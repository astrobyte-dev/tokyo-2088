using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;

class FontNoticeMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Font notices"});
        addItem(new WatchUi.MenuItem("DejaVu / Arev",null,Rez.Strings.LegalDejaVu,{}));
        addItem(new WatchUi.MenuItem("Noto / SIL OFL",null,Rez.Strings.LegalNoto,{}));
    }
}
class FontNoticeMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {Menu2InputDelegate.initialize();}
    function onSelect(item) {
        var view=new FontNoticeView(item.getLabel(),item.getId());
        WatchUi.pushView(view,new FontNoticeDelegate(view),WatchUi.SLIDE_LEFT);
    }
}
// Notices are loaded only in the separate settings context, never on a clock tick.
// Pages preserve every character; line wrapping inserts no shortened text.
class FontNoticeView extends WatchUi.View {
    var title; var content; var page=0; var starts as Lang.Array<Lang.Number> = []; var linesPerPage; var lineHeight;
    var left; var top; var width; var font=Graphics.FONT_XTINY;
    function initialize(label,resource) {
        View.initialize(); title=label;
        content=WatchUi.loadResource(resource) as Lang.String;
    }
    function lineEnd(dc,start) {
        var end=start;var lastSpace=-1;
        while(end<content.length()) {
            var ch=content.substring(end,end+1);
            if(ch.equals("\n")) {return end+1;}
            if(dc.getTextWidthInPixels(content.substring(start,end+1),font)>width) {
                if(lastSpace>=start) {return lastSpace+1;}
                return end>start ? end : start+1;
            }
            if(ch.equals(" ")) {lastSpace=end;}
            end+=1;
        }
        return end;
    }
    function onLayout(dc) {
        // A centered rectangle inside the round screen, clear of the curved edge.
        left=dc.getWidth()*0.17; width=dc.getWidth()-2*left;
        top=dc.getHeight()*0.22; lineHeight=dc.getFontHeight(font);
        linesPerPage=((dc.getHeight()*0.58)/lineHeight).toNumber();
        if(linesPerPage<1) {linesPerPage=1;}
        starts=[0];var pos=0;var count=0;
        while(pos<content.length()) {
            pos=lineEnd(dc,pos);count+=1;
            if(count%linesPerPage==0 && pos<content.length()) {starts.add(pos);}
        }
        if(page>=starts.size()) {page=starts.size()-1;}
    }
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_BLACK);dc.clear();
        dc.drawText(dc.getWidth()/2,dc.getHeight()*0.1,font,title,Graphics.TEXT_JUSTIFY_CENTER);
        var pos=starts[page];var row=0;
        while(pos<content.length() && row<linesPerPage) {
            var end=lineEnd(dc,pos);var line=content.substring(pos,end);
            if(line.length()>0 && line.substring(line.length()-1,line.length()).equals("\n")) {
                line=line.substring(0,line.length()-1);
            }
            dc.drawText(left,top+row*lineHeight,font,line,Graphics.TEXT_JUSTIFY_LEFT);
            pos=end;row+=1;
        }
        dc.drawText(dc.getWidth()/2,dc.getHeight()*0.82,font,
            (page+1).toString()+"/"+starts.size().toString()+"  UP/DOWN",Graphics.TEXT_JUSTIFY_CENTER);
    }
    function movePage(delta) {
        var next=page+delta;
        if(next>=0 && next<starts.size()) {page=next;WatchUi.requestUpdate();}
        return true;
    }
}
class FontNoticeDelegate extends WatchUi.BehaviorDelegate {
    var view;
    function initialize(noticeView) {BehaviorDelegate.initialize();view=noticeView;}
    function onNextPage() {return view.movePage(1);}
    function onPreviousPage() {return view.movePage(-1);}
    function onBack() {WatchUi.popView(WatchUi.SLIDE_RIGHT);return true;}
}
