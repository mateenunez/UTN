unit analizadorSintactico;


interface

uses
  Classes, SysUtils,crt, ManejoConLista, Archivos, analizadorLexico, TablaDeSimbolos;

const
  MaxProd = 10;

type

  //Definicion de TAS
  TProduccion = record
    elem:array[1..MaxProd]of tipoSimboloGramatical;
    cant:0..MaxProd;
    end;
  TipoVariable = vPrograma..vBoolean; //subrangos de tiposimbologramatical
  TipoTerminypesos = tProgram..PESOS;
  TipoTAS = array [TipoVariable, TipoTerminypesos] of ^Tproduccion;     //TipoTAS es un puntero de Tproduccion

  //Arbol de derivacion
  TApuntNodo = ^TNodoArbol;
  TipoHijos = record
    elem:array[1..MaxProd]of TApuntNodo;
    cant:0..MaxProd;
    end;
  TNodoArbol = record
    Simbolo:tipoSimboloGramatical;
    lexema:string;
    Hijos:TipoHIjos;
    end;
  //Definicion pila
  TipoElemPila = record
    Simbolo:tipoSimboloGramatical;
    NodoArbol:TApuntNodo;
    end;
  TApuntPila = ^TNodoPila;
    TipoPila = record
    punt:TApuntPila;
    tam:integer;
    end;
  TNodoPila = record
    elem: TipoElemPila;
    sig: TApuntPila;
  end;
  Tfunc = 0..2;






procedure analizadorPredictivo(ruta:string;Var Arbol:TApuntNodo;var funcionamiento:Tfunc);
procedure ASCargaTas(var TAS:tipoTAS);
procedure ApilarElementos(Var Celda:TProduccion; var Nodo:TApuntNodo;var Pila:TipoPila);
procedure CrearPila(Var Pila:TipoPila);
procedure Apilar(Var Pila:TipoPila; ElemPila:TipoElemPila);
procedure Desapilar(Var Pila:TipoPila;Var ElemPila:TipoElemPila);
procedure mostrarPila(var Pila:TipoPila);
procedure DesapilarPeso(var Pila:TipoPila);
procedure CrearNodo(var Nodo:TApuntNodo;Simbolo:TipoSimboloGramatical);
procedure AgregarNodo (var raiz:TApuntNodo; Var Nodo:TApuntNodo);
procedure GuardarArbol(rutaarbol:string; var arbol:TApuntNodo);
procedure GuardarNodo(var arch:text; var arbol:TApuntNodo; despl:string);

// guardar arbol y nodo

implementation

procedure CrearPila(Var Pila:TipoPila);
begin
     Pila.tam:=0;
     Pila.punt:=nil;

end;

procedure Apilar(Var Pila:TipoPila; ElemPila:TipoElemPila);
var nodoaux:TApuntPila;
begin
     new(nodoaux);
     nodoaux^.elem:=ElemPila;
     nodoaux^.sig:=Pila.punt;
     Pila.punt:=nodoaux;
     inc(Pila.tam);

end;

procedure Desapilar(Var Pila:TipoPila;Var ElemPila:TipoElemPila);
var nodoaux:TApuntPila;
begin

    ElemPila:=Pila.punt^.elem;
    nodoaux:=Pila.punt;
    Pila.punt:=Pila.punt^.sig;
    dispose(nodoaux);
    dec(Pila.tam);

end;

procedure mostrarPila(var Pila:TipoPila);
 var i,s:TApuntPila ;
   var pilaaux:TipoPila;
begin
    pilaaux:=Pila;
   writeln(pilaaux.tam);
   s:= pilaaux.punt^.sig;
   while s<>nil do
   begin

    i:=pilaaux.punt;
    writeln(i^.elem.Simbolo);
    pilaaux.punt:=s;
    s:= pilaaux.punt^.sig;

   end;

end;

procedure DesapilarPeso(var Pila:TipoPila);
 var i,s:TApuntPila ;
   var pilaaux:TipoPila;
begin
    pilaaux:=Pila;
    i:=Pila.punt;
    if i^.sig = nil then writeln(i^.elem.Simbolo);
    dispose(Pila.punt);

end;

procedure CrearNodo(var Nodo:TApuntNodo; Simbolo:tipoSimboloGramatical);

begin
    new(Nodo);
    Nodo^.Simbolo:=Simbolo;
    Nodo^.lexema:= '';
    Nodo^.Hijos.cant:=0;

end;

procedure AgregarNodo (var raiz:TApuntNodo; Var Nodo:TApuntNodo);
begin
    if raiz^.Hijos.cant < MaxProd then
    begin
      inc(raiz^.Hijos.cant);
      raiz^.Hijos.elem[raiz^.Hijos.cant]:= Nodo;
    end;
end;

procedure GuardarNodo(var arch:text; var arbol:TApuntNodo; despl:string);
var i:byte;
begin
   writeln(arch, despl, arbol^.Simbolo, ' (', arbol^.lexema, ') ');
   for i:=1 to arbol^.hijos.cant do
   begin
    GuardarNodo(arch, arbol^.hijos.elem[i], despl + '  ');
    end;
end;

procedure GuardarArbol(rutaarbol:string; var arbol:TApuntNodo);
var arch:text;
begin
   assign(arch,rutaarbol);
   rewrite(arch);
   GuardarNodo(arch, arbol, '');
   close(arch);
end;

procedure ApilarElementos(Var Celda:TProduccion; var Nodo:TApuntNodo;var Pila:TipoPila);
var i:1..MaxProd; ElemPila:TipoElemPila;
begin

     for i:= Celda.cant downto 1 do
       begin
         ElemPila.simbolo := celda.elem[i];
         ElemPila.NodoArbol := Nodo^.Hijos.elem[i];
         Apilar(Pila,ElemPila);
       end;

end;

procedure analizadorPredictivo(ruta:string;Var Arbol:TApuntNodo;var funcionamiento:Tfunc);
    Var
      CodigoFuente: archivofuente;
      CompLex:componentelex;
      Lexema:String;
      TablaSimbolos: lista;
      TAS: TipoTAS;
      Pila:TipoPila;
      ElemPila:TipoElemPila;
      problem:byte;
      i:0..MaxProd;
      aux:TApuntNodo;
      simboloaux:TipoSimboloGramatical;
      control:longint;
      //auxx:t_puntero;
      //fin:boolean;
begin
     assign(Codigofuente, ruta);
     reset(CodigoFuente);

     //Carga palabras reservadas
     crear_lista(TablaSimbolos);
     CargarPalabras(TablaSimbolos);
     //auxx:= tablasimbolos.cab;                         para ver lo que esta cargado en la lista de palabras reservadas
     {fin:=false;
     while not(fin) do
     begin
       writeln('lexema: ', auxx^.info.lexema,' complex:',auxx^.info.complex);
       if auxx^.sig <> nil then
       begin
         auxx:=auxx^.sig;
       end else fin:=true;
     end;}
     //Carga TAS
     ASCargaTas(TAS);
     //Creamos Pila
     CrearPila(Pila);
     //Apilamos PESOS
     CrearNodo(Arbol,vPrograma);
     ElemPila.Simbolo:=PESOS;
     ElemPila.NodoArbol:=Nil;
     Apilar(Pila,ElemPila);
     //Apilamos vPrograma
     ElemPila.Simbolo:=vPrograma;
     ElemPila.NodoArbol:=Arbol;
     Apilar(Pila,ElemPila);

     control:=0;
     funcionamiento:=0;
     ObtenerSiguienteCompLex(CodigoFuente, control, CompLex, Lexema, TablaSimbolos);
     if CompLex = PESOS then begin               //archivo vacio
        writeln('Archivo Vacio');
        funcionamiento:=1;
     end;

     while funcionamiento = 0 do
     begin
       Desapilar(Pila,ElemPila);
       if ElemPila.Simbolo in [tProgram..PESOS] then          // compara terminales
       begin
         if (ElemPila.Simbolo = CompLex) then
         begin
             ElemPila.NodoArbol^.lexema:= Lexema;
             //writeln('se agrego al arbol el siguiente lexema: ', lexema);
             ObtenerSiguienteCompLex(CodigoFuente, control, CompLex, Lexema, TablaSimbolos);                 //porque se llama nuevamente a obtener siguiente comp lexico
             //readkey;
             end else begin
               funcionamiento:=1;

               Writeln('Error Sintactico TERMINAL: se esperaba ', ElemPila.Simbolo, ' se obtuvo ', CompLex);
               readkey;
               end;
       end;
       if ElemPila.Simbolo in [vPrograma..vBoolean] then     // deriva variable
       begin
         if (TAS[ElemPila.Simbolo, CompLex] = Nil) then
         begin
             funcionamiento:=1;
             writeln('Error sintactico VARIABLE: se intento derivar de ', elempila.simbolo,' a ', complex);
             readkey;
         end else
         begin
            for i:=1 to TAS[ElemPila.Simbolo, CompLex]^.cant do
               begin
                  simboloaux:= TAS[ElemPila.Simbolo, CompLex]^.elem[i];
                  crearNodo(aux,simboloaux);
                  agregarNodo(ElemPila.NodoArbol,aux);
               end;
                   if (TAS[ElemPila.Simbolo, CompLex]^.cant <> 0) then ApilarElementos(TAS[ElemPila.Simbolo, CompLex]^, ElemPila.NodoArbol, Pila);

         end;
       end;
      if (ElemPila.Simbolo = tEnd) then
      begin
        funcionamiento:= 2;
        DesapilarPeso(Pila);
        writeln('Sintaxis correcta');
      end;
     end;
end;

procedure ASCargaTas(var TAS:tipoTAS);
var i,j:tipoSimboloGramatical;

begin
     for i:= vPrograma to vBoolean do
       for j:= tProgram to PESOS do
         TAS[I,J]:= nil; //Llenamos todas las celdas con nil

     //Dar de alta las producciones
     {vPrograma -> program id; declaración begin cuerpo end}
     new(TAS[vPrograma,tProgram]);
     TAS[vPrograma,tProgram]^.elem[1]:=tProgram;
     TAS[vPrograma,tProgram]^.elem[2]:=tId;
     TAS[vPrograma,tProgram]^.elem[3]:=tPuntoyComa;
     TAS[vPrograma,tProgram]^.elem[4]:=vDeclaracion;
     TAS[vPrograma,tProgram]^.elem[5]:=tBegin;
     TAS[vPrograma,tProgram]^.elem[6]:=vCuerpo;
     TAS[vPrograma,tProgram]^.elem[7]:=tEnd;
     TAS[vPrograma,tProgram]^.cant:=7;
     {vDeclaracion -> var variables}
     new(TAS[vDeclaracion,tVar]);
     TAS[vDeclaracion,tVar]^.elem[1]:=tVar;
     TAS[vDeclaracion,tVar]^.elem[2]:=vVariables;
     TAS[vDeclaracion,tVar]^.cant:=2  ;
     {vVariables -> epsilon }
     new(TAS[vVariables,tBegin]);
     TAS[vVariables,tBegin]^.cant:=0;
     {vVariables -> ids = tipo variables}
     new(TAS[vVariables,tId]);
     TAS[vVariables,tId]^.elem[1]:=vIds;
     TAS[vVariables,tId]^.elem[2]:=tAsignacion;
     TAS[vVariables,tId]^.elem[3]:=vTipo;
     TAS[vVariables,tId]^.elem[4]:=vVariables;
     TAS[vVariables,tId]^.cant:=4;
     {vIds -> id id2}
     new(TAS[vIds,tId]);
     TAS[vIds,tId]^.elem[1]:=tId;
     TAS[vIds,tId]^.elem[2]:=vId2;
     TAS[vIds,tId]^.cant:=2;
     {vId2 -> , id id2}
     new(TAS[vId2,tComa]);
     TAS[vId2,tComa]^.elem[1]:=tComa;
     TAS[vId2,tComa]^.elem[2]:=tId;
     TAS[vId2,tComa]^.elem[3]:=vId2;
     TAS[vId2,tComa]^.cant:=3;
     {vId2 -> epsilon}
     new(TAS[vId2,tAsignacion]);
     TAS[vId2,tAsignacion]^.cant:=0;
     {vTipo -> real;}
     new(TAS[vTipo,tRealT]);
     TAS[vTipo,tRealT]^.elem[1]:=tRealT;
     TAS[vTipo,tRealT]^.elem[2]:=tPuntoyComa;
     TAS[vTipo,tRealT]^.cant:=2;
     {vTipo -> vector}
     new(TAS[vTipo,tArray]);
     TAS[vTipo,tArray]^.elem[1]:=tArray;
     TAS[vTipo,tArray]^.elem[2]:=tCorcheteA;
     TAS[vTipo,tArray]^.elem[3]:=vexpArit;
     TAS[vTipo,tArray]^.elem[4]:=tCorcheteC;
     TAS[vTipo,tArray]^.elem[5]:=tPuntoyComa;
     TAS[vTipo,tArray]^.cant:= 5;
     {vCuerpo -> sent B}
     new(TAS[vCuerpo,tId]);
     TAS[vCuerpo,tId]^.elem[1]:=vSent;
     TAS[vCuerpo,tId]^.elem[2]:=vB;
     TAS[vCuerpo,tId]^.cant:=2;

     new(TAS[vCuerpo,tIf]);
     TAS[vCuerpo,tIf]^.elem[1]:=vSent;
     TAS[vCuerpo,tIf]^.elem[2]:=vB;
     TAS[vCuerpo,tIf]^.cant:=2;

     new(TAS[vCuerpo,tWhile]);
     TAS[vCuerpo,tWhile]^.elem[1]:=vSent;
     TAS[vCuerpo,tWhile]^.elem[2]:=vB;
     TAS[vCuerpo,tWhile]^.cant:=2;

     new(TAS[vCuerpo,tFor]);
     TAS[vCuerpo,tFor]^.elem[1]:=vSent;
     TAS[vCuerpo,tFor]^.elem[2]:=vB;
     TAS[vCuerpo,tFor]^.cant:=2;

     new(TAS[vCuerpo,tCase]);
     TAS[vCuerpo,tCase]^.elem[1]:=vSent;
     TAS[vCuerpo,tCase]^.elem[2]:=vB;
     TAS[vCuerpo,tCase]^.cant:=2;

     new(TAS[vCuerpo,tRead]);
     TAS[vCuerpo,tRead]^.elem[1]:=vSent;
     TAS[vCuerpo,tRead]^.elem[2]:=vB;
     TAS[vCuerpo,tRead]^.cant:=2;

     new(TAS[vCuerpo,tWrite]);
     TAS[vCuerpo,tWrite]^.elem[1]:=vSent;
     TAS[vCuerpo,tWrite]^.elem[2]:=vB;
     TAS[vCuerpo,tWrite]^.cant:=2;
     {vB -> epsilon}
     new(TAS[vB,tEnd]);
     TAS[vB,tEnd]^.cant:=0;
     {vB -> epsilon}  //agregue
     new(TAS[vB,tCorcheteC]);
     TAS[vB,tCorcheteC]^.cant:=0;
     {vB -> sent B}
     new(TAS[vB,tId]);
     TAS[vB,tId]^.elem[1]:=vSent;
     TAS[vB,tId]^.elem[2]:=vB;
     TAS[vB,tId]^.cant:=2;

     new(TAS[vB,tIf]);
     TAS[vB,tIf]^.elem[1]:=vSent;
     TAS[vB,tIf]^.elem[2]:=vB;
     TAS[vB,tIf]^.cant:=2;

     new(TAS[vB,tWhile]);
     TAS[vB,tWhile]^.elem[1]:=vSent;
     TAS[vB,tWhile]^.elem[2]:=vB;
     TAS[vB,tWhile]^.cant:=2;

     new(TAS[vB,tFor]);
     TAS[vB,tFor]^.elem[1]:=vSent;
     TAS[vB,tFor]^.elem[2]:=vB;
     TAS[vB,tFor]^.cant:=2;

     new(TAS[vB,tCase]);
     TAS[vB,tCase]^.elem[1]:=vSent;
     TAS[vB,tCase]^.elem[2]:=vB;
     TAS[vB,tCase]^.cant:=2;

     new(TAS[vB,tRead]);
     TAS[vB,tRead]^.elem[1]:=vSent;
     TAS[vB,tRead]^.elem[2]:=vB;
     TAS[vB,tRead]^.cant:=2;

     new(TAS[vB,tWrite]);
     TAS[vB,tWrite]^.elem[1]:=vSent;
     TAS[vB,tWrite]^.elem[2]:=vB;
     TAS[vB,tWrite]^.cant:=2;
     {vSent ->  asignacion}
     new(TAS[vSent,tId]);
     TAS[vSent,tId]^.elem[1]:=vAsignacion;
     TAS[vSent,tId]^.cant:=1;
     {vSent ->  condicional}
     new(TAS[vSent,tIf]);
     TAS[vSent,tIf]^.elem[1]:=vCondicional;
     TAS[vSent,tIf]^.cant:=1;
     {vSent ->  ciclo}
     new(TAS[vSent,tWhile]);
     TAS[vSent,tWhile]^.elem[1]:=vCiclo;
     TAS[vSent,tWhile]^.cant:=1;

     new(TAS[vSent,tFor]);
     TAS[vSent,tFor]^.elem[1]:=vCiclo;
     TAS[vSent,tFor]^.cant:=1;
     {vSent ->  segun}
     new(TAS[vSent,tCase]);
     TAS[vSent,tCase]^.elem[1]:=vSegun;
     TAS[vSent,tCase]^.cant:=1;
     {vSent ->  read[idJ]}
     new(TAS[vSent,tRead]);
     TAS[vSent,tRead]^.elem[1]:=tRead;
     TAS[vSent,tRead]^.elem[2]:=tCorcheteA;
     TAS[vSent,tRead]^.elem[3]:=tId;
     TAS[vSent,tRead]^.elem[4]:=vJ;
     TAS[vSent,tRead]^.elem[5]:=tCorcheteC;
     TAS[vSent,tRead]^.cant:=5;
     {vSent ->  write[expArit]}
     new(TAS[vSent,tWrite]);
     TAS[vSent,tWrite]^.elem[1]:=tWrite;
     TAS[vSent,tWrite]^.elem[2]:=tCorcheteA;
     TAS[vSent,tWrite]^.elem[3]:=vExpArit;
     TAS[vSent,tWrite]^.elem[4]:=tCorcheteC;
     TAS[vSent,tWrite]^.cant:=4;
     {vAsignacion -> id J = expArit;}
     new(TAS[vAsignacion,tId]);
     TAS[vAsignacion,tId]^.elem[1]:=tId;
     TAS[vAsignacion,tId]^.elem[2]:=vJ;
     TAS[vAsignacion,tId]^.elem[3]:=tAsignacion;
     TAS[vAsignacion,tId]^.elem[4]:=vExpArit;
     TAS[vAsignacion,tId]^.elem[5]:=tPuntoyComa;
     TAS[vAsignacion,tId]^.cant:=5;
     {vExpArit -> MX}
     new(TAS[vExpArit,tId]);
     TAS[vExpArit,tId]^.elem[1]:=vM;
     TAS[vExpArit,tId]^.elem[2]:=vX;
     TAS[vExpArit,tId]^.cant:=2;

     new(TAS[vExpArit,tParentesisA]);
     TAS[vExpArit,tParentesisA]^.elem[1]:=vM;
     TAS[vExpArit,tParentesisA]^.elem[2]:=vX;
     TAS[vExpArit,tParentesisA]^.cant:=2;

     new(TAS[vExpArit,tReal]);
     TAS[vExpArit,tReal]^.elem[1]:=vM;
     TAS[vExpArit,tReal]^.elem[2]:=vX;
     TAS[vExpArit,tReal]^.cant:=2;

     new(TAS[vExpArit,tResta]);
     TAS[vExpArit,tResta]^.elem[1]:=vM;
     TAS[vExpArit,tResta]^.elem[2]:=vX;
     TAS[vExpArit,tResta]^.cant:=2;
     {vX -> epsilon}
     new(TAS[vX,tPuntoyComa]);
     TAS[vX,tPuntoyComa]^.cant:=0;
     {vX -> epsilon}
     new(TAS[vX,tCorcheteC]);
     TAS[vX,tCorcheteC]^.cant:=0;
     {vX -> epsilon}
     new(TAS[vX,tParentesisC]);
     TAS[vX,tParentesisC]^.cant:=0;
     {vX -> epsilon}
     new(TAS[vX,tComillaSimple]);
     TAS[vX,tComillaSimple]^.cant:=0;
     {vX -> RX}
     new(TAS[vX,tSuma]);
     TAS[vX,tSuma]^.elem[1]:=vR;
     TAS[vX,tSuma]^.elem[2]:=vX;
     TAS[vX,tSuma]^.cant:=2;
     {vX -> RX}
     new(TAS[vX,tResta]);
     TAS[vX,tResta]^.elem[1]:=vR;
     TAS[vX,tResta]^.elem[2]:=vX;
     TAS[vX,tResta]^.cant:=2;
     {vX -> epsilon}
     new(TAS[vX,tOpRel]);
     TAS[vX,tOpRel]^.cant:=0;
     {vX -> epsilon}
     new(TAS[vX,tTo]);
     TAS[vX,tTo]^.cant:=0;
     {vX -> epsilon}
     new(TAS[vX,tDo]);
     TAS[vX,tDo]^.cant:=0;
     {vR -> +M}
     new(TAS[vR,tSuma]);
     TAS[vR,tSuma]^.elem[1]:=tSuma;
     TAS[vR,tSuma]^.elem[2]:=vM;
     TAS[vR,tSuma]^.cant:=2;
     {vR -> -M}
     new(TAS[vR,tResta]);
     TAS[vR,tResta]^.elem[1]:=tResta;
     TAS[vR,tResta]^.elem[2]:=vM;
     TAS[vR,tResta]^.cant:=2;
     {vM -> GT}
     new(TAS[vM,tId]);
     TAS[vM,tId]^.elem[1]:=vG;
     TAS[vM,tId]^.elem[2]:=vT;
     TAS[vM,tId]^.cant:=2;
     {vM -> GT}
     new(TAS[vM,tParentesisA]);
     TAS[vM,tParentesisA]^.elem[1]:=vG;
     TAS[vM,tParentesisA]^.elem[2]:=vT;
     TAS[vM,tParentesisA]^.cant:=2;
     {vM -> GT}
     new(TAS[vM,tReal]);
     TAS[vM,tReal]^.elem[1]:=vG;
     TAS[vM,tReal]^.elem[2]:=vT;
     TAS[vM,tReal]^.cant:=2;
     {vM -> GT}
     new(TAS[vM,tResta]);
     TAS[vM,tResta]^.elem[1]:=vG;
     TAS[vM,tResta]^.elem[2]:=vT;
     TAS[vM,tResta]^.cant:=2;
     {vT -> epsilon}
     new(TAS[vT,tPuntoyComa]);
     TAS[vT,tPuntoyComa]^.cant:=0;
     {vT -> epsilon}
     new(TAS[vT,tCorcheteC]);
     TAS[vT,tCorcheteC]^.cant:=0;
     {vT -> epsilon}
     new(TAS[vT,tParentesisC]);
     TAS[vT,tParentesisC]^.cant:=0;
     {vT -> epsilon}
     new(TAS[vT,tSuma]);
     TAS[vT,tSuma]^.cant:=0;
     {vT -> epsilon}
     new(TAS[vT,tResta]);
     TAS[vT,tResta]^.cant:=0;
     {vT -> epsilon}
     new(TAS[vT,tComillaSimple]);
     TAS[vT,tComillaSimple]^.cant:=0;
     {vT -> epsilon}
     new(TAS[vT,tTo]);
     TAS[vT,tTo]^.cant:=0;
     {vT -> YT}
     new(TAS[vT,tMult]);
     TAS[vT,tMult]^.elem[1]:=vY;
     TAS[vT,tMult]^.elem[2]:=vT;
     TAS[vT,tMult]^.cant:=2;
     {vT -> YT}
     new(TAS[vT,tDiv]);
     TAS[vT,tDiv]^.elem[1]:=vY;
     TAS[vT,tDiv]^.elem[2]:=vT;
     TAS[vT,tDiv]^.cant:=2;
     {vT -> epsilon}
     new(TAS[vT,tOpRel]);
     TAS[vT,tOpRel]^.cant:=0;
     {vT -> epsilon}
     new(TAS[vT,tTo]);
     TAS[vT,tTo]^.cant:=0;
     {vT -> epsilon}
     new(TAS[vT,tDo]);
     TAS[vT,tDo]^.cant:=0;
     {vY -> *G}
     new(TAS[vY,tMult]);
     TAS[vY,tMult]^.elem[1]:=tMult;
     TAS[vY,tMult]^.elem[2]:=vG;
     TAS[vY,tMult]^.cant:=2;
     {vY -> /G}
     new(TAS[vY,tDiv]);
     TAS[vY,tDiv]^.elem[1]:=tDiv;
     TAS[vY,tDiv]^.elem[2]:=vG;
     TAS[vY,tDiv]^.cant:=2;
     {vG -> numZ}
     new(TAS[vG,tId]);
     TAS[vG,tId]^.elem[1]:=vNum;
     TAS[vG,tId]^.elem[2]:=vZ;
     TAS[vG,tId]^.cant:=2;
     {vG -> numZ}
     new(TAS[vG,tParentesisA]);
     TAS[vG,tParentesisA]^.elem[1]:=vNum;
     TAS[vG,tParentesisA]^.elem[2]:=vZ;
     TAS[vG,tParentesisA]^.cant:=2;
     {vG -> numZ}
     new(TAS[vG,tReal]);
     TAS[vG,tReal]^.elem[1]:=vNum;
     TAS[vG,tReal]^.elem[2]:=vZ;
     TAS[vG,tReal]^.cant:=2;
     {vG -> numZ}
     new(TAS[vG,tResta]);
     TAS[vG,tResta]^.elem[1]:=vNum;
     TAS[vG,tResta]^.elem[2]:=vZ;
     TAS[vG,tResta]^.cant:=2;
     {vZ -> epsilon}
     new(TAS[vZ,tPuntoyComa]);
     TAS[vZ,tPuntoyComa]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tCorcheteC]);
     TAS[vZ,tCorcheteC]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tParentesisC]);
     TAS[vZ,tParentesisC]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tSuma]);
     TAS[vZ,tSuma]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tResta]);
     TAS[vZ,tResta]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tMult]);
     TAS[vZ,tMult]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tDiv]);
     TAS[vZ,tDiv]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tOpRel]);
     TAS[vZ,tOpRel]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tComillaSimple]);
     TAS[vZ,tComillaSimple]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tTo]);
     TAS[vZ,tTo]^.cant:=0;
     {vZ -> epsilon}
     new(TAS[vZ,tDo]);
     TAS[vZ,tDo]^.cant:=0;
     {vZ -> ^numZ}
     new(TAS[vZ,tPot]);
     TAS[vZ,tPot]^.elem[1]:=tPot;
     TAS[vZ,tPot]^.elem[2]:=vNum;
     TAS[vZ,tPot]^.elem[3]:=vZ;
     TAS[vZ,tPot]^.cant:=3;
     {num -> -const}
     new(TAS[vNum,tResta]);
     TAS[vNum,tResta]^.elem[1]:=tResta;
     TAS[vNum,tResta]^.elem[2]:=tReal;
     TAS[vNum,tResta]^.cant:=2;
     {num -> const}
     new(TAS[vNum,tReal]);
     TAS[vNum,tReal]^.elem[1]:=tReal;
     TAS[vNum,tReal]^.cant:=1;
     {num -> idJ}
     new(TAS[vNum,tId]);
     TAS[vNum,tId]^.elem[1]:=tId;
     TAS[vNum,tId]^.elem[2]:=vJ;
     TAS[vNum,tId]^.cant:=2;
     {num -> (expArit)}
     new(TAS[vNum,tParentesisA]);
     TAS[vNum,tParentesisA]^.elem[1]:=tParentesisA;
     TAS[vNum,tParentesisA]^.elem[2]:=vExpArit;
     TAS[vNum,tParentesisA]^.elem[3]:=tParentesisC;
     TAS[vNum,tParentesisA]^.cant:=3;
     {vJ -> epsilon}
     new(TAS[vJ,tPuntoyComa]);
     TAS[vJ,tPuntoyComa]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tCorcheteC]);
     TAS[vJ,tCorcheteC]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tParentesisC]);
     TAS[vJ,tParentesisC]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tSuma]);
     TAS[vJ,tSuma]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tResta]);
     TAS[vJ,tResta]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tMult]);
     TAS[vJ,tMult]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tDiv]);
     TAS[vJ,tDiv]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tOpRel]);
     TAS[vJ,tOpRel]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tPot]);
     TAS[vJ,tPot]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tAsignacion]);
     TAS[vJ,tAsignacion]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tTo]);
     TAS[vJ,tTo]^.cant:=0;
     {vJ -> epsilon}
     new(TAS[vJ,tDo]);
     TAS[vJ,tDo]^.cant:=0;
     {vJ -> [expArit]}
     new(TAS[vJ,tCorcheteA]);
     TAS[vJ,tCorcheteA]^.elem[1]:=tCorcheteA;
     TAS[vJ,tCorcheteA]^.elem[2]:=vExpArit;
     TAS[vJ,tCorcheteA]^.elem[3]:=tCorcheteC;
     TAS[vJ,tCorcheteA]^.cant:=3;
     {condiciones -> NK}
      new(TAS[vCondiciones,tParentesisA]);
      TAS[vCondiciones,tParentesisA]^.elem[1]:=vN;
      TAS[vCondiciones,tParentesisA]^.elem[2]:=vK;
     TAS[vCondiciones,tParentesisA]^.cant:=2;
     {condiciones -> NK}
     new(TAS[vCondiciones,tNot]);
     TAS[vCondiciones,tNot]^.elem[1]:=vN;
     TAS[vCondiciones,tNot]^.elem[2]:=vK;
     TAS[vCondiciones,tNot]^.cant:=2;
     {K -> epsilon}
     new(TAS[vK,tCorcheteA]);
     TAS[vK,tCorcheteA]^.cant:=0;
     {K -> epsilon}
     new(TAS[vK,tParentesisC]);
     TAS[vK,tParentesisC]^.cant:=0;
     {K -> AK}
     new(TAS[vK,tAnd]);
     TAS[vK,tAnd]^.elem[1]:=vA;
     TAS[vK,tAnd]^.elem[2]:=vk;
     TAS[vK,tAnd]^.cant:=2;
     {A -> and N}
     new(TAS[vA,tAnd]);
     TAS[vA,tAnd]^.elem[1]:=tAnd;
     TAS[vA,tAnd]^.elem[2]:=vN;
     TAS[vA,tAnd]^.cant:=2;
     {N -> condic Q}
     new(TAS[vN,tParentesisA]);
     TAS[vN,tParentesisA]^.elem[1]:=vCondic;
     TAS[vN,tParentesisA]^.elem[2]:=vQ;
     TAS[vN,tParentesisA]^.cant:=2;
     {N -> condic Q}
     new(TAS[vN,tNot]);
     TAS[vN,tNot]^.elem[1]:=vCondic;
     TAS[vN,tNot]^.elem[2]:=vQ;
     TAS[vN,tNot]^.cant:=2;
     {Q -> epsilon}
     new(TAS[vQ,tCorcheteA]);
     TAS[vQ,tCorcheteA]^.cant:=0;
     {Q -> epsilon}
     new(TAS[vQ,tAnd]);
     TAS[vQ,tAnd]^.cant:=0;
     {Q -> epsilon}
     new(TAS[vQ,tParentesisC]);
     TAS[vQ,tParentesisC]^.cant:=0;
     {Q -> LQ}
     new(TAS[vQ,tOr]);
     TAS[vQ,tOr]^.elem[1]:=vL;
     TAS[vQ,tOr]^.elem[2]:=vQ;
     TAS[vQ,tOr]^.cant:=2;
     {L -> or condic}
     new(TAS[vL,tOr]);
     TAS[vL,tOr]^.elem[1]:=tOr;
     TAS[vL,tOr]^.elem[2]:=vCondic;
     TAS[vL,tOr]^.cant:=2;
     {condic -> (cond)}
     new(TAS[vCondic, tParentesisA]);
     TAS[vCondic,tParentesisA]^.elem[1]:= tParentesisA;
     TAS[vCondic,tParentesisA]^.elem[2]:= vCond;
     TAS[vCondic,tParentesisA]^.elem[3]:= tParentesisC;
     TAS[vCondic,tParentesisA]^.cant:=3;
     {condic -> not(condiciones)}
     new(TAS[vCondic, tNot]);
     TAS[vCondic,tNot]^.elem[1]:= tNot;
     TAS[vCondic,tNot]^.elem[2]:= tParentesisA;
     TAS[vCondic,tNot]^.elem[3]:= vCondiciones;
     TAS[vCondic,tNot]^.elem[4]:= tParentesisC;
     TAS[vCondic,tNot]^.cant:=4;

     {cond -> expArit opRel expArit }
     new(TAS[vCond,tId]);
     TAS[vCond,tId]^.elem[1]:=vExpArit;
     TAS[vCond,tId]^.elem[2]:=tOpRel;
     TAS[vCond,tId]^.elem[3]:=vExpArit;
     TAS[vCond,tId]^.cant:=3;
     {cond -> expArit opRel expArit }
     new(TAS[vCond,tParentesisA]);
     TAS[vCond,tParentesisA]^.elem[1]:=vExpArit;
     TAS[vCond,tParentesisA]^.elem[2]:=tOpRel;
     TAS[vCond,tParentesisA]^.elem[3]:=vExpArit;
     TAS[vCond,tParentesisA]^.cant:=3;
     {cond -> expArit opRel expArit }
     new(TAS[vCond,tReal]);
     TAS[vCond,tReal]^.elem[1]:=vExpArit;
     TAS[vCond,tReal]^.elem[2]:=tOpRel;
     TAS[vCond,tReal]^.elem[3]:=vExpArit;
     TAS[vCond,tReal]^.cant:=3;
     {condicional -> if condiciones [cuerpo] E}
     new(TAS[vCondicional,tIf]);
     TAS[vCondicional,tIf]^.elem[1]:=tIf;
     TAS[vCondicional,tIf]^.elem[2]:=vCondiciones;
     TAS[vCondicional,tIf]^.elem[3]:=tCorcheteA;
     TAS[vCondicional,tIf]^.elem[4]:=vCuerpo;
     TAS[vCondicional,tIf]^.elem[5]:=tCorcheteC;
     TAS[vCondicional,tIf]^.elem[6]:=vE;
     TAS[vCondicional,tIf]^.cant:=6;
     {E -> epsilon}
     new(TAS[vE,tEnd]);
     TAS[vE,tEnd]^.cant:=0;
     {E -> epsilon}
     new(TAS[vE,tId]);
     TAS[vE,tId]^.cant:=0;
     {E -> epsilon}
     new(TAS[vE,tIf]);
     TAS[vE,tIf]^.cant:=0;
     {E -> epsilon}
     new(TAS[vE,tWhile]);
     TAS[vE,tWhile]^.cant:=0;
     {E -> epsilon}
     new(TAS[vE,tFor]);
     TAS[vE,tFor]^.cant:=0;
     {E -> epsilon}
     new(TAS[vE,tCase]);
     TAS[vE,tCase]^.cant:=0;
     {E -> epsilon}
     new(TAS[vE,tRead]);
     TAS[vE,tRead]^.cant:=0;
     {E -> epsilon}
     new(TAS[vE,tWrite]);
     TAS[vE,tWrite]^.cant:=0;
     {E -> epsilon}
     new(TAS[vE,tCorcheteC]);
     TAS[vE,tCorcheteC]^.cant:=0;
     {E -> else [cuerpo]}
     new(TAS[vE,tElse]);
     TAS[vE,tElse]^.elem[1]:=tElse;
     TAS[vE,tElse]^.elem[2]:=tCorcheteA;
     TAS[vE,tElse]^.elem[3]:=vCuerpo;
     TAS[vE,tElse]^.elem[4]:=tCorcheteC;
     TAS[vE,tElse]^.cant:=4;
     {ciclo -> while condiciones [cuerpo]}
     new(TAS[vCiclo,tWhile]);
     TAS[vCiclo,tWhile]^.elem[1]:=tWhile;
     TAS[vCiclo,tWhile]^.elem[2]:=vCondiciones;
     TAS[vCiclo,tWhile]^.elem[3]:=tCorcheteA;
     TAS[vCiclo,tWhile]^.elem[4]:=vCuerpo;
     TAS[vCiclo,tWhile]^.elem[5]:=tCorcheteC;
     TAS[vCiclo,tWhile]^.cant:=5;
     {ciclo -> for id= expArit to expArit [cuerpo]}
     new(TAS[vCiclo,tFor]);
     TAS[vCiclo,tFor]^.elem[1]:=tFor;
     TAS[vCiclo,tFor]^.elem[2]:=tId;
     TAS[vCiclo,tFor]^.elem[3]:=tAsignacion;
     TAS[vCiclo,tFor]^.elem[4]:=vExpArit;
     TAS[vCiclo,tFor]^.elem[5]:=tTo;
     TAS[vCiclo,tFor]^.elem[6]:=vExpArit;
     TAS[vCiclo,tFor]^.elem[7]:=tDo;
     TAS[vCiclo,tFor]^.elem[8]:=tCorcheteA;
     TAS[vCiclo,tFor]^.elem[9]:=vCuerpo;
     TAS[vCiclo,tFor]^.elem[10]:=tCorcheteC;
     TAS[vCiclo,tFor]^.cant:=10;
     {segun→ case of id ’expArit’ [cuerpo] cuerposegun}
     new(TAS[vSegun,tCase]);
     TAS[vSegun,tCase]^.elem[1]:=tCase;
     TAS[vSegun,tCase]^.elem[2]:=tOf;
     TAS[vSegun,tCase]^.elem[3]:=tId;
     TAS[vSegun,tCase]^.elem[4]:=tComillaSimple;
     TAS[vSegun,tCase]^.elem[5]:=vExpArit;
     TAS[vSegun,tCase]^.elem[6]:=tComillaSimple;
     TAS[vSegun,tCase]^.elem[7]:=tCorcheteA;
     TAS[vSegun,tCase]^.elem[8]:=vCuerpo;
     TAS[vSegun,tCase]^.elem[9]:=tCorcheteC;
     TAS[vSegun,tCase]^.elem[10]:=vCuerpoSegun;
     TAS[vSegun,tCase]^.cant:=10;
     {cuerposegun -> epsilon}
     new(TAS[vCuerpoSegun,tEnd]);
     TAS[vCuerpoSegun,tEnd]^.cant:=0;
     {cuerposegun -> epsilon}
     new(TAS[vCuerpoSegun,tId]);
     TAS[vCuerpoSegun,tId]^.cant:=0;
     {cuerposegun -> epsilon}
     new(TAS[vCuerpoSegun,tIf]);
     TAS[vCuerpoSegun,tIf]^.cant:=0;
     {cuerposegun -> epsilon}
     new(TAS[vCuerpoSegun,tWhile]);
     TAS[vCuerpoSegun,tWhile]^.cant:=0;
     {cuerposegun -> epsilon}
     new(TAS[vCuerpoSegun,tFor]);
     TAS[vCuerpoSegun,tFor]^.cant:=0;
     {cuerposegun -> epsilon}
     new(TAS[vCuerpoSegun,tCase]);
     TAS[vCuerpoSegun,tCase]^.cant:=0;
     {cuerposegun -> epsilon}
     new(TAS[vCuerpoSegun,tRead]);
     TAS[vCuerpoSegun,tRead]^.cant:=0;
     {cuerposegun -> epsilon}
     new(TAS[vCuerpoSegun,tWrite]);
     TAS[vCuerpoSegun,tWrite]^.cant:=0;
     {cuerposegun -> ’num’ [cuerpo] cuerposegun}
     new(TAS[vCuerpoSegun,tComillaSimple]);
     TAS[vCuerpoSegun,tComillaSimple]^.elem[1]:=tComillaSimple;
     TAS[vCuerpoSegun,tComillaSimple]^.elem[2]:=vExpArit;
     TAS[vCuerpoSegun,tComillaSimple]^.elem[3]:=tComillaSimple;
     TAS[vCuerpoSegun,tComillaSimple]^.elem[4]:=tCorcheteA;
     TAS[vCuerpoSegun,tComillaSimple]^.elem[5]:=vCuerpo;
     TAS[vCuerpoSegun,tComillaSimple]^.elem[6]:=tCorcheteC;
     TAS[vCuerpoSegun,tComillaSimple]^.elem[7]:=vCuerpoSegun;
     TAS[vCuerpoSegun,tComillaSimple]^.cant:=7;
     {boolean -> true}
     new(TAS[vBoolean,tTrue]);
     TAS[vBoolean,tTrue]^.elem[1]:=tTrue;
     TAS[vBoolean,tTrue]^.cant:=1;
     {boolean -> false}
     new(TAS[vBoolean,tFalse]);
     TAS[vBoolean,tFalse]^.elem[1]:=tFalse;
     TAS[vBoolean,tFalse]^.cant:=1;

 end;



end.

