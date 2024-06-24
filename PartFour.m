close all
clear all
%%Fm for sin tone at 3KHz
%%Band Limited Signal
close all
clear all
%Read the audio 
[SignalT,Fs]=audioread("D:\Project\NewMessageSignall.wav");
Fs=48000;
%sound(SignalT,Fs)
%time Domain Signal
t=linspace(0,length(SignalT)/Fs,length(SignalT));
%Frequancy Domain
SignalF=abs(fftshift(fft(SignalT,length(SignalT)))/length(fft(SignalT)));
f=linspace(-Fs/2,Fs/2,length(SignalF));
%filtering the signal
order=12;
FCutOff=(3400/48000)*2;
[param1 param2]=butter(order,FCutOff,'low');
FilteredSignalT=filter(param1,param2,SignalT);
FilteredSignalF=abs(fftshift(fft(FilteredSignalT,length(FilteredSignalT)))/length(fft(FilteredSignalT)));

%FM Modulation
    %message Signal
Fm=3400;
FS=4*48000; %sampling frequancy
MessageSignal=interp(FilteredSignalT,4);
T=0:1/FS:10-1/FS;
n=length(MessageSignal);
F=(-n/2:n/2-1)*(FS/n);
MessageSignalF=abs(fftshift(fft(MessageSignal,length(MessageSignal))))/length(fft(MessageSignal));
    %Carrier Signal
Fc=48000;
CarrierSignal=cos(2*pi*Fc*T);
    %Modulated Signal
DeviationRatio=3;
FrequancyDeviation=DeviationRatio*Fm;
ModulatedSignal=fmmod(MessageSignal,Fc,FS,FrequancyDeviation);
ModulatedSignalF=abs(fftshift(fft(ModulatedSignal,length(ModulatedSignal))))/length(fft(ModulatedSignal));
n=length(ModulatedSignal);
F=(-n/2:n/2-1)*(FS/n);
%Adding Noise
SNRinDB=30;
SignalWithNoise=awgn(ModulatedSignal,SNRinDB,-3.0103)+ModulatedSignal;
SignalWithNoiseF=abs(fftshift(fft(SignalWithNoise,length(SignalWithNoise)))/length(fft(SignalWithNoise)));
%%Demodulation
RecievedSignal=SignalWithNoise;
DemodulatedSignal=fmdemod(RecievedSignal,Fc,FS,FrequancyDeviation);
%sound(DemodulatedSignal,FS)






%%% Calculate the beta threshold
DeviationRatio2=1;
FrequancyDeviation2=DeviationRatio2*Fm;
ModulatedSignal2=fmmod(MessageSignal,Fc,FS,FrequancyDeviation2);
ModulatedSignalF2=abs(fftshift(fft(ModulatedSignal2,length(ModulatedSignal2))))/length(fft(ModulatedSignal2));
n2=length(ModulatedSignal2);
FF=(-n2/2:n2/2-1)*(FS/n2);
%Adding Noise
SNRBBDB=7;
SNRBB=10^(SNRBBDB/10);
No=1/(2*SNRBB*Fm);
B2=Fc+0.5*(2*Fm*(1+DeviationRatio2))
SNRin2=1/(2*No*B2)
SNRinDB2=10*log10(SNRin2);
SignalWithNoise2=awgn(ModulatedSignal2,SNRinDB2,-3.0103)+ModulatedSignal2;
SignalWithNoiseF2=abs(fftshift(fft(SignalWithNoise2,length(SignalWithNoise2)))/length(fft(SignalWithNoise2)));
%%Demodulation
RecievedSignal2=SignalWithNoise2;
DemodulatedSignal2=fmdemod(RecievedSignal2,Fc,FS,FrequancyDeviation2);
%sound(DemodulatedSignal2,FS)
    %calculating the snro
mp=max(abs(MessageSignal));
SNRo2=3*((DeviationRatio2)^2)*0.5*SNRBB/(mp^2);
SNRoDb2=10*log10(SNRo2)
THRESHOLD=10*log10(20*(1+DeviationRatio2))

