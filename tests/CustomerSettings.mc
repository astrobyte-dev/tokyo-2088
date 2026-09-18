using Toybox.Application;
using Toybox.Test;
using Toybox.Graphics;

// Simulator properties only. Changing defaults must never migrate stored text.
(:test)
function customerSettingsPreservation(logger) {
    var keys=["HeaderLine1","City","HeaderMode","Palette","Seconds"];
    var old=[];
    for(var i=0;i<keys.size();i+=1) {old.add(Application.Properties.getValue(keys[i]));}
    // Simulate old/malformed stored types; packaged fresh defaults are checked
    // separately in tools/check-store-prep.py. Properties has no delete API.
    Application.Properties.setValue("HeaderLine1",false);
    Application.Properties.setValue("City",false);
    var settings=new FaceSettings();
    Test.assertEqual(settings.line1,"YOUR NAME");
    Test.assertEqual(settings.city,"YOUR CITY");
    // Prior personal values are valid user preferences, not migration targets.
    Application.Properties.setValue("HeaderLine1","COREY");
    Application.Properties.setValue("City","HOBART");
    settings.reload();
    Test.assertEqual(settings.line1,"COREY");Test.assertEqual(settings.city,"HOBART");
    var input="  Mixed Case / 123 with a very long equipment label that exceeds the displayed width  ";
    Application.Properties.setValue("HeaderLine1",input);
    Application.Properties.setValue("HeaderMode",1);
    Application.Properties.setValue("Palette",3);
    Application.Properties.setValue("Seconds",1);
    var bitmap=Graphics.createBufferedBitmap({:width=>280,:height=>280});
    var dc=bitmap.get().getDc();var view=new TokyoView();view.onLayout(dc);
    var app=Application.getApp() as TokyoApp;var previousFace=app.face;app.face=view;
    app.onSettingsChanged();
    Test.assertEqual(view.settings.palette,3);Test.assertEqual(view.settings.seconds,1);
    Test.assertEqual(view.accent,0xffaa00);Test.assertEqual(view.lastSample,-1);
    view.onUpdate(dc);
    Test.assertEqual(Application.Properties.getValue("HeaderLine1"),input);
    Test.assert(dc.getTextWidthInPixels(view.fitted(dc,view.plate[0],142,:small),view.fonts[:small])<=142);
    Application.Properties.setValue("HeaderMode",2);
    Application.Properties.setValue("City","   ");app.onSettingsChanged();
    Test.assertEqual(view.plate[0],"ASTROBYTE");
    Test.assertEqual(Application.Properties.getValue("City"),"   ");
    Application.Properties.setValue("Palette",99);Application.Properties.setValue("Seconds",99);
    settings.reload();Test.assertEqual(settings.palette,0);Test.assertEqual(settings.seconds,0);
    app.face=previousFace;
    for(var j=0;j<keys.size();j+=1) {Application.Properties.setValue(keys[j],old[j]);}
    logger.debug("Neutral defaults, stored legacy text, display-only shortening and settings callback passed; phone sync not exercised.");
    return true;
}
