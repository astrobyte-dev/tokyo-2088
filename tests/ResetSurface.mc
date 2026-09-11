using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Test;

// Included only in native tests and the explicitly labelled capture fixture.
(:fixture)
class FixtureClock {
    var hour=8; var min=27; var sec=15;
    function initialize() {}
}
(:fixture)
class FixtureData extends DataSnapshot {
    var refreshes=0;
    function initialize() {DataSnapshot.initialize();}
    function refresh(settings,now) {
        refreshes+=1;
        battery=74;batteryText="74%";hr="68";steps="6.4K";temp="11°";
    }
}
(:fixture)
class ResetSurfaceView extends TokyoView {
    var clockFixture; var momentFixture; var trace=""; var secondsDraws=0;
    function initialize() {
        TokyoView.initialize();clockFixture=new FixtureClock();
        momentFixture= new Time.Moment(1789079220);data=new FixtureData();
    }
    function currentClock() {return clockFixture;}
    function currentMoment() {return momentFixture;}
    function text(dc,x,y,font,value,color,center) {
        // Record every production text path AND execute it on the real Garmin DC.
        trace+=x.toString()+","+y.toString()+":"+value+"|";
        TokyoView.text(dc,x,y,font,value,color,center);
    }
    function drawSeconds(dc,second) {
        secondsDraws+=1;TokyoView.drawSeconds(dc,second);
    }
}
(:fixture)
function clearFixtureSurface(dc) {
    // Injected simulation of a non-retained device DC, not a hardware observation.
    dc.clearClip();dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_BLACK);dc.clear();
}
(:fixture)
function assertRestored(view,dc,expected) {
    clearFixtureSurface(dc);view.trace="";view.onUpdate(dc);
    Test.assertEqual(view.trace,expected);
}
(:fixture)
function resetSurfaceCase(logger,seconds) {
    var bitmap=Graphics.createBufferedBitmap({:width=>280,:height=>280});
    var dc=bitmap.get().getDc();var view=new ResetSurfaceView();view.onLayout(dc);
    view.settings.seconds=seconds;view.settings.clockMode=1;
    view.settings.headerMode=0;view.plate=["ASTROBYTE","INDUSTRIES"];
    view.onUpdate(dc);var expected=view.trace;
    Test.assert(expected.find("91,59:08|")!=null);
    Test.assert(expected.find("91,140:27|")!=null);
    Test.assert(expected.find("144,22:ASTROBYTE|")!=null);
    Test.assert(expected.find("144,37:INDUSTRIES|")!=null);
    Test.assert(expected.find("36,69:東|")!=null);
    Test.assert(expected.find("55,166:2088|")!=null);
    Test.assert(!view.dirty);
    // Baseline must fail HERE: no invalidation and a guaranteed same minute.
    logger.debug("Injected reset surface, seconds="+seconds);
    for(var i=0;i<10;i+=1) {assertRestored(view,dc,expected);}
    Test.assertEqual((view.data as FixtureData).refreshes,1);
    var fresh=Graphics.createBufferedBitmap({:width=>280,:height=>280});
    dc=fresh.get().getDc();assertRestored(view,dc,expected);
    // Deliberately leave a stale clip: full update must restore the full region.
    dc.setClip(209,145,26,21);view.trace="";view.onUpdate(dc);
    Test.assertEqual(view.trace,expected);
    view.onEnterSleep();view.trace="";view.onUpdate(dc);
    var sleeping=view.trace;var secondsBefore=view.secondsDraws;
    assertRestored(view,dc,sleeping);Test.assertEqual(view.secondsDraws,secondsBefore);
    view.onExitSleep();assertRestored(view,dc,expected);
    view.onHide();view.onShow();assertRestored(view,dc,expected);
    Test.assertEqual((view.data as FixtureData).refreshes,1);
    view.momentFixture=new Time.Moment(view.momentFixture.value()+60);
    view.clockFixture.min=28;view.trace="";view.onUpdate(dc);
    Test.assert(view.trace.find("91,140:28|")!=null);
    Test.assertEqual((view.data as FixtureData).refreshes,2);assertRestored(view,dc,view.trace);
    // Local midnight/date transition uses Gregorian's actual local interpretation.
    var utc=Gregorian.moment({:year=>2026,:month=>12,:day=>31,:hour=>23,:minute=>59,:second=>59});
    var local=Gregorian.info(utc,Time.FORMAT_SHORT);
    var interpreted=Gregorian.moment({:year=>local.year,:month=>local.month,:day=>local.day,:hour=>local.hour,:minute=>local.min,:second=>local.sec});
    view.momentFixture=new Time.Moment(utc.value()-(interpreted.value()-utc.value()));
    view.clockFixture.hour=23;view.clockFixture.min=59;view.clockFixture.sec=59;
    view.trace="";view.onUpdate(dc);
    Test.assert(view.trace.find("91,59:23|")!=null);
    Test.assert(view.trace.find("224,92:31|")!=null);
    Test.assert(view.trace.find("224,120:DEC|")!=null);
    view.momentFixture=new Time.Moment(view.momentFixture.value()+1);
    view.clockFixture.hour=0;view.clockFixture.min=0;view.clockFixture.sec=0;
    view.trace="";view.onUpdate(dc);
    Test.assert(view.trace.find("91,59:00|")!=null);
    Test.assert(view.trace.find("91,140:00|")!=null);
    Test.assert(view.trace.find("224,92:1|")!=null);
    Test.assert(view.trace.find("224,120:JAN|")!=null);
    assertRestored(view,dc,view.trace);
    var count=(view.data as FixtureData).refreshes;
    view.momentFixture=new Time.Moment(view.momentFixture.value()-120);
    view.onUpdate(dc);Test.assertEqual((view.data as FixtureData).refreshes,count+1);
    view.reloadSettings();view.onUpdate(dc);Test.assertEqual((view.data as FixtureData).refreshes,count+2);
    return true;
}
(:test)
function resetSurfaceSecondsOff(logger) {return resetSurfaceCase(logger,0);}
(:test)
function resetSurfaceSecondsOn(logger) {return resetSurfaceCase(logger,1);}

// No trace instrumentation in this timing view; the production renderer runs.
(:fixture)
class UpdateCostView extends TokyoView {
    var fixedClock; var fixedMoment;
    function initialize() {
        TokyoView.initialize();fixedClock=new FixtureClock();
        fixedMoment=new Time.Moment(1789079220);data=new FixtureData();
    }
    function currentClock() {return fixedClock;}
    function currentMoment() {return fixedMoment;}
}
(:test)
function repeatedUpdateCost(logger) {
    var bitmap=Graphics.createBufferedBitmap({:width=>280,:height=>280});
    var dc=bitmap.get().getDc();var view=new UpdateCostView();view.onLayout(dc);
    view.onUpdate(dc);var peak=0;
    for(var seconds=0;seconds<=1;seconds+=1) {
        view.settings.seconds=seconds;
        var start=System.getTimer();
        for(var i=0;i<240;i+=1) {
            view.onUpdate(dc);
            var used=System.getSystemStats().usedMemory;if(used>peak){peak=used;}
        }
        logger.debug("240 fixed-time updates, seconds="+seconds+", elapsed ms="+(System.getTimer()-start));
    }
    Test.assertEqual((view.data as FixtureData).refreshes,1);
    Test.assert(peak<65536);
    logger.debug("Update-cost fixture sampled max bytes="+peak+"; telemetry refreshes=1");
    return true;
}
