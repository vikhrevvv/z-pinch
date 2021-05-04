program FOCUS;

uses
  Forms,
  TWO in 'TWO.PAS' {Form1},
  Unit2 in 'Unit2.pas' {settingRis},
  Velocity in 'Velocity.pas',
  About in 'About.pas' {AboutBox},
  TIME1 in 'TIME1.PAS' {inTime},
  SP in 'SP.PAS',
  balanc in 'balanc.pas' {balance},
  init in 'init.pas' {Form3},
  TWOGLOB in 'TWOGLOB.PAS',
  WINEVAL in 'WINEVAL.PAS';

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TsettingRis, settingRis);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TinTime, inTime);
  Application.CreateForm(Tbalance, balance);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(Tbalance, balance);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(Tbalance, balance);
  Application.CreateForm(Tbalance, balance);
  Application.CreateForm(Tbalance, balance);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
