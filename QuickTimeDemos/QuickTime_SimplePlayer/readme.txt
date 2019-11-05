Simple Player demo using the QuickTime headers
-----------------------------------------------------

This is a form that uses the QuickTime headers to show a movie in it

All children of the form that descend from TControl (that is any controls
that have their one Windows handle) will be visible over the movie

All children descending from TGraphicsControl won't be visible. Code to hook movie
toolbox's updates of the movie and paint the children is needed. Otherwise a panel child
is needed to play the movie inside it (or use my TQTVRControl from http://visitweb.com/QT4Delphi)

You can open-up any QT movie from the file menus, but if you open a QTVR object or panorama
you'll be able to spin arround using the standard QTVR navigation (mouse drag - CTRL and SHIFT to
zoom and unzoom) or the child arrow buttons of the form that use the QuickTimeVR Manager API to 
pan (move left-right) or tilt (move up-down) the QTVR panorama or object movie

Buttons could be added for zoom/unzoom or node change (for multinode QTVR movies) too

------------------------------------------------------
this document was last updated by
George Birbilis (birbilis@cti.gr) at 17Sepy2001
