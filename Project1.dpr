program Project1;

uses
  Vcl.Forms,
  OnCreate in 'OnCreate.pas' {Form1},
  Spravochnik_1 in 'Spravochnik_1.pas',
  SplashScreen in 'SplashScreen.pas',
  vedom in 'vedom.pas',
  Vedom2 in 'Vedom2.pas';

{$R *.res}

begin
  Application.Initialize;

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
