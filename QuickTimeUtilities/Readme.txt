QuickTime Utilities - Readme.txt
last update: 19 Sep 2004 by George Birbilis (birbilis@kagi.com)

0. RELEASE HISTORY

* 10 Jun 2000 - first version donated to Delphi-JEDI (http://www.delphi-jedi.org)
* 10 Jun 2001 - added "Delphi4" folder with "QuickTimeUtilities" package for Delphi4 (there has also been a "Delphi5" folder)
* 01 Feb 2002 - reorganized subfolders
* 21 Apr 2002 - added QTURL and QTStep units
                     - added "Delphi6" folder with "QuickTimeUtilities" package for Delphi6
* 19 Sep 2004 - added "Delphi7" folder with "QuickTimeUtilities" package for Delphi7

1. KNOWN ISSUES

These are Apple's utitities ported from QuickTime sample projects in C

2. IMPLEMENTATION

Not all of the utilities are test yet

3. TESTER REPORTS

Do send your comments at birbilis@kagi.com
If you can test Box3DSupport.pas utilities for QuickDraw3D I'd be grateful

4. ASSOCIATED WORK

The original Apple's sample code is at:
http://developer.apple.com/samplecode/Sample_Code/QuickTime.htm

5. FILE MAPPING

Using the same filenames as Apple's original C files, e.g. QTVRUtils.c -> QTVRUtils.pas
Apple is reusing these utilities in most of its sample projects

6. DEFINES

Some MAC defines etc. are used in the sources, they were like that in the QuickTime headers.
Don't remove them, you never know: Delphi might be released for the Mac too someday (since MacOS-X
will be Mach-BSD-kernel based and Delphi/Kylix is going to be released soon for Linux)
