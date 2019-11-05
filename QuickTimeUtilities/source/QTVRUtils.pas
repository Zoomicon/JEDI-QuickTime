unit QTVRUtils;

(*
Porting history:
 06Mar1999 - birbilis: Began porting
 07Mar1999 - birbilis: Stopped using the QuickTime unit
 26Jun2002 - birbilis: Did some changes to work with the latest JEDI-QuickTime
 07Aug2004 - birbilis: Added "GetNodeCount", so "isMultiNode" should be working
           -           Ported "Point3DToPanAngle", "GetVRWorldHeaderAtomData",
                       "GetHotSpotAtomData", "GetNodeHeaderAtomData",
                       "GetControllerBarHeight"
*)

interface

//////////
//
//	File:		QTVRUtilities.h
//
//	Contains:	Some utilities for working with QuickTime and QuickTime VR movies.
//				All utilities start with the prefix "".
//
//	Written by:	Tim Monroe
//
//	Copyright:	© 1996-1997 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <2>	 	01/27/97	rtm		added some constants
//	   <1>	 	11/27/96	rtm		first file
//
//////////

 uses
  C_Types,
  qt_MacTypes,
  qt_Movies,
  qt_QuickTimeVR,
  qt_QuickTimeVRFormat,
  qt_Gestalt,
  {qt_WinPrefix,}
  qt_Endian,
  qt_QD3D;

// constants

 const	kQTVRSpeakerButton 		= mcFlagSuppressSpeakerButton;
	kQTVRBackButton 		= mcFlagQTVRSuppressBackBtn;
	kQTVRZoomButtons 		= mcFlagQTVRSuppressZoomBtns;
	kQTVRHotSpotButton 		= mcFlagQTVRSuppressHotSpotBtn;
	kQTVRTranslateButton 	        = mcFlagQTVRSuppressTranslateBtn;
	kQTVRHelpText 			= mcFlagQTVRSuppressHelpText;
	kQTVRHotSpotNames 		= mcFlagQTVRSuppressHotSpotNames;
	kQTVRCustomButton 		= mcFlagsUseCustomButton;

// values of ¹
 const kVRPi 				=	({(float)}3.1415926535898);
       kVR2Pi 				=	({(float)}(2.0 * 3.1415926535898));
       kVRPiOver2			=	({(float)}(3.1415926535898 / 2.0));
       kVR3PiOver2			=	({(float)}(3.0 * 3.1415926535898 / 2.0));

// define a constant for an invalid hot spot ID;
// hot spot IDs are just indices into an 8-bit palette, so valid IDs range from 0 to 255
 const kInvalidHotSpotID	= UInt32(-1);

//////////
//
// DegreesToRadians
// RadiansToDegrees
// Angle conversion utilities.
//
//////////

 function DegreesToRadians(x:float):float; //Delphi: C macro made a function
 function RadiansToDegrees(x:float):float; //Delphi: C macro made a function

// some other define'd symbols

 function GetDistance(thePoint:TQ3Point3D):float; //Delphi: C macro made a function

// function prototypes

 function IsQTVRMgrInstalled:Boolean;
 function GetQTVRVersion:long;
 function GetControllerType(theMovie:Movie):OSType;
 function SetControllerType(theMovie:Movie;theType:OSType):OSErr;
 function IsQTVRMovie(theMovie:Movie):Boolean;
 function Is20QTVRMovie(theMovie:Movie):Boolean;
 function IsTranslateAvailable(theInstance:QTVRInstance):Boolean;
 function IsZoomAvailable(theInstance:QTVRInstance):Boolean;
 function IsPanoNode(theInstance:QTVRInstance):Boolean;
 function IsObjectNode(theInstance:QTVRInstance):Boolean;
 function IsHotSpotInNode(theInstance:QTVRInstance):Boolean;
 function IsMultiNode(theInstance:QTVRInstance):Boolean;
 function IsControllerBarVisible(theMC:MovieController):Boolean;
 function getControllerBarHeight(theMC:MovieController):short;
 procedure HideControllerBar(theMC:MovieController);
 procedure ShowControllerBar(theMC:MovieController);
 procedure ToggleControllerBar(theMC:MovieController);
 procedure HideControllerButton(theMC:MovieController;theButton:long);
 procedure ShowControllerButton(theMC:MovieController;theButton:long);
 procedure ToggleControllerButton(theMC:MovieController;theButton:long);
 procedure ResetControllerButton(theMC:MovieController;theButton:long);
 function IsControllerButtonVisible(theMC:MovieController;theButton:long):Boolean;
 procedure HideHotSpotNames(theMC:MovieController);
 procedure ShowHotSpotNames(theMC:MovieController);
 procedure ToggleHotSpotNames(theMC:MovieController);
 function GetVRWorldHeaderAtomData(theInstance:QTVRInstance;theVRWorldHdrAtomPtr:QTVRWorldHeaderAtomPtr):OSErr;
 function GetNodeHeaderAtomData(theInstance:QTVRInstance;theNodeID:UInt32;theNodeHdrPtr:QTVRNodeHeaderAtomPtr):OSErr;
 function GetHotSpotAtomData(theInstance:QTVRInstance;theNodeID:UInt32;theHotSpotID:UInt32;theHotSpotInfoPtr:QTVRHotSpotInfoAtomPtr):OSErr;
 function GetStringFromAtom(theContainer:QTAtomContainer;theParent:QTAtom;theID:QTAtomID):PChar;
 function AddStr255ToAtomContainer(theContainer:QTAtomContainer;theParent:QTAtom;theString:Str255;theID:QTAtomID):OSErr;
 function GetDefaultNodeID(theInstance:QTVRInstance):UInt32;
 function GetSceneFlags(theInstance:QTVRInstance):UInt32;
(*
 function GetSceneName(QTVRInstance:theInstance):PChar;
*)
 function GetNodeCount(theInstance:QTVRInstance):UInt32;
(*
 function GetNodeType(theInstance:QTVRInstance;theNodeID:UInt32;theNodeType:OSType):OSErr;
 function GetNodeName(QTVRInstance:theInstance:;theNodeID:UInt32):PChar;
 function GetNodeComment(QTVRInstance:theInstance:;theNodeID:UInt32):PChar;
*)
 function GetHotSpotCount(theInstance:QTVRInstance;theNodeID:UInt32;theHotSpotIDs:Handle):UInt32;
 function GetHotSpotIDByIndex(theInstance:QTVRInstance;theHotSpotIDs:Handle;theIndex:UInt32):UInt32;
 function GetHotSpotType(theInstance:QTVRInstance;theNodeID:UInt32;theHotSpotID:UInt32;theHotSpotType:OSType):OSErr;
 function GetHotSpotName(theInstance:QTVRInstance;theNodeID:UInt32;theHotSpotID:UInt32):PChar;
 function Point3DToPanAngle(theX:float;theY:float;theZ:float):float;
 function Point3DToTiltAngle(theX:float;theY:float;theZ:float):float;
 function StandardEnteringNodeProc(theInstance:QTVRInstance;fromNodeID:long;toNodeID:long;var theCancel:Boolean;theMC:MovieController):OSErr; pascal; //in Delphi3 pascal isn't the default calling convention {PASCAL_RTN}
 function StandardLeavingNodeProc(theInstance:QTVRInstance;fromNodeID:long;toNodeID:long;var theCancel:Boolean;theMC:MovieController):OSErr; pascal; //in Delphi3 pascal isn't the default calling convention {PASCAL_RTN}

implementation
 uses
  Math,
  QTUtils,
  qt_Errors;

//////////
//
// DegreesToRadians
// RadiansToDegrees
// Angle conversion utilities.
//
//////////

function DegreesToRadians(x:float):float;
begin
 result:=({(float)}((x) * kVRPi / 180.0));
end;

function RadiansToDegrees(x:float):float;
begin
 result:=({(float)}((x) * 180.0 / kVRPi));
end;

// some other define'd symbols

function GetDistance(thePoint:TQ3Point3D):float;
begin
 result:=sqrt((thePoint.x*thePoint.x)+(thePoint.y*thePoint.y)+(thePoint.z*thePoint.z));
end;

//////////
//
//	File:		QTVRUtilities.c
//
//	Contains:	Some utilities for working with QuickTime and QuickTime VR movies.
//				All utilities start with the prefix "".
//
//	Written by:	Tim Monroe
//
//	Copyright:	© 1996-1998 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <21>	 	02/12/98	rtm		added HideHotSpotNames and her sisters, *Show* and *Toggle*
//	   <20>	 	01/27/98	rtm		revised IsQTVRMgrInstalled and GetQTVRVersion
//	   <19>	 	01/26/98	rtm		revised GetHotSpotName to look also in hot spot atom for name atom
//	   <18>	 	01/14/98	rtm		added SetControllerType and AddStr255ToAtomContainer
//	   <17>	 	10/20/97	rtm		added IsMultiNode; added Endian*_BtoN macros to file format routines
//	   <16>	 	10/17/97	rtm		fixed IsControllerButtonVisible behavior for speaker button
//	   <15>	 	10/07/97	rtm		added cannotFindAtomErr result code to Get*AtomData functions
//	   <14>	 	09/15/97	rtm		added ToggleControllerBar
//	   <13>	 	08/21/97	rtm		added IsControllerButtonVisible
//	   <12>	 	08/19/97	rtm		added #ifdefs to support Windows compilation
//	   <11>	 	08/05/97	rtm		added GetNodeComment; still needs testing
//	   <10>	 	07/27/97	rtm		fixed GetHotSpotCount; added GetHotSpotIDByIndex
//	   <9>	 	07/25/97	rtm		revised Get*AtomData functions to use QTCopyAtomDataToPtr;
//									rewrote GetStringFromAtom
//	   <8>	 	07/24/97	rtm		removed sound volume utilities; added IsZoomAvailable;
//									revised IsQTVRMovie to use GetUserDataItem, not GetUserData
//	   <7>	 	07/23/97	rtm		revised file format utilities; added Get*AtomData functions
//	   <6>	 	07/22/97	rtm		fixed GetHotSpotCount to make sure handle is actually resized
//	   <5>	 	07/21/97	rtm		added GetNodeCount
//	   <4>	 	06/04/97	rtm		fixed ShowControllerButton and HideControllerButton,
//									and added some explanation of them; added ResetControllerButton
//	   <3>	 	02/03/97	rtm		revised ShowControllerButton and HideControllerButton
//									to use explicit flag
//	   <2>	 	12/03/96	rtm		added controller bar utilities
//	   <1>	 	11/27/96	rtm		first file
//
//////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// General utilities.
//
// Use these functions to get information about the availability/features of QuickTime VR or other services.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// IsQTVRMgrInstalled
// Is the QuickTime VR Manager installed?
//
//////////

function IsQTVRMgrInstalled:Boolean;
var myQTVRAvail:Boolean;
    myAttrs:long;
    myErr:OSErr;
begin
 myQTVRAvail := false;

 myErr := Gestalt(gestaltQTVRMgrAttr, myAttrs);
 if (myErr = noErr) then
  if ((myAttrs and (long(1) shl gestaltQTVRMgrPresent))<>0) then
   myQTVRAvail := true;

 result:=(myQTVRAvail);
end;


//////////
//
// GetQTVRVersion
// Get the version of the QuickTime VR Manager installed.
//
// The low-order word of the returned long integer contains the version number,
// so you can test a version like this:
//
//		if (GetQTVRVersion() < 0x0210)		// we require QTVR 2.1 or greater
//			return;
//
//////////

function GetQTVRVersion:long; //Delphi: C's 0x0210 is Pascal's $210
var myVersion:long;
    myErr:OSErr;
begin
 myVersion := long(0);
 //myErr := noErr;

 myErr := Gestalt(gestaltQTVRMgrVers, myVersion);
 if (myErr = noErr) then
  result:=(myVersion)
 else
  result:=(long(0));
end;


//////////
//
// shlType
// Get the controller type of the specified movie.
//
//////////

function GetControllerType(theMovie:Movie):OSType;
var myUserData:UserData;
    myType:OSType;
begin
 myType := kQTVRUnknownType;

 // make sure we've got a movie
 if (theMovie = nil) then
  begin
  result:=(myType);
  exit;
  end;

 myUserData := GetMovieUserData(theMovie);
 if (myUserData <> nil) then
  GetUserDataItem(myUserData, myType, sizeof(myType), kQTControllerType, 0);

 result:=(EndianU32_BtoN(myType));
end;


//////////
//
// SetControllerType
// Set the controller type of the specified movie.
//
// This function adds an item to the movie's user data;
// the updated user data is written to the movie file when the movie is next updated
// (by calling AddMovieResource or UpdateMovieResource).
//
//////////

function SetControllerType(theMovie:Movie;theType:OSType):OSErr;
var myUserData:UserData;
    myErr:OSErr;
begin
//	myErr := noErr;

	// make sure we've got a movie
	if (theMovie = nil) then
		begin result:=(paramErr); exit; end;

	// get the movie's user data list
	myUserData := GetMovieUserData(theMovie);
	if (myUserData = nil) then
		begin result:=(paramErr); exit; end;

	theType := EndianU32_NtoB(theType);
	myErr := SetUserDataItem(myUserData, theType, sizeof(theType), kUserDataMovieControllerType, 0);

	result:=(myErr);
end;


//////////
//
// IsQTVRMovie
// Is the specified movie a QTVR movie?
//
// WARNING: This function is intended for use ONLY when you want to determine if you've got a QTVR movie
// but you don't want to use the QuickTime VR API (perhaps QTVR isn't installed...). The preferred way to
// determine if a movie is a QTVR movie is to call QTVRGetQTVRTrack and then QTVRGetQTVRInstance; if you
// get back a non-nil instance, you've got a VR movie.
//
//////////

function IsQTVRMovie(theMovie:Movie):Boolean;
var myIsQTVRMovie:Boolean;
    myType:OSType;
begin
	myIsQTVRMovie := false;

	// QTVR movies have a special piece of user data identifying the movie controller type
	myType := GetControllerType(theMovie);

	if ((myType = kQTVRQTVRType) or (myType = kQTVROldPanoType) or (myType = kQTVROldObjectType)) then
		myIsQTVRMovie := true;

	result:=(myIsQTVRMovie);
end;


//////////
//
// Is20QTVRMovie
// Is the specified QTVR movie version 2.0 or greater?
//
//////////

function Is20QTVRMovie(theMovie:Movie):Boolean;
var myIs20QTVRMovie:Boolean;
    myType:OSType;
begin
	myIs20QTVRMovie := false;

	// QTVR movies have a special piece of user data identifying the movie controller type
	myType := GetControllerType(theMovie);

	if (myType = kQTVRQTVRType) then
		myIs20QTVRMovie := true;

	result:=(myIs20QTVRMovie);
end;


//////////
//
// IsTranslateAvailable
// Is translation currently enabled for the specified object node?
//
//////////

function IsTranslateAvailable(theInstance:QTVRInstance):Boolean;
var myState:Boolean;
begin
 QTVRGetControlSetting(theInstance, kQTVRTranslation, myState);
 result:=(myState);
end;


//////////
//
// IsZoomAvailable
// Is zooming currently enabled for the specified object node?
//
//////////

function IsZoomAvailable(theInstance:QTVRInstance):Boolean;
var myState:Boolean;
begin
 QTVRGetControlSetting(theInstance, kQTVRCanZoom, myState);
 result:=(myState);
end;


//////////
//
// IsPanoNode
// Is the specified node a panoramic node?
//
//////////

function IsPanoNode(theInstance:QTVRInstance):Boolean;
begin
 result:=(QTVRGetNodeType(theInstance, kQTVRCurrentNode) = kQTVRPanoramaType);
end;


//////////
//
// IsObjectNode
// Is the specified node an object node?
//
//////////

function IsObjectNode(theInstance:QTVRInstance):Boolean;
begin
 result:=(QTVRGetNodeType(theInstance, kQTVRCurrentNode) = kQTVRObjectType);
end;


//////////
//
// IsHotSpotInNode
// Does the specified node contain at least one hot spot (whether visible, enabled, or whatever)?
//
// NOTE: This is not an easy function to implement using just the QTVR 2.1 API. We do have our own
// utility GetHotSpotCount, but that function returns the number of hot spot information atoms
// in the node, which is not (necessarily) the number of hot spot regions in the hot spot image track.
// For panoramas, we could check to see if the panorama sample atom structure contains a reference
// to a hot spot image track; if it does, we'd blindly assume that that track isn't empty. For objects,
// we'll have to rely on GetHotSpotCount. So it goes....
//
// In an ideal world, there would be a hot spot information atom for each and every hot spot region in
// the hot spot image track, in which case we could be happier using GetHotSpotCount.
//
//////////

function IsHotSpotInNode(theInstance:QTVRInstance):Boolean;
begin
 result:=(GetHotSpotCount(theInstance, QTVRGetCurrentNodeID(theInstance), nil) > 0);
end;

//////////
//
// IsMultiNode
// Does the specified QuickTime VR instance contain more than one node?
//
//////////

function IsMultiNode(theInstance:QTVRInstance):Boolean;
begin
 result:=(GetNodeCount(theInstance) > UInt32(1));
end;

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Controller bar utilities.
//
// Use these functions to manipulate the controller bar, its buttons, and the help text displayed in it.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// IsControllerBarVisible
// Is the controller bar currently visible?
//
//////////

function IsControllerBarVisible(theMC:MovieController):Boolean;
begin
	result:=(Boolean(MCGetVisible(theMC)));
end;


//////////
//
// GetControllerBarHeight
// Return the height of the controller bar displayed by the movie controller.
//
// Note that MCGetControllerBoundsRect returns rectangle of bar and movie, if attached;
// so we need to unattach the controller bar first.
//
//////////

function GetControllerBarHeight(theMC:MovieController):short;
var
 //wasAttached:Boolean;
 myRect:Rect;
 myHeight:short;
begin
 //wasAttached := false;
 //myHeight := 0;

 // if the controller bar is attached, detach it (and remember we did so)
(*
 if (MCIsControllerAttached(theMC) = 1) then
  begin
  wasAttached := true;
  MCSetControllerAttached(theMC, false);
  end;
*)

 // get the rectangle of the controller
 MCGetControllerBoundsRect(theMC, myRect);
 myHeight := myRect.bottom - myRect.top;

 // now reattach the controller bar, if it was originally attached
(*
 if (wasAttached) then
  MCSetControllerAttached(theMC, true);
*)  

 result:=(myHeight);
end;


//////////
//
// HideControllerBar
// Hide the controller bar provided by the movie controller.
//
//////////

procedure HideControllerBar(theMC:MovieController);
begin
	MCSetVisible(theMC, false);
end;


//////////
//
// ShowControllerBar
// Show the controller bar provided by the movie controller.
//
//////////

procedure ShowControllerBar(theMC:MovieController);
begin
	MCSetVisible(theMC, true);
end;


//////////
//
// ToggleControllerBar
// Toggle the state of the controller bar provided by the movie controller.
//
//////////

procedure ToggleControllerBar(theMC:MovieController);
begin
	if (IsControllerBarVisible(theMC)) then
		HideControllerBar(theMC)
	else
		ShowControllerBar(theMC);
end;


//////////
//
// HideControllerButton
// Hide the specified button in the controller bar.
//
// Some explanation is probably useful here: the first thing to understand is that every VR movie has 
// TWO sets of movie controller flags: (1) a set of "control flags" and (2) a set of "explicit flags".
//
// The control flags work as documented in IM: QuickTime Components (pp. 2-20f) and in VRPWQTVR2.0 (pp. 2-23f):
// if a bit in the set of control flags is set (that is, equal to 1), then the associated action or property is
// enabled. For instance, bit 17 (mcFlagQTVRSuppressZoomBtns) means to suppress the zoom buttons. So, if that
// bit is set in a VR movie's control flags, the zoom buttons are NOT displayed. If that bit is clear, the zoom
// buttons are displayed.
//
// However, the QuickTime VR movie controller sometimes suppresses buttons even when those buttons
// have not been explicitly suppressed in the control flags. For example, if a particular VR movie does not
// contain a sound track, then the movie controller automatically suppresses the speaker/volume button. Likewise,
// if a movie does contain a sound track, then the speaker/volume button is automatically displayed, again without
// regard to the actual value of bit 17 in the control flags.
//
// This might not be what you'd like to happen. For instance, if your application is playing a sound that it
// loaded from a sound resource, you might want the user to be able to adjust the sound's volume using the volume
// control. To do that, you need a way to *force* the speaker/volume button to appear. For this reason, the
// explicit flags were introduced.
//
// The explicit flags indicate which bits in the control flags are to be used explicitly (that is, taken at
// face value). If a certain bit is set in a movie's explicit flags, then the corresponding bit in the control
// flags is interpreted as the desired setting for the feature (and the movie controller will not attempt to
// do anything "clever"). In other words, if bit 17 is set in a movie's explicit flags and bit 17 is clear in
// that movie's control flags, then the zoom buttons are displayed. Similarly, if bit 2 is set in a movie's
// explicit flags and bit 2 is clear in that movie's control flags, then the speaker/volume button is displayed,
// whether or not the movie contains a sound track.
//
// The final thing to understand: to get or set a bit in a movie's explicit flags, you must set the flag 
// mcFlagQTVRExplicitFlagSet in your call to mcActionGetFlags or mcActionSetFlags. To get or set a bit in a 
// movie's control flags, you must clear the flag mcFlagQTVRExplicitFlagSet in your call to mcActionGetFlags 
// or mcActionSetFlags. Note that when you use the defined constants to set values in the explicit flags, the 
// constant names might be confusing. For instance, setting the bit mcFlagSuppressSpeakerButton in a movie's
// explicit flags doesn't cause the speaker to be suppressed; it just means: "use the actual value of the
// mcFlagSuppressSpeakerButton bit in the control flags".
//
// Whew! Any questions? Okay, then now you'll understand how to hide or show a button in the controller bar:
// set the appropriate explicit flag to 1 and set the corresponding control flag to the desired value. And
// you'll understand how to let the movie controller do its "clever" work: clear the appropriate explicit flag.
//
//////////

procedure HideControllerButton(theMC:MovieController;theButton:long);
var myControllerFlags:long;
begin
	// get the current explicit flags and set the explicit flag for the specified button
	myControllerFlags := mcFlagQTVRExplicitFlagSet;
	MCDoAction(theMC, mcActionGetFlags, @myControllerFlags);
	MCDoAction(theMC, mcActionSetFlags, pointer(((myControllerFlags or theButton) or mcFlagQTVRExplicitFlagSet)));

	// get the current control flags and set the suppress flag for the specified button
	myControllerFlags := 0;
	MCDoAction(theMC, mcActionGetFlags, @myControllerFlags);
	MCDoAction(theMC, mcActionSetFlags, pointer(((myControllerFlags or theButton) and (not mcFlagQTVRExplicitFlagSet)))); //Delphi: C's "~" is Pascal's "not"
end;


//////////
//
// ShowControllerButton
// Show the specified button in the controller bar.
//
//////////

procedure ShowControllerButton(theMC:MovieController;theButton:long);
var myControllerFlags:long;
begin
	// get the current explicit flags and set the explicit flag for the specified button
	myControllerFlags := mcFlagQTVRExplicitFlagSet;
	MCDoAction(theMC, mcActionGetFlags, @myControllerFlags);
	MCDoAction(theMC, mcActionSetFlags, pointer(((myControllerFlags or theButton) or mcFlagQTVRExplicitFlagSet)));

	// get the current control flags and clear the suppress flag for the specified button
	myControllerFlags := 0;
	MCDoAction(theMC, mcActionGetFlags, @myControllerFlags);
	MCDoAction(theMC, mcActionSetFlags, pointer((myControllerFlags and (not theButton) and (not mcFlagQTVRExplicitFlagSet)))); //Delphi: C's "~" is Pascal's "not"
end;


//////////
//
// ToggleControllerButton
// Toggle the state of the specified button in the controller bar.
//
//////////

procedure ToggleControllerButton(theMC:MovieController;theButton:long);
var myControllerFlags:long;
begin
	// get the current control flags and toggle the suppress flag for the specified button
	myControllerFlags := 0;
	MCDoAction(theMC, mcActionGetFlags, @myControllerFlags);
	
	if (myControllerFlags and theButton <> 0) then				// if the button is currently suppressed...
		ShowControllerButton(theMC, theButton)
	else
		HideControllerButton(theMC, theButton);
end;


//////////
//
// ResetControllerButton
// Remove any explicit setting of the specified button in the controller bar.
// (This allows the QuickTime VR movie controller to be as clever as it knows how to be.)
//
//////////

procedure ResetControllerButton(theMC:MovieController;theButton:long);
var myControllerFlags:long;
begin
	myControllerFlags := mcFlagQTVRExplicitFlagSet;

	// get the current explicit flags and clear the explicit flag for the specified button
	MCDoAction(theMC, mcActionGetFlags, @myControllerFlags);
	MCDoAction(theMC, mcActionSetFlags, pointer(((myControllerFlags or theButton) and (not mcFlagQTVRExplicitFlagSet)))); //Delphi: C's "~" is Pascal's "not"
end;


//////////
//
// IsControllerButtonVisible
// Is the specified button in the controller bar currently visible?
//
//////////

//Delphi: C's "~" is Pascal's "not"
function IsControllerButtonVisible(theMC:MovieController;theButton:long):Boolean;
var myControllerFlags:long;
    myExplicitFlags:long;
begin
	// get the current control flags
	myControllerFlags := 0;
	MCDoAction(theMC, mcActionGetFlags, @myControllerFlags);

	// the speaker button requires some additional logic, because the QTVR movie controller treats it special;
	// be advised that that controller's special behavior could change in the future,
	// so you might need to tweak this code
	if (theButton = mcFlagSuppressSpeakerButton) then begin

		// get the current explicit flags
		myExplicitFlags := mcFlagQTVRExplicitFlagSet;
		MCDoAction(theMC, mcActionGetFlags, @myExplicitFlags);

		// the speaker button is not showing if the movie has no sound track and the explicit flag is not set
		if (not MovieHasSoundTrack(MCGetMovie(theMC)) and ((myExplicitFlags and theButton)=0)) then
			begin result:=(false); exit; end;
	end;

	// examine the suppress flag for the specified button
	if (myControllerFlags and theButton <>0) then 			// if the button is currently suppressed...
		result:=(false)
	else
		result:=(true);
end;


//////////
//
// HideHotSpotNames
// Disable the displaying of hot spot names in the controller bar.
//
//////////

procedure HideHotSpotNames(theMC:MovieController);
begin
	HideControllerButton(theMC, kQTVRHotSpotNames);
end;


//////////
//
// ShowHotSpotNames
// Enable the displaying of hot spot names in the controller bar.
//
//////////

procedure ShowHotSpotNames(theMC:MovieController);
begin
	ShowControllerButton(theMC, kQTVRHotSpotNames);
end;


//////////
//
// ToggleHotSpotNames
// Toggle the displaying of hot spot names in the controller bar.
//
//////////

procedure ToggleHotSpotNames(theMC:MovieController);
begin
	ToggleControllerButton(theMC, kQTVRHotSpotNames);
end;


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// File format utilities.
//
// Use these functions to read information from QuickTime VR files that's not accessible using the API.
// Throughout, we assume that we're dealing with format 2.0 files. We begin with a series of functions that
// return a pointer to the data in an atom (Get*AtomData); you probably won't use these functions
// directly.
//
// Keep in mind that data stored in QuickTime atoms is big-endian. We'll need to convert any multi-byte data
// that we read from an atom to native format before we use it.
//
// Note that these file format utilities are all Getters. As yet, no Setters. Perhaps later?
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// GetVRWorldHeaderAtomData
// Get a pointer to the VR world header atom data in a QTVR movie.
//
//////////

function GetVRWorldHeaderAtomData(theInstance:QTVRInstance;theVRWorldHdrAtomPtr:QTVRWorldHeaderAtomPtr):OSErr;
var myVRWorld:QTAtomContainer;
    myAtom:QTAtom;
    myErr:OSErr;
begin
 //myErr := noErr;

 // get the VR world
 myErr := QTVRGetVRWorld(theInstance, myVRWorld);
 if (myErr <> noErr) then
  begin
  result:=(myErr);
  exit;
  end;

 // get the single VR world header atom in the VR world
 myAtom := QTFindChildByIndex(myVRWorld, kParentAtomIsContainer, kQTVRWorldHeaderAtomType, 1, nil);
 if (myAtom <> 0) then
  myErr := QTCopyAtomDataToPtr(myVRWorld, myAtom, false, sizeof(QTVRWorldHeaderAtom), theVRWorldHdrAtomPtr, nil)
 else
  myErr := cannotFindAtomErr;

 QTDisposeAtomContainer(myVRWorld);
 result:=(myErr);
end;


//////////
//
// GetNodeHeaderAtomData
// Get a pointer to the node header atom data for the node having the specified node ID.
//
//////////

function GetNodeHeaderAtomData(theInstance:QTVRInstance;theNodeID:UInt32;theNodeHdrPtr:QTVRNodeHeaderAtomPtr):OSErr;
var myNodeInfo:QTAtomContainer;
    myAtom:QTAtom;
    myErr:OSErr;
begin
 //myErr := noErr;

 // get the node information atom container for the specified node
 myErr := QTVRGetNodeInfo(theInstance, theNodeID, myNodeInfo);
 if (myErr <> noErr) then
  begin
  result:=(myErr);
  exit;
  end;

 // get the single node header atom in the node information atom container
 myAtom := QTFindChildByID(myNodeInfo, kParentAtomIsContainer, kQTVRNodeHeaderAtomType, 1, nil);
 if (myAtom <> 0) then
  myErr := QTCopyAtomDataToPtr(myNodeInfo, myAtom, false, sizeof(QTVRNodeHeaderAtom), theNodeHdrPtr, nil)
 else
  myErr := cannotFindAtomErr;

 QTDisposeAtomContainer(myNodeInfo);
 result:=(myErr);
end;


//////////
//
// GetHotSpotAtomData
// Get a pointer to the hot spot atom data for hot spot having the specified hot spot ID in the specified node.
//
//////////

function GetHotSpotAtomData(theInstance:QTVRInstance;theNodeID:UInt32;theHotSpotID:UInt32;theHotSpotInfoPtr:QTVRHotSpotInfoAtomPtr):OSErr;
var myNodeInfo:QTAtomContainer;
    myHSParentAtom:QTAtom;
    myErr :OSErr;
    myHSAtom:QTAtom;
    myAtom:QTAtom;
begin
//myErr := noErr;

 // (1) the node information atom container contains a *hot spot parent atom*;
 // (2) the hot spot parent atom contains one or more *hot spot atoms*;
 // (3) the hot spot atom contains two children, a *general hot spot information atom*
 //     and a *specific hot spot information atom*.
 // We want to return a pointer to the general hot spot information atom data.

 // get the node information atom container for the specified node
 myErr := QTVRGetNodeInfo(theInstance, theNodeID, myNodeInfo);
 if (myErr <> noErr) then
  begin
  result:=(myErr);
  exit;
  end;

 // get the single hot spot parent atom in the node information atom container
 myHSParentAtom := QTFindChildByID(myNodeInfo, kParentAtomIsContainer, kQTVRHotSpotParentAtomType, 1, nil);
 if (myHSParentAtom <> 0) then
  begin

  // get the hot spot atom whose atom ID is the specified hot spot ID
  myHSAtom := QTFindChildByID(myNodeInfo, myHSParentAtom, kQTVRHotSpotAtomType, theHotSpotID, nil);
  if (myHSAtom <> 0) then
   begin

   // get the single hot spot information atom in the hot spot atom
   myAtom := QTFindChildByIndex(myNodeInfo, myHSAtom, kQTVRHotSpotInfoAtomType, 1, nil);
   if (myAtom <> 0) then
    myErr := QTCopyAtomDataToPtr(myNodeInfo, myAtom, false, sizeof(QTVRHotSpotInfoAtom), theHotSpotInfoPtr, nil);
   end
  else
   myErr := cannotFindAtomErr;
  end
 else
  myErr := cannotFindAtomErr;

 QTDisposeAtomContainer(myNodeInfo);
 result:=(myErr);
end;


//////////
//
// GetStringFromAtom
// Get the string data from the string atom having the specified ID in the specified atom container.
//
// We use a different strategy here, since we don't know the size of the string data in advance.
//
//////////

function GetStringFromAtom(theContainer:QTAtomContainer;theParent:QTAtom;theID:QTAtomID):PChar;
begin
(*
	QTVRStringAtomPtr	myStringAtomPtr := nil;
	QTAtom				myNameAtom;
	char				*myString := nil;
 	OSErr				myErr := noErr;

	if (theContainer = nil)
		result:=(myString);
		
	QTLockContainer(theContainer);

	myNameAtom := QTFindChildByID(theContainer, theParent, kQTVRStringAtomType, theID, nil);
	if (myNameAtom <> 0) then begin
		myErr := QTGetAtomDataPtr(theContainer, myNameAtom, nil, (Ptr * )&myStringAtomPtr);
		if ((myErr = noErr) and (myStringAtomPtr <> nil)) begin
			UInt16		myLength;

			myLength := EndianU16_BtoN(myStringAtomPtr->stringLength);
			if (myLength > 0) begin
				myString := malloc(myLength + 1);
				if (myString <> nil) begin
					memcpy(myString, myStringAtomPtr->theString, myLength);
					myString[myLength] := '\0';
				end;
			end;			
		end;
	end;
	
	QTUnlockContainer(theContainer);
	result:=(myString);
*)
end;


//////////
//
// AddStr255ToAtomContainer
// Add a Pascal string to the specified atom container; return (through theID) the ID of the new string atom.
//
//////////

function AddStr255ToAtomContainer(theContainer:QTAtomContainer;theParent:QTAtom;theString:Str255;theID:QTAtomID):OSErr;
begin
(*
	OSErr					myErr := noErr;

	*theID := 0;				// initialize the returned atom ID

	if ((theContainer = nil) or (theParent = 0))
		result:=(paramErr);
		
	if (theString[0] <> 0) begin
		QTAtom				myStringAtom;
		UInt16				mySize;
		QTVRStringAtomPtr	myStringAtomPtr := nil;
		
		mySize := sizeof(QTVRStringAtom) - 4 + theString[0] + 1;
		myStringAtomPtr := (QTVRStringAtomPtr)NewPtrClear(mySize);
		
		if (myStringAtomPtr <> nil) begin
			myStringAtomPtr->stringUsage := EndianU16_NtoB(1);
			myStringAtomPtr->stringLength := EndianU16_NtoB(theString[0]);
			BlockMove(theString + 1, myStringAtomPtr->theString, theString[0]);
			myStringAtomPtr->theString[theString[0]] := '\0';
			myErr := QTInsertChild(theContainer, theParent, kQTVRStringAtomType, 0, 0, mySize, (Ptr)myStringAtomPtr, &myStringAtom);
			DisposePtr((Ptr)myStringAtomPtr);
			
			if (myErr = noErr)
				QTGetAtomTypeAndID(theContainer, myStringAtom, nil, theID);
		end;
	end;
	
	result:=(myErr);
*)
end;


//////////
//
// GetDefaultNodeID
// Get the ID of the default node in a QTVR movie.
//
//////////

function GetDefaultNodeID(theInstance:QTVRInstance):UInt32;
begin
(*
	QTVRWorldHeaderAtom	 	myVRWorldHeader;
	UInt32					myNodeID := kQTVRCurrentNode;
	OSErr					myErr := noErr;
		
	myErr := GetVRWorldHeaderAtomData(theInstance, &myVRWorldHeader);
	if (myErr = noErr)
		myNodeID := EndianU32_BtoN(myVRWorldHeader.defaultNodeID);

	result:=(myNodeID);
*)
end;


//////////
//
// GetSceneFlags
// Get the set of flags associated with the VR scene.
// (Currently these flags are undefined, however.)
//
//////////

function GetSceneFlags(theInstance:QTVRInstance):UInt32;
begin
(*
	QTVRWorldHeaderAtom	 	myVRWorldHeader;
	UInt32					myFlags := 0L;
	OSErr					myErr;
		
	myErr := GetVRWorldHeaderAtomData(theInstance, &myVRWorldHeader);
	if (myErr = noErr)
		myFlags := EndianU32_BtoN(myVRWorldHeader.vrWorldFlags);

	result:=(myFlags);
*)
end;

(*

//////////
//
// GetSceneName
// Get the name of the VR scene.
// The caller is responsible for disposing of the pointer returned by this function (by calling free).
//
//////////

function GetSceneName(QTVRInstance:theInstance):PChar;
begin
	QTVRWorldHeaderAtom	 		myVRWorldHeader;
	char						*mySceneName := nil;
	OSErr						myErr := noErr;
		
	myErr := GetVRWorldHeaderAtomData(theInstance, &myVRWorldHeader);
	if (myErr = noErr) begin
		QTAtomID				myNameAtomID;
		
		// get the atom ID of the name string atom
		myNameAtomID := EndianU32_BtoN(myVRWorldHeader.nameAtomID);
		
		if (myNameAtomID <> 0) begin
			QTAtomContainer		myVRWorld;
			
			// the string atom containing the name of the scene is a *sibling* of the VR world header atom
			myErr := QTVRGetVRWorld(theInstance, &myVRWorld);
			if (myErr = noErr)
				mySceneName := GetStringFromAtom(myVRWorld, kParentAtomIsContainer, myNameAtomID);

			QTDisposeAtomContainer(myVRWorld);
		end;
	end;

	result:=(mySceneName);
end;

*)


//////////
//
// GetNodeCount
// Get the number of nodes in a QTVR movie.
//
//////////

function GetNodeCount(theInstance:QTVRInstance):UInt32;
var
 myVRWorld:QTAtomContainer;
 myNodeParentAtom:QTAtom;
 myNumNodes:UInt32;
 myErr:OSErr;
begin
 myNumNodes:=0;
 //myErr := noErr;

 // get the VR world
 myErr := QTVRGetVRWorld(theInstance, myVRWorld);
 if (myErr <> noErr) then
  begin
  result:=(myNumNodes);
  exit;
  end;

 // get the node parent atom, whose children contain info about all nodes in the scene
 myNodeParentAtom := QTFindChildByIndex(myVRWorld, kParentAtomIsContainer, kQTVRNodeParentAtomType, 1, nil);
 if (myNodeParentAtom <> 0) then  // now count the node ID children of the node parent atom, which is the number of nodes in the scene
  myNumNodes := QTCountChildrenOfType(myVRWorld, myNodeParentAtom, kQTVRNodeIDAtomType);

 QTDisposeAtomContainer(myVRWorld);

 result:=(myNumNodes);
end;

(*
//////////
//
// GetNodeType
// Get the type of the node with the specified ID.
//
// NOTE: This function is redundant, given QTVRGetNodeType; it's included here for illustrative purposes only.
//
//////////

function GetNodeType(theInstance:QTVRInstance;theNodeID:UInt32;theNodeType:OSType):OSErr;
begin
 QTVRNodeHeaderAtom  myNodeHeader;
 OSErr		     myErr := noErr;

// make sure we always return some meaningful value
 *theNodeType := kQTVRUnknownType;

// get the node header atom data
 myErr := GetNodeHeaderAtomData(theInstance, theNodeID, &myNodeHeader);
 if (myErr = noErr)
  *theNodeType := EndianU32_BtoN(myNodeHeader.nodeType);

 result:=(myErr);
end;


//////////
//
// GetNodeName
// Get the name of the node with the specified ID.
// The caller is responsible for disposing of the pointer returned by this function (by calling free).
//
//////////

function GetNodeName(QTVRInstance:theInstance:;theNodeID:UInt32):PChar;
begin
	QTVRNodeHeaderAtom		myNodeHeader;
	char					*myNodeName := nil;
	OSErr					myErr := noErr;

	myErr := GetNodeHeaderAtomData(theInstance, theNodeID, &myNodeHeader);
	if (myErr = noErr) begin
		QTAtomID				myNameAtomID;
		
		// get the atom ID of the name string atom
		myNameAtomID := EndianU32_BtoN(myNodeHeader.nameAtomID);

		if (myNameAtomID <> 0) begin
			QTAtomContainer		myNodeInfo;

			// the string atom containing the name of the node is a *sibling* of the node information atom
			myErr := QTVRGetNodeInfo(theInstance, theNodeID, &myNodeInfo);
			if (myErr = noErr)
				myNodeName := GetStringFromAtom(myNodeInfo, kParentAtomIsContainer, myNameAtomID);

			QTDisposeAtomContainer(myNodeInfo);
		end;
	end;
	
	result:=(myNodeName);
end;


//////////
//
// GetNodeComment
// Get the comment for the node with the specified ID.
// The caller is responsible for disposing of the pointer returned by this function (by calling free).
//
//////////

function GetNodeComment(QTVRInstance:theInstance:;theNodeID:UInt32):PChar;
begin
	QTVRNodeHeaderAtom		myNodeHeader;
	char					*myNodeCmt := nil;
	OSErr					myErr := noErr;

	myErr := GetNodeHeaderAtomData(theInstance, theNodeID, &myNodeHeader);
	if (myErr = noErr) begin
		QTAtomID				myCmtAtomID;
		
		// get the atom ID of the comment string atom
		myCmtAtomID := EndianU32_BtoN(myNodeHeader.commentAtomID);
		
		if (myCmtAtomID <> 0) begin
			QTAtomContainer		myNodeInfo;
			
			// the string atom containing the comment for the node is a *sibling* of the node information atom
			myErr := QTVRGetNodeInfo(theInstance, theNodeID, &myNodeInfo);
			if (myErr = noErr)
				myNodeCmt := GetStringFromAtom(myNodeInfo, kParentAtomIsContainer, myCmtAtomID);

			QTDisposeAtomContainer(myNodeInfo);
		end;
	end;
	
	result:=(myNodeCmt);
end;

*)

//////////
//
// GetHotSpotCount
// Return the number of hot spots in the node with specified ID,
// and fill the specified handle with a list of the hot spot IDs.
//
// If theHotSpotIDs = nil on entry, do not pass back the list of IDs.
//
// WARNING: This routine determines the number of hot spots by counting
// the hot spot atoms in a hot spot parent atom; this might not be
// the same as counting the number of regions in the hot spot image track.
// Sigh.
//
//////////

function GetHotSpotCount(theInstance:QTVRInstance;theNodeID:UInt32;theHotSpotIDs:Handle):UInt32;
begin
(*
	QTAtomContainer			myNodeInfo;
	QTAtom					myHSParentAtom := 0;
	UInt32					myNumHotSpots := 0;
	OSErr					myErr := noErr;
	
	// get the node information atom container for the current node
	myErr := QTVRGetNodeInfo(theInstance, theNodeID, &myNodeInfo);
	
	// get the hot spot parent atom
	if (myErr = noErr)
		myHSParentAtom := QTFindChildByID(myNodeInfo, kParentAtomIsContainer, kQTVRHotSpotParentAtomType, 1, nil);
		
	if (myHSParentAtom <> 0) begin
		SignedByte			myHState;
		Size				mySize;

		// get the number of hot spots in the current node
		myNumHotSpots := QTCountChildrenOfType(myNodeInfo, myHSParentAtom, kQTVRHotSpotAtomType);
		
		// now pass back a list of the hot spot IDs;
		// if theHotSpotIDs is nil on entry, we assume the caller doesn't want this information
		if (theHotSpotIDs <> nil) begin
		
			// unlock the handle, if it's locked (so that we can resize it)
			myHState := HGetState(theHotSpotIDs);
			if (myHState & 0x80)			// 0x80 = the block-is-locked bit in the SignedByte returned by HGetState
				HUnlock(theHotSpotIDs);

			// resize the handle to the appropriate size
			mySize := sizeof(UInt32) * myNumHotSpots;
			SetHandleSize(theHotSpotIDs, mySize);
			
			// restore the original handle state
			HSetState(theHotSpotIDs, myHState);
			
			// make sure we actually did resize the handle
			if (GetHandleSize(theHotSpotIDs) = mySize) begin
				short			myIndex;
				QTAtom			myAtom;
				QTAtomID		myID;
				UInt32			*myIDPtr;
				
				myIDPtr := (UInt32 * )*theHotSpotIDs;

				// loop thru all the hot spots to get their IDs
				for (myIndex := 1; myIndex <= (short)myNumHotSpots; myIndex++) begin
					myAtom := QTFindChildByIndex(myNodeInfo, myHSParentAtom, kQTVRHotSpotAtomType, myIndex, &myID);
					myIDPtr[myIndex - 1] := (UInt32)myID;
				end
			end;
		end;
	end;
	
	QTDisposeAtomContainer(myNodeInfo);
	result:=(myNumHotSpots);
*)
end;


//////////
//
// GetHotSpotIDByIndex
// Return the hot spot ID having the specified index in the list of hot spot IDs returned by GetHotSpotCount,
// or kInvalidHotSpotID if no such hot spot exists.
//
//////////

function GetHotSpotIDByIndex(theInstance:QTVRInstance;theHotSpotIDs:Handle;theIndex:UInt32):UInt32;
begin
(*
	Size			mySize;
	UInt32			myID := kInvalidHotSpotID;
	UInt32			*myIDPtr;

	// make sure the instance and hot spot list are non-nil
	if ((theInstance = nil) or (theHotSpotIDs = nil)) then
		begin result:=(myID); exit; end;

	// make sure that the index is valid
	mySize := GetHandleSize(theHotSpotIDs);
	if (theIndex >= (mySize / sizeof(UInt32))) then
		begin result:=(myID); exit; end;

	myIDPtr := (UInt32 * )*theHotSpotIDs;
	myID := myIDPtr[theIndex];
	result:=(myID);
*)
end;


//////////
//
// GetHotSpotType
// Return the type of the hot spot having the specified hot spot ID in the specified node.
//
// NOTE: This function is semi-redundant, given QTVRGetHotSpotType; it's included here for illustrative purposes only.
// (Note, however, that QTVRGetHotSpotType returns types only for hot spots in the current node; here we do any node!)
//
//////////

function GetHotSpotType(theInstance:QTVRInstance;theNodeID:UInt32;theHotSpotID:UInt32;theHotSpotType:OSType):OSErr;
begin
(*
	QTVRHotSpotInfoAtom		myHotSpotAtomData;
	OSErr					myErr := noErr;

	// make sure we always return some meaningful value
	*theHotSpotType := kQTVRHotSpotUndefinedType;

	// get the hot spot information atom data
	myErr := GetHotSpotAtomData(theInstance, theNodeID, theHotSpotID, &myHotSpotAtomData);
	if (myErr = noErr)
		*theHotSpotType := EndianU32_BtoN(myHotSpotAtomData.hotSpotType);		// return the hot spot type

	result:=(myErr);
*)
end;


//////////
//
// GetHotSpotName
// Return the name of the hot spot having the specified hot spot ID in the specified node.
// The caller is responsible for disposing of the pointer returned by this function (by calling free).
//
//////////

function GetHotSpotName(theInstance:QTVRInstance;theNodeID:UInt32;theHotSpotID:UInt32):PChar;
begin
(*
	QTVRHotSpotInfoAtom		myHotSpotAtomData;
	char					*myHotSpotName := nil;
	OSErr					myErr := noErr;

	// get the hot spot information atom data
	myErr := GetHotSpotAtomData(theInstance, theNodeID, theHotSpotID, &myHotSpotAtomData);
	if (myErr = noErr) begin
		QTAtomID				myNameAtomID;

		// get the atom ID of the name string atom
		myNameAtomID := EndianU32_BtoN(myHotSpotAtomData.nameAtomID);

		if (myNameAtomID <> 0) begin
			QTAtomContainer		myNodeInfo;
			QTAtom				myHSParentAtom;
			QTAtom				myHSAtom;
			QTAtom				myNameAtom := 0;

			// version 2.0 documentation says that the hot spot name is contained in a string atom
			// that is a sibling of the hot spot atom (that is, a child of the hot spot parent atom);
			// some other documents indicate that a string atom is always a sibling of the atom that
			// contains the reference (in this case, a sibling of the hot spot information atom, and
			// hence a child of the hot spot atom); we will look first in the hot spot atom and then
			// in the hot spot parent atom. The version 2.1 documentation corrects the earlier error.
			// Mea culpa!

			// get the hot spot parent atom and the hot spot atom
			myErr := QTVRGetNodeInfo(theInstance, theNodeID, &myNodeInfo);
			if (myErr = noErr) begin
				myHSParentAtom := QTFindChildByID(myNodeInfo, kParentAtomIsContainer, kQTVRHotSpotParentAtomType, 1, nil);
				if (myHSParentAtom <> 0) begin
					myHSAtom := QTFindChildByID(myNodeInfo, myHSParentAtom, kQTVRHotSpotAtomType, theHotSpotID, nil);
					if (myHSAtom <> 0) begin
						QTAtom	myParentAtom;

						// look for a string atom that is a child of the hot spot atom
						myParentAtom := myHSAtom;
						myNameAtom := QTFindChildByID(myNodeInfo, myParentAtom, kQTVRStringAtomType, theHotSpotID, nil);
						if (myNameAtom = 0) begin
							// no such atom in the hot spot atom; look in the hot spot parent atom
							myParentAtom := myHSParentAtom;
							myNameAtom := QTFindChildByID(myNodeInfo, myParentAtom, kQTVRStringAtomType, theHotSpotID, nil);
						end;

						if (myNameAtom <> 0)
							myHotSpotName := GetStringFromAtom(myNodeInfo, myParentAtom, myNameAtomID);
					end;
				end;
			end;

			QTDisposeAtomContainer(myNodeInfo);
		end;
	end;

	result:=(myHotSpotName);
*)
end;


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Miscellaneous utilities.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////
//
// Point3DToPanAngle
// Return the QTVR pan angle for a given QD3D point.
//
//////////

function Point3DToPanAngle(theX:float;theY:float;theZ:float):float;
var myPan:float;
begin
//#pragma unused(theY)

 if (theZ <> 0.0) then
  begin
  // note that atan always returns angles in the range -¹/2 to ¹/2
  myPan := arctan(theX / theZ);
  if (theZ > 0) then myPan:=myPan + kVRPi;
  end
 else
  if (theX > 0) then myPan:=kVR3PiOver2 else myPan:=kVRPiOver2;

 // make sure myPan is positive
 while (myPan < 0.0) do
  myPan := myPan + kVR2Pi;

 result:=(myPan);
end;

//////////
//
// Point3DToTiltAngle
// Return the QTVR tilt angle for a given QD3D point.
//
//////////

function Point3DToTiltAngle(theX:float;theY:float;theZ:float):float;
var myTilt:float;
    myDistance:float;
    myPoint:TQ3Point3D;
begin
 myPoint.x := theX;
 myPoint.y := theY;
 myPoint.z := theZ;

 myDistance := GetDistance(myPoint);
 if (myDistance <> 0.0) then
  myTilt := arcsin(theY / myDistance) //Delphi: C's asin = Delphi's arcsin
 else
  myTilt := 0.0;

 result:=(myTilt);
end;


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Node callback utilities.
//
// Use these to obtain standard behaviors when entering or exiting nodes.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// StandardEnteringNodeProc
// A standard procedure for entering a new node.
//
// This function performs actions that many applications will want done when entering a new node:
//	* display back button only if multinode movie
//	* display show-hot-spot button only if there are hotspots
//	* display the translate button only for object nodes that can translate
//	* (this space for rent)
//
//////////

function StandardEnteringNodeProc(theInstance:QTVRInstance;fromNodeID:long;toNodeID:long;var theCancel:Boolean;theMC:MovieController):OSErr; pascal; //in Delphi3 pascal isn't the default calling convention {PASCAL_RTN}
var myErr:OSErr;
begin
//#pragma unused(theNodeID)

	myErr := noErr;

	if ((theInstance = nil) or (theMC = nil)) then
		begin result:=(paramErr); exit; end;

	///////
	// all nodes
	///////

	// display the back button only if it's a multinode movie
	if (IsMultiNode(theInstance)) then
		ShowControllerButton(theMC, long(mcFlagQTVRSuppressBackBtn))
	else
		HideControllerButton(theMC, long(mcFlagQTVRSuppressBackBtn));

	// display the show-hot-spot button only if there are hotspots in the node
	if (IsHotSpotInNode(theInstance)) then
		ShowControllerButton(theMC, long(mcFlagQTVRSuppressHotSpotBtn))
	else
		HideControllerButton(theMC, long(mcFlagQTVRSuppressHotSpotBtn));

	///////
	// panoramic nodes
	///////

	if (IsPanoNode(theInstance)) then

		// hide the translate button
		HideControllerButton(theMC, long(mcFlagQTVRSuppressTranslateBtn))

	else begin

	///////
	// object nodes
	///////

		// show the translate button, but only if translation is available
		if (IsTranslateAvailable(theInstance)) then
			ShowControllerButton(theMC, long(mcFlagQTVRSuppressTranslateBtn))
		else
			HideControllerButton(theMC, long(mcFlagQTVRSuppressTranslateBtn));
	end;

	result:=(myErr);
end;


//////////
//
// StandardLeavingNodeProc
// A standard procedure for leaving a node.
// This function performs actions that many applications will want done when leaving a node:
//	* (this space for rent)
//
// We assume that when this procedure is called, the application has decided NOT to cancel the move;
// accordingly, we always return false in theCancel.
//
//////////

function StandardLeavingNodeProc(theInstance:QTVRInstance;fromNodeID:long;toNodeID:long;var theCancel:Boolean;theMC:MovieController):OSErr; pascal; //in Delphi3 pascal isn't the default calling convention {PASCAL_RTN}
var myErr:OSErr;
begin
//#pragma unused(fromNodeID, toNodeID)

	myErr := noErr;

	if ((theInstance = nil) or (theMC = nil)) then
		begin result:=(paramErr); exit; end;

	// nothing yet....

	theCancel := false;
	result:=(myErr);
end;

end.


