
function plotBodeFig(t,U,Y,xlimval)

figure

% PSD plots
[f,PHI_U] = getPSD(t,U);
[f,PHI_Y] = getPSD(t,Y);
%
subplot(2,2,2)
loglog(f,PHI_U);
title('PSD of IRU roll (input)');
ylabel('W/Hz');
xlabel('Frequency (Hz)');
xlim([xlimval]);
grid on;

subplot(2,2,4);
loglog(f,PHI_Y);
title('PSD of KF roll (output)');
ylabel('W/Hz');
xlabel('Frequency (Hz)');
xlim([xlimval]);
grid on;

% Bode plots -- 
[f,G]   = getETFE(t,U,Y,0.5);
phaseAngles = unwrap(angle(G))*180/pi;
% find +360 phase angles
ind = find(phaseAngles>360);
phaseAngles(ind) = phaseAngles(ind)-360;
% find -360 phase angles
ind = find(phaseAngles<-360);
phaseAngles(ind) = phaseAngles(ind)+360;
% phase is negative because we actually want angle(U-Y)
phaseAngles = -phaseAngles; %need to remember this
%

subplot(2,2,1)
loglog(f,abs(G));
title('Gain of Y/U');
ylabel('dB');
xlabel('Frequency (Hz)');
xlim([xlimval]);
ylim([0.01 15]);
grid on;

subplot(2,2,3);
semilogx(f,phaseAngles);
title('Phase of Y/U');
ylabel('deg');
xlabel('Frequency (Hz)');
xlim([xlimval]);
grid on;

end