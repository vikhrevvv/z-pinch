unit UNIT2;
interface
uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;
type
  TsettingRis = class(TForm)
    ListBox1: TListBox;
    TrackBar1: TTrackBar;
    mas1: TMemo;
    mas2: TMemo;
    procedure ChangeRis(Sender: TObject; Npart4: integer);
    procedure TrackBar1Change(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;
const
Color6: array [0..7] of integer =($111100,
$110011,$1111,$1100,$110000,$101010,$11,$101010);
 ten1: array [1..5] of integer = (15,13,10,6,0);
 ten2: array [6..12] of integer = (14,12,10,8,6,3,0);
var
  settingRis: TsettingRis;
  NumberK, Npart4: integer;
  Mastab: array [0..7] of integer;
  part4: array [1..2] of integer;
  mastab64: array [1..64] of double;
  newris: boolean;
implementation
uses Two;
{$R *.DFM}

procedure TsettingRis.ChangeRis(Sender: TObject; Npart4: integer);
var k: integer;
begin k:=ListBox1.ItemIndex;
  case Npart4 of
 1: FORM1.Button1.caption:=ListBOX1.ITEMS[K];
 2: FORM1.Button2.caption:=ListBOX1.ITEMS[K];
  end;
 if Form1.Start1.Enabled and not newris then
 begin newris:=true; NTfig; newris:=false end
 else newris:=true;
end;

procedure TsettingRis.TrackBar1Change(Sender: TObject);
begin mastab[ListBox1.ItemIndex]:=TrackBar1.position;
  FormShow(Sender);
end;

procedure TsettingRis.ListBox1Click(Sender: TObject);
begin part4[Npart4]:=ListBox1.ItemIndex;
  FormShow(Sender);
end;

procedure TsettingRis.FormShow(Sender: TObject);
var x,i,m,k: integer; s,s1: string[15]; a: double;
begin k:=part4[Npart4]; ListBox1.ItemIndex:=k;
  { TrackBar1.position:=mastab[k]; }
  m:=mastab[k]; TrackBar1.position:=m;
  a:=Mastab2[k]/64;
  if m<>0 then for i:=1 to m do a:=a*sqrt(2);
  with Canvas do
  for m:=1 to 12 do
  begin Pen.Width:=6;
    if m>5 then Pen.color:=TColor(ten2[m]*color6[k]) else
    Pen.color:=TColor(ten1[m]*($111111-COLOR6[k])+color6[k]*15);
    rectangle(175,126-m*10,200,130-m*10);
    a:=a*sqrt(2); if a>9999 then
    begin str(a:11,s); s1:=s[2]+s[3]+s[4]+'e';
     if s[10]<>'0' then s1:=s1+s[10]; s1:=s1+s[11] end
     else if a<10 then str(a:5:3,s1) else str(a:5:0,s1);
    Pen.color:=clblack; Pen.Width:=1; x:=25;
    if m mod 2 = 1 then
    begin x:=0; mas1.Lines [7-(m+1) div 2]:=s1 end
    else if m<12 then mas2.Lines [6-m div 2]:=s1;
    moveto(160+x,122-m*10); if m<12 then lineto(190+x,122-m*10);
  end; mas1.show; mas2.show;
  ChangeRis(Sender, Npart4);
end;

begin
  part4[1]:=0; part4[2]:=0;
  for Npart4:=0 to 7 do mastab[Npart4]:=6;
  mastab2[0]:=1.E18;
  mastab2[1]:=5;     {TE}
  mastab2[2]:=2E4;   {B}
  mastab2[3]:=2e6;   {Vr}
  mastab2[4]:=2e6;   {Uz}
  mastab2[5]:=2e4;   {J}
  mastab2[6]:=1;    {rad}
  mastab2[7]:=1;
  Npart4:=1;
end.
