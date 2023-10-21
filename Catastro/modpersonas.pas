unit modpersonas;


interface                                                   //UNIT CON PROCEDIMIENTOS PARA MODIFICAR A LOS PROPIETARIOS/AS

uses
   crt, SysUtils, archivopersonas;

const
  rutaaux= 'C:\archivos\archivoaux.dat';

procedure cargar_datos_p(var x:p_dato);
procedure campos_p();
procedure mostrar_datos_p(var j:p_dato; var y:byte);
procedure buscar_p_arch(var arch:p_archivo;var buscado:string;var pos:byte; var enc:boolean);
procedure buscar_p_arch_dni(var arch:p_archivo;var buscado:string;var pos:byte; var enc:boolean);
procedure buscar_p_arch_dni2(var arch:p_archivo;var buscado:string;var pos:byte; var enc:boolean);
procedure buscar_p_arch_na(var arch:p_archivo;var buscado:string;var pos:byte; var enc:boolean);
procedure agregar_p_arch(var arch:p_archivo; var x:p_dato);

implementation

procedure cargar_datos_p(var x:p_dato);                 //cargar datos en reg de personas
var
  ac:1..2;
  i:integer;
  fallo:boolean;
  lengthaux:byte;
begin
  with x do
  begin
     gotoxy(43,12);
     writeln('Nombre:');
     gotoxy(51,12);
     readln(nombre);
     gotoxy(43,13);
     writeln('Apellido:');
     gotoxy(53,13);
     readln(apellido);
     gotoxy(43,14);
     writeln(utf8toansi('Dirección:'));
     gotoxy(54,14);
     readln(direccion);
     gotoxy(43,15);
     writeln('Ciudad:');
     gotoxy(51,15);
     readln(ciudad);
     ac:=1;
     repeat
       if ac=2 then
         begin
           textbackground(red);
           gotoxy(43,17);
           Writeln ('La fecha ingresada es invalida, intente nuevamente.');
           textbackground(black);
         end;
         fallo:=false;
         gotoxy(43,16);
         writeln('Fecha de Nacimiento:                                   (AAAA/MM/DD)');
         gotoxy(64,16);
         readln(fecha_n);
         delete(fecha_n,5,1);
         delete(fecha_n,7,1);
         if not(TryStrToInt(fecha_n,i)) then
         begin
         gotoxy(64,16);
         writeln('              ');
         textbackground(red);
         gotoxy(43,17);
         Writeln('La fecha ingresada es invalida, intente nuevamente.');
         textbackground(black);
         fallo:=true;
         end else
         begin
         insert('/', fecha_n,5);
         insert('/', fecha_n,8);
         end;
         ac:=2;
     until (copy(fecha_n,5,1)='/') and (copy(fecha_n,8,1)='/') and (strtoint(copy(fecha_n,6,2))<=12) and (strtoint(copy(fecha_n,6,2))>0) and (fallo=false) and (strtoint(copy(fecha_n,9,2))<=31) and (strtoint(copy(fecha_n,9,2))>0) and (strtoint(copy(fecha_n,9,2))>0);
     gotoxy(43,17);
     writeln(utf8toansi('Teléfono:                                             '));
     gotoxy(53,17);
     readln(tel);
     gotoxy(43,18);
     writeln('Email:');
     gotoxy(50,18);
     readln(email);
     gotoxy(43,19);
     writeln(Utf8toAnsi('Número de contribuyente: '),x.n_contrib);
     estado:=true;
  end;
end;

procedure campos_p();
begin
   writeln(Utf8ToAnsi('N° Contrib |   DNI   | Apellido | Nombre |  Dirección  |  Ciudad  | Nacimiento | Teléfono | Email'));
end;

procedure mostrar_datos_p(var j:p_dato; var y:byte);          //mostrar datos de un reg de personas

begin
with j do
  begin
  gotoxy(15,y);
  writeln('',n_contrib);
  gotoxy(20,y);
  writeln('',dni);
  gotoxy(30,y);
  writeln('',apellido);
  gotoxy(41,y);
  writeln('',nombre);
  gotoxy(50,y);
  writeln('',direccion);
  gotoxy(64,y);
  writeln('',ciudad);
  gotoxy(76,y);
  writeln('',fecha_n);
  gotoxy(88,y);
  writeln('',tel);
  gotoxy(99,y);
  writeln('',email);
  end;
end;

procedure buscar_p_arch(var arch:p_archivo;var buscado:string;var pos:byte; var enc:boolean);
var
  x:p_dato;
begin
  seek(arch,0);
  while not(eof(arch)) do
  begin
        read(arch,x);
        if (x.n_contrib = buscado) and (x.estado=true) then
        begin
          pos:= filepos(arch)-1;
          enc:=true;
        end;
  end
end;

procedure buscar_p_arch_dni(var arch:p_archivo;var buscado:string;var pos:byte; var enc:boolean);
var
  x:p_dato;
begin
  seek(arch,0);
  while not(eof(arch)) do
  begin
        read(arch,x);
        if (x.dni = buscado) and (x.estado=true) then
        begin
          pos:= filepos(arch)-1;
          enc:=true;
        end;
  end
end;

procedure buscar_p_arch_dni2(var arch:p_archivo;var buscado:string;var pos:byte; var enc:boolean);
var
  x:p_dato;
begin
  seek(arch,0);
  while not(eof(arch)) do
  begin
        read(arch,x);
        if (x.dni = buscado) then
        begin
          pos:= filepos(arch)-1;
          enc:=true;
        end;
  end
end;

procedure buscar_p_arch_na(var arch:p_archivo;var buscado:string;var pos:byte; var enc:boolean);
var
  x:p_dato;
  nom:string;
begin
  seek(arch,0);
  while not(eof(arch)) do
  begin
        read(arch,x);
        nom:=concat(x.apellido+' '+x.nombre);
        if (nom = buscado) and (x.estado=true) then
        begin
          pos:= filepos(arch)-1;
          enc:=true;
        end;
  end
end;

procedure agregar_p_arch(var arch:p_archivo; var x:p_dato);
begin
  seek(arch, filesize(arch));
  write(arch,x);
end;


end.

