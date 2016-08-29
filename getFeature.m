%parameters
interval=128;
channels=2;
%read from xlsx
source=xlsread('test1.xlsx');
source=source(:,2:3);
[Y X]=size(source);
%FFT Transform
NSamples=floor(Y/interval);
result=zeros(NSamples,X);
%feature1: domaint frequency
for j=1:X
    for i=1:NSamples
        time_domain=source((i-1)*interval+1:i*interval,j);
        frequency_domain=fft(time_domain);
        amplitude=abs(frequency_domain);
        %amplitude2=amplitude.*amplitude;
        alpha(i,j)=sum(amplitude(10:13))/4;
        beta(i,j)=sum(amplitude(14:26))/13;
        ratio(i,j)=alpha(i,j)/beta(i,j);
        result(i,j)=ratio(i,j);
    end
end
%feature2: Average power of domaint peak
for j=1:X
    for i=1:NSamples
        if result(i,j)>1
            feature2(i,j)=alpha(i,j);
        else
            feature2(i,j)=beta(i,j);
        end
    end
end
%feature3: CGF
result2=zeros(NSamples,X);
temp=zeros(NSamples,X);
power=zeros(NSamples,30,X);
sumpower=zeros(NSamples,30,X);
 for j=1:X
    for i=1:NSamples
        for k=1:30
            time_domain=source((i-1)*interval+1:i*interval,j);
            frequency_domain=fft(time_domain);
            amplitude=abs(frequency_domain);
            power(i,k,j)=amplitude(k);
        end
    end
 end
 
for j=1:X
    for i=1:NSamples
        for k=1:30
            temp(i,j)=temp(i,j)+power(i,k,j)*k;
            sumpower(i,j)=sumpower(i,k,j)+power(i,k,j);
        end
    end
end

for j=1:X
    for i=1:NSamples
        result2(i,j)=temp(i,j)/sumpower(i,j);
    end
end
%feature4: frequency variability
result3=zeros(NSamples,X);
temp2=zeros(NSamples,X);

for j=1:X
    for i=1:NSamples
        for k=1:30
            temp2(i,j)=temp2(i,j)+power(i,k,j)*k*k;
        end
    end
end
for j=1:X
    for i=1:NSamples
        result3(i,j)=(temp2(i,j)+temp(i,j)*temp(i,j)/sumpower(i,j))/sumpower(i,j);
    end
end