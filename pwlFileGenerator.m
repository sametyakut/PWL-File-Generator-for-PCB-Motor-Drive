% PWL Generator
% Can be used to generate PWL files for Spice

% INPUTS
clc;
clear all;
clear;
close all;
f=500000;           % Switching Frequency
n=1;                % Total number of cycles
Tr=1e-9;            % Rise time
Tf=1e-9;            % Fall time
timeStep = 1e-11;   % minimum time step
waveType = 1 ;      % 0 = Constant duty
                    % 1 = Sine
duty = 0.5 ;        % for the constant duty waveType
fundamental = 1000 ; % fundamental frequency for the sine waveType
deadTime = 100e-9 ; % Deadtime (should be small value)

Vdd = 1 ;          % 12V supply
Vcc = 0 ;           % reference of the Vdd
range = 0.90 ;      % duty range


totalTime=n/fundamental;

time = 0:timeStep:totalTime-timeStep;


trigRef= 0.5*sawtooth(2*pi*f*time,1/2)+0.5;
sineRef = 0.5*range*sin(2*pi*fundamental*time)+0.5;


% Generating PWL
pw1(1)=0 ;
pw2(1)=Vdd;
pw3(1)=0 ;
pw4(1)=Vcc;
k=3;
for i=2:length(time);
    if ((trigRef(i)-sineRef(i)>=0) & (trigRef(i-1)-sineRef(i-1)<=0)) % fall
        pw1(k)=time(i)- deadTime/2;
        pw1(k-1)=time(i)+Tf-deadTime/2;        %fall time
        pw2(k)=Vcc;
        pw2(k-1)=Vdd;
        pw3(k)=time(i)+ deadTime/2;
        pw3(k-1)=time(i)+Tr+deadTime/2;        %rise time
        pw4(k)=Vdd;
        pw4(k-1)=Vcc;
        k=k+2;
    end
    if((trigRef(i)-sineRef(i)<0) & (trigRef(i-1)-sineRef(i-1)>0))  
        pw1(k)=time(i)+deadTime/2;
        pw1(k-1)=time(i)+Tr+deadTime/2;        %rise time
        pw2(k)=Vdd;
        pw2(k-1)=Vcc;
        pw3(k)=time(i)- deadTime/2;
        pw3(k-1)=time(i)+Tf-deadTime/2;        %fall time
        pw4(k)=Vcc;
        pw4(k-1)=Vdd;
        k=k+2;
    end
 
end
    
% Writing csv file
HighGatePulse = [pw1.' pw2.'];
LowGatePulse = [pw3.' pw4.'];

writematrix(HighGatePulse,'HighGatePulse_PWL.csv'); %first column is time
writematrix(LowGatePulse,'LowGatePulse_PWL.csv'); %second column is waveform



