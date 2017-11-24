close all
clear
clc

n = 10000; % num of samples
szp = 50; % pooling size
m = .5; % mean of norm dist
s = .1; % std of norm dist
l = .9; % lambda of exp dist

%% matlab made norm dist data
madata = m + randn(n, 1) * s; % data of custom dist

%% my custom dist
myfix = @(x) ([x(2:end)-x(1:end-1);((max(x)-min(x))/size(x, 1))]);
mycustom = @(x, m, s) (exp(-(x-m).^2/(2*s^2)) / (s*sqrt(2*pi))) .* myfix(x);
mycustom = @(x, m, s, l) ((exp(-(x-m).^2/(2*s^2))/(s*sqrt(2*pi))) + (x>0).*exp(-l*x)/l) .* myfix(x);

%% I made custom dist data
pp = linspace(m-5*s, m+10*s, szp)';
xseed = mycustom(pp, m, s, l);
xseed = ceil(xseed * n);
mydata = [];
for j = 1 : szp
    tmp = zeros(xseed(j), 1);
    tmp = tmp + (2*rand(size(tmp))-1)*pp(j)/10;
    mydata = [mydata; pp(j)+tmp];
end

%% hist
data = mydata;
[dist_sample, p]= hist(data, szp);
dist_sample = dist_sample / n; % normalize
sum(dist_sample)

figure
hold on
bar(p, dist_sample)
line = plot(p, mycustom(p', m, s, l), 'r');
set(line, 'LineWidth', 2)
hold off

% return
%% fit
para_guess = myfit(p', dist_sample')
hold on
line = plot(p, mycustom(p', para_guess(1), para_guess(2), para_guess(3)), 'k');
set(line, 'LineWidth', 2)
hold off

colormap('cool')

