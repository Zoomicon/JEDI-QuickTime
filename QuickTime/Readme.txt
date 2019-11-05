QuickTime headers - Readme.txt
------------------------------
last editor: George Birbilis (birbilis@kagi.com)

0. RELEASE HISTORY

* 14May2000 - first version donated to Delphi-JEDI (http://www.delphi-jedi.org)
* 10Jun2001 - added "Delphi4" folder with "QuickTime" package for Delphi4 (there has also been a "Delphi5" folder)
* 08Oct2001 - added hotspot related calls and "events & cursor" related calls to qt_QuickTimeVR.pas
* 07Nov2001 - added "View State Calls" to qt_QuickTimeVR.pas
* 08Nov2001 - added lots of stuff to qt_QuickTimeVR, not it's almost completed!
* ?????2002 - added qt_QuickTimeComponents, qt_Aliases and qt_OSUtils and other stuff
* 13Apr2002 - new version, not using "out" parameters anymore
* 21May2002 - added qt_FixMath and various functions to qt_Movies
            - added "Delphi6" folder with "QuickTime" package for Delphi6
* 23May2002 - added qt_Finder and various declarations to the existing headers
* 19Sep2004 - added "Delphi7" folder with "QuickTime" package for Delphi7
* 15Feb2007 - updated texts etc.

1. KNOWN ISSUES

There's a problem with QuickTime dialogs (like Music-related ones [instrument picking etc.]), they don't seem to receive events correctly and remain modal and unresponsive till ESC key is pressed (they close when that is pressed). Need to add some special event handling for them maybe.

2. IMPLEMENTATION

QuickTime headers use 4-char strings (FOUR_CHAR_CODE) for OSCode/ComponentType, which in most headers I've defined
as an integer and using char arithmetic (shifts etc.) to construct the integer from the 4 chars
that make up the string-id from the QT headers. Declaring it as "packed array of char" works, but
may cause problems in future Delphi versions, if char changes size. Maybe just risk it and make
the headers more readable (making them is easy anyway with my C2PasFilter utility) and hope Borland
will define some shortChar type if they make the char type 2-bytes-wide in the future (I think
Kylix/Delphi has a 2 char that is 2-bytes-wide). Would need a

type sca4=packed array[1..4] of shortChar;

and then do

xxxComponent=sca4('qvod');
etc. instead of just
xxxComponent='qvod';

now I'm doing

xxxComponent=(((ord('q') shl 8 +ord('v'))shl 8 +ord('o'))shl 8 +ord('d'))
[this string can be obtained from the C2PasFilter utility, passing in 'qvod' and pressing the FCC button]

[**** NEWER INFO (1Feb2002) ****]
I tried 
 type FOUR_CHAR_CODE=packed array[0..3] of ansiChar;
and
 const MovieFileType:FOUR_CHAR_CODE='MooV';

Then wherever MovieFileType is used, passing:
 cardinal(MovieFileType)
but it seems it gets the chars reversed, e.g. VooM instead of MooV (remember Motorolla PowerPC is of
reverse endianness than the Intel x86 family)

**** so I'm going back to the tried and working formula of using the FCC expressions that can be 
generated with the C2PasFilter utility (other way might be to invert the 4 char strings in all those 
declarations, but that would be a bad pattern to suggest for people porting their Mac code to Delphi, 
cause they might easily forget to reverse those strings in their own four char codes - better stick
to the calculated FCC formula). Plus with the FOUR_CHAR_CODE define the headers were cleaner from 
expressions, but would be more difficult to read for error checking (cause of the reversed strings)
and users using the FOUR_CHAR_CODE constants would need to cast them to cardinal everywhere they use
them

the unfortunate thing is that Delphi doesn't support defines and that if Delphi is ported to Mac in the 
future all those formulas would need to be changed to assume the reverse endianess)


3. TESTER REPORTS

Some problems have been reported with the music instruments dialog coming up disabled
(seems to have WS_DISABLED set) and only accepting ESC to close it (no mouse clicks are accepted)

4. ASSOCIATED WORK
QT4Delphi components/controls by George Birbilis (http://visitweb.com/QT4Delphi)

5. FILE MAPPING

The file mapping used is from "xxx.h" to "qt_xxx.pas"
This is done for grouping reasons and cause Apple is using header names like "Windows.h" and
"Printing.h" which would most possibly do conflicts with other units.

6. DEFINES

Some MAC defines etc. are used in the sources, they were like that in the QuickTime headers.
Don't remove them, you never know: Delphi might be released for the Mac too someday (since MacOS-X 
is Mach-BSD-kernel based and Apple has moved to Intel CPUs now [I know Kylix/Delphi for Linux died off 
though, so this may just be a wild dream])

7. BUG LIST and FIXES

I have patched the definition of "FSSpec" at qt_Files.pas cause the debugger showed some
different behaviour of this structure than the one documented in the QuickTime C headers.
Maybe this needs a rechecking with the latest QT headers (might have been a QT headers' "bug")
