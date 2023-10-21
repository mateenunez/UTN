unit unitarbolpersonas;

interface
uses
  crt, unitarchivopersonas, unitarchivoterrenos;
  type
  pa_punt = ^pa_nodo;
  pa_nodo = record
            info: p_dato;
            pos_r:byte;
            sai, sad: pa_punt;
  end;

procedure agregar_adni(var raiz:pa_punt; x:p_dato;var pos:byte);
procedure agregar_ana(var raiz:pa_punt; x : p_dato;var pos:byte);
procedure eliminar_p_adni (var raiz:pa_punt ; x:p_dato);
procedure eliminar_p_ana (var raiz:pa_punt ; x:p_dato);
procedure crear_arbol (var raiz:pa_punt);
procedure muestra_datos (x: pa_punt);
procedure consulta_adni (raiz:pa_punt);
procedure consulta_ana (raiz:pa_punt);
procedure busqueda_adni(raiz:pa_punt);
procedure busqueda_ana(raiz:pa_punt);
function arbol_vacio (raiz:pa_punt): boolean;
function preorden_ana(raiz:pa_punt;x:p_dato):pa_punt;
function preorden_adni(raiz:pa_punt;x:p_dato):pa_punt;
procedure inorden(raiz:pa_punt; pos:byte; x:p_dato);
procedure recorrer_inorden(var raiz:pa_punt; var arch:t_archivo);


implementation


procedure agregar_adni(var raiz:pa_punt; x : p_dato;var pos:byte);
begin

if raiz = nil then
begin
new(raiz);
raiz^.info:= x;
raiz^.sai:= nil;
raiz^.sad:= nil;
raiz^.pos_r:= pos;
end
else if raiz^.info.dni > x.dni then agregar_adni(raiz^.sai,x,pos)
else agregar_adni(raiz^.sad,x,pos)
end;

procedure agregar_ana(var raiz:pa_punt; x : p_dato;var pos:byte);
begin
if raiz = nil then
begin
new(raiz);
raiz^.info:= x;
raiz^.sai:= nil;
raiz^.sad:= nil;
raiz^.pos_r:=pos;
end
else if (raiz^.info.apellido + raiz^.info.nombre) > (x.apellido + x.nombre) then agregar_ana(raiz^.sai,x,pos)
else agregar_ana(raiz^.sad,x,pos)
end;

procedure crear_arbol (var raiz:pa_punt);
begin
raiz:= nil;
end;

function eliminar_min (var raiz:pa_punt):p_dato;
begin
     if raiz^.sai = nil then
     begin
          eliminar_min := raiz^.info ;
          raiz := raiz^.sad ;
     end
     else eliminar_min:=eliminar_min(raiz^.sai);
end;

procedure eliminar_p_adni (var raiz:pa_punt ; x:p_dato);
begin
     if raiz<>nil then
     begin
          if x.dni<raiz^.info.dni then eliminar_p_adni(raiz^.sai,x)
          else
            if x.dni>raiz^.info.dni then
                 eliminar_p_adni(raiz^.sad,x)
            else
                 if (raiz^.sai=nil) and (raiz^.sad=nil) then
                      raiz:=nil
                 else
                      if raiz^.sai = nil then
                         raiz:=raiz^.sad
                      else
                          if raiz^.sad = nil then
                             raiz:=raiz^.sai
                          else
                          raiz^.info:=eliminar_min(raiz^.sad);
     end;
end;

procedure eliminar_p_ana (var raiz:pa_punt ; x:p_dato);
begin
     if raiz<>nil then
     begin
          if (x.nombre + x.apellido) <(raiz^.info.nombre + raiz^.info.apellido) then
          eliminar_p_ana(raiz^.sai,x)
          else
            if (x.nombre + x.apellido) > (raiz^.info.nombre + raiz^.info.apellido) then
                 eliminar_p_ana(raiz^.sad,x)
            else
                 if (raiz^.sai=nil) and (raiz^.sad=nil) then
                      raiz:=nil
                 else
                      if raiz^.sai = nil then
                         raiz:=raiz^.sad
                      else
                          if raiz^.sad = nil then
                             raiz:=raiz^.sai
                          else
                          raiz^.info:=eliminar_min(raiz^.sad);
     end;
end;

function arbol_vacio (raiz:pa_punt): boolean;
begin
arbol_vacio:= raiz = nil;
end;

function preorden_adni(raiz:pa_punt;x:p_dato):pa_punt;
begin
if (raiz = nil) then preorden_adni:= nil
else
if ( raiz^.info.dni = x.dni ) then
preorden_adni:= raiz
else if raiz^.info.dni > x.dni then
preorden_adni := preorden_adni(raiz^.sai,x)
else
preorden_adni := preorden_adni(raiz^.sad,x)
end;

function preorden_ana(raiz:pa_punt;x:p_dato):pa_punt;
begin
if (raiz = nil) then preorden_ana := nil
else
if (raiz^.info.apellido + raiz^.info.nombre) = (x.apellido + x.nombre)  then
preorden_ana:= raiz
else if (raiz^.info.apellido + raiz^.info.nombre) > (x.apellido + x.nombre) then
preorden_ana := preorden_ana(raiz^.sai,x)
else
preorden_ana := preorden_ana(raiz^.sad,x)
end;

procedure inorden(raiz:pa_punt; pos:byte; x:p_dato);
begin
     if (raiz <> nil) then
     begin
     if (raiz^.pos_r = pos) then raiz^.info := x;
     inorden(raiz^.sai,pos,x);
     inorden(raiz^.sad,pos,x);
     end
end;

procedure muestra_datos(x:pa_punt);
var j:p_dato;
begin
     j:= x^.info;
     mostrar_datos_p(j);
end;

procedure consulta_adni (raiz:pa_punt);
var pos:pa_punt; x:p_dato;
begin
clrscr;
gotoxy(50,7);
writeln('Consulta de persona');
gotoxy(43,11);
write('Ingrese DNI de la persona a buscar: ');
gotoxy(43,12);
readln (x.dni);
pos:= preorden_adni (raiz,x);
if pos = nil then
begin
gotoxy(43,15);
writeln ('No se ha encontrado a la persona');
gotoxy(43,16);
writeln('Presione una tecla para continuar');
gotoxy(43,17);
readkey;
clrscr;
end
else
begin
  clrscr;
  gotoxy(50,7);
  writeln('Consulta de persona');
  gotoxy(43,12);
  writeln('Datos de la persona buscada:');
  muestra_datos(pos);
  gotoxy(43,25);
  writeln('Presione una tecla para continuar.');
  gotoxy(43,26);
  readkey;
end;
end;

procedure consulta_ana(raiz:pa_punt);
var pos:pa_punt; x:p_dato;
begin
clrscr;
gotoxy(50,7);
writeln('Consulta de persona');
gotoxy(43,11);
write('Ingrese nombre de la persona a buscar: ');
gotoxy(43,12);
readln (x.nombre);
lowercase(x.nombre);
gotoxy(43,13);
write('Ingrese apellido de la persona a buscar: ');
gotoxy(43,14);
readln (x.apellido);
lowercase(x.apellido);
pos:= preorden_ana(raiz,x);
if pos = nil then
begin
gotoxy(43,15);
writeln ('No se ha encontrado a la persona');
gotoxy(43,16);
writeln('Presione una tecla para continuar');
gotoxy(43,17);
readkey;
clrscr;
end
else
begin
  clrscr;
  gotoxy(50,7);
  writeln('Consulta de persona');
  gotoxy(43,12);
  writeln('Datos de la persona buscada:');
  muestra_datos(pos);
  gotoxy(43,25);
  writeln('Presione una tecla para continuar');
  gotoxy(43,26);
  readkey;
end;
end;

procedure busqueda_adni(raiz:pa_punt);
begin
     if arbol_vacio(raiz) then
     begin
     clrscr;
     gotoxy(50,7);
     writeln('Consulta de persona');
     gotoxy(43,11);
     writeln('El archivo de personas esta vacio.');
     gotoxy(43,12);
     writeln('Presione una tecla para continuar.');
     gotoxy(43,13);
     readkey;
     clrscr;
     end
     else consulta_adni(raiz);
end;

procedure busqueda_ana(raiz:pa_punt);
begin
     if arbol_vacio(raiz) then
     begin
     clrscr;
     gotoxy(50,7);
     writeln('Consulta de persona');
     gotoxy(43,11);
     writeln('El archivo de personas esta vacio.');
     gotoxy(43,12);
     writeln('Presione una tecla para continuar.');
     gotoxy(43,13);
     readkey;
     clrscr;
     end
     else consulta_ana(raiz);
end;

procedure recorrer_inorden(var raiz:pa_punt;var arch:t_archivo);
var
  x:p_dato;
  y:t_dato;
  buscado:string;
  pos:byte;
  nom,cad2:string;
begin
if raiz <> nil then
begin
abrir_t_arch(arch);
recorrer_inorden(raiz^.sai, arch);
x:= raiz^.info;
cad2:=' ';
nom:=concat(x.nombre,cad2,x.apellido);
buscar_t_arch_contrib(arch,x.n_contrib,nom);
recorrer_inorden(raiz^.sad, arch);
end

end;



end.


