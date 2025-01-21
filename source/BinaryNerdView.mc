import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

const SCREEN_WIDTH = 260;
const SCREEN_HEIGHT = 260;

const DIODE_RADIUS = 12;
const DIODE_HEIGHT = 20;
const DIODE_WIDTH = 10;
const DIODE_GAP_X = 5;
const DIODE_GAP_Y = 15;
const DIODE_COUNT = 6;
const DIODES_TOTAL_WIDTH = ((DIODE_RADIUS * 2) * DIODE_COUNT);
const DIODES_TOTAL_HEIGHT = ((DIODE_RADIUS * 2) * 2);

const START_X = (SCREEN_WIDTH / 2) - (DIODES_TOTAL_WIDTH / 2);
const START_Y = (SCREEN_HEIGHT / 2) - (DIODES_TOTAL_HEIGHT / 2);

const COLOR_HOUR = Graphics.COLOR_ORANGE;
const COLOR_MINUTE = Graphics.COLOR_ORANGE;

class BinaryNerdView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        // var timeFormat = "$1$:$2$";
        // var clockTime = System.getClockTime();
        // var hours = clockTime.hour;
        // if (!System.getDeviceSettings().is24Hour) {
        //     if (hours > 12) {
        //         hours = hours - 12;
        //     }
        // } else {
        //     if (Application.Properties.getValue("UseMilitaryFormat")) {
        //         timeFormat = "$1$$2$";
        //         hours = hours.format("%02d");
        //     }
        // }
        // var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // // Update the view
        // var view = View.findDrawableById("TimeLabel") as Text;
        // view.setColor(Graphics.COLOR_BLUE);
        // view.setText("DANTUA");

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var clockTime = System.getClockTime();
        drawDiodes(dc, COLOR_HOUR, clockTime.hour, START_Y);
        drawDiodes(dc, COLOR_MINUTE, clockTime.min, START_Y + (DIODE_HEIGHT * 2) + DIODE_GAP_Y);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    hidden function drawDiodes(dc as Dc, onColor, number as Lang.Number, y) as Void {
        var x = START_X;

        dc.setPenWidth(2);

        var n = 32;
        while (true) {
            var on = number & n;
            dc.setColor(on > 0 ? onColor : Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);

            var height2 = DIODE_HEIGHT - 6;

            var pts = [
                [x - DIODE_RADIUS, y - height2],
                [x, y - DIODE_HEIGHT],
                [x + DIODE_RADIUS, y - height2],
                [x + DIODE_RADIUS, y + height2],
                [x, y + DIODE_HEIGHT],
                [x - DIODE_RADIUS, y + height2],
            ];
            dc.fillPolygon(pts);

            // if (on > 0) {
                // dc.fillCircle(x, y, DIODE_RADIUS);
                
            // } else {
                // dc.drawCircle(x, y, DIODE_RADIUS);
                // dc.draw
                
            // }

            x = x + (DIODE_RADIUS * 2) + DIODE_GAP_X;
            if (n == 1) {
                break;
            }

            n = n / 2;
        }
    }

}
