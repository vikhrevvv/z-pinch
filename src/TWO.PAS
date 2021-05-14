unit Two;
interface
uses
  SysUtils, WinTypes, Classes, TwoGLOB,
  Controls, Forms, Menus, Dialogs,
  StdCtrls, Unit2, ExtCtrls, Grids;
type
  TForm1 = class(TForm)
  MainMenu1: TMainMenu;
  start1: TMenuItem;
  Finish1: TMenuItem;
  Files1: TMenuItem;
  About1: TMenuItem;
  Ne1: TMenuItem;
  MagField1: TMenuItem;
  Temperature1: TMenuItem;
  Rvelosity1: TMenuItem;
  Zvelosity1: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    RadiationRAD1: TMenuItem;
    Ltime: TLabel;
  procedure Progr(Sender: Tobject);
  procedure Stop(Sender: TObject);
  procedure Label1Click(Sender: TObject);
  procedure Label4Click(Sender: TObject);
  procedure start1Click(Sender: TObject);
  procedure Start3Click(Sender: TObject);
  procedure About1Click(Sender: TObject);
  procedure RvelocityRV1Click(Sender: TObject);
  procedure ZvelocityZV1Click(Sender: TObject);
  procedure TemperatureT1Click(Sender: TObject);
  procedure Ne1Click(Sender: TObject);
  procedure MagField1Click(Sender: TObject);
    procedure ZverClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure RadiationRAD1Click(Sender: TObject);
    procedure LtimeClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
end;
  procedure NTfig;
  procedure PAINTVVV;
var Form1: TForm1;
  NS,NSprint: integer;
  Mastab2: array [0..7] of double;
  NN: array [1..701,1..701] of integer;
  radsum: mm;
  zvert: boolean = false;
implementation
{$R *.DFM}
uses Graphics,  About,  balanc,
  WinEval, WinProcs, Init, Velocity, Time1;
var X: mm;
  XM: double;
  color2: integer;
  cod: byte;

procedure grayfon;
begin with form1 do with Canvas do
  begin  Pen.Width:=height; Pen.Color:=clBtnFace;
    Moveto(0,height div 2); Lineto(width,height div 2);
  end;
  if cod>0 then NTfig;
end;

procedure Tform1.Stop(Sender: TObject);
begin
  finish1.Enabled:=false;
  start1.Enabled:=true;
  Files1.Enabled:=true;
  form3.Enabled:=true;
  NTfig;
end;

procedure Tform1.Progr(Sender: TObject);
var Msg: TMsg;
procedure pp(NN: integer);
begin
  with Canvas do
  begin Pen.Width:=2;
   if NS mod 2 = 0 then Pen.Color:=clGray
                   else Pen.Color:=clRed;
   rectangle(4,NN,14,NN+4);
  end;
  while PeekMessage(Msg,0,0,0,pm_Remove) do
  begin TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
  if unit2.newris then
  begin  NTfig; unit2.newris:=false end;
end;
procedure imagerad;
var I,J,J1: integer;
begin
  for I:=1 to IM do
  for J1:=1 to JM do
  for J:=J1 to J1{M} do radsum[i,j1]:={radsum[i,J1]}+(n[i,j]*n[I,J]/5e35)
  *{dt*}sqrt(TE[I,J]){/JM*(sqrt((J+1)*(J+1)-J1*J1)-sqrt(J*J-J1*J1))};
end;
begin
  Finish1.enabled:=true;
  form3.Enabled:=false;
  Start1.Enabled:=false;
  Files1.Enabled:=false;
  nsbrosdt:=0;
  repeat
    DENSIT; PP(10);
    MFIELD; PP(20);
      PP(30);
    RSPEED; PP(40);
    ZSPEED;
    TEMPS; PP(50);
    if(use_corrector)then
      CorrectMagEnergy;
    STEP;   pp(60);
    TIMER;  pp(70);
    if time>timesave then
    begin       time1.savetime;
    timesave:=timesave+1e-9 end;
    if time>timesavebal then
    begin       Timebalance;
    timesavebal:=timesavebal+2e-8 end;
    if NS mod NSprint = 0 then
    begin NTfig; ptime; imagerad end;
    NS:=NS+1;
    //if TOK<TOKmax/5 then Start1.Enabled:=true;
  until Start1.Enabled;
end;

procedure PAINTVVV;
var Msg: TMsg;
  M,I,J,I1,J1,I2,J2,II,JJ,II1,Istart,
  DI,DJ,JDJ,IMAX,JMAX,XXX,YYY,DA,DX,Y,
  X1,X2,X3,X4,Y1,Y2,IMM,JMM,setka: integer;
  A1,A2: array [0..1002] of word;
  ageo: array [0..1002] of integer;
  SC: double;
  nn1, nn2, nn3: byte;
  mm: longint;
  S1,S2,S3,S4,S5,S6,s7,s8: string [30];
  YX: array [1..30] of word;

BEGIN
  while PeekMessage(Msg,0,0,0,pm_Remove) do
  begin TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
          zvert:=false;
  nn1:=cod and 1; nn2:=cod and 2; nn3:=0;
  if zvert then begin nn3:=nn1; nn1:=nn2; nn2:=0 end;
  YX[1]:=64; for m:=1 to 30 do YX[M+1]:=Round(YX[M]*1.41);
  IMM:=JM; JMM:=IM;

    if zvert then
  for I:=1 to IM+1 do  begin IMM:=IM; JMM:=JM;
  for J:=1 to JM+1 do NN[i,j]:=Round(64.0*abs(X[I,J]));
  end else
  for I:=1 to IM+1 do
  for J:=1 to JM+1 do NN[j,i]:=Round(64.0*abs(X[I,J]));
  XXX:=20; YYY:=30;
  IMAX:=Form1.Height-100; JMAX:=Form1.Width-40;
  if zvert then jmax:=jmax div 2 else  imax:=imax div 2;
  DI:=IMAX div IMM; if DI<1 then DI:=1;
  DJ:=JMAX div JMM; if DJ<1 then DJ:=1;
  if(DI>DJ)then
    DI:=DJ
  else
    DJ:=DI;
  IMAX:=IMM*DI; JMAX:=JMM*DJ; YYY:=YYY+IMAX;
  with Form1 do
  begin
    if zvert then
    begin Button2.Left:=jmax*2-70; {zver.left:=Jmax+10;
      zver.top:=0;} XXX:=XXX+JMAX end else
    begin Button2.Top:=Form1.Height-80;
      {zver.top:=Imax+18; zver.left:=form1.width-32;  }
    end;
  end;
  for J:=2 to JMM+2 do
  begin DX:=NN[1,J]-NN[1,J-1];
    A1[(J-2)*DJ+1]:=NN[1,J-1];
    for J1:=1 to DJ do
      begin A1[(J-2)*DJ+J1+1]:=NN[1,J-1]+DX*J1 div DJ;
     if zvert then Ageo[(J-2)*DJ+J1+1]:=geo[1,J-1]
     else Ageo[(J-2)*DJ+J1+1]:=geo[J-1,1]  end;
  end;
  with Form1 do with Canvas do
  for I:=1 to IMM+1 do
  begin Pen.Width:=1;
    for J:=2 to JMM+2 do
    begin DX:=NN[I,J]-NN[I,J-1];
      JDJ:=(J-2)*DJ+1;
      A2[JDJ]:=NN[I,J-1];
      for J1:=1 to DJ do
      begin A2[JDJ+J1]:=NN[I,J-1]+DX*J1 div DJ;
        if zvert then Ageo[JDJ+J1]:=geo[I,J-1]
                 else Ageo[JDJ+J1]:=geo[J-1,I]
      end;
    end;
    for I1:=1 to DI do
    begin II:=I1+(I-2)*DI; MM:=0; JJ:=1;
      Y1:=YYY+II; Y2:=YYY-II-DI+1;
      for J:= 1 to JMAX+1 do
      begin DA:=A2[J]-A1[J];
        if (Ageo[j]<0) and (Ageo[j]>-4) then m:=Ageo[j] else
        begin Y:=A1[J]+DA*I1 div DI;
           M:=0; SC:=ABS(Y)/ABS(XM);
           repeat M:=M+1 until (YX[M]>SC) or (M>70);
        end;
        if (MM<>M) or (J=Jmax+1) then
        begin X1:=XXX+JJ; X2:=XXX+J;
          X3:=XXX-JJ+1;   X4:=XXX-J+1;
          if MM>12 then Pen.color:=Tcolor(0) else
          if MM>5 then Pen.color:=TColor(ten2[MM]*color2) else
          Pen.color:=TColor(ten1[MM]*($111111-Color2)+color2*15);
          if MM=-1 then Pen.Color:=Tcolor($F0F0A0);
          if MM=-2 then Pen.Color:=Tcolor($80F0);
          if MM=-3 then Pen.Color:=Tcolor($30A0D0);
          if nn1<>0 then begin MoveTo(X1,Y2); LineTo(X2,Y2) end;
          if nn3<>0 then begin MoveTo(X3,Y2); LineTo(X4,Y2) end;
          if nn2<>0 then begin MoveTo(X1,Y1); LineTo(X2,Y1) end;
          MM:=M; JJ:=J;
        end;
      end {J}
    end; {I1}
    for J:=1 to JMAX do A1[J]:=A2[J];
  end;
  str(time*1000000:4:2,S1);
  str(tok/1000:5:0,S2);
//  str(neutrons:2:0,S3);
  s3:=floattostrf(neutrons,ffexponent,2,2);
  str(Lkamer*1e9:6:2,S4);
  str(nmax:10,S5);
  str(SN:10,S6);
  s7:='';
  if(ispinched)then
    str(pinchtime*1000000:4:2,s7);
  s8:='';
  if(ispinched)then
    str(pinchtok/1000:5:0,s8);
  if(ispinched)then
    form1.Ltime.caption:=' t='+S1+' mks,   I='+s2+' kA,'+
  '  Y='+ S3+
  '  L='+S4+' cm   nmax='+S5{+'   nall='+S6}+'   t_oc='+s7+' mks   I_oc='+s8+' kA'
  else
  form1.Ltime.caption:=' t='+S1+' mks,   I='+s2+' kA,'+
  '  Y='+ S3+
  '  L='+S4+' cm   nmax='+S5{+'   nall='+S6};

 setka:=round(IM/2/ZP);
 if time<=0 then
  with Form1 do with Canvas do
  begin Pen.Width:=1; Pen.Color:=clgray;
    for J:=0 to JM do
    if (j div setka)*setka = j then
    begin if Pen.Color=clgray then Pen.Color:=clblack else Pen.Color:=clgray;
      MoveTo(XXX,YYY+j*DJ); LineTo(XXX+IM*DI,YYY+j*DJ);
      MoveTo(XXX,YYY-j*DJ); LineTo(XXX+IM*DI,YYY-j*DJ) end;
    Pen.Color:=clgray;
    for I:=0 to IM+1 do
    if (I div setka)*setka = i then
    begin if Pen.Color=clgray then Pen.Color:=clblack else Pen.Color:=clgray;
      MoveTo(XXX+i*DI,YYY-jm*DI); LineTo(XXX+i*DI,YYY+jm*DI) end;
  end;

  with Form1 do with Canvas do
  begin Pen.Width:=1; Pen.Color:=clgray;
  {  if zvert then
    begin Moveto(zver.left+11,5); Lineto(zver.left+11,height) end else
    begin Moveto(10,zver.top+11); Lineto(width,zver.top+11) end;    }
  end;
end;
{***********************}
procedure NTfig;
var k,i,j,m: integer;
m2: double;
begin cod:=1;
  for k:=1 to 2 do
  begin
    case part4[k] of
   0: X:=N;
   1: X:=TE;
   2: X:=H;
   3: X:=V;
   4: X:=U;
   5: begin for I:=1 to IM do
        for J:=1 to JM do X[I,J]:=sqrt(sqr((H[I,J+1]*R[J+1]-H[I,J]*R[J])/
        (sqr(R[J+1])-sqr(R[J]))/2)+sqr((H[I+1,J]-H[I,J])/(Z[I+1]-Z[I])));
      end;
   6: X:=radsum;
    end;
    M2:=mastab2[Part4[k]];
    for I:=1 to Im+1 do
    for J:=1 to Jm+1 do X[I,J]:=X[I,J]/m2;
    XM:=1; m:=mastab[part4[k]];
    if m>10 then for i:=10 to m do XM:=XM*sqrt(2);
    if m<10 then for i:=m to 10 do XM:=XM/sqrt(2);
    color2:=color6[part4[k]];
    if part4[1]=part4[2] then
    begin cod:=3; PaintVVV; exit end;
    PaintVVV;
    cod:=2;
  end;
  inTime.show;
 
end;

procedure TForm1.Label1Click(Sender: TObject);
begin unit2.Npart4:=1; SettingRis.show;
  SettingRis.FormShow(Sender) end;

procedure TForm1.Label4Click(Sender: TObject);
begin unit2.Npart4:=2; SettingRis.show;
  SettingRis.FormShow(Sender) end;

procedure TForm1.start1Click(Sender: TObject);
begin form3.show end;

procedure TForm1.Start3Click(Sender: TObject);
begin form3.show; Init.start; Progr(Sender) end;

procedure TForm1.About1Click(Sender: TObject);
begin AboutBox.Show end;

procedure TOFile(SSS: string);
var i,I1,j2,j: integer;
FIL: TextFile;
nn: single;
begin AssignFile(FIL,SSS+'.dat'); Rewrite(fil);
  for i1:= 1 to IM do
  begin I:=abs(I1)+1;
    for J:= -JM to JM do
    begin J2:=abs(j)+1;
      if geo[I,J2]<0 then NN:=geo[i,j]
                     else NN:=X[I,J2];
      write(FIL,NN:12);
    end;
    writeln(FIL);
  end;
  CloseFile(FIL);
end;

procedure TForm1.RvelocityRV1Click(Sender: TObject);
begin X:=V; TOFile('RV') end;

procedure TForm1.ZvelocityZV1Click(Sender: TObject);
begin X:=U; TOFile('ZV') end;

procedure TForm1.TemperatureT1Click(Sender: TObject);
begin X:=TE; TOFile('TE') end;

procedure TForm1.Ne1Click(Sender: TObject);
begin  X:=N; TOFile('NE') end;

procedure TForm1.MagField1Click(Sender: TObject);
begin X:=H; TOFile('MF') end;

procedure TForm1.RadiationRAD1Click(Sender: TObject);
begin X:=radsum; TOFile('Rad') end;

procedure TForm1.ZverClick(Sender: TObject);
begin zvert := not zvert;
  if zvert then Button2.Top:=0 else Button2.Left:=25;
  grayfon;
end;

{procedure TForm1.zgorClick(Sender: TObject);
begin zvert:=false; Button2.Left:=25; grayfon end;
}
procedure TForm1.FormResize(Sender: TObject);
begin
  grayfon;
end;

procedure TForm1.LtimeClick(Sender: TObject);
begin
  time1.ptime;
end;
// begin cod:=0;
procedure TForm1.FormPaint(Sender: TObject);
procedure imagerad;
var I,J,J1: integer;
begin
  for I:=1 to IM do
  for J1:=1 to JM do
  for J:=J1 to J1{M} do radsum[i,j1]:={radsum[i,J1]}+(n[i,j]*n[I,J]/5e35)
  *{dt*}sqrt(TE[I,J]){/JM*(sqrt((J+1)*(J+1)-J1*J1)-sqrt(J*J-J1*J1))};
end;
begin
if(start1.Enabled=true or finish1.Enabled=true)then begin
NTfig; imagerad;
end;
end;



end.
