using Toybox.Application;
using Toybox.System;
(:capture)
class ResetCaptureApp extends Application.AppBase {
    var face;
    function initialize() {AppBase.initialize();}
    function getInitialView() {face=new ResetCaptureView();return [face];}
    function onSettingsChanged() {face.reloadSettings();WatchUi.requestUpdate();}
}
(:capture)
class ResetCaptureSecondsApp extends ResetCaptureApp {
    function initialize() {ResetCaptureApp.initialize();}
    function getInitialView() {face=new ResetCaptureSecondsView();return [face];}
}
(:capture)
class ResetCaptureSecondsView extends ResetCaptureView {
    function initialize() {ResetCaptureView.initialize();}
    function onLayout(dc) {ResetCaptureView.onLayout(dc);settings.seconds=1;}
}
(:capture)
class ResetCaptureView extends ResetSurfaceView {
    var logged=false;
    function initialize() {ResetSurfaceView.initialize();}
    function onUpdate(dc) {
        // Two real production callbacks at identical injected time. The second
        // receives a cleared DC and clean state, just like the regression test.
        trace="";TokyoView.onUpdate(dc);
        clearFixtureSurface(dc);trace="";TokyoView.onUpdate(dc);
        if(!logged) {
            System.println("INJECTED RESET-SURFACE FIXTURE; second update text="+trace);
            logged=true;
        }
    }
}
