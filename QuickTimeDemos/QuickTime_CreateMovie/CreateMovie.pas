(*********************************************************************
Version:
- 01Nov2000 - George Birbilis - first version based on CreateMovie.c
- 11Jun2001 - George Birbilis - made changes to compile
- 07Aug2004 - George Birbilis - using "Windows" instead of "Dialogs" unit
- 16Apr2005 - George Birbilis - fixed some errors to compile OK
*********************************************************************)

--- THIS IS NOT YET FINISHED, IT DOESN'T COMPILE ---

(* File:		CreateMovie.c
   Contains:	QuickTime CreateMovie sample code

   Written by:	Scott Kuechle
  (based heavily on QuickTime sample code in Inside Macintosh: QuickTime)

  Copyright:	© 1998 by Apple Computer, Inc. All rights reserved

  Change History (most recent first)

   <3>	 	09/30/98	rtm		tweaked calls to CreateMovieFIle and AddMovieResource to create single-fork movies
   <2>		09/28/98	rtm		changes for Metrowerks compiler
   <1>		06/26/98	srk		first file
*)

unit CreateMovie;

interface

 function CreateAMovie:boolean;

implementation
 uses
  C_Types,
  qt_MacTypes,
  qt_Movies,
  qt_Files,
  qt_Script,
  QTVideo,
  QTUtils,
  Windows;

const kMsgDialogRsrcID = 129;
      kMsgItemID       = 3;

var kPrompt:string = 'Enter the movie file name:';
var kFileName:string = 'MovieFile.mov';

(*
Sample Player's creator type since it is the movie player
of choice. You can use your own creator type, of course.
*)

const kMyCreatorType = (((ord('T')shl 8 +ord('V'))shl 8 +ord('O'))shl 8 +ord('D')); {'TVOD'}


(************************************************************
*                                                           *
*    CheckError()                                           *
*                                                           *
*    Displays error message if an error occurred            *
*                                                           *
*************************************************************)

procedure CheckError(error:OSErr; msg:string);
begin
 if (error = noErr) then exit;
 if (length(msg) > 0) then MessageBox(0,pchar(msg),pchar(''),0);
end;


(************************************************************
*                                                           *
*    CreateAMovie()                                         *
*                                                           *
*    Creates a QuickTime movie with both a sound & video    *
*    track                                                  *
*                                                           *
*************************************************************)

function CreateAMovie;//:boolean;
const where:Point=(v:100;h:100);
var theMovie:Movie;
    mySpec:FSSpec;
    resRefNum:short;
    resId:short;
    fileName:StringPtr;
    prompt:StringPtr;
    isSelected:boolean;
    isReplacing:boolean;
    err:OSErr;
label bail;
begin
 theMovie := nil;
 resRefNum := 0;
 resId := movieInDataForkResID;
 fileName := @kFileName;
 prompt := @kPrompt;
 isSelected := false;
 isReplacing := false;
 err := noErr;

 //QTFrame_PutFile(prompt, fileName, @mySpec, @isSelected, @isReplacing);
 if (not isSelected) then goto bail;

 // Create and open the movie file, this call creates an empty movie which
 // references the file, and opens the movie file with write permission.
 err := CreateMovieFile(mySpec,							(* FSSpec specifier *)
  		        kMyCreatorType, (* file creator type *)
			smCurrentScript, (* movie file creation flags *)
                        createMovieFileDeleteCurFile +
                        createMovieFileDontCreateResFile +
                        newMovieActive,
                        resRefNum,  (* file ref num *)
                        theMovie ); (* field to recieve movie specification *)
 CheckError(err, 'CreateMovieFile error');

 // Call our functions to create the video track and the sound track.
 QTVideo_CreateMyVideoTrack(theMovie);
 QTSound_CreateMySoundTrack(theMovie);

 // Add the movie resource to the movie file. We use movieInDataForkResID for the resID.
 // This will add the movie resource to the file's data fork for a single-fork movie file
 // instead of adding the resource to the file's resource fork.
 err := AddMovieResource(theMovie,  (* movie specification *)
                        resRefNum, (* file ref num *)
                        resId,    (* movie resource id *)
                        fileName); (* name of the movie resource *)
 CheckError(err, 'AddMovieResource error');

 if (resRefNum) then
  CloseMovieFile(resRefNum); //Close our open movie file

bail:
 //free(fileName);
 //free(prompt);

 result:=QTFrame_OpenMovieInWindow(theMovie, @mySpec);
end;

end.

