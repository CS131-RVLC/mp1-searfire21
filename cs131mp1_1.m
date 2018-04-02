# Allan Matthew B. Mariano
# 2015-05804
# CS 131 WFY



################################################
#Part 2: Monomial Basis Interpolation
################################################

x =[
  0
  2.3
  4.9
  9.1
  13.7
  18.3
  22.9
  27.2
];
temp = [
  22.8
  22.8
  22.8
  20.6
  13.9
  11.7
  11.1
  11.1
];

function ret = first(x,a)
  ret =x*(x*(x*(x*(x*(x*7*a(8)+6*a(7))+5*a(6))+4*a(5))+3*a(4))+2*a(3))+a(2); 
endfunction


function ret = inflex(x,a)
  ret =x*(x*(x*(x*(x*42*a(8)+30*a(7))+20*a(6))+12*a(5))+6*a(4))+2*a(3); 
endfunction

function ret = inflex2(x,a)
  ret = x*(x*(x*(x*210*a(8)+120*a(7))+60*a(6))+24*a(5))+6*a(4); 
endfunction


function ret = cholesky(Tot,p)
  A = Tot'*Tot;
  b = Tot'*p;
  I  = eye(columns(A));
  s = columns(I);



  D = A;
  L = I;

  for j = 1:s-1
     M1 = I;
    for k=j+1:s
       M1(k,j) = -D(k,j)/D(j,j);
   end
    L = M1*L;
    D = M1*D;
  end


  D= diag(diag(D));

  L = inv(L);

  y = L\b;
  x = (D*L')\y;

  ret = x;
endfunction

#vandermonde matrix

x1 = [
  1 x(1) x(1)^2 x(1)^3 x(1)^4 x(1)^5 x(1)^6 x(1)^7
  1 x(2) x(2)^2 x(2)^3 x(2)^4 x(2)^5 x(2)^6 x(2)^7
  1 x(3) x(3)^2 x(3)^3 x(3)^4 x(3)^5 x(3)^6 x(3)^7
  1 x(4) x(4)^2 x(4)^3 x(4)^4 x(4)^5 x(4)^6 x(4)^7
  1 x(5) x(5)^2 x(5)^3 x(5)^4 x(5)^5 x(5)^6 x(5)^7
  1 x(6) x(6)^2 x(6)^3 x(6)^4 x(6)^5 x(6)^6 x(6)^7
  1 x(7) x(7)^2 x(7)^3 x(7)^4 x(7)^5 x(7)^6 x(7)^7
  1 x(8) x(8)^2 x(8)^3 x(8)^4 x(8)^5 x(8)^6 x(8)^7
]

# compute a0 - a7

ans = cholesky(x1, temp)

hehe = ans;

#plotting

j = linspace(0, 28);
for i = 1: 100
  y(i) = polyval(flipud(ans), j(i));
end

figure(1)
clf()
hold on;
xlabel("Depth (m)");
ylabel("Temperature ('C)");
title("Temperature vs Depth");
plot(x,temp, 'o')
plot(j,y, '-')
xlim([0,30])
ylim([-10,30])
hold off;

# getting inflection
temp = temp';

thermocline = 12.476;


curr = thermocline + (inflex(thermocline, ans)/inflex2(thermocline, ans));
old = curr;
err = curr;

while err > 0.01
  curr = thermocline - (inflex(thermocline, ans)/inflex2(thermocline, ans));
  err = abs(curr-old);
  old = curr;
  thermocline = curr;
endwhile

thermocline = curr

#getting the gradient

gradient = first(thermocline, ans)

#plotting the gradient

a = linspace(0, 30);
for i = 1: 100
  b(i) = first(a(i),ans);
end

figure(2)
clf()
xlabel("Depth (m)");
ylabel("Gradient ('C/m)");
title("Gradient vs Depth");
hold on;
plot(a,b, '-')
ylim([-5,5])
xlim([0,30])
hold off;

#get heat flux

heatflux = ((-0.01*(gradient/100))*86400)

