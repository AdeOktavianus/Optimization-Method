clear;
clc;
n = input('jumlah variable independen: ');
for i = 1:n
    eval(sprintf('x%d = sym(''x%d'');', i, i))
end
f = input('f(x) : ');
var = symvar(f); %menentukan variable dalam fungsi f
f = symfun(f, var); %membuat fungsi f dengan input sejumlah variable
g = gradient(f, var); %turunan fungsi f terhadap variable
syms flam(lam) %membuat fungsi phi yang berubah terhadap waktu
x0 = input('titik mulai: ');
x(1)= x0(1);
y(1)= x0(2);
xi = x0
i = 0;
d = -double(subs(g, var, xi));
norm_d = norm(d)
epsilon = input('toleransi error : ');
while norm_d>epsilon
    disp(strrep(['Iteration: [' num2str(i+1, ' %0.2d') ']'], ',)', ')'))
    t = xi + (lam*d');
    flam = (subs(f, var, t));
    flam = symfun(flam, lam);
    flam(lam) = simplify(flam); %menyederhanakan fungsi f(lamda)
    gradlam = diff(flam); %mendapatkan nilai lamda minimum
    ti = solve(gradlam, lam); %hasil yang diadapatkan
    ti = double(ti);  %mengubah bentuk data menjadi type double
    if real(ti) == 0 & imag(ti) ~= 0
        for j = 1:size(ti)
            for i = 1:size(ti)
                if imag(ti(j)) == -imag(ti(i))
                    ri = imag(ti)./0.000000001;
                end
            end
        end
    else
        ri = imag(ti)./real(ti);
    end
    ti(ri>1e-3) = [];%menghilangkan nilai yang sama(imajiner)
    ti = real(ti);
    temp = double(flam(ti)); %mendapatkan nilai minimum
    [~, te] = min((temp)); %memilih nilai minimum
    ti = ti(te); %memilih nilai lamda minimum
    
    i=i+1; %mengupdate iterasi
    xt = xi;
    xi = xi + ti*d' %mendapatkan nilai x selanjutnya
    a = double(subs(g, var, xi));
    b = double(subs(g, var, xt));
    d = -a +((norm(a))^2/(norm(b))^2)*d;
    norm_d = norm(d)
    x(i+1) = xi(1);
    y(i+1) = xi(2);
    if d == 0
        break; %karena xi merupakan penyelesaian
    elseif xt == xi
        break;
    end
end
i=1:i; %menghapus titik mulai
fcontour(f);
hold on
plot(x,y,'o-r');
xlabel('x1')
ylabel('x2')
title('Plot showing Error convergence')
hold off
disp(strrep(['Solution is: [' num2str(xi, ' %0.2d') ']'], ',)', ')'))