# C: Condicionales (si simple, compuesto, anidado)
x := 5;
si (x > 0) entonces escribir 'positivo'; fin_si;
si (x < 0) entonces escribir 'negativo'; fin_si;

x := 3;
si (x > 5) entonces escribir 'mayor'; si_no escribir 'menor o igual'; fin_si;
x := 7;
si (x > 5) entonces escribir 'mayor'; si_no escribir 'menor o igual'; fin_si;

x := 5;
si (x > 0) entonces
  si (x > 3) entonces escribir 'C'; si_no escribir 'B'; fin_si;
fin_si;
si (x > 10) entonces
  escribir 'nunca';
si_no
  si (x > 3) entonces escribir 'C'; fin_si;
fin_si;
