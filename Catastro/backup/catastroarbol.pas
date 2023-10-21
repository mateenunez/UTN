unit catastroarbol;


interface
uses
  crt, catastrounit;
  type
  pa_punt = ^pa_nodo;
  pa_nodo = record
            info: p_dato;
            sai, sad: pa_punt;
  end;

procedure agregar_adni(var raiz:pa_punt; x:p_dato);
procedure agregar_ana(var raiz:pa_punt; x : p_dato);
procedure crear_arbol (var raiz:pa_punt);
implementation

procedure agregar_adni(var raiz:pa_punt; x : p_dato);
begin
if raiz = nil then
begin
new(raiz);
raiz^.info:= x;
raiz^.sai:= nil;
raiz^.sad:= nil;
end
else if raiz^.info.dni > x.dni then agregar_adni(raiz^.sai,x)
else agregar_adni(raiz^.sad,x)
end;

procedure agregar_ana(var raiz:pa_punt; x : p_dato);
begin
if raiz = nil then
begin
new(raiz);
raiz^.info:= x;
raiz^.sai:= nil;
raiz^.sad:= nil;
end
else if (raiz^.info.nombre + raiz^.info.apellido) > (x.nombre + x.apellido) then agregar_ana(raiz^.sai,x)
else agregar_ana(raiz^.sad,x)
end;

procedure crear_arbol (var raiz:pa_punt);
begin
raiz:= nil;
end;


end.

