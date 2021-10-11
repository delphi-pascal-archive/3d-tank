program Prog3D;

uses
  Forms,
  frmMain in 'frmMain.pas' {frmcube};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tfrmcube, frmcube);
  Application.Run;
end.

