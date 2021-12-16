pkg load instrument-control %load serial comms package
arduino=serialport("COM4", 115200); %setup arduino on COM4 at 115200 baud
configureTerminator(arduino, "cr"); %set terminator carriage return
pkg load signal;
data=dataTransfer(arduino,1500); %calls data transfer function
if_cnt = 0;

x=data(:,1)*10^-3; %time (in seconds)
y=data(:,2); %output ADC count
temp=data(:,3); %temperature (converted to oC in arduino)

b = fir1(length(y), [0.01,0.08], "bandpass");
y = filter(b,1,y);

len = length(y);
x = x(round(len/2):end);
y = y(round(len/2):end);
plot(x,1024-y)
set(gca,'FontSize',20)
xlabel('Time (s)','FontSize',20)
ylabel('ADC output (AU)','FontSize',20)

%peak detection
y1=1024-y;
peaks = findpeaksx(x,y,0.7*10^-2,16,0.7*5^-2,1,1);
peak_x=peaks(:,2);
Time = zeros(1,length(peak_x)-1);
if length(peak_x) > 2
 if_cnt = if_cnt + 1;
 for i=1:(length(peak_x)-1)
   time=peak_x(i+1)-peak_x(i);
   Time(i)=time;
 end
TimE=mean(Time);
BPM=(1/TimE)*60; %beats per minute from peak detection
BPMR=round(BPM);
 end
 %find sampling frequency
for i=1:(length(x)-1)
   av=x(i+1)-x(i);
   AV(i)=av;
 end
timestep=mean(AV);
sampling_freq=1/timestep; % sampling frequency

%windowing
w=hann(length(y),'periodic');
y_w=y.*w;

%FFT
m=length(y_w); %original sample length
n=pow2(4+nextpow2(m)); %transform length of data vector by adding trailing zeros
y1=fft(y_w,n); %Discrete Fourier Transform of signal
f=(0:n-1)*(sampling_freq/n); %Frequency
power=(abs(y1).^2)/n; 

up=find(f >(sampling_freq/2));
power=power(1:up(1));
f=f(1:up(1));
peak=max(power);
a=find(power==peak);
frequency=f(a);
bpm=frequency*60; %beats per minute for FFT
bpmr=round(bpm);

xtextpeak=0.1*length(x); 
xtextfft=0.4*length(x);
xtexttemp=0.8*length(x);
ytext=max(y)+(0.1*max(y));

text(xtextpeak,ytext,[num2str(BPMR) ' beats per minute (from peak detection)'],'FontSize',30,'Color','Red');
text(xtextfft,ytext,[num2str(bpmr) ' beats per minute (from FFT)'],'FontSize',30,'Color','Magenta');
text(xtexttemp,ytext,['Body temperature = ' num2str(temp) '^oC','FontSize',30,'Color','Green']);

clear arduino
