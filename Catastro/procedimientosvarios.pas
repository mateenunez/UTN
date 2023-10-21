unit procedimientosvarios;

interface                                                   //UNIT PARA LISTADOS,COMPROBANTE Y ESTADISTICAS

uses
   SysUtils, crt, archivoterrenos, archivopersonas, arbolpersonas, ABMC_personas, modpersonas, modterrenos;





procedure listado_na(var raiz:pa_punt; var archt:t_archivo;var archp:p_archivo);
procedure listado_fecha(var arch:t_archivo);
procedure listado_zona(var arch:t_archivo);
procedure comprobante(var archt:t_archivo; var archp: p_archivo);
procedure dos_fechas(var arch:t_archivo);
procedure porcentaje_prop(var archt:t_archivo; var archp:p_archivo);
procedure porcentaje_edif(var archt:t_archivo);
procedure cantidad_baja();
procedure cantidad_baja2(var arch:p_archivo);

implementation

procedure listado_na(var raiz:pa_punt; var archt:t_archivo;var archp:p_archivo);
var
  acgotoxy:byte;
begin
  if arbol_vacio(raiz)=false then
  begin
     Clrscr;
     gotoxy(43,1);
     writeln('Listado de propietarios ordenado');
     gotoxy(43,2);
     writeln('por apellido y nombre, con sus respectivos terrenos');
     gotoxy(1,4);
     writeln('Apellido y nombre |');
     gotoxy(20,4);
     campos_t();
     acgotoxy:=6;
     recorrer_inorden(raiz,archt,archp,acgotoxy);
     readkey;
  end
  else
    begin
        clrscr;
        gotoxy(43,7);
        writeln('Listado de propietarios ordenado');
        gotoxy(43,8);
        writeln('por apellido y nombre, con sus respectivos terrenos');
        gotoxy(43,11);
        writeln('No existen propietarios para listar');
        gotoxy(43,13);
        writeln('Presione una tecla para continuar.');
        gotoxy(43,14);
        readkey;
    end;
  clrscr;
end;

procedure listado_fecha(var arch:t_archivo);
var
  buscad:string;
  x:t_dato;
  anio:string;
  aux:boolean;
  ac,ac2,acgotoxy,l,j:byte;
  archaux:t_archivo;
  fallo:boolean;
  i:integer;

begin
  clrscr;
  assign(archaux,rutaaux);
  rewrite(archaux);
  reset(archaux);
  abrir_t_arch(arch);
  gotoxy(43,7);
  writeln(utf8toansi('Listado de inscripciones de un año, ordenado por fecha'));
  ac2:=1;
  repeat
       if ac=2 then
         begin
           gotoxy(79,11);
           writeln('              ');
           textbackground(red);
           gotoxy(43,12);
           Writeln ('La fecha ingresada es invalida, intente nuevamente.');
           textbackground(black);
         end;
         fallo:=false;
         gotoxy(43,11);
         writeln(Utf8toAnsi('Ingrese el año que desea consultar:                          (AAAA)'));
         gotoxy(79,11);
         readln(buscad);
         if not(TryStrToInt(buscad,i)) then
         begin
         gotoxy(79,11);
         writeln('              ');
         textbackground(red);
         gotoxy(43,2);
         Writeln('La fecha ingresada es invalida, intente nuevamente.');
         textbackground(black);
         fallo:=true;
         end;
         ac:=2;
  until (fallo=false);
  aux:=false;
  seek(arch,0);
  ac:=1;
  while not(eof(arch)) do
  begin
     read(arch,x);
     anio:= copy(x.fecha,0,4);
     if (anio = buscad) then
     begin
          aux:=true;
          clrscr;
          seek(archaux,filesize(archaux));
          write(archaux,x);
          if filesize(archaux)>=2 then ordenar_t_archaux(archaux);
     end
  end;
  if aux=false then
  begin
      clrscr;
      gotoxy(43,7);
      writeln(utf8toansi('Listado de inscripciones de un año, ordenado por fecha'));
      gotoxy(43,11);
      writeln(utf8toansi('No existen terrenos inscriptos en el año '), buscad);
      gotoxy(43,14);
      writeln('Presione una tecla para continuar');
      gotoxy(43,15);
      readkey;
      clrscr;
  end;
  clrscr;
  if filesize(archaux)>0 then
  begin
  seek(archaux,0);
  acgotoxy:=0;
  l:=5;
  gotoxy(37,1);
  writeln(utf8toansi('Listado de inscripciones de un año, ordenado por fecha'));
  while not(eof(archaux)) do
  begin
          read(archaux,x);
          gotoxy(8,4);
          campos_t();
          j:=0;
          mostrar_datos_t(x,j,l);
          l:=l+1;
  end;
  gotoxy(43,24);
  writeln('Presione una tecla para continuar');
  gotoxy(43,25);
  readkey;
  end;
  close(archaux);
  erase(archaux);
  clrscr;
  cerrar_t_arch(arch);
end;

procedure listado_zona(var arch:t_archivo);
var
  i,l,j:byte;
  x:t_dato;
  aux:boolean;

begin
  clrscr;
  abrir_t_arch(arch);
  j:=0;
  l:=4;
  gotoxy(40,1);
  writeln('Listado de terrenos ordenado por zona');
  gotoxy(8,3);
  campos_t();
  for i:=1 to 5 do
  begin
   l:=l+1;
   gotoxy(40,l);
   writeln('Terrenos de zona ', i);
   l:=l+1;
   aux:=false;
   seek(arch,0);
   while not(eof(arch)) do
   begin
      read(arch,x);
      if (x.zona = i) then
      begin
        aux:=true;
        mostrar_datos_t(x,j,l);
        l:=l+1;
      end;
   end;
   if (aux=false) then
   begin
     gotoxy(37,l);
     writeln('No existen terrenos de la zona ',i);
     l:=l+1;
   end;
  end;
  gotoxy(37,l+1);
  writeln('Presione una tecla para continuar.');
  gotoxy(37,l+2);
  readkey;
  clrscr;
  cerrar_t_arch(arch);
end;

procedure comprobante(var archt:t_archivo; var archp: p_archivo);
var
  buscado:string;
  buscado2:string;
  pos,l,j:byte;
  pos2:byte;
  x:t_dato;
  i:p_dato;
  enc,enc2:boolean;
begin
     clrscr;
     abrir_t_arch(archt);
     abrir_p_arch(archp);
     enc:=false;
     enc2:=false;
     gotoxy(50,7);
     writeln('Comprobante');
     gotoxy(43,11);
     writeln('Ingrese el domicilio del terreno');
     gotoxy(43,12);
     writeln('el cual desea imprimir su comprobante');
     gotoxy(43,13);
     readln(buscado);
     buscar_t_arch(archt,buscado,pos,enc);
     if enc then
     begin
          seek(archt,pos);
          read(archt,x);
          buscado2:= x.n_contrib;
          buscar_p_arch(archp,buscado2,pos2,enc2);
          if enc2 then
          begin
          seek(archp,pos2);
          read(archp,i);
          clrscr;
          gotoxy(50,7);
          writeln('Comprobante');
          gotoxy(43,17);
          writeln('Datos del terreno');
          gotoxy(8,19);
          campos_t();
          l:=15;
          mostrar_datos_t(x,j,l);
          gotoxy(43,12);
          writeln('Datos del propietario/a');
          gotoxy(8,14);
          campos_p();
          l:=20;
          mostrar_datos_p(i,l);
          gotoxy(43,25);
          writeln('Presione una tecla para continuar');
          gotoxy(43,26);
          readkey;
          clrscr;
          end
          else
          begin
           clrscr;
           gotoxy(50,7);
           writeln('Comprobante');
           gotoxy(43,11);
           writeln('No se encontro al propietario/a del terreno buscado');
           gotoxy(43,13);
           writeln('Presione una tecla para continuar');
           gotoxy(43,14);
           readkey;
           clrscr;
          end;
     end
     else
     begin
          clrscr;
           gotoxy(50,7);
           writeln('Comprobante');
           gotoxy(43,11);
           writeln('No se encontro el terreno buscado');
           gotoxy(43,13);
           writeln('Presione una tecla para continuar');
           gotoxy(43,14);
           readkey;
           clrscr;
     end;
end;

procedure dos_fechas(var arch:t_archivo);
var f1,f2:string;
  x:t_dato;
  cont:byte;
  ac,ac2:byte;
  fallo:boolean;
  i:integer;
begin
  clrscr;
  gotoxy(50,7);
  writeln('Cantidad de inscriptos entre dos fechas');
  ac:=1;
  repeat
       if ac=2 then
         begin
           textbackground(red);
           gotoxy(43,12);
           Writeln ('La fecha ingresada es invalida, intente nuevamente.');
           textbackground(black);
         end;
         fallo:=false;
         gotoxy(43,11);
         writeln('Ingrese fecha de inicio:                              (AAAA/MM/DD)');
         gotoxy(68,11);
         readln(f1);
         delete(f1,5,1);
         delete(f1,7,1);
         if not(TryStrToInt(f1,i)) then
         begin
         gotoxy(68,11);
         writeln('              ');
         textbackground(red);
         gotoxy(43,12);
         Writeln('La fecha ingresada es invalida, intente nuevamente.');
         textbackground(black);
         fallo:=true;
         end else
         begin
         insert('/', f1,5);
         insert('/', f1,8);
         end;
         ac:=2;
  until (copy(f1,5,1)='/') and (copy(f1,8,1)='/') and (strtoint(copy(f1,6,2))<=12) and (strtoint(copy(f1,6,2))>0) and (fallo=false) and (strtoint(copy(f1,9,2))<=31) and (strtoint(copy(f1,9,2))>0);
  ac2:=1;
  GOTOXY(43,12);
  writeln('                                                 ');
  repeat
       if ac2=2 then
         begin
           textbackground(red);
           gotoxy(43,13);
           Writeln ('La fecha ingresada es invalida, intente nuevamente.');
           textbackground(black);
         end;
         fallo:=false;
         gotoxy(43,12);
         writeln('Ingrese fecha final:                              (AAAA/MM/DD)');
         gotoxy(64,12);
         readln(f2);
         delete(f2,5,1);
         delete(f2,7,1);
         if not(TryStrToInt(f2,i)) then
         begin
         gotoxy(64,12);
         writeln('              ');
         textbackground(red);
         gotoxy(43,13);
         Writeln('La fecha ingresada es invalida, intente nuevamente.');
         textbackground(black);
         fallo:=true;
         end else
         begin
         insert('/', f2,5);
         insert('/', f2,8);
         end;
         ac2:=2;
  until (copy(f2,5,1)='/') and (copy(f2,8,1)='/') and (strtoint(copy(f2,6,2))<=12) and (strtoint(copy(f2,6,2))>0) and (fallo=false) and (strtoint(copy(f2,9,2))<=31) and (strtoint(copy(f2,9,2))>0);
  gotoxy(43,13);
  writeln('                                                           ');
  abrir_t_arch(arch);
  seek(arch,0);
  cont:=0;
  while not(eof(arch)) do
  begin
   read(arch,x);
   if (x.fecha>=f1) and (x.fecha<=f2) then cont:= cont+1;
  end;
  gotoxy(43,14);
  writeln('La cantidad de inscripciones entre');
  gotoxy(43,15);
  writeln('esas fechas fueron: ',cont,'.');
  gotoxy(43,17);
  writeln('Presione una tecla para continuar');
  gotoxy(43,18);
  readkey;
  clrscr;
end;

procedure porcentaje_prop(var archt:t_archivo; var archp:p_archivo);
var totalpersonas:byte;
    x:t_dato;
    j:p_dato;
    cont,cont2:byte;
    percent:real;
    aux:string;
begin
   cont2:=0;
   abrir_p_arch(archp);
   abrir_t_arch(archt);
   totalpersonas:=filesize(archp);
   seek(archp,0);
   while not(eof(archp)) do
   begin
        clrscr;
        cont:=0;
        read(archp,j);
        aux:=j.n_contrib;
        seek(archt,0);
   while not(eof(archt)) do
   begin
        read(archt,x);
        if (x.n_contrib = aux) then
        begin
             cont:=cont+1;
        end;
   end;
   if (cont>=2) then
   begin
      cont2:= cont2 +1;
   end;
   end;
   if (totalpersonas>0) then
   begin
    percent:= (cont2*100)/totalpersonas;
    gotoxy(50,7);
    writeln(utf8toansi('Porcentaje de personas con más de un terreno'));
    gotoxy(43,11);
    writeln(utf8toansi('El porcentaje de personas con más de un terreno es de: '), floatToStr(percent), '%');
    gotoxy(43,13);
    writeln('Presione una tecla para continuar');
    gotoxy(43,14);
   end else
   begin
    gotoxy(50,7);
    writeln(utf8toansi('Porcentaje de personas con más de un terreno'));
    gotoxy(43,11);
    writeln('No hay terrenos registrados');
   end;
   cerrar_t_arch(archt);
   cerrar_p_arch(archp);
   readkey;
   clrscr;
end;

procedure porcentaje_edif(var archt:t_archivo);
var ac1,ac2,ac3,ac4,ac5:byte;
    x:t_dato;
    totalterrenos:byte;
begin
   abrir_t_arch(archt);
   if filesize(archt)<>0 then
   begin
   totalterrenos:= filesize(archt);
   ac1:=0;
   ac2:=0;
   ac3:=0;
   ac4:=0;
   ac5:=0;
   seek(archt,0);
   while not(eof(archt)) do
   begin
        read(archt,x);
        if (x.edificacion = 1) then ac1:= ac1+1 else
           if (x.edificacion = 2) then ac2:=ac2+1 else
              if (x.edificacion = 3) then ac3:=ac3+1 else
                 if (x.edificacion = 4) then ac4:=ac4+1 else
                    if (x.edificacion = 5) then ac5:=ac5+1;
   end;
   clrscr;
   gotoxy(50,7);
   writeln(utf8toansi('Porcentaje por tipo de edificación'));
   gotoxy(43,11);
   writeln(utf8toansi('Porcentaje de terrenos con tipo de edificación 1: '), round(ac1*100/totalterrenos), '%');
   gotoxy(43,12);
   writeln(utf8toansi('Porcentaje de terrenos con tipo de edificación 2: '), round(ac2*100/totalterrenos), '%');
   gotoxy(43,13);
   writeln(utf8toansi('Porcentaje de terrenos con tipo de edificación 3: '), round(ac3*100/totalterrenos), '%');
   gotoxy(43,14);
   writeln(utf8toansi('Porcentaje de terrenos con tipo de edificación 4: '), round(ac4*100/totalterrenos), '%');
   gotoxy(43,15);
   writeln(utf8toansi('Porcentaje de terrenos con tipo de edificación 5: '), round(ac5*100/totalterrenos), '%');
   gotoxy(43,17);
   writeln('Presione una tecla para continuar');
   gotoxy(43,18);
   readkey;
   clrscr;
   end else
   begin
       clrscr;
       gotoxy(50,7);
       writeln(utf8toansi('Porcentaje por tipo de edificación'));
       gotoxy(43,11);
       writeln('No hay terrenos cargados.');
       gotoxy(43,13);
       writeln('Presione una tecla para continuar');
       gotoxy(43,14);
       readkey;
       clrscr;
   end;
end;

procedure cantidad_baja();
begin
     clrscr;
     gotoxy(50,7);
     writeln('Cantidad de personas dadas de baja');
     gotoxy(43,11);
     writeln('La cantidad de personas dadas de baja son: ', bajapersonas);
     gotoxy(43,13);
     writeln('Presione una tecla para continuar');
     gotoxy(43,14);
     readkey;
     clrscr;
end;

procedure cantidad_baja2(var arch:p_archivo);
var
    x:p_dato;
begin
  abrir_p_arch(arch);
  seek(arch,0);
  while not(eof(arch)) do
  begin
       read(arch,x);
       if x.estado = false then
       bajapersonas:=bajapersonas+1;
  end;
  cerrar_p_arch(arch);
end;

end.

