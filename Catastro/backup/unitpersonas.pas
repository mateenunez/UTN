unit unitpersonas;



interface
uses Classes, SysUtils, unitarbolpersonas;
const ruta1 = 'C:\Users\Juan Zanuttini\Desktop\algoritmo\Archivos\propietarios.dat';

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

procedure cargar_datos_p(var p_archivo:t_archivo; var x:p_dato);
procedure agregar_p(var p_archivo:t_archivo; var x:p_dato);
procedure abrir_p_archivo(var arch:p_archivo);

implementation

procedure abrir_p_archivo(var arch:p_archivo);
begin
    assign(arch, ruta1);
    reset(arch);
end;
procedure agregar_p(var p_archivo:t_archivo;var raiz;pa_punt var x:p_dato);
var
  pos:byte;
begin
     pos:=filesize(p_archivo);
     write(p_archivo,pos,x);
     agregar_adni(raiz,x,pos);
     agregar_ana(raiz,x,pos);
end;

procedure cargar_datos_p(var x:p_dato);

begin
  with x do
  begin
  gotoxy(50,10);
  writeln('A continuacion podra cargar todos los datos de un registro de terrenos. Presione cualquier tecla para continuar.');
  readkey();
  clrscr;
  gotoxy(30,10);
  writeln('Numero de contribuyente.');
  gotoxy(30,11);
  readln(n_contrib);
  clrscr;

  gotoxy(30,10);
  writeln('Apellido.');
  gotoxy(30,11);
  readln(apellido);
  clrscr;

  gotoxy(30,10);
  writeln('Nombre.');
  gotoxy(30,11);
  readln(nombre);
  clrscr;

  gotoxy(30,10);
  writeln('Avaluo.');
  gotoxy(30,11);
  readln(avaluo);
  clrscr;

  gotoxy(30,10);
  writeln('Dirección.');
  gotoxy(30,11);
  readln(direccion);
  clrscr;

  gotoxy(30,10);
  writeln('Ciudad.');
  gotoxy(30,11);
  readln(ciudad);
  clrscr;

  gotoxy(30,10);
  writeln('DNI.');
  gotoxy(30,11);
  readln(dni);
  clrscr;

  gotoxy(30,10);
  writeln('Fecha de Nacimiento.');
  gotoxy(30,11);
  readln(fecha_n);
  clrscr;

  gotoxy(30,10);
  writeln('Telefono.');
  gotoxy(30,11);
  readln(tel);
  clrscr;

  gotoxy(30,10);
  writeln('Email.');
  gotoxy(30,11);
  readln(email);
  clrscr;

  estado:=true;

  end;
end;


end.

