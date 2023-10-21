unit procedures;

interface

uses
  Classes, crt, SysUtils, unitarchivopersonas, unitarchivoterrenos, unitarbolpersonas;


procedure muestra_p(var reg:p_dato);
procedure muestra_t(var reg:t_dato);

implementation

procedure muestra_p(var reg:p_dato);
begin
  with reg do
  begin
  gotoxy(30,10);
  writeln('Numero de contribuyente.');
  gotoxy(30,11);
  write(n_contrib);
  clrscr;

  gotoxy(30,12);
  writeln('Apellido.');
  gotoxy(30,13);
  readln(apellido);
  clrscr;

  gotoxy(30,14);
  writeln('Nombre.');
  gotoxy(30,15);
  readln(nombre);
  clrscr;

  gotoxy(30,16);
  writeln('Avaluo.');
  gotoxy(30,17);
  readln(avaluo);
  clrscr;

  gotoxy(30,18);
  writeln('Dirección.');
  gotoxy(30,19);
  readln(direccion);
  clrscr;

  gotoxy(30,20);
  writeln('Ciudad.');
  gotoxy(30,21);
  readln(ciudad);
  clrscr;

  gotoxy(30,22);
  writeln('DNI.');
  gotoxy(30,23);
  readln(dni);
  clrscr;

  gotoxy(30,24);
  writeln('Fecha de Nacimiento.');
  gotoxy(30,25);
  readln(fecha_n);
  clrscr;

  gotoxy(30,26);
  writeln('Telefono.');
  gotoxy(30,27);
  readln(tel);
  clrscr;

  gotoxy(30,27);
  writeln('Email.');
  gotoxy(30,28);
  readln(email);
  clrscr;

  if estado:=true then
     begin
     gotoxy(30,29);
     write('Estado: activo');
     end;
     else write('Estado: inactivo');

  end;
end;
end.

