unit ManejoConLista;



interface

uses
  Classes, SysUtils, crt;

type
  tipoSimboloGramatical = (vPrograma, vDeclaracion, vVariables, vIds, vId2, Vcuerpo, vTipo, vB, vSent, vAsignacion, vF, vExpArit, vX,vR, vM,
                        vT, vY, vG, vZ, vNum, vJ, vCondiciones, vK, vA, vN, vQ, vL, vCond, vCondicional, vCondic ,vE,vCiclo, vSegun, vCuerpoSegun, vBoolean,
                        tProgram, tBegin, tEnd, tId, tPuntoyComa, tCorcheteA, tCorcheteC, tPunto, tComa, tParentesisA, tParentesisC, tIf, tElse, tWhile,
                        tCase, tConst, tSuma, tResta, tMult, tDiv, tPot, tFor, tTo, tDo, tOf, tComillaSimple, tRead, tWrite, tAnd, tOr, tNot, tTrue, tFalse, tOpRel,
                        tAsignacion, tReal, tRealT, tBoolean, tVar, tArray, tCadena, ERRORLEXICO, PESOS);
                           {ELIMINE vOpRel, tDosPuntos, tStringT}
  componentelex = tProgram..pesos; //o hasta error lexicp
  variable = vPrograma..vBoolean;

  info = record
    lexema:string[100];
    compLex:componentelex;
    end;

  t_puntero = ^nodo;
  nodo = record
    info: info;
    sig: t_puntero;
  end;

  lista = record
  cab,act: t_puntero;
  tam: integer;
  end;

procedure crear_lista(var l:lista);
procedure agregaralista(var l:lista; x:info);
function listavacia(var l:lista):boolean;
function listallena(var l:lista):boolean;
procedure primero(var l:lista);
function fin_lista(var l:lista):boolean;
procedure mostrar_datos(var x:info);
procedure recuperar(var l:lista;var x:info);
procedure siguiente(var l:lista);
procedure mostrar_lista(var l:lista);




implementation

procedure crear_lista(var l:lista);
 begin
   l.tam:=0;
   l.cab:=nil;
   end;

procedure agregaralista(var l:lista; x:info);
 var dir, ant:t_puntero;
begin
     new(dir);
     dir^.info:=x;
     if (l.cab = nil) or (l.cab^.info.lexema > x.lexema) then
     begin
       dir^.sig:=l.cab;
       l.cab:=dir;
       end else begin
         ant:=l.cab;
         l.act:=l.cab^.sig;
         while(l.act <> nil) and (l.act^.info.lexema < x.lexema) do
         begin
               ant:=l.act;
               l.act:=l.act^.sig;
         end;
         dir^.sig:=l.act;
         ant^.sig:=dir;
         end;
       inc(l.tam)
end;

function listavacia(var l:lista):boolean;
begin
  listavacia:= l.tam = 0;
  end;

function listallena(var l:lista):boolean;
begin
  listallena:= getheapstatus.totalfree = sizeof(nodo);
  end;

procedure primero(var l:lista);
begin
  l.act:=l.cab;
  end;

function fin_lista(var l:lista):boolean;
begin
    fin_lista:=(l.act=nil)
end;

procedure mostrar_datos(var x:info);
begin
  writeln('Lexema:      ', x.lexema);
  writeln('Comp. Lexico: ', x.complex);
  end;

procedure recuperar(var l:lista;var x:info);
 begin
     x:= l.act^.info;
 end;

procedure siguiente(var l:lista);
 begin
     l.act:=l.act^.sig;
 end;

procedure mostrar_lista(var l:lista);
var x:info;
begin
  primero(l);
  while not fin_lista(l) do
  begin
        recuperar(l,x);
        mostrar_datos(x);
        siguiente(l);
        end;
  end;


end.

