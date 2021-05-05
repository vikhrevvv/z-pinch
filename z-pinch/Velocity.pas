Unit Velocity;
Interface
Procedure MFIELD;
Procedure RSPEED;
Procedure ZSPEED;
Procedure CorrectMagEnergy;

Implementation
Uses TwoGlob;
var VR,UZ: MM;

Procedure MFIELD;
var DIVZ1: array [1..640] of real;
  DIVR2,DR,DZ,DIVR1,DIVR,DIVZ,DIVZ2: real;
  I,J,J2,I2 : integer;
BEGIN
  for J:=1 to JM do DIVZ1[J]:=0;
  for I:=1 to IM  do
  begin DIVR1:=0; DZ:=Z[I+1]-Z[I];
    for J:=1 to JM-1 do
    begin DR:=R[J+1]-R[J];
      if V[I,J+1]>0 then J2:=J else J2:=J+1;
      DIVR2:=H[I,J2]*V[I,J+1];
      DIVR:=(DIVR2-DIVR1)/DR;
      if U[I+1,J]>0 then I2:=I else I2:=I+1;
      DIVZ2:=H[I2,J]*U[I+1,J];
      DIVZ:=(DIVZ2-DIVZ1[J])/DZ;
      HF[I,J]:=H[I,J]-(DIVR+DIVZ)*DT;
      DIVZ1[J]:=DIVZ2;
      DIVR1:=DIVR2;
    end;
  end;
END;

Procedure RSPEED;
var DP,DH,DIVR,DIVZ,DIV1,DIV2,RI2,RI1,DR,H1,DIVV,VALF1: double;
  I,I1,I2,J: integer;
  DIVZ1,DIVZ2: array [2..640] of double;
begin
  for J:=2 to JM do DIVZ1[J]:=0;
  for I:=2 to IM do
  begin DIV1:=0.25*(VF[I,1]+VF[I,2])*(V[I,1]+V[I,2]);
    for J:=2 to JM-1 do
    begin  RI2:=(R[J]+R[J+1])*0.5;
      DR:=(R[J+1]-R[J-1])*0.5;
      if UF[I+1,J]<0 then I2:=I+1 else I2:=I;
      if UF[I+1,J-1]<0 then I1:=I+1 else I1:=I;
      DIVZ2[J]:=0.5*(V[I2,J]*UF[I+1,J]+V[I1,J]*UF[I+1,J-1]);
      RI1:=(R[J]+R[J-1])*0.5;
      DIV2:=0.25*(VF[I,J]+VF[I,J+1])*(V[I,J]+V[I,J+1]);
      if (geo[i,j]<-1) or (geo[i,j-1]<-1) then DH:=0 else
      DH:=-(HF[I,J-1]+HF[I,J])/R[J]*DT/DR/(8*pi)*(RI2*HF[I,J]-RI1*HF[I,J-1]);
      IF geo[I,J]*geo[I,J-1]<=0 then dp:=0 else
      DP:=-KB*(NF[I,J]*TE[I,J]*2-NF[I,J-1]*TE[I,J-1]*2)/DR*DT;

      DIVR:=-MD*(DIV2-DIV1)/R[J]*DT;
      DIVZ:=-MD*(DIVZ2[J]-DIVZ1[J])*DT;
      DIV1:=DIV2;
      DIVZ1[J]:=DIVZ2[J];
      VR[I,J]:=(MD*0.5*(N[I,J]*RI2+N[I,J-1]*RI1)/R[J]*V[I,J]+DIVZ+DIVR+DP+DH)/
               (MD*0.5*(NF[I,J]*RI2+NF[I,J-1]*RI1)/R[J]);

      vvr[i,j]:=vr[i,j];
    end;
  end;
end;

Procedure ZSPEED;
var I,J,J1,J2: integer;
  DH,DP,DIVR,DIVZ,DIV1,DIV2,DR,DZ,DIVV,G: double;
  DIVR1,DIVR2: array [2..640] of double;
BEGIN
  for I:=2 to IM do DivR1[I]:=0;
  for J:=1 to JM do
  begin DIV1:=0.25*(UF[1,J]+UF[2,J])*(U[1,J]+U[2,J]);
    DR:=(R[J+1]-R[J-1])*0.5;
    for I:=2 to IM do
    begin DZ:=(Z[I+1]-Z[I-1])*0.5;
      DIV2:=0.25*(UF[I,J]+UF[I+1,J])*(U[I,J]+U[I+1,J]);
      if VF[I,J+1]<0 then J2:=J+1 else J2:=J;
      if VF[I-1,J+1]<0 then J1:=J+1 else J1:=J;
      DivR2[I]:=0.5*(U[I,J2]*VF[I,J+1]+U[I,J1]*VF[I-1,J+1]);
      if (geo[i,j]<-1) or (geo[i-1,j]<-1) then DH:=0 else
      DH:=-(HF[I-1,J]+HF[I,J])/(8*pi)*(HF[I,J]-HF[I-1,J])/DZ*DT;
      IF geo[I,J]*geo[I-1,J]<=0 then dp:=0 else
      DP:=-KB*(NF[I,J]*TE[I,J]*2-NF[I-1,J]*TE[I-1,J]*2)/DZ*DT;
      DIVZ:=-MD*(DIV2-DIV1)*DT;
      DIVR:=-MD*(DIVR2[I]-DIVR1[I])*2/(R[J+1]+R[J])*DT;
      DIV1:=DIV2; DIVR1[I]:=DIVR2[I];
      UZ[I,J]:=(MD*(N[I-1,J]+N[I,J])*0.5*U[I,J]+DIVR+DIVZ+DP+DH)/
      (MD*(NF[I-1,J]+NF[I, J])*0.5);

      uuz[i,j]:=uz[i,j];
    end;
  end;
  for I:=2 to IM do begin
     for J:=1 to JM do U[I,J]:=UZ[I,J]; U[I,JM+1]:=U[I,JM];
     for J:=2 to JM-1 do V[I,J]:=VR[I,J];
  end;
  for J:=1 to JM do begin V[IM+1,J]:=V[IM,J]; U[1,J]:=U[IM,J] end;

end;

Procedure CorrectMagEnergy;
  var I,J,J2,I2: integer;
  DV,DR,DZ,RI,DIVRR,DIVZZ: double;
  V2energy, H2energy,nTenergy:double;
BEGIN
  for J:=1 to JM do
  for I:=1 to IM do
  begin
    Vcorr[i,j]:=0;
    Ucorr[i,j]:=0;
  end;

  for J:=1 to JM do
  for I:=1 to IM do
  if ((geo[I,J]>=0)or((geo[I,J+1]>0)and(geo[I,J]=-1))) then
  begin
    DZ:=Z[I+1]-Z[I];
    RI:=(R[J+1]+R[J])*0.5;
    DR:=(R[J+1]-R[J]);
    DV:=pi*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I]);
    V2energy:={DV*}NF[I,J]*MD{*1e-7}*
    (sqr(Uuz[I,J])+sqr(Uuz[I+1,J])+sqr(Vvr[I,J])+sqr(Vvr[I,J+1]))/4;
//    H2energy:={DV*}Hf[I,J]*Hf[I,J]/8/pi{*1e-7};
    nTenergy:={DV*}NF[I,J]*TE[I,J]*3/2*KB{*1e-7};

    if Vvr[I,J+1]>0 then J2:=J else J2:=J+1;;
    Vcorr[I,J+1]:=N[I,J2]*MD*(sqr(Uuz[I,J2])+sqr(Uuz[I+1,J2])
      +sqr(Vvr[I,J2])+sqr(Vvr[I,J2+1]))/4*Vvr[I,J+1]*R[J+1]/DR
      +2*H[I,J2]*H[I,J2]/8/pi*Vvr[I,J+1]*R[J+1]/DR;
    DIVRR:=(Vcorr[I,J+1]-Vcorr[I,J])/RI;
    if Uuz[I+1,J]>0 then I2:=I else I2:=I+1;;
    Ucorr[I+1,J]:=N[I2,J]*MD*(sqr(Uuz[I2,J])+sqr(Uuz[I2+1,J])
      +sqr(Vvr[I2,J])+sqr(Vvr[I2,J+1]))/4*Uuz[I+1,J]/DZ
      +2*H[I2,J]*H[I2,J]/8/pi*Uuz[I+1,J]/DZ;
    DIVZZ:=Ucorr[I+1,J]-Ucorr[I,J];


//    W[i,j]:=W[i,j]-V2energy-nTenergy-divrr*dt-divzz*dt;
    H2energy:=W[i,j]-V2energy-nTenergy-divrr*dt-divzz*dt;
    if((abs(Hf[i,j])>1e-30)and(H2energy>1e-10))then
      Hf[i,j]:=Hf[i,j]/abs(Hf[i,j])*sqrt(H2energy*8*Pi);
  end;
end;
end.