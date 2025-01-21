import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

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

        var currentDate = View.findDrawableById("CurrentDate") as Text;
        var now = Time.now();
        var today = Time.Gregorian.info(now, Time.FORMAT_SHORT);
        currentDate.setColor(Properties.getValue("ForegroundColor") as Number);
        currentDate.setText(Lang.format("$1$ $2$", [
            monthName(today.month),
            today.day,
        ]));

        if (!sleeping) {
            var clockTime = System.getClockTime();
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

    hidden function monthName(month as Lang.Number) as Lang.String {
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
