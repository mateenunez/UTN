Unit unitarchivoterrenos;

interface
uses crt, SysUtils;
  const ruta2 = 'C:\Users\Juan Zanuttini\Desktop\Algoritmo\archivos\archivoterrenos.dat';
        rutaaux = 'C:\Users\Juan Zanuttini\Desktop\Algoritmo\archivos\archivoterrenosaux.dat';
        rutaaux2 = 'C:\Users\Juan Zanuttini\Desktop\Algoritmo\archivos\archivoterrenosaux2.dat';
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

procedure abrir_t_arch(var arch:t_archivo);
procedure crear_t_arch(var arch:t_archivo);
procedure cerrar_t_arch(var arch:t_archivo);
procedure agregar_t_arch(var arch:t_archivo; x:t_dato);
procedure agregar_t_archaux(var arch:t_archivo; x:t_dato);
procedure cargar_datos_t(var x:t_dato);
procedure mostrar_datos_t(var x:t_dato);
procedure eliminar_datos_t(var arch:t_archivo;var pos:byte);
procedure buscar_t_arch(var arch:t_archivo;buscado:string;var pos:byte);
procedure buscar_t_arch_contrib(var arch:t_archivo;buscado:string;var nom:string);
procedure valorizar(var x:t_dato);
procedure mostrar_t_archivo(var arch:t_archivo);

implementation

procedure cargar_datos_t( var x:t_dato);             //procedimiento para cargar datos de terrenos en reg

begin
  with x do
  begin
  gotoxy(50,7);
  writeln('Alta de terreno');
  gotoxy(43,11);
  writeln(utf8toansi('A continuación podra cargar todos'));
  gotoxy(43,12);
  writeln('los datos de un terreno.');
  gotoxy(43,13);
  writeln('Presione cualquier tecla para continuar.');
  gotoxy(43,14);
  readkey();
  clrscr;

  gotoxy(50,7);
  writeln('Alta de terreno');
  gotoxy(43,11);
  writeln('Numero de contribuyente.');
  gotoxy(43,12);
  readln(n_contrib);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de terreno');
  gotoxy(43,11);
  writeln('Plano.');
  gotoxy(43,12);
  readln(plano);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de terreno');
  gotoxy(43,11);
  writeln(utf8toansi('Fecha de inscripción.'));
  gotoxy(43,12);
  readln(fecha);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de terreno');
  gotoxy(43,11);
  writeln('Domicilio parcelario.');
  gotoxy(43,12);
  readln(domicilio_p);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de terreno');
  gotoxy(43,11);
  writeln('Superficie en m2.');
  gotoxy(43,12);
  readln(superficie);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de terreno');
  gotoxy(43,11);
  writeln('Zona.');
  gotoxy(43,12);
  readln(zona);
  clrscr;

  gotoxy(50,7);
  writeln('Alta de terreno');
  gotoxy(43,11);
  writeln(utf8toansi('Edificación.'));
  gotoxy(43,12);
  readln(edificacion);
  clrscr;

  end;
end;

procedure valorizar(var x:t_dato);
var
  percentzona,percentedi:real;
begin
   with x do
   begin

   if zona=1 then percentzona:=1.5 else
    if zona=2 then percentzona:=1.1 else
      if zona=3 then percentzona:=0.7 else
        if zona=4 then percentzona:=0.4 else percentzona:=0.1 ;

  if edificacion=1 then percentedi:=1.7 else
    if edificacion=2 then percentedi:=1.3 else
      if edificacion=3 then percentedi:=1.1 else
        if edificacion=4 then percentedi:=0.8 else percentedi:=0.5;

  avaluo:= (12308.60*superficie)*percentzona*percentedi;

  end;
end;

procedure abrir_t_arch(var arch:t_archivo);          //abrir archivo de terreno
begin
    reset(arch);
end;

procedure crear_t_arch(var arch:t_archivo);          //crear archivo de terreno
begin
  assign(arch,ruta2);
  rewrite(arch);
end;

procedure cerrar_t_arch(var arch:t_archivo);         //cerrar archivo de terreno
begin
    close(arch);
end;

procedure agregar_t_arch(var arch:t_archivo; x:t_dato);   //agregar reg a archivo de terreno
var                                                       //de manera ordenada, similar a el procedimiento
                                                          //de agregar elemento a LOCIMD.
  j:t_dato;
  k:byte;
  pos_t:byte;
  archaux:t_archivo;
  enc:boolean;
begin
   if filesize(arch)=0 then                    //si el reg de terrenos esta vacio, lo guarda primero
   begin
     seek(arch,0);
     write(arch,x);
   end
   else                                       //sino busca la posicion en la que deveria ir
   begin
        seek(arch,0);
        enc:=false;
        pos_t:=0;
        while (not(eof(arch))) and (enc=false) do
        begin
             read(arch,j);
             if (j.n_contrib+ j.fecha) > (x.n_contrib + x.fecha) then
             begin
                  enc:=true;
                  pos_t:=filepos(arch)-1;
             end;
        end;
        if not(enc) then                                 //si no encuentra reg mayor lo coloca en la ultima posicion
        begin
             seek(arch,filesize(arch));
             write(arch,x);
        end
        else                                           //sino lo coloca en la posicion que encontro.
        begin                                          //Lo colocamos utilizando un archivo auxiliar

                        assign(archaux,rutaaux);
                        rewrite(archaux);
                        abrir_t_arch(archaux);
                        seek(arch,0);
                        while not(eof(arch)) do
                        begin
                             if filesize(archaux)=pos_t then
                             begin
                                  write(archaux,x);
                             end;
                        read(arch,j);
                        write(archaux,j);

                        end;
        close(arch);
        erase(arch);
        assign(arch, ruta2);
        rewrite(arch);
        seek(archaux,0);
        while not(eof(archaux)) do
        begin
             read(archaux,x);
             write(arch,x);
        end;
        close(archaux);
        erase(archaux);
   end;
   end;
end;

procedure agregar_t_archaux(var arch:t_archivo; x:t_dato);   //agregar reg a archivo de terreno
var                                                       //de manera ordenada, similar a el procedimiento
                                                          //de agregar elemento a LOCIMD.
  j:t_dato;
  k:byte;
  pos_t:byte;
  archaux:t_archivo;
  enc:boolean;
begin
   if filesize(arch)=0 then                    //si el reg de terrenos esta vacio, lo guarda primero
   begin
     seek(arch,0);
     write(arch,x);
   end
   else                                       //sino busca la posicion en la que deveria ir
   begin
        seek(arch,0);
        enc:=false;
        pos_t:=0;
        while (not(eof(arch))) and (enc=false) do
        begin
             read(arch,j);
             if (j.fecha) > (x.fecha) then
             begin
                  enc:=true;
                  pos_t:=filepos(arch)-1;
             end;
        end;
        if not(enc) then                                 //si no encuentra reg mayor lo coloca en la ultima posicion
        begin
             seek(arch,filesize(arch));
             write(arch,x);
        end
        else                                           //sino lo coloca en la posicion que encontro.
        begin                                          //Lo colocamos utilizando un archivo auxiliar

                        assign(archaux,rutaaux);
                        rewrite(archaux);
                        abrir_t_arch(archaux);
                        seek(arch,0);
                        while not(eof(arch)) do
                        begin
                             if filesize(archaux)=pos_t then
                             begin
                                  write(archaux,x);
                             end;
                        read(arch,j);
                        write(archaux,j);

                        end;
        close(arch);
        erase(arch);
        assign(arch, rutaaux2);
        rewrite(arch);
        seek(archaux,0);
        while not(eof(archaux)) do
        begin
             read(archaux,x);
             write(arch,x);
        end;
        close(archaux);
        erase(archaux);
   end;
   end;
end;

procedure mostrar_datos_t(var x:t_dato);                 //muestra un reg

begin
  with x do
  begin
  gotoxy(43,15);
  writeln('Numero de contribuyente: ', n_contrib);
  gotoxy(43,16);
  writeln('Plano: ', plano);
  gotoxy(43,17);
  writeln(utf8toansi(utf8toansi('Fecha de inscripción: ')), fecha);
  gotoxy(43,18);
  writeln(utf8toansi('Avalúo: $'), floatToStr(avaluo));
  gotoxy(43,19);
  writeln('Domicilio parcelario: ', domicilio_p);
  gotoxy(43,20);
  writeln('Superficie en m2: ', floatToStr(superficie));
  gotoxy(43,21);
  writeln('Zona: ', zona);
  gotoxy(43,22);
  writeln(utf8toansi('Edificación: '), edificacion);
  end;
end;

procedure eliminar_datos_t(var arch:t_archivo;var pos:byte);   //elimina un datos de un reg
  var
    j:byte;
    x:t_dato;
    archaux:t_archivo;
begin
  assign(archaux,rutaaux);
  rewrite(archaux);
  abrir_t_arch(archaux);


while not(eof(arch)) do
begin
if (filepos(arch)=pos) then
  begin
        read(arch,x);

  end
  else
  begin
  read(arch,x);
  write(archaux,x);
  end;
end;

close(arch);
erase(arch);
assign(arch, ruta2);
rewrite(arch);
seek(archaux,0);
while not(eof(archaux)) do
begin
read(archaux,x);
write(arch,x);
end;

close(archaux);
erase(archaux);
end;

procedure buscar_t_arch(var arch:t_archivo;buscado:string;var pos:byte);
var
  x:t_dato;
begin
  seek(arch,0);
  while not(eof(arch)) do
  begin
       read(arch,x);
        if (x.domicilio_p = buscado) then
        begin
          pos:= filepos(arch)-1;
        end
  end;
end;

procedure buscar_t_arch_contrib(var arch:t_archivo;buscado:string;var nom:string);
var
  x:t_dato;
  ac:byte;
begin
  ac:=1;
  seek(arch,0);
  while not(eof(arch)) do
  begin
       read(arch,x);
       if (x.n_contrib = buscado) then
       begin
          clrscr;
          gotoxy(50,7);
          writeln('Listado de personas ordenado');
          gotoxy(50,8);
          writeln('por nombre y apellido');
          gotoxy(43,12);
          writeln('Terrenos de ', nom);
          gotoxy(43,13);
          writeln('Terreno ',ac);
          mostrar_datos_t(x);
          gotoxy(43,24);
          writeln('Presione una tecla para continuar.');
          gotoxy(43,25);
          readkey;
          clrscr;
        end;

  end;
end;

procedure mostrar_t_archivo(var arch:t_archivo);
var
   x:t_dato;
begin
  reset(arch);
  seek(arch,0);
  while not(eof(arch)) do
  begin
    read(arch,x);
    mostrar_datos_t(x);
    readkey;
  end;
  readkey;
end;


end.
