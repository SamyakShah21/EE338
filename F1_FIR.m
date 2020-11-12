%Bandpass FIR (Chebyshev)
%Samyak Shah 18D070062
%Filter Number 144
%---------------------------------------------------
f_samp= 330e3;
%Initializing the band edges (unique values), values in kHz
fs1= 55.6e3;
fp1= 59.6e3;
fp2= 79.6e3;
fs2= 83.6e3;
Wc1= fp1*2*pi/f_samp;
Wc2= fp2*2*pi/f_samp;

%Initializing the kaiser window parameters
A= -20*log10(0.15);
%piecewise function for beta value
if(A < 21)
    beta= 0;
elseif(A <51)
    beta= 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta= 0.1102*(A-8.7);
end
N_min= ceil((A-7.95) / (2.285*0.04*pi));  %N was coming out to be 49 in my calcultion           
%Window length
n= N_min+16;   %Result of hit and trial to meet the given specifications and tolerance conditions
%Ideal bandpass impulse response of length "n"
bp_ideal= ideal_lp(0.494545*pi,n)- ideal_lp(0.34909*pi,n);
%Reference: https://in.mathworks.com/help/signal/ref/kaiser.html
kaiser_win= (kaiser(n,beta))';
FIR_BP= bp_ideal.* kaiser_win;
%Getting the frequency response
fvtool(FIR_BP);         
%Getting the magnitude response
[H,f] = freqz(FIR_BP,1,1024, f_samp);
plot(f,abs(H))
yline(0.85,'-k')
yline(0.15,'-k')
xline(fs1, "g--")
xline(fp1, "r--")
xline(fp2, "r--")
xline(fs2, "g--")
grid
%We used the options of impulse response, magnitude and phase plot using
%MATLAB's GUI for saving different plots as required.
%The x axis, y axis, label etc. are written via MATLAB Online's GUI