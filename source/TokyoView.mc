using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;
using Toybox.Math;
using Toybox.Weather;

// Explicit primary profile. Other sizes remain disabled until tested.
module Profile {
    const WIDTH=280;
    const TIME_X=91;
    const HOUR_Y=59;
    const MINUTE_Y=140;
}
class TokyoView extends WatchUi.WatchFace {
    var settings as FaceSettings; var data as DataSnapshot; var provider as LocationLabelProvider; var fonts as Lang.Dictionary = {};
    var awake=true; var dirty=true; var lastMinute=-1; var lastSample=-1;
    var accent=0xff0000; var plate as Lang.Array = ["",""];
    var weekdays as Lang.Array<Lang.String> = ["SUN","MON","TUE","WED","THU","FRI","SAT"];
    var months as Lang.Array<Lang.String> = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    function initialize() {
        WatchFace.initialize(); settings=new FaceSettings();data=new DataSnapshot();provider=new LocationLabelProvider();
    }
    function onLayout(dc) {
        fonts={:hero=>WatchUi.loadResource(Rez.Fonts.hero),:tokyo=>WatchUi.loadResource(Rez.Fonts.tokyo),
            :micro=>WatchUi.loadResource(Rez.Fonts.micro),:label=>WatchUi.loadResource(Rez.Fonts.label),
            :data=>WatchUi.loadResource(Rez.Fonts.data),:date=>WatchUi.loadResource(Rez.Fonts.date),
            :small=>WatchUi.loadResource(Rez.Fonts.plateSmall)};
        reloadSettings();
    }
    function reloadSettings() {
        settings.reload(); accent=[0xff0000,0x00ffff,0xffffff,0xffaa00][settings.palette];
        plate=provider.plate(settings); dirty=true; lastSample=-1;
    }
    function onEnterSleep() {awake=false;dirty=true;WatchUi.requestUpdate();}
    function onExitSleep() {awake=true;dirty=true;}
    function text(dc,x,y,font,value,color,center) {
        dc.setColor(color,Graphics.COLOR_TRANSPARENT);
        dc.drawText(x,y,fonts[font],value,center ? Graphics.TEXT_JUSTIFY_CENTER : Graphics.TEXT_JUSTIFY_LEFT);
    }
    function fitted(dc,value,width,font) {
        if(dc.getTextWidthInPixels(value,fonts[font])<=width) {return value;}
        var v=value;
        while(v.length()>0 && dc.getTextWidthInPixels(v+"...",fonts[font])>width) {v=v.substring(0,v.length()-1);}
        return v+"...";
    }
    function drawPlate(dc) {
        if(settings.headerMode==3) {
            return;
        }
        var font=:label;
        if(dc.getTextWidthInPixels(plate[0],fonts[font])>142) {font=:small;}
        text(dc,144,22,font,fitted(dc,plate[0],142,font),0xffffff,true);
        // Subtitle stays at the legible minimum; excess is abbreviated.
        var subtitleFont=settings.headerMode==0 ? :micro : :small;
        text(dc,144,37,subtitleFont,fitted(dc,plate[1],142,subtitleFont),0xaaaaaa,true);
    }
    function onUpdate(dc) {
        var clock=System.getClockTime(); var now=Time.now(); var minute=now.value()/60;
        if(!dirty && minute==lastMinute) {
            if(awake && settings.seconds==1) {drawSeconds(dc,clock.sec);}
            return;
        }
        if(lastSample<0 || now.value()-lastSample>=60 || now.value()<lastSample) {data.refresh(settings,now.value());lastSample=now.value();}
        var info=Gregorian.info(now,Time.FORMAT_SHORT);
        var is24=settings.clockMode==1 || (settings.clockMode==0 && System.getDeviceSettings().is24Hour);
        render(dc,Format.hour(clock.hour,is24,settings.leadingZero),clock.min.format("%02d"),weekdays[info.day_of_week-1],info.day.toString(),months[info.month-1],is24 ? "" : (clock.hour<12 ? "AM" : "PM"));
        if(awake && settings.seconds==1) {drawSeconds(dc,clock.sec);}
        lastMinute=minute;dirty=false;
    }
    function render(dc,hour,minute,dayName,day,month,ampm) {
        dc.clearClip();dc.setColor(0xffffff,0x000000);dc.clear();
        drawPlate(dc);
        dc.setColor(accent,0x000000);dc.drawLine(79,51,220,51);
        dc.setColor(0x555555,0x000000);dc.drawLine(80,58,80,214);
        text(dc,36,69,:tokyo,"東",accent,false);text(dc,36,113,:tokyo,"京",accent,false);
        text(dc,55,166,:data,"2088",0xaaaaaa,true);
        text(dc,Profile.TIME_X,Profile.HOUR_Y,:hero,hour,0xffffff,false);
        text(dc,Profile.TIME_X,Profile.MINUTE_Y,:hero,minute,0xffffff,false);
        text(dc,224,71,:label,dayName,0xaaaaaa,true);text(dc,224,92,:date,day,0xffffff,true);
        text(dc,224,120,:label,month,0xaaaaaa,true);
        text(dc,221,202,:micro,ampm,0xaaaaaa,true);
        drawBattery(dc);
        dc.setColor(0x555555,0x000000);dc.drawLine(43,222,237,222);
        var font=settings.readable ? :data : :label;
        metric(dc,65,font,data.batteryText);metric(dc,114,font,data.hr);
        metric(dc,166,font,data.steps);metric(dc,214,font,data.temp);
        text(dc,65,245,:micro,data.battery!=null && data.battery<=10 ? "LOW" : "BAT",data.battery!=null && data.battery<=10 ? 0xffffff : 0xaaaaaa,true);
        text(dc,114,245,:micro,"BPM",0xaaaaaa,true);text(dc,166,245,:micro,"STEP",0xaaaaaa,true);
        text(dc,214,245,:micro,data.weatherStale ? "OLD" : (data.fahrenheit ? "°F" : "°C"),0xaaaaaa,true);
        drawWeather(dc,218,174);
        if(settings.footer) {text(dc,140,260,:micro,"TERMINAL // AC-01",accent,true);}
    }
    function metric(dc,x,font,value) {
        if(dc.getTextWidthInPixels(value,fonts[font])>48) {font=:label;}
        text(dc,x,228,font,fitted(dc,value,48,font),0xffffff,true);
    }
    function drawBattery(dc) {
        var filled=data.battery==null ? 0 : Math.floor(data.battery/10.0).toNumber();
        if(data.battery!=null && data.battery>0 && filled==0) {filled=1;}
        for(var i=0;i<10;i+=1) {
            dc.setColor(i>=10-filled ? accent : 0x555555,0x000000);
            var y=148+i*5;dc.fillPolygon([[241,y],[250,y-8],[250,y-5],[241,y+3]]);
        }
        if(data.battery==null) {text(dc,246,201,:micro,"?",0xffffff,true);}
        else if(data.battery<=10) {
            dc.setColor(0xffffff,0x000000);dc.drawRectangle(239,138,14,63);text(dc,246,203,:micro,"!",0xffffff,true);
        }
    }
    function drawSeconds(dc,second) {
        dc.setClip(209,145,26,21);dc.setColor(0xffffff,0x000000);dc.clear();
        text(dc,222,147,:data,second.format("%02d"),0xffffff,true);dc.clearClip();
    }
    function drawWeather(dc,x,y) {
        dc.setColor(0xaaaaaa,0x000000);
        if(data.weatherCondition==null) {dc.drawLine(x-4,y+6,x+4,y+6);return;}
        if(data.weatherCondition==Weather.CONDITION_CLEAR || data.weatherCondition==Weather.CONDITION_FAIR) {
            dc.drawCircle(x,y+5,4);dc.drawLine(x,y-3,x,y-1);dc.drawLine(x,y+11,x,y+13);dc.drawLine(x-8,y+5,x-6,y+5);dc.drawLine(x+6,y+5,x+8,y+5);
        } else if(data.weatherCondition==Weather.CONDITION_CLOUDY || data.weatherCondition==Weather.CONDITION_PARTLY_CLOUDY || data.weatherCondition==Weather.CONDITION_MOSTLY_CLOUDY) {
            dc.drawArc(x,y+4,5,Graphics.ARC_CLOCKWISE,0,180);dc.drawArc(x-5,y+7,3,Graphics.ARC_CLOCKWISE,90,270);dc.drawLine(x-5,y+10,x+7,y+10);dc.drawLine(x+7,y+5,x+7,y+10);
        } else {text(dc,x,y,:micro,"?",0xaaaaaa,true);}
    }
}
