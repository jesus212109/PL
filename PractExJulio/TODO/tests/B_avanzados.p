# B avanzado: Concatenacion, ternario, asignacion compuesta
escribir 'hola' || ' mundo';
escribir 'a' || 'b' || 'c';
escribir 'numero: ' || 42;

escribir (1 < 2 ? 10 : 20);
escribir (1 > 2 ? 'a' : 'b');
x := 5;
escribir (x = 5 ? 'si' : 'no');
escribir (x <> 5 ? 'no' : 'si');

x := 10;
x +:= 3;
escribir x;
x := 10;
x -:= 5;
escribir x;
