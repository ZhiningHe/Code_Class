[fn,pn,fi]=uigetfile('*.txt','选择文件');%获取已知数据
I=load([pn fn]);
x=I(:,1)';y=I(:,2)';X=I(:,3)';Y=I(:,4)';Z=I(:,5)';
s=0;S=0;
for i=1:3;
j=i+1;
sij=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
Sij=sqrt((X(i)-X(j))^2+(Y(i)-Y(j))^2);
s=s+sij;
S=S+Sij;
end
m=S*1000/s;
f=153.24;
%确定未知数的初始值
Xs0=(X(1)+X(2)+X(3)+X(4))/4;
Ys0=(Y(1)+Y(2)+Y(3)+Y(4))/4;
Zs0=m*f;
t=0;k=0;w=0;
for v=1:+inf;
%计算各方向余弦值，组成旋转矩阵R 
a1=cos(t)*cos(w)-sin(t)*sin(k)*sin(w);
a2=-cos(t)*sin(w)-sin(t)*sin(k)*cos(w);
a3=-sin(t)*cos(k);
b1=cos(k)*sin(w);
b2=cos(k)*cos(w);
b3=-sin(k);
c1=sin(t)*cos(w)+cos(t)*sin(k)*sin(w);
c2=-sin(t)*sin(w)+cos(t)*sin(k)*cos(w);
c3=cos(t)*cos(k);
R=[a1 a2 a3;b1 b2 b3;c1 c2 c3];
l=[];A=[];
%逐点计算像点坐标近似值
for h=1:4;
O=a1*(X(h)-Xs0)+b1*(Y(h)-Ys0)+c1*(Z(h)-Zs0);
P=a2*(X(h)-Xs0)+b2*(Y(h)-Ys0)+c2*(Z(h)-Zs0);
Q=a3*(X(h)-Xs0)+b3*(Y(h)-Ys0)+c3*(Z(h)-Zs0);
x1=-f*O/Q;%共线方程
y1=-f*P/Q;%共线方程
%计算法方程系数矩阵A
a11=(a1*f+a3*x(h))/Q;
a12=(b1*f+b3*x(h))/Q;
a13=(c1*f+c3*x(h))/Q;
a14=y(h)*sin(k)-(x(h)/f*(x(h)*cos(w)-y(h)*sin(w))+f*cos(w))*cos(k);
a15=-f*sin(w)-x(h)/f*(x(h)*sin(w)+y(h)*cos(w));
a16=y(h);
a21=(a2*f+a3*y(h))/Q;
a22=(b2*f+b3*y(h))/Q;
a23=(c2*f+c3*y(h))/Q;
a24=-x(h)*sin(k)-(y(h)/f*(x(h)*cos(w)-y(h)*sin(w))-f*sin(w))*cos(k);
a25=-f*cos(w)-y(h)/f*(x(h)*sin(w)+y(h)*cos(w));
a26=-x(h);
lx=x(h)-x1;
ly=y(h)-y1;
lh=[lx ly]';
Ah=[a11,a12,a13,a14,a15,a16;a21,a22,a23,a24,a25,a26];
A=[A;Ah]; 
l=[l;lh];
end
%根据最小二乘原理解法方程和未知数改正数
%迭代改正数
XX=inv(A'*A)*A'*l;
Xs0=Xs0+XX(1);
Ys0=Ys0+XX(2);
Zs0=Zs0+XX(3);
t=t+XX(4);
k=k+XX(5);
w=w+XX(6);
R=[a1,a2,a3;b1,b2,b3;c1,c2,c3]
Xs=Xs0
Ys=Ys0
Zs=Zs0
fai=t
omig=k
ka=w
if abs(XX(4))<0.0000291&&abs(XX(5))<0.0000291&&abs(XX(6))<0.0000291
break
end
end
%输出计算结果
R=[a1,a2,a3;b1,b2,b3;c1,c2,c3];
V=A*XX-l;
Qii=inv(A'*A);
m0=sqrt(V'*V/2);
mi=m0*sqrt(Qii);
m=diag(mi);
m=[m(1),m(2),m(3),m(4)/pi*180*3600,m(5)/pi*180*3600,m(6)/pi*180*3600];
mXs=m(1);mYs=m(2);mZs=m(3);mfai=m(4);momig=m(5);mka=m(6);
fp=fopen('后方交会计算结果.txt','wt'); 
fprintf(fp,'迭代次数:%d\n',v); 
fprintf(fp,'\n旋转矩阵R：\n');
[m,n]=size(R); 
for i=1:1:m 
for j=1:1:n
if j==n 
fprintf(fp,'%g\n',R(i,j)); 
else
fprintf(fp,'%g\t',R(i,j));
end
end
end
fprintf(fp,'\n外方位元素解：\n');
fprintf(fp,'Xs=%g\t',Xs);fprintf(fp,'Ys=%g\t',Ys);fprintf(fp,'Zs=%g\n',Zs);
fprintf(fp,'φ=%g\t',fai);fprintf(fp,'ω=%g\t',omig);fprintf(fp,'κ=%g\n',ka);
fprintf(fp,'\n单位权中误差的值：mo=%g\n',m0);
fprintf(fp,'\n外方位元素中误差为：\n');
fprintf(fp,'mXs=%g米\t',mXs);fprintf(fp,'mYs=%g米\t',mYs);fprintf(fp,'mZs=%g米\n',mZs);
fprintf(fp,'mφ=%g秒\t',mfai);fprintf(fp,'mω=%g秒\t',momig);fprintf(fp,'mκ=%g秒\n',mka);