import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

enum DataType {
    DATE,
    HEART_RATE,
    ELEVATION,
    STEPS
}

class DataLabel extends WatchUi.Drawable {
    private var _x as Number;
    private var _y as Number;
    private var _type as DataType;
    private var _font = Application.loadResource(Rez.Fonts.retro) as FontReference;
    private var _icon as BitmapType?;
    private var _iconMarginRight as Number = 20;

    function initialize(params as { :x as Number, :y as Number, :type as DataType }) {
        Drawable.initialize(params);
        _x = params[:x];
        _y = params[:y];
        _type = params[:type];

        switch (_type) {
        case DATE:
            _icon = Application.loadResource(Rez.Drawables.calendarIcon);
            break;

        case HEART_RATE:
            _icon = Application.loadResource(Rez.Drawables.heartIcon);
            break;

        case ELEVATION:
            _icon = Application.loadResource(Rez.Drawables.elevationIcon);
            break;

        case STEPS:
            _icon = Application.loadResource(Rez.Drawables.stepsIcon);
            break;
        }
    }

    function draw(dc as Dc) as Void {
        dc.setColor(Properties.getValue("ForegroundColor") as Number, Graphics.COLOR_TRANSPARENT);
        drawIcon(dc);

        var text = getText();
        dc.drawText(_x + _iconMarginRight, _y, _font, text, Graphics.TEXT_JUSTIFY_LEFT);
    }

    hidden function drawIcon(dc as Dc) as Void {
      if (_icon != null) {
        dc.drawBitmap(_x, _y + 1, _icon);
      }
    }

    hidden function getText() as String {
        switch (_type) {
        case DATE: {
            var now = Time.now();
            var today = Time.Gregorian.info(now, Time.FORMAT_SHORT);
            var date = Lang.format("$1$ $2$", [
                monthName(today.month),
                today.day,
            ]);
            return date;
        }

        case HEART_RATE: {
            var info = Activity.getActivityInfo();
            if (info == null) {
                return "";
            }

            var hr = info.currentHeartRate;
            if (hr == null) {
                return "";
            }
            return hr.format("%d");
        }

        case ELEVATION: {
            if (!((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory))) {
                return "";
            }

            var it = SensorHistory.getElevationHistory({ :period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST });
            if (it == null) {
                return "";
            }

            var ret = it.next().data;
            if (System.getDeviceSettings().heightUnits == System.UNIT_STATUTE) {
                ret *= 3.28084; // meters to feet
            }
            return ret.format("%d");
        }

        case STEPS: {
            var info = ActivityMonitor.getInfo();
            if (info == null) {
                return "";
            }

            var steps = info.steps;
            if (steps == null) {
                return "";
            }
            return steps.format("%d");
        }

        default:
            return "";
        }
    }

    hidden function monthName(month as Number) as String {
        var names = [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec"
        ];
        return names[month - 1];
    }
}
