//
//	VDIG.ORG test application. (see http://www.vdig.org)
//
//	Get the sequence grabber settings. Place then in a handle and read them back in.
//	This simulates storing the preferences for an application in a resource.
//


#include "common.h"
#include "SGSettings.h"

void ReadWriteSettings();

int main(void)
{
	Initialize();
	ReadWriteSettings();
	::ExitMovies();
}

void ReadWriteSettings()
{
	ofstream ofs("ReadWriteSettings.txt");
	
	cout << "ReadWriteSettings..." << endl;
	ofs << "ReadWriteSettings..." << endl;

	OSErr err;
	SeqGrabComponent mSGComponent;
	SGChannel mVideoChannel;

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
	
	cout << "Putting Settings into Handle..." << endl;
	ofs << "Putting Settings into Handle..." << endl;

	Handle theVideoSettingsHandle = NewHandle(4);
	{
		UserData ud;
		CheckErr("SGGetChannelSettings",SGGetChannelSettings(mSGComponent, mVideoChannel, &ud, 0));
	
		CheckErr("PutUserDataIntoHandle",::PutUserDataIntoHandle(ud, theVideoSettingsHandle));
	}
	//
	//	OK, Close things up, and reopen
	//
	CheckErr("CloseComponent",::CloseComponent(mSGComponent));

	mSGComponent = OpenComponent (sgCompID);
	CheckErr("SGInitialize",::SGInitialize(mSGComponent));
	CheckErr("SGNewChannel",::SGNewChannel(mSGComponent, VideoMediaType, &mVideoChannel));

	cout << "Getting Settings from Handle..." << endl;
	ofs << "Getting Settings from Handle..." << endl;
	
	UserData newData;
	CheckErr("NewUserDataFromHandle",::NewUserDataFromHandle(theVideoSettingsHandle,&newData));

	CheckErr("SGSetChannelSettings",::SGSetChannelSettings(mSGComponent, mVideoChannel, newData, 0L));

	CheckErr("CloseComponent",::CloseComponent(mSGComponent));
	
	cout << "SUCCEEDED" << endl;
	ofs << "SUCCEEDED" << endl;

die:
	if (err)
	{
		SysBeep(1);
		cout << "FAILED" << endl;
		ofs << "FAILED" << endl;
	}
}
