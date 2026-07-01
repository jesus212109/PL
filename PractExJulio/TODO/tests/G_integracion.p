# G: Integracion (factorial, cambio tipo, incremento, validacion)
n := 5;
fact := 1;
para i desde 1 hasta n hacer
  fact := fact * i;
fin_para;
escribir fact;

x := 42;
escribir x;
x := 'ahora soy string';
escribir x;

x := 5;
++x;
escribir x;
x++;
escribir x;
--x;
escribir x;
x--;
escribir x;

x := 10;
y := 3;
s := x + y;
r := x - y;
m := x * y;
d := x / y;
di := x // y;
mod := x mod y;
escribir s;
escribir r;
escribir m;
escribir d;
escribir di;
escribir mod;
escribir x > y;
escribir x <= y;
escribir x = 10;
escribir x <> 5;
escribir (x > 5) y (y < 5);
escribir (x > 5) o (y > 5);
escribir no (x = y);
