defmodule Pleroma.Web.RelMeTest do
  use ExUnit.Case, async: true

  setup do
    Tesla.Mock.mock(fn
      %{
        method: :get,
        url: "http://example.com/rel_me/anchor"
      } ->
        %Tesla.Env{status: 200, body: File.read!("test/fixtures/rel_me_anchor.html")}

      %{
        method: :get,
        url: "http://example.com/rel_me/anchor_nofollow"
      } ->
        %Tesla.Env{status: 200, body: File.read!("test/fixtures/rel_me_anchor_nofollow.html")}

      %{
        method: :get,
        url: "http://example.com/rel_me/link"
      } ->
        %Tesla.Env{status: 200, body: File.read!("test/fixtures/rel_me_link.html")}

      %{
        method: :get,
        url: "http://example.com/rel_me/null"
      } ->
        %Tesla.Env{status: 200, body: File.read!("test/fixtures/rel_me_null.html")}
    end)

    :ok
  end

  test "parse/1" do
    hrefs = ["https://social.example.org/users/lain"]

    assert Pleroma.Web.RelMe.parse("http://example.com/rel_me/null") == {:ok, []}
    assert {:error, _} = Pleroma.Web.RelMe.parse("http://example.com/rel_me/error")

    assert Pleroma.Web.RelMe.parse("http://example.com/rel_me/link") == {:ok, hrefs}
    assert Pleroma.Web.RelMe.parse("http://example.com/rel_me/anchor") == {:ok, hrefs}
    assert Pleroma.Web.RelMe.parse("http://example.com/rel_me/anchor_nofollow") == {:ok, hrefs}
  end

  test "maybe_put_rel_me/2" do
    profile_urls = ["https://social.example.org/users/lain"]
    attr = "me"
    fallback = nil

    assert Pleroma.Web.RelMe.maybe_put_rel_me("http://example.com/rel_me/null", profile_urls) ==
             fallback

    assert Pleroma.Web.RelMe.maybe_put_rel_me("http://example.com/rel_me/error", profile_urls) ==
             fallback

    assert Pleroma.Web.RelMe.maybe_put_rel_me("http://example.com/rel_me/anchor", profile_urls) ==
             attr

    assert Pleroma.Web.RelMe.maybe_put_rel_me(
             "http://example.com/rel_me/anchor_nofollow",
             profile_urls
           ) == attr

    assert Pleroma.Web.RelMe.maybe_put_rel_me("http://example.com/rel_me/link", profile_urls) ==
             attr
  end
end
