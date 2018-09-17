# DarkSkySensor

DarkSkySensor is a client for the [Dark Sky API](https://darksky.net), configured to be used from within the [Scenic](https://github.com/boydm/scenic) ecosystem. Having the Scenic framework already installed and running on your system is a requirement.

Also a requirement is having a Dark Sky API key. Go to the [DarkSky API website](https://darksky.net/dev) and sign up for one. There is a very generous free tier that should be sufficient for most needs.

Then add `dark_sky_sensor` to the dependencies in your `mix.exs` file.

```elixir
  defp deps do
    [
      { :dark_sky_sensor, git: "https://github.com/nerves-build/dark_sky_sensor.git"},
      ...
    ]
  end
```
### Basic Setup

Update your config for `:dark_sky_sensor`. Of the following only latitude, longitude and key must be set

```elixir
config :dark_sky_sensor, :settings,
  latitude: "40.9",
  longitude: "-73.6",
  key: "YOUR_SECRET_KEY",
  interval: 1000 * 60 * 30,
  auto_start: true,
```
In this setup the sensor will broadcast the following updates:

Name | Description
--- | ---
dark\_sky_currently | The data returned in the "currently" portion of the response
dark\_sky_daily | The data returned in the "daily" portion of the response

These channels update immediately upon launch, and then after the interval set in the configs.


### Advanced Setup

#### Multiple Remotes
You can specify multiple locations to poll by providing a named a map under the `remotes` key in the config. The map should consist of a key that will be used as the remote name, and a value that should be any config specific to that remote. Values not specified in the remote settings are inherited from the root level configs.

```elixir
config :dark_sky_sensor, :settings,
  interval: 1000 * 60 * 15,
  auto_start: true,
  key: "YOUR_SECRET_KEY",
  remotes: %{
    phoenix: %{
      latitude: "33.232635478117196",
      longitude: "-111.88057312851868"
	  interval: 1000 * 60 * 60,
    },
    edmonton: %{
      latitude: "53.46277435531115",
      longitude: "-113.42740005163068",
    },
    london: %{
      latitude: "51.52164770543298",
      longitude: "-0.11724604453058873",
	  interval: 1000 * 60 * 5,
      key: "OTHER_SECRET_KEY",
    }
  }
```

In this setup the sensor will broadcast the following updates:
dark\_sky\_daily\_edmonton, dark\_sky\_daily\_phoenix, dark\_sky\_daily\_london, dark\_sky\_currently\_edmonton, dark\_sky\_currently\_phoenix, dark\_sky\_currently\_london.

Corresponding to the response portions from each individual location

#### Configuration params

Scene | Default | Description
--- | --- | ---
name | "" | The remote name. Determines the broadcast channel names and allows for manipulating the remote during runtime
blocking | [:minutely, :hourly] | The portions of the DarkSky API data to omit from the request. [:currently, :daily, :minutely, :hourly] are the possible choices. The hourly and minutely portions can be large and slow to retrieve.
interval | 1000 * 60 * 15 (15 minutes) | milliseconds to wait between data requests
auto_start | true | Whether or not to start the polling on application launch. Currently theres no easy way to turn them on at runtime, so this should best stay true for now.
latitude | nil | latitude of the location to query for. Must be supplied
longitude |  nil | longitude of the location to query for. Must be supplied
key |  nil | secret key obtained earlier, provided by DarkSky


## Whats next?
 - Add runtime management of the remotes state.
 - Better docs
 - Better specs
 
I Hope this is of some use to someone, or some help to someone else! Feel free to enter any issues you may come across.

