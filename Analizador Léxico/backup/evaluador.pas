unit Evaluador;


interface

uses
  Classes, SysUtils, analizadorSintactico, analizadorLexico, TablaDeSimbolos, ManejoConLista, math, crt;

const MaxVariables = 100;

type
  Tipos = (tipoReal, tipoArray);
  ElemEstado = record
    nombre_id: string;
    valor: real;
    tipo: Tipos;
    valorArray: array[1..100] of Real;  //MaxReales es 100
    end;
  tipoEstado = record
    elem: array[1..maxVariables] of ElemEstado;
    tam: byte;
    end;

procedure inicializarEstado(var Estado:tipoEstado);
procedure agregarVariable(var Estado:tipoEstado; nombre:string; tipo:Tipos; eTam:byte);
procedure asignarValor(var Estado:tipoEstado; nombre:string; elemento:byte; result:real);
function obtenerValor(var Estado:tipoEstado; nombre:string; pos:byte):real;
function convertirAReal( nombre:string):real;
function Verificar_Variable(var Estado:tipoEstado; nombre:string):boolean;
procedure eval_Programa(var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_Declaracion(var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_Variables(var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_Ids(var arbol:TApuntNodo;var Estado:tipoEstado; var nombre:string; var tipo:Tipos; var eTam:byte);
procedure eval_Id2(var arbol:TApuntNodo;var Estado:tipoEstado; var nombre:string; var tipo:Tipos; var eTam:byte);
procedure eval_Tipo(var arbol:TApuntNodo;var Estado:tipoEstado; var tipo:Tipos; var eTam:byte);
procedure eval_Cuerpo(var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_B(var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_Sent(var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_Asignacion(var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_J(var arbol:TApuntNodo;var Estado:tipoEstado;var pos:byte);
procedure eval_ExpArit(var arbol:TApuntNodo;var Estado:tipoEstado; var Valor:real);
procedure eval_X(var arbol:TApuntNodo;var Estado:tipoEstado; var operando1:real; var valor:real);
procedure eval_R(var arbol:TApuntNodo;var Estado:tipoEstado; var operando1:real; var valor:real);
procedure eval_M(var arbol:TApuntNodo;var Estado:tipoEstado;var valor:real);
procedure eval_T(var arbol:TApuntNodo;var Estado:tipoEstado; var operando1:real; var valor:real);
procedure eval_Y(var arbol:TApuntNodo;var Estado:tipoEstado; var operando1:real; var Valor:real);
procedure eval_G(var arbol:TApuntNodo;var Estado:tipoEstado; var Valor:real);
procedure eval_Z(var arbol:TApuntNodo;var Estado:tipoEstado; var Valor:real);
procedure eval_Num(var arbol:TApuntNodo;var Estado:tipoEstado; var Valor:real);
procedure eval_Condiciones(var arbol:TApuntNodo;var Estado:tipoEstado; var result:boolean);
procedure eval_K (var arbol:TApuntNodo;var Estado:tipoEstado; var value1:boolean;var result:boolean);
procedure eval_A(var arbol:TApuntNodo;var Estado:tipoEstado; var value1:boolean ;var result:boolean);
procedure eval_N(var arbol:TApuntNodo;var Estado:tipoEstado; var result:boolean);
procedure eval_Q(var arbol:TApuntNodo;var Estado:tipoEstado; var value1: boolean;var result:boolean);
procedure eval_L(var arbol:TApuntNodo;var Estado:tipoEstado; var value1: boolean;var result:boolean);
Procedure eval_Cond(var arbol:TApuntNodo; var Estado:tipoEstado; var result:boolean);
Procedure eval_Condic(var arbol:TApuntNodo; var Estado:tipoEstado; var result:boolean);
Procedure eval_Condicional (var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_E(var arbol:TApuntNodo;var Estado:tipoEstado);
Procedure eval_Ciclo(var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_Segun(var arbol:TApuntNodo;var Estado:tipoEstado);
procedure eval_Cuerposegun(var arbol:TApuntNodo;var Estado:tipoEstado; valorCase:real);



implementation

procedure inicializarEstado(var Estado:tipoEstado);

begin
     Estado.tam:=0;
end;

procedure agregarVariable(var Estado:tipoEstado; nombre:string; tipo:Tipos; eTam:byte);
var p:byte;
begin
     Estado.tam:=Estado.tam+1;
     Estado.elem[Estado.tam].nombre_id:= AnsiLowerCase(nombre);
     Estado.elem[Estado.tam].tipo:=tipo;
     Estado.elem[Estado.tam].valor:=0;
     //Estado.elem[Estado.tam].valorArray:=0;
     if (Estado.elem[Estado.tam].tipo = tipoArray) then
     begin
        for p:=1 to eTam do
        begin
          Estado.elem[Estado.tam].valorArray[p]:=0;
        end;
     end;

end;

procedure asignarValor(var Estado:tipoEstado; nombre:string; elemento:byte; result:real);
var i:byte;
    begin
      //writeln('tamanio: ', eTam, ' y resultado: ',result:3:2);
      //readkey;
      for i:=1 to Estado.tam do
       begin
                  if AnsiLowerCase(Estado.elem[i].nombre_id) = AnsiLowerCase(nombre) then
                  begin
                          if (Estado.elem[i].tipo = tipoReal) then
                          begin
                             Estado.elem[i].valor:= result;
                          end else begin
                              Estado.elem[i].valorArray[elemento]:=result;
                          end;
                  end;
       end;
    end;

function obtenerValor(var Estado:tipoEstado; nombre:string; pos:byte):real;
var j:byte; valorId:real;
begin
     for j:=1 to Estado.tam do
     begin
          if AnsiLowerCase(Estado.elem[j].nombre_id) = AnsiLowerCase(nombre) then
          begin
               if (Estado.elem[j].tipo = tipoReal) then
               begin
                    obtenerValor := Estado.elem[j].valor;
               end else
               begin
                    obtenerValor := Estado.elem[j].valorArray[pos];
               end;
          end;
     end;
end;

function convertirAReal( nombre:string):real;

var num:Real; Error:byte;
begin
   num:=0;
   Val(nombre,num,Error);
   if Error <> 0 then writeln('Error en transformacion');
   convertirAReal:=num;

end;

function Verificar_Variable(var Estado:tipoEstado; nombre:string):boolean;
var j:byte;
begin
   Verificar_Variable:=false;
    for j:=1 to Estado.tam do
       begin
                  if AnsiLowerCase(Estado.elem[j].nombre_id) = AnsiLowerCase(nombre) then
                  begin
                     Verificar_Variable:=true;
                  end;

       end;
end;

//program -> program id; declaración begin cuerpo end
procedure eval_Programa(var arbol:TApuntNodo;var Estado:tipoEstado);
var i:byte;
begin
     eval_Declaracion(arbol^.Hijos.elem[4], Estado);
     eval_Cuerpo(arbol^.Hijos.elem[6], Estado);
     readkey;
     //writeln(' elemento de mateo : ', estado.elem[2].valorArray[4]);
     //writeln(' elemento de mateo : ', estado.elem[1].valor)
end;

//declaración → Var variables
procedure eval_Declaracion(var arbol:TApuntNodo;var Estado:tipoEstado);
begin
      eval_Variables(arbol^.Hijos.elem[2], Estado);
end;

// variables →  ids = tipo  variables | epsilon
procedure eval_Variables(var arbol:TApuntNodo;var Estado:tipoEstado);
var tipo:Tipos;
    eTam:byte;
    nombre:string;
begin
       if arbol^.hijos.cant <> 0 then
       begin
          eval_Tipo(arbol^.Hijos.elem[3], Estado, tipo, eTam);
          eval_Ids(arbol^.Hijos.elem[1], Estado, nombre, tipo, eTam);
          eval_Variables(arbol^.Hijos.elem[4], estado)
       end;
end;

//ids → id id2
procedure eval_Ids(var arbol:TApuntNodo;var Estado:tipoEstado; var nombre:string; var tipo:Tipos; var eTam:byte);
   begin
        nombre:= arbol^.Hijos.elem[1]^.lexema;
        agregarVariable(Estado, nombre, tipo,eTam);
        eval_Id2(arbol^.Hijos.elem[2], Estado, nombre, tipo, eTam);
   end;

//id2 →  ,id id2 | epsilon
procedure eval_Id2(var arbol:TApuntNodo;var Estado:tipoEstado; var nombre:string; var tipo:Tipos; var eTam:byte);
var i:0..MaxProd;                      // para mi nombre no se tiene que ir pasando en este procedimiento
   begin
       if (arbol^.Hijos.cant > 0) then
       begin
          nombre:=arbol^.Hijos.elem[2]^.lexema;
          agregarVariable(Estado, nombre, tipo, eTam);
          eval_Id2(arbol^.Hijos.elem[3], Estado, nombre, tipo, eTam);
       end;

end;

//tipo →  real;  | array[expArit];
procedure eval_Tipo(var arbol:TApuntNodo;var Estado:tipoEstado; var tipo:Tipos; var eTam:byte);
var Resultado:real;
begin
    if (arbol^.Hijos.elem[1]^.Simbolo = tRealT) then
    begin
       tipo:= tipoReal;
       eTam := 0;
    end else
    begin
      tipo:= tipoArray;
      eval_expArit(arbol^.Hijos.elem[3], Estado, resultado);
      eTam:= floor(Resultado);

    end;
end;

//cuerpo → sent B
procedure eval_Cuerpo(var arbol:TApuntNodo;var Estado:tipoEstado);

begin
    eval_Sent(arbol^.Hijos.elem[1], Estado);
    eval_B(arbol^.Hijos.elem[2], Estado);
end;

// B → sent B | epsilon
procedure eval_B(var arbol:TApuntNodo;var Estado:tipoEstado);
begin
    if arbol^.Hijos.cant > 0 then
    begin
      eval_Sent(arbol^.Hijos.elem[1], Estado);
      eval_B(arbol^.Hijos.elem[2], Estado);
    end;
end;

//sent → condicional | ciclo | asignacion | según | read[idJ] | write[expArit]
procedure eval_Sent(var arbol:TApuntNodo;var Estado:tipoEstado);
var asig,Valor:real;pos:byte;
    id:string;
begin
    if (arbol^.Hijos.elem[1]^.Simbolo = vCondicional) then  begin eval_Condicional(arbol^.Hijos.elem[1], Estado) end
    else if (arbol^.Hijos.elem[1]^.Simbolo = vCiclo) then begin eval_Ciclo(arbol^.Hijos.elem[1], Estado) end
    else if (arbol^.Hijos.elem[1]^.Simbolo = vAsignacion) then  begin eval_Asignacion(arbol^.Hijos.elem[1], Estado) end
    else if (arbol^.Hijos.elem[1]^.Simbolo = vSegun) then  begin eval_Segun(arbol^.Hijos.elem[1], Estado) end

    else if (arbol^.Hijos.elem[1]^.Simbolo = tRead) then
         begin
            id:=arbol^.Hijos.elem[3]^.Lexema;
            eval_J(arbol^.Hijos.elem[4], Estado, pos);
            readln(asig);
            asignarValor(Estado,id,pos,asig);
         end
    else if (arbol^.Hijos.elem[1]^.Simbolo = tWrite) then
         begin
            eval_ExpArit(arbol^.Hijos.elem[3], Estado, Valor);
            writeln(Valor:3:3);
         end;
end;

//asignacion →  idJ = expArit ;
procedure eval_Asignacion(var arbol:TApuntNodo;var Estado:tipoEstado);
var pos:byte;
    Valor:real;
    nombre:string;
begin
  valor := 0;
  eval_J(arbol^.Hijos.elem[2], Estado, pos);
      if (pos > 0) then begin
         eval_ExpArit(arbol^.Hijos.elem[4], Estado, Valor);
         nombre:=arbol^.Hijos.elem[1]^.Lexema;
         asignarValor(Estado, nombre, pos, Valor);
      end else
      begin
           eval_ExpArit(arbol^.Hijos.elem[4],Estado, valor);
           //writeln(arbol^.Hijos.elem[1]^.Lexema, ' = ',valor:3:3);
           //readkey;
           nombre:= arbol^.Hijos.elem[1]^.Lexema;
	   asignarValor(Estado, nombre,pos, valor);
      end;
end;

// J →  [expArit] | epsilon
procedure eval_J(var arbol:TApuntNodo;var Estado:tipoEstado;var pos:byte);
var value1:real;
begin
   if (arbol^.Hijos.cant > 0) then
   begin
      eval_ExpArit(arbol^.Hijos.elem[2], Estado, value1);
      pos:=floor(value1);
   end else pos:=0;
end;


//expArit → MX
procedure eval_ExpArit(var arbol:TApuntNodo;var Estado:tipoEstado; var Valor:real);
var operando1,operando2:real; k:byte;
begin
eval_M(arbol^.Hijos.elem[1], Estado, operando1);
eval_X(arbol^.Hijos.elem[2], Estado, operando1, valor);
end;


//X → RX | epsilon
procedure eval_X(var arbol:TApuntNodo;var Estado:tipoEstado; var operando1:real; var valor:real);
var operando2:real;
begin
    if (arbol^.Hijos.cant > 0) then begin
    eval_R(arbol^.Hijos.elem[1], Estado, operando1, operando2);
    eval_X(arbol^.Hijos.elem[2], Estado, operando2, valor);
    end else valor:=operando1;
end;

//R →  + M | - M
procedure eval_R(var arbol:TApuntNodo;var Estado:tipoEstado; var operando1:real; var valor:real);
var operando2:real;
begin
      case arbol^.Hijos.elem[1]^.Simbolo of
      tSuma:  Begin
              eval_M(arbol^.Hijos.elem[2], Estado, operando2);
              Valor:= operando1+operando2;
              end;
      tResta:  Begin
              eval_M(arbol^.Hijos.elem[2], Estado, operando2);
              Valor:= operando1-operando2;
              end;
      end;
end;

//M →  GT
procedure eval_M(var arbol:TApuntNodo;var Estado:tipoEstado;var valor:real);
var operando1:real;
begin
    eval_G(arbol^.Hijos.elem[1], Estado, operando1);
    eval_T(arbol^.Hijos.elem[2], Estado, operando1, valor);
end;

//T → YT | epsilon
procedure eval_T(var arbol:TApuntNodo;var Estado:tipoEstado; var operando1:real; var valor:real);
var operando2:real;
begin
     if (arbol^.Hijos.cant > 0) then begin
     eval_Y(arbol^.Hijos.elem[1], Estado, operando1, operando2);
     eval_T(arbol^.Hijos.elem[2], Estado, operando2, valor);
    end else valor:=operando1;
end;

//Y → *G | /G
procedure eval_Y(var arbol:TApuntNodo;var Estado:tipoEstado; var operando1:real; var Valor:real);
var operando2:real;
begin
case arbol^.Hijos.elem[1]^.Simbolo of
      tMult:  Begin
              eval_G(arbol^.Hijos.elem[2], Estado, operando2);
              Valor:= operando1*operando2;
              end;
      tDiv:  Begin
              eval_G(arbol^.Hijos.elem[2], Estado, operando2);
              Valor:= operando1/operando2;
              end;
      end;

end;


  //G →   numZ
procedure eval_G(var arbol:TApuntNodo;var Estado:tipoEstado; var Valor:real);
begin
      eval_Num(arbol^.Hijos.elem[1], Estado, valor);
      eval_Z(arbol^.Hijos.elem[2], Estado, valor);
end;


//Z → ^numZ | epsilon
procedure eval_Z(var arbol:TApuntNodo;var Estado:tipoEstado; var Valor:real);
var pot:real;
begin
      if (arbol^.Hijos.cant > 0) then begin
         eval_Num(arbol^.Hijos.elem[2], Estado, pot);
         valor := power(valor,pot);//Potencia(valor,pot);
         eval_Z(arbol^.Hijos.elem[3], Estado, valor);
      end else pot:=1;
end;


//num -> Real| idJ | (expArit) | -Real
procedure eval_Num(var arbol:TApuntNodo;var Estado:tipoEstado; var Valor:real);
var pos:byte;
begin
     Case arbol^.Hijos.elem[1]^.Simbolo of
     tReal : begin
                  Valor := StrToFloat(arbol^.Hijos.elem[1]^.lexema);
             end;
     tId : begin
             eval_J(arbol^.Hijos.elem[2], Estado, pos);
             if pos>0 then
             begin
                  valor := obtenervalor(estado,arbol^.Hijos.elem[1]^.lexema,pos);
             end else valor := obtenervalor(estado,arbol^.Hijos.elem[1]^.lexema,pos);
             end;
     tParentesisA : begin
             eval_ExpArit(arbol^.Hijos.elem[2], Estado, Valor);
             end;
     tResta : begin
          valor := -strtofloat(arbol^.hijos.elem[2]^.lexema);
        end;
      end;
end;

// condiciones → NK
procedure eval_Condiciones(var arbol:TApuntNodo;var Estado:tipoEstado; var result:boolean);
var value1: boolean;
begin
eval_N(arbol^.Hijos.elem[1], Estado, value1);
eval_K(arbol^.Hijos.elem[2],Estado, value1, result);
end;


//K → AK | epsilon
procedure eval_K (var arbol:TApuntNodo;var Estado:tipoEstado; var value1:boolean;var result:boolean);
var value2:boolean;
begin
if (arbol^.Hijos.cant > 0) then begin
   eval_A(arbol^.Hijos.elem[1], Estado, value1, value2);
   eval_K(arbol^.Hijos.elem[2], Estado, value2 ,result);
   end else begin
   result:=value1;
   end;

end;

//A → and N
procedure eval_A(var arbol:TApuntNodo;var Estado:tipoEstado; var value1:boolean ;var result:boolean);
 var value2:boolean;
begin
eval_N(arbol^.Hijos.elem[2], Estado, value2);
result:= value1 and value2;

end;

//N —> condic Q
procedure eval_N(var arbol:TApuntNodo;var Estado:tipoEstado; var result:boolean);
var value1:boolean;
begin
     eval_Condic(arbol^.Hijos.elem[1], Estado, value1);
     eval_Q(arbol^.Hijos.elem[2], Estado, value1 ,result);
end;

//Q → LQ | epsilon
procedure eval_Q(var arbol:TApuntNodo;var Estado:tipoEstado; var value1: boolean;var result:boolean);
  var value2:boolean;
begin
if (arbol^.Hijos.cant > 0) then begin
   eval_L(arbol^.Hijos.elem[1], Estado, value1, value2);
   eval_Q(arbol^.Hijos.elem[2], Estado, value2 ,result);
   end else begin
   result:=value1;
   end;
end;

//L → or condic
procedure eval_L(var arbol:TApuntNodo;var Estado:tipoEstado; var value1: boolean;var result:boolean);
var value3:boolean;
begin
     eval_Condic(arbol^.Hijos.elem[2], Estado, value3);
     result:= value1 or value3;
end;

//cond → expArit opRel expArit
Procedure eval_Cond(var arbol:TApuntNodo; var Estado:tipoEstado; var result:boolean);
 var valor1, valor2: real;
Begin
           eval_ExpArit(arbol^.hijos.elem[1], estado, valor1);
           eval_ExpArit(arbol^.hijos.elem[3], estado, valor2);
           case arbol^.hijos.elem[2]^.lexema of
             '<': result:= valor1<valor2;
             '>': result:= valor1>valor2;
             '==': result:= valor1=valor2;
             '<=': result:= valor1<=valor2;
             '>=': result:= valor1>=valor2;
             '<>': result:= valor1<>valor2;
           end;

End;

//condic  → (cond) | not(condiciones)
Procedure eval_Condic(var arbol:TApuntNodo; var Estado:tipoEstado; var result:boolean);

begin
if (arbol^.Hijos.elem[1]^.Simbolo = tParentesisA) then
   begin
      eval_Cond(arbol^.Hijos.elem[2], Estado, result);
   end else
   begin
      eval_Condiciones(arbol^.hijos.elem[3], Estado, result);
      result:= not(result);
   end;

end;

//condicional → if condiciones [cuerpo] E
Procedure eval_Condicional (var arbol:TApuntNodo;var Estado:tipoEstado);
var result: boolean;
begin
  eval_condiciones(arbol^.hijos.elem[2], estado, result);
  if (result) then
  eval_cuerpo(arbol^.hijos.elem[4], estado)
  else
  eval_E(arbol^.hijos.elem[6], estado);
 end;

//E → else [cuerpo] | epsilon
procedure eval_E(var arbol:TApuntNodo;var Estado:tipoEstado);

begin
  if (arbol^.Hijos.cant > 0) then eval_Cuerpo(arbol^.Hijos.elem[3], Estado);
end;


//ciclo → while condiciones [cuerpo] | for id= num to num do[cuerpo]
Procedure eval_Ciclo(var arbol:TApuntNodo;var Estado:tipoEstado);
var i,valorId,pos:byte;
    result, found:boolean;
    valor1,valor2:real;
begin
  if (arbol^.Hijos.elem[1]^.Simbolo=tWhile)then
   begin
    eval_condiciones(arbol^.Hijos.elem[2], estado, result);
    while (result) do
    begin
      eval_cuerpo(arbol^.Hijos.elem[4], estado);
      eval_condiciones(arbol^.Hijos.elem[2], estado, result);
    end;
   end;
  if (arbol^.Hijos.elem[1]^.Simbolo=tFor)then
  begin
    eval_ExpArit(arbol^.Hijos.elem[4], estado, valor1);
    eval_ExpArit(arbol^.Hijos.elem[6], estado, valor2);
    found:= Verificar_Variable(Estado, arbol^.Hijos.elem[2]^.lexema);
    if (found) then
    begin
    for i := floor(valor1) to floor(valor2) do
      begin
        valorId:=i;
        asignarValor(Estado, arbol^.Hijos.elem[2]^.lexema, pos ,valorId);
        eval_cuerpo(arbol^.hijos.elem[9], Estado);
      end;
    end else writeln('Error: la variable utilizada en el FOR no esta definida');
  end;
end;

//segun→ case of id ’expArit’ [cuerpo] cuerposegun
procedure eval_Segun(var arbol:TApuntNodo;var Estado:tipoEstado);
var valor1, valorCase:real; pos:byte;
begin
   eval_expArit(arbol^.Hijos.elem[5], Estado, valor1);
   valorCase := obtenerValor(Estado,arbol^.Hijos.elem[3]^.lexema,pos);
if (valorCase= valor1) then eval_Cuerpo(arbol^.Hijos.elem[8], Estado)
else eval_Cuerposegun(arbol^.Hijos.elem[10], Estado, valorCase);

end;


//cuerposegun →’expArit’ [cuerpo] cuerposegun | epsilon
procedure eval_Cuerposegun(var arbol:TApuntNodo;var Estado:tipoEstado; valorCase:real);
var valor2:real ;
begin

     if (arbol^.Hijos.cant>0) then
     begin
     eval_ExpArit(arbol^.Hijos.elem[2], Estado, valor2);
     if (valorCase = valor2) then
     begin
     eval_Cuerpo(arbol^.Hijos.elem[5], Estado)
     end else eval_Cuerposegun(arbol^.Hijos.elem[7], Estado, valorCase);
     end;

end;




end.

