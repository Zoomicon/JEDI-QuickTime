unit QTStep;

interface

//23May2002 - birbilis: minor code adjustments 

//////////
//
//	File:		QTFrameStepper.h
//
//	Contains:	Functions to step frame-by-frame through a QuickTime movie.
//
//	Written by:	Tim Monroe
//
//	Copyright:	© 1997 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <1>	 	12/22/97	rtm		first file
//
//////////

 uses qt_Movies,
      qt_MacTypes,
      C_Types;

//////////
//
// constants
//
//////////

const kBogusStartingTime=-1; // an invalid starting time

//////////
//
// function prototypes
//
//////////

function QTStep_GetStartTimeOfFirstVideoSample(theMovie:Movie; var theTime:TimeValue):OSErr;
function QTStep_DrawVideoSampleAtTime(theMovie:Movie; theTime:TimeValue):OSErr;
function QTStep_DrawVideoSampleNextOrPrev(theMovie:Movie; theRate:Fixed):OSErr;

function QTStep_GoToFirstVideoSample(theMovie:Movie):OSErr;
function QTStep_GoToNextVideoSample(theMovie:Movie):OSErr;
function QTStep_GoToPrevVideoSample(theMovie:Movie):OSErr;

function QTStep_MCGoToFirstVideoSample(theMC:MovieController):OSErr;
function QTStep_MCGoToNextVideoSample(theMC:MovieController):OSErr;
function QTStep_MCGoToPrevVideoSample(theMC:MovieController):OSErr;

function QTStep_GetFrameCount(theTrack:Track):long;

implementation

//////////
//
//	File:		QTFrameStepper.c
//
//	Contains:	Functions to step frame-by-frame through a QuickTime movie.
//
//	Written by:	Tim Monroe
//				Parts based on DTSQTUtilities.c by Apple Developer Technical Support
//				and on SimpleInMovies sample code by Guillermo A. Ortiz.
//
//	Copyright:	© 1997 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//
//	   <5>	 	11/18/98	rtm		added QTStep_GetFrameCount, for illustrative purposes only
//	   <4>	 	03/09/98	rtm		changed nextTimeMediaSample flag to nextTimeStep (to support MPEG files)
//	   <3>	 	01/05/98	rtm		revised and augmented comments
//	   <2>	 	01/02/98	rtm		some code clean-up
//	   <1>	 	12/22/97	rtm		first file
//
//	This file defines functions that you can use to step frame-by-frame through a QuickTime movie.
//	Indeed, it illustrates *two* different methods for doing this: (1) using Movie Toolbox functions
//	to advance (or retreat) to interesting times in the movie; and (2) using movie controller actions
//	to step forward or backward through a movie. To my knowledge, there are no particular advantages
//	to using one or the other method, except that the second method is (as you will see) quite a bit
//	simpler to code.
//
//	METHOD ONE: Use Movie Toolbox calls to step to interesting times in the movie. An interesting time
//	is a time value in a movie, track, or media that meets certain search conditions that you specify.
//	We'll use a very simple search condition: locate the next (or previous) sample in the movie's media.
//	Once we have an interesting time, we display the sample at that time by calling SetMovieTimeValue.
//	To implement this first method, we define three functions (which all operate on an open movie):
//
//	-> QTStep_GoToNextVideoSample: display the sample that follows the current sample in a movie
//	-> QTStep_GoToPrevVideoSample: display the sample that precedes the current sample in a movie
//	-> QTStep_GoToFirstVideoSample: display the first video sample in a movie
//
//	Internally, these functions depend on three static functions defined at the beginning of this file.
//	The code here is extremely straightforward. The only "gotcha" concerns finding the first
//	interesting time in a movie. See the description of QTStep_GetStartTimeOfFirstVideoSample for
//	details.
//
//	METHOD TWO: Use movie controller actions to step through frames in the movie. This method uses
//	the MCDoAction function with the mcActionStep and mcActionGoToTime actions. Using this method,
//	the code is considerably simpler. To implement this second method, we define three functions
//	(which all operate on a movie controller that is associated with an open movie):
//
//	-> QTStep_MCGoToNextVideoSample: display the sample that follows the current sample in a movie
//	-> QTStep_MCGoToPrevVideoSample: display the sample that precedes the current sample in a movie
//	-> QTStep_MCGoToFirstVideoSample: display the first video sample in a movie
//
//	Historical note: Method One is based loosely on sample-stepping code in the DTSQTUtilities package
//	developed by Apple Macintosh Developer Technical Support. Method Two is based on a few functions
//	in the SimpleInMovies sample code written by Guillermo A. Ortiz.
//
//////////

 uses
  qt_Errors,
  qt_FixMath;

//////////
//
// METHOD ONE: Use Movie Toolbox calls to step to interesting times in the movie.
//
//////////

//////////
//
// QTStep_GetStartTimeOfFirstVideoSample
// Return, through the theTime parameter, the starting time of the first video sample of the
// specified QuickTime movie.
//
// The "trick" here is to set the nextTimeEdgeOK flag, to indicate that you want to get the
// starting time of the beginning of the movie.
//
// If this function encounters an error, it returns a (bogus) starting time of -1. Note that
// GetMovieNextInterestingTime also returns -1 as a starting time if the search criteria
// specified in the myFlags parameter are not matched by any interesting time in the movie.
//
//////////

function QTStep_GetStartTimeOfFirstVideoSample;
var myFlags:short;
    myTypes:array[0..0] of OSType;
begin
 theTime := kBogusStartingTime;	// a bogus starting time
 if (theMovie = nil) then
  begin result:=invalidMovie; exit; end;

 myFlags := nextTimeMediaSample + nextTimeEdgeOK; // we want the first sample in the movie
 myTypes[0] := VisualMediaCharacteristic; // we want video samples

 GetMovieNextInterestingTime(theMovie, myFlags, 1, @myTypes[0], TimeValue(0), fixed1, @theTime, nil);
 result:=GetMoviesError();
end;


//////////
//
// QTStep_DrawVideoSampleAtTime
// Draw the video sample of a QuickTime movie at the specified time.
//
//////////

function QTStep_DrawVideoSampleAtTime;
var myErr:OSErr;
label bail;
begin
 if (theMovie = nil) then
  begin result:=invalidMovie; exit; end;

 // make sure that the specified time lies within the movie's temporal bounds
 if ((theTime < 0) or (theTime > GetMovieDuration(theMovie))) then
  begin result:=paramErr; exit; end;

 SetMovieTimeValue(theMovie, theTime);
 myErr := GetMoviesError();
 if (myErr <> noErr) then goto bail;

 // the following calls to UpdateMovie and MoviesTask are not necessary
 // if you are handling movie controller events in your main event loop
 // (by passing the event to MCIsPlayerEvent); they don't hurt, however.

 // redraw the movie immediately by calling UpdateMovie and MoviesTask
 UpdateMovie(theMovie);
 myErr := GetMoviesError();
 if (myErr <> noErr) then goto bail;

 MoviesTask(theMovie, long(0));
 myErr := GetMoviesError();

bail:
 result:=myErr;
end;


//////////
//
// QTStep_DrawVideoSampleNextOrPrev
// Draw the next or previous video sample of a QuickTime movie.
// If theRate is 1, the next video sample is drawn; if theRate is -1, the previous sample is drawn.
//
//////////

function QTStep_DrawVideoSampleNextOrPrev;
var myCurrTime:TimeValue;
    myNextTime:TimeValue;
    myFlags:short;
    myTypes:array[0..0] of OSType;
    myErr:OSErr;
begin
 if (theMovie = nil) then
  begin result:=invalidMovie; exit; end;

 myFlags := nextTimeStep;									// we want the next frame in the movie's media
 myTypes[0] := VisualMediaCharacteristic;					// we want video samples
 myCurrTime := GetMovieTime(theMovie, nil);

 GetMovieNextInterestingTime(theMovie, myFlags, 1, @myTypes[0], myCurrTime, theRate, @myNextTime, nil);
 myErr := GetMoviesError();
 if (myErr <> noErr) then
  begin result:=myErr; exit; end;

 myErr := QTStep_DrawVideoSampleAtTime(theMovie, myNextTime);

 result:=myErr;
end;


//////////
//
// QTStep_GoToFirstVideoSample
// Draw the first video sample of a QuickTime movie.
//
//////////

function QTStep_GoToFirstVideoSample(theMovie:Movie):OSErr;
var myTime:TimeValue;
    myErr:OSErr;
begin
 if (theMovie = nil) then
  begin result:=invalidMovie; exit; end;

 myErr := QTStep_GetStartTimeOfFirstVideoSample(theMovie, myTime);
 if (myErr <> noErr) then
  begin result:=myErr; exit; end;

 myErr := QTStep_DrawVideoSampleAtTime(theMovie, myTime);
 result:=myErr;
end;


//////////
//
// QTStep_GoToNextVideoSample
// Draw the next video sample of a QuickTime movie.
//
//////////

function QTStep_GoToNextVideoSample(theMovie:Movie):OSErr;
begin
 result:=QTStep_DrawVideoSampleNextOrPrev(theMovie, fixed1);
end;


//////////
//
// QTStep_GoToPrevVideoSample
// Draw the previous video sample of a QuickTime movie.
//
//////////

function QTStep_GoToPrevVideoSample(theMovie:Movie):OSErr;
begin
 result:=QTStep_DrawVideoSampleNextOrPrev(theMovie, FixMul(Long2Fix(-1), fixed1));
end;


//////////
//
// METHOD TWO: Use movie controller actions to step thru frames in the movie.
//
//////////

//////////
//
// QTStep_MCGoToFirstVideoSample
// Draw the first video sample of the QuickTime movie associated with the specified movie controller.
//
//////////

function QTStep_MCGoToFirstVideoSample(theMC:MovieController):OSErr;
var myTimeRecord:TimeRecord;
    myMovie:Movie;
    myErr:OSErr;
begin
 if (theMC = nil) then
  begin result:=paramErr; exit; end;

 myMovie := MCGetMovie(theMC);
 if (myMovie = nil) then
  begin result:=paramErr; exit; end;

 myTimeRecord.value.hi := 0;
 myTimeRecord.value.lo := 0;
 myTimeRecord.base := nil;
 myTimeRecord.scale := GetMovieTimeScale(myMovie);
 myErr := GetMoviesError();
 if (myErr <> noErr)
  then result:=myErr
  else result:=MCDoAction(theMC, mcActionGoToTime, @myTimeRecord);
end;


//////////
//
// QTStep_MCGoToNextVideoSample
// Draw the next video sample of the QuickTime movie associated with the specified movie controller.
//
//////////

function QTStep_MCGoToNextVideoSample(theMC:MovieController):OSErr;
var myStep:short;
begin
 myStep := 1;				// advance the movie one frame
 if (theMC = nil)
  then result:=paramErr
  else result:=MCDoAction(theMC, mcActionStep,ptr(myStep)); //cast to a pointer, don't pass a pointer to the data
end;


//////////
//
// QTStep_MCGoToPrevVideoSample
// Draw the previous video sample of the QuickTime movie associated with the specified movie controller.
//
//////////

function QTStep_MCGoToPrevVideoSample(theMC:MovieController):OSErr;
var myStep:short;
begin
 myStep := -1;			// back the movie up one frame
 if (theMC = nil)
  then result:=paramErr
  else result:=MCDoAction(theMC, mcActionStep,ptr(myStep)); //cast to a pointer, don't pass a pointer to the data //don't use hardcoded -1 here, it must be the size of a "short"
end;


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Frame utilities.
//
// These functions illustrate some other useful things you might want to do with movie frames;
// they are not used elsewhere in this file.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////
//
// QTStep_GetFrameCount
// Get the number of frames in the specified movie track. We return the value -1 if
// an error occurs and we cannot determine the number of frames in the track.
//
// Based (loosely) on frame-counting code in ConvertToMovie Jr.c.
// 
// We count the frames in the track by stepping through all of its interesting times
// (the places where the track displays a new sample).
//
//////////

function QTStep_GetFrameCount(theTrack:Track):long;
var myCount:long;
    myFlags:short;
    myTime:TimeValue;
label bail;
begin
 myCount := -1;
 myTime := 0;

 if (theTrack = nil) then goto bail;

 // we want to begin with the first frame (sample) in the track
 myFlags := nextTimeMediaSample + nextTimeEdgeOK;

 while (myTime >= 0) do
  begin
  inc(myCount);

  // look for the next frame in the track; when there are no more frames,
  // myTime is set to -1, so we'll exit the while loop
  GetTrackNextInterestingTime(theTrack, myFlags, myTime, fixed1, myTime, nil);

  // after the first interesting time, don't include the time we're currently at
  myFlags := nextTimeStep;
  end;

bail:
 result:=myCount;
end;

end.