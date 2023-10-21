Unit unitterreno;

interface
uses crt, SysUtils;
  const ruta2 = 'C:\Users\Juan Zanuttini\Desktop\Algoritmo\Archivos\terrenos.dat';

type
t_dato = record
         n_contrib: string[10];
         plano: string[10];
         fecha: string[10];
         avaluo: real;
         domicilio_p: string[50];
         superficie: real;
         zona: 1..5;
         edificacion: 1..5;
         end;
t_archivo = file of t_dato;

procedure abrirt(var arch:t_archivo);
procedure agregar_t(var arch:t_archivo; x:t_dato);
procedure cargar_datos_t(var arch:t_archivo; var x:t_dato);

implementation

procedure abrir_t_archivo(var arch:t_archivo);
begin
    assign(arch, ruta2);
    reset(arch);
end;

procedure cargar_datos_t(var arch:t_archivo; var x:t_dato);

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
  writeln('Plano.');
  gotoxy(30,11);
  readln(plano);
  clrscr;

  gotoxy(30,10);
  writeln('Fecha.');
  gotoxy(30,11);
  readln(fecha);
  clrscr;

  gotoxy(30,10);
  writeln('Avaluo.');
  gotoxy(30,11);
  readln(avaluo);
  clrscr;

  gotoxy(30,10);
  writeln('Domicilio parcelario.');
  gotoxy(30,11);
  readln(domicilio_p);
  clrscr;

  gotoxy(30,10);
  writeln('Superficie.');
  gotoxy(30,11);
  readln(superficie);
  clrscr;

  gotoxy(30,10);
  writeln('Zona.');
  gotoxy(30,11);
  readln(zona);
  clrscr;

  gotoxy(30,10);
  writeln('Edificacion.');
  gotoxy(30,11);
  readln(edificacion);
  clrscr;
  end;

end;


procedure agregar_t(var arch:t_archivo; x:t_dato);
var
  j:t_dato;
  k:byte;
begin
   if filesize(arch)=0 then
   begin
     write(arch,x);
   end
   else
   begin
   seek(arch,0);
   pos_t:=0;
   while (not(eof(arch))) and (pos_t=0) do
         begin
        read(arch,j);
        if (j.n_contrib+ j.fecha) > (x.n_contrib + x.fecha) then
        begin
          pos_t:=filepos(arch)-1;
        end;
   end;
   if pos_t=0 then
   begin
     writeln(arch,filesize(arch),x);
   end;
   else
   begin
        for k:filesize(arch) downto pos_t do
        begin
             read(arch,j);
             write(arch,j);
        end;
        write(arch,pos_t,x);
   end;
end;

end.

