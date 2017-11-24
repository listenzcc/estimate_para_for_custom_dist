function para_guess = myfit(x, y)

save tmp x y
para     = [0 1 1 0.5 0.5];
para_bot = [min(x), 0, 0, 0, 0];
para_top = [max(x), max(abs(x)), max(abs(x)), 1, 1];

para_guess = fmincon(@myloss, para, [], [], [0 0 0 1 1], 1, para_bot, para_top);

end

function loss = myloss(p)

load tmp

myfix = @(x) ([x(2:end)-x(1:end-1);((max(x)-min(x))/size(x, 1))]);
mycustom = @(x, m, s, l, a, b) (a*(exp(-(x-m).^2/(2*s^2))/(s*sqrt(2*pi))) + b*(x>0).*exp(-l*x)/l) .* myfix(x);

err = y - mycustom(x, p(1), p(2), p(3), p(4), p(5));
loss = norm(err);

end