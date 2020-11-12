%Bandpass IIR (Chebyshev)
%Samyak Shah 18D070062
%Filter Number 144
%---------------------------------------------------
D1= 1/(0.85*0.85)-1;   %Delta is equal to 0.15
eps= sqrt(D1);         
N= 4; %Filter order
%4 poles
p1= -sin(pi/(2*N))*sinh(asinh(1/eps)/N)+i*cos(pi/(2*N))*cosh(asinh(1/eps)/N);
p2= -sin(pi/(2*N))*sinh(asinh(1/eps)/N)-i*cos(pi/(2*N))*cosh(asinh(1/eps)/N);
p3= -sin(3*pi/(2*N))*sinh(asinh(1/eps)/N)+i*cos(3*pi/(2*N))*cosh(asinh(1/eps)/N);
p4= -sin(3*pi/(2*N))*sinh(asinh(1/eps)/N)-i*cos(3*pi/(2*N))*cosh(asinh(1/eps)/N);        

%Transfer function of Chebyshev Analog LPF
n1= [1 -p1-p2 p1*p2];
n2= [1 -p3-p4 p3*p4];
den= conv(n1,n2);          
%DC Gain set is sqrt(1/(1+ eps^2)) because of even order (N=4)
num= [den(5)*sqrt(1/(1+eps*eps))];       
%Initializing the band edges (unique values), values in kHz
fs1= 55.6;
fp1= 59.6;
fp2= 79.6;
fs2= 83.6;

%Using Bilinear Transformation on band edge
f_samp= 330;%kHz
ws1= tan(fs1/f_samp*pi);          
wp1= tan(fp1/f_samp*pi);
wp2= tan(fp2/f_samp*pi);
ws2= tan(fs2/f_samp*pi);

W0= sqrt(wp1*wp2); %Omege_knot
B= wp2-wp1;
%Frequency Response of the final filter
%Variable names are self-explanatory
syms s z;
alog_lpf(s)= poly2sym(num,s)/poly2sym(den,s);    
analog_bpf(s)= alog_lpf((s*s +W0*W0)/(B*s));     
discrete_bpf(z)= analog_bpf((z-1)/(z+1));          

%coefficients of the Analog BPF
[ns, ds] = numden(analog_bpf(s));                   
ns= sym2poly(expand(ns));                          
ds= sym2poly(expand(ds));                          
k0= ds(1);    
ds= ds/k0;
ns= ns/k0;
%coefficients of the Discrete BPF
[nz, dz] = numden(discrete_bpf(z));                 
nz= sym2poly(expand(nz));                          
dz= sym2poly(expand(dz));                          
k0= dz(1);                                          
dz= dz/k0;
nz= nz/k0;
fvtool(nz,dz) %in Decibels
%Magnitude plot
[H,f]= freqz(nz,dz,1024*1024, 330e3);
plot(f,abs(H))
grid
%We used the options of pole zero plot, magnitude and phase plot using
%MATLAB's GUI for saving different plots as required.
%The x axis, y axis, label etc. are written via MATLAB Online's GUI