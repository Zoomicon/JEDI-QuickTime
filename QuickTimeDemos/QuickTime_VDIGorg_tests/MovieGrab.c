#include "common.h"

short gCount = 0;
#include "SGSettings.h"
#include "GrabMovieNoPreview.h"


void doSequenceGrabNoPreview(void); // this kills the InterView
void doSingleFrameGrab(void);
void doSimpleSingleFrameGrab(void);		// this kills the InterView
void doPreviewSingleFrameGrab(void);		// this kills the InterView

int main(void)
{
	Initialize();
	doGrabMovieNoPreview();
//	doSequenceGrabNoPreview();
//	doSingleFrameGrab();
//	doSimpleSingleFrameGrab();
//	doPreviewSingleFrameGrab();
	::ExitMovies();
}


// 
//	Initialize everything for the program, make sure we can run
//

void Initialize(void)
{
	SysEnvRec	theWorld;
		
	OSErr err = SysEnvirons(1, &theWorld);
	if (theWorld.hasColorQD == false) {
		SysBeep(50);
		ExitToShell();					/* If no color QD, we must leave. */
	}
	
	InitGraf(&qd.thePort);
	InitWindows();
	InitMenus();
	TEInit();
	InitDialogs(nil);
	InitCursor();

	::GetDateTime((unsigned long*) &qd.randSeed);
	
	err = ::EnterMovies();
	if (noErr != err)
	{
		SysBeep(50);
		ExitToShell();
	}
}



void doSingleFrameGrab(void)
{
	OSErr err;
	SeqGrabComponent mSGComponent;
	SGChannel mVideoChannel;
	FSSpec newFile;
	Boolean canOffscreen = false;
	short mResourceID = 0;	// force a search for the first movie resource ID.

	ofstream ofs("CaptureLog.txt");
	
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
	
	cout << "Initializing Single Frame Capture..." << endl;

	CheckErr("SGInitialize",::SGInitialize(mSGComponent));
	CheckErr("SGNewChannel",::SGNewChannel(mSGComponent, VideoMediaType, &mVideoChannel));
	
	Rect mFrame;
	GWorldPtr mMacGWorld;
	
	CheckErr("SGGetSrcVideoBounds",::SGGetSrcVideoBounds(mVideoChannel,&mFrame));
	::MacOffsetRect(&mFrame, -mFrame.left, -mFrame.top);
	ofs  << "Frame {" << mFrame.left << "," << mFrame.top << "},{" << mFrame.right << "," << mFrame.bottom << "}" << endl;
	cout << "Frame {" << mFrame.left << "," << mFrame.top << "},{" << mFrame.right << "," << mFrame.bottom << "}" << endl;
	
	CheckErr("QTNewGWorld",::QTNewGWorld(&mMacGWorld, 32, &mFrame, nil, nil, 0));
	::LockPixels(::GetGWorldPixMap(mMacGWorld));
	
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


	CheckErr("SGSetGWorld(mSGComponent,",::SGSetGWorld(mSGComponent,(CGrafPtr)mMacGWorld,nil));

	err = ::SGGetUseScreenBuffer(mVideoChannel,&canOffscreen);
	if (canOffscreen == false)
		goto die;
		
	//
	//	Follow the calls that VideoScript does.
	//	
	CheckErr("SGSetUseScreenBuffer",::SGSetUseScreenBuffer(mVideoChannel,canOffscreen));
	CheckErr("SGSetChannelUsage",::SGSetChannelUsage(mVideoChannel, seqGrabRecord | seqGrabPreview));
	CheckErr("SGSetChannelBounds ",::SGSetChannelBounds (mVideoChannel, &mFrame));
	CheckErr("SGStartPreview",::SGStartPreview(mSGComponent));
	CheckErr("SGIdle",::SGIdle(mSGComponent));
	CheckErr("SGStop",::SGStop(mSGComponent));
	
	cout << "Capturing a single frame..." << endl;
	PicHandle p;
	err = ::SGGrabPict(mSGComponent, &p, &mFrame, 0, 0);
	if (err || (p == nil))
	{
		CheckErr("SGGrabPict",err);
	}
	cout << "Picture Handle: " << p << endl;
	KillPicture(p);

	CheckErr("CloseComponent",::CloseComponent(mSGComponent));

	cout << "Grabbing Complete." << endl;
 	::SetGWorld(mSavePort, mSaveDevice);

die:
	if (err)
		SysBeep(1);
}

void doSimpleSingleFrameGrab(void)
{
	OSErr err;
	SeqGrabComponent mSGComponent;
	SGChannel mVideoChannel;
	FSSpec newFile;
	Boolean canOffscreen = false;
	short mResourceID = 0;	// force a search for the first movie resource ID.

	ofstream ofs("CaptureLog.txt");
	
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
	
	cout << "Initializing Simple Single Frame Capture..." << endl;

	Rect mFrame = {0,0,240,320};
	GWorldPtr mMacGWorld;
	
	CheckErr("QTNewGWorld",::QTNewGWorld(&mMacGWorld, 32, &mFrame, nil, nil, 0));
	::LockPixels(::GetGWorldPixMap(mMacGWorld));
	
	CGrafPtr mSavePort;
	GDHandle mSaveDevice;
	::GetGWorld(&mSavePort, &mSaveDevice);
	::SetGWorld(mMacGWorld, nil);
	
	CheckErr("SGInitialize",::SGInitialize(mSGComponent));
	CheckErr("SGNewChannel",::SGNewChannel(mSGComponent, VideoMediaType, &mVideoChannel));


	CheckErr("SGSetGWorld(mSGComponent,",::SGSetGWorld(mSGComponent,(CGrafPtr)mMacGWorld,nil));
	
	cout << "Capturing a single frame..." << endl;
	PicHandle p;
	err = ::SGGrabPict(mSGComponent, &p, &mFrame, 0, 0);
	if (err || (p == nil))
	{
		CheckErr("SGGrabPict",err);
	}
	cout << "Picture Handle: " << p << endl;
	KillPicture(p);

	CheckErr("CloseComponent",::CloseComponent(mSGComponent));

	cout << "Grabbing Complete." << endl;
// 	::SetGWorld(mSavePort, mSaveDevice);

die:
	if (err)
		SysBeep(1);
}

void doPreviewSingleFrameGrab(void)
{
	OSErr err;
	SeqGrabComponent mSGComponent;
	SGChannel mVideoChannel;
	FSSpec newFile;
	Boolean canOffscreen = false;
	short mResourceID = 0;	// force a search for the first movie resource ID.

	ofstream ofs("CaptureLog.txt");
	
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
	
	cout << "Initializing Preview Single Frame Capture..." << endl;

	Rect mFrame = {0,0,240,320};
	GWorldPtr mMacGWorld;
	CheckErr("QTNewGWorld",::QTNewGWorld(&mMacGWorld, 32, &mFrame, nil, nil, 0));
	::LockPixels(::GetGWorldPixMap(mMacGWorld));
	CGrafPtr mSavePort;
	GDHandle mSaveDevice;
	::GetGWorld(&mSavePort, &mSaveDevice);
	::SetGWorld(mMacGWorld, nil);
	
	CheckErr("SGInitialize",::SGInitialize(mSGComponent));
	CheckErr("SGNewChannel",::SGNewChannel(mSGComponent, VideoMediaType, &mVideoChannel));


	CheckErr("SGSetGWorld(mSGComponent,",::SGSetGWorld(mSGComponent,(CGrafPtr)mMacGWorld,nil));

	err = ::SGGetUseScreenBuffer(mVideoChannel,&canOffscreen);
	if (canOffscreen == false)
		goto die;
		
	//
	//	Follow the calls that VideoScript does.
	//	
	CheckErr("SGSetUseScreenBuffer",::SGSetUseScreenBuffer(mVideoChannel,canOffscreen));
	CheckErr("SGSetChannelUsage",::SGSetChannelUsage(mVideoChannel, seqGrabRecord | seqGrabPreview));
	CheckErr("SGSetChannelBounds ",::SGSetChannelBounds (mVideoChannel, &mFrame));
	CheckErr("SGStartPreview",::SGStartPreview(mSGComponent));
	CheckErr("SGIdle",::SGIdle(mSGComponent));
	CheckErr("SGStop",::SGStop(mSGComponent));
	
	cout << "Capturing a single frame..." << endl;
	PicHandle p;
	err = ::SGGrabPict(mSGComponent, &p, &mFrame, 0, 0);
	if (err || (p == nil))
	{
		CheckErr("SGGrabPict",err);
	}
	cout << "Picture Handle: " << p << endl;
	KillPicture(p);

	CheckErr("CloseComponent",::CloseComponent(mSGComponent));

	cout << "Grabbing Complete." << endl;
 	::SetGWorld(mSavePort, mSaveDevice);

die:
	if (err)
		SysBeep(1);
}


void doSequenceGrabNoPreview(void)
{
	OSErr err;
	SeqGrabComponent mSGComponent;
	SGChannel mVideoChannel;
	FSSpec mMovieFile;
	FSSpec newFile;
	Boolean canOffscreen = false;
	short mResourceID = 0;	// force a search for the first movie resource ID.
	short mMovieRefNum;
	Movie mMovie;

	ofstream ofs("CaptureLog.txt");
	
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
	
	cout << "Initializing Capture..." << endl;

	CheckErr("SGInitialize",::SGInitialize(mSGComponent));
	CheckErr("SGNewChannel",::SGNewChannel(mSGComponent, VideoMediaType, &mVideoChannel));
	
	Rect mFrame;
	GWorldPtr mMacGWorld;
	
	CheckErr("SGGetSrcVideoBounds",::SGGetSrcVideoBounds(mVideoChannel,&mFrame));
	::MacOffsetRect(&mFrame, -mFrame.left, -mFrame.top);
	ofs  << "Frame {" << mFrame.left << "," << mFrame.top << "},{" << mFrame.right << "," << mFrame.bottom << "}" << endl;
	cout << "Frame {" << mFrame.left << "," << mFrame.top << "},{" << mFrame.right << "," << mFrame.bottom << "}" << endl;
	
	CheckErr("QTNewGWorld",::QTNewGWorld(&mMacGWorld, 32, &mFrame, nil, nil, 0));
	::LockPixels(::GetGWorldPixMap(mMacGWorld));
	
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


	CheckErr("SGSetGWorld(mSGComponent,",::SGSetGWorld(mSGComponent,(CGrafPtr)mMacGWorld,nil));

	err = ::SGGetUseScreenBuffer(mVideoChannel,&canOffscreen);
	if (canOffscreen == false)
		goto die;
		
	//
	//	Follow the calls that VideoScript does.
	//	
	CheckErr("SGSetUseScreenBuffer",::SGSetUseScreenBuffer(mVideoChannel,canOffscreen));
	CheckErr("SGSetChannelUsage",::SGSetChannelUsage(mVideoChannel, seqGrabRecord ));
	CheckErr("SGSetChannelBounds ",::SGSetChannelBounds (mVideoChannel, &mFrame));
	
	err = ::FSMakeFSSpec(0, 0L, "\pTempOutput.mov", &mMovieFile);
	::DeleteMovieFile(&mMovieFile);
	CheckErr("CreateMovieFile",::CreateMovieFile(&mMovieFile, 'TVOD', smSystemScript,
					createMovieFileDontOpenFile | createMovieFileDontCreateMovie | createMovieFileDontCreateResFile,
					nil, nil));
	
	CheckErr("SGSetDataOutput",::SGSetDataOutput(mSGComponent,&mMovieFile,seqGrabToDisk));
	CheckErr("SGSetMaximumRecordTime",::SGSetMaximumRecordTime(mSGComponent,8 * 60)); // 8 seconds
	CheckErr("SGSetFrameRate",::SGSetFrameRate(mVideoChannel,X2Fix(6.0)));
	CheckErr("SGStartRecord",::SGStartRecord(mSGComponent));
	
	cout << "Capturing 8 seconds of video at 6 FPS..." << endl;
	while (!err)
		err = ::SGIdle(mSGComponent);

	if (err == grabTimeComplete)
		err = noErr;
			
	cout << "Grabbing complete." << endl;
		
	CheckErr("SGStop",::SGStop(mSGComponent));

	CheckErr("CloseComponent",::CloseComponent(mSGComponent));

	CheckErr("OpenMovieFile ",::OpenMovieFile (&mMovieFile, &mMovieRefNum, fsRdWrPerm));
	
	cout << "Loading Captured Data..." << endl;
	
	CheckErr("NewMovieFromFile ",::NewMovieFromFile (&mMovie, mMovieRefNum,
							&mResourceID,
							nil, newMovieActive, nil));
	CheckErr("NewMovieFromFile",::GetMoviesError());			
	
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
 	::SetGWorld(mSavePort, mSaveDevice);

die:
	if (err)
		SysBeep(1);
}