unit MainGameUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, CastleUIState,
  {$ifndef cgeapp}
  Forms, Controls, Graphics, Dialogs, CastleControl,
  {$else}
  CastleWindow, 
  {$endif}
  CastleControls, CastleColors, CastleUIControls,
  CastleTriangles, CastleShapes, CastleVectors,
  CastleCameras, CastleApplicationProperties, CastleLog,
  CastleSceneCore, CastleScene, CastleViewport,
  X3DNodes, X3DFields, X3DTIme,
  CastleImages, CastleTimeUtils, CastleKeysMouse;

type
  { TCastleApp }

{$ifndef cgeapp}

  { TCastleForm }

  TCastleForm = class(TForm)
    Window: TCastleControlBase;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WindowClose(Sender: TObject);
    procedure WindowOpen(Sender: TObject);
  end;
{$endif}

  TCastleApp = class(TUIState)
    procedure BeforeRender; override; // TCastleUserInterface
    procedure Render; override; // TCastleUserInterface
    procedure Resize; override; // TCastleUserInterface
    procedure Update(const SecondsPassed: Single; var HandleInput: boolean); override; // TUIState
    function  Motion(const Event: TInputMotion): Boolean; override; // TUIState
    function  Press(const Event: TInputPressRelease): Boolean; override; // TUIState
    function  Release(const Event: TInputPressRelease): Boolean; override; // TUIState
  private
    Viewport: TCastleViewport;
    Scene: TCastleScene;
  public
    procedure Start; override; // TUIState
    procedure Stop; override; // TUIState
    procedure LoadScene(filename: String);
  end;

var
  GLIsReady: Boolean;
  CastleApp: TCastleApp;
{$ifndef cgeapp}
  CastleForm: TCastleForm;
{$endif}

{$ifdef cgeapp}
procedure WindowClose(Sender: TUIContainer);
procedure WindowOpen(Sender: TUIContainer);
{$endif}

implementation
{$ifdef cgeapp}
uses GameInitialize;
{$endif}

{$ifndef cgeapp}
{$R *.lfm}
{$endif}

procedure TCastleApp.LoadScene(filename: String);
begin
  // Set up the main viewport
  Viewport := TCastleViewport.Create(Application);
  // Use all the viewport
  Viewport.FullSize := true;
  // Automatically position the camera
  Viewport.AutoCamera := True;
  // Use default navigation keys
  Viewport.AutoNavigation := False;

  // Add the viewport to the CGE control
  InsertFront(Viewport);

  Scene := TCastleScene.Create(Application);
  // Load a model into the scene
  Scene.Load(filename);

  // Add the scene to the viewport
  Viewport.Items.Add(Scene);

  // Tell the control this is the main scene so it gets some lighting
  Viewport.Items.MainScene := Scene;
end;

procedure TCastleApp.Start;
begin
  Scene := nil;
//  UIScaling := usDpiScale;
  LoadScene('castle-data:/box_roty.x3dv');
end;

procedure TCastleApp.Stop;
begin
end;


{
Lazarus only code
}
{$ifndef cgeapp}
procedure TCastleForm.FormCreate(Sender: TObject);
begin
  GLIsReady := False;
  Caption := 'Basic CGE Lazarus Application';
end;

procedure TCastleForm.FormDestroy(Sender: TObject);
begin
end;
{$endif}

{$ifdef cgeapp}
procedure WindowOpen(Sender: TUIContainer);
{$else}
procedure TCastleForm.WindowOpen(Sender: TObject);
{$endif}
begin
  GLIsReady := True;
  {$ifndef cgeapp}
  TCastleControlBase.MainControl := Window;
  CastleApp := TCastleApp.Create(Application);
  TUIState.Current := CastleApp;
  CastleApp.Start;
  {$else}
  // Duplicated from ApplicationInitialize (still breaks)
  if Application.MainWindow = nil then
    Application.MainWindow := Window;
  CastleApp := TCastleApp.Create(Application);
  TUIState.Current := CastleApp;
  {$endif}
end;

{$ifdef cgeapp}
procedure WindowClose(Sender: TUIContainer);
{$else}
procedure TCastleForm.WindowClose(Sender: TObject);
{$endif}
begin
end;

procedure TCastleApp.BeforeRender;
const
  // How many seconds to take to rotate the scene
  SecsPerRot = 4;
var
  theta: Single;
begin
  if GLIsReady then
    begin
    // Set angle (theta) to revolve completely once every SecsPerRot
    theta := ((CastleGetTickCount64 mod
              (SecsPerRot * 1000)) /
              (SecsPerRot * 1000)) * (Pi * 2);

    // Rotate the scene in Y
    // Change to Vector4(1, 0, 0, theta); to rotate in X

    Scene.Rotation := Vector4(0, 1, 0, theta);
    end;
end;

procedure TCastleApp.Render;
begin
end;

procedure TCastleApp.Resize;
begin
end;

procedure TCastleApp.Update(const SecondsPassed: Single; var HandleInput: boolean);
begin
end;

function TCastleApp.Motion(const Event: TInputMotion): Boolean;
begin
  Result := inherited;
end;

function TCastleApp.Press(const Event: TInputPressRelease): Boolean;
begin
  Result := inherited;
end;

function    TCastleApp.Release(const Event: TInputPressRelease): Boolean;
begin
  Result := inherited;
end;

end.

