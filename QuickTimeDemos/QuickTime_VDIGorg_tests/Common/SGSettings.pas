unit SGSettings;

interface
 uses
  qt_QuickTimeComponents,
  qt_QuickDraw,
  qt_Events,
  C_Types;

 procedure ShowSettings(mSGComponent:SeqGrabComponent;mVideoChannel:SGChannel);

implementation
 uses
  qt_MacTypes,
  qt_MixedMode;

function SeqGrabberModalFilterProc(theDialog:DialogPtr;theEvent:EventRecordPtr;
	 itemHit:ShortPtr;refCon:long):boolean;cdecl; //#pragma unused(theDialog,itemHit,refCon)
// Ordinarily, if we had multiple windows we cared about, we'd handle
// updating them in here, but since we don't, we'll just clear out
// any update events meant for us
var handled:boolean;
begin
 handled:=false;
 if (theEvent^.what = updateEvt) then
  begin
  handled:=true;
  end;
 result:=handled;
end;

procedure ShowSettings(mSGComponent:SeqGrabComponent;mVideoChannel:SGChannel);
var seqGragModalFilterUPP:SGModalFilterUPP;
//    err:OSErr;
begin
 seqGragModalFilterUPP:={SGModalFilterUPP(NewSGModalFilterProc(}SeqGrabberModalFilterProc{))};
 {err:=}SGSettingsDialog(mSGComponent,mVideoChannel,0,nil,
                       long(0),nil, //seqGragModalFilterUPP,
		       long(nil));
 DisposeRoutineDescriptor(@seqGragModalFilterUPP);
end;

end.
