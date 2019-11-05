{-$DEFINE USE_WIRE_FRAME_RENDERER}

unit Box3DSupport;

interface
 uses
  C_Types,
  Windows,
  qt_QD3D,
  qt_QD3DCamera,
  qt_QD3DDrawContext;

// Box3dSupport.c - QuickDraw 3d routines - interface
//
// This file contains
//
// Created 27th Dec 1994, Nick Thompson, DEVSUPPORT
//
// Modification History:
//
//	12/27/94		nick		initial version

{
// QuickDraw 3D stuff
#include "QD3D.h"			// QuickDraw 3D lives in here
#include "QD3DIO.h"
#include "QD3DErrors.h"
#include "QD3DMath.h"
#include "QD3DDrawContext.h"
#include "QD3DShader.h"
#include "QD3DTransform.h"
#include "QD3DGroup.h"
#include "QD3DRenderer.h"
#include "QD3DCamera.h"
#include "QD3DLight.h"
#include "QD3DGeometry.h"
#include "QD3DSet.h"
#include "QD3DAcceleration.h"
#include "QD3DStorage.h"
#include "QD3DView.h"

#include "QD3DWinViewer.h"
}

const
 kA3BtnZoom   = 1;
 kA3BtnRotate =2;
 kA3BtnPan    =3;

type
 DocumentRec=packed record //struct _documentRecord //6Feb1999: placed packed, just in case it's some QT structure
  fControlStripVisible:TQ3Boolean;	// if control strip is visible
  fView:TQ3ViewObject;				// the view for the scene
  fModel:TQ3GroupObject;			// object in the scene being modelled
  fInterpolation:TQ3StyleObject;	// interpolation style used when rendering
  fBackFacing:TQ3StyleObject;		// whether to draw shapes that face away from the camera
  fFillStyle:TQ3StyleObject;		// whether drawn as solid filled object or decomposed to components
  fRotation:TQ3Matrix4x4;			// the transform for the model
  fIllumination:TQ3ShaderObject;

  fWindow:HWND;			// destination window to blit offscreen buffer onto
  fWidth:unsigned_long;
  fHeight:unsigned_long;
  fMemoryDC:HDC;			// memory device context for offscreen buffer
  fBitmap:HBITMAP;			// offscreen bitmap to draw into (really a pixelmap)
  fBitStorage:pointer;		// storage for bits in offscreen bitmap (pixelmap)

  fViewer:TQ3WinViewerObject;

  fViewerMode:unsigned_long;		(* which button is active *)

  fMouseDown:TQ3Boolean;
  end;

 DocumentPtr=^DocumentRec;

//---------------------------------------------------------------------------------------

function MyNewView(theDocument:DocumentPtr):TQ3ViewObject;
function MyNewDrawContext(theDocument:DocumentPtr):TQ3DrawContextObject;
function MyNewCamera(theDocument:DocumentPtr):TQ3CameraObject;
function MyNewLights:TQ3GroupObject;
function MyNewModel:TQ3GroupObject;

procedure pvCamera_Fit(theDocument:DocumentPtr);
procedure pvBBoxCenter(var bbox:TQ3BoundingBox;var center:TQ3Point3D);
procedure pvBBox_Get(var theDocument:DocumentPtr;var bbox:TQ3BoundingBox);

var documentGroupCenter:TQ3Point3D; //Delphi: declared as static in C, so moved to unit's interface part
    documentGroupScale:float;  //Delphi: declared as static in C, so moved to unit's interface part

implementation
 uses
  Math,
  qt_QD3DLight,
  qt_QD3DGeometry,
  qt_QD3DView,
  qt_QD3DGroup,
  qt_QD3DSet,
  qt_QD3DTransform,
  qt_QD3DShader,
  qt_QD3DMath,
  qt_QD3DRenderer,
  qt_QD3DAcceleration;

// Box3dSupport.c - QuickDraw 3d routines
//
// This file contains utility routines for QuickDraw 3d sample code.
// This is a simple QuickDraw 3d application to draw a cube in the center
// of the main application window.  The routines in here handle setting up
// the main display group, the view, the Macintosh 3D draw context, and the
// camera and lighting.
//
// This code is the basis of the introductory article in  d e v e l o p  issue 22
//
// Nick Thompson - January 6th 1995
// ©1994-95 Apple computer Inc., All Rights Reserved
//
//

{#include "Box3DSupport.h"}

function ErMath_Atan(x:double):float; begin result:=arctan(x); end; //Delphi: macro implemented as a function

const kEPSILON=1.19209290e-07;

function MyNewView(theDocument:DocumentPtr):TQ3ViewObject;
var myStatus:TQ3Status;
    myView:TQ3ViewObject;
    myDrawContext:TQ3DrawContextObject;
    myRenderer:TQ3RendererObject;
    myCamera:TQ3CameraObject;
    myLights:TQ3GroupObject;
label bail;
begin
	myView := Q3View_New;

	//	Create and set draw context.
        myDrawContext := MyNewDrawContext(theDocument); //Delphi: broken C assignment+if to two commands
	if ( myDrawContext = nil ) then
		goto bail;

        myStatus := Q3View_SetDrawContext(myView, myDrawContext); //Delphi: broken C assignment+if to two commands
	if ( myStatus = kQ3Failure ) then
		goto bail;

	Q3Object_Dispose( myDrawContext ) ;

	//	Create and set renderer.

	// this uses the wire frame renderer
{$ifdef USE_WIRE_FRAME_RENDERER} //Delphi: was '#if 0' in C, using this instead

	myRenderer := Q3Renderer_NewFromType(kQ3RendererTypeWireFrame);
        myStatus := Q3View_SetRenderer(myView, myRenderer); //Delphi: broken C assignment+if to two commands
	if ( myStatus = kQ3Failure ) then
		goto bail;

{$else}

	// this uses the interactive software renderer

        myRenderer := Q3Renderer_NewFromType(kQ3RendererTypeInteractive); //Delphi: broken C assignment+if to two commands
	if (myRenderer <> nil ) then
         begin
                myStatus := Q3View_SetRenderer(myView, myRenderer); //Delphi: broken C assignment+if to two commands
		if ( myStatus = kQ3Failure ) then
			goto bail;

		// these two lines set us up to use the best possible renderer,
		// including  hardware if it is installed.
		Q3InteractiveRenderer_SetDoubleBufferBypass(myRenderer, kQ3True);
		Q3InteractiveRenderer_SetPreferences(myRenderer, kQAVendor_BestChoice, 0);

   	 end
 	else goto bail;
{$endif}

	Q3Object_Dispose( myRenderer ) ;

	//	Create and set camera
        myCamera := MyNewCamera(theDocument); //Delphi: broken C assignment+if to two commands
	if ( myCamera = nil ) then
		goto bail;

        myStatus := Q3View_SetCamera(myView, myCamera); //Delphi: broken C assignment+if to two commands
	if ( myStatus = kQ3Failure ) then
		goto bail;

	Q3Object_Dispose( myCamera ) ;

	//	Create and set lights
        myLights:=MyNewLights(); //Delphi
	if ( myLights = nil ) then
		goto bail;

        myStatus := Q3View_SetLightGroup(myView, myLights);
	if ( myStatus = kQ3Failure ) then
		goto bail;

	Q3Object_Dispose(myLights);

	result:=myView;
        exit;

bail:
	//	If any of the above failed, then don't return a view.
	result:=nil;
end;

//----------------------------------------------------------------------------------

function MyNewDrawContext(theDocument:DocumentPtr):TQ3DrawContextObject;
var	myDrawContextData:TQ3DrawContextData;
	myPixmapDrawContextData:TQ3PixmapDrawContextData;
	ClearColor:TQ3ColorARGB;
	myDrawContext:TQ3DrawContextObject;
	aPixmap:TQ3Pixmap;
 	bitmapInfo:TBitmapInfo; //Delphi: BITMAPINFO->TBitmapInfo
	hdc:THandle{HDC};
	is32Bit:TQ3Boolean;
begin
 is32Bit := kQ3False;

		//	Set the background color.
	ClearColor.a := 0.0;
	ClearColor.r := 1.0;
	ClearColor.g := 1.0;
	ClearColor.b := 1.0;

		//	fill in draw context data.
	myDrawContextData.clearImageMethod := kQ3ClearMethodWithColor;
	myDrawContextData.clearImageColor := ClearColor;
	myDrawContextData.paneState := kQ3False;
	myDrawContextData.maskState := kQ3False;
	myDrawContextData.doubleBufferState := kQ3False;

		// set up device independent bitmap
	hdc := GetDC(theDocument^.fWindow);
	theDocument^.fMemoryDC := CreateCompatibleDC(hdc);

	bitmapInfo.bmiHeader.biSize := sizeof(TBitmapInfoHeader); //Delphi: BITMAPINFOHEADER->TBitmapInfoHeader
	bitmapInfo.bmiHeader.biWidth := theDocument^.fWidth;
	bitmapInfo.bmiHeader.biHeight := -theDocument^.fHeight;

	bitmapInfo.bmiHeader.biPlanes := 1;
	if (is32Bit = kQ3True) then
		bitmapInfo.bmiHeader.biBitCount := 32
	else
		bitmapInfo.bmiHeader.biBitCount := 16;
	bitmapInfo.bmiHeader.biCompression := BI_RGB;
	bitmapInfo.bmiHeader.biSizeImage := 0;
	bitmapInfo.bmiHeader.biXPelsPerMeter := 0;
	bitmapInfo.bmiHeader.biYPelsPerMeter := 0;
	bitmapInfo.bmiHeader.biClrUsed := 0;
	bitmapInfo.bmiHeader.biClrImportant := 0;

	theDocument^.fBitmap := CreateDIBSection(hdc, bitmapInfo, DIB_RGB_COLORS,theDocument^.fBitStorage, THandle(nil), 0); //Delphi: casted nil to a THandle
	SelectObject(theDocument^.fMemoryDC, theDocument^.fBitmap);

		(* create a pixmap *)
	aPixmap.width := theDocument^.fWidth;
	aPixmap.height := theDocument^.fHeight;
	aPixmap.image := theDocument^.fBitStorage;
	if (is32Bit = kQ3True) then
	 begin
		aPixmap.rowBytes := aPixmap.width * 4;
		aPixmap.pixelSize := 32;
		aPixmap.pixelType := kQ3PixelTypeRGB32;
  	 end
	else
	 begin
		aPixmap.rowBytes := trunc(aPixmap.width * (bitmapInfo.bmiHeader.biBitCount/8)); //Delphi: using truncating real to cardinal
		aPixmap.rowBytes := trunc(aPixmap.rowBytes + 3) and long(not 3); // make it long aligned //Delphi: truncating eal to cardinal //not 3: was ~3
		aPixmap.pixelSize := 16;
		aPixmap.pixelType := kQ3PixelTypeRGB16;
	end;
	aPixmap.bitOrder := kQ3EndianBig;
	aPixmap.byteOrder := kQ3EndianBig; (* this should be Little, but that crashes *)

		(* set up the pixmapDrawContext *)
	myPixmapDrawContextData.pixmap := aPixmap;
	myPixmapDrawContextData.drawContextData := myDrawContextData;

	//	Create draw context and return it, if it's nil the caller must handle
	myDrawContext := Q3PixmapDrawContext_New(@myPixmapDrawContextData);

	result:=myDrawContext;
end;

//----------------------------------------------------------------------------------

function MyNewCamera(theDocument:DocumentPtr):TQ3CameraObject;
var perspectiveData:TQ3ViewAngleAspectCameraData;
    camera:TQ3CameraObject;
const _from:TQ3Point3D=(x:0.0; y:0.0; z:7.0);
      _to:TQ3Point3D=(x:0.0; y:0.0; z:0.0);
      _up:TQ3Vector3D=(x:0.0; y:1.0; z:0.0);
      fieldOfView:float=1.0;
      hither:float=0.001;
      yon:float=1000;
      returnVal:TQ3Status=kQ3Failure;
begin
	perspectiveData.cameraData.placement.cameraLocation 	:= _from;
	perspectiveData.cameraData.placement.pointOfInterest 	:= _to;
	perspectiveData.cameraData.placement.upVector 		:= _up;

	perspectiveData.cameraData.range.hither	:= hither;
	perspectiveData.cameraData.range.yon 	:= yon;

	perspectiveData.cameraData.viewPort.origin.x := -1.0;
	perspectiveData.cameraData.viewPort.origin.y := 1.0;
	perspectiveData.cameraData.viewPort.width := 2.0;
	perspectiveData.cameraData.viewPort.height := 2.0;

	perspectiveData.fov := fieldOfView;
	perspectiveData.aspectRatioXToY	:=
		{(float)}(theDocument^.fWidth) /
		{(float)}(theDocument^.fHeight);

	camera := Q3ViewAngleAspectCamera_New(@perspectiveData);

	result:=camera;

end;

//----------------------------------------------------------------------------------

function MyNewLights:TQ3GroupObject;
const pointLocation:TQ3Point3D=(x:-10.0; y:0.0; z:10.0);
      fillDirection:TQ3Vector3D=(x:10.0; y:0.0; z:10.0);
      WhiteLight:TQ3ColorRGB=(r:1.0; g:1.0; b:1.0);
var	myGroupPosition:TQ3GroupPosition;
	myLightList:TQ3GroupObject;
	myLightData:TQ3LightData;
	myPointLightData:TQ3PointLightData;
	myDirectionalLightData:TQ3DirectionalLightData;
	myAmbientLight, myPointLight, myFillLight:TQ3LightObject;
label bail;
begin

	//	Set up light data for ambient light.  This light data will be used for point and fill
	//	light also.

	myLightData.isOn := kQ3True;
	myLightData.color := WhiteLight;

	//	Create ambient light.
	myLightData.brightness := 0.25;
	myAmbientLight := Q3AmbientLight_New(@myLightData);
	if ( myAmbientLight = nil ) then
		goto bail;

	//	Create point light.
	myLightData.brightness := 1.0;
	myPointLightData.lightData := myLightData;
	myPointLightData.castsShadows := kQ3False;
	myPointLightData.attenuation := kQ3AttenuationTypeNone;
	myPointLightData.location := pointLocation;
	myPointLight := Q3PointLight_New(@myPointLightData);
	if ( myPointLight = nil ) then
		goto bail;

	//	Create fill light.
	myLightData.brightness := 0.3;
	myDirectionalLightData.lightData := myLightData;
	myDirectionalLightData.castsShadows := kQ3False;
	myDirectionalLightData.direction := fillDirection;
	myFillLight := Q3DirectionalLight_New(@myDirectionalLightData);
	if ( myFillLight = nil ) then
		goto bail;

	//	Create light group and add each of the lights into the group.
	myLightList := Q3LightGroup_New;
	if ( myLightList = nil ) then
		goto bail;
	myGroupPosition := Q3Group_AddObject(myLightList, myAmbientLight);
	if ( myGroupPosition = nil ) then //Delphi: was 0, made nil
		goto bail;
	myGroupPosition := Q3Group_AddObject(myLightList, myPointLight);
	if ( myGroupPosition = nil ) then //Delphi: was 0, made nil
		goto bail;
	myGroupPosition := Q3Group_AddObject(myLightList, myFillLight);
	if ( myGroupPosition = nil ) then //Delphi: was 0, made nil
		goto bail;

	Q3Object_Dispose( myAmbientLight ) ;
	Q3Object_Dispose( myPointLight ) ;
	Q3Object_Dispose( myFillLight ) ;

	//	Done!
	result:=myLightList;
        exit;

bail:
	//	If any of the above failed, then return nothing!
	result:=nil;
end;

{static} procedure MyColorBoxFaces(var myBoxData:TQ3BoxData);
var faceColor:TQ3ColorRGB;
    face:short;
begin
	// sanity check - you need to have set up
	// the face attribute set for the box data
	// before calling this.

	if( myBoxData.faceAttributeSet = nil ) then
		exit;

	// make each face of a box a different color

	for face:=0 to 5 do
         begin

		myBoxData.faceAttributeSet[face] := Q3AttributeSet_New;
		case face of
                 0:             begin
				faceColor.r := 1.0;
				faceColor.g := 0.0;
				faceColor.b := 0.0;
				end;

                 1:             begin
				faceColor.r := 0.0;
				faceColor.g := 1.0;
				faceColor.b := 0.0;
				end;

                 2:             begin
				faceColor.r := 0.0;
				faceColor.g := 0.0;
				faceColor.b := 1.0;
				end;

                 3: begin
				faceColor.r := 1.0;
				faceColor.g := 1.0;
				faceColor.b := 0.0;
				end;

		4: begin
				faceColor.r := 1.0;
				faceColor.g := 0.0;
				faceColor.b := 1.0;
				end;

                5: begin
				faceColor.r := 0.0;
				faceColor.g := 1.0;
				faceColor.b := 1.0;
				end;
		end;
		Q3AttributeSet_Add(myBoxData.faceAttributeSet[face], integer(kQ3AttributeTypeDiffuseColor), @faceColor);
	end;
end;

{static} function MyAddTransformedObjectToGroup(theGroup:TQ3GroupObject;theObject:TQ3Object;var translation:TQ3Vector3D):TQ3GroupPosition;
var transform:TQ3TransformObject;
begin
	transform := Q3TranslateTransform_New(@translation);
	Q3Group_AddObject(theGroup, transform);
	Q3Object_Dispose(transform);
	result:=Q3Group_AddObject(theGroup, theObject);
end;

function MyNewModel:TQ3GroupObject;
var myGroup:TQ3GroupObject;
    myBox:TQ3GeometryObject;
    myBoxData:TQ3BoxData;
    //myGroupPosition:TQ3GroupPosition;
    myIlluminationShader:TQ3ShaderObject;
    translation:TQ3Vector3D;
    //i,j:unsigned_long;

    faces:array[0..5] of TQ3SetObject;
    face:short;

const kBoxSide=0.8;
      kBoxSidePlusGap=0.1;

begin
	//myGroup := nil; //Birb: removed
        myBox:=nil; //Delphi: needed to avoid a compiler warning that this var may be unititialized
        myIlluminationShader:=nil; //Delphi: needed to avoid a compiler warning that this var may be unititialized

	// Create a group for the complete model.
	// do not use Q3OrderedDisplayGroup_New since in this
	// type of group all of the translations are applied before
	// the objects in the group are drawn, in this instance we
	// dont want this.
        myGroup := Q3DisplayGroup_New(); //Delphi: placed out of if
	if (myGroup <> nil ) then
         begin

		// Define a shading type for the group
		// and add the shader to the group
		myIlluminationShader := Q3PhongIllumination_New;
		Q3Group_AddObject(myGroup, myIlluminationShader);

		// set up the colored faces for the box data
		myBoxData.faceAttributeSet := @faces;
		myBoxData.boxAttributeSet := nil;
		MyColorBoxFaces( myBoxData ) ;

		// create the box itself
		Q3Point3D_Set(myBoxData.origin, 0, 0, 0);
		Q3Vector3D_Set(myBoxData.orientation, 0, kBoxSide, 0);
		Q3Vector3D_Set(myBoxData.majorAxis, 0, 0, kBoxSide);
		Q3Vector3D_Set(myBoxData.minorAxis, kBoxSide, 0, 0);
		myBox := Q3Box_New(myBoxData);

		translation.x := 0;  translation.y := kBoxSidePlusGap;  translation.z := 0;
		MyAddTransformedObjectToGroup( myGroup, myBox, translation );
		translation.x := 2 * kBoxSide;	translation.y := kBoxSidePlusGap;  translation.z := 0;
		MyAddTransformedObjectToGroup( myGroup, myBox, translation ) ;
		translation.x := 0;  translation.y := kBoxSidePlusGap;  translation.z := -2 * kBoxSide;
		MyAddTransformedObjectToGroup( myGroup, myBox, translation ) ;
		translation.x := -2 * kBoxSide;	 translation.y := kBoxSidePlusGap;  translation.z := 0;
		MyAddTransformedObjectToGroup( myGroup, myBox, translation ) ;
         end;

	// dispose of the objects we created here
	if( myIlluminationShader<>nil ) then
		Q3Object_Dispose(myIlluminationShader);

	for face := 0 to 5 do
  	  if( myBoxData.faceAttributeSet[face] <> nil ) then
             Q3Object_Dispose(myBoxData.faceAttributeSet[face]);

	if(myBox<>nil) then
		Q3Object_Dispose( myBox );

	//	Done!
	result:=myGroup;
end;

procedure pvCamera_Fit(theDocument:DocumentPtr);
const cQ3Vector3D_010:TQ3Vector3D=(x:0.0; y:1.0; z:0.0);
var from, _to:TQ3Point3D;
    viewBBox:TQ3BoundingBox;
    fieldOfView, hither, yon:float;

    viewVector,
    normViewVector,
    eyeToFrontClip,
    eyeToBackClip,
    diagonalVector:TQ3Vector3D;
    viewDistance:float;
    maxDimension:float;

    data:TQ3ViewAngleAspectCameraData;
    up:TQ3Vector3D;

    w,h:float;

    camera:TQ3CameraObject;

begin
	if (theDocument=nil) then exit;

	if (theDocument^.fModel=nil) then exit;

	pvBBox_Get(theDocument, viewBBox);
	pvBBoxCenter(viewBBox, _to);

        begin
 	Q3Point3D_Subtract(viewBBox.max,
        		   viewBBox.min,
			   diagonalVector);
	maxDimension := Q3Vector3D_Length(diagonalVector);
	if (maxDimension = 0.0) then
		maxDimension := 1.0;

	maxDimension := maxDimension * (8.0 / 7.0);

	from.x := _to.x;
	from.y := _to.y;
	from.z := _to.z + (2 * maxDimension);

	Q3Point3D_Subtract(_to, from, viewVector);
	viewDistance := Q3Vector3D_Length(viewVector);
	Q3Vector3D_Normalize(viewVector, normViewVector);

	maxDimension := maxDimension / 2.0;

	Q3Vector3D_Scale(normViewVector,
                         viewDistance - maxDimension,
			 eyeToFrontClip);

	Q3Vector3D_Scale(normViewVector,
  			 viewDistance + maxDimension,
			 eyeToBackClip);

	hither 	:= Q3Vector3D_Length(eyeToFrontClip);
	yon 	:= Q3Vector3D_Length(eyeToBackClip);

	fieldOfView := Q3Math_RadiansToDegrees(1.25 * ErMath_Atan(maxDimension/hither));
	end;

	begin
         up:= cQ3Vector3D_010; //Delphi: put as constant

		data.cameraData.placement.cameraLocation 	:= from;
		data.cameraData.placement.pointOfInterest 	:= _to;
		data.cameraData.placement.upVector 		:= up;

		data.cameraData.range.hither := hither;
		data.cameraData.range.yon    := yon;

		data.cameraData.viewPort.origin.x := -1.0;
		data.cameraData.viewPort.origin.y :=  1.0;
		data.cameraData.viewPort.width  := 2.0;
		data.cameraData.viewPort.height := 2.0;

		data.fov := Q3Math_DegreesToRadians(fieldOfView);

		begin
    		w := {float(}theDocument^.fWidth{)}; //Delphi: can't cast an int to a float
		h := {float(}theDocument^.fHeight{)}; //Delphi: can't cast an int to a float

		data.aspectRatioXToY := w/h;
		end;

		if (theDocument^.fView<>nil) then
 		 begin
		 Q3View_GetCamera(theDocument^.fView,
                    @camera);
                 if (camera<>nil) then
                  begin
  		  Q3ViewAngleAspectCamera_SetData(camera, @data);
		  Q3Object_Dispose(camera);
		  end
		 else
                  begin
		  camera  := Q3ViewAngleAspectCamera_New (@data);
                  if (camera<>nil) then
                   begin
		   Q3View_SetCamera (theDocument^.fView, camera);
		   Q3Object_Dispose(camera);
                   end;
		  end;
		end;
	end;
end;

procedure pvBBox_Get(var theDocument:DocumentPtr;var bbox:TQ3BoundingBox);
begin

 if (theDocument^.fView<>nil) then
  begin
  Q3View_StartBoundingBox(theDocument^.fView, kQ3ComputeBoundsExact);
  repeat
   if (Q3DisplayGroup_Submit(theDocument^.fModel, theDocument^.fView) = kQ3Failure) then
    begin
    Q3View_Cancel(theDocument^.fView);
    exit;
    end;
  until(Q3View_EndBoundingBox(theDocument^.fView, @bbox) <> kQ3ViewStatusRetraverse);
  end
 else
  begin
  Q3Point3D_Set((bbox.min), -0.1, -0.1, -0.1);
  Q3Point3D_Set((bbox.max), 0.1, 0.1, 0.1);
  bbox.isEmpty := kQ3False;
  end;
end;

procedure pvBBoxCenter(var bbox:TQ3BoundingBox;var center:TQ3Point3D);
var xSize, ySize, zSize: float;
begin

	xSize := bbox.max.x - bbox.min.x;
	ySize := bbox.max.y - bbox.min.y;
	zSize := bbox.max.z - bbox.min.z;

	if (xSize <= kEPSILON) and
	    (ySize <= kEPSILON) and
		(zSize <= kEPSILON)  then
        begin
		bbox.max.x:=bbox.max.x+0.0001;
		bbox.max.y:=bbox.max.y+0.0001;
		bbox.max.z:=bbox.max.z+0.0001;

		bbox.min.x := bbox.min.x-0.0001;
		bbox.min.y := bbox.min.y-0.0001;
		bbox.min.z := bbox.min.z-0.0001;
	end;

	center.x := (bbox.min.x + bbox.max.x) / 2.0;
	center.y := (bbox.min.y + bbox.max.y) / 2.0;
	center.z := (bbox.min.z + bbox.max.z) / 2.0;
end;

end.
