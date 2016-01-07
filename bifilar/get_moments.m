% Get Moment of Inertia from Bifilar Data
clear; close all

for variable = ['x','y','z']

%variable = 'x';
m = 3.81;  %kg (8.4 lbs measured on 3/1/2014)
g = 9.81;

% Load data
switch variable
    case 'x'
        directory = 'Jxx';
        D = 0.11;
        h = 65.25 * 0.0254;
        t0 = [0;0];
        data_column = 2;  % rotation.w
    case 'y'
        directory = 'Jyy';
        D = 0.13;
        h = 56.375 * 0.0254;
        t0 = [0;0];
        data_column = 4;  
    case 'z'
        directory = 'Jzz';
        D = 0.18;
        h = 68 * 0.0254;
        t0 = [12.61;3.15];
        data_column = 2;  % euler.z
end

for id = 1:2
filename = ['/1.csv';'/2.csv'];
data = load(strcat(directory,filename(id,:)));
t = data(:,1);
theta = data(:,data_column);

% Trim beginning
mask = t > t0(id);
t = t(mask);
theta = theta(mask);

% Plot Signal
figure(1)
subplot(2,1,id), plot(t,theta,'.')

% Plot Frequency Response
Fs = 200;
x = theta;
figure(2)

%Removes final data point if odd number
if mod(length(x),2) == 1
    x = x(1:end-1);
end

N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)).*abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;
psd_log = 10*log10(psdx);
figure(2)
subplot(2,1,id), plot(freq,psd_log); grid on;
title('Periodogram Using FFT');
xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');

[sorted,index] = sort(psd_log);
peak_index = index(end-1);
wn = freq(peak_index);
period = 1/wn;

J(id) = m*g*D^2/(4*h*(wn*2*pi)^2);

%fprintf('Power(%f) = %f\n',wn,psd_log(peak_index));
%fprintf('Period: %f sec\n',period);
%fprintf('J%s%s: %f\n',variable,variable,J(id));
end

fprintf('J%s%s: %f\n',variable,variable,mean(J));

end

