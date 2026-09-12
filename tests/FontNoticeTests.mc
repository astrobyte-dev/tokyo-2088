using Toybox.Test;
using Toybox.Graphics;
using Toybox.Application;

(:test)
function fontNoticeDelivery(logger) {
    var bitmap=Graphics.createBufferedBitmap({:width=>280,:height=>280});var dc=bitmap.get().getDc();
    var pair=(Application.getApp() as TokyoApp).getSettingsView();
    Test.assert(pair[0] instanceof FontNoticeMenu);
    var resources=[Rez.Strings.LegalDejaVu,Rez.Strings.LegalNoto];
    for(var n=0;n<resources.size();n+=1) {
        var view=new FontNoticeView(n==0 ? "DejaVu / Arev" : "Noto / SIL OFL",resources[n]);
        view.onLayout(dc);var rebuilt="";var pos=0;
        for(var p=0;p<view.starts.size();p+=1) {
            Test.assertEqual(view.starts[p],pos);view.page=p;view.onUpdate(dc);
            for(var row=0;row<view.linesPerPage && pos<view.content.length();row+=1) {
                var end=view.lineEnd(dc,pos);Test.assert(end>pos);
                rebuilt+=view.content.substring(pos,end);pos=end;
            }
        }
        Test.assertEqual(rebuilt,view.content);Test.assert(view.content.length()>3000);
        Test.assertEqual(pos,view.content.length());
        view.movePage(1);Test.assertEqual(view.page,view.starts.size()-1);
        view.page=0;view.movePage(-1);Test.assertEqual(view.page,0);
        logger.debug("Complete offline notice paginated without omission: "+view.content.length()+" chars, "+view.starts.size()+" pages.");
    }
    return true;
}
