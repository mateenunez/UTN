unit modterrenos;

interface                                               //UNIT CON PROCEDIMIENTOS QUE MODIFICAN A LOS TERRENOS

uses
   crt, SysUtils, archivoterrenos;

const
   rutaaux = 'C:\archivos\archivoterrenosaux.dat';
   rutaaux2 = 'C:\archivos\archivoterrenosaux2.dat';

procedure ordenar_t_arch(var arch:t_archivo);
procedure ordenar_t_archaux(var arch:t_archivo);
procedure cargar_datos_t(var x:t_dato);
procedure campos_t();
procedure mostrar_datos_t(var x:t_dato;var j:byte;var y:byte);
procedure eliminar_datos_t(var arch:t_archivo;var pos:byte);
procedure buscar_t_arch(var arch:t_archivo;buscado:string;var pos:byte;var enc:boolean);
procedure buscar_t_arch_contrib(var arch:t_archivo;buscado:string;var nom:string;var acgotoxy:byte);
procedure valorizar(var x:t_dato);

implementation

procedure ordenar_t_arch(var arch:t_archivo);                      //Ordenamiento Burbuja  del archivo
var
  i,j:byte;
  x,y,aux:t_dato;
begin
   for i:=0 to filesize(arch)-2 do
   begin
      for j:=0 to filesize(arch)-2 do
      begin
         seek(arch,j);
         read(arch,x);
         read(arch,y);

         if (x.n_contrib+x.fecha)>(y.n_contrib+y.fecha) then
         begin
            seek(arch,j);
            write(arch,y);
            write(arch,x);
         end;
      end;
   end;

end;

procedure ordenar_t_archaux(var arch:t_archivo);                      //Ordenamiento Burbuja  del archivo
var
  i,j:byte;
  x,y,aux:t_dato;
begin
   for i:=0 to filesize(arch)-2 do
   begin
      for j:=0 to filesize(arch)-2 do
      begin
         seek(arch,j);
         read(arch,x);
         read(arch,y);
         if (x.fecha)>(y.fecha) then
         begin
            seek(arch,j);
            write(arch,y);
            write(arch,x);
         end;
      end;
   end;

end;

procedure cargar_datos_t( var x:t_dato);                           //procedimiento para cargar datos de terrenos en reg
var
  zona2,edificacion2:string;
  fallo:boolean;
  i:integer;
  ac:1..2;
begin
  clrscr;
  gotoxy(50,7);
  writeln('Alta de terreno');
  with x do
  begin
     gotoxy(43,12);
     writeln('Plano:');
     gotoxy(50,12);
     readln(plano);
     gotoxy(43,13);
     writeln(utf8toansi('Domicilio parcelario:'));
     gotoxy(65,13);
     readln(domicilio_p);
     ac:=1;
     repeat
       if ac=2 then
         begin
           textbackground(red);
           gotoxy(43,15);
           Writeln ('La fecha ingresada es invalida, intente nuevamente.');
           textbackground(black);
         end;
         fallo:=false;
         gotoxy(43,14);
         writeln('Fecha de Inscripcion:                                   (AAAA/MM/DD)');
         gotoxy(64,14);
         readln(fecha);
         delete(fecha,5,1);
         delete(fecha,7,1);
         if not(TryStrToInt(fecha,i)) then
         begin
         textbackground(red);
         gotoxy(43,15);
         Writeln('La fecha ingresada es invalida, intente nuevamente.');
         textbackground(black);
         fallo:=true;
         end else
         begin
         insert('/', fecha,5);
         insert('/', fecha,8);
         end;
         ac:=2;
     until (copy(fecha,5,1)='/') and (copy(fecha,8,1)='/') and (strtoint(copy(fecha,6,2))<=12) and (strtoint(copy(fecha,6,2))>0) and (fallo=false) and (strtoint(copy(fecha,9,2))<=31) and (strtoint(copy(fecha,9,2))>0);
     gotoxy(43,15);
     writeln('Superficie:                                                        ');
     gotoxy(55,15);
     readln(superficie);
     ac := 1;
     repeat
       if ac = 2 then
       begin
            gotoXY(49,16);
            writeln('                                        ');
            textbackground(red);
            gotoxy(43,17);
            Writeln('La zona ingresada es invalida, intente nuevamente.');
            textbackground(black);
       end;
       fallo:=false;
          gotoxy(43,16);
          writeln('Zona:');
          gotoXY(49,16);
          readln(zona2);
          if not(trystrToInt(zona2,i)) then
          begin
             gotoXY(49,16);
             writeln('                                        ');
             textbackground(red);
             gotoxy(43,17);
             Writeln('La zona ingresada es invalida, intente nuevamente.');
             textbackground(black);
             fallo:=true;
          end else zona:=strToInt(zona2);
       ac:=2;
    until ((zona=0) or (zona=1) or (zona=2) or (zona=3) or (zona=4) or (zona=5)) and (fallo=false);
    gotoxy(43,17);
    Writeln('                                                       ');
    ac:=1;
    repeat
       if ac = 2 then
       begin
            gotoxy(57,17);
            writeln('                                        ');
            textbackground(red);
            gotoxy(43,18);
            Writeln(Utf8toAnsi('La edificación ingresada es invalida, intente nuevamente.'));
            textbackground(black);
       end;
       fallo:=false;
       gotoxy(43,17);
       writeln(Utf8toAnsi('Edificación:'));
       gotoxy(57,17);
       readln(edificacion2);
       if not(trystrtoint(edificacion2,i)) then
          begin
             gotoxy(57,17);
             writeln('                                        ');
             textbackground(red);
             gotoxy(43,18);
             Writeln(Utf8toAnsi('La edificación ingresada es invalida, intente nuevamente.'));
             textbackground(black);
             fallo:=true;
          end else edificacion:=strtoint(edificacion2);
       ac:=2;
    until ((edificacion=0) or (edificacion=1) or (edificacion=2) or (edificacion=3) or (edificacion=4) or (edificacion=5)) and (fallo=false);
    gotoxy(43,18);
    Writeln('                                                             ');
    gotoxy(43,18);
    writeln(Utf8toAnsi('Número de contribuyente: '),x.n_contrib);
  end;
end;

procedure campos_t();
begin
  writeln(Utf8ToAnsi('N° contrib | Plano | Fecha de inscripción |   Avalúo   |  Domicilio | Superficie | Zona | Edificación '));
end;

procedure mostrar_datos_t(var x:t_dato;var j:byte;var y:byte);                           //muestra un reg

begin
  with x do
  begin
  gotoxy(j+15,y);
  writeln('', n_contrib);
  gotoxy(j+24,y);
  writeln('', plano);
  gotoxy(j+34,y);
  writeln('', fecha);
  gotoxy(j+52,y);
  writeln('$', floatToStr(avaluo));
  gotoxy(j+66,y);
  writeln('', domicilio_p);
  gotoxy(j+81,y);
  writeln('', floatToStr(superficie));
  gotoxy(j+92,y);
  writeln('', zona);
  gotoxy(j+102,y);
  writeln('', edificacion);
  end;
end;

procedure eliminar_datos_t(var arch:t_archivo;var pos:byte);       //elimina un datos de un reg
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

procedure buscar_t_arch(var arch:t_archivo;buscado:string;var pos:byte;var enc:boolean);
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
          enc:=true;
        end
  end;
end;

procedure buscar_t_arch_contrib(var arch:t_archivo;buscado:string;var nom:string;var acgotoxy:byte);
var
  x:t_dato;
  ac,l,j:byte;

begin
  j:=12;
  ac:=0;
  seek(arch,0);
  while not(eof(arch)) do
  begin
       read(arch,x);
       if (x.n_contrib = buscado) then
       begin
          if ac=0 then
          begin
            gotoxy(1,acgotoxy);
            writeln(' ',nom);
          end;
          mostrar_datos_t(x,j,acgotoxy);
          acgotoxy:=acgotoxy+1;
          ac:=ac+1;
       end;
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



end.

