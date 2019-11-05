(*

(C) Copyright 2000 - 2007 Apple Computer, Inc. All rights reserved.

IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc. ("Apple") in
consideration of your agreement to the following terms, and your use, installation,
modification or redistribution of this Apple software constitutes acceptance of these
terms.  If you do not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject to these
terms, Apple grants you a personal, non-exclusive license, under Apple's copyrights in
this original Apple software (the "Apple Software"), to use, reproduce, modify and
redistribute the Apple Software, with or without modifications, in source and/or binary
forms; provided that if you redistribute the Apple Software in its entirety and without
modifications, you must retain this notice and the following text and disclaimers in all
such redistributions of the Apple Software. Neither the name, trademarks, service marks
or logos of Apple Computer, Inc. may be used to endorse or promote products derived from
the Apple Software without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or implied, are
granted by Apple herein, including but not limited to any patent rights that may be
infringed by your derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO WARRANTIES,
EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF
NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE
APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE
USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER
CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT
LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*)

// Ported from Apple's QTUtilities.c to QT4Delphi by G.Birbilis (http://www.zoomicon.com)
// History of porting to Delphi:
//  23Dec2009: first port

unit QTTimeCode; //named as QTTimeCode and removed the QTTC_ prefix from all routines

interface
 uses
  C_Types,
  //qt_Script,
  qt_MacTypes,
  qt_Movies
  //qt_ImageCompression,
  //qt_Files
  ;

//////////
//
// constants
//
//////////

const
 kTimeCodeTrackSize	  = (20 shl 16);				// initial height of timecode track

 kTimeCodeDialogID		= 200;
 kTimeCodeAlertID			= 201;

 kItemSrcName					= 4;
 kItemDisplayTimeCode = 5;
 kItemTimeScale			  =	7;
 kItemFrameDur			  =	9;
 kItemNumFrames				=	11;

 kItemUseTC					  = 12;
 kItemUseCounter			=	13;

 kItemDropFrame		  = 14;
 kItem24Hour			  =	(kItemDropFrame + 1);
 kItemNegOK					=	(kItem24Hour + 1);
 kItemIsNeg					=	(kItemNegOK + 2);
 kItemHours					=	(kItemIsNeg + 1);
 kItemMinutes				=	(kItemHours + 1);
 kItemSeconds				=	(kItemMinutes + 1);
 kItemFrames				=	(kItemSeconds + 1);

 kItemCounter					 = 24;
 kItemBelowVideo			 = 25;
 kFontPopUpMenuControl = 26;

 kFontPopUpResID			 = 1000;

{$ifdef TARGET_OS_MAC}
   kTextBigSize				 = 20;
   kTextRegSize				 = 12;
{$else} //TARGET_OS_WIN32
   kTextBigSize				 = 70;
   kTextRegSize				 = 12;
{$endif}

 // function prototypes
 procedure DeleteTimeCodeTracks(theMovie:Movie);
 function AddTimeCodeToMovie(theMovie:Movie; theType:OSType):OSErr;
 procedure ShowCurrentTimeCode(theMovie:Movie);
 procedure ShowTimeCodeSource(theMovie:Movie);
 procedure ToggleTimeCodeDisplay(theMC:MovieController);
 function GetTimeCodeMediaHandler(theMovie:Movie):MediaHandler;
 function MovieHasTimeCodeTrack(theMovie:Movie):Boolean;

implementation
 uses
  SysUtils,
  Math,
  qt_Gestalt,
  qt_StandardFile,
  qt_Errors,
  qt_QuickDraw,
  qt_Printing,
  qt_MacMemory,
  qt_Components,
  qt_Endian,
  qt_QuickTimeComponents,
  qt_ImageCompression,
  qt_QuickDrawText,
  qt_Sound,
  qt_FixMath
  ;

// This file only contains the older C Utility functions that call the QuickTime
// Timecode Media Handler - all other support functions have
// been removed as they are all deprecated.

///////////
//
// DeleteTimeCodeTracks
// Remove all existing timecode tracks from the specified movie.
//
//////////

procedure DeleteTimeCodeTracks(theMovie:Movie);
var
 myTrack:Track;
begin
    myTrack := GetMovieIndTrackType(theMovie, 1, TimeCodeMediaType, movieTrackMediaType);
    while (myTrack <> nil)  do
        begin
        DisposeMovieTrack(myTrack);
        myTrack := GetMovieIndTrackType(theMovie, 1, TimeCodeMediaType, movieTrackMediaType);
        end;
end;

//////////
//
// AddTimeCodeToMovie
// Add a timecode track to the specified movie.
//
//////////

function AddTimeCodeToMovie(theMovie:Movie; theType:OSType):OSErr;
const
 gUseTimeCode=true; //???
 gDropFrameVal=false;
 gIsNeg=false;
 g24Hour=true;
 gTimeScale=1;
 gFrameDur=1;  //???
 gNumFrames=1;
 gHours=0; //??? timecode to add
 gMinutes=0;
 gSeconds=0;
 gFrames=1;
 gCounterVal = 1; //???
 gDisplayBelowVideo = true;
var
    myTypeTrack:Track;
    myTrack:Track;
    myMedia:Media;
    myHandler:MediaHandler;
    myTCDef:TimeCodeDef;
    myTCRec:TimeCodeRecord;
    myString:Str63;
    myDuration:TimeValue;
    myMatrix:MatrixRecord;
    myWidth:Fixed;
    myHeight:Fixed;
    myTCHeight:Fixed;
    myFlags:long;
    myTextOptions:TCTextOptions;
    myFontInfo:FontInfo;
    myDesc:TimeCodeDescriptionHandle;
    myFrameHandle:longHandle;
    myErr:OSErr;
    mySize:long;
    myUserData:UserData;
    myNameHandle: Handle;
label bail;
begin
    myErr := noErr;
    myNameHandle := nil;

    //////////
    //
    // find the target track
    //
    //////////

    // get the (first) track of the specified type; this track determines the width of the new timecode track
    myTypeTrack := GetMovieIndTrackType(theMovie, 1, theType, movieTrackMediaType);
    if (myTypeTrack = nil)  then
        begin
        myErr := trackNotInMovie;
        goto bail;
        end;

    // get the dimensions of the target track
    GetTrackDimensions(myTypeTrack, myWidth, myHeight);
    
    //////////
    //
    // create the timecode track and media
    //
    //////////

    myTrack := NewMovieTrack(theMovie, myWidth, kTimeCodeTrackSize, kNoVolume);
    if (myTrack = nil) then
        goto bail;

    myMedia := NewTrackMedia(myTrack, TimeCodeMediaType, GetMovieTimeScale(theMovie), nil, 0);
    if (myMedia = nil) then
        goto bail;

    myHandler := GetMediaHandler(myMedia);
    if (myHandler = nil) then
        goto bail;

    //////////
    //
    // fill in a timecode definition structure; this becomes part of the timecode description
    //
    //////////

    // set the timecode format information flags
    if (gUseTimeCode) then
        begin
        myFlags := 0;
        if (gDropFrameVal) then
            myFlags := myFlags or tcDropFrame;
        if (gIsNeg) then
            myFlags := myFlags or tcNegTimesOK;
        if (g24Hour) then
            myFlags := myFlags or tc24HourMax;
        end
    else
        myFlags := tcCounter;
     
    myTCDef.flags := myFlags;
    myTCDef.fTimeScale := gTimeScale;
    myTCDef.frameDuration := gFrameDur;
    myTCDef.numFrames := gNumFrames;

    //////////
    //
    // fill in a timecode record
    //
    //////////
    
    if (gUseTimeCode)  then
        begin
        myTCRec.t.hours := UInt8(gHours);
        myTCRec.t.minutes := UInt8(gMinutes);        // negative flag is here
        myTCRec.t.seconds := UInt8(gSeconds);
        myTCRec.t.frames := UInt8(gFrames);
        if (gIsNeg) then
            with myTCRec.t do minutes := minutes or tctNegFlag
        else
            myTCRec.c.counter := gCounterVal;

    //////////
    //
    // figure out the timecode track geometry
    //
    //////////
    
    // get display options to calculate box height
    TCGetDisplayOptions(myHandler, myTextOptions);
    //???//GetFNum(gFontName, myTextOptions.txFont);
    TCSetDisplayOptions(myHandler, @myTextOptions);
    
    // use the starting time to figure out the dimensions of track    
    TCTimeCodeToString(myHandler, myTCDef, myTCRec, @myString);
//???//    TextFont(myTextOptions.txFont);
//???//    TextFace(myTextOptions.txFace);
//???//    TextSize(myTextOptions.txSize);
    GetFontInfo(myFontInfo);
    
    // calculate track width and height based on text    
    myTCHeight := FixRatio(myFontInfo.ascent + myFontInfo.descent + 2, 1);
    SetTrackDimensions(myTrack, myWidth, myTCHeight);

    GetTrackMatrix(myTrack, myMatrix);
    if (gDisplayBelowVideo) then
        TranslateMatrix(myMatrix, 0, myHeight);

    SetTrackMatrix(myTrack, myMatrix);
    SetTrackEnabled(myTrack, gDisplayTimeCode);
        
    if gDisplayTimeCode then 
       TCSetTimeCodeFlags(myHandler,  tcdfShowTimeCode, tcdfShowTimeCode);
    else
       TCSetTimeCodeFlags(myHandler,  0, tcdfShowTimeCode);

    //////////
    //
    // edit the track media
    //
    //////////

    myErr := BeginMediaEdits(myMedia);    
    if (myErr = noErr)  then
        begin
        
        //////////
        //
        // create and configure a new timecode description handle
        //
        //////////

        mySize := sizeof(TimeCodeDescription);
        myDesc := TimeCodeDescriptionHandle(NewHandleClear(mySize));
        if (myDesc = nil) then
            goto bail;
        
        ( **myDesc).descSize := mySize; //???
        ( **myDesc).dataFormat := TimeCodeMediaType;
        ( **myDesc).timeCodeDef := myTCDef;
        
        //////////
        //
        // set the source identification information
        //
        //////////

        // the source identification information for a timecode track is stored
        // in a user data item of type TCSourceRefNameType
        myErr := NewUserData(myUserData);
        if (myErr = noErr)  then
            begin
            myErr := PtrToHand(@gSrcName[1], myNameHandle, gSrcName[0]);
            if (myErr = noErr)  then
                begin
                myErr := AddUserDataText(myUserData, myNameHandle, TCSourceRefNameType, 1, langEnglish);
                if (myErr = noErr) then
                    TCSetSourceRef(myHandler, myDesc, myUserData);
                end;
            
            if (myNameHandle <> nil) then
                DisposeHandle(myNameHandle);
                
            DisposeUserData(myUserData);
            end;

        //////////
        //
        // add a sample to the timecode track
        //
        // each sample in a timecode track provides timecode information for a span of movie time;
        // here, we add a single sample that spans the entire movie duration
        //
        //////////

        // the sample data contains a frame number that identifies one or more content frames
        // that use the timecode; this value (a long integer) identifies the first frame that
        // uses the timecode
        myFrameHandle := (long **)NewHandle(sizeof(long));
        if (myFrameHandle = nil) then
            goto bail;

        myErr := TCTimeCodeToFrameNumber(myHandler, &( **myDesc).timeCodeDef, &myTCRec, *myFrameHandle);

        // the data in the timecode track must be big-endian
        **myFrameHandle = EndianS32_NtoB( **myFrameHandle);

        myDuration := GetMovieDuration(theMovie);
        // since we created the track with the same timescale as the movie,
        // we don't need to convert the duration

        myErr := AddMediaSample(myMedia, Handle(myFrameHandle), 0, GetHandleSize(Handle(myFrameHandle)), myDuration, SampleDescriptionHandle(myDesc), 1, 0, 0);
        if (myErr <> noErr) then
            goto bail;
    end;

    myErr := EndMediaEdits(myMedia);
    if (myErr <> noErr) then
        goto bail;

    myErr := InsertMediaIntoTrack(myTrack, 0, 0, myDuration, fixed1);
    if (myErr <> noErr) then
        goto bail;

    //////////
    //
    // create a track reference from the target track to the timecode track
    //
    //////////

    myErr := AddTrackReference(myTypeTrack, myTrack, TimeCodeMediaType, nil);

bail:
    if (myDesc <> nil)
        DisposeHandle(Handle(myDesc));

    if (myFrameHandle <> nil) then
        DisposeHandle(Handle(myFrameHandle));

    result := myErr;
end;

//////////
//
// ShowCurrentTimeCode 
// Show (in an alert box) the timecode value for the current movie time.
//
//////////

procedure ShowCurrentTimeCode(theMovie:Movie);
var
    myHandler:MediaHandler;
    myErr:HandlerError=noErr;
    myTCDef:TimeCodeDef;
    myTCRec:TimeCodeRecord;
     myString:Str255;
begin
    myHandler := GetTimeCodeMediaHandler(theMovie);
    if (myHandler <> nil)  then
        begin
    
        // get the timecode for the current movie time
        myErr := TCGetCurrentTimeCode(myHandler, nil, myTCDef, myTCRec, nil);
        if (myErr = noErr)  then
            begin
            myErr := TCTimeCodeToString(myHandler, myTCDef, myTCRec, myString);
            if (myErr = noErr) then
                // do something with the string //!!!
            end;
        end;
end;

//////////
//
// ShowTimeCodeSource
// Show (in an alert box) the timecode source for the specified movie.
//
//////////

procedure ShowTimeCodeSource(theMovie:Movie);
var
    myHandler:MediaHandler;
    myErr:HandlerError;
    myUserData:UserData;
    myString:Str255;
    myNameHandle:Handle;
begin
    myHandler := GetTimeCodeMediaHandler(theMovie);
    if (myHandler <> nil)  then
        begin
    
        // get the timecode source for the current movie time
        myErr = TCGetCurrentTimeCode(myHandler, nil, nil, nil, myUserData);
        if (myErr = noErr)  then
            begin
            myString := " [No source name!]";
            myNameHandle := NewHandleClear(0);
            
            GetUserDataText(myUserData, myNameHandle, TCSourceRefNameType, 1, langEnglish);
            if (GetHandleSize(myNameHandle) > 0) then
                begin
                BlockMove( *myNameHandle, &myString[1], GetHandleSize(myNameHandle));
                myString[0] := GetHandleSize(myNameHandle);
                end;

            if (myNameHandle <> nil) then
                DisposeHandle(myNameHandle);

            // do something with the string //???

            DisposeUserData(myUserData);
            end;
       end;
end;

//////////
//
// ToggleTimeCodeDisplay
// Toggle the current state of timecode display.
//
//////////

procedure ToggleTimeCodeDisplay(theMC:MovieController);
var
    myMovie:Movie;
    myTrack:Track;
    myHandler:MediaHandler;
    myFlags:long = 0;
begin
    myMovie := MCGetMovie(theMC);

    // get the (first) timecode track in the specified movie
    myTrack := GetMovieIndTrackType(myMovie, 1, TimeCodeMediaType, movieTrackMediaType);
    if (myTrack <> nil)  then
        begin
    
        // get the timecode track's media handler
        myHandler := GetTimeCodeMediaHandler(myMovie);
        if (myHandler <> nil)  then
            begin
        
            // toggle the show-timecode flag
            TCGetTimeCodeFlags(myHandler, myFlags);
            myFlags ^= tcdfShowTimeCode; //???
            TCSetTimeCodeFlags(myHandler, myFlags, tcdfShowTimeCode);
            
            // toggle the track enabled state
            SetTrackEnabled(myTrack, not GetTrackEnabled(myTrack));
            
            // now tell the movie controller the movie has changed,
            // so that the movie rectangle gets updated correctly
            MCMovieChanged(theMC, myMovie);
            end;
         end;
end;

//////////
//
// GetTimeCodeMediaHandler 
// Get the media handler for the first timecode track in the specified movie.
//
//////////

function GetTimeCodeMediaHandler(theMovie:Movie):MediaHandler;
var
    myTrack:Track;
    myMedia:Media;
    myHandler:MediaHandler;
begin
    myHandler:=nil;

    // get the (first) timecode track in the specified movie
    myTrack := GetMovieIndTrackType(theMovie, 1, TimeCodeMediaType, movieTrackMediaType);
    if (myTrack <> nil)  then
        begin
        // get the timecode track's media and media handler
        myMedia := GetTrackMedia(myTrack);
        if (myMedia <> nil) then
            myHandler := GetMediaHandler(myMedia);
    end;

    result := myHandler;
end;

//////////
//
// MovieHasTimeCodeTrack
// Determine whether the specified movie contains a timecode track.
//
//////////

function MovieHasTimeCodeTrack(theMovie:Movie):Boolean;
begin
    result := (GetMovieIndTrackType(theMovie, 1, TimeCodeMediaType, movieTrackMediaType) <> nil);
end;

// ************ This file is for reference only and NOT used in this Sample ************
// This file only contains the older C Utility functions that call the QuickTime
// Timecode Media Handler - all other support functions have
// been removed as they are all deprecated.