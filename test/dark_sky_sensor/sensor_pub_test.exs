defmodule DarkSkySensor.SensorPubTest do
  use ExUnit.Case

  alias DarkSkySensor.{Remote, SensorPub}

  setup do
    %{
      remote: %Remote{name: "a_name"}
    }
  end

  describe "setup_context" do
    test "it adds registered_names to the data", %{remote: remote} do
      subject = SensorPub.setup_context(remote)
      assert Enum.count(subject.registered_names) == 2
    end

    test "registered_names contain the name and query", %{remote: remote} do
      subject = SensorPub.setup_context(remote)

      assert subject.registered_names[:currently] == :dark_sky_currently_a_name
      assert subject.registered_names[:daily] == :dark_sky_daily_a_name
    end

    test "registered_names are based on queries", %{remote: remote} do
      subject = SensorPub.setup_context(%{remote | blocking: [:minutely, :hourly, :daily]})

      assert subject.registered_names[:currently] == :dark_sky_currently_a_name
      assert Enum.count(subject.registered_names) == 1
    end
  end
end
