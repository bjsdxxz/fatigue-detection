%parameters
interval=128;
channels=14;
relax_begin=60;
relax_end=540;
fatigue_begin=1800;
fatigue_end=2400;
%read from csv
%filename='hanxu.csv';
%source=csvread(filename,1,2);
%source=source(:,1:14);
source=EEG.data;
[Y X]=size(f3);
%FFT Transform
NSamples=floor(Y/interval);
result=zeros(NSamples,1);
for j=1:1
    for i=1:NSamples
        time_domain=f3((i-1)*interval+1:i*interval,j);
        frequency_domain=fft(time_domain);
        amplitude=abs(frequency_domain);
        %amplitude2=amplitude.*amplitude;
        theta(i)=sum(amplitude(6:9))/4;
        alpha(i)=sum(amplitude(10:13))/4;
        beta(i)=sum(amplitude(14:26))/13;
        ratio(i)=(theta(i)+alpha(i))/beta(i);
        result(i,j)=ratio(i);
    end
end
%change format
file=fopen('hanxu.txt','w+');
for i=relax_begin:relax_end
    fprintf(file,'+1 ');
    for j=1:channels
        if j==channels
            fprintf(file,'%d:%f\r\n',j,result(i,j));
        else
            fprintf(file,'%d:%f ',j,result(i,j));
        end
    end
end
for i=fatigue_begin:fatigue_end
    fprintf(file,'-1 ');
    for j=1:channels
        if j==channels
            fprintf(file,'%d:%f\r\n',j,result(i,j));
        else
            fprintf(file,'%d:%f ',j,result(i,j));
        end
    end
end
fclose(file);