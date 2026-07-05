<p align="center">
	<a href="https://unlimited.studio" target="_blank"><img src="https://unlimited.dev/us_white.png" width="280" style="display: inline-block; vertical-align: middle;"></a>
</p>

# SleekTime

A clean, minimal watchface for Garmin smartwatches with soft pastel color themes.

See [FEATURES.md](FEATURES.md) for the full feature list.

### Layouts

- **Orbit** - Three arc indicators around the edge that show progress towards your goals
- **Circles** - Five ring indicators: one large outer ring and four small ones around the date and time
- **(optional) Sleep Time** - A calm, minimal layout that activates during your configured sleep hours

### Color Themes

All themes use a black background with one soft accent color shared by the time, rings, and indicators:

- **Daisy** - white
- **Rose** - pastel pink
- **Lavender** - pastel purple
- **Marigold** - pastel gold
- **Bluebell** - pastel blue
- **Custom** - your own accent color from a 12-color palette

Colors can optionally dim during your sleep hours.

### Supported Data Fields

- Heartrate
- Battery (percent, or estimated days remaining)
- Calories
- Steps per Day
- Active Minutes per Week
- Floors Up / Down per Day
- Notifications
- Alarms
- Bluetooth connection status
- Body Battery
- Stress Level
- Weather Temperature
- Sunrise / Sunset
- Moon Phase
- Second Time Zone

Developed by [unlimited.studio](https://unlimited.studio) & captainscor.ch.

### Attributions

- Uses the [DINish Font](https://github.com/playbeing/dinish) for the date and time elements.
- Various icons used from and inspired by [The Noun Project](https://thenounproject.com/).
- This project has been forked from [Protomolecule](https://github.com/blotspot/garmin-watchface-protomolecule).

### Building & Installing

Requires the [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) (`monkeyc`/`monkeydo`
on your `PATH`) and a developer key. Device IDs: Venu 2s = `venu2s`, Fenix 6X Pro = `fenix6xpro`
(all supported devices are listed in `manifest.xml`).

```sh
# Build and run in the simulator
monkeyc -f monkey.jungle -d venu2s -o bin/sleektime.prg -y ~/.ssh/developer_key
monkeydo bin/sleektime.prg venu2s

# Sideload over USB: build for the device, then copy to the watch (mounts as GARMIN).
# Sideloaded apps have NO phone-settings screen — configure from the on-watch menu.
monkeyc -f monkey.jungle -d venu2s     -o bin/sleektime-venu2s.prg     -y ~/.ssh/developer_key
monkeyc -f monkey.jungle -d fenix6xpro -o bin/sleektime-fenix6xpro.prg -y ~/.ssh/developer_key
cp bin/sleektime-venu2s.prg     "/Volumes/GARMIN/GARMIN/APPS/"
cp bin/sleektime-fenix6xpro.prg "/Volumes/GARMIN/GARMIN/APPS/"

# Private beta: build a store package (.iq) from the beta manifest (separate app id).
# Upload at the developer portal and check "Beta App" to keep it unlisted.
monkeyc -e -f beta.jungle -o bin/SleekTime-beta.iq -y ~/.ssh/developer_key
```
