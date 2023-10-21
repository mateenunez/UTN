unit AnalizadorLexico;

interface

uses
  Classes, SysUtils, Archivos, TablaDeSimbolos, ManejoConLista, crt;

 
Var CodigoFuente:archivofuente;
   Control:Longint;
   CompLex:componentelex;
   Lexema:String;
   TablaSimbolos:lista;

Function EsIdentificador(Var CodigoFuente:archivofuente;Var Control:Longint;Var Lexema:String):boolean;
Function EsReal(Var CodigoFuente:archivofuente; Var Control:longint; Var Lexema:string):boolean;
Function EsCadena(Var CodigoFuente:archivofuente; Var Control:longint; Var Lexema:string):boolean;
Function EsSimboloEspecial(Var CodigoFuente:archivofuente; Var Control:longint;Var CompLex:componentelex; Var Lexema:string):boolean;
Procedure ObtenerSiguienteCompLex(Var CodigoFuente:archivofuente; Var Control:Longint; Var CompLex:componentelex;Var Lexema:String;Var TablaSimbolos:lista);

implementation

Function EsIdentificador(Var CodigoFuente:archivofuente;Var Control:Longint;Var Lexema:String):boolean;
Const
      q0=0;
      F=[2];
   Type
      Q=0..3;
      Sigma=(Digito,Letra,Otro);
      TipoDelta=Array [Q,Sigma] of Q;
   var
     EstadoActual:Q;
     Transicion:TipoDelta;
     caracter:char;
     control2:longint;

function CarAsimb(caracter:char):Sigma;
      begin
       case caracter of
         'A'..'Z', 'a'..'z': CarAsimb:=Letra;
         '0'..'9': CarAsimb:=Digito;
       else
         CarAsimb:=Otro
       end;
      end;

   Begin
        control2:=control;
        EstadoActual:=q0;
        Transicion[0,Digito]:=3;
        Transicion[0,Otro]:=3;
        Transicion[0,Letra]:=1;
        Transicion[1,Digito]:=1;
        Transicion[1,Otro]:=2;
        Transicion[1,Letra]:=1;
        while EstadoActual in [0..1] do
        begin
          leer_arch(codigoFuente,control2,caracter);
          EstadoActual:=Transicion[EstadoActual,CarASimb(caracter)];
         if EstadoActual in [0..1] then
         begin
           lexema:=lexema+caracter;
         end;
         inc(control2);
        end;

        if EstadoActual in F then
         begin
           control:=control2-1;
           EsIdentificador:=true;
         end
        else
        begin
         esIdentificador:=false;
         lexema:='';
         end;
   end;

Function EsReal(Var CodigoFuente:archivofuente; Var Control:longint; Var Lexema:string):boolean;
Const
   q0=0;
   F=[5];
Type
   Q=0..4;
   Sigma=(Digito,Coma,Otro);
   TipoDelta=Array [Q,Sigma] of Q;
Var
   EstadoActual:Q;
   Transicion:TipoDelta;
   caracter:char;
   control2:longint;

function CarAsimb(caracter:char):sigma;
 begin
    case caracter of
      '.': CarAsimb:=Coma;
      '0'..'9': CarAsimb:=Digito;
    else
      CarAsimb:=Otro
    end;
 end;

begin
   control2:=control;
   EstadoActual:=q0;
   Transicion[0,Digito]:=2;
   Transicion[0,Otro]:=1;
   Transicion[0,Coma]:=1;
   Transicion[2,Digito]:=2;
   Transicion[2,Otro]:=5;
   Transicion[2,Coma]:=3;
   Transicion[3,Digito]:=4;
   Transicion[3,Coma]:=1;
   Transicion[3,Otro]:=1;
   Transicion[4,Digito]:=4;
   Transicion[4,Otro]:=5;

   while EstadoActual in [0,2,3,4] do
     begin
       leer_arch(codigoFuente,control2,caracter);
       EstadoActual:=Transicion[EstadoActual,CarASimb(caracter)];
      if EstadoActual in [0,2,3,4] then
      begin
        lexema:=lexema+caracter;
      end;
      inc(control2);
     end;

     if EstadoActual in F then
      begin
        control:=control2-1;
        esReal:=true;
      end
     else
     begin
      esReal:=false;
      lexema:='';
     end;

end;

Function EsCadena(Var CodigoFuente:archivofuente; Var Control:longint; Var Lexema:string):boolean;
Const
   q0=0;
   F=[2];
Type
   Q=0..3;
   Sigma=(Letra,Comilla,Otro);
   TipoDelta=Array [Q,Sigma] of Q;
Var
   EstadoActual:Q;
   Transicion:TipoDelta;
   caracter:char;
   control2:longint;

function CarAsimb(caracter:char):sigma;
 begin
    case caracter of
      '"': CarAsimb:=Comilla;
      'a'..'z', 'A'..'Z': CarAsimb:=Letra;
    else
      CarAsimb:=Otro
    end;
 end;


begin
   control2:=control;
   EstadoActual:=q0;
   Transicion[0,Comilla]:=1;
   Transicion[0,Otro]:=3;
   Transicion[0,letra]:=3;
   Transicion[1,Letra]:=1;
   Transicion[1,Otro]:=1;
   Transicion[1,Comilla]:=2;

   while EstadoActual in [0,1] do
     begin
       leer_arch(codigoFuente,control2,caracter);
       EstadoActual:=Transicion[EstadoActual,CarASimb(caracter)];
      if EstadoActual in [0,1,2] then
      begin
        lexema:=lexema+caracter;
      end;
      inc(control2);
     end;

     if EstadoActual in F then
      begin
        control:=control2;
        esCadena:=true;
      end
     else
     begin
      esCadena:=false;
      lexema:='';
     end;

end;

Function EsSimboloEspecial(Var CodigoFuente:archivofuente; Var Control:longint;Var CompLex:componentelex; Var Lexema:string):boolean;
Var
    control2:longint;
    value: 0..1;
    caracter2,caracter:char;
begin
    value:=0;
    control2:=control;
    leer_arch(codigofuente, control, caracter);

    case caracter of
      '^': begin
       Lexema:=caracter;
       CompLex:=tPot;
       value:=1;
       end;
      '+': begin
       Lexema:=caracter;
       CompLex:=tSuma;
       value:=1;
       end;
      '-': begin
       Lexema:=caracter;
       CompLex:=tResta;
       value:=1;
       end;
      '*': begin
       Lexema:=caracter;
       CompLex:=tMult;
       value:=1;
       end;
      '/': begin
       Lexema:=caracter;
       CompLex:=tDiv;
       value:=1;
       end;
      ';': begin
       Lexema:=caracter;
       CompLex:=tPuntoyComa;
       value:=1;
       end;
      '[': begin
       Lexema:=caracter;
       CompLex:=tCorcheteA;
       value:=1;
       end;
      ']': begin
       Lexema:=caracter;
       CompLex:=tCorcheteC;
       value:=1;
       end;
      ',': begin
       Lexema:=caracter;
       CompLex:=tComa;
       value:=1;
       end;
      '.': begin
       Lexema:=caracter;      //Agregue punto para solucionar un error de Pascal
       CompLex:=tPunto;
       value:=1;
       end;
      '(': begin
       Lexema:=caracter;
       CompLex:=tParentesisA;
       value:=1;
       end;
      ')': begin
       Lexema:=caracter;
       CompLex:=tParentesisC;
       value:=1;
       end;
      #39: begin
       Lexema:=caracter;
       CompLex:=tComillaSimple;
       value:=1;
       end;
      '>': begin
       Lexema:=caracter;
       control:=control+1;
       leer_arch(codigofuente,control,caracter2);
         if (caracter2 = '=') then
          begin
            Lexema:= Lexema + caracter2;
            value:=1;
            end;
       CompLex:=tOpRel;               // o tMayor??
       value:=1;
       end;
      '<': begin
       Lexema:=caracter;
       control:=control+1;
       leer_arch(codigofuente,control,caracter2);
       if (caracter2 = '=') then
          begin
            Lexema:= Lexema + caracter2;
            end else if (caracter2 = '>') then
              begin
                Lexema:= Lexema + caracter2;
                value:=1;
                end else control:= control-1;
       CompLex:=tOpRel;
       value:=1;
       end;
      '=': begin
       Lexema:=caracter;
       control:=control+1;
       leer_arch(codigofuente,control,caracter2);
       if (caracter2 = '=') then
         begin
           Lexema:=Lexema+caracter2;
           CompLex:=tOpRel;
           value:=1;// creo ??
           end else begin
       CompLex:=tAsignacion;     //o tIgual
       value:=1;
       control:= control-1;
       end;
       end;
       end;

       EsSimboloEspecial:= (value = 1);
       control:= control+1;
       //Da el booleano
       if not EsSimboloEspecial then Lexema:='';

end;

Procedure ObtenerSiguienteCompLex(Var CodigoFuente:archivofuente; Var Control:Longint; Var CompLex:componentelex;Var Lexema:String;Var TablaSimbolos:lista);
var caracter:char;
Begin
  Lexema:='';
  leer_arch(codigofuente,control,caracter);
  while (caracter in [#1..#32]) do
  begin
     control:=control+1;
     leer_arch(codigofuente,control,caracter);
  end;
  if (caracter = #0) then
    begin
               CompLex:=PESOS;
    end
  else
  If EsIdentificador(CodigoFuente,Control,Lexema) then
  begin
             CargarEnTAS(TablaSimbolos,Lexema,CompLex);          // la lista 'TablaSimbolos' tiene que llamarse palabras reservadas
  end
  else If EsReal(CodigoFuente,Control,Lexema) then
		CompLex:=tReal
  else If EsCadena(CodigoFuente,Control,Lexema) then
		CompLex:=tCadena
  else if Not EsSimboloEspecial(CodigoFuente,Control,CompLex,Lexema) then
    CompLex:=ERRORLEXICO
End;

end.

