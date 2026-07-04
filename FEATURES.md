# SleekTime — Feature List

Canonical feature reference for SleekTime. Use it as the source for the Garmin store
listing, the README feature section, and release notes. Keep it in sync when features change.

**Tagline:** A clean, minimal watchface for Garmin smartwatches with soft pastel themes and
a fully configurable set of data fields.

---

## Layouts

- **Orbit** — three arc indicators sweeping the edge of the screen, showing progress toward
  your goals, with three smaller data fields by the time.
- **Circles** — five ring indicators (one large outer ring plus four small rings) around the
  date and time, for up to eight data fields.
- **Sleep** — a calm, minimal layout that activates automatically during your configured sleep
  hours, showing only the fields you choose.
- **Always-On / burn-in protection** — a simplified, position-shifting time layout on AMOLED
  watches that require it, to protect the screen in low-power mode.

## Themes & Personalization

- **Five pastel flower themes**, each a single soft accent color on a black background shared by
  the time, rings, and every indicator so the face reads as one cohesive color:
  **Daisy** (white), **Rose** (pink), **Lavender** (purple), **Marigold** (gold),
  **Bluebell** (blue).
- **Custom theme** with your own accent color chosen from a 12-color palette: White, Pink,
  Coral, Peach, Gold, Mint, Teal, Sky, Blue, Lavender, Purple, Magenta.
- **Night dimming** — optionally dim all colors during your sleep hours for a softer look in bed.

## Data Fields

Every field slot is configurable. Progress rings and arcs use goal-based fields; the text
fields around the clock (and the sleep layout) can show any of the following:

- **Heart Rate** (with optional 10-second live updates)
- **Battery** — as a percentage or estimated days remaining
- **Steps** (per day, toward your goal)
- **Calories** (toward a configurable daily goal)
- **Active Minutes** (per week, toward your goal)
- **Floors Climbed / Descended** (per day)
- **Body Battery**
- **Stress Level**
- **Notifications**
- **Alarms**
- **Bluetooth connection status**
- **Weather Temperature** (°C or °F, following your watch's unit setting)
- **Sunrise / Sunset** — automatically shows the next event (sunrise before dawn, sunset during
  the day, tomorrow's sunrise after dark)
- **Moon Phase** — the current lunar phase drawn as a shaped icon, with percent illuminated
- **Second Time Zone** — a second time from a configurable UTC offset
- **Empty** — leave any slot blank for a cleaner face

## Time & Date

- 12- or 24-hour time, following your watch's setting.
- Optional **AM / PM** indicator on 12-hour time.
- Optional **seconds** display.
- Date line in the watchface font, or your watch's **system font** (for full special-character
  and localization support).

## Configuration

- Configure everything **on the watch** through the settings menu, or from the **Garmin Connect
  IQ app** on your phone.
- Independent field assignments per layout — Orbit and Circles remember their own setups.
- Adjustable **daily calories goal** and **low-battery icon threshold**.
- Second-time-zone offset, accent color, sleep-layout fields, and night dimming are all
  user-settable.

## Compatibility

- Over 90 round Garmin devices, including Venu, Vivoactive, Forerunner, Fenix, Epix, MARQ,
  Descent, and D2 series (MIP and AMOLED displays).
- Available in **English** and **German**.

---

## Enhancements in 1.1.0

- New pastel flower themes replacing the previous palettes, plus a **Custom accent color**.
- New data fields: **Weather Temperature**, **Sunrise / Sunset**, **Moon Phase**,
  **Second Time Zone**, and **Battery in days**.
- **Configurable sleep layout** (previously fixed) with **night dimming**.
- Refreshed date/time typography with proper glyphs.
