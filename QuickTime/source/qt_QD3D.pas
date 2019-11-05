{************************************************************************}
{                                                       	             }
{       Borland Delphi Runtime Library                  		       }
{       QuickTime interface unit                                         }
{ 									                   }
{ Portions created by Apple Computer, Inc. are 					 }
{ Copyright (C) 1995-1998 Apple Computer, Inc.. 			       }
{ All Rights Reserved. 							             }
{ 								                   	 }
{ The original file is: QD3D.h, released dd Mmm yyyy. 		       }
{ The original Pascal code is: qt_QD3D.pas, released 14 May 2000. 	 }
{ The initial developer of the Pascal code is George Birbilis            }
{ (birbilis@cti.gr).                     				             }
{ 									                   }
{ Portions created by George Birbilis are    				       }
{ Copyright (C) 1998-2000 George Birbilis 					 }
{ 									                   }
{       Obtained through:                               		       }
{ 									                   }
{       Joint Endeavour of Delphi Innovators (Project JEDI)              }
{									                   }
{ You may retrieve the latest version of this file at the Project        }
{ JEDI home page, located at http://delphi-jedi.org                      }
{									                   }
{ The contents of this file are used with permission, subject to         }
{ the Mozilla Public License Version 1.1 (the "License"); you may        }
{ not use this file except in compliance with the License. You may       }
{ obtain a copy of the License at                                        }
{ http://www.mozilla.org/MPL/MPL-1.1.html 	                         }
{ 									                   }
{ Software distributed under the License is distributed on an 	       }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or         }
{ implied. See the License for the specific language governing           }
{ rights and limitations under the License. 				       }
{ 									                   }
{************************************************************************}

//28Feb1999 - birbilis: using {$MINENUMSIZE 4} define
//14May2000 - birbilis: donated to Delphi-JEDI

unit qt_QD3D;

{$MINENUMSIZE 4} //must use this and make C enums into Delphi enums and not subrange types

interface
 uses C_Types;

 type TQ3WinViewerObject=pointer; //?

 //QD3D.h//

 (* Set Types *)

 type TQ3ElementType=long;

 const	kQ3ElementTypeNone	= 0;
	kQ3ElementTypeUnknown	= 32;
	kQ3ElementTypeSet	= 33;

 (* Flags and Switches *)

 type TQ3Boolean=(
       kQ3False   {= 0},
       kQ3True    {= 1});
      PQ3Boolean=^TQ3Boolean; //Delphi

      TQ3Switch=(
       kQ3Off   {= 0},
       kQ3On    {= 1});

      TQ3Status=(
       kQ3Failure  {= 0},
       kQ3Success  {= 1});
      PQ3Status=^TQ3Status; //Delphi

      TQ3Axis=(
       kQ3AxisX {= 0},
       kQ3AxisY {= 1},
       kQ3AxisZ {= 2});
      PQ3Axis=^TQ3Axis; //Delphi 

 type TQ3PixelType=(
       kQ3PixelTypeRGB32	{= 0}, (* Alpha:8 (ignored), R:8, G:8, B:8	*)
       kQ3PixelTypeARGB32	{= 1}, (* Alpha:8, R:8, G:8, B:8 			*)
       kQ3PixelTypeRGB16	{= 2}, (* Alpha:1 (ignored), R:5, G:5, B:5	*)
       kQ3PixelTypeARGB16	{= 3}, (* Alpha:1, R:5, G:5, B:5 			*)
       kQ3PixelTypeRGB16_565	{= 4}, (* Win32 only: 16 bits/pixel, R:5, G:6, B:5		*)
       kQ3PixelTypeRGB24	{= 5}); (* Win32 only: 24 bits/pixel, R:8, G:8, B:8		*)

 type TQ3Endian=(
       kQ3EndianBig    {= 0},
       kQ3EndianLittle {= 1});

 const kQ3EndCapNone		= 0;
       kQ3EndCapMaskTop		= 1 shl 0;
       kQ3EndCapMaskBottom	= 1 shl 1;
       kQ3EndCapMaskInterior	= 1 shl 2;
 type  TQ3EndCapMasks=int; {kQ3EndCapNone..kQ3EndCapMaskInterior;} //must be 32bit!!!

 type TQ3EndCap=unsigned_long;

 const kQ3ArrayIndexNULL = (not 0); //? was (~0) in C

 (* Objects *)

(*
 * Everything in QuickDraw 3D is an OBJECT: a bunch of data with a type,
 * deletion, duplication, and i/o methods.
 *)
 type TQ3ObjectType=long;
      OpaqueTQ3Object=packed record end;
      TQ3Object=^OpaqueTQ3Object;
      PQ3Object=^TQ3Object;
(* *)
(*
 * There are four subclasses of OBJECT:
 *	an ELEMENT, which is data that is placed in a SET
 *	a SHAREDOBJECT, which is reference-counted data that is shared
 *	VIEWs, which maintain state information for an image
 *	a PICK, which used to query a VIEW
 *)
 type TQ3ElementObject=TQ3Object;
      TQ3SharedObject=TQ3Object;
      TQ3ViewObject=TQ3Object;
      TQ3PickObject=TQ3Object;
(*
 * There are several types of SharedObjects:
 *	RENDERERs, which paint to a drawContext
 *	DRAWCONTEXTs, which are an interface to a device
 *	SETs, which maintains "mathematical sets" of ELEMENTs
 *	FILEs, which maintain state information for a metafile
 *	SHAPEs, which affect the state of the View
 *	SHAPEPARTs, which contain geometry-specific data about a picking hit
 *	CONTROLLERSTATEs, which hold state of the output channels for a CONTROLLER
 *	TRACKERs, which represent a position and orientation in the user interface
 *  STRINGs, which are abstractions of text string data.
 *	STORAGE, which is an abstraction for stream-based data storage (files, memory)
 *	TEXTUREs, for sharing bitmap information for TEXTURESHADERS
 *	VIEWHINTs, which specifies viewing preferences in FILEs
 *)
 type TQ3RendererObject=TQ3SharedObject;
      TQ3DrawContextObject=TQ3SharedObject;
      TQ3SetObject=TQ3SharedObject;
      TQ3ShapePartObject=TQ3SharedObject;
      TQ3FileObject=TQ3SharedObject;
      TQ3ShapeObject=TQ3SharedObject;
      TQ3ControllerStateObject=TQ3SharedObject;
      TQ3TrackerObject=TQ3SharedObject;
      TQ3StringObject=TQ3SharedObject;
      TQ3StorageObject=TQ3SharedObject;
      TQ3TextureObject=TQ3SharedObject;
      TQ3ViewHintsObject=TQ3SharedObject;
(*
 * There is one types of SET:
 *	ATTRIBUTESETs, which contain ATTRIBUTEs which are inherited
 *)
 type TQ3AttributeSet=TQ3SetObject;
(*
 * There are many types of SHAPEs:
 *	LIGHTs, which affect how the RENDERER draws 3-D cues
 *	CAMERAs, which affects the location and orientation of the RENDERER in space
 *	GROUPs, which may contain any number of SHARED OBJECTS
 *	GEOMETRYs, which are representations of three-dimensional data
 *	SHADERs, which affect how colors are drawn on a geometry
 *	STYLEs, which affect how the RENDERER paints to the DRAWCONTEXT
 *	TRANSFORMs, which affect the coordinate system in the VIEW
 *	REFERENCEs, which are references to objects in FILEs
 *  UNKNOWN, which hold unknown objects read from a metafile.
 *)
 type TQ3GroupObject=TQ3ShapeObject;
      TQ3GeometryObject=TQ3ShapeObject;
      TQ3ShaderObject=TQ3ShapeObject;
      TQ3StyleObject=TQ3ShapeObject;
      TQ3TransformObject=TQ3ShapeObject;
      TQ3LightObject=TQ3ShapeObject;
      TQ3CameraObject=TQ3ShapeObject;
      TQ3UnknownObject=TQ3ShapeObject;
      TQ3ReferenceObject=TQ3ShapeObject;
(*
 * For now, there is only one type of SHAPEPARTs:
 *	MESHPARTs, which describe some part of a mesh
 *)
 type TQ3MeshPartObject=TQ3ShapePartObject;
(*
 * There are three types of MESHPARTs:
 *	MESHFACEPARTs, which describe a face of a mesh
 *	MESHEDGEPARTs, which describe a edge of a mesh
 *	MESHVERTEXPARTs, which describe a vertex of a mesh
 *)
 type TQ3MeshFacePartObject=TQ3MeshPartObject;
      TQ3MeshEdgePartObject=TQ3MeshPartObject;
      TQ3MeshVertexPartObject=TQ3MeshPartObject;
(*
 * A DISPLAY Group can be drawn to a view
 *)
 type TQ3DisplayGroupObject=TQ3GroupObject;
(*
 * There are many types of SHADERs:
 *	SURFACESHADERs, which affect how the surface of a geometry is painted
 *	ILLUMINATIONSHADERs, which affect how lights affect the color of a surface
 *)
 type TQ3SurfaceShaderObject=TQ3ShaderObject;
      TQ3IlluminationShaderObject=TQ3ShaderObject;
(*
 * A handle to an object in a group
 *)
 type OpaqueTQ3GroupPosition=packed record end;
 TQ3GroupPosition=^OpaqueTQ3GroupPosition;
(*
 * TQ3ObjectClassNameString is used for the class name of an object
 *)
 const kQ3StringMaximumLength = 1024;
 type TQ3ObjectClassNameString=array[0..kQ3StringMaximumLength-1] of char;

 (* Point and Vector Definitions *)

 type TQ3Vector2D=packed record
       x:float;
       y:float;
       end;

      TQ3Vector3D=packed record
	x:float;
	y:float;
	z:float;
        end;
      PQ3Vector3D=^TQ3Vector3D; //Delphi

      TQ3Point2D=packed record
       x:float;
       y:float;
       end;

      TQ3Point3D=packed record
       x:float;
       y:float;
       z:float;
       end;
      PQ3Point3D=^TQ3Point3D; //Delphi

      TQ3RationalPoint4D=packed record
       x:float;
       y:float;
       z:float;
       w:float;
       end;

      TQ3RationalPoint3D=packed record
       x:float;
       y:float;
       w:float;
       end;

(******************************************************************************
 **																			 **
 **	Quaternion							     **
 **																			 **
 *****************************************************************************)

 type TQ3Quaternion=packed record
       w:float;
       x:float;
       y:float;
       z:float;
       end;
      PQ3Quaternion=^TQ3Quaternion; //Delphi

(******************************************************************************
 **																			 **
 **	Ray Definition							     **
 **																			 **
 *****************************************************************************)

 type TQ3Ray3D=packed record
       origin:TQ3Point3D;
       direction:TQ3Vector3D;
       end;


(******************************************************************************
 **																			 **
 **	Parameterization Data  typeures				             **
 **																			 **
 *****************************************************************************)

 type TQ3Param2D=packed record
       u:float;
       v:float;
       end;

 type TQ3Param3D=packed record
       u:float;
       v:float;
       w:float;
       end;

 type TQ3Tangent2D=packed record
       uTangent:TQ3Vector3D;
       vTangent:TQ3Vector3D;
       end;

 type TQ3Tangent3D=packed record
       uTangent:TQ3Vector3D;
       vTangent:TQ3Vector3D;
       wTangent:TQ3Vector3D;
       end;

(******************************************************************************
 **																			 **
 **	Polar and Spherical Coordinates					     **
 **																			 **
 *****************************************************************************)

 type TQ3PolarPoint=packed record
       r:float;
       theta:float;
       end;

 type TQ3SphericalPoint=packed record
       rho:float;
       theta:float;
       phi:float;
       end;

 (* Vertices *)
 type TQ3Vertex3D=packed record
       point:TQ3Point3D;
       attributeSet:TQ3AttributeSet;
       end;

 (* Matrices *)
 type TQ3Matrix3x3=packed record
       value:array[0..2,0..2]of float;
       end;
      PQ3Matrix3x3=^TQ3Matrix3x3; //Delphi

      TQ3Matrix4x4=packed record
       value:array[0..3,0..3]of float;
       end;
      PQ3Matrix4x4=^TQ3Matrix4x4; //Delphi

 (* Bitmap/Pixmap *)

 type TQ3Pixmap=packed record
       image:pointer;
       width:unsigned_long;
       height:unsigned_long;
       rowBytes:unsigned_long;
       pixelSize:unsigned_long; (* MUST be 16 or 32 to use with the Interactive Renderer on Mac OS *)
       pixelType:TQ3PixelType;
       bitOrder:TQ3Endian;
       byteOrder:TQ3Endian;
       end;

      TQ3StoragePixmap=packed record
       image:TQ3StorageObject;
       width:unsigned_long;
       height:unsigned_long;
       rowBytes:unsigned_long;
       pixelSize:unsigned_long; (* MUST be 16 or 32 to use with the Interactive Renderer on Mac OS *)
       pixelType:TQ3PixelType;
       bitOrder:TQ3Endian;
       byteOrder:TQ3Endian;
       end;

      TQ3Bitmap=packed record
	image:pchar;
	width:unsigned_long;
	height:unsigned_long;
	rowBytes:unsigned_long;
	bitOrder:TQ3Endian;
        end;

      TQ3MipmapImage=packed record (* An image for use as a texture mipmap *)
	width,		      (* Width of mipmap, must be power of 2   *)
	height,		      (* Height of mipmap, must be power of 2  *)
	rowBytes,	      (* Rowbytes of mipmap                    *)
	offset:unsigned_long; (* Offset from image base to this mipmap *)
       end;

      TQ3Mipmap=packed record
       image:TQ3StorageObject; (* Data containing the texture map and *)
                               (* if (useMipmapping==kQ3True) the     *)
                               (* mipmap data 		              *)
       useMipmapping:TQ3Boolean; (* True if mipmapping should be used  *)
                                 (* and all mipmaps have been provided *)
       pixelType:TQ3PixelType;
       bitOrder:TQ3Endian;
       byteOrder:TQ3Endian;
       reserved:unsigned_long; (* leave NULL for next version *)
       mipmaps:array[0..31]of TQ3MipmapImage; (* The actual number of mipmaps is determined from the size of the first mipmap *)
      end;

 (* Higher dimension quantities *)

 type TQ3Area=packed record
       min:TQ3Point2D;
       max:TQ3Point2D;
       end;

      TQ3PlaneEquation=packed record
       normal:TQ3Vector3D;
       constant:float;
       end;

      TQ3BoundingBox=packed record
	min:TQ3Point3D;
	max:TQ3Point3D;
	isEmpty:TQ3Boolean;
        end;

      TQ3BoundingSphere=packed record
	origin:TQ3Point3D;
	radius:float;
	isEmpty:TQ3Boolean;
        end;

(*
 *	The TQ3ComputeBounds flag passed to StartBoundingBox or StartBoundingSphere
 *	calls in the View. It's a hint to the system as to how it should
 *	compute the bbox of a shape:
 *
 *	kQ3ComputeBoundsExact:
 *		Vertices of shapes are transformed into world space and
 *		the world space bounding box is computed from them.  Slow!
 *
 *	kQ3ComputeBoundsApproximate:
 *		A local space bounding box is computed from a shape's
 *		vertices.  This bbox is then transformed into world space,
 *		and its bounding box is taken as the shape's approximate
 *		bbox.  Fast but the bbox is larger than optimal.
 *)

 type TQ3ComputeBounds=(
       kQ3ComputeBoundsExact	   {= 0},
       kQ3ComputeBoundsApproximate {= 1});

///////////////

 (* Color Definition *)

 type TQ3ColorRGB=packed record
       r:float;
       g:float;
       b:float;
       end;

      TQ3ColorARGB=packed record
       a:float;
       r:float;
       g:float;
       b:float;
       end;

(******************************************************************************
 **																			 **
 **	Object Types							     **
 **																			 **
 *****************************************************************************)
(*
 * Note:	a call to Q3Foo_GetType will return a value kQ3FooTypeBar
 *			e.g. Q3Shared_GetType(object) returns kQ3SharedTypeShape, etc.
 *)

const
(*
 kQ3ObjectTypeInvalid				=0L
 kQ3ObjectTypeView				=((TQ3ObjectType)FOUR_CHAR_CODE('view'))
 kQ3ObjectTypeElement				=((TQ3ObjectType)FOUR_CHAR_CODE('elmn'))
	 kQ3ElementTypeAttribute		=((TQ3ObjectType)FOUR_CHAR_CODE('eatt'))
 kQ3ObjectTypePick				=((TQ3ObjectType)FOUR_CHAR_CODE('pick'))
	 kQ3PickTypeWindowPoint			=((TQ3ObjectType)FOUR_CHAR_CODE('pkwp'))
	 kQ3PickTypeWindowRect			=((TQ3ObjectType)FOUR_CHAR_CODE('pkwr'))
 kQ3ObjectTypeShared				=((TQ3ObjectType)FOUR_CHAR_CODE('shrd'))
	 kQ3SharedTypeRenderer			=((TQ3ObjectType)FOUR_CHAR_CODE('rddr'))
*)
		 kQ3RendererTypeWireFrame	=TQ3ObjectType(((ord('w') shl 8 +ord('r'))shl 8 +ord('f'))shl 8 +ord('r')); {'wrfr'}
		 kQ3RendererTypeGeneric		=TQ3ObjectType(((ord('g') shl 8 +ord('n'))shl 8 +ord('r'))shl 8 +ord('r')); {'gnrr'}

		 kQ3RendererTypeInteractive	=TQ3ObjectType(((ord('c') shl 8 +ord('t'))shl 8 +ord('w'))shl 8 +ord('n')); {'ctwn'}
(*
	 kQ3SharedTypeShape			=((TQ3ObjectType)FOUR_CHAR_CODE('shap'))

		 kQ3ShapeTypeGeometry		                =((TQ3ObjectType)FOUR_CHAR_CODE('gmtr'))
			 kQ3GeometryTypeBox	                =((TQ3ObjectType)FOUR_CHAR_CODE('box '))
			 kQ3GeometryTypeGeneralPolygon	        =((TQ3ObjectType)FOUR_CHAR_CODE('gpgn'))
			 kQ3GeometryTypeLine		        =((TQ3ObjectType)FOUR_CHAR_CODE('line'))
			 kQ3GeometryTypeMarker			=((TQ3ObjectType)FOUR_CHAR_CODE('mrkr'))
			 kQ3GeometryTypePixmapMarker		=((TQ3ObjectType)FOUR_CHAR_CODE('mrkp'))
			 kQ3GeometryTypeMesh			=((TQ3ObjectType)FOUR_CHAR_CODE('mesh'))
			 kQ3GeometryTypeNURBCurve		=((TQ3ObjectType)FOUR_CHAR_CODE('nrbc'))
			 kQ3GeometryTypeNURBPatch		=((TQ3ObjectType)FOUR_CHAR_CODE('nrbp'))
			 kQ3GeometryTypePoint			=((TQ3ObjectType)FOUR_CHAR_CODE('pnt '))
			 kQ3GeometryTypePolygon			=((TQ3ObjectType)FOUR_CHAR_CODE('plyg'))
			 kQ3GeometryTypePolyLine		=((TQ3ObjectType)FOUR_CHAR_CODE('plyl'))
			 kQ3GeometryTypeTriangle		=((TQ3ObjectType)FOUR_CHAR_CODE('trng'))
			 kQ3GeometryTypeTriGrid			=((TQ3ObjectType)FOUR_CHAR_CODE('trig'))
			 kQ3GeometryTypeCone			=((TQ3ObjectType)FOUR_CHAR_CODE('cone'))
			 kQ3GeometryTypeCylinder		=((TQ3ObjectType)FOUR_CHAR_CODE('cyln'))
			 kQ3GeometryTypeDisk			=((TQ3ObjectType)FOUR_CHAR_CODE('disk'))
			 kQ3GeometryTypeEllipse			=((TQ3ObjectType)FOUR_CHAR_CODE('elps'))
			 kQ3GeometryTypeEllipsoid		=((TQ3ObjectType)FOUR_CHAR_CODE('elpd'))
			 kQ3GeometryTypePolyhedron		=((TQ3ObjectType)FOUR_CHAR_CODE('plhd'))
			 kQ3GeometryTypeTorus			=((TQ3ObjectType)FOUR_CHAR_CODE('tors'))
			 kQ3GeometryTypeTriMesh			=((TQ3ObjectType)FOUR_CHAR_CODE('tmsh'))


		 kQ3ShapeTypeShader				=((TQ3ObjectType)FOUR_CHAR_CODE('shdr'))
			 kQ3ShaderTypeSurface			=((TQ3ObjectType)FOUR_CHAR_CODE('sush'))
				 kQ3SurfaceShaderTypeTexture	=((TQ3ObjectType)FOUR_CHAR_CODE('txsu'))
			 kQ3ShaderTypeIllumination		=((TQ3ObjectType)FOUR_CHAR_CODE('ilsh'))
				 kQ3IlluminationTypePhong	=((TQ3ObjectType)FOUR_CHAR_CODE('phil'))
				 kQ3IlluminationTypeLambert	=((TQ3ObjectType)FOUR_CHAR_CODE('lmil'))
				 kQ3IlluminationTypeNULL	=((TQ3ObjectType)FOUR_CHAR_CODE('nuil'))
		 kQ3ShapeTypeStyle				=((TQ3ObjectType)FOUR_CHAR_CODE('styl'))
			 kQ3StyleTypeBackfacing			=((TQ3ObjectType)FOUR_CHAR_CODE('bckf'))
			 kQ3StyleTypeInterpolation		=((TQ3ObjectType)FOUR_CHAR_CODE('intp'))
			 kQ3StyleTypeFill			=((TQ3ObjectType)FOUR_CHAR_CODE('fist'))
			 kQ3StyleTypePickID			=((TQ3ObjectType)FOUR_CHAR_CODE('pkid'))
			 kQ3StyleTypeReceiveShadows		=((TQ3ObjectType)FOUR_CHAR_CODE('rcsh'))
			 kQ3StyleTypeHighlight			=((TQ3ObjectType)FOUR_CHAR_CODE('high'))
			 kQ3StyleTypeSubdivision		=((TQ3ObjectType)FOUR_CHAR_CODE('sbdv'))
			 kQ3StyleTypeOrientation		=((TQ3ObjectType)FOUR_CHAR_CODE('ofdr'))
			 kQ3StyleTypePickParts			=((TQ3ObjectType)FOUR_CHAR_CODE('pkpt'))
			 kQ3StyleTypeAntiAlias			=((TQ3ObjectType)FOUR_CHAR_CODE('anti'))


		 kQ3ShapeTypeTransform				=((TQ3ObjectType)FOUR_CHAR_CODE('xfrm'))
			 kQ3TransformTypeMatrix			=((TQ3ObjectType)FOUR_CHAR_CODE('mtrx'))
			 kQ3TransformTypeScale			=((TQ3ObjectType)FOUR_CHAR_CODE('scal'))
			 kQ3TransformTypeTranslate		=((TQ3ObjectType)FOUR_CHAR_CODE('trns'))
			 kQ3TransformTypeRotate			=((TQ3ObjectType)FOUR_CHAR_CODE('rott'))
			 kQ3TransformTypeRotateAboutPoint 	=((TQ3ObjectType)FOUR_CHAR_CODE('rtap'))
			 kQ3TransformTypeRotateAboutAxis 	=((TQ3ObjectType)FOUR_CHAR_CODE('rtaa'))
			 kQ3TransformTypeQuaternion		=((TQ3ObjectType)FOUR_CHAR_CODE('qtrn'))
			 kQ3TransformTypeReset			=((TQ3ObjectType)FOUR_CHAR_CODE('rset'))
		 kQ3ShapeTypeLight				=((TQ3ObjectType)FOUR_CHAR_CODE('lght'))
			 kQ3LightTypeAmbient			=((TQ3ObjectType)FOUR_CHAR_CODE('ambn'))
			 kQ3LightTypeDirectional		=((TQ3ObjectType)FOUR_CHAR_CODE('drct'))
			 kQ3LightTypePoint			=((TQ3ObjectType)FOUR_CHAR_CODE('pntl'))
			 kQ3LightTypeSpot			=((TQ3ObjectType)FOUR_CHAR_CODE('spot'))
		 kQ3ShapeTypeCamera				=((TQ3ObjectType)FOUR_CHAR_CODE('cmra'))
			 kQ3CameraTypeOrthographic		=((TQ3ObjectType)FOUR_CHAR_CODE('orth'))
			 kQ3CameraTypeViewPlane			=((TQ3ObjectType)FOUR_CHAR_CODE('vwpl'))
			 kQ3CameraTypeViewAngleAspect		=((TQ3ObjectType)FOUR_CHAR_CODE('vana'))
		 kQ3ShapeTypeGroup				=((TQ3ObjectType)FOUR_CHAR_CODE('grup'))
			 kQ3GroupTypeDisplay			=((TQ3ObjectType)FOUR_CHAR_CODE('dspg'))
				 kQ3DisplayGroupTypeOrdered	=((TQ3ObjectType)FOUR_CHAR_CODE('ordg'))
				 kQ3DisplayGroupTypeIOProxy	=((TQ3ObjectType)FOUR_CHAR_CODE('iopx'))
			 kQ3GroupTypeLight			=((TQ3ObjectType)FOUR_CHAR_CODE('lghg'))
			 kQ3GroupTypeInfo			=((TQ3ObjectType)FOUR_CHAR_CODE('info'))


		 kQ3ShapeTypeUnknown				=((TQ3ObjectType)FOUR_CHAR_CODE('unkn'))
			 kQ3UnknownTypeText			=((TQ3ObjectType)FOUR_CHAR_CODE('uktx'))
			 kQ3UnknownTypeBinary			=((TQ3ObjectType)FOUR_CHAR_CODE('ukbn'))
		 kQ3ShapeTypeReference				=((TQ3ObjectType)FOUR_CHAR_CODE('rfrn'))
			 kQ3ReferenceTypeExternal		=((TQ3ObjectType)FOUR_CHAR_CODE('rfex'))
	 kQ3SharedTypeSet					=((TQ3ObjectType)FOUR_CHAR_CODE('set '))
		 kQ3SetTypeAttribute				=((TQ3ObjectType)FOUR_CHAR_CODE('attr'))
	 kQ3SharedTypeDrawContext				=((TQ3ObjectType)FOUR_CHAR_CODE('dctx'))
		 kQ3DrawContextTypePixmap			=((TQ3ObjectType)FOUR_CHAR_CODE('dpxp'))
		 kQ3DrawContextTypeMacintosh			=((TQ3ObjectType)FOUR_CHAR_CODE('dmac'))
		 kQ3DrawContextTypeWin32DC			=((TQ3ObjectType)FOUR_CHAR_CODE('dw32'))
		 kQ3DrawContextTypeDDSurface			=((TQ3ObjectType)FOUR_CHAR_CODE('ddds'))
		 kQ3DrawContextTypeX11				=((TQ3ObjectType)FOUR_CHAR_CODE('dx11'))
	 kQ3SharedTypeTexture					=((TQ3ObjectType)FOUR_CHAR_CODE('txtr'))
		 kQ3TextureTypePixmap				=((TQ3ObjectType)FOUR_CHAR_CODE('txpm'))
		 kQ3TextureTypeMipmap				=((TQ3ObjectType)FOUR_CHAR_CODE('txmm'))


	 kQ3SharedTypeFile					=((TQ3ObjectType)FOUR_CHAR_CODE('file'))
	 kQ3SharedTypeStorage					=((TQ3ObjectType)FOUR_CHAR_CODE('strg'))
		 kQ3StorageTypeMemory				=((TQ3ObjectType)FOUR_CHAR_CODE('mems'))
		 kQ3MemoryStorageTypeHandle			=((TQ3ObjectType)FOUR_CHAR_CODE('hndl'))
		 kQ3StorageTypeUnix				=((TQ3ObjectType)FOUR_CHAR_CODE('uxst'))
		 kQ3UnixStorageTypePath				=((TQ3ObjectType)FOUR_CHAR_CODE('unix'))
		 kQ3StorageTypeMacintosh			=((TQ3ObjectType)FOUR_CHAR_CODE('macn'))
		 kQ3MacintoshStorageTypeFSSpec			=((TQ3ObjectType)FOUR_CHAR_CODE('macp'))
		 kQ3StorageTypeWin32				=((TQ3ObjectType)FOUR_CHAR_CODE('wist'))
	 kQ3SharedTypeString					=((TQ3ObjectType)FOUR_CHAR_CODE('strn'))
		 kQ3StringTypeCString				=((TQ3ObjectType)FOUR_CHAR_CODE('strc'))
	 kQ3SharedTypeShapePart					=((TQ3ObjectType)FOUR_CHAR_CODE('sprt'))
		 kQ3ShapePartTypeMeshPart			=((TQ3ObjectType)FOUR_CHAR_CODE('spmh'))
			 kQ3MeshPartTypeMeshFacePart		=((TQ3ObjectType)FOUR_CHAR_CODE('mfac'))
			 kQ3MeshPartTypeMeshEdgePart		=((TQ3ObjectType)FOUR_CHAR_CODE('medg'))
			 kQ3MeshPartTypeMeshVertexPart		=((TQ3ObjectType)FOUR_CHAR_CODE('mvtx'))
	 kQ3SharedTypeControllerState				=((TQ3ObjectType)FOUR_CHAR_CODE('ctst'))
	 kQ3SharedTypeTracker					=((TQ3ObjectType)FOUR_CHAR_CODE('trkr'))
	 kQ3SharedTypeViewHints					=((TQ3ObjectType)FOUR_CHAR_CODE('vwhn'))
	 kQ3SharedTypeEndGroup					=((TQ3ObjectType)FOUR_CHAR_CODE('endg'))
*)

(******************************************************************************
 **																			 **
 **	QuickDraw 3D System Routines					     **
 **																			 **
 *****************************************************************************)

 function Q3Initialize:TQ3Status; cdecl;
 function Q3Exit:TQ3Status; cdecl;
 function Q3IsInitialized:TQ3Boolean; cdecl;
 function Q3GetVersion(majorRevision:unsigned_longPtr;minorRevision:unsigned_longPtr):TQ3Status; cdecl;

(* Object Routines *)

 function Q3Object_Dispose(_object:TQ3Object):TQ3Status; cdecl;
 function Q3Object_Duplicate(_object:TQ3Object):TQ3Object; cdecl;
 function Q3Object_Submit(_object:TQ3Object;view:TQ3ViewObject):TQ3Status; cdecl;
 function Q3Object_IsDrawable(_object:TQ3Object):TQ3Boolean; cdecl;
 function Q3Object_IsWritable(_object:TQ3Object;theFile:TQ3FileObject):TQ3Boolean; cdecl;

implementation

(******************************************************************************
 **																			 **
 **	QuickDraw 3D System Routines					     **
 **																			 **
 *****************************************************************************)

function Q3Initialize; cdecl; external 'qd3d.dll';
function Q3Exit; cdecl; external 'qd3d.dll';
function Q3IsInitialized; cdecl; external 'qd3d.dll';
function Q3GetVersion; cdecl; external 'qd3d.dll';

(* Object Routines *)

 function Q3Object_Dispose; cdecl; external 'qd3d.dll';
 function Q3Object_Duplicate; cdecl; external 'qd3d.dll';
 function Q3Object_Submit; cdecl; external 'qd3d.dll';
 function Q3Object_IsDrawable; cdecl; external 'qd3d.dll';
 function Q3Object_IsWritable; cdecl; external 'qd3d.dll';

end.

