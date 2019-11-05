program VRMakeObject;

{--------------------------
 History:
---------------------------
* 26Jun2002
[birbilis]
- first version from VRMakeObject.cpp (command-line version [by G.Birbilis] of VRMakeObject demo of Apple)
- added code to create a temporary output file when the output file dialog isn't shown (that is if output path command line parameter is supplied)
* 30Jun2002
[birbilis]
- a complilable and runnable version taking command-line parameters etc. (still doesn't seem to produce anything though)
* 22Jun2003
[birbilis]
- fixed call to "BlockMove" (needs newer JEDI QuickTime version with correct "BlockMove" prototype at "qt_MacMemory.pas")
- uncommented and fixed calls to "VRObject_AddStr255ToAtomContainer" (but commented out the related code blocks cause they were not being used)
- fixed "VRObject_ImportVideoTrack" call
- added optional "controlSettings" parameter
- added optional "animationSettings" parameter
}

//------------------------------------------------------------------------------

//////////
//
//	File:		VRMakeObject.h
//
//	Contains:	Code for creating a QuickTime VR object movie from a linear QuickTime movie.
//
//	Written by:	Tim Monroe
//				Based on MakeQTVRObject code by Pete Falco and Michael Chen (and others?).
//
//	Copyright:	© 1991-1998 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <1>	 	01/20/98	rtm		first file
//
//////////

 uses windows, //must go first, cause the QT headers redefine "float"
      SysUtils,
      qt_QTML,
      qt_Endian,
      qt_FixMath,
      qt_ImageCompression,
      qt_Movies,
      qt_QuickTimeComponents,
      qt_QuickTimeVR,
      qt_QuickTimeVRFormat,
      qt_Script,
      qt_Sound,
      qt_MacTypes,
      C_Types,
      qt_Files,
      qt_Errors,
      qt_MacMemory,
      QTUtils,
      QTFrame;

//////////
// macros
//////////

 function FloatToFixed(a:float):Fixed;
 begin
  result:=trunc(a*fixed1); //birbilis: or use round?
 end;


//////////
//
// constants
//
//////////

const
 kDefaultNodeID = 1; // default node ID
 kQTVRVersion1 = long(1);
 kQTVRVersion2 = long(2);
 kObjectFormat1x0DataType = (((ord('N') shl 8 +ord('A'))shl 8 +ord('V'))shl 8 +ord('G')); //FOUR_CHAR_CODE('NAVG')
 kObjSaveMoviePrompt = 'Save object movie file as:';
 kObjSaveMovieFileName = 'UntitledObject.mov';

// default object settings;
// a real application would let the user select these values interactively
// (perhaps by displaying a dialog box with a bunch of edit text items....)

var
 numOfColumns:UInt16; //3
 numOfRows:UInt16; //1

const
 kDefaultLoopSize = UInt16(1);
 kDefaultLoopTicks = UInt16(0); // for looping object: display next frame as quickly as possible
 kDefaultFrameDuration = UInt16(60);
 kDefaultMovieType = UInt16(kGrabberScrollerUI);
 kDefaultViewStateCount	= UInt16(1);
 kDefaultDefaultViewState = UInt16(1);
 kDefaultMouseDownViewState = UInt16(1);

// version 1.0 uses Fixed for some of its data items, while version 2.x uses Float32;
// we'll define our default settings using Float32 and, when necessary, convert to Fixed using the FloatToFixed macro defined above
const
 kDefaultFieldOfView = {Float32}(180.0);
 kDefaultMinFieldOfView	= {Float32}(8.0);

var
 startPan:Float32; //0.0
 endPan:Float32; //360.0
 startTilt:Float32; //90.0
 endTilt:Float32; //-20.0
 controlSettings:UInt32; //OR mask made of: kQTVRObjectWrapPanOn, kQTVRObjectWrapTiltOn, kQTVRObjectCanZoomOn, kQTVRObjectHControlOn, kQTVRObjectVControlOn, kQTVRObjectSwapHVControlOn, kQTVRObjectTranslationOn (defined in QuickTimeVRFormat.h at the QuickTime SDK)
 animationSettings:UInt32; //OR mask made of: kQTVRObjectAnimateViewFramesOn, kQTVRObjectPalindromeViewFramesOn, kQTVRObjectStartFirstViewFrameOn, kQTVRObjectAnimateViewsOn, kQTVRObjectPalindromeViewsOn, kQTVRObjectSyncViewToFrameRate, kQTVRObjectDontLoopViewFramesOn, kQTVRObjectPlayEveryViewFrameOn, kQTVRObjectStreamingViewsOn

const
 kDefaultInitialPan = {Float32}(180.0); // not used; we calculate the initial pan angle from the source movie's current time
 kDefaultInitialTilt = {Float32}(0.0);	// not used; we calculate the initial tilt angle from the source movie's current time
 kDefaultMouseMotionScale    =		{Float32}(180.0);
 kDefaultDefaultViewCenterH  =		{Float32}(0.0);
 kDefaultDefaultViewCenterV  =		{Float32}(0.0);
 kDefaultViewRate	     =		{Float32}(1.0);
 kDefaultFrameRate	     =		{Float32}(1.0);

 kDefaultAnimationSettings   =		UInt32(0);
 kDefaultControlSettings     =		UInt32(kQTVRObjectWrapPanOn or kQTVRObjectCanZoomOn or kQTVRObjectTranslationOn);


//////////
//
// data types
//
//////////

// version 1.0 data types

// object file format record:
// this defines the structure of the 'NAVG' user data item

type
 QTVRObjectFileFormat1x0Record=packed record //align=mac68k ???
  versionNumber:short; // version number; always 1
  numberOfColumns:short; // number of columns in movie
  numberOfRows:short; // number rows in movie
  reserved1:short; // reserved; must be 0
  loopSize:short; // number of frames shot at each position
  frameDuration:short; // the duration of each frame
  movieType:short; // kStandardObject, kObjectInScene, or kOldNavigableMovieScene
  loopTicks:short; // number of ticks before next frame of loop is displayed
  fieldOfView:Fixed; // 180.0 for kStandardObject or kObjectInScene, actual degrees for kOldNavigableMovieScene.
  startHPan:Fixed; // start horizontal pan angle, in degrees
  endHPan:Fixed; // end horizontal pan angle, in degrees
  endVPan:Fixed; // end vertical pan angle, in degrees
  startVPan:Fixed; // start vertical pan angle, in degrees
  initialHPan:Fixed; // initial horizontal pan angle, in degrees (poster view)
  initialVPan:Fixed; // initial vertical pan angle, in degrees (poster view)
  reserved2:long; // reserved; must be 0
  end;
 QTVRObjectFileFormat1x0Ptr=^QTVRObjectFileFormat1x0Record;

//////////
//
// function prototypes
//
//////////

procedure VRObject_PromptUserForMovieFileAndMakeObject; forward;
function VRObject_CreateVRWorld (var theVRWorld:QTAtomContainer; var theNodeInfo:QTAtomContainer; theNodeType:OSType):OSErr; forward;
function VRObject_CreateObjectTrack (theSrcMovie:Movie; theObjectTrack:Track; theObjectMedia:Media):OSErr; forward;
function VRObject_CreateQTVRMovieVers1x0 (var theObjMovSpec:FSSpec; var theSrcMovSpec:FSSpec):OSErr; forward;
function VRObject_CreateQTVRMovieVers2x0 (var theObjMovSpec:FSSpec; var theSrcMovSpec:FSSpec):OSErr; forward;
function VRObject_MakeObjectMovie (var theMovieSpec:FSSpec; var theDestSpec:FSSpec; theVersion:long):OSErr; forward;
function VRObject_GetPanAndTiltFromTime (theTime:TimeValue;
                                         theFrameDuration:TimeValue;
                                         theNumColumns:short;
                                         theNumRows:short;
                                         theLoopSize:short;
                                         theStartPan:Float32;
                                         theEndPan:Float32;
                                         theStartTilt:Float32;
                                         theEndTilt:Float32;
                                         var thePan:Float32;var theTilt:Float32):OSErr; forward;
function VRObject_ImportVideoTrack (theSrcMovie:Movie; theDstMovie:Movie; var theImageTrack:Track):OSErr; forward;
function VRObject_SetControllerType (theMovie:Movie;theType:OSType):OSErr; forward;
function VRObject_AddStr255ToAtomContainer (theContainer:QTAtomContainer;theParent:QTAtom;theString:Str255;var theID:QTAtomID):OSErr; forward;
procedure VRObject_ConvertFloatToBigEndian(theFloat:floatPtr); forward;

function VRObject_FileFilterFunction(thePBPtr:CInfoPBPtr):Boolean; stdcall; forward; //PASCAL_RTN=stdcall?

var inputFilename, outputFilename:string;

//------------------------------------------------------------------------------

//////////
//
//	File:		VRMakeObject.c
//
//	Contains:	Code for creating a QuickTime VR object movie from a linear QuickTime movie.
//
//	Written by:	Tim Monroe
//				Based on MakeQTVRObject code by Pete Falco and Michael Chen (and others?).
//
//	Copyright:	© 1991-1998 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <6>	 	03/21/00	rtm		made changes to get things running under CarbonLib
//	   <5>	 	02/01/99	rtm		reworked prompt and filename handling to remove "\p" sequences
//	   <4>	 	09/30/98	rtm		tweaked call to AddMovieResource to create single-fork movies;
//									tweaked call to FlattenMovieData to enable FastStart option
//	   <3>	 	01/22/98	rtm		version 2.0 objects working on MacOS and Windows
//	   <2>	 	01/21/98	rtm		version 1.0 objects working on MacOS and Windows
//	   <1>	 	01/20/98	rtm		first file from QTVRObjectAuthoring.c in MakeQTVRObject 1.0b2
//
//	This file contains functions that convert a linear QuickTime movie into a QuickTime VR object movie.
//	Here we can create both version 1.0 and version 2.0 QTVR object movies.
//
//
//	VERSION 2.0 FILE FORMAT
//
//	The definitive source of information about creating QTVR 2.0 object movies is Chapter 3 of the
//	book "Virtual Reality Programming With QuickTime VR 2.0". (This information is also available
//	online, at <http://dev.info.apple.com/dev/techsupport/insidemac/qtvr/qtvrapi-2.html>.) Here is
//	a condensed version of the info in that chapter, as pertains to objects:
//
//	An object movie is a QuickTime movie that contains at least three tracks: a QTVR track, an object
//	track, and an object image track. In addition, a QuickTime VR movie must contain some special user data
//	that specifies the QuickTime VR movie controller. A QuickTime VR movie can also contain other kinds of
//	tracks, such as hot spot image tracks and even sound tracks.
//
//	A QuickTime VR movie contains a single "QTVR track", which maintains a list of the nodes in the
//	movie. Each individual sample in the QTVR track's media contains information about a single node,
//	such as the node's type, ID, and name. Since we are creating a single-node movie here, our
//	QTVR track will contain a single media sample. 
//
//	Every media sample in a QTVR track has the same sample description, whose type is QTVRSampleDescription.
//	The data field of that sample description is a "VR world", an atom container whose child atoms specify
//	information about the nodes in the movie, such as the default node ID and the default imaging properties.
//	We'll spend a good bit of time putting things into the VR world.
//
//	An object movie also contains a single "object track", which contains information specific to the
//	object nodes in a scene. An object track has a media sample for each media sample in the QTVR track.
//	As a result, our object track will have one sample. The QTVRObjectSampleAtom structure defines the media
//	sample data. 
//
//	The actual image data for an object node is contained in an "object image track". The individual
//	frames in that track are various views of the object. There may also be a "hot spot image track" that
//	contains the hot spot images. This sample code does not create hot spot image tracks.
//
//	So, our general strategy, given a linear QuickTime movie, is as follows:
//		(1) Create a new, empty movie. Call this movie the "QTVR movie".
//		(2) Create a QTVR track and its associated media.
//		(3) Create a VR world atom container; this is stored in the sample description for the QTVR track.
//		(4) Create a node information atom container for each node; this is stored as a media sample
//	        in the QTVR track.
//		(5) Create an object track and add it to the movie.
//		(6)	Create an object image track by copying the video track from the QuickTime movie to the QTVR movie.
//		(7) Set up track references from the QTVR track to the object track, and from the object track
//	        to the object image track.
//		(8) Add a user data item that identifies the QTVR movie controller.
//		(9) Flatten the QTVR movie into the final object movie.
//
//
//	VERSION 1.0 FILE FORMAT
//
//	The definitive source of information about creating QTVR version 1.0 object movies is Technote 1036,
//	"QuickTime VR 1.0 Object Movie File Format" released in March 1996, available online at the address
//	<http://devworld.apple.com/dev/technotes/tn/tn1036.html>. Here is a condensed version of the info
//	in that technote:
//
//	For version 1.0 object movies, the file format is quite simple. A single-node object movie contains
//	an "object video track", an active video track that contains the various views of the object in the
//	movie frames. An object video track is essentially just a standard QuickTime video track and is the
//	same as the version 2 object image tack.
//
//	What distinguishes an object movie from a standard linear QuickTime movie is the manner in which
//	the frames of the video track are displayed to the user. This is determined by a special piece of
//	user data stored in the object movie file, which selects the QuickTime VR movie controller.
//
//	Various display parameters of the object movie (for instance, the default pan angle) are contained in
//	another piece of user data, of type 'NAVG'. The data in this user data item is structured according
//	to the QTVRObjectFileFormat1x0Record structure.
//
//	A QuickTime VR object movie can also contain a movie poster of the object and a movie file preview.
//	A movie poster is a single view of the object that can be used to represent the object. A poster is
//	defined by specifying a time in the object video track. In general, the poster view should be the same
//	as the initial object view specified in the 'NAVG' user data item. A movie file preview is some part
//	of the object movie that is displayed in order to give the user an idea of what's in the entire movie
//	(for instance, in Standard File Package dialog boxes).
//
//	Version 1.0 object movies do not support hot spots.
//
//	So, our general strategy, given a linear QuickTime movie, is as follows:
//		(1) Create a new, empty movie. Call this movie the "QTVR movie".
//		(2)	Create an object video track by copying the video track from the linear movie to the QTVR movie.
//		(3) Add a user data item of type 'NAVG' to the QTVR movie that specifies object parameters.
//		(4)	Add a user data item of type 'ctyp' that identifies the QTVR movie controller.
//		(5) Set the poster time to the desired view of the object.
//		(6) Create a movie file preview and add it to the movie.
//		(7) Flatten the QTVR movie into the final object movie.
//
//
//	NOTES:
//
//	*** (1) ***
//	The routines in this file use lots of hard-coded values. A real-life application would want to elicit the
//	actual values for a specific object movie from the user. (Hey, this is only sample code!)
//
//	*** (2) ***
//	All data in QTAtom structures must be in big-endian format. We use macros like EndianU32_NtoB to convert
//	values into the proper format before inserting them into atoms. See VRObject_CreateVRWorld for some examples.
//	Similarly, data in the version 1.0 'NAVG' user data item must be big-endian.
//
//////////

const
 gVersionToCreate:UInt32 = kQTVRVersion2; // the version of the file format we create


//////////
//
// VRObject_PromptUserForMovieFileAndMakeObject
// Let the user select a linear QuickTime movie file, then make a QTVR object movie from it.
//
//////////

procedure VRObject_PromptUserForMovieFileAndMakeObject;
var myTypeList:OSType;
    myNumTypes:short;
    myMoovSpec:FSSpec;
    myDestSpec:FSSpec;
    myMoviePrompt:StringPtr;
    myMovieFileName:StringPtr;
    myIsSelected:Boolean;
    myIsReplacing:Boolean;
    myFilterUPP:QTFrameFileFilterUPP;
    myErr:OSErr;
label bail;
begin
 myTypeList := MovieFileType;
 myNumTypes := 1;
 myMoviePrompt := QTUtils.ConvertCToPascalString(kObjSaveMoviePrompt);
 myMovieFileName := QTUtils.ConvertCToPascalString(kObjSaveMovieFileName);
 myFilterUPP := nil; {!!!try to fix this one!!!} //birbilis: file-dialog was failing when a movie file was clicked to select, removed: // QTFrame_GetFileFilterUPP(ProcPtr(VRObject_FileFilterFunction));
 //myErr := noErr; //birbilis: not used, commented out

{$ifdef TARGET_OS_MAC}
 myNumTypes := 0;
{$endif}

 if(inputFilename<>'') then
  myMoovSpec.name:=inputFilename
 else
  begin //INPUT FILE DIALOG DOESN'T WORK YET !!!
  // have the user select a linear QuickTime movie file
  myErr := QTFrame_GetOneFileWithPreview(myNumTypes, QTFrameTypeListPtr(@myTypeList), @myMoovSpec, @myFilterUPP);
  if (myErr <> noErr) then goto bail;
  end;

 if(outputFilename<>'') then
  myDestSpec.name:=outputFilename
 else
  begin //OUTPUT FILE DIALOG DOESN'T WORK YET !!!
  // have the user select the name of the new object movie file
  {myErr :=} QTFrame_PutFile(@myMoviePrompt, @myMovieFileName, @myDestSpec, myIsSelected, myIsReplacing); //birbilis: myErr result wasn't used, commented out
  if (not myIsSelected) then goto bail;
  end;

 // just do it...
 VRObject_MakeObjectMovie(myMoovSpec, myDestSpec, gVersionToCreate);

 // ...and let the user know we're done
 QTFrame_Beep();

bail:
 // now clean up after ourselves
 freeMem(myMoviePrompt); //C's "free" is "freeMem" in Delphi
 freeMem(myMovieFileName);
end;


//////////
//
// VRObject_CreateVRWorld
// Create a VR world atom container and add the basic required atoms to it. Also, create a
// node information atom container and add a node header atom to it. Return both atom containers.
//
// The caller is responsible for disposing of the VR world and the node information atom
// (by calling QTDisposeAtomContainer).
//
// This function assumes that the scene described by the VR world contains a single node whose
// type is specified by the theNodeType parameter.
//
//////////

function VRObject_CreateVRWorld (var theVRWorld:QTAtomContainer; var theNodeInfo:QTAtomContainer; theNodeType:OSType):OSErr;
var myVRWorld:QTAtomContainer;
    myNodeInfo:QTAtomContainer;
    myVRWorldHeaderAtom:QTVRWorldHeaderAtom;
    myImagingParentAtom:QTAtom;
    myNodeParentAtom:QTAtom;
    myNodeAtom:QTAtom;
    myPanoImagingAtom:QTVRPanoImagingAtom;
    myNodeLocationAtom:QTVRNodeLocationAtom;
    myNodeHeaderAtom:QTVRNodeHeaderAtom;
    myIndex:UInt16;
    myErr:OSErr;
    //myStr:Str255; //birbilis: commented-out, unused
    //myID:QTAtomID; //birbilis: commented-out, unused
label bail;
begin
 myVRWorld := nil;
 myNodeInfo := nil;

 //myErr := noErr; //birbilis: not used, commented out

 //////////
 //
 // create a VR world atom container
 //
 //////////

 myErr := QTNewAtomContainer(myVRWorld);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // add a VR world header atom to the VR world
 //
 //////////

 myVRWorldHeaderAtom.majorVersion := EndianU16_NtoB(kQTVRMajorVersion);
 myVRWorldHeaderAtom.minorVersion := EndianU16_NtoB(kQTVRMinorVersion);

 // insert the scene name string, if we have one; if not, set nameAtomID to 0
{if (false) then
  begin
  myStr := 'My Scene'; //birbilis: removed '\p' from start of string (means Pascal string in C)

  myErr := VRObject_AddStr255ToAtomContainer(myVRWorld, kParentAtomIsContainer, myStr, myID);
  myVRWorldHeaderAtom.nameAtomID := EndianU32_NtoB(myID);
  end
 else} //birbilis: commented out: this code was never getting called
  myVRWorldHeaderAtom.nameAtomID := EndianU32_NtoB(long(0));

 myVRWorldHeaderAtom.defaultNodeID := EndianU32_NtoB(kDefaultNodeID);
 myVRWorldHeaderAtom.vrWorldFlags := EndianU32_NtoB(long(0));
 myVRWorldHeaderAtom.reserved1 := EndianU32_NtoB(long(0));
 myVRWorldHeaderAtom.reserved2 := EndianU32_NtoB(long(0));

 // add the atom to the atom container (the VR world)
 myErr := QTInsertChild(myVRWorld, kParentAtomIsContainer, kQTVRWorldHeaderAtomType, 1, 1, sizeof(QTVRWorldHeaderAtom), @myVRWorldHeaderAtom, nil);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // add an imaging parent atom to the VR world and insert imaging atoms into it
 //
 // imaging atoms describe the default imaging characteristics for the different types of nodes in the scene;
 // currently, only the panorama imaging atoms are defined, so we'll include those (even in object movies)
 //
 //////////

 myErr := QTInsertChild(myVRWorld, kParentAtomIsContainer, kQTVRImagingParentAtomType, 1, 1, 0, nil, @myImagingParentAtom);
 if (myErr <> noErr) then goto bail;

 // fill in the fields of the panorama imaging atom structure
 myPanoImagingAtom.majorVersion := EndianU16_NtoB(kQTVRMajorVersion);
 myPanoImagingAtom.minorVersion := EndianU16_NtoB(kQTVRMinorVersion);
 myPanoImagingAtom.correction := EndianU32_NtoB(kQTVRFullCorrection);
 myPanoImagingAtom.imagingValidFlags := EndianU32_NtoB(kQTVRValidCorrection or kQTVRValidQuality or kQTVRValidDirectDraw);
 for myIndex:=0 to 5 do
  myPanoImagingAtom.imagingProperties[myIndex] := EndianU32_NtoB(long(0));
 myPanoImagingAtom.reserved1 := EndianU32_NtoB(long(0));
 myPanoImagingAtom.reserved2 := EndianU32_NtoB(long(0));

 // add a panorama imaging atom for kQTVRMotion state
 myPanoImagingAtom.quality := EndianU32_NtoB(codecLowQuality);
 myPanoImagingAtom.directDraw := EndianU32_NtoB(cardinal(true));
 myPanoImagingAtom.imagingMode := EndianU32_NtoB(kQTVRMotion);
 myErr := QTInsertChild(myVRWorld, myImagingParentAtom, kQTVRPanoImagingAtomType, 0, 0, sizeof(QTVRPanoImagingAtom), @myPanoImagingAtom, nil);
 if (myErr <> noErr) then goto bail;

 // add a panorama imaging atom for kQTVRStatic state
 myPanoImagingAtom.quality := EndianU32_NtoB(codecHighQuality);
 myPanoImagingAtom.directDraw := EndianU32_NtoB(cardinal(false));
 myPanoImagingAtom.imagingMode := EndianU32_NtoB(kQTVRStatic);
 myErr := QTInsertChild(myVRWorld, myImagingParentAtom, kQTVRPanoImagingAtomType, 0, 0, sizeof(QTVRPanoImagingAtom), @myPanoImagingAtom, nil);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // add a node parent atom to the VR world and insert node ID atoms into it
 //
 //////////

 myErr := QTInsertChild(myVRWorld, kParentAtomIsContainer, kQTVRNodeParentAtomType, 1, 1, 0, nil, @myNodeParentAtom);
 if (myErr <> noErr) then goto bail;

 // add a node ID atom
 myErr := QTInsertChild(myVRWorld, myNodeParentAtom, kQTVRNodeIDAtomType, kDefaultNodeID, 0, 0, {0} nil, @myNodeAtom);
 if (myErr <> noErr) then goto bail;

 // add a single node location atom to the node ID atom
 myNodeLocationAtom.majorVersion := EndianU16_NtoB(kQTVRMajorVersion);
 myNodeLocationAtom.minorVersion := EndianU16_NtoB(kQTVRMinorVersion);
 myNodeLocationAtom.nodeType := EndianU32_NtoB(theNodeType);
 myNodeLocationAtom.locationFlags := EndianU32_NtoB(kQTVRSameFile);
 myNodeLocationAtom.locationData := EndianU32_NtoB(0);
 myNodeLocationAtom.reserved1 := EndianU32_NtoB(0);
 myNodeLocationAtom.reserved2 := EndianU32_NtoB(0);

 // insert the node location atom into the node ID atom
 myErr := QTInsertChild(myVRWorld, myNodeAtom, kQTVRNodeLocationAtomType, 1, 1, sizeof(QTVRNodeLocationAtom), @myNodeLocationAtom, nil);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // create a node information atom container and add a node header atom to it
 //
 //////////

 myErr := QTNewAtomContainer(myNodeInfo);
 if (myErr <> noErr) then goto bail;

 myNodeHeaderAtom.majorVersion := EndianU16_NtoB(kQTVRMajorVersion);
 myNodeHeaderAtom.minorVersion := EndianU16_NtoB(kQTVRMinorVersion);
 myNodeHeaderAtom.nodeType := EndianU32_NtoB(theNodeType);
 myNodeHeaderAtom.nodeID := EndianU32_NtoB(kDefaultNodeID);
 myNodeHeaderAtom.commentAtomID := EndianU32_NtoB(long(0));
 myNodeHeaderAtom.reserved1 := EndianU32_NtoB(long(0));
 myNodeHeaderAtom.reserved2 := EndianU32_NtoB(long(0));

 // insert the node name string into the node info atom container
{if (false) then
  begin
  myStr := 'My Node'; //birbilis: removed '\p' from start of string (means Pascal string in C)

  myErr := VRObject_AddStr255ToAtomContainer(myNodeInfo, kParentAtomIsContainer, myStr, myID);
  myNodeHeaderAtom.nameAtomID := EndianU32_NtoB(myID);
  end
 else} //birbilis: commented out: this code was never getting called
  myNodeHeaderAtom.nameAtomID := EndianU32_NtoB(long(0));

 // insert the node header atom into the node info atom container
 myErr := QTInsertChild(myNodeInfo, kParentAtomIsContainer, kQTVRNodeHeaderAtomType, 1, 1, sizeof(QTVRNodeHeaderAtom), @myNodeHeaderAtom, nil);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // create hot spot atoms and add them to the node information atom container
 // [left as an exercise for the reader]
 //
 //////////

bail:
 // return the atom containers that we've created and configured here
 theVRWorld := myVRWorld;
 theNodeInfo := myNodeInfo;

 result:=myErr;
end;


//////////
//
// VRObject_CreateObjectTrack
// Configure the specified object track. Note that theSrcMovie is the linear QuickTime movie.
//
//////////

function VRObject_CreateObjectTrack (theSrcMovie:Movie; theObjectTrack:Track; theObjectMedia:Media):OSErr;
var mySampleDesc:SampleDescriptionHandle;
    myObjectSample:QTAtomContainer;
    myObjectSampleData:QTVRObjectSampleAtom;
    myDuration:TimeValue;
    myCurrTime:TimeValue;
    myInitialPan, myInitialTilt:Float32;
    myErr:OSErr;
label bail;
begin
 //mySampleDesc := nil; //birbilis: not used, commented out
 //myErr := noErr; //birbilis: not used, commented out

 //////////
 //
 // get some information from the linear QuickTime movie
 //
 //////////

 // get the duration of a single video frame
 GetMovieNextInterestingTime(theSrcMovie, nextTimeMediaSample, 0, nil, TimeValue(0), fixed1, nil, @myDuration);

 // get the movie's current time, and convert it to an initial pan/tilt pair
 myCurrTime := GetMovieTime(theSrcMovie, nil);
	
 VRObject_GetPanAndTiltFromTime(myCurrTime,
                                kDefaultFrameDuration,
                                NumOfColumns,
                                NumOfRows,
                                kDefaultLoopSize,
                                StartPan,
                                EndPan,
                                StartTilt,
                                EndTilt,
                                myInitialPan, myInitialTilt);

 //////////
 //
 // add a media sample to the object track
 //
 //////////

 // create a sample description; this contains no real info, but AddMediaSample requires it
 mySampleDesc := SampleDescriptionHandle(NewHandleClear(sizeof(SampleDescription)));

 myErr := QTNewAtomContainer(myObjectSample);
 if (myErr <> noErr) then goto bail;

 myObjectSampleData.majorVersion := EndianU16_NtoB(kQTVRMajorVersion);
 myObjectSampleData.minorVersion := EndianU16_NtoB(kQTVRMinorVersion);

 myObjectSampleData.movieType := EndianU16_NtoB(kDefaultMovieType);
 myObjectSampleData.viewStateCount := EndianU16_NtoB(kDefaultViewStateCount);
 myObjectSampleData.defaultViewState := EndianU16_NtoB(kDefaultDefaultViewState);
 myObjectSampleData.mouseDownViewState := EndianU16_NtoB(kDefaultMouseDownViewState);

 myObjectSampleData.viewDuration := EndianU32_NtoB(myDuration);
 myObjectSampleData.columns := EndianU32_NtoB(UInt32(numOfColumns));
 myObjectSampleData.rows := EndianU32_NtoB(UInt32(numOfRows));

 myObjectSampleData.mouseMotionScale := kDefaultMouseMotionScale;
 myObjectSampleData.minPan := startPan;
 myObjectSampleData.maxPan := endPan;
 myObjectSampleData.defaultPan := myInitialPan;
 myObjectSampleData.minTilt := startTilt;
 myObjectSampleData.maxTilt := endTilt;
 myObjectSampleData.defaultTilt := myInitialTilt;
 myObjectSampleData.minFieldOfView := kDefaultMinFieldOfView;
 myObjectSampleData.fieldOfView := kDefaultFieldOfView;
 myObjectSampleData.defaultFieldOfView := kDefaultFieldOfView;
 myObjectSampleData.defaultViewCenterH := kDefaultDefaultViewCenterH;
 myObjectSampleData.defaultViewCenterV := kDefaultDefaultViewCenterV;
 myObjectSampleData.viewRate := kDefaultViewRate;
 myObjectSampleData.frameRate := kDefaultFrameRate;

 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.mouseMotionScale);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.minPan);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.maxPan);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.defaultPan);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.minTilt);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.maxTilt);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.defaultTilt);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.minFieldOfView);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.fieldOfView);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.defaultFieldOfView);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.defaultViewCenterH);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.defaultViewCenterV);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.viewRate);
 VRObject_ConvertFloatToBigEndian(@myObjectSampleData.frameRate);

 //myObjectSampleData.animationSettings := EndianU32_NtoB(kDefaultAnimationSettings);
 myObjectSampleData.animationSettings := EndianU32_NtoB(animationSettings); //birbilis: using command-line optional param, which defaults to kDefaultAnimationSettings

 //myObjectSampleData.controlSettings := EndianU32_NtoB(kDefaultControlSettings);
 myObjectSampleData.controlSettings := EndianU32_NtoB(controlSettings); //birbilis: using command-line optional param, which defaults to kDefaultControlSettings

 // insert the object sample atom into the object sample atom container
 myErr := QTInsertChild(myObjectSample, kParentAtomIsContainer, kQTVRObjectInfoAtomType, 1, 1, sizeof(QTVRObjectSampleAtom), @myObjectSampleData, nil);
 if (myErr <> noErr) then goto bail;
	
 // get the duration of the object image track (which is the same as the duration of the linear video track)
 myDuration := GetMovieDuration(theSrcMovie);
	
 // create the media sample
 BeginMediaEdits(theObjectMedia);

 myErr := AddMediaSample(theObjectMedia, Handle(myObjectSample), 0, GetHandleSize(Handle(myObjectSample)), myDuration, SampleDescriptionHandle(mySampleDesc), 1, 0, nil);
 if (myErr <> noErr) then goto bail;

 EndMediaEdits(theObjectMedia);

 // add the media to the track
 myErr := InsertMediaIntoTrack(theObjectTrack, 0, 0, myDuration, fixed1);

bail:
 result:=myErr;
end;


//////////
//
// VRObject_CreateQTVRMovieVers1x0
// Create a single-node QuickTime VR object movie from the specified QuickTime movie.
//
// NOTE: This function builds a movie that conforms to version 1.0 of the QuickTime VR file format.
//
//////////

function VRObject_CreateQTVRMovieVers1x0 (var theObjMovSpec:FSSpec; var theSrcMovSpec:FSSpec):OSErr;
var myObjFormatPtr:QTVRObjectFileFormat1x0Ptr;
    myObjMovie:Movie;
    mySrcMovie:Movie;
    myObjResRefNum:short;
    mySrcResRefNum:short;
    myResID:short;
    myFlags:long;
    myUserData:UserData;
    myDuration:TimeValue;
    myCurrTime:TimeValue;
    myInitialPan, myInitialTilt:Float32;
    myImageTrack:Track;
    myErr:OSErr;
label bail;
begin
 myObjFormatPtr := nil;
 myObjMovie := nil;
 mySrcMovie := nil;
 myObjResRefNum := 0;
 mySrcResRefNum := 0;
 myResID := movieInDataForkResID;
 myFlags := createMovieFileDeleteCurFile or createMovieFileDontCreateResFile;
 //myErr := noErr; //birbilis: not used, commented out

 //////////
 //
 // create a new movie
 //
 //////////

 // create a movie file for the destination movie
 myErr := CreateMovieFile(theObjMovSpec, FOUR_CHAR_CODE('TVOD'), smCurrentScript, myFlags, myObjResRefNum, myObjMovie);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // copy the video track from the linear movie to the new movie; this is the "object video track"
 //
 //////////

 // open the source linear movie file
 myErr := OpenMovieFile(theSrcMovSpec, mySrcResRefNum, fsRdPerm);
 if (myErr <> noErr) then goto bail;

 myErr := NewMovieFromFile(mySrcMovie, mySrcResRefNum, nil, {0} nil, 0, {0} nil);
 if (myErr <> noErr) then goto bail;

 SetMoviePlayHints(mySrcMovie, hintsHighQuality, hintsHighQuality);

 // copy the video track from the linear movie to the object movie
 myErr := VRObject_ImportVideoTrack(mySrcMovie, myObjMovie, myImageTrack);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // get some information from the linear QuickTime movie
 //
 //////////

 // get the duration of a single video frame
 GetMovieNextInterestingTime(mySrcMovie, nextTimeMediaSample, 0, nil, TimeValue(0), fixed1, nil, @myDuration);

 // get the movie's current time, and convert it to an initial pan/tilt pair
 myCurrTime := GetMovieTime(mySrcMovie, nil);

 VRObject_GetPanAndTiltFromTime(myCurrTime,
                                kDefaultFrameDuration,
                                numOfColumns,
                                numOfRows,
                                kDefaultLoopSize,
                                startPan,
                                endPan,
                                startTilt,
                                endTilt,
                                myInitialPan, myInitialTilt);
 //////////
 //
 // add a user data item of type 'NAVG' to the QTVR movie
 //
 //////////

 // create an object file format record
 myObjFormatPtr := QTVRObjectFileFormat1x0Ptr(NewPtrClear(sizeof(QTVRObjectFileFormat1x0Record)));
 if (myObjFormatPtr = nil) then goto bail;

 // fill in the object file format record
 with myObjFormatPtr^ do
  begin
  versionNumber := EndianU16_NtoB(1);
  numberOfColumns := EndianU16_NtoB(numOfColumns);
  numberOfRows := EndianU16_NtoB(numOfRows);
  reserved1 := EndianU16_NtoB(0);
  loopSize := EndianU16_NtoB(kDefaultLoopSize);
  frameDuration	:= EndianU16_NtoB(short(myDuration));
  movieType := EndianU16_NtoB(kDefaultMovieType);
  loopTicks := EndianU16_NtoB(kDefaultLoopTicks);

  fieldOfView := EndianS32_NtoB(FloatToFixed(kDefaultFieldOfView));
  startHPan := EndianS32_NtoB(FloatToFixed(startPan));
  endHPan := EndianS32_NtoB(FloatToFixed(endPan));
  endVPan := EndianS32_NtoB(FloatToFixed(endTilt));
  startVPan := EndianS32_NtoB(FloatToFixed(startTilt));
  initialHPan := EndianS32_NtoB(FloatToFixed(myInitialPan));
  initialVPan := EndianS32_NtoB(FloatToFixed(myInitialTilt));
  reserved2 := EndianU32_NtoB(long(0));
  end;

 // get the movie's user data list
 myUserData := GetMovieUserData(myObjMovie);
 if (myUserData = nil) then
  begin
  myErr := userDataItemNotFound;
  goto bail;
  end;

 // add the object file format data as a user data item to the movie
 myErr := SetUserDataItem(myUserData, myObjFormatPtr, sizeof(QTVRObjectFileFormat1x0Record), kObjectFormat1x0DataType, 0);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // add a user data item that identifies the QTVR movie controller
 //
 //////////

 myErr := VRObject_SetControllerType(myObjMovie, kQTVROldObjectType);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // set the movie's poster time, current time, and preview
 //
 //////////

 // set the poster time to the linear movie's current time
 SetMoviePosterTime(myObjMovie, myCurrTime);

 // set the movie's current time to the poster view time
 SetMovieTimeValue(myObjMovie, myCurrTime);

 // make a movie preview with duration equal to the animation loop
 with myObjFormatPtr^ do
  SetMoviePreviewTime(myObjMovie, myCurrTime, frameDuration * loopSize);

 //////////
 //
 // add the movie resource to the object movie
 //
 //////////

 myErr := AddMovieResource(myObjMovie, myObjResRefNum, myResID, nil);

bail:
 if (myObjFormatPtr <> nil) then
  DisposePtr(Ptr(myObjFormatPtr));

 if (mySrcResRefNum <> 0) then
  CloseMovieFile(mySrcResRefNum);

 if (mySrcMovie <> nil) then
  DisposeMovie(mySrcMovie);

 if (myObjResRefNum <> 0) then
  CloseMovieFile(myObjResRefNum);

 if (myObjMovie <> nil) then
  DisposeMovie(myObjMovie);

 result:=myErr;
end;


//////////
//
// VRObject_CreateQTVRMovieVers2x0
// Create a single-node QuickTime VR object movie from the specified QuickTime movie.
//
// NOTE: This function builds a movie that conforms to version 2.0 of the QuickTime VR file format.
//
//////////

function VRObject_CreateQTVRMovieVers2x0 (var theObjMovSpec:FSSpec; var theSrcMovSpec:FSSpec):OSErr;
var //myHandle:Handle; //birbilis: not used, commented out
    mySampleDesc:SampleDescriptionHandle;
    myQTVRDesc:QTVRSampleDescriptionHandle;
    myVRWorld:QTAtomContainer;
    myNodeInfo:QTAtomContainer;
    myObjMovie:Movie;
    mySrcMovie:Movie;
    myObjResRefNum:short;
    mySrcResRefNum:short;
    myResID:short;
    myQTVRTrack:Track;
    myQTVRMedia:Media;
    myObjectTrack:Track;
    myObjectMedia:Media;
    myImageTrack:Track;
    mySize:long;
    myFlags:long;
    myDuration:TimeValue;
    myScale:TimeScale;
    myWidth, myHeight:Fixed;
    myErr:OSErr;
label bail;
begin
 //myHandle := nil; //birbilis: not used, commented out
 mySampleDesc := nil;
 myQTVRDesc := nil;
 myObjMovie := nil;
 mySrcMovie := nil;
 myObjResRefNum := 0;
 mySrcResRefNum := 0;
 myResID := movieInDataForkResID;
 //myQTVRTrack := nil; //birbilis: not used, commented out
 //myQTVRMedia := nil; //birbilis: not used, commented out
 //myObjectTrack := nil; //birbilis: not used, commented out
 //myObjectMedia := nil; //birbilis: not used, commented out
 myImageTrack := nil;
 myFlags := createMovieFileDeleteCurFile or createMovieFileDontCreateResFile;
 //myErr := noErr; //birbilis: not used, commented out

 //////////
 //
 // create a new movie
 //
 //////////

 // create a movie file for the destination movie
 myErr := CreateMovieFile(theObjMovSpec, FOUR_CHAR_CODE('TVOD'), smCurrentScript, myFlags, myObjResRefNum, myObjMovie);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // copy the video track from the linear movie to the new movie; this is the "object image track"
 //
 //////////

 // open the source linear movie file
 myErr := OpenMovieFile(theSrcMovSpec, mySrcResRefNum, fsRdPerm);
 if (myErr <> noErr) then goto bail;

 myErr := NewMovieFromFile(mySrcMovie, mySrcResRefNum, nil, {0} nil, 0, {0} nil);
 if (myErr <> noErr) then goto bail;

 SetMoviePlayHints(mySrcMovie, hintsHighQuality, hintsHighQuality);

 // copy the video track from the linear movie to the object movie
 myErr := VRObject_ImportVideoTrack(mySrcMovie, myObjMovie, myImageTrack);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // get some information from the linear QuickTime movie
 //
 //////////

 // get the duration and dimensions of the object image track
 myDuration := GetTrackDuration(myImageTrack);
 GetTrackDimensions(myImageTrack, myWidth, myHeight);
 myScale := GetMediaTimeScale(GetTrackMedia(myImageTrack));

 //////////
 //
 // create the QTVR movie track and media
 //
 //////////

 myQTVRTrack := NewMovieTrack(myObjMovie, myWidth, myHeight, kFullVolume);
 myQTVRMedia := NewTrackMedia(myQTVRTrack, kQTVRQTVRType, myScale, nil, 0);
 if ((myQTVRTrack = nil) or (myQTVRMedia = nil)) then goto bail;

 // create a VR world atom container and a node information atom container;
 // remember that the VR world becomes part of the QTVR sample description,
 // and the node information atom container becomes the media sample data
 myErr := VRObject_CreateVRWorld(myVRWorld, myNodeInfo, kQTVRObjectType);
 if (myErr <> noErr) then goto bail;

 if ((myVRWorld = nil) or (myNodeInfo = nil)) then goto bail;

 // create a QTVR sample description
 mySize := sizeof(QTVRSampleDescription) + GetHandleSize(Handle(myVRWorld)) - sizeof(long);
 myQTVRDesc := QTVRSampleDescriptionHandle(NewHandleClear(mySize));
 if (myQTVRDesc = nil) then goto bail;

 with myQTVRDesc^^ do
  begin
  descSize := mySize;
  descType := kQTVRQTVRType;
  reserved1 := 0;
  reserved2 := 0;
  dataRefIndex := 0;
  end;

 // copy the VR world atom container into the data field of the QTVR sample description
 BlockMove(Handle(myVRWorld)^, @(myQTVRDesc^^.data), GetHandleSize(Handle(myVRWorld)));

 // create the media sample
 BeginMediaEdits(myQTVRMedia);

 myErr := AddMediaSample(myQTVRMedia, Handle(myNodeInfo), 0, GetHandleSize(Handle(myNodeInfo)), myDuration, SampleDescriptionHandle(myQTVRDesc), 1, 0, nil);
 if (myErr <> noErr) then goto bail;

 EndMediaEdits(myQTVRMedia);

 // add the media to the track
 InsertMediaIntoTrack(myQTVRTrack, 0, 0, myDuration, fixed1);

 //////////
 //
 // create an object track and add it to the movie
 //
 //////////

 // create object track and media
 myObjectTrack := NewMovieTrack(myObjMovie, myWidth, myHeight, 0);
 myObjectMedia := NewTrackMedia(myObjectTrack, kQTVRObjectType, myScale, nil, 0);
 if ((myObjectTrack = nil) or (myObjectMedia = nil)) then goto bail;

 myErr := VRObject_CreateObjectTrack(mySrcMovie, myObjectTrack, myObjectMedia);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // create track references from QTVR track to object track
 // and from the object track to the object image track
 //
 //////////

 if (myObjectTrack <> nil) then
  AddTrackReference(myQTVRTrack, myObjectTrack, kQTVRObjectType, nil);

 if (myImageTrack <> nil) then
  AddTrackReference(myObjectTrack, myImageTrack, kQTVRImageTrackRefType, nil);

 //////////
 //
 // add a user data item that identifies the QTVR movie controller
 //
 //////////

 myErr := VRObject_SetControllerType(myObjMovie, kQTVRQTVRType);
 if (myErr <> noErr) then goto bail;

 //////////
 //
 // add the movie resource to the object movie
 //
 //////////

 myErr := AddMovieResource(myObjMovie, myObjResRefNum, myResID, nil);

bail:
 if (mySampleDesc <> nil) then
  DisposeHandle(Handle(mySampleDesc));

 if (myQTVRDesc <> nil) then
  DisposeHandle(Handle(myQTVRDesc));

 if (myVRWorld <> nil) then
  QTDisposeAtomContainer(myVRWorld);

 if (myNodeInfo <> nil) then
  QTDisposeAtomContainer(myNodeInfo);

 if (myObjResRefNum <> 0) then
  CloseMovieFile(myObjResRefNum);

 if (myObjMovie <> nil) then
  DisposeMovie(myObjMovie);

 if (mySrcResRefNum <> 0) then
  CloseMovieFile(mySrcResRefNum);

 if (mySrcMovie <> nil) then
  DisposeMovie(mySrcMovie);

 result:=myErr;
end;


//////////
//
// VRObject_MakeObjectMovie
// Create a single-node QuickTime VR object movie from the specified linear QuickTime movie file.
//
//////////

function VRObject_MakeObjectMovie (var theMovieSpec:FSSpec; var theDestSpec:FSSpec; theVersion:long):OSErr;
var myTempSpec:FSSpec;
    myTempMovie:Movie;
    myObjectMovie:Movie;
    myTempResRefNum:short;
    myErr:OSErr;
label bail;
begin
 myTempMovie := nil;
 myObjectMovie := nil;
 myTempResRefNum := 0;
 myErr := noErr;

 // create a temporary version of the object movie file,
 // located in the same directory as the destination object movie file;
 // to create a new file name, we'll just change the last character of the destination movie file name
 // (no doubt you could do a better job here!)
 myTempSpec := theDestSpec;

 if (myTempSpec.name[byte(myTempSpec.name[0])] = 't') then
  myTempSpec.name[byte(myTempSpec.name[0])] := '@'
 else
  myTempSpec.name[byte(myTempSpec.name[0])] := 't';

 // create a single node object movie in the temp file
 if (theVersion = kQTVRVersion1) then
  myErr := VRObject_CreateQTVRMovieVers1x0(myTempSpec, theMovieSpec)
 else if (theVersion = kQTVRVersion2) then
  myErr := VRObject_CreateQTVRMovieVers2x0(myTempSpec, theMovieSpec);

 if (myErr <> noErr) then goto bail;

 // create the final, flattened movie
 myErr := OpenMovieFile(myTempSpec, myTempResRefNum, fsRdPerm);
 if (myErr <> noErr) then goto bail;

 myErr := NewMovieFromFile(myTempMovie, myTempResRefNum, nil, {0} nil, 0, {0} nil);
 if (myErr <> noErr) then goto bail;

 // flatten the temporary file into a new movie file;
 // put the movie resource first so that FastStart is possible
 myObjectMovie := FlattenMovieData(myTempMovie, flattenDontInterleaveFlatten or flattenAddMovieToDataFork or flattenForceMovieResourceBeforeMovieData, theDestSpec, FOUR_CHAR_CODE('TVOD'), smSystemScript, createMovieFileDeleteCurFile or createMovieFileDontCreateResFile); //??? check the FSSpec parameter ???

bail:
 if (myObjectMovie <> nil) then
  DisposeMovie(myObjectMovie);

 if (myTempMovie <> nil) then
  DisposeMovie(myTempMovie);

 if (myTempResRefNum <> 0) then
  CloseMovieFile(myTempResRefNum);

 DeleteMovieFile(myTempSpec);

 result:=myErr;
end;


//////////
//
// VRObject_ImportVideoTrack
// Copy a video track from one movie (the source) to another (the destination).
//
//////////

function VRObject_ImportVideoTrack (theSrcMovie:Movie; theDstMovie:Movie; var theImageTrack:Track):OSErr;
var mySrcTrack:Track;
    mySrcMedia:Media;
    myDstTrack:Track;
    //myDstMedia:Media; //birbilis: not used, commented out
    myWidth, myHeight:Fixed;
    myType:OSType;
    //myErr:OSErr; //birbilis: not used, commented out
begin
 //mySrcTrack := nil; //birbilis: not used, commented out
 //mySrcMedia := nil; //birbilis: not used, commented out
 //myDstTrack := nil; //birbilis: not used, commented out
 //myDstMedia := nil; //birbilis: not used, commented out

 //myErr := noErr; //birbilis: not used, commented out

 ClearMoviesStickyError();

 // get the first video track in the source movie
 mySrcTrack := GetMovieIndTrackType(theSrcMovie, 1, VideoMediaType, movieTrackMediaType);
 if (mySrcTrack = nil) then
  begin result:=paramErr; exit; end;

 // get the track's media and dimensions
 mySrcMedia := GetTrackMedia(mySrcTrack);
 GetTrackDimensions(mySrcTrack, myWidth, myHeight);

 // create a destination track
 myDstTrack := NewMovieTrack(theDstMovie, myWidth, myHeight, GetTrackVolume(mySrcTrack));

 // create a destination media
 GetMediaHandlerDescription(mySrcMedia, myType, {0}nil, {0}nil);
 {myDstMedia :=} NewTrackMedia(myDstTrack, myType, GetMediaTimeScale(mySrcMedia), {0} nil, 0); //birbilis: myDstMedia result wasn't used, commented out

 // copy the entire track
 InsertTrackSegment(mySrcTrack, myDstTrack, 0, GetTrackDuration(mySrcTrack), 0);
 CopyTrackSettings(mySrcTrack, myDstTrack);
 SetTrackLayer(myDstTrack, GetTrackLayer(mySrcTrack));

 // an object video track should always be enabled
 SetTrackEnabled(myDstTrack, true);

 //if (theImageTrack <> nil) then //birb: removed (fixed-bug: we use a "var" parameter instead of a pointer so there's no chance the user passed a null variable reference there)
 theImageTrack := myDstTrack;

 result:=GetMoviesStickyError();
end;


//////////
//
// VRObject_GetPanAndTiltFromTime
// Get the pan and tilt angles that correspond to the specified movie time.
//
//////////

function VRObject_GetPanAndTiltFromTime (theTime:TimeValue;
                                         theFrameDuration:TimeValue;
                                         theNumColumns:short;
                                         theNumRows:short;
                                         theLoopSize:short;
                                         theStartPan:Float32;
                                         theEndPan:Float32;
                                         theStartTilt:Float32;
                                         theEndTilt:Float32;
                                         var thePan:Float32;var theTilt:Float32):OSErr;
var
 myRow, myColumn:short;
 myTime:TimeValue;
 myPanRange:Float32;
 myTiltRange:Float32;
 myErr:OSErr;
begin
 myErr := noErr;

 myPanRange := theEndPan - theStartPan;
 myTiltRange := theStartTilt - theEndTilt;

 theTime := trunc(theTime / theFrameDuration); // adjust for frame duration (Birbilis: there's no /= operator in Delphi, copied the term at the left side to the start of the right side of the expression) //birbilis: added "trunc"

 myTime := trunc(theTime / theLoopSize); //birbilis: added "trunc"
 myRow := trunc(myTime / theNumColumns); //birbilis: added "trunc"
 myColumn := myTime mod theNumColumns; //C's "%" is Delphi's "mod"

 // note the mixed Float32 and integer math
 if (theNumColumns = 1) then
  thePan := theStartPan
 else if (myPanRange = 360.0) then
  thePan := theStartPan + (myColumn * (myPanRange / (theNumColumns)))
 else
  thePan := theStartPan + (myColumn * (myPanRange / (theNumColumns - 1)));

 if (theNumRows = 1) then
  theTilt := theStartTilt
 else
  theTilt := theStartTilt - (myRow * (myTiltRange / (theNumRows - 1)));

 result:=myErr;
end;


//////////
//
// VRObject_SetControllerType
// Set the controller type of the specified movie.
//
// This function adds an item to the movie's user data;
// the updated user data is written to the movie file when the movie is next updated
// (by calling AddMovieResource or UpdateMovieResource).
//
//////////

function VRObject_SetControllerType (theMovie:Movie;theType:OSType):OSErr;
var myUserData:UserData;
    myErr:OSErr;
begin
 //myErr := noErr; //birbilis: not needed

 // make sure we've got a movie
 if (theMovie = nil) then
  begin result:=paramErr; exit; end;

 // get the movie's user data list
 myUserData := GetMovieUserData(theMovie);
 if (myUserData = nil) then
  begin result:=paramErr; exit; end;

 theType := EndianU32_NtoB(theType);
 myErr := SetUserDataItem(myUserData, theType, sizeof(theType), kQTControllerType, 0);

 result:=myErr;
end;


//////////
//
// VRObject_AddStr255ToAtomContainer
// Add a Pascal string to the specified atom container; return (through theID) the ID of the new string atom.
//
//////////

function VRObject_AddStr255ToAtomContainer (theContainer:QTAtomContainer;theParent:QTAtom;theString:Str255;var theID:QTAtomID):OSErr;
var myErr:OSErr;
    myStringAtom:QTAtom;
    mySize:UInt16;
    myStringAtomPtr:QTVRStringAtomPtr;
begin
 myErr := noErr;

 theID := 0; // initialize the returned atom ID

 if ((theContainer = nil) or (theParent = 0)) then
  begin result:=paramErr; exit; end;

 if (theString[0] <> #0) then
  begin
  //myStringAtomPtr := nil; //birbilis: not used, commented out

  mySize := sizeof(QTVRStringAtom) - 4 + byte(theString[0]) + 1;
  myStringAtomPtr := QTVRStringAtomPtr(NewPtrClear(mySize));

  if (myStringAtomPtr <> nil) then
   begin
   myStringAtomPtr^.stringUsage := EndianU16_NtoB(1);
   myStringAtomPtr^.stringLength := EndianU16_NtoB(byte(theString[0]));
   BlockMove(@theString[1], @myStringAtomPtr^.theString, byte(theString[0]));
   myStringAtomPtr^.theString[byte(theString[0])] := #0;
   myErr := QTInsertChild(theContainer, theParent, kQTVRStringAtomType, 0, 0, mySize, Ptr(myStringAtomPtr), @myStringAtom);
   DisposePtr(Ptr(myStringAtomPtr));

   if (myErr = noErr) then
    QTGetAtomTypeAndID(theContainer, myStringAtom, nil, theID);
   end;
  end;

 result:=myErr;
end;


//////////
//
// VRObject_ConvertFloatToBigEndian
// Convert the specified floating-point number to big-endian format.
//
//////////

procedure VRObject_ConvertFloatToBigEndian (theFloat:floatPtr);
var myLongPtr:unsigned_longPtr;
begin
 myLongPtr := unsigned_longPtr(theFloat);
 myLongPtr^ := EndianU32_NtoB(myLongPtr^);
end;


//////////
//
// VRObject_FileFilterFunction
// Filter files for a file-opening dialog box.
//
//////////

function VRObject_FileFilterFunction;
begin //"thePBPtr" is unused
 result:=false;
end;

begin //check results below...
 if(paramCount<6) then
  begin
  MessageBox(0,pchar('Syntax: VRMakeObject cols rows startPan endPan startTilt endTilt [controlSettings [animationSettings [inputFilename [outputFilename]]]]'),pchar('VRMakeObject / JEDI-QuickTime demo'),MB_ICONERROR);
  halt(1);
  end;

 numOfColumns:=strToInt(paramStr(1));
 numOfRows:=strToInt(paramStr(2));
 startPan:=strToInt(paramStr(3));
 endPan:=strToInt(paramStr(4));
 startTilt:=strToInt(paramStr(5));
 endTilt:=strToInt(paramStr(6));
 if (paramCount<7)
  then controlSettings:=kDefaultControlSettings
  else controlSettings:=strToInt(paramStr(7)); //OR mask made of: kQTVRObjectWrapPanOn, kQTVRObjectWrapTiltOn, kQTVRObjectCanZoomOn, kQTVRObjectHControlOn, kQTVRObjectVControlOn, kQTVRObjectSwapHVControlOn, kQTVRObjectTranslationOn (defined in QuickTimeVRFormat.h at the QuickTime SDK)
 if (paramCount<8)
  then animationSettings:=kDefaultAnimationSettings
  else animationSettings:=strToInt(paramStr(8)); //OR mask made of: kQTVRObjectAnimateViewFramesOn, kQTVRObjectPalindromeViewFramesOn, kQTVRObjectStartFirstViewFrameOn, kQTVRObjectAnimateViewsOn, kQTVRObjectPalindromeViewsOn, kQTVRObjectSyncViewToFrameRate, kQTVRObjectDontLoopViewFramesOn, kQTVRObjectPlayEveryViewFrameOn, kQTVRObjectStreamingViewsOn
 inputFilename:=paramStr(9); //if that parameter is missing will be ''
 outputFilename:=paramStr(10); //if that parameter is missing will be ''

 InitializeQTML(0);
 EnterMovies;
 VRObject_PromptUserForMovieFileAndMakeObject;
 ExitMovies;
 TerminateQTML;
end.

