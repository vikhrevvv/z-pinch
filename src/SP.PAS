unit SP;
interface
procedure SnowPl;
function Inside(r,z:double): boolean;
type Itype  = Word;
     Rtype  = Double;
const imax=1200;

var counter: integer;
  imsp: integer;
   vv,dl,constm,ds: double;

implementation
 uses twoglob;

function inside(r,z:double):boolean;
var iz,jr: integer;
begin
  jr:=round(jm*r/rp);
  iz:=round(im*Z/zp);
  if geo[iz,jr]>0 then inside:=true
  else inside:=false;
end;

procedure SnowPl;
var i,j,i1: integer;
  f,m1,vz1,vr1,rmiddle,vl,vn,uz,ur,sz,sr,s: real;
  dr1,dr2,dz1,dz2: real;
begin
   dL:=0; vr1:=0; vz1:=0; m1:=m[1];
   for i:=1 to imsp-1 do
   begin
    uz:=(m1*vz1+m[i]*vz[i])/(m1+m[i]);
    ur:=(m1*vr1+m[i]*vr[i])/(m1+m[i]);
    rmiddle:=(r[i]+r[i+1])/2;

    m1:=m[i]; vz1:=vz[i]; vr1:=vr[i];

    sz:=z[i]-z[i+1];
    sr:=r[i]-r[i+1];
    s:=sqrt(sr*sr+sz*sz);

    r[i]:=r[i]+ur*dt;
    z[i]:=z[i]+uz*dt;

    vn:=(sr*vz[i]-sz*vr[i])/s;
    vl:=(sz*vz[i]+sr*vr[i])/s;

    m[i]:=m1+vn*rmiddle*constm*dt*s;

    f:=0.01*tok*tok/rmiddle;
    if f<0 then f:=0;

    vn:=(m1*vn+f*s*dt)/m[i];
    //i1:=i;
    vl:=vl*m1/m[i];
   /////////////////////////////////////////////////////////////
    if r[i]<0.05 then begin r[i]:=0.05; {vn:=0; vl:=0} end;

    if not inside(r[i],z[i]) or not inside(r[i+1],z[i+1]) then
    begin vl:=0; vn:=0 end;

    vr[i]:=(sr*vl-sz*vn)/s;
    vz[i]:=(sz*vl+sr*vn)/s;
    dL:=dL+vn*s/rmiddle*dt;
   end;
   // --- ���� ����� ���������� ������� ������, ����� ���� �������� �����
   for i:=1 to imsp-1 do
   begin
    s:=sqrt(sqr(r[i]-r[i+1])+sqr(z[i]-z[i+1]));
    if (s>ds*2*r[i]/(r[i]+ds)) and (imsp<imax) then
    begin m[i]:=m[i]*0.5;
     for i1:=imsp downto i do
     begin r[i1+1]:=r[i1]; z[i1+1]:=z[i1];
       vr[i1+1]:=vr[i1]; vz[i1+1]:=vz[i1]; m[i1+1]:=m[i1] end;
       r[i+1]:=(r[i]+r[i+2])*0.5;
       z[i+1]:=(z[i]+z[i+2])*0.5;
       imsp:=imsp+1
    end;
   end;
   // --- ���� ����� � ���������, ��� ������������
   if (not inside(r[2],z[2])) and (imsp>2) then
   begin imsp:=imsp-1;
     for i:=1 to imsp do
     begin r[i]:=r[i+1]; z[i]:=z[i+1];
     vr[i]:=vr[i+1]; vz[i]:=vz[i+1]; m[i]:=m[i+1] end;
     if not inside(r[imsp-1],z[imsp-1]) then imsp:=imsp-1
   end;
   // --- ���� �������� ��������, �� ����� ������������

   repeat
   for i:=2 to imsp do
   begin
     dr1:=r[i-1]-r[i]; dz1:=z[i-1]-z[i];
     dr2:=r[i]-r[i+1]; dz2:=z[i]-z[i+1];
     s:=sqrt(sqr(r[i+1]-r[i-1])+sqr(z[i+1]-z[i-1]));
     I1:=0;
     if (dr1*dz2-dr2*dz1<0) and (s<2*ds) then
     begin I1:=I1+1;
       for j:=I-1 to imsp-1 do
       begin r[j]:=r[j+1]; z[j]:=z[j+1];
         Vr[j]:=Vr[j+1]; Vz[j]:=Vz[j+1]; M[j]:=M[j+1];
       end;
       imsp := imsp-1;
     end;
   end;
   Until I1=0;

end;

end.


