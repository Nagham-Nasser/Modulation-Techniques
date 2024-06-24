%%Band Limited Signal
close all
clear all
%Read the audio 
[SignalT,Fs]=audioread("D:\Project\NewMessageSignall.wav");
Fs=48000;
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
%%%%DSB_SC Modulation
    %Message Signal m(t)
FS=4*48000; %sampling frequancy
MessageSignal=interp(FilteredSignalT,4);
T=0:1/FS:10-1/FS;
n=length(MessageSignal);
F=(-n/2:n/2-1)*(FS/n);
MessageSignalF=abs(fftshift(fft(MessageSignal,length(MessageSignal))))/length(fft(MessageSignal));
    %Carrier Signal C(t)
Fc=48000;
CarrierSignal=cos(2*pi*Fc*T);
    %Modulated Signal S(t)
ModulatedSignal=MessageSignal.*CarrierSignal';
ModulatedSignalF=abs(fftshift(fft(ModulatedSignal,length(ModulatedSignal))))/length(fft(ModulatedSignal));

%Coherant Demodulation + LowPassFilter
RecievedSignal=ModulatedSignal;
DemodulatedSignal=RecievedSignal.*CarrierSignal';
FCutOff=3400/FS;
Parameter=fir1(50,FCutOff,'low');
DemodulatedFilteredSignalT=filtfilt(Parameter,1,DemodulatedSignal);
DemodulatedFilteredSignalF=abs(fftshift(fft(DemodulatedFilteredSignalT,length(DemodulatedFilteredSignalT)))/length(fft(DemodulatedFilteredSignalT)));


%Frequancy Offset
FrequancyOffset=7000;
NewCarrier=cos(2*pi*(Fc+FrequancyOffset)*T);
NewDemodulatedSignal=RecievedSignal.*NewCarrier';
NewFCutOff=3400/FS;
NewParameter=fir1(50,NewFCutOff,'low');
NewDemodulatedFilteredSignalT=filtfilt(NewParameter,1,NewDemodulatedSignal);
NewDemodulatedFilteredSignalF=abs(fftshift(fft(NewDemodulatedFilteredSignalT,length(NewDemodulatedFilteredSignalT)))/length(fft(NewDemodulatedFilteredSignalT)));
%sound(NewDemodulatedFilteredSignalT,FS)
% figure
% plot(T,NewDemodulatedFilteredSignalT)
% title("Demodulated Signal with Distortion in Time Domain")
% xlabel("Time(s)")
% ylabel("Amplitude (V) ")
% legend('Signal with Distortion')
% figure
% plot(F,NewDemodulatedFilteredSignalF)
% title("New Demodulated Signal with Distortion in Frequency Domain")
% xlabel("Frequency (Hz)")
% ylabel("Amplitude  ")
% legend('Signal with Distortion')

%%%Single Side Band
    %Hilbert Transform
HilbertMessage=imag(hilbert(MessageSignal));
    %Carrier Signal
Fc=48000;
CarrierSignal1=cos(2*pi*Fc*T);
CarrierSignal2=sin(2*pi*Fc*T);
    %Modulated Signal
ModulatedSignalSSB=MessageSignal.*CarrierSignal1'- HilbertMessage.*CarrierSignal2';
ModulatedSignalSSBF=abs(fftshift(fft(ModulatedSignalSSB,length(ModulatedSignalSSB)))/length(fft(ModulatedSignalSSB)));

%SSB Demodulation
RecievedSSB=ModulatedSignalSSB;
DemodulatedSpectra=RecievedSSB.*CarrierSignal1';
DemodulatedHilbertspectra=RecievedSSB.*CarrierSignal2';
NewFCutOff=3400/FS;
ParSSB=fir1(50,NewFCutOff,'low');
DemodulatedMessage=filtfilt(ParSSB,1,DemodulatedSpectra);
DemodulatedHilbert=filtfilt(ParSSB,1,DemodulatedHilbertspectra);
DemodulatedMessageF=abs(fftshift(fft(DemodulatedMessage,length(DemodulatedMessage)))/length(fft(DemodulatedMessage)));
%sound(DemodulatedMessage,FS)

%Frequancy Offset
FrequencuOffset2=6000;
NewCarrierSignal1=cos(2*pi*(Fc+FrequencuOffset2)*T);
NewCarrierSignal2=sin(2*pi*(Fc+FrequencuOffset2)*T);
RecievedSSB=ModulatedSignalSSB;
NewDemodulatedSpectra=RecievedSSB.*NewCarrierSignal1';
NewDemodulatedHilbertspectra=RecievedSSB.*NewCarrierSignal2';
NewFCutOff=3400/FS;
NewParSSB=fir1(50,NewFCutOff,'low');
NewDemodulatedMessage=filtfilt(NewParSSB,1,NewDemodulatedSpectra);
NewDemodulatedHilbert=filtfilt(NewParSSB,1,NewDemodulatedHilbertspectra);
%sound(NewDemodulatedMessage,FS)
NewDemodulatedMessageF=abs(fftshift(fft(NewDemodulatedMessage,length(NewDemodulatedMessage)))/length(fft(NewDemodulatedMessage)));
% figure
% plot(T,NewDemodulatedMessage)
% title("Demodulated SSB with Distortion")
% xlabel("Time(s)")
% ylabel("Amplitude (V) ")
% legend('Signal with Distortion')
% figure
% plot(F,NewDemodulatedMessageF)
% title("Demodulated SSB with Distortion")
% xlabel("Frequency (Hz)")
% ylabel("Amplitude  ")
% legend('Signal with Distortion')



x=2;
y=2;
figure
subplot(x,y,1)
plot(T,ModulatedSignal)
title("Modulated Signal in Time Domain")
xlabel("Time (s)")
ylabel("Amplitude (V) ")
legend('DSB-SC Signal')
subplot(x,y,2)
plot(T,DemodulatedFilteredSignalT)
title("Demodulated Signal in Time Domain")
xlabel("Time (s)")
ylabel("Amplitude (V) ")
legend('Demodulated DSB-SC Signal')
subplot(x,y,3)
plot(T,ModulatedSignalSSB)
title("Modulated Signal in Time Domain")
xlabel("Time(s)")
ylabel("Amplitude (V) ")
legend('SSB Modulated')
subplot(x,y,4)
plot(T,DemodulatedMessage)
title("Demodulated Signal in Time Domain")
xlabel("Time(s)")
ylabel("Amplitude (V) ")
legend('Demodulated SSB Signal')


 

figure
subplot(x,y,1)
plot(F,ModulatedSignalF)
title("Modulated Signal in Frequancy Domain")
xlabel("Frequency (Hz)")
ylabel("Amplitude  ")
legend('DSB-SC Signal')
subplot(x,y,2)
plot(F,DemodulatedFilteredSignalF)
title("Demodulated Signal in Frequency Domain")
xlabel("Frequency (Hz)")
ylabel("Amplitude  ")
legend('Demodulated DSB-SC Signal')
subplot(x,y,3)
plot(F,ModulatedSignalSSBF)
title(" Modulated Signal in Frequency Domain") 
xlabel("Frequency (Hz)")
ylabel("Amplitude  ")
legend('SSB Modulated')
subplot(x,y,4)
plot(F,DemodulatedMessageF)
title("Demodulated Signal in Frequency Domain")
xlabel("Frequency (Hz)")
ylabel("Amplitude  ")
legend('Demodulated SSB Signal')




