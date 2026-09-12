using Toybox.Application;
using Toybox.WatchUi;
class TokyoApp extends Application.AppBase {
    var face;
    function initialize() {AppBase.initialize();}
    function getInitialView() {face=new TokyoView();return [face];}
    // Garmin's separate watch-face settings context; no change to the face.
    function getSettingsView() {return [new FontNoticeMenu(),new FontNoticeMenuDelegate()];}
    function onSettingsChanged() {
        if(face!=null) {face.reloadSettings();}
        WatchUi.requestUpdate();
    }
}
