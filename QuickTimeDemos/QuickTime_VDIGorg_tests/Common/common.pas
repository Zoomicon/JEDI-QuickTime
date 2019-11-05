Unit common;

interface
 uses qt_MacTypes;

 procedure CheckErr(note:string;err:OSErr);
 procedure Initialize;

implementation
 uses SysUtils,qt_Movies;

//
// A little macro to spit out the results of functions we call.
//
procedure CheckErr;
var msg:string;
begin
 msg:=format('%s: \t%d\n',[note,err]);
 writeln(msg);
 if(err<>0) then raise Exception.Create(msg); //? shouldn't this be err<>noErr?
end;

//
//	Initialize everything for the program, make sure we can run
//
procedure Initialize;
begin
 checkErr('Call to EnterMovies failed',EnterMovies);
end;

end.
