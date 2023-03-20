function [fInterval, Ghat] =  getETFE(t,u,y,stddev)

N                       = numel(t);
DT                      = (t(2)-t(1));
Fs                      = 1/DT;
fInterval               = Fs*(0:(N/2))/N;
wInterval               = fInterval*2*pi;
dW                      = wInterval(2)-wInterval(1);

%fft of u
U                       = fft(u);
two_sided_U             = U/N;
UN                      = two_sided_U(1:N/2+1);

%%fft of y
Y                       = fft(y);
two_sided_Y             = Y/N;
YN                      = two_sided_Y(1:N/2+1);


%Unsmoothed ETFE -- ETFE is not Tranfer Function
Ghathat  = (YN)./(UN);

%Method2: cross-correlations to get impulse response
% Ryu = corr(y,u);
% Ruu = corr(u,u);


%Assume gaussian smoothing window -- choose width by stddev....
%integral (W) dw = 1
%details on page 152

for w = 1:numel(wInterval)
    W = 1/(stddev*sqrt(2*pi)) * exp(-1/2*((wInterval - wInterval(w))/stddev).^2);
    Num = W*(abs(UN).^2.*Ghathat)*dW;
    Den = W*(abs(UN).^2)*dW;
    Ghat(w) = Num/Den;
end



end