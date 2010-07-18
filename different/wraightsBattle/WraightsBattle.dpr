program WraightsBattle;

{%File 'ModelSupport\MainUnit\MainUnit.txvpck'}
{%File 'ModelSupport\default.txvpck'}

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
