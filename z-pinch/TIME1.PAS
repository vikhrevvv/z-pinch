unit Time1;
interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart, MXGRAPH, DbChart, StdCtrls;
type
  TinTime = class(TForm)
    Chart1: TChart;
    DBChart1: TDBChart;
    Series2: TFastLineSeries;
    Series1: TLineSeries;
    Series4: TLineSeries;
    Chart2: TChart;
    LineSeries1: TLineSeries;
    DBChart2: TDBChart;
    nmax_line: TFastLineSeries;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DBChart3: TDBChart;
    dY_line: TFastLineSeries;
    Button44: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button44Click(Sender: TObject);
end;
  procedure savetime;
  procedure ptime;
var inTime: TinTime;
  Ntime: integer;
  FIL2: TextFile;
implementation
uses Twoglob;
{$R *.DFM}

procedure savetime;
begin intime.series1.addXY(time*1e6,Ukamera/1000);
      intime.series2.addXY(time*1e6,TOK/1000);
      intime.series4.addXY(time*1e6,Ukond/1000);
//      intime.LineSeries1.addXY(time*1e6,Lkamer*1e9);
      intime.LineSeries1.addXY(time*1e6,Lind*1e9);
      intime.nmax_line.addXY(time*1e6,nmax/n1);
      intime.dY_line.addXY(time*1e6,d_neutrons);
  // writeln(FIL2,time:11,tok:11);
end;

procedure ptime;
var my,mx,i: integer;
Tmax,Mtok,Umax,dIdtmax: single;
S1,S2,S3: string [30];
begin     intime.Show;
(*   str(time*1000000:4:2,S1);
  str(tok/1000:5:0,S2); str(Ukond/1000:4:1,S3);
  inTime.caption:='t='+S1+' ns,  I='  +s2+' kA,  Uc='+S3 +'kV';
str(tok/1000:5:0,S2); str(Ukond/1000:4:1,S3);
  inTime.caption:='t='+S1+'mks,  I='  +s2+'kA'  *)
end;
procedure TinTime.Button1Click(Sender: TObject);
begin
  intime.Chart1.Visible:=true;
  intime.Chart2.Visible:=false;
  intime.DBChart2.Visible:=false;
  intime.DBChart3.Visible:=false;
end;

procedure TinTime.Button2Click(Sender: TObject);
begin
  intime.Chart1.Visible:=false;
  intime.Chart2.Visible:=true;
  intime.DBChart2.Visible:=false;
  intime.DBChart3.Visible:=false;
end;

procedure TinTime.Button3Click(Sender: TObject);
begin
  intime.Chart1.Visible:=false;
  intime.Chart2.Visible:=false;
  intime.DBChart2.Visible:=true;
  intime.DBChart3.Visible:=false;
end;

procedure TinTime.Button44Click(Sender: TObject);
begin
  intime.Chart1.Visible:=false;
  intime.Chart2.Visible:=false;
  intime.DBChart2.Visible:=false;
  intime.DBChart3.Visible:=true;

end;

{
begin  NTIME:=100;
  AssignFile(FIL2,'CURRENT.OUT');       }

end.
