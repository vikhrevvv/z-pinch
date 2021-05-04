unit balanc;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, MXGRAPH;
type
  Tbalance = class(TForm)
    Chart1: TChart;
    Series1: TAreaSeries;
    Series2: TAreaSeries;
    Series3: TAreaSeries;
    Series4: TAreaSeries;
    Series5: TAreaSeries;
    Series6: TAreaSeries;
    Series8: TAreaSeries;
  end;
    procedure Timebalance;
var balance: Tbalance;
  WallKin, WallkT,
 Emust,Emag,dHH, EINIT, SN, Esum, V2energy, H2energy,nTenergy,
 I2energy,U2energy :double;

implementation
uses Twoglob;
{$R *.dfm}
var Eplasma, Ekamera, Eused, Epluswall: double;

procedure Timebalance;
var I,j,k: integer;
DV: real;
begin V2energy:=0; H2energy:=0; nTenergy:=0; SN:=0;
  nmax:=0;
  for J:=1 to JM do
  for I:=1 to IM do
  if (geo[I,J]>0) then
  begin DV:=pi*(sqr(R[J+1])-sqr(R[J]))*(Z[I+1]-Z[I]);
    V2energy:=V2energy+DV*N[I,J]*MD*1e-7*
    (sqr(U[I,J])+sqr(U[I+1,J])+sqr(V[I,J])+sqr(V[I,J+1]))/4;
    H2energy:=H2energy+DV*H[I,J]*H[I,J]/8/pi*1e-7;
    nTenergy:=nTenergy+DV*N[I,J]*TE[I,J]*3/2*KB*1e-7;
    SN:=SN+DV*(N[I,J]*1e-20);
    if nmax < N[I,J] then nmax:=N[I,J];
  end;
  Eplasma:=NTenergy+V2energy;
//  ekamold:=ekam;
  Ekamera:=Eplasma+H2energy;
//  ekam:=ekamera;
{  dEnergy:=Ekamera-sumEnergy;
  SumEnergy:=Ekamera;  }
  Eused:=Ekamera+Lkontur*TOK*TOK/2;
  Ekontur:=Ekontur+Rkontur1*TOK*TOK*dt;
 // Ekontur:=Ekontur+Eplasma*dt*Rkontur1/1e-10;
 // 30.08.10 Esum:=Eused+Ekontur;
  Esum:=Eused+Ckond*Ukond*Ukond/2;
  Epluswall:=Esum+WallkT;//+WallKin;
  if TOK<>0 then Lkamer:=2*H2Energy/TOK/TOK else Lkamer:=0;
    balance.series6.addXY(time*1e6,Epluswall/1000);
  balance.series1.addXY(time*1e6,Esum/1000);
  balance.series2.addXY(time*1e6,Eused/1000);
  balance.series3.addXY(time*1e6,Ekamera/1000);
  balance.series4.addXY(time*1e6,Eplasma/1000);
  balance.series5.addXY(time*1e6,NTenergy/1000);
  balance.series8.addXY(time*1e6,(Eloss+Esum)/1000);
  balance.Show
end;
end.
