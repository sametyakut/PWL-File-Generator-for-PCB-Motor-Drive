% PWL Generator

% INPUTS
clc;
clear all;
clear;
close all;
f=500000;           % Switching Frequency
n=4;                % Total number of cycles
Tr=1e-9;            % Rise time
Tf=1e-9;            % Fall time
timeStep = 1e-9;   % minimum time step
waveType = 1 ;      % 0 = Constant duty
                    % 1 = Sine
duty = 0.5 ;        % for the constant duty waveType
fundamental = 1000 ; % fundamental frequency for the sine waveType
deadBand = 16e-9 ; % Deadtime should be low

Vdd = 1 ;           % 12V supply
Vcc = 0 ;           % reference of the Vdd
range = 0.90 ;      % duty range
phaseA = 120 ;       % phase difference in degree
phaseB = 240 ;      % phase difference in degree

totalTime = n/fundamental;

time = 0:timeStep:totalTime-timeStep;
   



trigRef= 0.5*sawtooth(2*pi*f*time,1/2)+0.5; % triangular wave
sineRefA = 0.5*range*sin(2*pi*fundamental*time)+0.5; % reference sinusoid for phase A
sineRefB = 0.5*range*sin(2*pi*fundamental*time+phaseA*pi/180)+0.5; % reference sinusoid for phase B
sineRefC = 0.5*range*sin(2*pi*fundamental*time+phaseB*pi/180)+0.5; % reference sinusoid for phase C 
    
    
% Generating PWL File, note that first point is assigned by user
pw1(1)=0 ;   % Phase A high side time array
pw2(1)=Vdd;  % Phase A high side PWM
pw3(1)=0 ;   % Phase A low side time array
pw4(1)=Vcc;  % Phase A low side PWM
pw5(1)=0 ;   % Phase B high side time array
pw6(1)=Vdd;  % Phase B high side PWM
pw7(1)=0 ;   % Phase B low side time array
pw8(1)=Vcc;  % Phase B low side PWM
pw9(1)=0 ;   % Phase C high side time array
pw10(1)=Vdd; % Phase C high side PWM
pw11(1)=0 ;  % Phase C low side time array
pw12(1)=Vcc; % Phase C low side PWM
    
k=3;
j=3;
l=3;
    
for i=2:length(time);

    % Generating phase A signals
    if ((trigRef(i)-sineRefA(i)>=0) & (trigRef(i-1)-sineRefA(i-1)<=0)) 
        pw1(k)=time(i)- deadBand/2;
        pw1(k-1)=time(i)-Tf-deadBand/2;        %fall time
        pw2(k)=Vcc;
        pw2(k-1)=Vdd;
        pw3(k)=time(i)+ deadBand/2;
        pw3(k-1)=time(i)-Tr+deadBand/2;        %rise time
        pw4(k)=Vdd;
        pw4(k-1)=Vcc;
        k=k+2;
    end

    if((trigRef(i)-sineRefA(i)<0) & (trigRef(i-1)-sineRefA(i-1)>0))
        pw1(k)=time(i)+deadBand/2;
        pw1(k-1)=time(i)-Tr+deadBand/2;        %rise time
        pw2(k)=Vdd;
        pw2(k-1)=Vcc;
        pw3(k)=time(i)- deadBand/2;
        pw3(k-1)=time(i)-Tf-deadBand/2;        %fall time
        pw4(k)=Vcc;
        pw4(k-1)=Vdd;
        k=k+2;
    end
        
    % Generating phase B signals
    if ((trigRef(i)-sineRefB(i)>=0) & (trigRef(i-1)-sineRefB(i-1)<=0)) % fall
        pw5(j)=time(i)- deadBand/2;
        pw5(j-1)=time(i)-Tf-deadBand/2;        %fall time
        pw6(j)=Vcc;
        pw6(j-1)=Vdd;
        pw7(j)=time(i)+ deadBand/2;
        pw7(j-1)=time(i)-Tr+deadBand/2;        %rise time
        pw8(j)=Vdd;
        pw8(j-1)=Vcc;
        j=j+2;
    end
    
    if((trigRef(i)-sineRefB(i)<0) & (trigRef(i-1)-sineRefB(i-1)>0))  %rise
        pw5(j)=time(i)+deadBand/2;
        pw5(j-1)=time(i)-Tr+deadBand/2;        %rise time
        pw6(j)=Vdd;
        pw6(j-1)=Vcc;
        pw7(j)=time(i)- deadBand/2;
        pw7(j-1)=time(i)-Tf-deadBand/2;        %fall time
        pw8(j)=Vcc;
        pw8(j-1)=Vdd;
        j=j+2;
    end
         
    % Generating phase C signals
    if ((trigRef(i)-sineRefC(i)>=0) & (trigRef(i-1)-sineRefC(i-1)<=0)) % fall
       pw9(l)=time(i)- deadBand/2;
       pw9(l-1)=time(i)-Tf-deadBand/2;        %fall time
       pw10(l)=Vcc;
       pw10(l-1)=Vdd;
       pw11(l)=time(i)+ deadBand/2;
       pw11(l-1)=time(i)-Tr+deadBand/2;        %rise time
       pw12(l)=Vdd;
       pw12(l-1)=Vcc;
       l=l+2;
    end
    
    if((trigRef(i)-sineRefC(i)<0) & (trigRef(i-1)-sineRefC(i-1)>0))  %rise
        pw9(l)=time(i)+deadBand/2;
        pw9(l-1)=time(i)-Tr+deadBand/2;        %rise time
        pw10(l)=Vdd;
        pw10(l-1)=Vcc;
        pw11(l)=time(i)- deadBand/2;
        pw11(l-1)=time(i)-Tf-deadBand/2;        %fall time
        pw12(l)=Vcc;
        pw12(l-1)=Vdd;
        l=l+2;
    end
    
end
    
% Adding last terms of signals to be completed, i.e, they should not include any
% impulse signal
pw1(length(pw1)+1) = totalTime;
pw2(length(pw2)+1) = pw2(length(pw2));

pw3(length(pw3)+1) = totalTime;
pw4(length(pw4)+1) = pw4(length(pw4));

pw5(length(pw5)+1) = totalTime;
pw6(length(pw6)+1) = pw6(length(pw6));

pw7(length(pw7)+1) = totalTime;
pw8(length(pw8)+1) = pw8(length(pw8));

pw9(length(pw9)+1) = totalTime;
pw10(length(pw10)+1) = pw10(length(pw10));

pw11(length(pw11)+1) = totalTime;
pw12(length(pw12)+1) = pw12(length(pw12));


% Generating final PWL matrices
PhaseA_H  = [pw1.' pw2.'];
PhaseA_L  = [pw3.' pw4.'];
PhaseB_H = [pw5.' pw6.'];
PhaseB_L = [pw7.' pw8.'];
PhaseC_H = [pw9.' pw10.'];
PhaseC_L = [pw11.' pw12.'];
   
    
% Writing PWL files, can be also written in csv format
writematrix(PhaseA_H,'PhaseA-H.txt');
writematrix(PhaseA_L,'PhaseA-L.txt');
writematrix(PhaseB_H,'PhaseB-H.txt');
writematrix(PhaseB_L,'PhaseB-L.txt');
writematrix(PhaseC_H,'PhaseC-H.txt');
writematrix(PhaseC_L,'PhaseC-L.txt');


