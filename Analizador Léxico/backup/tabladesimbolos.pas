unit TablaDeSimbolos;


interface

uses
  Classes, SysUtils, crt, ManejoConLista;

procedure CargarEnTAS(var palabrasReservadas: lista; var Lexema:string; var CompLex:componentelex);
procedure CargarPalabras(var palabrasReservadas: lista);
//procedure MostrarPalabras(var palabrasReservadas: lista);

implementation

procedure  CargarEnTAS(var palabrasReservadas: lista; var Lexema:string; var CompLex:componentelex);
var
   aux:t_puntero;
   x: info;
   ultimo,enc:boolean;

begin
  enc:=false;
  ultimo:=false;
  aux := palabrasReservadas.cab;
  while not(ultimo) and not(enc) do
  begin
     if aux^.info.lexema = lowercase(lexema) then
     begin
          complex:= aux^.info.compLex;
          enc:=true;
     end else
     begin
          if aux^.sig = nil then
          begin
          ultimo :=true;
          end
          else aux:=aux^.sig;
     end;
  end;

  if not(enc) then
  begin
     CompLex:=tId;
     x.lexema:=Lexema;
     x.complex:= tId;
     agregaralista(palabrasReservadas,x);
  end;
end;

procedure CargarPalabras(var palabrasReservadas: lista);
var
palabra:info;

begin
palabra.lexema:='program';
palabra.complex:=tProgram;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='begin';
palabra.complex:=tBegin;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='end';
palabra.complex:=tEnd;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='if';
palabra.complex:=tIf;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='else';
palabra.complex:=tElse;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='while';
palabra.complex:=tWhile;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='case';
palabra.complex:=tCase;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='for';
palabra.complex:=tFor;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='to';
palabra.complex:=tTo;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='of';
palabra.complex:=tOf;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='read';
palabra.complex:=tRead;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='write';
palabra.complex:=tWrite;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='and';
palabra.complex:=tAnd;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='or';
palabra.complex:=tOr;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='not';
palabra.complex:=tNot;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='var';
palabra.complex:=tVar;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='real';
palabra.complex:=tRealT;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='boolean';
palabra.complex:=tBoolean;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='array';
palabra.complex:=tArray;
agregaralista(palabrasReservadas,palabra);

{palabra.lexema:=';';
palabra.complex:=tPuntoyComa;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='=';
palabra.complex:=tAsignacion;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:='[';
palabra.complex:=tCorcheteA;
agregaralista(palabrasReservadas,palabra);

palabra.lexema:=']';
palabra.complex:=tCorcheteC;
agregaralista(palabrasReservadas,palabra);}

  end;
end.

