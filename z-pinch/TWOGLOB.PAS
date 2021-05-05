unit Twoglob;
interface
const Imax=801; Jmax=401;
type mm = array [0..Imax,0..jmax] of double;
var timesave,timesavebal,tokmax: real;
  IM,JM,KM,IK,Nprint,IZizol,JRizol,iZel,jRel,ir3: integer;
  ROR,NZero,TN,AN1,EPS,VIS,TIME,DT,DD,KB,MD,N1,
  RP,ZP,Rel,Zel,TOK,Zizol,Rizol, neutrons, d_neutrons, nmax,Lkamer,
  Ukond,Ukamera,Lind,Ckond,Rkontur1,SM,Tcped,Lkontur,Lkam,Lkamold,TOKold,Zatom: double;
  current: boolean;
  Ekontur: real;
  geo: array [0..Imax,0..jmax] of integer;
  V,VF,U,UF,N,NF,H,HF,TE,WUF,WVF,Ucorr,Vcorr,DrawMas,mv2,mv2old: MM;
  W:MM;
  z,r,vz,vr,m: array [0..1201] of double;
  timetok1, tok1: array [1..100] of double;
  VvR,UuZ: MM;
  nsbrosdt:integer;
  ispinched:boolean;
  pinchtime,pinchtok:double;
  E_to_kam,Eloss,Esumold:double;
  use_corrector,use_Kdt,use_U_cheat,use_anomal:boolean;
  koef_i4_dd,koef_i4_dt:double;
  sigv_dd_T,sigv_dd,sigv_dt_T,sigv_dt,sigv2_dd_T,sigv2_dd,sigv2_dt_T,sigv2_dt:array[0..30]of double;
implementation
end.
