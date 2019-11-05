//////////
//
//	File:		QTUtilities.h
//
//	Contains:	Useful utilities for working with QuickTime movies.
//				All utilities start with the prefix "QTUtils_".
//
//	Written by:	Tim Monroe
//				Based heavily on the DTSQTUtilities package by Apple DTS.
//				This is essentially a subset of that package, revised for cross-platform use.
//
//	Copyright:	© 1996-1998 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <1>	 	09/10/97	rtm		first file
//
//////////

// Ported from Apple's QTUtilities.c to QT4Delphi by G.Birbilis
// History of porting to Delphi:
//      ?????1998 - ported till PrintMoviePICT (this last one not fully)
//      18Jan1999 - ported PrintMoviePICT too
//      30Jan1999 - ported all the rest of the routines
//      31Jan1999 - ported the eQTUPICTPrinting C enum name as a Pascal range type
//       6Feb1999 - corrected FCC_TVOD implementation at SaveMovie proc
//       7Mar1999 - not using the QuickTime unit anymore, but using qt_MacTypes and C_Types
//      21Jan2002 - using new FOUR_CHAR_CODE type
//      23May2002 - added "ConvertCToPascalString" function from QTUtilities.c (version 8Oct2000)
//      26Jun2002 - changed usage of SFTypeList at GetMovie to match newer headers

unit QTUtils; //named as QTUtils and removed the QTUtils_ prefix from all routines

interface
 uses
  C_Types,
  qt_Script,
  qt_MacTypes,
  qt_Movies,
  qt_ImageCompression,
  qt_Files;

// constants

// constants used for QTUtils_PrintMoviePICT
const kPrintFrame=1;
      kPrintPoster=2;
type eQTUPICTPrinting=kPrintFrame..kPrintPoster;

// constants used for QTUtils_GetMovieFileLoopingInfo
const	kNormalLooping				= 0;
	kPalindromeLooping			= 1;
	kNoLooping				= 2;

const kQTVideoEffectsMinVers=$0300;		// version of QT that first supports QT video effects
const kQTFullScreenMinVers=$0209;		// version of QT that first supports full-screen calls
const kQTWiredSpritesMinVers=$0300;		// version of QT that first supports wired sprites

// function prototypes
function IsQuickTimeInstalled:Boolean;
function GetQTVersion:long;
function HasQuickTimeVideoEffects:Boolean;
function HasFullScreenSupport:Boolean;
function HasWiredSprites:Boolean;
function GetMovie(theFSSpec:FSSpecPtr;theRefNum:shortPtr;theResID:shortPtr):Movie;
function SaveMovie(theMovie:Movie):OSErr;
function IsMediaTypeInMovie(theMovie:Movie;theMediaType:OSType):Boolean;
function MovieHasSoundTrack(theMovie:Movie):Boolean;
function GetSoundMediaHandler(theMovie:Movie):MediaHandler;
function PrintMoviePICT(theMovie:Movie;x,y:short;PICTUsed:long):OSErr;
{$ifdef TARGET_OS_MAC}{$ifdef powerc}function IsQuickTimeCFMInstalled:Boolean;{$endif}{$endif}
function SelectAllMovie (theMC:MovieController):OSErr;
function MakeSampleDescription(theEffectType:long;theWidth,theHeight:short):ImageDescriptionHandle;
function AddUserDataTextToMovie(theMovie:Movie;theText:shortString;theType:OSType):OSErr; //Delphi: shortString??? (it's only 255 chars long)
function AddCopyrightToMovie(theMovie:Movie;theText:PChar):OSErr;
function AddMovieNameToMovie(theMovie:Movie; theText:PChar):OSErr;
function AddMovieInfoToMovie(theMovie:Movie;theText:PChar):OSErr;
function GetMovieFileLoopingInfo(theMovie:Movie;theLoopInfo:longPtr):OSErr;
function SetMovieFileLoopingInfo(theMovie:Movie;theLoopInfo:long):OSErr;
function SetLoopingStateFromFile (theMovie:Movie;theMC:MovieController):OSErr;
procedure ConvertFloatToBigEndian(theFloat:floatPtr);
function ConvertCToPascalString(theString:pchar):StringPtr;

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
  qt_Endian;

//////////
//
//	File:		QTUtilities.c
//
//	Contains:	Some utilities for working with QuickTime movies.
//				All utilities start with the prefix "QTUtils_".
//
//	Written by:	Tim Monroe
//				Based heavily on the DTSQTUtilities package by Apple DTS.
//				This began as essentially a subset of that package, revised for cross-platform use.
//
//	Copyright:	© 1996-1998 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <9>	 	02/28/98	rtm		fixed QTUtils_GetMovieFileLoopingInfo and the like
//	   <8>	 	01/14/98	rtm		added QTUtils_ConvertFloatToBigEndian
//	   <7>	 	12/19/97	rtm		added QTUtils_AddUserDataTextToMovie and associated routines;
//									added QTUtils_GetMovieFileLoopingInfo and the like
//	   <6>	 	11/06/97	rtm		added QTUtils_MakeSampleDescription
//	   <5>	 	10/29/97	rtm		modified QTUtils_IsMediaTypeInMovie and similar routines to use GetMovieIndTrackType
//	   <4>	 	10/27/97	rtm		added QTUtils_HasQuickTimeVideoEffects
//	   <3>	 	10/17/97	rtm		added QTUtils_MovieHasSoundTrack
//	   <2>	 	09/23/97	rtm		added endian adjustment to QTUtils_PrintMoviePICT
//	   <1>	 	09/10/97	rtm		first file
//
//////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// General utilities.
//
// Use these functions to get information about the availability/features of QuickTime or other services.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// QTUtils_IsQuickTimeInstalled
// Is QuickTime installed?
//
//////////

function IsQuickTimeInstalled;
var myAttrs:long;
begin
 if (Gestalt(gestaltQuickTime, myAttrs) = noErr)
  then result:=true
  else result:=false;
end;

//////////
//
// QTUtils_GetQTVersion
// Get the version of QuickTime installed.
// The high-order word of the returned long integer contains the version number,
// so you can test a version like this:
//
//		if ((QTUtils_GetQTVersion() >> 16) & 0xffff >= 0x0210)		// we require QT 2.1 or greater
//			return;
//
//////////

function GetQTVersion:long;
var myVersion:long;
begin
 myVersion := 0; //?
 if (Gestalt(gestaltQuickTime, myVersion) = noErr)
  then result:=myVersion
  else result:=0;
end;

//////////
//
// QTUtils_HasQuickTimeVideoEffects
// Does the installed version of QuickTime support video effects?
//
//////////

function HasQuickTimeVideoEffects;
begin
 result:=(((GetQTVersion shr 16) and $ffff) >= kQTVideoEffectsMinVers);
end;

//////////
//
// QTUtils_HasFullScreenSupport
// Does the installed version of QuickTime support the full-screen routines?
//
//////////

function HasFullScreenSupport;
begin
 result:=(((GetQTVersion shr 16) and $ffff) >= kQTFullScreenMinVers);
end;

//////////
//
// QTUtils_HasWiredSprites
// Does the installed version of QuickTime support wired sprites?
//
//////////

function HasWiredSprites;
begin
 result:=(((GetQTVersion shr 16) and $ffff) >= kQTWiredSpritesMinVers);
end;


//////////
//
// QTUtils_GetMovie
// Open the specified movie file; if none is specified, query the user to select a file.
//
//////////

function GetMovie(theFSSpec:FSSpecPtr;theRefNum:shortPtr;theResID:shortPtr):Movie;
var myTypeList:SFTypeList;
    myReply:StandardFileReply;
    myMovie:Movie;
    myErr:OSErr;
    myMovieName:ShortString{255};
    wasChanged:Boolean;
begin
 myTypeList[0]:= MovieFileType; //next 3 values not needed since we pass a count of 1 as second param at StandardGetFilePreview
 myMovie := nil;
 //myErr := noErr; //not needed, cause we are doing myErr:=OpenMovieFile... below

 // if we are provided with an FSSpec then use it; otherwise elicit a file from the user
 if ((theFSSpec = nil) or (theFSSpec^.vRefNum = 0)) then
  begin
  StandardGetFilePreview(nil, 1, ConstSFTypeListPtr(@myTypeList), myReply);
  if (not myReply.sfGood) then
   begin
   result:=nil;
   exit;
   end;
  theFSSpec^ := myReply.sfFile;
  end;

 // we should have now a usable FSSpec; just double check this before continuing
 if (theFSSpec = nil) then
  begin
  result:=nil;
  exit;
  end;

 // open the movie file shortString
 FSMakeFSSpec(0,0,@theFSSpec.name,theFSSpec); //Birb (maybe should move to the bottom of the 1st if-block

 myErr := OpenMovieFile(theFSSpec^, theRefNum^, fsRdPerm);
 if (myErr = noErr) then
  begin
  theResID^ := 0; // we want the first movie
  myErr := NewMovieFromFile(myMovie, theRefNum^, theResID, @myMovieName, newMovieActive, @wasChanged);
  CloseMovieFile(theRefNum^);
  end;

 if (myErr <> noErr)
  then result:=nil
  else result:=myMovie;
end;

//////////
//
// QTUtils_SaveMovie
// Save and flatten a movie resource into a file.
//
// QTUtils_SaveMovie will provide a user dialog asking for a file name, and will then save the movie
// into this file. Note that this function will also automatically flatten the movie so that it's
// self-contained, and also make it cross-platform (by adding any possible resource forks to
// the end of the data fork). The default name of the movie is also NEWMOVIE.MOV, this reflects
// the way movie file names should be named for cross-platform support (Windows). The default
// creator type is also 'TVOD' so that MoviePlayer will be the default application that opens the
// movie file. If there's an existing movie file with the same name, it will be deleted.
//
//////////

function SaveMovie(theMovie:Movie):OSErr;
const FCC_TVOD=(((ord('T') shl 8 +ord('V'))shl 8 +ord('O'))shl 8 +ord('D')); //FOUR_CHAR_CODE('TVOD')
var mySFReply:StandardFileReply;
    myErr:OSErr;
    prompt:ShortString;
    defaultName:ShortString;
begin
 myErr := noErr;

 if (theMovie = nil)
  then begin result:=invalidMovie; exit end;

 prompt:='Save Movie as:';
 defaultName:='NEWMOVIE.MOV';
 StandardPutFile(@prompt, @defaultName, mySFReply);
 if (mySFReply.sfGood) then begin
  FlattenMovieData(theMovie, flattenAddMovieToDataFork, mySFReply.sfFile, FCC_TVOD, smSystemScript, createMovieFileDeleteCurFile);
  myErr := GetMoviesError();
  end;

 result:=myErr;
end;


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Media utilities.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// QTUtils_IsMediaTypeInMovie
// Determine whether a specific media type is in a movie.
//
//////////

function IsMediaTypeInMovie;
begin
 result:=(GetMovieIndTrackType(theMovie, 1, theMediaType, movieTrackMediaType or movieTrackEnabledOnly) <> nil);
end;


//////////
//
// QTUtils_MovieHasSoundTrack
// Determine whether a movie contains a sound track.
//
//////////

function MovieHasSoundTrack;
begin
 result:=(GetMovieIndTrackType(theMovie, 1, AudioMediaCharacteristic, movieTrackCharacteristic or movieTrackEnabledOnly) <> nil);
end;

//////////
//
// QTUtils_GetSoundMediaHandler
// Return the sound media handler for a movie.
//
//////////

function GetSoundMediaHandler(theMovie:Movie):MediaHandler;
var myTrack:Track;
    myMedia:Media;
begin
 myTrack:=GetMovieIndTrackType(theMovie, 1, AudioMediaCharacteristic, movieTrackCharacteristic or movieTrackEnabledOnly);
 if (myTrack <> nil) then
  begin
  myMedia:=GetTrackMedia(myTrack);
  result:=GetMediaHandler(myMedia);
  exit;
  end;

 result:=nil;
end;


//////////
//
// QTUtils_PrintMoviePICT
// Print the existing movie frame pict.
//
// Note that in a real application we should put the PrStlDialog code into the Print Setup… menu
// function. The reason it's inside this function is that we use this code for quick testing of printing.
//
//////////

function PrintMoviePICT(theMovie:Movie;x,y:short;PICTUsed:long):OSErr;
var myPictHandle:PicHandle;
    myTHPrint:THPrint;
    mySavedPort:GrafPtr;
    myPrintPort:TPPrPort;
    myResult:Boolean;
    isPrinting:Boolean;
    myPictRect:Rect;
    myErr:OSErr;
label Closure;
begin
 myPictHandle := nil;
 myTHPrint := nil;
 isPrinting := false;
 myErr := noErr;

 if (theMovie = nil) then
  begin
  result:=invalidMovie;
  exit;
  end;

 GetPort(mySavedPort);

 // get the PICT to be printed, either the poster pict or the current frame pict.
 case PICTUsed of
  kPrintFrame:
   myPictHandle := GetMoviePict(theMovie, GetMovieTime(theMovie, nil{0}));
  kPrintPoster:
   myPictHandle := GetMoviePosterPict(theMovie);
  else
   goto Closure;
  end;

 if (myPictHandle = nil)
  then goto Closure;

{$ifdef TARGET_RT_LITTLE_ENDIAN}
	// change the fields of the Picture structure,
	// if the target runtime environment uses little-endian format for integers
	(myPictHandle^^).picSize = EndianS16_BtoL((myPictHandle^^).picSize);

	(myPictHandle^^).picFrame.top = EndianS16_BtoL((myPictHandle^^).picFrame.top);
	(myPictHandle^^).picFrame.left = EndianS16_BtoL((myPictHandle^^).picFrame.left);
	(myPictHandle^^).picFrame.bottom = EndianS16_BtoL((myPictHandle^^).picFrame.bottom);
	(myPictHandle^^).picFrame.right = EndianS16_BtoL((myPictHandle^^).picFrame.right);
{$endif}

	// get the Print record
	myTHPrint := THPrint(NewHandleClear(sizeof(TPrint)));
	if (myTHPrint = nil)
         then goto Closure;

	PrOpen();
	isPrinting := true;
	myErr := PrError();
	if (myErr <> noErr)
	 then goto Closure;

	PrintDefault(myTHPrint);

	// move this to Print Setup… if you want to make this look really cool
	myResult := PrStlDialog(myTHPrint);
	if (not myResult)
         then goto Closure;

	myResult := PrJobDialog(myTHPrint);
	if (not myResult)
         then goto Closure;

	myPrintPort := PrOpenDoc(myTHPrint, nil, nil);
	PrOpenPage(myPrintPort, nil);
	myErr := PrError();
	if (myErr <> noErr)
         then goto Closure;

	// print at x,y position
	myPictRect := (myPictHandle^^).picFrame;
	MacOffsetRect(myPictRect, x - myPictRect.left,  y - myPictRect.top);

	DrawPicture(myPictHandle, @myPictRect);

	// if you want to do additional drawing, do it here.

	PrClosePage(myPrintPort);
	PrCloseDoc(myPrintPort);
	myErr := PrError();
	if (myErr <> noErr)
         then goto Closure;

	if ((myTHPrint^^).prJob.bJDocLoop = bSpoolLoop)
         then PrPicFile(myTHPrint, nil, nil, nil, nil);

	// our closure handling
Closure:
	MacSetPort(mySavedPort);

	if (isPrinting)
         then PrClose();
	if (myPictHandle<>nil)
         then KillPicture(myPictHandle);
	if (myTHPrint<>nil)
         then DisposeHandle(Handle(myTHPrint));

	result:=myErr;
end;

//////////
//
// QTUtils_IsQuickTimeCFMInstalled
// Are the QuickTime CFM libraries installed?
//
//////////

{$ifdef TARGET_OS_MAC}
{$ifdef powerc}
function IsQuickTimeCFMInstalled;
var myQTCFMAvail:Boolean = false;
    myAttrs:long;
    myErr:OSErr=noErr;
begin
	// test whether the library is registered.
	myErr := Gestalt(gestaltQuickTimeFeatures, @myAttrs);
	if (myErr = noErr) then
		if (myAttrs and (long(1) shl gestaltPPCQuickTimeLibPresent)) then
			myQTCFMAvail := true;

	// test whether a function is available (the library is not moved from the Extension folder);
	// this is the trick to be used when testing if a function is available via CFM
	if (not CompressImage)
		myQTCFMAvail := false;

	result:=myQTCFMAvail;
}
{$endif} // powerc
{$endif}

//////////
//
// QTUtils_SelectAllMovie
// Select the entire movie associated with the specified movie controller.
//
//////////

function SelectAllMovie (theMC:MovieController):OSErr;
var myTimeRecord:TimeRecord;
    myMovie:Movie;
    myErr:OSErr;
begin
//myMovie := nil;
//myErr := noErr;

 if (theMC = nil) then
  begin
  result:=paramErr;
  exit;
  end;

 myMovie := MCGetMovie(theMC);
 if (myMovie = nil) then
  begin
  result:=paramErr;
  exit;
  end;

 myTimeRecord.value.hi := 0;
 myTimeRecord.value.lo := 0;
 myTimeRecord.base := TimeBase(0);
 myTimeRecord.scale := GetMovieTimeScale(myMovie);
 myErr := GetMoviesError();
 if (myErr <> noErr) then
  begin
  result:=myErr;
  exit;
  end;

 myErr := MCDoAction(theMC, mcActionSetSelectionBegin, @myTimeRecord);
 if (myErr <> noErr) then
  begin
  result:=myErr;
  exit;
  end;

 myTimeRecord.value.lo := GetMovieDuration(myMovie);
 myErr := GetMoviesError();
 if (myErr <> noErr) then
  begin
  result:=myErr;
  exit;
  end;

 myErr := MCDoAction(theMC, mcActionSetSelectionDuration, @myTimeRecord);

 result:=myErr;
end;

//////////
//
// QTUtils_MakeSampleDescription
// Return a new image description with default and specified values.
//
//////////

function MakeSampleDescription(theEffectType:long;theWidth,theHeight:short):ImageDescriptionHandle;
var mySampleDesc:ImageDescriptionHandle;
  //myErr:OSErr;
begin
//mySampleDesc := nil;
//myErr := noErr;

 // create a new sample description
 mySampleDesc := ImageDescriptionHandle(NewHandleClear(sizeof(ImageDescription)));
 if (mySampleDesc = nil) then
  begin result:=nil; exit; end;

 // fill in the fields of the sample description
 mySampleDesc^^.idSize := sizeof(ImageDescription); //Delphi3 compiler bug: "(mySampleDesc^^).idSize := sizeof(ImageDescription);" says "Left side cannot be assigned to"
 mySampleDesc^^.cType := theEffectType;
 mySampleDesc^^.vendor := kAppleManufacturer;
 mySampleDesc^^.temporalQuality := codecNormalQuality;
 mySampleDesc^^.spatialQuality := codecNormalQuality;
 mySampleDesc^^.width := theWidth;
 mySampleDesc^^.height := theHeight;
 mySampleDesc^^.hRes := long(72) shl 16;
 mySampleDesc^^.vRes := long(72) shl 16;
 mySampleDesc^^.dataSize := long(0);
 mySampleDesc^^.frameCount := 1;
 mySampleDesc^^.depth := 24;
 mySampleDesc^^.clutID := -1;

 result:=mySampleDesc;
end;


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// User data utilities.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// QTUtils_AddUserDataTextToMovie
// Add a user data item, of the specified type, containing the specified text to a movie.
//
// This function adds the specified text to the movie's user data;
// the updated user data is written to the movie file when the movie is next updated
// (by calling UpdateMovieResource).
//
//////////

function AddUserDataTextToMovie(theMovie:Movie;theText:shortString;theType:OSType):OSErr;
var myUserData:UserData;
    myHandle:Handle;
    myIndex:short;
    myErr:OSErr;
begin
 myIndex := 0;
// myErr := noErr;

 // get the movie's user data list
 myUserData := GetMovieUserData(theMovie);
 if (myUserData = nil) then
  begin result:=paramErr; exit; end;

 // copy the specified text into a new handle
 myHandle := NewHandleClear(integer(theText[0]));
 if (myHandle = nil) then
  begin result:=MemError(); exit; end;

 BlockMove(@theText[1], myHandle^, integer(theText[0]));

 // for simplicity, we assume that we want only one user data item of the specified type in the movie;
 // as a result, we won't worry about overwriting any existing item of that type....
 //
 // if you need multiple user data items of a given type (for example, a copyright notice
 // in several different languages), you would need to modify this code; this is left as an exercise
 // for the reader....

 // add the data to the movie's user data
 myErr := AddUserDataText(myUserData, myHandle, theType, myIndex + 1, smSystemScript);

 // clean up
 DisposeHandle(myHandle);
 result:=myErr;
end;


//////////
//
// QTUtils_AddCopyrightToMovie
// Add a user data item containing the specified copyright text to a movie.
//
//////////

function AddCopyrightToMovie(theMovie:Movie;theText:PChar):OSErr;
begin
 result:=AddUserDataTextToMovie(theMovie, theText, kUserDataTextCopyright);
end;


//////////
//
// QTUtils_AddMovieNameToMovie
// Add a user data item containing the specified name to a movie.
//
//////////

function AddMovieNameToMovie(theMovie:Movie; theText:PChar):OSErr;
begin
 result:=AddUserDataTextToMovie(theMovie, theText, kUserDataTextFullName);
end;


//////////
//
// QTUtils_AddMovieInfoToMovie
// Add a user data item containing the specified information to a movie.
//
//////////

function AddMovieInfoToMovie(theMovie:Movie;theText:PChar):OSErr;
begin
 result:=AddUserDataTextToMovie(theMovie, theText, kUserDataTextInformation);
end;

//////////
//
// QTUtils_GetMovieFileLoopingInfo
// Get the looping state of a movie file.
//
// A movie file can have information about its looping state in a user data item of type 'LOOP'.
// If the movie doesn't contain an item of this type, then we'll assume that it isn't looping.
// If it does contain an item of this type, then the item data (a long integer) is 0 for normal
// looping and 1 for palindrome looping. Accordingly, this function returns the following values
// in the theLoopInfo parameter:
//
//		0 == normal looping
//		1 == palindrome looping
//		2 == no looping
//
//////////

const LOOP=(((ord('L') shl 8 +ord('O'))shl 8 +ord('O'))shl 8 +ord('P'));

function GetMovieFileLoopingInfo(theMovie:Movie;theLoopInfo:longPtr):OSErr;
var myUserData:UserData;
    myInfo:long;
    myErr:OSErr;
label bail;
begin
 myInfo := kNoLooping;
 myErr := paramErr;

 // make sure we've got a movie
 if (theMovie = nil) then
         goto bail;

 // get the movie's user data list
 myUserData := GetMovieUserData(theMovie);
 if (myUserData <> nil) then
         myErr := GetUserDataItem(myUserData, myInfo, sizeof(myInfo), LOOP, 0);

bail:
 theLoopInfo^ := myInfo;

 result:=myErr;
end;

//////////
//
// QTUtils_SetMovieFileLoopingInfo
// Set the looping state for a movie file.
//
//////////

function SetMovieFileLoopingInfo(theMovie:Movie;theLoopInfo:long):OSErr;
var myUserData:UserData;
    myCount:short;
    myErr:OSErr;
label bail;
begin
//    myCount := 0;
    myErr := paramErr;

	// get the movie's user data
    myUserData := GetMovieUserData(theMovie);
	if (myUserData = nil) then
		goto bail;

	// we want to end up with at most one user data item of type 'LOOP',
	// so let's remove any existing ones
    myCount := CountUserDataType(myUserData, LOOP);

    while (myCount<>0) do //??? myCount--
     begin
     dec(myCount);
        RemoveUserData(myUserData, LOOP, 1);
     end;

	case (theLoopInfo) of
         kNormalLooping,
	 kPalindromeLooping:
			myErr := SetUserDataItem(myUserData, theLoopInfo, sizeof(long), LOOP, 0);
	 //kNoLooping,
  	 else myErr := noErr;
	end;

bail:
	result:=myErr;
end;

//////////
//
// QTUtils_SetLoopingStateFromFile
// Set the looping state for a movie based on the looping information in the movie file.
//
//////////

function SetLoopingStateFromFile (theMovie:Movie;theMC:MovieController):OSErr;
var myLoopInfo:long;
    myErr:OSErr;
begin
//myErr:=noErr;

 myErr := GetMovieFileLoopingInfo(theMovie, @myLoopInfo);
 case (myLoopInfo) of
  kNormalLooping: begin
                  MCDoAction(theMC, mcActionSetLooping, pointer(true));
                  MCDoAction(theMC, mcActionSetLoopIsPalindrome, pointer(false));
                  end;
  kPalindromeLooping:
                  begin
                  MCDoAction(theMC, mcActionSetLooping, pointer(true));
                  MCDoAction(theMC, mcActionSetLoopIsPalindrome, pointer(true));
                  end;
  //kNoLooping,
  else
                 MCDoAction(theMC, mcActionSetLooping, pointer(false));
                 MCDoAction(theMC, mcActionSetLoopIsPalindrome, pointer(false));
  end;

 result:=myErr;
end;

//////////
//
// QTUtils_ConvertFloatToBigEndian
// Convert the specified floating-point number to big-endian format.
//
//////////

procedure ConvertFloatToBigEndian(theFloat:floatPtr);
var myLongPtr:^cardinal; //unsigned long *
begin
 myLongPtr := pointer(theFloat);
 myLongPtr^ := EndianU32_NtoB(myLongPtr^);
end;

//////////
//
// QTUtils_ConvertCToPascalString
// Convert a C string into a Pascal string.
//
// The caller is responsible for disposing of the pointer returned by this function (by calling free).
//
//////////

function ConvertCToPascalString(theString:pchar):StringPtr;
var myString:StringPtr;
    myIndex:short;
begin
 myString := AllocMem(min(strlen(theString) + 1, 256)); //C's "malloc" is "AllocMem" in Delphi
 myIndex := 0;

 while ((theString[myIndex] <> #0) and (myIndex < 255)) do
  begin
  myString^[myIndex + 1] := theString[myIndex];
  inc(myIndex);
  end;

 myString^[0] := unsigned_char(myIndex);

 result:=myString;
end;

//////////
//
// QTUtils_DeleteAllReferencesToTrack
// Delete all existing track references to the specified track.
//
//////////

(*
function DeleteAllReferencesToTrack(theTrack:Track):OSErr;
begin
  Movie        myMovie = NULL;
  Track        myTrack = NULL;
  long        myTrackCount = 0L;
  long        myTrRefCount = 0L;
  long        myTrackIndex;
  long        myTrRefIndex;
  OSErr        myErr = noErr;

  myMovie = GetTrackMovie(theTrack);
  if (myMovie == NULL)
    return(paramErr);

  // iterate thru all the tracks in the movie (that are different from the specified track)
  myTrackCount = GetMovieTrackCount(myMovie);
  for (myTrackIndex = 1; myTrackIndex <= myTrackCount; myTrackIndex++) {
    myTrack = GetMovieIndTrack(myMovie, myTrackIndex);
    if ((myTrack != NULL) && (myTrack != theTrack)) {
      OSType    myType = 0L;
  
      // iterate thru all track reference types contained in the current track
      myType = GetNextTrackReferenceType(myTrack, myType);
      while (myType != 0L) {

        // iterate thru all track references of the current type;
        // note that we count down to 1, since DeleteTrackReference will cause
        // any higher-indexed track references to be renumbered
        myTrRefCount = GetTrackReferenceCount(myTrack, myType);
        for (myTrRefIndex = myTrRefCount; myTrRefIndex >= 1; myTrRefIndex--) {
          Track  myRefTrack = NULL;

          myRefTrack = GetTrackReference(myTrack, myType, myTrRefIndex);
          if (myRefTrack == theTrack)
            myErr = DeleteTrackReference(myTrack, myType, myTrRefIndex);
        }

        myType = GetNextTrackReferenceType(myTrack, myType);
      }
    }
  }

  return(myErr);
}
*)

end.

