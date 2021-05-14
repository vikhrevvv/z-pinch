Unit WinEval;
Interface
{uses  SysUtils, WinTypes, Classes, TwoGLOB,
  Controls, Forms, Menus, Dialogs,
  StdCtrls, Unit2, ExtCtrls, Grids;
}Procedure DENSIT;
Procedure STEP;
Procedure TEMPS;
Procedure TIMER;
Procedure CorrectorToka;

Implementation
Uses TwoGlob,balanc,velocity;

Procedure CorrectorToka;
var TOKold,Uold,a,b,fa,fb,c,fc:double;
    i,j,k:integer;
begin
    TOKold:=TOK;
    Uold:=Ukamera;
  TOK:=TOKold+(Ukond-Ukamera-Rkontur1*TOKold)*DT/Lind;
  a:=TOK;


  for J:=1 to JM do
  begin
    for I:=1 to IM do
    begin
      if geo[i,J]=-1 then
         begin H[I,J]:=0.2*TOK/R[J] end;
    end;
  end;

    MFIELD;
    RSPEED;
    ZSPEED;
    {U1:=Ukamera; }Ukamera:=0;// Ukamdivtok:=0;
    for I:=1 to IZizol+1 do
    begin
      Ukamera:=Ukamera+1e-8*VVR[I,JRizol+1]*{H[I,JRizol+1] }
      0.2*TOK/Rizol*(Z[I+1]-Z[I]);
//      Ukamdivtok:=Ukamdivtok+1e-8*V[I,JRizol+1]*{H[I,JRizol+1] }
//      0.2/Rizol*(Z[I+1]-Z[I]);
    end;
//    Ukamera:=Uold*0.5+Ukamera*0.5;


  TOK:=TOKold+(Ukond-Ukamera-Rkontur1*TOKold)*DT/Lind;
  b:=TOK;
  fa:=TOK;
  if(abs(fa-a)<1e-8)then
    exit;

  for J:=1 to JM do
  begin
    for I:=1 to IM do
    begin
      if geo[i,J]=-1 then
         begin H[I,J]:=0.2*TOK/R[J] end;
    end;
  end;

    MFIELD;
    RSPEED;
    ZSPEED;
    {U1:=Ukamera; }Ukamera:=0;// Ukamdivtok:=0;
    for I:=1 to IZizol+1 do
    begin
      Ukamera:=Ukamera+1e-8*VVR[I,JRizol+1]*{H[I,JRizol+1] }
      0.2*TOK/Rizol*(Z[I+1]-Z[I]);
//      Ukamdivtok:=Ukamdivtok+1e-8*V[I,JRizol+1]*{H[I,JRizol+1] }
//      0.2/Rizol*(Z[I+1]-Z[I]);
    end;
//    Ukamera:=Uold*0.5+Ukamera*0.5;

  TOK:=TOKold+(Ukond-Ukamera-Rkontur1*TOKold)*DT/Lind;
  fb:=TOK;
  if(abs(fb-b)<1e-8)then
    exit;

  for k:=1 to 4 do
  begin
    c:=(a/(fa-a)-b/(fb-b))*(fa-a)*(fb-b)/(fb-b-fa+a);
    TOK:=c;
  for J:=1 to JM do
  begin
    for I:=1 to IM do
    begin
      if geo[i,J]=-1 then
         begin H[I,J]:=0.2*TOK/R[J] end;
    end;
  end;

    MFIELD;
    RSPEED;
    ZSPEED;
    {U1:=Ukamera; }Ukamera:=0;// Ukamdivtok:=0;
    for I:=1 to IZizol+1 do
    begin
      Ukamera:=Ukamera+1e-8*VVR[I,JRizol+1]*{H[I,JRizol+1] }
      0.2*TOK/Rizol*(Z[I+1]-Z[I]);
//      Ukamdivtok:=Ukamdivtok+1e-8*V[I,JRizol+1]*{H[I,JRizol+1] }
//      0.2/Rizol*(Z[I+1]-Z[I]);
    end;
//    Ukamera:=Uold*0.5+Ukamera*0.5;

  TOK:=TOKold+(Ukond-Ukamera-Rkontur1*TOKold)*DT/Lind;
  fc:=TOK;
  if(abs(fc-c)<1e-8)then
    break;
  if((fc-c)*(fa-a)<0)then
  begin
    b:=c;
    fb:=fc;
  end
  else
  begin
    a:=c;
    fa:=fc;
  end;
 end;
 TOK:=(c+fc)/2;
end;


Procedure DENSIT;
var I,J,J2,I2: integer;
  DR,DZ,RI,DIVRR,DIVZZ: double;
BEGIN
  for I:=0 to IM+1 do
    for J:=0 to JM+1 do
    begin
      VF[I,J]:=0;
      UF[I,J]:=0;
    end;
  for I:=1 to IM do
  begin DZ:=Z[I+1]-Z[I];
    for J:=1 to JM do
    begin DR:=(R[J+1]-R[J]);
      RI:=(R[J+1]+R[J])*0.5;
      if V[I,J+1]>0 then J2:=J else J2:=J+1;;
      VF[I,J+1]:=N[I,J2]*V[I,J+1]*R[J+1]/DR;
      DIVRR:=(VF[I,J+1]-VF[I,J])/RI;
//      if(geo[i,j+1]<0)then
//        DIVRR:=divrr-(VF[I,J+1])/RI;
//      if((geo[i,j]<0)or(j=1))then
//        DIVRR:=divrr+(VF[I,J])/RI;
      if U[I+1,J]>0 then I2:=I else I2:=I+1;;
      UF[I+1,J]:=N[I2,J]*U[I+1,J]/DZ;
      DIVZZ:=UF[I+1,J]-UF[I,J];
//      if(geo[i+1,j]<0)then
//        DIVZZ:=divzz-UF[I+1,J];
//      if(geo[i,j]<0)then
//        DIVZZ:=divzz+UF[I,J];
      NF[I,J]:=N[I,J]-(DIVRR+DIVZZ)*DT;
      IF NF[I,J]<AN1 then NF[I,J]:=AN1;
      WVF[I,J+1]:=1.5*KB*TE[I,J2]*VF[I,J+1];
      WUF[I+1,J]:=1.5*KB*TE[I2,J]*UF[I+1,J];
    end;
    UF[I+1,JM+1]:=UF[I+1,JM];
    WUF[I+1,JM+1]:=WUF[I+1,JM];
    VF[I+1,JM+1]:=0;  WVF[I+1,JM+1]:=0; V[I+1,JM+1]:=0;
  end;
  for J:=1 to JM+1 do begin U[IM+1,J]:=0; UF[IM+1,J]:=0; {UF[IM,J];  }
    WUF[IM+1,J]:=0; {WUF[IM,J]}  end;
END;

procedure TEMPS;
var I,J,j1,j2: integer;
  DR,DZ,RI,DIVRR,DIVZZ,PV,PU,W,DV,ri1,ri2,divvv,divuu,dhu,dhv: double;
BEGIN
  for I:=1 to IM do
    for J:=1 to JM{-1} do
    begin
      mv2old[i,j]:=mv2[i,j];
      mv2[i,j]:=NF[I,J]*MD*(sqr(U[I,J])+sqr(U[I+1,J])+sqr(V[I,J])+sqr(V[I,J+1]))/4;
    end;

  for I:=1 to IM do
  begin DZ:=Z[I+1]-Z[I];
    for J:=1 to JM{-1} do
    begin DR:=(R[J+1]-R[J]);
      divuu:=0.5*(UF[I,J]+UF[I+1,J])*(mv2old[i,j]/N[I,J]);
      if(i>1)then
      divuu:=divuu-0.5*(UF[I-1,J]+UF[I,J])*(mv2old[i-1,j]/N[I-1,J]);
//      divuu:=divuu*dt;
      RI:=(R[J+1]+R[J])*0.5;

      DIVvv:=0.5*(VF[I,J]+VF[I,J+1])*(mv2old[i,j]/N[I,J]);
      if(j>1)then
      DIVvv:=divvv-0.5*(VF[I,J-1]+VF[I,J])*(mv2old[i,j-1]/N[I,J-1]);
      if(R[j]>0)then
      divvv:=divvv/R[j];
      RI1:=(R[J]+R[J-1])*0.5;
      RI2:=(R[J]+R[J+1])*0.5;
      if (geo[i,j]<-1) or (geo[i-1,j]<-1) then DHu:=0 else
      DHu:=-(HF[I-1,J]+HF[I,J])/(8*pi)*(HF[I,J]-HF[I-1,J])/DZ*DT*0.5*(U[I,J]+U[I+1,J]);
      if (geo[i,j]<-1) or (geo[i,j-1]<-1) or (r[j]=0) then DHv:=0 else
      DHv:=-(HF[I,J-1]+HF[I,J])/R[J]*DT/DR/(8*pi)*(RI2*HF[I,J]-RI1*HF[I,J-1])*0.5*(v[I,J]+v[I+1,J]);


      DIVRR:=(WVF[I,J+1]-WVF[I,J])/RI;
      DIVZZ:=WUF[I+1,J]-WUF[I,J];
      PV:=2/3/RI*(R[J+1]*V[I,J+1]-R[J]*V[I,J])/DR;
      PU:=2/3*(U[I+1,J]-U[I,J])/DZ;
      W:=1.5*KB*TE[I,J]*N[I,J];
      W:=W-(DIVRR+DIVZZ{+divuu+divvv})*DT-W*(pv+pu)*DT;//+dhv+dhu-mv2[i,j]+mv2old[i,j];
      TE[I,J]:=W/(1.5*KB*NF[I,J]);
      if TE[I,J]<0.1 then TE[I,J]:=0.1;
      if TE[I,J]>sqr(NF[I,J]/n1)*1000 then TE[I,J]:=sqr(NF[I,J]/n1)*1000;
    end;
    TE[I,JM+1]:=TE[I,JM];
  end;
  for J:=1 to JM+1 do TE[IM+1,J]:=TE[IM,J];
END;

Procedure STEP;

var I,J: integer;
  DR,DZ,U1,H2energy,DV,Ukamdivtok,dtold,k_dt,j_tok,j_tok_max:double;
  needsbros:boolean;

Function SigmaV(T: real): real;
var T2,GV: real;
begin T2:=15e-16;
  if T<100 then T2:=T2*T*0.01;
  if T<20 then T2:=T2*T*0.05;
  if T<10 then T2:=T2*T*0.1;
  if T<5 then T2:=T2*T*0.2;
  if T<2 then
  begin T2:=T2*T*0.5;
    if T<1 then T2:=T2*T*T;
    if T<0.5 then T2:=T2*T*2;
    if T<0.3 then begin T2:=T2*T/0.3;
      if T<0.2 then T2:=T2*T*T*T*125 end;
  end ;
  SigmaV:=T2;
end;
 { IntenNeutr:=SigmaV(TE[I,J])*DT*SQR(NE[I,J])/4;  }
begin


//  CorrectorToka;
//  Ukond:=Ukond-TOK*DT/Ckond;


  for I:=2 to IM do begin
     for J:=1 to JM do U[I,J]:=UZ[I,J]; U[I,JM+1]:=U[I,JM];
     for J:=2 to JM-1 do V[I,J]:=VVR[I,J];
  end;
  for J:=1 to JM do begin V[IM+1,J]:=V[IM,J]; U[1,J]:=U[IM,J] end;

 needsbros:=false;
 dtold:=dt;
 k_dt:=1.0001;
 DT:=DT*k_dt;
  IF DT>1e-8 then DT:=1e-8;
  for J:=1 to JM do
  begin
    for I:=1 to IM do
    begin DR:=EPS*(R[J+1]-R[J]);
      IF ABS(V[I,J])*DT>DR then
          DT:=DR/ABS(V[I,J]);
      IF ABS(V[I,J])*DT>DR*0.5 then
        needsbros:=true;
      DZ:=EPS*(Z[I+1]-Z[I]);
      IF ABS(U[I,J])*DT>DZ then
          DT:=DZ/ABS(U[I,J]);
      IF ABS(U[I,J])*DT>DZ*0.5 then
        needsbros:=true;
      N[I,J]:=NF[I,J]; H[I,J]:=HF[I,J];
      if geo[i,J]=-1 then
         begin N[I,J]:=AN1; H[I,J]:=0.2*TOK/R[J] end;
      if (geo[I,J]<0) and (geo[I,J-1]<0) then
      begin DV:=pi*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I]);
 {     if TE[I,J]>0.1 then
      { WallkT:=WallkT+3/2*1e-7*(TE[I,J]-0.1)*DV*KB*N[I,J];
     TE[I,J]:=0.1;   }
      WallKin:=WallKin+DV*MD*1e-7*
     (sqr(U[I,J])*(N[I,J]+N[I-1,J])+sqr(V[I,J])*(N[I,J-1]+N[I,J]))/4;
      U[I,J]:=0; V[I,J]:=0 end;
      if (geo[I,J]>0) then begin
        neutrons :=neutrons+sqr(N[I,J])*SigmaV(TE[I,J]/1000)*
        pi/4*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I])*dt;
      end;
    end;
  end;
{  if((dt/dtold>1) and (nsbrosdt<26))then
  begin
    dt:=dtold;
    inc(nsbrosdt);
  end;   }
//  if((dt>=dtold)and(needsbros))then
//    dt:=dtold/(1+(k_dt-1)*2000);

//  if((dt/dtold<1/k_dt)and(nsbrosdt<>0))then
//  begin
//    dt:=dtold/k_dt;// nsbrosdt:=0;
//  end
//  else
 { if(dt/dtold<1/k_dt)then
    nsbrosdt:=0;    }

  begin U1:=Ukamera; Ukamera:=0; Ukamdivtok:=0;
    for I:=1 to IZizol+1 do
    begin
      Ukamera:=Ukamera+1e-8*V[I,JRizol+1]*{H[I,JRizol+1] }
      0.2*TOK/Rizol*(Z[I+1]-Z[I]);
      Ukamdivtok:=Ukamdivtok+1e-8*V[I,JRizol+1]*{H[I,JRizol+1] }
      0.2/Rizol*(Z[I+1]-Z[I]);
    end;
//    Ukamera:=U1*0.5+Ukamera*0.5;
    H2energy:=0;
  for J:=1 to JM do
  for I:=1 to IM do
  if (geo[I,J]>0) then
  begin
    DV:=pi*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I]);
    H2energy:=H2energy+DV*H[I,J]*H[I,J]/8/pi*1e-7;
  end;

  E_to_kam:=E_to_kam+Ukamera*TOK*dt;

  if(Tok>1e-30)then Lkam:=2*H2energy/Tok/Tok else Lkam:=0;
//!!! izza korrektora
TOK:=TOK+(Ukond-Ukamera-Rkontur1*TOK)*DT/Lkontur;
  Eloss:=Eloss+Rkontur1*TOK*TOK*dt;
//  TOK:=(TOK+(Ukond-Rkontur1*TOK)*DT/Lind)/(1+Ukamdivtok*dt/Lind);
//  Ukamera:=ukamdivtok*tok;
//
// !!iz-za korr
Ukond:=Ukond-TOK*DT/Ckond;
  if TOK>TOKmax then TOKmax:=TOK;
 end;

  nmax:=0;
  H2energy:=0;
  SN:=0;
  for J:=1 to JM do
  for I:=1 to IM do
  if (geo[I,J]>0) then
  begin
    DV:=pi*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I]);
    H2energy:=H2energy+DV*H[I,J]*H[I,J]/8/pi*1e-7;
    SN:=SN+DV*(N[I,J]*1e-20);
    if (nmax < N[I,J])and((j<=1)or(geo[i,j-1]>0))and((j<=2)or(geo[i,j-2]>0))and((j<=3)or(geo[i,j-3]>0))and((j<=4)or(geo[i,j-4]>0))and((j<=5)or(geo[i,j-5]>0))and((j<jmax-2)and(geo[i,j+1]>0))and((j<jmax-3)and(geo[i,j+2]>0))and((j<jmax-4)and(geo[i,j+3]>0))and((j<jmax-5)and(geo[i,j+4]>0))and((j<jmax-6)and(geo[i,j+5]>0)) then nmax:=N[I,J];
  end;
  if TOK<>0 then Lkamer:=2*H2Energy/TOK/TOK else Lkamer:=0;
  Lind:=Lkamer;
  if(not ispinched)then
  begin
    j_tok_max:=0;
    for I:=1 to IM do
        for J:=1 to JM do
        begin
          j_tok:=sqrt(sqr((H[I,J+1]*R[J+1]-H[I,J]*R[J])/
          (sqr(R[J+1])-sqr(R[J]))/2)+sqr((H[I+1,J]-H[I,J])/(Z[I+1]-Z[I])));
          if((j_tok>j_tok_max)and((j>1)and(geo[i,j-1]>0))and((j>2)and(geo[i,j-2]>0))and((j>3)and(geo[i,j-3]>0))and((j>4)and(geo[i,j-4]>0))and((j>5)and(geo[i,j-5]>0))and((j<jmax-2)and(geo[i,j+1]>0))and((j<jmax-3)and(geo[i,j+2]>0))and((j<jmax-4)and(geo[i,j+3]>0))and((j<jmax-5)and(geo[i,j+4]>0))and((j<jmax-6)and(geo[i,j+5]>0)))then
            j_tok_max:=j_tok;
        end;
    if(j_tok_max>0)then
    for I:=1 to IM do
        for J:=1 to 5 do
        begin
          j_tok:=sqrt(sqr((H[I,J+1]*R[J+1]-H[I,J]*R[J])/
          (sqr(R[J+1])-sqr(R[J]))/2)+sqr((H[I+1,J]-H[I,J])/(Z[I+1]-Z[I])));
          if(j_tok>j_tok_max/5)then
          begin
            ispinched:=true;
            pinchtime:=time;
            pinchtok:=tok;
          end;
        end;
    end;

  TIME:=TIME+DT;
END;


{************************************************}
Procedure TIMER;
{var
   I,J: integer;  }
BEGIN

{  VMAX:=0; NMAX:=0; TMAX:=0; HMAX:=0; UMAX:=0;
  for I:=1 to IM do
  begin
    for J:=1 to JM do
    begin
      IF ABS(V[I,J])>VMAX then VMAX:=ABS(V[I, J]);
      IF ABS(U[I,J])>UMAX then UMAX:=ABS(U[I, J]);
      IF (TE[I,J]>TMAX) then TMAX:=TE[I, J];
      IF (N[I,J]>NMAX) then  NMAX:=N[I,J];
      IF (H[I,J]>HMAX) then  HMAX:=H[I,J];
     end;
  end;    }
END;
{begin Kizl:=1; Kstat:=0; zz:=8; }
end.