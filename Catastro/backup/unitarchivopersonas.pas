unit unitarchivopersonas;

interface
uses Classes, SysUtils,crt;
const ruta1 = 'C:\Users\Juan Zanuttini\Desktop\Algoritmo\archivos\archivopersonas.dat';

type p_dato = record
              n_contrib: string[10];
              apellido: string[50];
              nombre: string[50];
              direccion: string[50];
              ciudad: string[50];
              dni: string[8];
              fecha_n: string[10];
              tel: string[10];
              email: string[20];
              estado: boolean;
              end;
p_archivo = file of p_dato;


Procedure crear_p_arch(var arch:p_archivo);
procedure abrir_p_arch(var arch:p_archivo);
procedure cerrar_p_arch(var arch:p_archivo);
procedure cargar_datos_p(var x:p_dato);
procedure mostrar_datos_p(var x:p_dato);
procedure buscar_p_arch(var arch:p_archivo;var buscado:string;var pos:byte);
procedure agregar_p_arch(var arch:p_archivo; var x:p_dato);

implementation

procedure agregar_p_arch(var arch:p_archivo; var x:p_dato);
begin
  seek(arch, filesize(arch));
  write(arch,x);
end;

procedure cargar_datos_p(var x:p_dato);           //cargar datos en reg de personas

begin
  with x do
  begin
  clrscr;
  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln('A continuacion podra cargar todos');
  gotoxy(43,12);
  writeln('los datos de una persona.');
  gotoxy(43,13);
  writeln('Presione cualquier tecla para continuar.');
  gotoxy(43,14);
  readkey();
  clrscr;

  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln('Numero de contribuyente:');
  gotoxy(43,12);
  readln(n_contrib);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln('Nombre:');
  gotoxy(43,12);
  readln(nombre);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln('Apellido:');
  gotoxy(43,12);
  readln(apellido);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln(utf8toansi('Dirección:'));
  gotoxy(43,12);
  readln(direccion);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln('Ciudad:');
  gotoxy(43,12);
  readln(ciudad);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln('DNI:');
  gotoxy(43,12);
  readln(dni);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln('Fecha de Nacimiento:');
  gotoxy(43,12);
  readln(fecha_n);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln(utf8toansi('Teléfono:'));
  gotoxy(43,12);
  readln(tel);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de persona');
  gotoxy(43,11);
  writeln('Email:');
  gotoxy(43,12);
  readln(email);
  clrscr;

  estado:=true;

  end;
end;

procedure crear_p_arch(var arch:p_archivo);       //crear archivo de personas
begin
  assign(arch,ruta1);
  rewrite(arch);
end;

procedure abrir_p_arch(var arch:p_archivo);       //abrir archivo de personas
begin
    //assign(arch, ruta1);
    reset(arch);
end;

procedure cerrar_p_arch(var arch:p_archivo);      //cerrar archivo de personas
begin
    close(arch);
end;

procedure mostrar_datos_p(var x:p_dato);          //mostrar datos de un reg de personas

begin
with x do
  begin
  gotoxy(43,15);
  writeln('Numero de contribuyente: ',n_contrib);
  gotoxy(43,16);
  writeln('Apellido: ',apellido);
  gotoxy(43,17);
  writeln('Nombre: ', nombre);
  gotoxy(43,18);
  writeln(utf8toansi('Dirección: '), direccion);
  gotoxy(43,19);
  writeln('Ciudad: ', ciudad);
  gotoxy(43,20);
  writeln(utf8toansi('Número de documento: '), dni);
  gotoxy(43,21);
  writeln('Fecha de nacimiento: ', fecha_n);
  gotoxy(43,22);
  writeln(utf8toansi('Teléfono: '), tel);
  gotoxy(43,23);
  writeln('Email: ', email);
  end;
end;

procedure buscar_p_arch(var arch:p_archivo;var buscado:string;var pos:byte);
var
  x:p_dato;
begin
  seek(arch,0);
  while not(eof(arch)) do
  begin
        read(arch,x);
        if x.n_contrib = buscado then
        begin
          pos:= filepos(arch)-1;
        end;
  end
end;

end.

