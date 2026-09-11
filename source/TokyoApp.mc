using Toybox.Application;
using Toybox.WatchUi;
class TokyoApp extends Application.AppBase {
    var face;
    function initialize() {AppBase.initialize();}
    function getInitialView() {face=new TokyoView();return [face];}
    function onSettingsChanged() {
        if(face!=null) {face.reloadSettings();}
        WatchUi.requestUpdate();
    }
}
