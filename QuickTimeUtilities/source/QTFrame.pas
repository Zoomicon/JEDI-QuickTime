// Ported from Apple's ComFramework.h and ComFrameWork.c to Delphi by G.Birbilis
// History of porting to Delphi:
//  26Jun2002 - first version (was needed by VRMakeObject.dpr)
//  30Jun2002 - change to the usage of FSMakeFSSpec to match some header changes
//  22Jun2003 - at "QTFrame_GetOneFileWithPreview", changed "theFilterProc" parameter from "untyped variable" to "pointer value"

unit QTFrame; //named as QTFrame (didn't remove the QTFrame_ prefix from the routines)

interface
 uses
  qt_MacTypes,
  Windows,
  qt_StandardFile,
  qt_Files,
  qt_ImageCompression;

//////////
//
//	File:		ComFramework.h
//
//	Contains:	Code for the QuickTime sample code framework that is common to both Macintosh and Windows.
//
//	Written by:	Tim Monroe
//				Based on the QTShell code written by Tim Monroe, which in turn was based on the MovieShell
//				code written by Kent Sandvik (Apple DTS). This current version is now very far removed from
//				MovieShell.
//
//	Copyright:	© 1999 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <2>	 	01/14/00	rtm		added fGraphicsImporter field to window object record
//	   <1>	 	11/05/99	rtm		first file
//
//////////

//////////
//
// data types
//
//////////

type
 QTFrameTypeListPtr={const}^OSType;

type
 MenuReference=HMENU;
 WindowReference=HWND;
 QTFrameFileFilterUPP=FileFilterUPP;

procedure QTFrame_Beep;
function QTFrame_PutFile(thePrompt:ConstStr255Param;theFileName:ConstStr255Param;theFSSpecPtr:FSSpecPtr;var theIsSelected:Boolean;var theIsReplacing:Boolean):OSErr;
function QTFrame_GetOneFileWithPreview(theNumTypes:short;theTypeList:QTFrameTypeListPtr;theFSSpecPtr:FSSpecPtr;theFilterProc:pointer):OSErr;
function QTFrame_GetFileFilterUPP(theFileFilterProc:ProcPtr):QTFrameFileFilterUPP;

implementation
uses qt_Errors;

//////////
//
//	File:		ComFramework.c
//
//	Contains:	Code for the QuickTime sample code framework that is common to both Macintosh and Windows.
//
//	Written by:	Tim Monroe
//				Based on the QTShell code written by Tim Monroe, which in turn was based on the MovieShell
//				code written by Kent Sandvik (Apple DTS). This current version is now very far removed from
//				MovieShell.
//
//	Copyright:	© 1999-2000 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <25>	 	02/12/01	rtm		fixed stupid bug in QTFrame_PutFile (was calling NavDisposeReply before
//									reading data from reply record); d'oh!
//	   <24>	 	02/01/01	rtm		fixed *Proc names to *UPP, to conform to Universal Header 3.4b4
//	   <23>	 	11/24/00	rtm		added QTFrame_GetWindowReferenceFromWindow
//	   <22>	 	10/09/00	rtm		added QTFrame_IsMovieWindow and QTFrame_IsImageWindow; reworked the function
//									QTFrame_SizeWindowToMovie to use these calls
//	   <21>	 	10/02/00	rtm		added code in QTFrame_SaveAsMovieFile to remove empty resource fork created
//									by FlattenMovieData; commented out calls to MakeFilePreview, since it always
//									adds a resource fork; will replace MakeFilePreview by QTInfo_MakeFilePreview
//	   <20>	 	07/26/00	rtm		converted gValidFileTypes into a handle (it was previously a pointer)
//	   <19>	 	07/07/00	rtm		further work on QTFrame_AdjustMenus and QTFrame_ConvertMacToWinMenuItemLabel 
//	   <18>	 	07/06/00	rtm		added theModifiers parameter to QTFrame_AdjustMenus; updated it to support 
//									modifier keys under Windows; added QTFrame_ConvertMacToWinMenuItemLabel
//	   <17>	 	04/24/00	rtm		added calls to MakeFilePreview
//	   <16>	 	03/15/00	rtm		modified QTFrame_SaveAsMovieFile to create a single-fork, self-contained,
//									interleaved, Fast Start movie
//	   <15>	 	03/02/00	rtm		made changes to get things running under CarbonLib
//	   <14>	 	02/16/00	rtm		added QTFrame_GetWindowPtrFromWindowReference
//	   <13>	 	01/19/00	rtm		revised QTFrame_IsAppWindow (dialog windows no longer count as application
//									windows); added QTFrame_BuildFileTypeList and QTFrame_AddComponentFileTypes
//									to avoid calling GetMovieImporterForDataRef in QTFrame_FilterFiles; removed
//									the hard-coded file types
//	   <12>	 	01/14/00	rtm		added support for graphics files, using graphics importers
//	   <11>	 	12/28/99	rtm		added QTFrame_ConvertMacToWinRect and QTFrame_ConvertWinToMacRect
//	   <10>	 	12/21/99	rtm		hard-coded some file types into QTFrame_FilterFiles; if we let QuickTime
//									to do all the testing (using GetMovieImporterForDataRef), it takes too long
//	   <9>	 	12/17/99	rtm		added some code to QTFrame_SetMenuItemState to work around a problem that
//									appears under MacOS 8.5.1 (as far as I can tell...)
//	   <8>	 	12/16/99	rtm		added QTApp_HandleMenu calls to _HandleFileMenuItem and _HandleEditMenuItem
//									to allow the application-specific code to intercept menu item selections;
//									added QTFrame_FilterFiles
//	   <7>	 	12/15/99	rtm		added QTApp_Idle call to QTFrame_IdleMovieWindows
//	   <6>	 	12/11/99	rtm		added GetMenuState call to Windows portion of QTFrame_SetMenuItemLabel;
//									tweaked _SizeWindowToMovie to guard against NULL movie and/or controller
//	   <5>	 	11/30/99	rtm		added QTFrame_CloseMovieWindows
//	   <4>	 	11/27/99	rtm		added QTFrame_GetFileFilterUPP
//	   <3>	 	11/17/99	rtm		finished support for Navigation Services; added QTFrame_IdleMovieWindows
//	   <2>	 	11/16/99	rtm		begun support for Navigation Services
//	   <1>	 	11/05/99	rtm		first file
//
//	This file contains several kinds of functions: (1) functions that use completely cross-platform APIs and
//	which therefore can be compiled and run for both Mac and Windows platforms with no changes whatsoever (a
//	good example of this is QTFrame_SaveAsMovieFile); (2) functions that are substantially the same on both
//	platforms but which require several short platform-dependent #ifdef TARGET_OS_ blocks (a good example of
//	this is QTFrame_AdjustMenus); (3) functions that retrieve data from framework-specific data structures (a
//	good example of this is QTFrame_GetWindowObjectFromWindow); (4) functions that provide a platform-neutral
//	interface to platform-specific operations (a good example of this is QTFrame_Beep). In a nutshell, this
//	file attempts to provide platform-independent services to its callers, typically functions in the files
//	MacFramework.c, WinFramework.c, and ComApplication.c.
//
//	In general, you should not need to modify this file. Your application-specific code should usually be put
//	into the file ComApplication.c.
//
//////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Miscellaneous utilities.
//
// Use the following functions to play beeps, manipulate menus, and do other miscellaneous things.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// QTFrame_Beep
// Beep.
//
//////////

procedure QTFrame_Beep;
begin
{$ifdef TARGET_OS_MAC}
 SysBeep(30);
{$else} //TARGET_OS_WIN32
 MessageBeep(MB_OK);
{$endif}
end;

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// File-opening and -saving utilities.
//
// The functions are meant to provide replacements for StandardGetFilePreview and StandardPutFile, which
// are not supported under Carbon. However, Navigation Services is not (yet, at any rate) supported under
// Windows, so we still need to call through to the Standard File Package.
//
// The Navigation Services portion of this code is based selectively on the file NavigationServicesSupport.c
// by Yan Arrouye and on the developer documentation "Programming With Navigation Services 1.1". The code that
// determines which files can be opened by QuickTime is based on code by Sam Bushell in CarbonMovieEditor.c.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// QTFrame_PutFile
// Save a file under the specified name. Return Boolean values indicating whether the user selected a file
// and whether the selected file is replacing an existing file.
//
//////////

function QTFrame_PutFile;
var myReply:StandardFileReply;
    myErr:OSErr;
begin
 myErr := noErr;

 if ((theFSSpecPtr = nil) {or (theIsSelected = nil) or (theIsReplacing = nil)}) then //birbilis: var parameters usually aren't nil
  begin result:=paramErr; exit; end;

 // deactivate any frontmost movie window
 //QTFrame_ActivateController(QTFrame_GetFrontMovieWindow(), false);

 // assume we are not replacing an existing file
 theIsReplacing := false;

 StandardPutFile(thePrompt, theFileName, myReply);
 theFSSpecPtr^ := myReply.sfFile;
 theIsSelected := myReply.sfGood;
 if (myReply.sfGood) then
  theIsReplacing := myReply.sfReplacing;

 result:=myErr;
end;


//////////
//
// QTFrame_GetOneFileWithPreview
// Display the appropriate file-opening dialog box, with an optional QuickTime preview pane. If the user
// selects a file, return information about it using the theFSSpecPtr parameter.
//
// Note that both StandardGetFilePreview and NavGetFile use the function specified by theFilterProc as a
// file filter. This framework always passes NULL in the theFilterProc parameter. If you use this function
// in your own code, keep in mind that on Windows the function specifier must be of type FileFilterUPP and 
// on Macintosh it must be of type NavObjectFilterUPP. (You can use the QTFrame_GetFileFilterUPP to create
// a function specifier of the appropriate type.) Also keep in mind that Navigation Services expects a file
// filter function to return true if a file is to be displayed, while the Standard File Package expects the
// filter to return false if a file is to be displayed.
//
//////////

function QTFrame_GetOneFileWithPreview;
var myReply:StandardFileReply;
    myErr:OSErr;
begin
 //myErr := noErr; //birbilis: not used, commented out

 if (theFSSpecPtr = nil) then
  begin result:=paramErr; exit; end;

 // deactivate any frontmost movie window
 //QTFrame_ActivateController(QTFrame_GetFrontMovieWindow(), false);

 // prompt the user for a file
 StandardGetFilePreview(FileFilterUPP(theFilterProc), theNumTypes, ConstSFTypeListPtr(theTypeList), myReply);
 if (not myReply.sfGood) then
  begin result:=userCanceledErr; exit; end;

 // make an FSSpec record
 myErr := FSMakeFSSpec(myReply.sfFile.vRefNum, myReply.sfFile.parID, @myReply.sfFile.name, theFSSpecPtr);

 result:=myErr;
end;


//////////
//
// QTFrame_GetFileFilterUPP
// Return a UPP for the specified file-selection filter function.
//
// The caller is responsible for disposing of the UPP returned by this function (by calling DisposeNavObjectFilterUPP).
//
//////////

function QTFrame_GetFileFilterUPP;
begin
 result:=NewFileFilterProc(FileFilterProcPtr(theFileFilterProc));
end;

end.

