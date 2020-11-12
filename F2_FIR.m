%Bandpass FIR (Chebyshev)
%Samyak Shah 18D070062
%Filter Number 144
%---------------------------------------------------
f_samp = 260e3;
%Band Edge speifications
fp1= 48.8e3;
fs1= 52.8e3;
fs2= 72.8e3;
fp2= 76.8e3;
%Kaiser paramters, for piecewise beta calculation fuction
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end
Wn = [(fs1+fp1)/2 (fs2+fp2)/2]*2/f_samp;        %average value of the two paramters
N_min = ceil((A-7.95)/ (2.285*0.031*pi));       %empirical formula for N_min
%Window length for Kaiser Window
n=N_min + 16;   %Adjusted using hit and trial
bs_ideal =  ideal_lp(pi,n) -ideal_lp(0.5754*pi,n) + ideal_lp(0.3908*pi,n);

%Kaiser Window using https://in.mathworks.com/help/signal/ref/kaiser.html
kaiser_win= (kaiser(n,beta))';
FIR_BandStop= bs_ideal .* kaiser_win;
fvtool(FIR_BandStop);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandStop,1,1024, f_samp);
plot(f,abs(H))
yline(0.15, "-k")
yline(0.85, "-k")
xline(fp1, "g--")
xline(fs1, "r--")
xline(fs2, "r--")
xline(fp2, "g--")
grid
%We used the options of impulse response, magnitude and phase plot using
%MATLAB's GUI for saving different plots as required.
%The x axis, y axis, label etc. are written via MATLAB Online's GUI