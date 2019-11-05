(* History:
 10Jun2000 - first creation
 25Jun2000 - using the "TStrFilenameProperty" editor for the "filename" property
 13Apr2002 - using contructor to call InitializeQTML
           - using destructor to call TerminateQTML
  5Apr2003 - added note that we may have to use "dsgninf=DesignEditors" or "dsgninf=DesignIntf" unit alias at Delphi6+ (Project/Options.../Directories-Conditionals/Aliases menu) [removed note later on, since we split into runtime and design packages]
*)

unit JQTComponent;

interface
 uses classes;

type
 TJQTComponent = class(TComponent) //all invisible QT components should extend this class
  constructor Create(AOnwer:TComponent); override;
  destructor Destroy; override;
 end;


implementation

uses qt_MacTypes,qt_QTML;

constructor TJQTComponent.Create(AOnwer:TComponent);
begin
 inherited;
 InitializeQTML(0); //must do this else any QT calls issued will crash!
end;

destructor TJQTComponent.Destroy;
begin
 TerminateQTML; //must call this one as many times as InitializeQTML has been called
 inherited;
end;

end.
