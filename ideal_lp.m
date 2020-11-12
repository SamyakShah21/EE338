function output = ideal_lp(wc,M)
    %Ideal Low pass function
    %Samyak Shah, 18D070062
    %-------------------------
alpha= (M-1)/2;
n= [0:1:(M-1)];
m= n - alpha + eps;
output= sin(wc*m)./(pi*m);

