using Toybox.ActivityMonitor;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.Weather;

module Format {
    function hour(hour, is24, zero) {
        var h=hour;
        if (!is24) { h=h%12; if(h==0) {h=12;} }
        if(h<10) {return (zero ? "0" : " ")+h.toString();}
        return h.toString();
    }
    function fresh(now, timestamp, limit) {
        return timestamp!=null && now>=timestamp && now-timestamp<=limit;
    }
    function hr(value, timestamp, now) {
        return value!=null && value!=ActivityMonitor.INVALID_HR_SAMPLE && value>0 && value<=255 && fresh(now,timestamp,300) ? value.toString() : "--";
    }
    function steps(value) {
        if(value==null || value<0) {return "--";}
        if(value<1000) {return value.toString();}
        if(value<10000) {return (Math.floor(value/100.0)/10.0).format("%.1f")+"K";}
        if(value<1000000) {return Math.floor(value/1000.0).toNumber().toString()+"K";}
        return "999K+";
    }
    function battery(value) {
        if(value==null || value<0 || value>100) {return null;}
        return Math.round(value).toNumber();
    }
    function temperature(value, timestamp, now, fahrenheit) {
        if(value==null || !fresh(now,timestamp,7200)) {return "--";}
        if(fahrenheit) {value=value*1.8+32;}
        return Math.round(value).toNumber().toString()+"°";
    }
}
class DataSnapshot {
    var battery=null; var batteryText="--"; var steps="--"; var hr="--"; var temp="--";
    var weatherCondition=null; var weatherStale=false; var fahrenheit=false;
    function initialize() {}
    function refresh(settings, now) {
        battery=Format.battery(System.getSystemStats().battery);
        batteryText=battery==null ? "--" : battery.toString()+"%";
        steps="--"; hr="--"; temp="--";weatherCondition=null;weatherStale=false;
        fahrenheit=settings.tempUnits==2 || (settings.tempUnits==0 && System.getDeviceSettings().temperatureUnits==System.UNIT_STATUTE);
        try {steps=Format.steps(ActivityMonitor.getInfo().steps);} catch(e) {}
        try {
            var history=ActivityMonitor.getHeartRateHistory(new Time.Duration(300),true);
            // A bounded scan: no live sensor subscription, no indefinite old reading.
            for(var i=0;i<8;i+=1) {
                var sample=history.next(); if(sample==null) {break;}
                var stamp=sample.when==null ? null : sample.when.value();
                var value=Format.hr(sample.heartRate,stamp,now);
                if(!value.equals("--")) {hr=value;break;}
            }
        } catch(e) {}
        try {
            var conditions=Weather.getCurrentConditions();
            if(conditions!=null) {
                var stamp=conditions.observationTime==null ? null : conditions.observationTime.value();
                temp=Format.temperature(conditions.temperature,stamp,now,fahrenheit);
                if(!temp.equals("--")) {weatherCondition=conditions.condition;weatherStale=!Format.fresh(now,stamp,3600);}
            }
        } catch(e) {}
    }
}
