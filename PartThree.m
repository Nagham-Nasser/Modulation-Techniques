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
DeviationRatio1=5;
DeviationRatio2=3;
FrequancyDeviation1=DeviationRatio1*Fm;
FrequancyDeviation2=DeviationRatio2*Fm;
ModulatedSignal1=fmmod(MessageSignal,Fc,FS,FrequancyDeviation1);
ModulatedSignalF1=abs(fftshift(fft(ModulatedSignal1,length(ModulatedSignal1))))/length(fft(ModulatedSignal1));
ModulatedSignal2=fmmod(MessageSignal,Fc,FS,FrequancyDeviation2);
ModulatedSignalF2=abs(fftshift(fft(ModulatedSignal2,length(ModulatedSignal2))))/length(fft(ModulatedSignal2));
n=length(ModulatedSignal1);
F=(-n/2:n/2-1)*(FS/n);

%%Demodulate by Direct Method
    %With B=5
RecievedSignal1=ModulatedSignal1;
b=0.5*(2*Fm*(1+DeviationRatio1));
f=(Fc+b)*2/FS;
[v vv]=butter(20,f,'low');
RecievedSignal1=filter(v,vv,RecievedSignal1);
DerivativeSignal1=diff(RecievedSignal1);
RectifierSignal1=DerivativeSignal1.* ( DerivativeSignal1> 0);
FCutOff2=(Fm/Fs)*2;
[PP1 PP2]=butter(20,FCutOff2,'low');
DemodulatedSignal1=filter(PP1,PP2,RectifierSignal1);
DemodulatedSignalF1=abs(fftshift(fft(DemodulatedSignal1,length(DemodulatedSignal1)))/length(fft(DemodulatedSignal1)));
NewT=0:1/FS:10-2/FS;
NewF=(-n/2:n/2-2)*(FS/n);
     %With B=3
RecievedSignal2=ModulatedSignal2;
b2=0.5*(2*Fm*(1+DeviationRatio2));
f2=(Fc+b2)*2/FS;
[v2 vv2]=butter(20,f2,'low');
RecievedSignal2=filter(v2,vv2,RecievedSignal2);
DerivativeSignal2=diff(RecievedSignal2);
RectifierSignal2=DerivativeSignal2.* ( DerivativeSignal2> 0);
FCutOff2=(Fm/Fs)*2;
[PP12 PP22]=butter(20,FCutOff2,'low');
DemodulatedSignal2=filter(PP12,PP22,RectifierSignal2);
DemodulatedSignalF2=abs(fftshift(fft(DemodulatedSignal2,length(DemodulatedSignal2)))/length(fft(DemodulatedSignal2)));
%sound(DemodulatedSignal1,Fs)
%sound(DemodulatedSignal2,Fs)

%%Fm for single tone at 3KHz
Fm=3000;
Fc=48000;
FFSS=167*Fm;
DeviationRatio=5;
tt=0:1/FFSS:5;
Tone=cos(pi*Fm*tt);
modulatedcos=fmmod(Tone,Fc,FFSS,Fm*DeviationRatio);
modulatedcosF=abs(fftshift(fft(modulatedcos,length(modulatedcos)))/length(fft(modulatedcos)));
nn=length(modulatedcos);
FF=(-nn/2:nn/2-1)*(FFSS/nn);

    %B=3
DeviationRatio2=3;
modulatedcos2=fmmod(Tone,Fc,FFSS,Fm*DeviationRatio);
modulatedcosF2=abs(fftshift(fft(modulatedcos,length(modulatedcos)))/length(fft(modulatedcos)));



x=2;
y=2;
figure
subplot(x,y,1)
plot(T,ModulatedSignal1)
title("FM Modulated Signal with B=5")
xlabel("Time (S))")
ylabel("Amplitude (V) ")
legend('FM Modulated')
%xlim([3.9 3.9005])
xlim([1.9 1.901])
subplot(x,y,2)
plot(T,ModulatedSignal2)
title("FM Modulated Signal with B=3")
xlabel("Time (S))")
ylabel("Amplitude (V) ")
legend('FM Modulated')
%xlim([3.9 3.9005])
xlim([1.9 1.901])
% subplot(x,y,3)
% plot(NewT,DemodulatedSignal2)
% title("FM DeModulated Signal with B=3")
% xlabel("Time (S))")
% ylabel("Amplitude (V) ")
% legend('FM DeModulated')
% subplot(x,y,4)
% plot(NewT,DemodulatedSignal1)
% title("FM DeModulated Signal with B=5")
% xlabel("Time (S))")
% ylabel("Amplitude (V) ")
% legend('FM DeModulated')
subplot(x,y,3)
plot(tt,modulatedcos)
title("Single Tone Modulation")
xlabel("Time (S))")
ylabel("Amplitude (V) ")
legend('Single Tone')
xlim([0 0.0009])
subplot(x,y,4)
plot(tt,modulatedcos2)
title("Single Tone Modulation with b=3")
xlabel("Time (S))")
ylabel("Amplitude (V) ")
legend('Single Tone b=3')
xlim([0 0.0009])





figure
subplot(x,y,1)
plot(F,ModulatedSignalF1)
title("FM Modulated Signal with B=5")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
legend('FM Modulated')
%ylim([0 0.000005])
subplot(x,y,2)
plot(F,ModulatedSignalF2)
title("FM Modulated Signal with B=3")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
legend('FM Modulated')
ylim([0 0.05])
%figure
% plot(NewF,DemodulatedSignalF2)
% title("FM DeModulated Signal with B=3")
% xlabel("Frequency (Hz)")
% ylabel("Amplitude (V) ")
% legend('FM DeModulated')
% plot(NewF,DemodulatedSignalF1 )
% title("FM DeModulated Signal with B=5")
% xlabel("Frequency (Hz)")
% ylabel("Amplitude (V) ")
% legend('FM DeModulated')
subplot(x,y,3)
plot(FF,modulatedcosF)
title("Single Tone Modulation")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
legend('Single Tone')
subplot(x,y,4)
plot(FF,modulatedcosF2)
title("Single Tone Modulation with B=3")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
legend('Single Tone b=3')












