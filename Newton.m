clear;
clc;
n = input('jumlah variable independen: ');
for i = 1:n
    eval(sprintf('x%d = sym(''x%d'');', i, i))
end
f = input('f(x) : ');
var = symvar(f); %menentukan variable dalam fungsi f
g = gradient(f, var); %turunan fungsi f terhadap variable
for j = 1:size(g)
    gg(j,:) = [gradient(g(j), var)']; %turunan kedua fungsi f terhadap variable
end
f = symfun(f, var); %membuat fungsi f dengan input sejumlah variable
g = symfun(g, var); %membuat fungsi f dengan input sejumlah variable
gg = symfun(gg, var); %membuat fungsi f dengan input sejumlah variable
x0 = input('titik mulai: ');
x(1)= x0(1);
y(1)= x0(2);
xi = x0
i = 0;
epsilon = input('toleransi error : ');
fd = double(subs(g, var, xi));
norm_fd = norm(fd)
while norm_fd>epsilon
    disp(strrep(['Iteration: ' num2str(i+1, ' %0.2d') ], ',)', ')'))
    h = double(subs(gg, var, xi));
    d = -(inv(h)*fd);
    xi = xi+d'
    fd = double(subs(g, var, xi));
    i = i+1;
    x(i+1) = xi(1);
    y(i+1) = xi(2);
    norm_fd = norm(fd)
end
i=1:i; %menghapus titik mulai
fcontour(f);
hold on
plot(x,y,'o-r');
xlabel('x1')
ylabel('x2')
title('Plot showing Error convergence')
hold off
disp(strrep(['Solution is: [' num2str(xi, ' %0.1d') ']'], ',)', ')'))
