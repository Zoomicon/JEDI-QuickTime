//Version: 16Jun2003 (http://developer.apple.com/samplecode/Sample_Code/QuickTime/Goodies/qtmoviefromurl/QTMovieFromURL.c.htm)

unit QTURL;

interface

//////////
//
//	File:		QTMovieFromURL.h
//
//	Contains:	Sample code for opening a QuickTime movie specified by a URL.
//
//	Written by:	Tim Monroe
//
//	Copyright:	© 1998 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <1>	 	10/29/98	rtm		first file
//	 
//////////

uses qt_Movies;

 const kURLSeparator='/'; // URL path separator

 function NewMovieFromURL(theURL:pchar):Movie;
 function GetURLBasename(theURL:pchar):pchar;

implementation

//////////
//
//	File:		QTMovieFromURL.c
//
//	Contains:	Sample code for opening a QuickTime movie specified by a URL.
//
//	Written by:	Tim Monroe
//
//	Copyright:	© 1998 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <1>	 	10/29/98	rtm		first file
//	 
//	QuickTime Streaming has a URL data handler, which you can use to open movies that are
// 	specified using uniform resource locators (URLs). A URL is the address of some resource
//	on the Internet or on a local disk. The QuickTime URL data handler can open http URLs,
//	ftp URLs, file URLs, and rtsp URLs.
//
//	This snippet defines several functions. The function QTURL_NewMovieFromURL takes a URL
//	as a parameter and opens the movie file located at the specified location. You can use
//	the function QTURL_GetURLBasename to get the basename of the URL (which is suitable for
//	use as the title of the window you display the movie in).
//
//////////

 uses
  SysUtils,
  qt_MacTypes,
  qt_MacMemory,
  C_Types;

//////////
//
// QTURL_NewMovieFromURL
// Open the movie file referenced by the specified uniform resource locator (URL).
//
//////////

function NewMovieFromURL(theURL:pchar):Movie;
var myMovie:Movie;
    myHandle:Handle;
    mySize:Size;
label bail;
begin

 //////////
 //
 // copy the specified URL into a handle
 //
 //////////

 myMovie:=nil;
 myHandle:=nil;

 // get the size of the URL, plus the terminating null byte
 mySize := size(strlen(theURL)+1);
 if (mySize <= 1) then goto bail; //Birb: using "<= 1" instead of "= 0"

(**)
 // allocate a new handle
 myHandle := NewHandleClear(mySize);
 if (myHandle = nil) then goto bail;

 // copy the URL into the handle
 BlockMove(theURL, myHandle^, mySize);
(**)

(*
 //---> alternative to NewHandleClear+BlockMove by Chris Flick (flick@apple.com)
 // PtrToHand takes a pointer to a buffer and a size to be copied into a newly allocated Handle
 // Since we have a C string pointer and therefore know there is a trailing 0, we use mySize.
 // myHandle should be updated with the newly allocated Handle
 if (PtrToHand(theURL, myHandle, mySize) <> noErr) then goto bail;
*)

 //////////
 //
 // instantiate a movie from the specified URL
 //
 // the data reference that is passed to NewMovieFromDataRef is a handle
 // containing the text of the URL, *with* a terminating null byte; this
 // is an exception to the usual practice with data references (where you
 // need to pass a handle to a handle containing the relevant data)
 //
 //////////

 NewMovieFromDataRef(myMovie, newMovieActive, nil, myHandle, URLDataHandlerSubType);

bail:
 if (myHandle <> nil)
  then DisposeHandle(myHandle);

 result:=myMovie;
end;


//////////
//
// QTURL_GetURLBasename
// Return the basename of the specified URL.
//
// The basename of a URL is the portion of the URL following the rightmost URL separator. This function
// is useful for setting window titles of movies opened using the URL data handler to the basename of a
// URL (just like MoviePlayer does).
//
// The caller is responsible for disposing of the pointer returned by this function (by calling FreeMem [Free is FreeMem in Delphi]).
//
//////////

function GetURLBasename(theURL:pchar):pchar;
var myBasename:pchar;
    myLength:short;
    myIndex:short;
label bail;
begin
 myBasename:=nil; //Birb

 // make sure we got a URL passed in
 if (theURL = nil) then goto bail;

 // get the length of the URL
 myLength := strlen(theURL);

 // find the position of the rightmost URL separator in theURL
 if (strpos(theURL, kURLSeparator) <> nil) then //"strchr" is "strpos" in Delphi (to work with MBCS chars use AnsiStrPos)
  begin
  myIndex := myLength - 1;

  while (theURL[myIndex] <> kURLSeparator) do
   dec(myIndex);

  // calculate the length of the basename
  myLength := myLength - myIndex - 1;

  end
 else
  // there is no rightmost URL separator in theURL;
  // set myIndex so that myIndex + 1 == 0, for the call to BlockMove below
  myIndex := -1;


 // allocate space to hold the string that we return to the caller
 myBasename := AllocMem(myLength + 1); //malloc is AllocMem in Delphi
 if (myBasename = nil) then goto bail;

 // copy into myBasename the substring of theURL from myIndex + 1 to the end
 BlockMove(@theURL[myIndex+1],myBasename, myLength);
 myBasename[myLength] := #0;

bail:
 result:=myBasename;
end;

end.