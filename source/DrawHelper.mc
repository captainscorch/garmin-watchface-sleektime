import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Application;

module Color {
  const TEXT_ACTIVE as Number = 0;
  const TEXT_INACTIVE as Number = 1;
  const PRIMARY as Number = 2;
  const SECONDARY_1 as Number = 3;
  const SECONDARY_2 as Number = 4;
  const BACKGROUND as Number = 5;
  const FOREGROUND as Number = 6;
  const INACTIVE as Number = 7;

  const MAX_COLOR_ID as Number = 8;

  // Every theme: black background, one accent shared by the time font,
  // the outer ring and all indicators, so the face reads as one color.
  const _COLORS as Array<Number> = [
    /* DAISY - white */
    Graphics.COLOR_WHITE, // TEXT_ACTIVE
    Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
    Graphics.COLOR_WHITE, // PRIMARY
    Graphics.COLOR_WHITE, // SECONDARY_1
    Graphics.COLOR_WHITE, // SECONDARY_2
    Graphics.COLOR_BLACK, // BACKGROUND
    Graphics.COLOR_WHITE, // FOREGROUND
    Graphics.COLOR_DK_GRAY, // INACTIVE
    /* ROSE - pastel pink */
    0xffb0c8, // TEXT_ACTIVE
    Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
    0xffb0c8, // PRIMARY
    0xffb0c8, // SECONDARY_1
    0xffb0c8, // SECONDARY_2
    Graphics.COLOR_BLACK, // BACKGROUND
    0xffb0c8, // FOREGROUND
    Graphics.COLOR_DK_GRAY, // INACTIVE
    /* LAVENDER - pastel purple */
    0xc9b3ff, // TEXT_ACTIVE
    Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
    0xc9b3ff, // PRIMARY
    0xc9b3ff, // SECONDARY_1
    0xc9b3ff, // SECONDARY_2
    Graphics.COLOR_BLACK, // BACKGROUND
    0xc9b3ff, // FOREGROUND
    Graphics.COLOR_DK_GRAY, // INACTIVE
    /* MARIGOLD - pastel gold */
    0xffd08a, // TEXT_ACTIVE
    Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
    0xffd08a, // PRIMARY
    0xffd08a, // SECONDARY_1
    0xffd08a, // SECONDARY_2
    Graphics.COLOR_BLACK, // BACKGROUND
    0xffd08a, // FOREGROUND
    Graphics.COLOR_DK_GRAY, // INACTIVE
    /* BLUEBELL - pastel blue */
    0xa3c7ff, // TEXT_ACTIVE
    Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
    0xa3c7ff, // PRIMARY
    0xa3c7ff, // SECONDARY_1
    0xa3c7ff, // SECONDARY_2
    Graphics.COLOR_BLACK, // BACKGROUND
    0xa3c7ff, // FOREGROUND
    Graphics.COLOR_DK_GRAY, // INACTIVE
  ];

  // Number of fixed themes in _COLORS; theme ids >= this select the Custom
  // theme, whose accent comes from ACCENT_PALETTE[accentColor].
  const FIXED_THEMES as Number = 5;

  // Accent choices for the Custom theme (index stored in the accentColor
  // setting). Order must match the accentColor list in the settings/strings.
  const ACCENT_PALETTE as Array<Number> = [
    Graphics.COLOR_WHITE, // White
    0xff9ec8, // Pink
    0xff8a8a, // Coral
    0xffb482, // Peach
    0xffd08a, // Gold
    0x9ee8c0, // Mint
    0x5ac8c8, // Teal
    0xa3c7ff, // Sky
    0x6aa0ff, // Blue
    0xc9b3ff, // Lavender
    0xb07aff, // Purple
    0xff7ad0, // Magenta
  ];
}

function themeColor(sectionId as Number) as Number {
  var theme = Settings.get("theme") as Number;
  var color;
  if (theme >= Color.FIXED_THEMES) {
    // Custom theme: black background, gray inactive tones, chosen accent
    // everywhere else.
    if (sectionId == Color.BACKGROUND) {
      color = Graphics.COLOR_BLACK;
    } else if (sectionId == Color.TEXT_INACTIVE) {
      color = Graphics.COLOR_LT_GRAY;
    } else if (sectionId == Color.INACTIVE) {
      color = Graphics.COLOR_DK_GRAY;
    } else {
      var idx = Settings.get("accentColor") as Number;
      if (idx < 0 || idx >= Color.ACCENT_PALETTE.size()) {
        idx = 0;
      }
      color = Color.ACCENT_PALETTE[idx];
    }
  } else {
    color = Color._COLORS[theme * Color.MAX_COLOR_ID + sectionId];
  }

  if (sectionId != Color.BACKGROUND && Settings.isSleepHours && Settings.get("sleepDimColors")) {
    // night dimming: halve each RGB channel, keeping the hue
    return (color >> 1) & 0x7f7f7f;
  }
  return color;
}

function setAntiAlias(dc, enabled as Boolean) as Void {
  if (Graphics.Dc has :setAntiAlias) {
    dc.setAntiAlias(enabled);
  }
}

function clearClip(dc) as Void {
  if (Graphics.Dc has :clearClip) {
    dc.clearClip();
  }
}
