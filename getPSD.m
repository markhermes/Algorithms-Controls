function [fInterval, psdx] = getPSD(t,u) 

N               = numel(t);
DT              = (t(2)-t(1));
Fs              = 1/DT;

%fft spits out two sided complex at frequency spacings of (Fs) * 1/(N/2)
%number of bins is L
two_sided_Y             = fft(u);
one_sided_Y             = two_sided_Y(1:N/2+1);
psdx                    = (1/(Fs*N)) * abs(one_sided_Y).^2;
psdx(2:end-1)           = 2*psdx(2:end-1);
fInterval               = 0:Fs/N:Fs/2;


end