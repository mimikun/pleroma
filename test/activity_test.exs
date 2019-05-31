# Pleroma: A lightweight social networking server
# Copyright © 2017-2018 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.ActivityTest do
  use Pleroma.DataCase
  alias Pleroma.Activity
  alias Pleroma.Bookmark
  alias Pleroma.ThreadMute
  import Pleroma.Factory

  test "returns an activity by it's AP id" do
    activity = insert(:note_activity)
    found_activity = Activity.get_by_ap_id(activity.data["id"])

    assert activity == found_activity
  end

  test "returns activities by it's objects AP ids" do
    activity = insert(:note_activity)
    [found_activity] = Activity.get_all_create_by_object_ap_id(activity.data["object"]["id"])

    assert activity == found_activity
  end

  test "returns the activity that created an object" do
    activity = insert(:note_activity)

    found_activity = Activity.get_create_by_object_ap_id(activity.data["object"]["id"])

    assert activity == found_activity
  end

  test "preloading a bookmark" do
    user = insert(:user)
    user2 = insert(:user)
    user3 = insert(:user)
    activity = insert(:note_activity)
    {:ok, _bookmark} = Bookmark.create(user.id, activity.id)
    {:ok, _bookmark2} = Bookmark.create(user2.id, activity.id)
    {:ok, bookmark3} = Bookmark.create(user3.id, activity.id)

    queried_activity =
      Ecto.Query.from(Pleroma.Activity)
      |> Activity.with_preloaded_bookmark(user3)
      |> Repo.one()

    assert queried_activity.bookmark == bookmark3
  end

  test "setting thread_muted?" do
    activity = insert(:note_activity)
    user = insert(:user)
    annoyed_user = insert(:user)
    {:ok, _} = ThreadMute.add_mute(annoyed_user.id, activity.data["context"])

    activity_with_unset_thread_muted_field =
      Ecto.Query.from(Activity)
      |> Repo.one()

    activity_for_user =
      Ecto.Query.from(Activity)
      |> Activity.with_set_thread_muted_field(user)
      |> Repo.one()

    activity_for_annoyed_user =
      Ecto.Query.from(Activity)
      |> Activity.with_set_thread_muted_field(annoyed_user)
      |> Repo.one()

    assert activity_with_unset_thread_muted_field.thread_muted? == nil
    assert activity_for_user.thread_muted? == false
    assert activity_for_annoyed_user.thread_muted? == true
  end

  describe "getting a bookmark" do
    test "when association is loaded" do
      user = insert(:user)
      activity = insert(:note_activity)
      {:ok, bookmark} = Bookmark.create(user.id, activity.id)

      queried_activity =
        Ecto.Query.from(Pleroma.Activity)
        |> Activity.with_preloaded_bookmark(user)
        |> Repo.one()

      assert Activity.get_bookmark(queried_activity, user) == bookmark
    end

    test "when association is not loaded" do
      user = insert(:user)
      activity = insert(:note_activity)
      {:ok, bookmark} = Bookmark.create(user.id, activity.id)

      queried_activity =
        Ecto.Query.from(Pleroma.Activity)
        |> Repo.one()

      assert Activity.get_bookmark(queried_activity, user) == bookmark
    end
  end

  describe "search" do
    setup do
      Tesla.Mock.mock_global(fn env -> apply(HttpRequestMock, :request, [env]) end)

      user = insert(:user)

      params = %{
        "@context" => "https://www.w3.org/ns/activitystreams",
        "actor" => "http://mastodon.example.org/users/admin",
        "type" => "Create",
        "id" => "http://mastodon.example.org/users/admin/activities/1",
        "object" => %{
          "type" => "Note",
          "content" => "find me!",
          "id" => "http://mastodon.example.org/users/admin/objects/1",
          "attributedTo" => "http://mastodon.example.org/users/admin"
        },
        "to" => ["https://www.w3.org/ns/activitystreams#Public"]
      }

      {:ok, local_activity} = Pleroma.Web.CommonAPI.post(user, %{"status" => "find me!"})
      {:ok, remote_activity} = Pleroma.Web.Federator.incoming_ap_doc(params)
      %{local_activity: local_activity, remote_activity: remote_activity, user: user}
    end

    test "find local and remote statuses for authenticated users", %{
      local_activity: local_activity,
      remote_activity: remote_activity,
      user: user
    } do
      assert [^remote_activity, ^local_activity] = Activity.search(user, "find me")
    end

    test "find only local statuses for unauthenticated users", %{local_activity: local_activity} do
      assert [^local_activity] = Activity.search(nil, "find me")
    end
  end
end
