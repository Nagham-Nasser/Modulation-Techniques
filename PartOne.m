 clear all
 close all
% %Recording
% record2 = audiorecorder(48000,8,1);
% recDuration = 10;
% SampleRate=48000;
% disp("Begin speaking.")
% recordblocking(record2,recDuration);
% disp("End of recording.")
% Fs=48000;
% data=getaudiodata(record2);
% audiowrite("D:\Project\NewMessageSignal.wav",data,Fs)

% %Read the audio 
[SignalT,Fs]=audioread("D:\Project\NewMessageSignall.wav");
Fs=48000;
%sound(SignalT,Fs)

%time Domain Signal
t=linspace(0,length(SignalT)/Fs,length(SignalT));

%Frequancy Domain Signal
SignalF=abs(fftshift(fft(SignalT,length(SignalT)))/length(fft(SignalT)));
f=linspace(-Fs/2,Fs/2,length(SignalF));

%filtering the signal with cutt off frequancy =3400HZ
order=50;
FCutOff=(3400/48000)*2;
param1 =fir1(order,FCutOff,'low');
FilteredSignalT=filtfilt(param1,1,SignalT);
FilteredSignalF=abs(fftshift(fft(FilteredSignalT,length(FilteredSignalT)))/length(fft(FilteredSignalT)));
%sound(FilteredSignalT,Fs)

%with cutt off frequancy =700HZ
order=12;
FCutOff2=(700/48000)*2;
[param1 param2]=butter(order,FCutOff2,'low');
FilteredSignalT2=filter(param1,param2,SignalT);
FilteredSignalF2=abs(fftshift(fft(FilteredSignalT2,length(FilteredSignalT2)))/length(fft(FilteredSignalT2)));
%sound(FilteredSignalT2,Fs)

%%%%Letter f at word frog
    %Original
order=12;
[Frog,Fs]=audioread("D:\Project\f.wav");
Fs=48000;
%sound(Frog,Fs)
FrogF=abs(fftshift(fft(Frog,length(Frog)))/length(fft(Frog)));
tLetter=linspace(0,length(Frog)/Fs,length(Frog));
fLetter=linspace(-Fs/2,Fs/2,length(FrogF));
    %Filtered
FCutOfff=(1500/48000)*2;
[Pf1 Pf2]=butter(order,FCutOfff,'low');
FilteredFrog=filter(Pf1,Pf2,Frog);
FilteredFrogF=abs(fftshift(fft(FilteredFrog,length(FilteredFrog)))/length(fft(FilteredFrog)));
%sound(FilteredFrog,Fs)

%%%%Letter s at word Serious
    %Original
[Serious,Fs]=audioread("D:\Project\s.wav");
Fs=48000;
%sound(Serious,Fs)
SeriousF=abs(fftshift(fft(Serious,length(Serious)))/length(fft(Serious)));
    %Filtered
FCutOffs=(1500/48000)*2;
[Ps1 Ps2]=butter(order,FCutOffs,'low');
FilteredSerious=filter(Ps1,Ps2,Serious);
FilteredSeriousF=abs(fftshift(fft(FilteredSerious,length(FilteredSerious)))/length(fft(FilteredSerious)));
%sound(FilteredSerious,Fs)

%%%%Letter b at word banana
    %Original
[Banana,Fs]=audioread("D:\Project\b.wav");
Fs=48000;
%sound(Banana,Fs)
BananaF=abs(fftshift(fft(Banana,length(Banana)))/length(fft(Banana)));
    %Filtered
FCutOffb=(700/48000)*2;
[Pb1 Pb2]=butter(order,FCutOffb,'low');
FilteredBanana=filter(Pb1,Pb2,Banana);
FilteredBananaF=abs(fftshift(fft(FilteredBanana,length(FilteredBanana)))/length(fft(FilteredBanana)));
%sound(FilteredBanana,Fs)

%%%%Letter d at word defend
    %Original
[Defend,Fs]=audioread("D:\Project\d.wav");
Fs=48000;
%sound(Defend,Fs)
DefendF=abs(fftshift(fft(Defend,length(Defend)))/length(fft(Defend)));
    %Filtered
FCutOffd=(700/48000)*2;
[Pb1 Pb2]=butter(order,FCutOffd,'low');
FilteredDefend=filter(Pb1,Pb2,Defend);
FilteredDefendF=abs(fftshift(fft(FilteredDefend,length(FilteredDefend)))/length(fft(FilteredDefend)));
%sound(FilteredDefend,Fs)

%%%Letter m at word monkey
    %Original
[Monkey,Fs]=audioread("D:\Project\m.wav");
Fs=48000;
%sound(Monkey,Fs)
MonkeyF=abs(fftshift(fft(Monkey,length(Monkey)))/length(fft(Monkey)));
    %Filtered
FCutOffm=(1000/48000)*2;
[Pm1 Pm2]=butter(order,FCutOffm,'low');
FilteredMonkey=filter(Pm1,Pm2,Monkey);
FilteredMonkeyF=abs(fftshift(fft(FilteredMonkey,length(FilteredMonkey)))/length(fft(FilteredMonkey)));
%sound(FilteredMonkey,Fs)

%%%Letter n at word normal
    %Original
[Normal,Fs]=audioread("D:\Project\n.wav");
Fs=48000;
%sound(Normal,Fs)
NormalF=abs(fftshift(fft(Normal,length(Normal)))/length(fft(Normal)));
    %Filtered
FCutOffn=(1000/48000)*2;
[Pn1 Pn2]=butter(order,FCutOffn,'low');
FilteredNormal=filter(Pn1,Pn2,Normal);
FilteredNormalF=abs(fftshift(fft(FilteredNormal,length(FilteredNormal)))/length(fft(FilteredNormal)));
%sound(FilteredNormal,Fs)

%%%%DSB_LC Modulation
    %Message Signal m(t)
FS=4*48000; %sampling frequancy
MessageSignal=interp(FilteredSignalT,4);
T=0:1/FS:10-1/FS;
n=length(MessageSignal);
F=(-n/2:n/2-1)*(FS/n);
MessageSignalF=abs(fftshift(fft(MessageSignal,length(MessageSignal))))/length(fft(MessageSignal));
%sound (MessageSignal,FS)
    %the Carries c(t)
Fc=48000;
CarrierSignal=cos(2*pi*Fc*T);
CarrierSignalF=abs(fftshift(fft(CarrierSignal))/length(fft(CarrierSignal)));
    %The Modulated Signal
modulation_index=0.8;
mp=max(abs(FilteredSignalT));
Ac=mp/modulation_index;
ModulatedSignal=(Ac+MessageSignal).*CarrierSignal';
ModulatedSignalF=abs(fftshift(fft(ModulatedSignal))/length(fft(ModulatedSignal)));

%%Demodulation
RecievedSignal=ModulatedSignal;
RectifierSignal=RecievedSignal.* ( RecievedSignal> 0);
FcLowPassFilter=(3400/FS)*2;
P1 =fir1(50,FcLowPassFilter,'low');
DemodulatedSignal=filtfilt(P1,1,RectifierSignal);
DemodulatedSignal=DemodulatedSignal-Ac/4;
DemodulatedSignal=DemodulatedSignal*4.264;
DemodulatedSignalF=abs(fftshift(fft(DemodulatedSignal))/length(fft(DemodulatedSignal)));
%sound(DemodulatedSignal,FS)


%%%%Energy
EnergyOfSignal= sum(FilteredSignalF.^2);
EnergyOfDemodulated=sum(DemodulatedSignalF.^2);


%%%Plotting
 x=3;
 y=6;
figure
subplot(x,y,1)
plot(t,SignalT)
title("Message Signal in Time Domain")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('Message')
subplot(x,y,2)
plot(t,FilteredSignalT)
title("Filtered Message in Time Domain")
xlabel("Time (S)")
ylabel("Amplitude (V)")
legend('Filtered Message')
subplot(x,y,3)
plot(t,FilteredSignalT2)
title("Filtered Message in Time Domain with Fc=700HZ")
xlabel("Time (s)")
ylabel("Amplitude(v)")
legend("message at Fc=700HZ")
subplot(x,y,4)
plot(tLetter,Frog)
title("F in Frog Time Domain")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('F')
subplot(x,y,5)
plot(tLetter,FilteredFrog)
title("F in Frog Time Domain with Fc=1500Hz")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('F at Fc=1500HZ')
subplot(x,y,6)
plot(tLetter,Serious)
title("S in Serious Time Domain")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('S')
subplot(x,y,7)
plot(tLetter,FilteredSerious)
title("S in Serious Time Domain with Fc=1500Hz")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('S at Fc=1500Hz')
subplot(x,y,8)
plot(tLetter,Banana)
title("B in Banana Time Domain ")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('B')
subplot(x,y,9)
plot(tLetter,FilteredBanana)
title("B in Banana Time Domain with Fc=700Hz")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('B at Fc=700Hz')
subplot(x,y,10)
plot(tLetter,Defend)
title("D in Defend Time Domain")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('D')
subplot(x,y,11)
plot(tLetter,FilteredDefend)
title("D in Defend Time Domain with Fc=700Hz")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('D at Fc=700Hz')
subplot(x,y,12)
plot(tLetter,Monkey)
title("M in Monkey Time Domain")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('M')
subplot(x,y,13)
plot(tLetter,FilteredMonkey)
title("M in Monkey Time Domain with Fc=1000Hz")
xlabel("Time(s)")
ylabel("Amplitude (V)")
legend('M at Fc=1000Hz')
subplot(x,y,14)
plot(tLetter,Normal)
title("N in Normal Time Domain")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('N')
subplot(x,y,15)
plot(tLetter,FilteredNormal)
title("N in Normal Time Domain with Fc=1000Hz")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('N at Fc=1000Hz')
subplot(x,y,16)
plot(T,ModulatedSignal)
title("The Modulated Signal in Time Domain")
xlabel("Time(s)")
ylabel("Amplitude (v) ")
legend('Modulated')
%xlim([1.9 1.9009])
subplot(x,y,17)
plot(T,DemodulatedSignal)
title("Demodulated Signal in Time Domain")
xlabel("Time(s)")
ylabel("Amplitude(V)")
legend('Demodulated Signal')

figure
subplot(x,y,1)
plot(f,SignalF)
title("Message Signal in Frequancy Domain")
xlabel("Frequancy (Hz)")
ylabel("Amplitude ")
legend('Message')
subplot(x,y,2)
plot(f,FilteredSignalF)
title("Filtered Message in Frequancy Domain")
xlabel("Frequancy (Hz)")
ylabel("Amplitude ")
legend('Filtered Message')
subplot(x,y,3)
plot(f,FilteredSignalF2)
title("filtered Message in Frequancy Domain with Fc=700HZ")
xlabel("Frequancy")
ylabel("Amplitude")
legend("message at Fc=700HZ")

subplot(x,y,4)
plot(fLetter,FrogF)
title("F in Frog Frequancy Domain")
xlabel("Frequancy (Hz)")
ylabel("Amplitude")
legend('F')
subplot(x,y,5)
plot(fLetter,FilteredFrogF)
title("F in Frog Frequancy Domain with Fc=1500Hz")
xlabel("Frequancy (Hz)")
ylabel("Amplitude")
legend('F at Fc=1500Hz')
subplot(x,y,6)
plot(fLetter,SeriousF)
title("S in Serious Frequancy Domain")
xlabel("Frequancy (Hz)")
ylabel("Amplitude")
legend('S')
subplot(x,y,7)
plot(fLetter,FilteredSeriousF)
title("S in Serious Frequancy Domain with Fc=1500Hz")
xlabel("Frequancy (Hz)")
ylabel("Amplitude")
legend('S at Fc=1500Hz')
subplot(x,y,8)
plot(fLetter,BananaF)
title("B in Banana Frequency Domain ")
xlabel("Frequency(Hz)")
ylabel("Amplitude")
legend('B')
subplot(x,y,9)
plot(fLetter,FilteredBananaF)
title("B in Banana Frequency Domain with Fc=700Hz")
xlabel("Frequency(Hz)")
ylabel("Amplitude")
legend('B at Fc=700Hz')
subplot(x,y,10)
plot(fLetter,DefendF)
title("D in Defend Frequency Domain")
xlabel("Frequency(Hz)")
ylabel("Amplitude")
legend('D')
subplot(x,y,11)
plot(fLetter,FilteredDefendF)
title("D in Defend Frequency Domain with Fc=700Hz")
xlabel("Frequency(Hz)")
ylabel("Amplitude")
legend('D at Fc=700Hz')
subplot(x,y,12)
plot(fLetter,MonkeyF)
title("M in Monkey Frequancy Domain")
xlabel("Frequancy(Hz)")
ylabel("Amplitude")
legend('M')
subplot(x,y,13)
plot(fLetter,FilteredMonkeyF)
title("M in Monkey Frequancy Domain with Fc=1000Hz")
xlabel("Frequancy(Hz)")
ylabel("Amplitude ")
legend('M at Fc=1000Hz')
subplot(x,y,14)
plot(fLetter,NormalF)
title("N in Normal Frequancy Domain")
xlabel("Frequancy(Hz)")
ylabel("Amplitude")
legend('N')
subplot(x,y,15)
plot(fLetter,FilteredNormalF)
title("N in Normal Frequancy Domain with Fc=1000Hz")
xlabel("Frequancy(Hz)")
ylabel("Amplitude")
legend('N at Fc=1000Hz')
subplot(x,y,16)
plot(F,ModulatedSignalF)
title("The Modulated Signal in Frequancy Domain")
xlabel("Frequency (Hz)")
ylabel("Amplitude  ")
legend('Modulated')
%ylim([0 0.006])
subplot(x,y,17)
plot(F,DemodulatedSignalF)
title("Demodulated Signal in Frequency Domain")
xlabel("Frequency(Hz)")
ylabel("Amplitude ")
legend('Demodulated Signal')
