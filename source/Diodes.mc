import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

const DIODE_WIDTH = 30;
const DIODE_HEIGHT = 50;
const DIODE_SLANT = 6;

const DIODE_GAP_X = 5;
const DIODE_GAP_Y = 5;

const DIODES_TOTAL_HEIGHT = DIODE_HEIGHT + DIODE_GAP_Y;

const HOUR_DIODE_COUNT = 5;
const HOUR_TOTAL_WIDTH = (DIODE_WIDTH * HOUR_DIODE_COUNT);

const MINUTE_DIODE_COUNT = 6;
const MINUTE_TOTAL_WIDTH = (DIODE_WIDTH * MINUTE_DIODE_COUNT);

class Diodes extends WatchUi.Drawable {

  function initialize() {
      Drawable.initialize({ :identifier => "Diodes" });
  }

  function draw(dc as Dc) as Void {
      var clockTime = System.getClockTime();
      var startY = (dc.getHeight() / 2) - (DIODES_TOTAL_HEIGHT * 0.75);
      drawDiodes(dc, Properties.getValue("HourDiodesColor") as Number, clockTime.hour, 5, (dc.getWidth() / 2) - (HOUR_TOTAL_WIDTH / 2), startY);
      drawDiodes(dc, Properties.getValue("MinuteDiodesColor") as Number, clockTime.min, 6, (dc.getWidth() / 2) - (MINUTE_TOTAL_WIDTH / 2), startY + DIODE_HEIGHT + DIODE_GAP_Y);
  }

  hidden function drawDiodes(dc as Dc, onColor, number as Lang.Number, pad as Lang.Number, x, y) as Void {
      var n = Math.pow(2, pad - 1).toNumber();
      while (true) {
          var halfHeight = DIODE_HEIGHT / 2;
          var halfWidth = DIODE_WIDTH / 2;
          var heightSlanted = halfHeight - DIODE_SLANT;
          var pts = [
              [x - halfWidth, y - heightSlanted],
              [x, y - halfHeight],
              [x + halfWidth, y - heightSlanted],
              [x + halfWidth, y + heightSlanted],
              [x, y + halfHeight],
              [x - halfWidth, y + heightSlanted],
          ];

          var on = number & n;
          if (on > 0) {
              dc.setColor(onColor, Graphics.COLOR_TRANSPARENT);
              dc.setAntiAlias(true);
              dc.fillPolygon(pts);
              dc.setAntiAlias(false);
          } else {
              dc.setPenWidth(1);
              dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);

              dc.drawLine(pts[3][0], pts[3][1], pts[4][0], pts[4][1]);
              dc.drawLine(pts[4][0], pts[4][1], pts[5][0], pts[5][1]);
              dc.drawLine(pts[5][0], pts[5][1], pts[0][0], pts[0][1]);
          }

          if (n == 1) {
              break;
          }

          x = x + DIODE_WIDTH + DIODE_GAP_X;
          n = n / 2;
      }
  }
}