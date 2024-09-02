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

  const _COLORS as Array<Number> = [
    /* VENUS */
    Graphics.COLOR_WHITE, // TEXT_ACTIVE
    Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
    Graphics.COLOR_YELLOW, // PRIMARY
    0xe7e2de, // SECONDARY_1
    Graphics.COLOR_RED, // SECONDARY_2
    Graphics.COLOR_BLACK, // BACKGROUND
    Graphics.COLOR_WHITE, // FOREGROUND
    Graphics.COLOR_DK_GRAY, // INACTIVE,
    /* EXPANSE */
    Graphics.COLOR_WHITE, // TEXT_ACTIVE
    Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
    Graphics.COLOR_YELLOW, // PRIMARY
    Graphics.COLOR_BLUE, // SECONDARY_1
    Graphics.COLOR_RED, // SECONDARY_2
    Graphics.COLOR_BLACK, // BACKGROUND
    Graphics.COLOR_WHITE, // FOREGROUND
    Graphics.COLOR_DK_GRAY, // INACTIVE,
    /* EARTH */
    Graphics.COLOR_WHITE, // TEXT_ACTIVE
    Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
    0x0055aa, // PRIMARY
    Graphics.COLOR_BLUE, // SECONDARY_1
    Graphics.COLOR_BLUE, // SECONDARY_2
    Graphics.COLOR_BLACK, // BACKGROUND
    Graphics.COLOR_WHITE, // FOREGROUND
    Graphics.COLOR_DK_GRAY, // INACTIVE
    /* MARS */
    Graphics.COLOR_WHITE, // TEXT_ACTIVE
    Graphics.COLOR_LT_GRAY, // TEXT_INACTIVE
    Graphics.COLOR_RED, // PRIMARY
    Graphics.COLOR_ORANGE, // SECONDARY_1
    Graphics.COLOR_ORANGE, // SECONDARY_2
    Graphics.COLOR_BLACK, // BACKGROUND
    Graphics.COLOR_WHITE, // FOREGROUND
    Graphics.COLOR_DK_GRAY, // INACTIVE
  ];
}

function themeColor(sectionId as Number) as Number {
  var theme = Settings.get("theme") as Number;
  return Color._COLORS[theme * Color.MAX_COLOR_ID + sectionId];
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
