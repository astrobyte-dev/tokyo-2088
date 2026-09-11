using Toybox.Test;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

(:test)
function formatting(logger) {
    Test.assertEqual(Format.hour(0,false,true),"12");
    Test.assertEqual(Format.hour(12,false,true),"12");
    Test.assertEqual(Format.hour(23,false,true),"11");
    Test.assertEqual(Format.hour(0,true,true),"00");
    Test.assertEqual(Format.hour(8,true,false)," 8");
    Test.assertEqual(Format.hr(null,1000,1000),"--");
    Test.assertEqual(Format.hr(0,1000,1000),"--");
    Test.assertEqual(Format.hr(68,700,1000),"68");
    Test.assertEqual(Format.hr(68,699,1000),"--");
    Test.assertEqual(Format.hr(68,1001,1000),"--");
    Test.assertEqual(Format.hr(68,null,1000),"--");
    Test.assertEqual(Format.steps(0),"0");
    Test.assertEqual(Format.steps(null),"--");
    Test.assertEqual(Format.steps(6482),"6.4K");
    Test.assertEqual(Format.steps(99999),"99K");
    Test.assertEqual(Format.steps(999999),"999K");
    Test.assertEqual(Format.temperature(0,1000,1000,false),"0°");
    Test.assertEqual(Format.temperature(-11,1000,1000,false),"-11°");
    Test.assertEqual(Format.temperature(0,1000,1000,true),"32°");
    Test.assertEqual(Format.temperature(11,1000,8201,false),"--");
    Test.assertEqual(Format.temperature(11,null,1000,false),"--");
    var batteries=[0,1,9,10,99,100];
    for(var i=0;i<batteries.size();i+=1) {var b=batteries[i];Test.assertEqual(Format.battery(b),b);}
    Test.assert(Format.battery(null)==null);Test.assert(Format.battery(101)==null);
    return true;
}
(:test)
function headerSettings(logger) {
    Test.assertEqual(safeText("  HoBaRt  "),"HOBART");
    Test.assertEqual(safeText("東京"),"??");
    Test.assertEqual(safeText("   "),"");
    Test.assertEqual(safeText("A東B京C"),"A?B?C");
    var settings=new FaceSettings();var provider=new LocationLabelProvider();
    settings.headerMode=0;Test.assertEqual(provider.plate(settings)[0],"ASTROBYTE");
    settings.headerMode=1;settings.line1="COREY";Test.assertEqual(provider.plate(settings)[0],"COREY");
    settings.headerMode=2;settings.city="";Test.assertEqual(provider.plate(settings)[0],"ASTROBYTE");
    settings.city="HOBART";Test.assertEqual(provider.plate(settings)[0],"HOBART");
    settings.headerMode=3;Test.assertEqual(provider.plate(settings)[0],"");
    var old=Application.Properties.getValue("Palette");
    Application.Properties.setValue("Palette",99);settings.reload();Test.assertEqual(settings.palette,0);
    Application.Properties.setValue("Palette",old);
    return true;
}
// Exercise the production drawing code with real Garmin fonts and DC, not a mock renderer.
(:test)
function rendererMatrix(logger) {
    var bitmap=Graphics.createBufferedBitmap({:width=>280,:height=>280});var dc=bitmap.get().getDc();
    var view=new TokyoView();view.onLayout(dc);
    for(var palette=0;palette<4;palette+=1) {
        view.accent=[0xff0000,0x00ffff,0xffffff,0xffaa00][palette];
        var clocks=[["08","27"],["11","11"],["00","00"],["12","59"],["23","59"]];
        for(var t=0;t<clocks.size();t+=1) {var digits=clocks[t];
            var batteries=[0,1,9,10,99,100,null];
            for(var i=0;i<batteries.size();i+=1) {var b=batteries[i];
                view.data.battery=b;view.data.batteryText=b==null ? "--" : b.toString()+"%";
                view.data.hr="199";view.data.steps="999K";view.data.temp="-11°";
                view.render(dc,digits[0],digits[1],"WED","31","DEC","");
            }
        }
    }
    view.settings.headerMode=1;view.plate=["A VERY LONG CITY WITH MIXED 123 / LETTERS","A LONG SUBTITLE THAT NEEDS TRUNCATION"];
    view.settings.readable=true;view.render(dc,"11","11","THU","1","JAN","AM");
    Test.assert(dc.getTextWidthInPixels(view.fitted(dc,view.plate[0],142,:small),view.fonts[:small])<=142);
    view.settings.headerMode=3;view.render(dc,"00","00","FRI","11","SEP","");
    view.onEnterSleep();view.onUpdate(dc);view.onExitSleep();view.settings.seconds=1;view.onUpdate(dc);
    // A subsequent full draw must clear the seconds clip.
    view.render(dc,"08","27","FRI","11","SEP","");
    logger.debug("Renderer matrix complete; memory snapshot="+System.getSystemStats().usedMemory);
    return true;
}

// Explicit lifecycle fixture: invokes the real callbacks and rendering on a Garmin DC.
// This supplements (does not impersonate) simulator-controlled display-mode testing.
(:test)
function repeatedPowerCycles(logger) {
    var bitmap=Graphics.createBufferedBitmap({:width=>280,:height=>280});var dc=bitmap.get().getDc();
    var view=new TokyoView();view.onLayout(dc);
    var peak=0;
    for(var i=0;i<100;i+=1) {
        view.reloadSettings();view.settings.seconds=1;
        view.onExitSleep();Test.assert(view.awake);Test.assert(view.dirty);view.onUpdate(dc);
        view.onEnterSleep();Test.assert(!view.awake);Test.assert(view.dirty);view.onUpdate(dc);
        Test.assert(!view.dirty);
        var sample=view.lastSample;view.onUpdate(dc);Test.assertEqual(view.lastSample,sample);
        var used=System.getSystemStats().usedMemory;if(used>peak){peak=used;}
    }
    Test.assert(peak<65536);
    logger.debug("100 wake/sleep/settings cycles completed; sampled test-context max bytes="+peak);
    return true;
}
