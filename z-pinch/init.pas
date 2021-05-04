 unit init;
interface
uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, Grids,
  StdCtrls, DBCtrls, ComCtrls, WinTypes;
type
  TForm3 = class(TForm)
    StringGrid1: TStringGrid;
    Edit1:   TEdit;
    Start:   TButton;
    Button1: TButton;                   
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    Button4: TButton;
    SaveDialog1: TSaveDialog;
    fname_label: TLabel;
    CheckBox1: TCheckBox;
    Check_corrector: TCheckBox;
    Check_U_ideal: TCheckBox;
    Check_k_dt: TCheckBox;
    RadioButtonMaxwell: TRadioButton;
    RadioButtonPower: TRadioButton;
    Label1: TLabel;
    RadioButtonPower2: TRadioButton;
    check_anomal: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure CCClick(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Check_correctorClick(Sender: TObject);
  end;
procedure START;
var  Form3: TForm3;
implementation
uses twoglob, Two, Time1, SP, balanc;
{$R *.DFM}
var Pd2,Rhole,r12,r3,dranod, drz, DRIZOL, dzkathode, Lini, Uini: double;
    edit1_changed:boolean;

procedure TForm3.FormCreate(Sender: TObject);
var fin:textfile;
    i:integer;
begin
  assignfile(fin,'koef_IIII_dd.txt');
  reset(fin);
  read(fin,koef_i4_dd);
  closefile(fin);
  assignfile(fin,'koef_IIII_dt.txt');
  reset(fin);
  read(fin,koef_i4_dt);
  closefile(fin);

  assignfile(fin,'sigv_max3_dd.txt');
  reset(fin);

  for i:=0 to 30 do
    read(fin,sigv_dd_T[i],sigv_dd[i]);

  closefile(fin);

  assignfile(fin,'sigv_max3_dt.txt');
  reset(fin);

  for i:=0 to 30 do
    read(fin,sigv_dt_T[i],sigv_dt[i]);

  closefile(fin);

  assignfile(fin,'sigv_max2_dd.txt');
  reset(fin);

  for i:=0 to 30 do
    read(fin,sigv2_dd_T[i],sigv2_dd[i]);

  closefile(fin);

  assignfile(fin,'sigv_max2_dt.txt');
  reset(fin);

  for i:=0 to 30 do
    read(fin,sigv2_dt_T[i],sigv2_dt[i]);

  closefile(fin);


  edit1_changed:=false;
  with StringGrid1 do begin
  cells[0,0]:='L katod [mm]';
  cells[0,1]:='D katod [mm]';
  cells[0,2]:='L anod  [mm]';
  cells[0,3]:='D anod  [mm]';
  cells[0,4]:='D hole  [mm]';
  cells[0,5]:='R12     [mm]';
  cells[0,6]:='R3      [mm]';
  cells[0,7]:='D izole [mm]';
  cells[0,8]:='dr izol [mm]';
  cells[0,9]:='L izol  [mm]';
  cells[0,10]:='Z atoms ';
  cells[0,11]:='Rkontur [OM]]';
  cells[0,12]:='P [torr]';
  cells[0,13]:='L [nH] ';
  cells[0,14]:='C [mmF]';
  cells[0,15]:='Uo [kV]';
  cells[0,16]:='dr,dz   [mm]';
  cells[0,17]:='setka';
  cells[0,18]:='Nprint (1-100)';
  cols[1].LoadFromFile('zpinch.ini');
  end;


  CCClick(Sender);
//  NTfig;
end;

procedure TForm3.Edit1Change(Sender: TObject);
begin
  if(edit1_changed)then
  if(length(fname_label.caption)>0)and(fname_label.caption[length(fname_label.caption)]<>'*')then
    fname_label.caption:=fname_label.caption+'*';
  if(edit1_changed=false)then
    edit1_changed:=true;
  with StringGrid1 do
  cells[1,row]:=edit1.text;
  CCClick(Sender); //NTfig;
end;

procedure TForm3.StringGrid1Click(Sender: TObject);
begin
  edit1_changed:=false;
  with StringGrid1 do
  begin edit1.visible:=false;
    edit1.text:=cells[1,row];
    edit1.left:=left+DefaultColWidth;
    Edit1.top:=trunc((DefaultRowHeight+1.25)*row)+top+2;
    edit1.visible:=true;
    edit1.SetFocus;
  end;
end;

var ro: double;
 FIL: TextFile;

procedure START;
var I,J,JRhole,CentrK,CentrA,Iz104,JDRizol,
Idranod,I1,Jgas,JRplasma,IR12,JR12,JCentrK,JCentrA,I1Centr3,begK,begA: integer;
{dzk,} dza, dzhole: real;
begin  IK:=0; TIME:=0;  EPS:=0.2; E_to_kam:=0;Eloss:=0;Esumold:=0;
  Ukamera:=0;  Ukond:=Uini; Lind:=Lini;Lkontur:=Lind; Lkamer:=0;
  KB:=1.6e-12; MD:=1.67e-24*Zatom; //!!!
//  n1:=2*3.56e16*Pd2;     //!!!!!!!!!!!!!!!!!!!!!!!!
  n1:=2*3.2e16*Pd2;        //!!!!!!!!!!!!!!!!!!!!!!!!
 { n1:=ro/MD;  }  tokmax:=0;

  use_corrector:=form3.check_corrector.Checked;
  use_Kdt:=form3.Check_k_dt.Checked;
  use_U_cheat:=form3.Check_U_ideal.Checked;
  use_anomal:=form3.check_anomal.Checked;

  an1:=n1*0.005;
  TN:=0.1; mastab2[0]:=n1*2;
  IM:=round(ZP/drz);
  JM:=round(RP/drz);
  IZizol:=round(Zizol*IM/ZP);
  IZel  :=round(Zel*IM/ZP);
  JRel  :=round(Rel*JM/RP);
  JRizol:=round(Rizol*JM/RP);
  JDRizol:=round(DRizol*JM/RP);
  JRhole:=round(Rhole*JM/RP);
  Idranod:=round(dranod*IM/ZP);
  IR12:=round(r12*IM/ZP);
  JR12:=round(r12*JM/RP);
  Ir3:=round(r3*Im/ZP);

  if(rel<rizol)then begin rizol:=rel; dzkathode:=0; dza:=0 end
  else begin
     if (rizol<=rel-r12) then dza:=0
     else
     if(r12<=rel)then
        dza:=r12-sqrt(r12*r12-sqr(rizol-(rel-r12)))
     else
        dza:=r12-sqrt(r12*r12-sqr(rizol));

     dzkathode:=rp-sqrt(rp*rp-rizol*rizol)end;
     IZIZOL:=IZIZOL+round(dzkathode*JM/RP);
     CentrK:=round(({dzkathode}-dza)*JM/RP)+IZizol+IR12;
     if(r12<=rel)then
     begin
        JCentrK:=JRel-IR12;
        JCentrA:=JRel-IR12;
     end
     else
     begin
        JCentrK:=0;
        JCentrA:=0;
     end;
     if((rhole<=rel-r12))then
     begin
        dzhole:=0;
        I1Centr3:=ir12;
     end
     else
     if(r12<=rel)then
     begin
        dzhole:=R12-sqrt(sqr(R12)-sqr(rhole-(rel-r12)+r3));
        I1Centr3:=round(sqrt((sqr(r12)-sqr(rhole+r3-(rel-r12))))*Im/ZP);
     end
     else
     begin
         dzhole:=R12-sqrt(sqr(R12)-sqr(rhole+r3));
        I1Centr3:=round(sqrt((sqr(r12)-sqr(rhole+r3)))*Im/ZP);
     end;
     CentrA:=CentrK+round((Zel-2*R12+dzhole+dza)*IM/ZP);
     begA:=CentrA;
     if(r12<r3)then
        begA:=CentrK+round((Zel-2*R3+dzhole+dza)*IM/ZP);
     if(r12>rel)then
     begin
        begK:=CentrK-round(sqrt(sqr(r12)-sqr(rel))*IM/ZP);
        begA:=CentrA+round(sqrt(sqr(r12)-sqr(rel))*IM/ZP);
     end;

  for J:=1 to JM+1 do R[J]:=RP/(JM-1)*(J-1);
  for I:=0 to IM do Z[I+1]:=ZP/(IM-1)*I;

  for I:=0 to IM+1 do
  for J:=0 to JM+1 do
  begin WVF[I,J]:=0; WUF[I,J]:=0;
    mv2[i,j]:=0; mv2old[i,j]:=0;
    V[I,J]:=0; U[I,J]:=0; VF[I,J]:=0; UF[I,J]:=0;
    TE[I,J]:=TN; H[I,J]:=0; radsum[I,J]:=0; NF[i,j]:=0; HF[i,j]:=0;
    N[I,J]:=AN1;w[i,j]:=0;
  end;


  for I:=0 to IM+1 do
  for J:=0 to JM+1 do
  begin WVF[I,J]:=0; WUF[I,J]:=0;
    mv2[i,j]:=0; mv2old[i,j]:=0;
    V[I,J]:=0; U[I,J]:=0; VF[I,J]:=0; UF[I,J]:=0;
    TE[I,J]:=TN; H[I,J]:=0; radsum[I,J]:=0; geo[I,J]:=1000;
    N[I,J]:=geo[I,J]*n1/1000;w[i,j]:=0;
    if I>JM then I1:=0 else I1:=JM-I;
    if I>IM-JM then I1:=IM-JM-I;
    if I1*I1+J*J>JM*JM then geo[I,J]:=-2; {katod}
    if (r12<=rel)and (j<jRel)and(((I<=CentrK) and (sqr(J-JCentrK)<JR12*JR12-sqr(CentrK-I))
         and ((sqr(J-JCentrK)>sqr(JR12-IR3)-sqr(CentrK-I))or((jr12<ir3){and()}))and(J>=JCentrK))
         or((J<=JCentrK)and(I>CentrK-IR12)and(((I<=begA)and(I<CentrK-IR12+IR3))or(I<IZizol+2)))) then geo[I,J]:=-3;
    if (r12>rel)and (j<jRel)and(((I<CentrK) and (sqr(J-JCentrK)<JR12*JR12-sqr(CentrK-I))
         and (sqr(J-JCentrK)>sqr(JR12-IR3)-sqr(CentrK-I))and(J>=JCentrK))
         or((J<=JCentrK)and(I>CentrK-IR12)and((I<CentrK-IR12+IR3)or(I<IZizol+2)))) then geo[I,J]:=-3;
    if ((r12<=rel)and(I>=CentrK) and (I<CentrA) and (j<jRel) and (J>JRel-IR3))
        or ((r12>rel)and(I>=begK) and (I<begA) and (j<jRel) and (J>JRel-IR3)) then geo[I,J]:=-3;
    I1:=I-CentrA;
    if ((I1>=0)or(I>=begA))and (j<jRel) and (((sqr(J-JCentrA)<JR12*JR12-I1*I1)
    and(J>=JCentrA))or((J<=JCentrA)and(I1<=IR12)))
    then begin
      if I1>I1Centr3-2*Ir3 then
      begin if ((j>jrhole+Ir3)and(I1>I1Centr3-Ir3)) or
      (sqr(J-jrhole-ir3)+sqr(I1-I1Centr3+ir3)<Ir3*Ir3) then Geo[i,j]:=-3
      end;
      if (sqr(J-JCentrA)>sqr(JR12-IR3)-I1*I1)and(J>=JCentrA)and(J>=jrhole+Ir3) then geo[I,J]:=-3;
    end;
      if I1>I1Centr3-2*Ir3 then
      begin if (sqr(J-jrhole-ir3)+sqr(I1-I1Centr3+ir3)<Ir3*Ir3) then Geo[i,j]:=-3
      end;
   if (J<JRizol) and (I<=IZizol+round(dzkathode*JM/RP)) then
   if J>JRizol-JDRizol then geo[I,J]:=-1 else geo[I,J]:=-3;
   if ((J<JRizol)or((sqr(J-JCentrK)<JR12*JR12-sqr(CentrK-I)))and(j<jRel))
   and (I<=IZizol+round(dzkathode*JM/RP)+2)and (I>IZizol+round(dzkathode*JM/RP)) then
   if J>JRizol-JDRizol then geo[I,J]:=-3 else geo[I,J]:=-3;
  end;

  AssignFile(FIL,'ne.in'); Rewrite(fil);
  for I:= 1 to IM+1 do
  begin
    for J:= 1 to JM+1 do
    begin if geo[i,j]<0 then write(fil,geo[i,j]:5)
           else write(fil,round(N[i,j]/n1*1000):5);
    end;
    writeln(FIL);
  end; CloseFile(FIL);

  AssignFile(FIL,'ne.ini'); {$I-} Reset(fil); {$I+}
  if IOResult=0 then
  begin MessageDlg('density took from ne.ini',
    mtInformation,[mbOk],1);
    for I:=1 to IM+1 do
    begin
      for J:= 1 to JM+1 do
      begin read(FIL,geo[i,j]);
        if geo[i,j]<0 then
        begin
          if geo[i,j]=-1 then n[i,j]:=an1 else n[i,j]:=n1
        end
        else n[i,j]:=geo[i,j]*n1/1000;
      end;
      readln(FIL);
    end;
    CloseFile(FIL);
  end;
  AssignFile(FIL,'CURRENT.DAT'); {$I-} Reset(fil); {$I+}
  if IOResult=0 then
  begin current:=true; KM:=0;
  MessageDlg('current took from current.dat',
    mtInformation,[mbOk],1);
    repeat KM:=KM+1;
      readln(FIL,timetok1[KM],tok1[KM]);
    until timetok1[KM]<0;
    CloseFile(FIL); KM:=KM-1;
  end else current:=false;
end;

procedure TForm3.CCClick(Sender: TObject);
var X,DV: double;
k,i,j,code: integer;
s,s2: string [20];
function X2: double;
begin if X>0.1 then X2:=X else X2:=0.1
end;
begin
  form1.start1.Enabled:=false;
  for k:=0 to 18 do
  with StringGrid1 do
  begin S:=cells[1,k]; val(S, X, Code);
    case k of
    0: ZP:=X2/10;
    1: RP:=X2/20;
    2: Zel:=X/10;
    3: Rel:=X/20;
    4: Rhole:=X/20;
    5: r12:=X/10;
    6: R3:=X/10;
    7: Rizol:=X/20;
    8: DRizol:=X/10;
    9: Zizol:=X/10;
    10: Zatom:=X;
    11: Rkontur1:=X;
    13: Lini:= X*1e-9;
    14: Ckond:=X*1e-6;
    15: Uini:= X*1000;
    16: begin drz:=X/10;  if drz<0.01 then drz:=0.01;
        if drz>10 then drz:=10; IM:=round(ZP/drz);
        if IM>640 then begin IM:=640; drz:=zp/IM; Str(drz:5:3,S); cells[1,16]:=S end;
        Str(IM:3,S); JM:=round(RP/drz); Str(JM:3,S2); cells[1,17]:=S2+'x'+S end;
    12: begin PD2:=X; ro:=Pd2*3.56e16*3.34e-24*Zatom end;
    18: NSprint:=round(X);
       end;
    cols[1].SaveToFile('last.ini');
  end;
  if(zp<10*drz)then zp:=10*drz;
  if(rp<10*drz)then rp:=10*drz;
  if(zel<10*drz)then zel:=10*drz;
  if(rel<10*drz)then rel:=10*drz;
  ROR:=0; Two.NS:=0; DT:=1e-9;ispinched:=false;
  Ukamera:=0; Ekontur:=0; TOK:=0; Lkam:=0;
  neutrons:=0; timesave:=0;  timesavebal:=0;
  NTenergy:=0;
  WallKin:=0;
  WallkT:=0;
  for J:=1 to JM do
  for I:=1 to IM do
  if (geo[I,J]>0) then
  begin DV:=pi*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I]);
     nTenergy:=nTenergy+DV*N[I,J]*TE[I,J]*3/2*KB*1e-7;
  end;
  EINIT:=nTEnergy+Ckond*Uini*Uini/2;
//  Init.Start;
//  NTfig;

end;

procedure TForm3.StartClick(Sender: TObject);
begin
  form3.Enabled:=false;
  CCClick(Sender);
  balance.Series1.Clear;
  balance.Series2.Clear;
  balance.Series3.Clear;
  balance.Series4.Clear;
  balance.Series5.Clear;
  balance.Series6.Clear;
  balance.Series8.Clear;
  intime.Series2.Clear;
  intime.Series1.Clear;
  intime.Series4.Clear;
  intime.nmax_line.Clear;
  intime.dY_line.Clear;
  intime.LineSeries1.Clear;
  init.START;
  NTfig;
  Form1.Progr(Sender);
end;

var imax,jmax, XXX, yyy: integer;

procedure imaxjmax;
var DI,dj,  imm, jmm: integer;
begin IMM:=JM; JMM:=IM;
  if zvert then begin IMM:=IM; JMM:=JM end;
  XXX:=20; YYY:=30;
  IMAX:=Form1.Height-100; JMAX:=Form1.Width-40;
  if zvert then jmax:=jmax div 2 else  imax:=imax div 2;
  DI:=IMAX div IMM; if DI<1 then DI:=1;
  DJ:=JMAX div JMM; if DJ<1 then DJ:=1;
  IMAX:=IMM*DI; JMAX:=JMM*DJ;
  YYY:=YYY+IMAX; if zvert then XXX:=XXX+JMAX;
end;

procedure TForm3.Button1Click(Sender: TObject);
 var i,ii,j,k: integer;
 dtRIS,timeRIS,TOK1,DS1: double;
s7,s8,s1,s2,s3,s9:string;
    Msg: TMsg;

procedure RIS;
var i:integer;
begin
  imaxjmax;
  with form1 do
  with Canvas do
  begin Pen.width:=1;
    Pen.Color:=Tcolor(clblack);
    if zvert then
    begin
      moveto(xxx+round(r[1]/Rp*Jmax),yyy-round(z[1]/Zp*Imax));
      for i:=2 to imsp do
      Lineto(xxx+round(r[i]/RP*Jmax),yyy-round(z[i]/ZP*Imax));
      moveto(xxx-round(r[1]/Rp*Jmax),yyy-round(z[1]/Zp*Imax));
      for i:=2 to imsp do
      Lineto(xxx-round(r[i]/RP*Jmax),yyy-round(z[i]/ZP*Imax));
    end else begin
      moveto(xxx+round(z[1]/Zp*Jmax),yyy-round(r[1]/Rp*Imax));
      for i:=2 to imsp do
      Lineto(xxx+round(z[i]/Zp*Jmax),yyy-round(r[i]/Rp*Imax));
      moveto(xxx+round(z[1]/Zp*Jmax),yyy+round(r[1]/Rp*Imax));
      for i:=2 to imsp do
      Lineto(xxx+round(z[i]/Zp*Jmax),yyy+round(r[i]/Rp*Imax));
   end;
  end;
end;

begin
  form3.Enabled:=false;
  CCClick(Sender);
  balance.Series1.Clear;
  balance.Series2.Clear;
  balance.Series3.Clear;
  balance.Series4.Clear;
  balance.Series5.Clear;
  balance.Series6.Clear;

  intime.Series2.Clear;
  intime.Series1.Clear;
  intime.Series4.Clear;
  intime.LineSeries1.Clear;
  drz:=zp/640;
  init.START;
  time:=1e-13;
  NTfig;

  Two.NS:=0;
  IK:=0;  EPS:=0.2;
  Ukamera:=0;
  intime.series2.clear;
  MD:=1.67e-24*Zatom;
//  n1:=2*3.56e16*Pd2;   //!!!!!!!!!!!!!!!!!!!!!
  n1:=2*3.2e16*Pd2;   //!!!!!!!!!!!!!!!!!!!!!
  constm:=2*pi*n1*MD;
  ds:=Zizol/0.5;
  DS1:=(dRizol)/2;
  if ds>ds1 then ds:=ds1;
  imsp:=round(Zizol/ds)+2;
  ds:=Zizol/(imsp-1);
  for i:=1 to imsp do
  begin vr[i]:=0; vz[i]:=0;
    z[i]:=ds*(i-1)+dzkathode;
    r[i]:=rizol+0.01*ds*(imsp-i);
    m[i]:=constm*r[i]*ds end;
  counter:=1; tok:=0;  TIME:=0;  Lind:=Lini; Ukond:=Uini;
  time:=0;  dtRIS:=1e-8; timeRIS:=1.37e-6;

  repeat dt:=5e-6*sqrt(Lind*Ckond);
    for i:=1 to imsp do
    begin vv:=sqrt(vz[i]*vz[i]+vr[i]*vr[i]);
     if vv*dt>0.02*ds then dt:=0.02*ds/vv
    end;
    SnowPl;
    TOK1:=TOK; dL:=dL*1.e-9;
    TOK:=(TOK*Lind+ukond*dt)/(Lind+dl);
    Lind:=Lind+dl;
    ukond:=ukond-tok*dt/ckond;
    time:=time+dt;
    If Time>timeRIS then begin RIS; TimeRIS:=TimeRIS+dtRIS end;

    if NS mod 100 = 0 then
    begin Ukamera:=ukond+Lini*(TOK1-TOK)/dt; time1.savetime end;
    if NS mod (NSprint*100)=0 then
    begin  time1.ptime; Inc(Counter);
      str(time*1000000:4:2,S1);
      str(tok/1000:5:0,S2);
      str((Lind-Lkontur)*1e9:6:2,S3);
      form1.Ltime.caption:=' t='+S1+' mks,  I='+s2+' kA,'+'  L='+S3+' cm';
    end;

    //if NS mod (NSprint*10)=0 then
      while PeekMessage(Msg,0,0,0,pm_Remove) do
      begin TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    NS:=NS+1;

  //  II:=0; For i:=1 to imsp do if r[i]<0.1 then II:=ii+1;


   until time>timeRIS+10*dtRIS;   //(counter>166) ; //or (ii>140) ;
 {  //if(ii>20)then
   begin
    ispinched:=true;
    pinchtime:=time;
    pinchtok:=TOK;
    neutrons:=0;
    if(abs(ZAtom-2)<1e-3)then
      neutrons:=koef_i4_dd*(pinchtok/1000)*(pinchtok/1000)*(pinchtok/1000)*(pinchtok/1000)
    else
    if(abs(ZAtom-2.5)<1e-3)then
      neutrons:=koef_i4_dt*(pinchtok/1000)*(pinchtok/1000)*(pinchtok/1000)*(pinchtok/1000);
    s7:='';
    str(pinchtime*1000000:4:2,s7);
    s8:='';
    str(pinchtok/1000:5:0,s8);
    s9:='';
//    str(neutrons:5:0,s9);
    s9:=floattostrf(neutrons,ffexponent,2,2);
    form1.Ltime.caption:='t_oc='+s7+' mks   I_oc='+s8+' kA    Y='+s9;
   end;
   RIS; }
    form3.Enabled:=true;
end;


procedure TForm3.Button2Click(Sender: TObject);
var s:string;
    i,l:integer;
begin
  opendialog1.FileName:='';
  if(opendialog1.Execute)then
  begin
    stringgrid1.cols[1].LoadFromFile(opendialog1.Files.Strings[0]);
    edit1.Hide;
    s:=opendialog1.Files.Strings[0];
    l:=0;
    for i:=1 to length(s) do
      if(s[i]='\')then
        l:=i;
    Delete(S,1,l);
    fname_label.Caption:=s;
    CCClick(Sender);
  end;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  form1.Start1.Enabled:=false;
  Init.Start;
  form1.Hide;
  form1.Show;
  NTfig;
end;

procedure TForm3.Button4Click(Sender: TObject);
var s:string;
    i,l:integer;
begin
  savedialog1.FileName:='';
  if(savedialog1.Execute)then
  begin
    stringgrid1.Cols[1].SaveToFile(savedialog1.FileName);
    s:=savedialog1.Files.Strings[0];
    l:=0;
    for i:=1 to length(s) do
      if(s[i]='\')then
        l:=i;
    Delete(S,1,l);
    fname_label.Caption:=s;
  end;
end;

procedure TForm3.Check_correctorClick(Sender: TObject);
begin
  if(check_corrector.Checked)then
  begin
    check_K_dt.Checked:=false;
  end;
end;

end.
