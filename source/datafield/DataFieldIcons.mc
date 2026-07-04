import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Graphics;
import Toybox.Application;
import Toybox.Lang;

module DataFieldIcons {
  //! dc => Drawable object
  //! x  => x-Axis center point
  //! y  => y-Axis center point
  //! size    => max. height & width of the object
  //! penSize => stroke width for unfilled areas
  //! value   => value of data field

  function drawBattery(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y + size * 0.1, "m");
  }

  function drawBatteryFull(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y + size * 0.1, "h");
  }

  function drawBatteryLow(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y + size * 0.1, "k");
  }

  function drawBatteryLoading(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y + size * 0.1, "l");
  }

  function drawSteps(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "s");
  }

  function drawCalories(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "c");
  }

  function drawActiveMinutes(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "t");
  }

  function drawNotificationInactive(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y + size * 0.1, "N");
  }

  function drawNotificationActive(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y + size * 0.1, "n");
  }

  function drawHeartRate(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "p");
  }

  function drawNoHeartRate(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "P");
  }

  function drawFloorsUp(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "F");
  }

  function drawFloorsDown(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "f");
  }

  function drawBluetoothConnection(dc, x, y, size, penSize, value) as Void {
    dc.setColor(themeColor(Color.TEXT_ACTIVE), Graphics.COLOR_TRANSPARENT);
    textIcon(dc, x, y, "b");
  }

  function drawNoBluetoothConnection(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "B");
  }

  function drawAlarms(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "a");
  }

  function drawNoAlarms(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "A");
  }

  function drawSeconds(dc, x, y, size, penSize, value) as Void {
    dc.setColor(themeColor(Color.TEXT_ACTIVE), Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, y - size * 0.1, Settings.resource(Rez.Fonts.MeridiemFont), value, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  function drawBodyBattery(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "y");
  }

  function drawStressLevel(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "z");
  }

  function drawTemperature(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "D");
  }

  function drawSunrise(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "U");
  }

  function drawSunset(dc, x, y, size, penSize, value) as Void {
    textIcon(dc, x, y, "d");
  }

  // Small clock face for the second-time-zone field.
  function drawSecondTime(dc, x, y, size, penSize, value) as Void {
    var r = size * 0.4;
    setAntiAlias(dc, true);
    dc.setPenWidth(penSize);
    dc.drawCircle(x, y, r);
    dc.drawLine(x, y, x, y - r * 0.55); // minute hand (up)
    dc.drawLine(x, y, x + r * 0.5, y + r * 0.15); // hour hand
    dc.setPenWidth(1);
    setAntiAlias(dc, false);
  }

  function drawMoonNew(dc, x, y, size, penSize, value) as Void {
    drawMoon(dc, x, y, size, 0.0, true);
  }
  function drawMoonWaxingCrescent(dc, x, y, size, penSize, value) as Void {
    drawMoon(dc, x, y, size, 0.25, true);
  }
  function drawMoonFirstQuarter(dc, x, y, size, penSize, value) as Void {
    drawMoon(dc, x, y, size, 0.5, true);
  }
  function drawMoonWaxingGibbous(dc, x, y, size, penSize, value) as Void {
    drawMoon(dc, x, y, size, 0.75, true);
  }
  function drawMoonFull(dc, x, y, size, penSize, value) as Void {
    drawMoon(dc, x, y, size, 1.0, true);
  }
  function drawMoonWaningGibbous(dc, x, y, size, penSize, value) as Void {
    drawMoon(dc, x, y, size, 0.75, false);
  }
  function drawMoonLastQuarter(dc, x, y, size, penSize, value) as Void {
    drawMoon(dc, x, y, size, 0.5, false);
  }
  function drawMoonWaningCrescent(dc, x, y, size, penSize, value) as Void {
    drawMoon(dc, x, y, size, 0.25, false);
  }

  // Draw a moon phase: a dim full disk with the lit fraction filled in the
  // accent color. The terminator is approximated by a polygon so it works on
  // devices without an ellipse primitive. waxing => lit on the right.
  function drawMoon(dc, x, y, size, litFraction, waxing) as Void {
    var r = size * 0.42;
    setAntiAlias(dc, true);

    dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(x, y, r);

    if (litFraction <= 0.02) {
      setAntiAlias(dc, false);
      return; // new moon: just the dim disk
    }

    dc.setColor(themeColor(Color.TEXT_ACTIVE), Graphics.COLOR_TRANSPARENT);
    if (litFraction >= 0.98) {
      dc.fillCircle(x, y, r); // full moon
      setAntiAlias(dc, false);
      return;
    }

    var dir = waxing ? 1 : -1;
    var t = 1.0 - 2.0 * litFraction; // terminator bulge (+1 new .. -1 full)
    var n = 18;
    var pts = [];
    var i;
    var ang;
    for (i = 0; i <= n; i++) {
      ang = -Math.PI / 2 + Math.PI * i / n;
      pts.add([x + dir * r * Math.cos(ang), y + r * Math.sin(ang)]); // lit limb
    }
    for (i = n; i >= 0; i--) {
      ang = -Math.PI / 2 + Math.PI * i / n;
      pts.add([x + dir * t * r * Math.cos(ang), y + r * Math.sin(ang)]); // terminator
    }
    dc.fillPolygon(pts);
    setAntiAlias(dc, false);
  }

  function textIcon(dc, x, y, string) as Void {
    var font = Settings.resource(Rez.Fonts.IconsFont);
    dc.drawText(x, y, font, string, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  function _getBuffer(size) as Lang.Double {
    return size / 10.0;
  }
}
