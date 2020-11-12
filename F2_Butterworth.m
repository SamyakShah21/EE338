%Bandstop IIR (Butterworth)
%Samyak Shah 18D070062
%Filter Number 144
%---------------------------------------------------
%Butterworth Analog LPF parameters
Wc= 1.077;              %cut-off frequency
N= 7;                   
%poles for order 7 butterworth case
p1= Wc*cos(pi/2 + pi/14) + i*Wc*sin(pi/2 + pi/14);
p2= Wc*cos(pi/2 + pi/14) - i*Wc*sin(pi/2 + pi/14);
p3= Wc*cos(pi/2 + pi/14+pi/7) + i*Wc*sin(pi/2 + pi/14+pi/7);
p4= Wc*cos(pi/2 + pi/14+pi/7) - i*Wc*sin(pi/2 + pi/14+pi/7);
p5= Wc*cos(pi/2 + pi/14+2*pi/7) + i*Wc*sin(pi/2 + pi/14+2*pi/7);
p6= Wc*cos(pi/2 + pi/14+2*pi/7) - i*Wc*sin(pi/2 + pi/14+2*pi/7);
p7= -Wc;

%Band Edge speifications in kHz
fp1= 48.8;
fs1= 52.8;
fs2= 72.8;
fp2= 76.8;

%Transformed Band Edge specifications using Bilinear Transformation
f_samp = 260;         
wp1= tan(fp1/f_samp*pi);
ws1= tan(fs1/f_samp*pi); 
ws2= tan(fs2/f_samp*pi);
wp2= tan(fp2/f_samp*pi);

%For Bandstop Transformation
W0 = sqrt(wp1*wp2);
B = wp2-wp1;

[num,den] = zp2tf([],[p1 p2 p3 p4 p5 p6 p7],Wc^N); %Transfer Function is multiplied with a constant to make DC gain=1 at s=0

%Evaluating Frequency Response of Final Filter
syms s z;
analog_lpf(s) = poly2sym(num,s)/poly2sym(den,s);        
analog_bsf(s) = analog_lpf((B*s)/(s*s + W0*W0));        
discrete_bsf(z) = analog_bsf((z-1)/(z+1));              
%coefficients of analog band stop filter
[ns, ds] = numden(analog_bsf(s));                  
ns = sym2poly(expand(ns));                          
ds = sym2poly(expand(ds));                          
k = ds(1);    
ds = ds/k;
ns = ns/k;

%coefficients of discrete band stop filter
[nz, dz] = numden(discrete_bsf(z));                                        
nz = sym2poly(expand(nz));
dz = sym2poly(expand(dz));                              
k = dz(1);                                              
dz = dz/k;
nz = nz/k;
fvtool(nz,dz)%Frequency Response

%Magnitude plot  
[H,f] = freqz(nz,dz,1024*1024, 260e3);
plot(f,abs(H))
grid