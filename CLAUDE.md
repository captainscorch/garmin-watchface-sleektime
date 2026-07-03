# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SleekTime is a Garmin Connect IQ watchface written in Monkey C, forked from
[Protomolecule](https://github.com/blotspot/garmin-watchface-protomolecule). It targets round
watches only (see `manifest.xml` for the ~90 supported products) and ships two main designs
("Orbit" and "Circles") plus an optional sleep-time layout and an AMOLED burn-in-protection layout.

## Build & Run

There is no build script or test suite; this is a standard Connect IQ project built with the
Garmin Connect IQ SDK (`monkey.jungle` only points at `manifest.xml`).

```sh
# Build (requires Connect IQ SDK on PATH and a developer key)
monkeyc -f monkey.jungle -d fenix7 -o bin/sleektime.prg -y <developer_key>

# Run in the simulator (start `connectiq` first)
monkeydo bin/sleektime.prg fenix7
```

The VS Code "Monkey C" extension can be used instead (Build / Run in Simulator commands).

- `manifest.xml` is the production manifest; `beta-manifest.xml` is a separate app id (single
  device) used for beta-store uploads.
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
