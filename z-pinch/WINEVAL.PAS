Unit WinEval;
Interface
Procedure DENSIT;
Procedure STEP;
Procedure TEMPS;
Procedure TIMER;

Implementation
Uses TwoGlob,balanc,math,init;

Procedure DENSIT;
var I,J,J2,I2: integer;
  DR,DZ,RI,DIVRR,DIVZZ: double;
  V2energy,H2energy,nTenergy,DV:double;
BEGIN
  for I:=1 to IM do
  begin DZ:=Z[I+1]-Z[I];
    for J:=1 to JM do
    begin DR:=(R[J+1]-R[J]);
      RI:=(R[J+1]+R[J])*0.5;
      if V[I,J+1]>0 then J2:=J else J2:=J+1;;
      VF[I,J+1]:=N[I,J2]*V[I,J+1]*R[J+1]/DR;
      DIVRR:=(VF[I,J+1]-VF[I,J])/RI;
      if U[I+1,J]>0 then I2:=I else I2:=I+1;;
      UF[I+1,J]:=N[I2,J]*U[I+1,J]/DZ;
      DIVZZ:=UF[I+1,J]-UF[I,J];
      NF[I,J]:=N[I,J]-(DIVRR+DIVZZ)*DT;
      IF NF[I,J]<AN1 then NF[I,J]:=AN1;
      WVF[I,J+1]:=1.5*KB*TE[I,J2]*VF[I,J+1];
      WUF[I+1,J]:=1.5*KB*TE[I2,J]*UF[I+1,J];
    end;
    UF[I+1,JM+1]:=UF[I+1,JM];
    WUF[I+1,JM+1]:=WUF[I+1,JM];
    VF[I+1,JM+1]:=0;  WVF[I+1,JM+1]:=0; V[I+1,JM+1]:=0;
  end;
  for J:=1 to JM+1 do begin U[IM+1,J]:=0; UF[IM+1,J]:=0;
    WUF[IM+1,J]:=0; end;

  for J:=1 to JM do
  for I:=1 to IM do
  if (geo[I,J]>0) then
  begin DV:=pi*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I]);
    V2energy:={DV*}N[I,J]*MD{*1e-7}*
    (sqr(U[I,J])+sqr(U[I+1,J])+sqr(V[I,J])+sqr(V[I,J+1]))/4;
    H2energy:={DV*}H[I,J]*H[I,J]/8/pi{*1e-7};
    nTenergy:={DV*}N[I,J]*TE[I,J]*3/2*KB{*1e-7};
    W[i,j]:=V2energy+H2energy+nTenergy
    -((WVF[I,J+1]-WVF[I,J])/RI+WUF[I+1,J]-WUF[I,J])*DT;
     {  if UF[I+1,J]<0 then I2:=I+1 else I2:=I;
      if UF[I+1,J-1]<0 then I1:=I+1 else I1:=I;
      W[i,j]:=W[i,j]+0.5*(V[I2,J]*UF[I+1,J]+V[I1,J]*UF[I+1,J-1]);
        if VF[I,J+1]<0 then J2:=J+1 else J2:=J;
      if VF[I-1,J+1]<0 then J1:=J+1 else J1:=J;
      DivR2[I]:=0.5*(U[I,J2]*VF[I,J+1]+U[I,J1]*VF[I-1,J+1]);   }
  end else W[i,j]:=0;
END;

procedure TEMPS;
var I,J: integer;
  DR,DZ,RI,DIVRR,DIVZZ,PV,PU,WT: double;
BEGIN
  for I:=1 to IM do
  begin DZ:=Z[I+1]-Z[I];
    for J:=1 to JM do
    begin DR:=(R[J+1]-R[J]);
      RI:=(R[J+1]+R[J])*0.5;
      DIVRR:=(WVF[I,J+1]-WVF[I,J])/RI;
      DIVZZ:=WUF[I+1,J]-WUF[I,J];
      PV:=2/3/RI*(R[J+1]*V[I,J+1]-R[J]*V[I,J])/DR;
      PU:=2/3*(U[I+1,J]-U[I,J])/DZ;
      WT:=1.5*KB*TE[I,J]*N[I,J];
      WT:=WT-(DIVRR+DIVZZ)*DT-WT*(pv+pu)*DT;
      TE[I,J]:=WT/(1.5*KB*NF[I,J]);
      if TE[I,J]<0.1 then TE[I,J]:=0.1;
      if TE[I,J]>1000 then TE[I,J]:=10000;
      if TE[I,J]>sqr(NF[I,J]/n1)*10000 then TE[I,J]:=sqr(NF[I,J]/n1)*10000;
    end;
    if TE[I,JM]>3 then TE[I,JM]:=3; TE[I,JM+1]:=TE[I,JM];
  end;
  for J:=1 to JM+1 do TE[IM+1,J]:=TE[IM,J];
END;

Procedure STEP;

var I,J: integer;
  DR,DZ,U1,Esum, V2energy, H2energy,nTenergy,dv,j_tok_max,j_tok,TOKold: double;
Function SigmaV(T: real): real;
var T2,GV: real;
    i:integer;
begin
  T:=T*1000;
  if(form3.RadioButtonPower.Checked)then
  begin
    if(abs(ZAtom-2)<1e-3)then
    begin
      i:=0;
      while(T>sigv_dd_T[i+1])do i:=i+1;
      SigmaV:=(sigv_dd[i]*(T-sigv_dd_T[i])+sigv_dd[i+1]*(sigv_dd_T[i+1]-T))/(sigv_dd_T[i+1]-sigv_dd_T[i]);
    end
    else
    if(abs(ZAtom-2.5)<1e-3)then
    begin
      i:=0;
      while(T>sigv_dt_T[i+1])do i:=i+1;
      SigmaV:=0.5*(sigv_dt[i]*(T-sigv_dt_T[i])+sigv_dt[i+1]*(sigv_dt_T[i+1]-T))/(sigv_dt_T[i+1]-sigv_dt_T[i]);
    end
    else
      SigmaV:=0;
  end
  else
  if(form3.RadioButtonPower2.Checked)then
  begin
    if(abs(ZAtom-2)<1e-3)then
    begin
      i:=0;
      while(T>sigv2_dd_T[i+1])do i:=i+1;
      SigmaV:=(sigv2_dd[i]*(T-sigv2_dd_T[i])+sigv2_dd[i+1]*(sigv2_dd_T[i+1]-T))/(sigv2_dd_T[i+1]-sigv2_dd_T[i]);
    end
    else
    if(abs(ZAtom-2.5)<1e-3)then
    begin
      i:=0;
      while(T>sigv2_dt_T[i+1])do i:=i+1;
      SigmaV:=0.5*(sigv2_dt[i]*(T-sigv2_dt_T[i])+sigv2_dt[i+1]*(sigv2_dt_T[i+1]-T))/(sigv2_dt_T[i+1]-sigv2_dt_T[i]);
    end
    else
      SigmaV:=0;
  end
  else
  if(form3.RadioButtonMaxwell.Checked)then
  begin
  if(abs(ZAtom-2)<1e-3)then
    SigmaV:=1.366e-12/Power(T,2/3)*exp(-187.8/Power(T,1/3))
  else
  if(abs(ZAtom-2.5)<1e-3)then
    SigmaV:=0.25*3.12e-10/Power(T,2/3)*exp(-200/Power(T,1/3))
  else
    SigmaV:=0;
  end;
    
{T2:=15e-16;
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
 }

end;
 { IntenNeutr:=SigmaV(TE[I,J])*DT*SQR(NE[I,J])/4;  }
begin
  Esum:=0; V2energy:=0; H2energy:=0; nTenergy:=0; nmax:=0;

{  for I:=2 to IM do begin
     for J:=1 to JM do U[I,J]:=UuZ[I,J]; U[I,JM+1]:=U[I,JM];
     for J:=2 to JM-1 do V[I,J]:=VvR[I,J];
  end;
  for J:=1 to JM do begin V[IM+1,J]:=V[IM,J]; U[1,J]:=U[IM,J] end;
}

  if(use_Kdt)then
    DT:=DT*1.1;
  IF DT>2e-8 then DT:=2e-8;
  d_neutrons:=0;

  for J:=1 to JM do
  begin
    for I:=1 to IM do
    begin DR:=EPS*(R[J+1]-R[J]);
      IF ABS(V[I,J])*DT>DR then DT:=DR/ABS(V[I,J]);
      DZ:=EPS*(Z[I+1]-Z[I]);
      IF ABS(U[I,J])*DT>DZ then DT:=DZ/ABS(U[I,J]);
      IF NF[I,J]<AN1 then NF[I,J]:=AN1;
      N[I,J]:=NF[I,J]; H[I,J]:=HF[I,J];
      if geo[i,J]=-1 then
         begin N[I,J]:=AN1; H[I,J]:=0.2*TOK/R[J] end;
      if (geo[I,J]<-1) then
      begin
        N[i,j]:=AN1;
        H[i,j]:=0;
        Te[i,j]:=0;
      end;
      if (geo[I,J]<0) and (geo[I,J-1]<0) then
      begin  V[I,J]:=0;U[I,J]:=0 end;
      if (geo[I,J]<-1) or (geo[I,J-1]<-1) then
      begin  V[I,J]:=0 end;
      if (geo[I,J]<-1) or (geo[I-1,J]<-1) then
      begin  U[I,J]:=0 end;
    end;
  end;
  for J:=1 to JM do
  begin
    for I:=1 to IM do
    begin
      if (geo[I,J]>0) then begin
        if((N[i,j]>5*n1)and((j<=1)or(geo[i,j-1]>0))and((j<=2)or(geo[i,j-2]>0))and((j<=3)or(geo[i,j-3]>0))and((j<=4)or(geo[i,j-4]>0))and((j<=5)or(geo[i,j-5]>0))and((j<jmax-2)and(geo[i,j+1]>0))and((j<jmax-3)and(geo[i,j+2]>0))and((j<jmax-4)and(geo[i,j+3]>0))and((j<jmax-5)and(geo[i,j+4]>0))and((j<jmax-6)and(geo[i,j+5]>0)))then
        begin
          neutrons :=neutrons+sqr(N[I,J])*SigmaV(TE[I,J]/1000)*
          pi/2*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I])*dt;
          d_neutrons :=d_neutrons+sqr(N[I,J])*SigmaV(TE[I,J]/1000)*
          pi/2*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I]);
        end;

        if (nmax < N[I,J])and((j<=1)or(geo[i,j-1]>0))and((j<=2)or(geo[i,j-2]>0))and((j<=3)or(geo[i,j-3]>0))and((j<=4)or(geo[i,j-4]>0))and((j<=5)or(geo[i,j-5]>0))and((j<jmax-2)and(geo[i,j+1]>0))and((j<jmax-3)and(geo[i,j+2]>0))and((j<jmax-4)and(geo[i,j+3]>0))and((j<jmax-5)and(geo[i,j+4]>0))and((j<jmax-6)and(geo[i,j+5]>0))and((i>1)and(geo[i-1,j]>0))and((i>2)and(geo[i-2,j]>0))and((i>3)and(geo[i-3,j]>0))and((i<imax-2)and(geo[i+1,j]>0))and((i<imax-3)and(geo[i+2,j]>0))and((i<imax-4)and(geo[i+3,j]>0)) then nmax:=N[I,J];
        DV:=pi*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I]);
        V2energy:=V2energy+DV*N[I,J]*MD*1e-7*
        (sqr(U[I,J])+sqr(U[I+1,J])+sqr(V[I,J])+sqr(V[I,J+1]))/4;
        H2energy:=H2energy+DV*H[I,J]*H[I,J]/8/pi*1e-7;
        nTenergy:=nTenergy+DV*N[I,J]*TE[I,J]*3/2*KB*1e-7;


      end;
    end;
  end;
  Esum:=V2energy+H2energy+nTenergy;

  begin U1:=Ukamera; Ukamera:=0;
    for I:=1 to IZizol+1 do
    begin
      Ukamera:=Ukamera+1e-8*V[I,JRizol+1]*{H[I,JRizol+1] }
      0.2*TOK/Rizol*(Z[I+1]-Z[I]);
//    Ukamera:=Ukamera+1e-8*V[I,JRizol+1]*H[I,JRizol+1]*(Z[I+1]-Z[I]);

//      E_to_kam:=E_to_kam+1e-8*V[I,JRizol+1]*H[I,JRizol+1]*(Z[I+1]-Z[I])*TOK*dt;
    end;

    if(use_U_cheat)then
    if(abs(TOK)>25000)then
      Ukamera:=(Esum-Esumold)/TOK/dt;

    Esumold:=Esum;
    TOKold:=TOK;
    TOK:=TOK+(Ukond-Ukamera-Rkontur1*TOK)*DT/Lkontur;
    Ukond:=Ukond-TOK*DT/Ckond;
    if TOK>TOKmax then TOKmax:=TOK;
    if TOK<>0 then Lkamer:=2*H2Energy/TOK/TOK else Lkamer:=0;
//    if TOK<>0 then Lkamer:=(Ukamera*DT+Lkamer*TOKold)/TOK else Lkamer:=0;

    Lind:=Lkamer+Lkontur;

    Eloss:=Eloss+Rkontur1*TOK*TOK*dt;
  end;

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
    for I:=IZizol to IM do
        for J:=1 to 2 do
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

Procedure TIMER;
BEGIN
END;

end.