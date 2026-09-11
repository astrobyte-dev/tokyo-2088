using Toybox.Application;
using Toybox.System;
(:preview)
class PreviewApp extends Application.AppBase {
    function initialize() {AppBase.initialize();}
    function getInitialView() {return [new PreviewView()];}
}
(:preview)
class PreviewView extends TokyoView {
    var logged=false;
    function initialize() {TokyoView.initialize();}
    function onUpdate(dc) {
        data.battery=74;data.batteryText="74%";data.hr="68";data.steps="6.4K";data.temp="11°";
        render(dc,"08","27","FRI","11","SEP","");
        if(!logged) {System.println("FIXTURE PREVIEW; used memory="+System.getSystemStats().usedMemory);logged=true;}
    }
}
