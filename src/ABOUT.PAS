unit About;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    OKButton: TBitBtn;
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Tel: TLabel;
    RRC: TLabel;
    Email: TLabel;
    MYLabel1: TLabel;
    NFI: TLabel;
    Author: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation
uses sysutils;
{$R *.DFM}

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  close
end;

{procedure TAboutBox.FormActivate(Sender: TObject);
begin
  Label1.Caption:='Free memory '{+inttostr(memavail)
end;}


end.

