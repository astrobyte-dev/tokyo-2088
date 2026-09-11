using Toybox.Application;
using Toybox.Lang;

class FaceSettings {
    var palette; var headerMode; var line1; var line2; var city; var citySubtitle;
    var readable; var clockMode; var leadingZero; var seconds; var tempUnits; var footer;
    function initialize() { reload(); }
    function number(key, fallback, maximum) {
        var v = Application.Properties.getValue(key);
        return (v instanceof Lang.Number && v >= 0 && v <= maximum) ? v : fallback;
    }
    function flag(key, fallback) {
        var v = Application.Properties.getValue(key);
        return v instanceof Lang.Boolean ? v : fallback;
    }
    function text(key, fallback) {
        var v = Application.Properties.getValue(key);
        return safeText(v instanceof Lang.String ? v : fallback);
    }
    function reload() {
        palette=number("Palette",0,3); headerMode=number("HeaderMode",0,3);
        line1=text("HeaderLine1","YOUR NAME"); line2=text("HeaderLine2","PERSONAL TERMINAL");
        city=text("City","YOUR CITY"); citySubtitle=text("CitySubtitle","LOCAL EDITION");
        readable=flag("Readable",false); clockMode=number("ClockMode",0,2);
        leadingZero=flag("LeadingZero",true); seconds=number("Seconds",0,1);
        tempUnits=number("TempUnits",0,2); footer=flag("Footer",true);
    }
}
// Display-only normalization. Never write shortened values back to Properties.
function safeText(input as Lang.String) as Lang.String {
    var out=""; var text=input.toUpper(); var chars=text.toCharArray(); var length=chars.size();
    if (length>64) { length=64; }
    for (var i=0;i<length;i+=1) {
        var ch=chars[i].toString(); var n=chars[i].toNumber();
        out += (n>=32 && n<=126) ? ch : "?";
    }
    while(out.length()>0 && out.substring(0,1).equals(" ")) {out=out.substring(1,out.length());}
    while(out.length()>0 && out.substring(out.length()-1,out.length()).equals(" ")) {out=out.substring(0,out.length()-1);}
    return out;
}
class LocationLabelProvider {
    function initialize() {}
    function plate(settings) as Lang.Array<Lang.String> {
        if (settings.headerMode==3) { return ["",""]; }
        if (settings.headerMode==1) { return [settings.line1,settings.line2]; }
        if (settings.headerMode==2 && settings.city.length()>0) { return [settings.city,settings.citySubtitle]; }
        return ["ASTROBYTE","INDUSTRIES"];
    }
}
