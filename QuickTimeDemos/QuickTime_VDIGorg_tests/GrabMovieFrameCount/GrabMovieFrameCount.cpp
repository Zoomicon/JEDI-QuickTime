//
//	VDIG.ORG test application. (see http://www.vdig.org)
//
//
//	Grab a Movie File. No Preview.
//



#include "common.h"
#include "SGSettings.h"

void doGrabMovieFrameCount();

int main(void)
{
	Initialize();
	doGrabMovieFrameCount();
	::ExitMovies();
}

void doGrabMovieFrameCount()
{
	ofstream ofs("GrabMovieFrameCount.txt");
	
	cout << "GrabMovieFrameCount (no preview)..." << endl;
	ofs << "GrabMovieFrameCount (no preview)..." << endl;

	OSErr err;
	SeqGrabComponent mSGComponent;
	SGChannel mVideoChannel;
	FSSpec mMovieFile;
	FSSpec newFile;
	Boolean canOffscreen = false;
	short mResourceID = 0;	// force a search for the first movie resource ID.
	short mMovieRefNum;
	Movie mMovie;

	ComponentDescription 		theDesc;
	theDesc.componentType 		= SeqGrabComponentType;
	theDesc.componentSubType 	= 0L;
	theDesc.componentManufacturer = 'appl';
	theDesc.componentFlags 		= 0L;
	theDesc.componentFlagsMask	= 0L;
	
	Component sgCompID = FindNextComponent (nil, &theDesc);
	if (sgCompID != 0L)
		mSGComponent = OpenComponent (sgCompID);

	if (mSGComponent == nil)
		goto die;
	

	//
	//	Open a component, and get a channel so we can find the Video bounds.
	//
	CheckErr("SGInitialize",::SGInitialize(mSGComponent));
	CheckErr("SGNewChannel",::SGNewChannel(mSGComponent, VideoMediaType, &mVideoChannel));
	
	ShowSettings(mSGComponent,mVideoChannel);
	//
	//	get the Video bounds.
	//
	Rect mFrame;
	CheckErr("SGGetSrcVideoBounds",::SGGetSrcVideoBounds(mVideoChannel,&mFrame));
	::MacOffsetRect(&mFrame, -mFrame.left, -mFrame.top);
	ofs  << "Frame {" << mFrame.left << "," << mFrame.top << "},{" << mFrame.right << "," << mFrame.bottom << "}" << endl;
	cout << "Frame {" << mFrame.left << "," << mFrame.top << "},{" << mFrame.right << "," << mFrame.bottom << "}" << endl;
	
	
	//
	//	Construct a suitable GWorld to give to the Sequence Grabber.
	//
	GWorldPtr mMacGWorld;
	CheckErr("QTNewGWorld",::QTNewGWorld(&mMacGWorld, 32, &mFrame, nil, nil, 0));
	::LockPixels(::GetGWorldPixMap(mMacGWorld));
	
	
	//
	//	OK, Close things up, and reopen using the new GWorld as the SGGworld.
	//
	CheckErr("CloseComponent",::CloseComponent(mSGComponent));
	mSGComponent = OpenComponent (sgCompID);

	if (mSGComponent == nil)
		goto die;
	
	CGrafPtr mSavePort;
	GDHandle mSaveDevice;
	::GetGWorld(&mSavePort, &mSaveDevice);
	::SetGWorld(mMacGWorld, nil);
	
	CheckErr("SGInitialize",::SGInitialize(mSGComponent));
	CheckErr("SGNewChannel",::SGNewChannel(mSGComponent, VideoMediaType, &mVideoChannel));


	CheckErr("SGSetGWorld",::SGSetGWorld(mSGComponent,(CGrafPtr)mMacGWorld,nil));

	err = ::SGGetUseScreenBuffer(mVideoChannel,&canOffscreen);
	if (canOffscreen == false)
		goto die;
		
	//
	//	Follow the calls that VideoScript does.
	//	
	CheckErr("SGSetUseScreenBuffer",::SGSetUseScreenBuffer(mVideoChannel,canOffscreen));
	CheckErr("SGSetChannelUsage",::SGSetChannelUsage(mVideoChannel, seqGrabRecord));
	CheckErr("SGSetChannelBounds ",::SGSetChannelBounds (mVideoChannel, &mFrame));
	
	err = ::FSMakeFSSpec(0, 0L, "\pTempOutput.mov", &mMovieFile);
	::DeleteMovieFile(&mMovieFile);
	CheckErr("CreateMovieFile",::CreateMovieFile(&mMovieFile, 'TVOD', smSystemScript,
					createMovieFileDontOpenFile | createMovieFileDontCreateMovie | createMovieFileDontCreateResFile,
					nil, nil));
	
	CheckErr("SGSetDataOutput",::SGSetDataOutput(mSGComponent,&mMovieFile,seqGrabToDisk));
	CheckErr("SGSetMaximumRecordTime",::SGSetMaximumRecordTime(mSGComponent,0));
	CheckErr("SGSetFrameRate",::SGSetFrameRate(mVideoChannel, X2Fix(6.0)));
	CheckErr("SGStartRecord",::SGStartRecord(mSGComponent));
	
	//
	//	This function is not required. Therefore don't throw if an error
	//	is encountered.
	//
	CheckErr("SGSetChannelMaxFrames",::SGSetChannelMaxFrames(mVideoChannel,32));
	
	cout << "Capturing 32 frames of video at 6 FPS..." << endl;
	
	
	long framesLeft;
	CheckErr("SGGetChannelMaxFrames",::SGGetChannelMaxFrames(mVideoChannel,&framesLeft) );
	
	while (framesLeft > 0)
	{
		CheckErr("SGIdle",::SGIdle(mSGComponent) );
		CheckErr("SGSetChannelMaxFrames",::SGGetChannelMaxFrames(mVideoChannel,&framesLeft) );
	}
			
	cout << "Grabbing complete." << endl;
		
	CheckErr("SGStop",::SGStop(mSGComponent));
 
	CheckErr("CloseComponent",::CloseComponent(mSGComponent));

	CheckErr("OpenMovieFile ",::OpenMovieFile (&mMovieFile, &mMovieRefNum, fsRdWrPerm));
	
	cout << "Loading Captured Data..." << endl;
	
	CheckErr("NewMovieFromFile ",::NewMovieFromFile (&mMovie, mMovieRefNum,
							&mResourceID,
							nil, newMovieActive, nil));
	CheckErr("GetMoviesError",::GetMoviesError());			
	
	err = ::FSMakeFSSpec(0, 0L, "\pOutput.mov", &newFile);
	
	cout << "Writing Movie File \"Output.mov\"..." << endl;
	Movie aMovie = ::FlattenMovieData(mMovie,
						flattenAddMovieToDataFork,
						&newFile,
						'TVOD',
						smSystemScript,
						createMovieFileDeleteCurFile | createMovieFileDontCreateResFile);
						
	CheckErr("FlattenMovieData",::GetMoviesError());
				
	::DisposeMovie(mMovie);
	::DisposeMovie(aMovie);
	CheckErr("CloseMovieFile",	::CloseMovieFile(mMovieRefNum));
	CheckErr("DeleteMovieFile",	::DeleteMovieFile(&mMovieFile));
						
	cout << "Grabbing Complete: Please check the file \"Output.mov\"." << endl;

	cout << "SUCCEEDED" << endl;
	ofs << "SUCCEEDED" << endl;

die:
	::SetGWorld(mSavePort, mSaveDevice);
	if (err)
	{
		SysBeep(1);
		cout << "FAILED" << endl;
		ofs << "FAILED" << endl;
	}
}
