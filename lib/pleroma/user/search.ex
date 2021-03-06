# Pleroma: A lightweight social networking server
# Copyright © 2017-2019 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.User.Search do
  alias Pleroma.Repo
  alias Pleroma.User
  import Ecto.Query

  @similarity_threshold 0.25
  @limit 20

  def search(query_string, opts \\ []) do
    resolve = Keyword.get(opts, :resolve, false)
    following = Keyword.get(opts, :following, false)
    result_limit = Keyword.get(opts, :limit, @limit)
    offset = Keyword.get(opts, :offset, 0)

    for_user = Keyword.get(opts, :for_user)

    # Strip the beginning @ off if there is a query
    query_string = String.trim_leading(query_string, "@")

    maybe_resolve(resolve, for_user, query_string)

    {:ok, results} =
      Repo.transaction(fn ->
        Ecto.Adapters.SQL.query(
          Repo,
          "select set_limit(#{@similarity_threshold})",
          []
        )

        query_string
        |> search_query(for_user, following)
        |> paginate(result_limit, offset)
        |> Repo.all()
      end)

    results
  end

  defp search_query(query_string, for_user, following) do
    for_user
    |> base_query(following)
    |> search_subqueries(query_string)
    |> union_subqueries
    |> distinct_query()
    |> boost_search_rank_query(for_user)
    |> subquery()
    |> order_by(desc: :search_rank)
    |> maybe_restrict_local(for_user)
  end

  defp base_query(_user, false), do: User
  defp base_query(user, true), do: User.get_followers_query(user)

  defp paginate(query, limit, offset) do
    from(q in query, limit: ^limit, offset: ^offset)
  end

  defp union_subqueries({fts_subquery, trigram_subquery}) do
    from(s in trigram_subquery, union_all: ^fts_subquery)
  end

  defp search_subqueries(base_query, query_string) do
    {
      fts_search_subquery(base_query, query_string),
      trigram_search_subquery(base_query, query_string)
    }
  end

  defp distinct_query(q) do
    from(s in subquery(q), order_by: s.search_type, distinct: s.id)
  end

  defp maybe_resolve(true, user, query) do
    case {limit(), user} do
      {:all, _} -> :noop
      {:unauthenticated, %User{}} -> User.get_or_fetch(query)
      {:unauthenticated, _} -> :noop
      {false, _} -> User.get_or_fetch(query)
    end
  end

  defp maybe_resolve(_, _, _), do: :noop

  defp maybe_restrict_local(q, user) do
    case {limit(), user} do
      {:all, _} -> restrict_local(q)
      {:unauthenticated, %User{}} -> q
      {:unauthenticated, _} -> restrict_local(q)
      {false, _} -> q
    end
  end

  defp limit, do: Pleroma.Config.get([:instance, :limit_to_local_content], :unauthenticated)

  defp restrict_local(q), do: where(q, [u], u.local == true)

  defp boost_search_rank_query(query, nil), do: query

  defp boost_search_rank_query(query, for_user) do
    friends_ids = User.get_friends_ids(for_user)
    followers_ids = User.get_followers_ids(for_user)

    from(u in subquery(query),
      select_merge: %{
        search_rank:
          fragment(
            """
             CASE WHEN (?) THEN 0.5 + (?) * 1.3
             WHEN (?) THEN 0.5 + (?) * 1.2
             WHEN (?) THEN (?) * 1.1
             ELSE (?) END
            """,
            u.id in ^friends_ids and u.id in ^followers_ids,
            u.search_rank,
            u.id in ^friends_ids,
            u.search_rank,
            u.id in ^followers_ids,
            u.search_rank,
            u.search_rank
          )
      }
    )
  end

  @spec fts_search_subquery(User.t() | Ecto.Query.t(), String.t()) :: Ecto.Query.t()
  defp fts_search_subquery(query, term) do
    processed_query =
      term
      |> String.replace(~r/\W+/, " ")
      |> String.trim()
      |> String.split()
      |> Enum.map(&(&1 <> ":*"))
      |> Enum.join(" | ")

    from(
      u in query,
      select_merge: %{
        search_type: ^0,
        search_rank:
          fragment(
            """
            ts_rank_cd(
              setweight(to_tsvector('simple', regexp_replace(?, '\\W', ' ', 'g')), 'A') ||
              setweight(to_tsvector('simple', regexp_replace(coalesce(?, ''), '\\W', ' ', 'g')), 'B'),
              to_tsquery('simple', ?),
              32
            )
            """,
            u.nickname,
            u.name,
            ^processed_query
          )
      },
      where:
        fragment(
          """
            (setweight(to_tsvector('simple', regexp_replace(?, '\\W', ' ', 'g')), 'A') ||
            setweight(to_tsvector('simple', regexp_replace(coalesce(?, ''), '\\W', ' ', 'g')), 'B')) @@ to_tsquery('simple', ?)
          """,
          u.nickname,
          u.name,
          ^processed_query
        )
    )
    |> User.restrict_deactivated()
  end

  @spec trigram_search_subquery(User.t() | Ecto.Query.t(), String.t()) :: Ecto.Query.t()
  defp trigram_search_subquery(query, term) do
    from(
      u in query,
      select_merge: %{
        # ^1 gives 'Postgrex expected a binary, got 1' for some weird reason
        search_type: fragment("?", 1),
        search_rank:
          fragment(
            "similarity(?, trim(? || ' ' || coalesce(?, '')))",
            ^term,
            u.nickname,
            u.name
          )
      },
      where: fragment("trim(? || ' ' || coalesce(?, '')) % ?", u.nickname, u.name, ^term)
    )
    |> User.restrict_deactivated()
  end
end
