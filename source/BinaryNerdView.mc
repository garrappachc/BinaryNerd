import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
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

class BinaryNerdView extends WatchUi.WatchFace {

    private var sleeping = false;

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
        View.onUpdate(dc);

        var clockTime = System.getClockTime();
        var startY = (dc.getHeight() / 2) - (DIODES_TOTAL_HEIGHT * 0.75);
        drawDiodes(dc, Properties.getValue("ForegroundColor") as Number, clockTime.hour, 5, (dc.getWidth() / 2) - (HOUR_TOTAL_WIDTH / 2), startY);
        drawDiodes(dc, Properties.getValue("ForegroundColor") as Number, clockTime.min, 6, (dc.getWidth() / 2) - (MINUTE_TOTAL_WIDTH / 2), startY + DIODE_HEIGHT + DIODE_GAP_Y);

        if (!sleeping) {
            drawSeconds(dc, clockTime.sec);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        sleeping = false;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        sleeping = true;
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

    hidden function drawSeconds(dc as Dc, seconds as Lang.Number) as Void {
        var secondHand = (seconds / 60.0) * Math.PI * 2 - degreesToRadians(90);

        var radius = dc.getWidth() / 2;
        var length = radius - 10;

        var middleX = dc.getWidth() / 2;
        var middleY = dc.getHeight() / 2;

        var startX = Math.cos(secondHand) * radius;
    	var startY = Math.sin(secondHand) * radius;
        var endX = Math.cos(secondHand) * length;
    	var endY = Math.sin(secondHand) * length;

        dc.setAntiAlias(true);

    	dc.setColor(Properties.getValue("SecondsTickColor") as Number, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(5);
    	dc.drawLine(middleX + startX, middleY + startY, middleX + endX, middleY + endY);

        dc.setAntiAlias(false);
    }

    hidden function degreesToRadians(deg) {
		return (deg * Math.PI / 180);
	}

}
