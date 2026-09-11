#!/usr/bin/env python3
"""AT-SPI access to Garmin simulator UI; no app-state or pixel fabrication."""
import pyatspi

def app():return next(a for a in pyatspi.Registry.getDesktop(0) if a.name=='simulator')
def walk(node):
 yield node
 for c in node:yield from walk(c)
def named(name,root=None):
 nodes=[n for n in walk(root or app()) if n.name==name]
 if not nodes:raise LookupError('Simulator UI element not found: '+name)
 return next((n for n in nodes if n.getState().contains(pyatspi.STATE_SHOWING)),nodes[0] if nodes else None)
def action(node):
 q=node.queryAction();return q.doAction(0)
def text(node):
 try:return node.queryText().getText(0,-1)
 except:return ''
def dump(root=None):
 for n in walk(root or app()):print(n.getRoleName(),repr(n.name),repr(text(n)))
if __name__=='__main__':dump()

def raise_window(title):
 import subprocess,os,time
 subprocess.run(['xdotool','search','--name',title,'windowactivate','--sync'],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL,check=True)
 time.sleep(.4)

def menu(name,top='Settings'):
 import time
 raise_window('CIQ Simulator')
 click(named(top));time.sleep(.2);action(named(name));time.sleep(.8)

def set_time(value,date=None):
 import subprocess,time,os
 frame=next((n for n in app() if n.name=='Time Simulation'),None)
 if frame is None:menu('Time Simulation','Simulation');frame=next(n for n in app() if n.name=='Time Simulation')
 raise_window('Time Simulation')
 click(named('Stop',frame));time.sleep(.2)
 if date:
  d=next(n for n in walk(frame) if n.getRoleName()=='text' and '/' in text(n));click(d)
  subprocess.run(['xdotool','key','ctrl+a'],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL)
  subprocess.run(['xdotool','type','--delay','50',date],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL)
  subprocess.run(['xdotool','key','Tab'],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL);time.sleep(.2)
  print('Simulator date input:',text(d))
 t=next(n for n in walk(frame) if n.getRoleName()=='text' and ':' in text(n))
 click(t);time.sleep(.2)
 for _ in range(4):
  if t.queryText().getSelection(0)[0]==0:break
  subprocess.run(['xdotool','key','Left'],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL);time.sleep(.15)
 subprocess.run(['xdotool','type','--delay','100','--clearmodifiers',value],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL)
 print('Simulator clock input:',text(t));click(named('Start',frame));time.sleep(1.3);click(named('Pause',frame));time.sleep(.3)

def click(node):
 import subprocess,os
 r=node.queryComponent().getExtents(pyatspi.DESKTOP_COORDS)
 if r.x<0 or r.y<0 or r.width<=1:raise RuntimeError('UI element is not visible: '+node.name)
 subprocess.run(['xdotool','mousemove',str(r.x+r.width//2),str(r.y+r.height//2),'click','1'],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL,check=True)

def capture(path):
 import time,pathlib
 raise_window('CIQ Simulator');click(named('File'));time.sleep(.2);click(named('Save Screen Capture'));time.sleep(.8)
 r=named('Save Screenshot');t=next(n for n in walk(r) if n.getRoleName()=='text')
 t.queryEditableText().setTextContents(str(pathlib.Path(path).resolve()));time.sleep(.2);click(named('Save',r));time.sleep(.5)
 print('Saved',path)

def settings_open():
 import time,subprocess,os
 raise_window('CIQ Simulator');subprocess.run(['xdotool','key','ctrl+p'],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL);time.sleep(2)

def choose(name,index):
 import subprocess,time,os
 click(named(name));time.sleep(.3)
 subprocess.run(['xdotool','key','Home']+['Down']*index+['Return'],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL);time.sleep(.2)

def settings_save():
 import time
 r=named('App Settings Editor');buttons=[n for n in walk(r) if n.name=='Save' and n.getRoleName()=='push button'];click(buttons[-1]);time.sleep(.6)
 click(named('OK'));time.sleep(.4);click(named('Close',r));time.sleep(.4)

def fill(name,value):
 import time,subprocess,os
 click(named(name));time.sleep(.1)
 subprocess.run(['xdotool','key','ctrl+a'],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL)
 subprocess.run(['xdotool','type','--delay','10',value],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL);time.sleep(.2)

def memory_snapshot(path):
 import subprocess,os,time,pathlib
 try:
  raise_window('Active Memory');subprocess.run(['xdotool','key','alt+F4'],env={**os.environ,'DISPLAY':':99'},stdout=subprocess.DEVNULL);time.sleep(.3)
 except subprocess.CalledProcessError:pass
 menu('View Memory','File');r=named('Active Memory');click(named('Expand All',r));time.sleep(.3)
 lines=[n.name for n in walk(r) if n.getRoleName()=='label']
 cells=[n.name for n in walk(r) if n.getRoleName()=='table cell']
 for key in ['awake','dirty','lastMinute','lastSample']:
  if key in cells:
   i=cells.index(key);lines.append(key+': '+cells[i+2])
 pathlib.Path(path).write_text('\n'.join(lines)+'\n');print('\n'.join(lines[:10]))
