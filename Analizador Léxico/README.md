### **UTN**

Projecto de universidad:

 **Analizador Lexico**

_Este proyecto desarrollado en la materia Sintaxis y semantica de los lenguajes con el lenguaje pascal busca crear un lenguaje de programacion (diseñado por nuestro grupo). Esto es posible ya que programamos un analizador lexico, un analizador sintactico y un evaluador._

1. _El analizador lexico sirve para saber si la palabra que esta leyendo es un ID, un numero real, una cadena o un simbolo especial. Si no es ninguno se obtiene un error lexico._
 
2. _El analizador sintactico trabaja con una pila y la tablas TAS la cual contiene la sintaxis del lenguaje. En definitiva, se fija si la escritura no sigue la estructura del lenguaje._
 
3. _El evaluador da significado a la escritura o el programa hecho por el usuario, se encarga de sumar, ejecutar ciclos, condicionales, etc..._

**A continuacion, dos programas que corren en nuestro lenguaje creado:**



```
program distanciaMaxima;
Var
vector1, vector2 = array[5];
maximo, i, numero, diferencia = real;
Begin

for i=1 to 5 do [
Read[numero]
vector1[i]=numero;
]

for i=1 to 5 do [
Read[vector2[i]]
]

for i=1 to 5 do [
diferencia = ((vector1[i]-vector2[i])^2)^(1/2) ;
if (diferencia > maximo) [
maximo = diferencia; ]
]

Write[maximo]

End
```

```
Program programaSumatoria
var
vector=array[100];
n, sumatoria, productoria, i, j=real;
Begin
sumatoria=0;
productoria=1;
read[n]
for j=1 to n do [
read[vector[j]]
]
for i=1 to n do [
sumatoria=sumatoria + vector[i];
productoria=productoria * vector[i];
]
write[sumatoria]
write[productoria]
End 

```

