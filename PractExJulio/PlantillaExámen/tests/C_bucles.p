# C: Bucles (mientras, hacer-mientras, repetir, para, selector)
x := 1;
mientras (x <= 5) hacer
  escribir x;
  x := x + 1;
fin_mientras;
escribir 'fin mientras';

x := 1;
hacer {
  escribir x;
  x := x + 1;
} mientras (x <= 3);
escribir 'fin hacer-mientras';

x := 1;
repetir
  escribir x;
  x := x + 1;
hasta_que (x > 5);
escribir 'fin repetir';

escribir 'inicio para';
para i desde 1 hasta 5 hacer
  escribir i;
fin_para;
escribir 'fin para';

escribir 'paso 2:';
para i desde 0 hasta 10 paso 2 hacer
  escribir i;
fin_para;
escribir 'paso -1:';
para i desde 5 hasta 1 paso -1 hacer
  escribir i;
fin_para;

x := 2;
selector (x)
  caso 1: escribir 'uno';
  caso 2: escribir 'dos';
  caso 3: escribir 'tres';
  defecto: escribir 'otro';
fin_selector;
escribir 'fin selector';
