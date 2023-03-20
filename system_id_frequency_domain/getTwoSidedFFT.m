function [fInterval, UN] = getTwoSidedFFT(t,u) 

N               = numel(t);
DT              = (t(2)-t(1));
Fs              = 1/DT;

%fft spits out two sided complex at frequency spacings of (Fs) * 1/(N/2)
%number of bins is L
Y                       = fftshift(fft(u));
UN                      = Y/N;
fInterval               = Fs*(-(N/2):(N/2)-1)/N;


end