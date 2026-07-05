# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SleekTime is a Garmin Connect IQ watchface written in Monkey C, forked from
[Protomolecule](https://github.com/blotspot/garmin-watchface-protomolecule). It targets round
watches only (see `manifest.xml` for the ~90 supported products) and ships two main designs
("Orbit" and "Circles") plus an optional sleep-time layout and an AMOLED burn-in-protection layout.

## Build & Run

There is no build script or test suite; this is a standard Connect IQ project built with the
Garmin Connect IQ SDK. `monkeyc`/`monkeydo`/`connectiq` are the SDK binaries — on this machine
they live under `~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk-version>/bin/` (not on
PATH), and the developer key is `~/.ssh/developer_key`. `monkey.jungle` points at `manifest.xml`;
`beta.jungle` points at `beta-manifest.xml`.

```sh
# Build and run in the simulator (start `connectiq` first)
monkeyc -f monkey.jungle -d venu2s -o bin/sleektime.prg -y ~/.ssh/developer_key
monkeydo bin/sleektime.prg venu2s

# Sideload over USB: build for the device, then copy the .prg into the watch's GARMIN/Apps folder.
# Sideloaded apps have NO phone-settings screen — every option must be reachable on-watch.
monkeyc -f monkey.jungle -d fenix6xpro -o bin/sleektime-fenix6xpro.prg -y ~/.ssh/developer_key
# If the watch mounts as a drive (watch USB Mode = "Garmin"/mass storage), just copy:
cp bin/sleektime-fenix6xpro.prg "/Volumes/GARMIN/GARMIN/APPS/"

# Private beta store package (.iq), built from the beta manifest (its own app id):
monkeyc -e -f beta.jungle -o bin/SleekTime-beta.iq -y ~/.ssh/developer_key
```

The VS Code "Monkey C" extension can be used instead (Build / Run in Simulator commands).

- Common device IDs: `venu2s` (360×360 AMOLED), `fenix6xpro` (280×280 MIP), `fenix7`. The Fenix
  6X is only ever `fenix6xpro` — there is no non-Pro 6X id. Full product list in `manifest.xml`.
- Sideloading on this Apple Silicon Mac: the Fenix 6X does **not** mount as `/Volumes/GARMIN`.
  In the watch's `Settings > System > USB Mode`, "Garmin"/mass-storage enumerates (`0x091e:0x0003`)
  but macOS never binds a disk to it (known Apple-Silicon xHCI + Garmin bulk-only-storage bug), and
  "MTP" mode isn't a mountable filesystem either. So the `cp` line above never finds the drive here.
  Working method: set USB Mode = **MTP**, then use **OpenMTP** (`brew install --cask openmtp`) to drag
  the built `.prg` into the watch's `GARMIN/Apps` folder. The `libmtp` CLI (`mtp-sendfile`) fails on
  Garmin with `get_suggested_storage_id(): could not get storage id from parent id` — use OpenMTP's
  GUI, not the CLI. After the copy, unplug the watch, then long-press MENU > Watch Face and pick
  SleekTime (sideloaded faces don't auto-activate).
- `manifest.xml` is the production manifest (~90 devices); `beta-manifest.xml` is a separate app
  id used for private beta-store uploads (check "Beta App" at upload to keep it unlisted).
- After changing a property's default in `properties.xml`, the simulator keeps the OLD value in
  `$TMPDIR/com.garmin.connectiq/GARMIN/APPS/SETTINGS/SLEEKTIME.SET` — delete that file to test
  fresh defaults.
- `Log.debug(...)` output only exists in debug builds: the `Log` module has `(:debug)` and
  `(:release)` variants, so release builds compile logging to a no-op.

## Architecture

**Entry points** — `source/SleekTimeApp.mc` (annotated `(:background)`) is the `AppBase`. It
returns `SleekTimeView` as the only view, registers background sleep/wake events handled by
`SleepModeServiceDelegate`, and returns the on-watch settings menu (`source/settingsMenu/`).

**Layout switching** — `SleekTimeView.chooseLayout()` is the central decision point. It picks one
of four layouts defined as XML in `resources/layouts/`, in priority order:
1. `SimpleWatchFace` (`simple-layout.xml`) — when the device requires burn-in protection and is in
   low-power mode
2. `WatchFaceSleep` (`layout-sleep.xml`) — when `Settings.isSleepTime` (driven by the user
   profile's sleep/wake times plus background sleep events)
3. `WatchFace` (`layout.xml`, Orbit) or `WatchFaceAlt` (`layout-alt.xml`, Circles) — per the
   `layout` setting (`LayoutId.ORBIT` / `LayoutId.CIRCLES`)

**Data field pipeline** — Layout XML instantiates drawable classes with a `fieldId` param
(constants in `FieldId`). All field drawables extend `DataFieldDrawable`
(`source/datafield/DataFieldDrawable.mc`), which on each draw asks
`DataFieldInfo.getInfoForField(fieldId)` for a `DataFieldProperties` (icon, text, progress). The
mapping from field *position* (FieldId) to field *content* (FieldType, e.g. HEART_RATE, STEPS)
lives in the Settings module. Concrete renderers: `OrbitDataField` (arc indicators),
`RingDataField` (circular indicators), `SecondaryDataField` (icon + text), `DateAndTime`.
`DataFieldIcons` maps field types to glyphs in the custom icon font. Only the heart-rate field
supports 1-Hz partial updates (`onPartialUpdate`, throttled to every 10th call).

**Settings** — `source/Settings.mc` is a module-level cache over `Application.Properties`. Always
go through `Settings.get`/`Settings.set`, not `Properties` directly: `set()` remaps logical keys
("outer", "upper1", "lower1", "middle1"...) onto *different* property names depending on the
active layout (e.g. "outer" → `outerOrbitDataField` or `outerDataField`), so Orbit and Circles
keep independent field assignments. Settings can change from two directions: the on-watch menu
(`source/settingsMenu/`) and Connect IQ phone-app settings (`resources/settings/settings.xml` +
`properties.xml`), which arrive via `onSettingsChanged()`. New properties need matching defaults
in `Settings.loadProperties()` (which validates types and falls back to defaults).

**Themes** — `source/DrawHelper.mc` defines the `Color` module: one flat array of 8 colors per
theme, indexed by `themeColor(sectionId)` using the `theme` setting. Adding a theme means
appending an 8-color block there and adding the option to the settings resources.

**Per-resolution resources** — `resources/` holds shared layouts/strings/settings;
`resources-round-<WxH>/fonts/` (218×218 through 454×454) holds pre-rendered bitmap fonts
(`.fnt`/`.png`) for the custom Expanse-style typeface, using identical font ids (`HoursFont`,
`MinutesFont`, `DateFont`, `IconsFont`, ...) at resolution-appropriate sizes. Supporting a new
device means adding it to `manifest.xml` and ensuring a resource folder exists for its resolution.
`resources-deu/` holds German strings; positions in layout XML are fractions of `dc.getWidth()`/
`dc.getHeight()`, so layouts scale without per-device variants.
