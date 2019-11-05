//Version: 13Apr2002

unit QTime;

interface
 uses
  Windows,
  C_Types,
  qt_MacTypes,
  qt_Movies,
  qt_Components; //QuickTime must be last to override RECT

 function EditCut(mc:MovieController):ComponentResult;
 function EditCopy(mc:MovieController):ComponentResult;
 function EditPaste(mc:MovieController):ComponentResult;
 function EditClear(mc:MovieController):ComponentResult;
 function EditUndo(mc:MovieController):ComponentResult;
 function EditSelectAll(movie:Movie;mc:MovieController):ComponentResult;
 procedure CreateNewMovieController(hwnd:THandle{HWND}; theMovie:Movie; var theMC:MovieController);
 function MCFilter(mc:MovieController;action:short;params:pointer;refCon:long):Boolean;

implementation
 uses
  qt_Errors,
  qt_QuickDraw,
  qt_MacWindows;

function EditCut(mc:MovieController):ComponentResult;
var scrapMovie:Movie;
begin
 result:=invalidMovie;
 if (mc<>nil) then
  begin
  scrapMovie:=MCCut(mc);
  if ( scrapMovie<>nil ) then
   begin
   result:=PutMovieOnScrap(scrapMovie, 0);
   DisposeMovie(scrapMovie);
   end;
  end;
end;

function EditCopy(mc:MovieController):ComponentResult;
var scrapMovie:Movie;
begin
 result:=invalidMovie;
 if (mc<>nil) then
  begin
  scrapMovie:=MCCopy(mc);
  if ( scrapMovie<>nil ) then
   begin
   result:=PutMovieOnScrap(scrapMovie, 0);
   DisposeMovie(scrapMovie);
   end;
  end;
end;

function EditPaste(mc:MovieController):ComponentResult;
begin
 if (mc<>nil)
  then result:=MCPaste(mc, nil)
  else result:=invalidMovie;
end;

function EditClear(mc:MovieController):ComponentResult;
begin
 if (mc<>nil)
  then result:=MCClear(mc)
  else result:=invalidMovie;
end;

function EditUndo(mc:MovieController):ComponentResult;
begin
 if (mc<>nil)
  then result:=MCUndo(mc)
  else result:=invalidMovie;
end;

function EditSelectAll(movie:Movie;mc:MovieController):ComponentResult;
var tr:TimeRecord;
begin
 result:=noErr;
 if ((movie<>nil) and (mc<>nil)) then
  begin
  tr.value.hi:=0;
  tr.value.lo:=0;
  tr.base:=nil; //?
  tr.scale:=GetMovieTimeScale(movie);
  MCDoAction(mc, mcActionSetSelectionBegin, @tr);
  tr.value.lo := GetMovieDuration(movie);
  MCDoAction(mc, mcActionSetSelectionDuration, @tr);
  end
 else
  if ( movie = nil )
   then	result:=invalidMovie
   else	result:=-1;
end;

procedure GetMaxBounds(var maxRect:Rect);
var deskRect:TRect;
begin
 GetWindowRect(GetDesktopWindow(), deskRect);

 OffsetRect(deskRect, -deskRect.left, -deskRect.top);

 with maxRect do
  begin
  top := short(deskRect.top);
  bottom := short(deskRect.bottom);
  left := short(deskRect.left);
  right := short(deskRect.right);
  end;
end;

procedure CreateNewMovieController(hwnd:THandle{HWND}; theMovie:Movie; var theMC:MovieController);
var bounds:Rect;
    maxBounds:Rect;
    controllerFlags:long;
    theMovieRect:Rect;
begin
 // 0,0 Movie coordinates
 GetMovieBox(theMovie, theMovieRect);
 MacOffsetRect(theMovieRect, -theMovieRect.left, -theMovieRect.top);

 // Attach a movie controller
 theMC := NewMovieController(theMovie, @theMovieRect, mcTopLeftMovie );

 // Get the controller rect
 MCGetControllerBoundsRect(theMC, bounds);

 // Enable editing
 MCEnableEditing(theMC,TRUE);

 // Tell the controller to attach a movie's CLUT to the window as appropriate.
 MCDoAction(theMC, mcActionGetFlags, @controllerFlags);
 MCDoAction(theMC, mcActionSetFlags, pointer((controllerFlags or mcFlagsUseWindowPalette)));

 // Allow the controller to accept keyboard events
 MCDoAction(theMC, mcActionSetKeysEnabled, pointer(TRUE));

 // Set the controller action filter
 MCSetActionFilterWithRefCon(theMC, @MCFilter, long(hwnd));

 // Set the grow box amound
 GetMaxBounds(maxBounds);
 MCDoAction(theMC, mcActionSetGrowBoxBounds, @maxBounds);

 // Size our window
 SizeWindow(WindowPtr(GetNativeWindowPort(hwnd)), bounds.right, bounds.bottom, FALSE);
end;

function MCFilter(mc:MovieController;action:short;params:pointer;refCon:long):Boolean;
var bounds:Rect;
    w:WindowPtr;
begin
 if(action = mcActionControllerSizeChanged) then
  begin
  MCGetControllerBoundsRect(mc, bounds);

  w := GetNativeWindowPort(HWND(refCon)); //?
  SizeWindow(WindowPtr(w), bounds.right, bounds.bottom, TRUE);
  end;
 result:=FALSE;
end;

end.
