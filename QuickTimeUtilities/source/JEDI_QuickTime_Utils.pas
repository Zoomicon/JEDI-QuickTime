unit JEDI_QuickTime_Utils;

//JEDI quicktime utilities unit
//Author(s): George Birbilis <birbilis@kagi.com>

//history:
// 23Feb2002 - first version [George Birbilis]

interface
 uses
  Messages,
  Windows,
  qt_QuickDraw;

function GetPortFromWindowReference(theWindow:HWND):GrafPtr;
procedure WinMessageToNativeEvent(const winmsg:TMessage;var nativeEvent:TMsg);

implementation

// GetPortFromWindowReference
// Return the graphics port associated with a window reference.

function GetPortFromWindowReference;
begin
 if(theWindow<>0) then
  result:=GrafPtr(GetNativeWindowPort(theWindow)) //same as GetHWNDPort
 else
  result:=nil;
end;

//Copy info from a Windows message to a QuickTime for Windows NativeEvent record
//result goes to "nativeEvent" parameter

procedure WinMessageToNativeEvent;
var point:integer;
begin
 with nativeEvent do
  begin
  message := winmsg.msg;
  wParam := winmsg.wParam;
  lParam := winmsg.lParam;
  time := GetMessageTime();
  point := GetMessagePos();
  with pt do
   begin
   x := LOWORD(point);
   y := HIWORD(point);
   end;
  end;
end;

end.
