unit ABMC_terrenos;


interface                                                                // UNIT PARA ABMC DE TERRENOS

uses
   SysUtils, crt, archivoterrenos, modterrenos, archivopersonas, modpersonas, abmc_personas, arbolpersonas;

procedure alta_terreno(var archt:t_archivo;var archp:p_archivo;var raizdni:pa_punt; var raizna:pa_punt);
procedure baja_terreno(var archt:t_archivo;var archp:p_archivo);
procedure consulta_terreno(var arch:t_archivo);
procedure modificar_terreno(var arch:t_archivo);

implementation

procedure alta_terreno(var archt:t_archivo;var archp:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
var
  x:t_dato;
  y:p_dato;
  dni2:string;
  dni:string;
  fallo,enc:boolean;
  res1,res2,res3:string[2];
  pos:byte;
  i:integer;
begin
  clrscr;
  abrir_t_arch(archt);
  abrir_p_arch(archp);
  repeat
    repeat
       clrscr;
       textbackground(3);
       gotoxy(47,7);
       writeln('   Alta de terreno   ');
       textbackground(8);
       if fallo=true then
       begin
          gotoxy(56,11);
          writeln('                                        ');
          textbackground(4);
          gotoxy(43,12);
          Writeln('El DNI ingresado es invalido, intente nuevamente.');
          textbackground(8);
       end;
       gotoxy(43,11);
       writeln('Ingrese DNI:');
       gotoxy(56,11);
       readln(dni2);
       fallo:=false;
       if not(TryStrToInt(dni2,i))  then
       begin
             fallo:=true;
       end else dni := dni2;
    until  fallo=false;
    gotoxy(43,12);
    writeln(utf8toansi('¿Es correcto el DNI ingresado?  (SI/NO)                             '));
    gotoxy(43,13);
    readln(res2);
  until (res2='SI') or (res2='Si') or (res2='si') or (res2='sI');
  gotoxy(43,12);
  writeln('                                                       ');
  enc:=false;
  buscar_p_arch_dni(archp,dni,pos,enc);
  if enc then
  begin
     seek(archp,pos);
     read(archp,y);
     x.n_contrib:=y.n_contrib;
     cargar_datos_t(x);
     valorizar(x);
     seek(archt,filesize(archt));
     if filesize(archt)>=2 then
     begin
        ordenar_t_arch(archt);
     end;
     gotoxy(43,19);
     writeln(Utf8toAnsi('Avalúo: $'),floatToStr(x.avaluo));
     gotoxy(43,21);
     writeln(Utf8toAnsi('¿Desea dar de alta el terreno?   (SI/NO)'));
     gotoxy(43,22);
     readln(res3);
     if (res3='SI') or (RES3='Si') or (res3='si') then
     begin
        write(archt,x);
        gotoxy(43,21);
        writeln('Terreno dado de alta exitosamente.                    ');
        gotoxy(43,22);
        writeln('Presione una tecla para continuar.                    ');
        gotoxy(43,23);
        readkey;
        clrscr;
     end
     else
     begin
        gotoxy(43,21);
        writeln('El terreno no se ha dado de alta.                        ');
        gotoxy(43,22);
        writeln('Presione una tecla para continuar.                    ');
        gotoxy(43,23);
        readkey;
        clrscr;
     end;
  end
  else
  begin
     gotoxy(43,12);
     writeln('La persona propietaria del terreno no se encuentra registrada.');
     gotoxy(43,13);
     writeln(Utf8toAnsi('¿Desea registrarla?   (SI/NO)'));
     gotoxy(43,14);
     readln(res1);
     if (res1='SI') or (res1='Si') or (res1='si') then
     Begin
     alta_persona(archp,raizdni,raizna);
     alta_terreno(archt,archp,raizdni,raizna);
     end
  end;
end;

procedure baja_terreno(var archt:t_archivo;var archp:p_archivo);
var
    r:string[2];
    pos,pos2,l,j:byte;
    x,y:t_dato;
    persona:p_dato;
    buscado,buscado2:string;
    enc,enc2:boolean;

begin
  j:=0;
  clrscr;
  enc:=false;
  abrir_t_arch(archt);
  textbackground(3);
  gotoxy(47,7);
  writeln('   Baja de terreno   ');
  textbackground(8);
  gotoxy(43,11);
  writeln('Ingrese el domicilio parcelario del');
  gotoxy(43,12);
  writeln('terreno que desea dar de baja: ');
  gotoxy(74,12);
  readln(buscado);
  while not(eof(archt)) do
  begin
    read(archt,x);
    if (x.domicilio_p = buscado) then
    begin
      enc:=true;
      gotoxy(8,15);
      writeln('                                                                             ');
      gotoxy(43,19);
      writeln('                                                                             ');
      gotoxy(43,20);
      writeln('                                                                             ');
      gotoxy(43,21);
      writeln('                                                                             ');
      gotoxy(8,14);
      campos_t();
      l:=15;
      mostrar_datos_t(x,j,l);
      gotoxy(43,18);
      writeln(utf8toansi('¿Desea eliminar este terreno? (SI/NO)'));
      gotoxy(43,19);
      readln(r);
      if (r='SI') or (r='Si') or (r='si') then
      begin
        pos:=filepos(archt)-1;
        eliminar_datos_t(archt,pos);
        seek(archt,0);
        enc2:=false;
        while not(eof(archt)) do
        begin
           read(archt,y);
           if x.n_contrib=y.n_contrib then
           begin
             enc2:=true;
           end;
        end;
        if not(enc2) then
        begin
             buscado2:=x.n_contrib;
             abrir_p_arch(archp);
             enc2:=false;
             buscar_p_arch(archp,buscado2,pos2,enc2);
             if enc2 then
             begin
               seek(archp,pos2);
               read(archp,persona);
               persona.estado:=false;
               seek(archp,pos2);
               write(archp,persona);
               gotoxy(43,20);
               writeln('La persona propietaria del terreno ha sido dada de baja,');
               gotoxy(43,21);
               writeln(Utf8toAnsi('por ser el terreno eliminado el único en su posesión.'));
             end;
        end;
        gotoxy(43,22);
        writeln('El terreno se dio de baja exitosamente.');
        gotoxy(43,23);
        writeln('Presione una tecla para continuar.');
        gotoxy(43,24);
        readkey;
      end else
      begin
        gotoxy(43,20);
        writeln('El terreno no se ha dado de baja.');
        gotoxy(43,21);
        writeln('Presione una tecla para continuar.');
        gotoxy(43,22);
        readkey;
      end;
    end
  end;
  if not(enc) then
  begin
    gotoxy(43,15);
    writeln('Terreno no encontrado.');
    gotoxy(43,17);
    writeln('Presione una tecla para continuar.');
    gotoxy(43,18);
    readkey;
  end;
  cerrar_t_arch(archt);
  clrscr;
end;

procedure modificar_terreno(var arch:t_archivo);
var
    buscado,opcion:string;
    pos,l,j,ac:byte;
    x:t_dato;
    r,r3:string[2];
    r2:1..10;
    enc,fallo:boolean;
    i:integer;
begin
      j:=0;
      clrscr;
      abrir_t_arch(arch);
      textbackground(3);
      gotoxy(47,7);
      writeln(utf8toansi('   Modificación de terreno   '));
      textbackground(8);
      gotoxy(43,11);
      writeln('Ingrese el domicilio parcelario');
      gotoxy(43,12);
      writeln('del terreno que desea modificar: ');
      gotoxy(43,13);
      readln(buscado);
      enc:=false;
      buscar_t_arch(arch,buscado,pos,enc);
      if enc then
      begin
            seek(arch,pos);
            read(arch,x);
            gotoxy(8,15);
            campos_t();
            l:=16;
            mostrar_datos_t(x,j,l);
            gotoxy(43,18);
            writeln(utf8toansi('¿Desea modificar este registro de terreno? (SI/NO)'));
            gotoxy(43,19);
            readln(r);
            if (r='SI') or (r='Si') or (r='si') then
            begin
            repeat
              clrscr;
              textbackground(3);
              gotoxy(47,7);
              writeln(utf8toansi('   Modificación de terreno   '));
              textbackground(8);
              gotoxy(43,11);
              writeln('Ingrese el campo que desee modificar: ');
              gotoxy(43,13);
              writeln('1-Plano');
              gotoxy(43,14);
              writeln(utf8toansi('2-Fecha de inscripción'));
              gotoxy(43,15);
              writeln('3-Domicilio parcelario');
              gotoxy(43,16);
              writeln('4-Superficie');
              gotoxy(43,17);
              writeln('5-Zona');
              gotoxy(43,18);
              writeln(utf8toansi('6-Edificación'));

              ac:=1;
              repeat
              if ac=2 then
              begin
                gotoxy(43,19);
                writeln('                                        ');
                gotoxy(43,20);
                Writeln('La opcion ingresada es invalida, intente nuevamente.');
              end;
              fallo:=false;

              gotoXY(43,19);
              readln(opcion);
              if not(trystrtoint(opcion,i)) then
              begin
                gotoxy(43,19);
                writeln('                                        ');
                gotoxy(43,20);
                Writeln('La opcion ingresada es invalida, intente nuevamente.');
                fallo:=true;
              end else r2:=strtoint(opcion);

              ac:=2;
              until ((r2=0) or (r2=1) or (r2=2) or (r2=3) or (r2=4) or (r2=5) or (r2=6) or (r2=7)) and (fallo=false);
              clrscr;
              case r2 of
                 1:begin
                        clrscr;
                        textbackground(3);
                        gotoxy(47,7);
                        writeln(utf8toansi('   Modificación de terreno   '));
                        textbackground(8);
                        gotoxy(43,11);
                        writeln('Ingrese nuevo numero de plano:');
                        gotoxy(43,12);
                        readln(x.plano);
                 end;
                 2:begin
                        clrscr;
                        textbackground(3);
                        gotoxy(47,7);
                        writeln(utf8toansi('   Modificación de terreno   '));
                        textbackground(8);
                        gotoxy(43,11);
                        writeln(utf8toansi('Ingrese nueva fecha de inscripción:'));
                        gotoxy(43,12);
                        readln(x.fecha);
                 end;
                 3:begin
                        clrscr;
                        textbackground(3);
                        gotoxy(47,7);
                        writeln(utf8toansi('   Modificación de terreno   '));
                        textbackground(8);
                        gotoxy(43,11);
                        writeln('Ingrese nuevo domicilio parcelario :');
                        gotoxy(43,12);
                        readln(x.domicilio_p);
                 end;
                 4:begin
                        clrscr;
                        textbackground(3);
                        gotoxy(47,7);
                        writeln(utf8toansi('   Modificación de terreno   '));
                        textbackground(8);
                        gotoxy(43,11);
                        writeln('Ingrese nuevo superficie:');
                        gotoxy(43,12);
                        readln(x.superficie);
                 end;
                 5:begin
                        clrscr;
                        textbackground(3);
                        gotoxy(47,7);
                        writeln(utf8toansi('   Modificación de terreno   '));
                        textbackground(8);
                        gotoxy(43,11);
                        writeln('Ingrese nueva zona:');
                        gotoxy(43,12);
                        readln(x.zona);
                 end;
                 6:begin
                        clrscr;
                        textbackground(3);
                        gotoxy(47,7);
                        writeln(utf8toansi('   Modificación de terreno   '));
                        textbackground(8);
                        gotoxy(43,11);
                        writeln(utf8toansi('Ingrese nuevo numero de edificación:'));
                        gotoxy(43,12);
                        readln(x.edificacion);
                 end;
              end;
              valorizar(x);
              seek(arch,pos);
              write(arch,x);
              gotoxy(43,14);
              writeln(utf8toansi('¿Desea modificar otro campo de este registro de terreno? (SI/NO)'));
              gotoxy(43,15);
              readln(r3);
              until (r3='NO') or (r3='No') or (r3='no');
              clrscr;
              textbackground(3);
              gotoxy(47,7);
              writeln(utf8toansi('   Modificación de terreno   '));
              textbackground(8);
              gotoxy(43,11);
              writeln('Los campos del terreno se han modificado exitosamente.');
              gotoxy(43,12);
              writeln('presione una tecla para continuar.');
              gotoxy(43,13);
              readkey;
              end
              else    //si la respuesta a modificar algun campo fue negativa
              begin
              clrscr;
              textbackground(3);
              gotoxy(47,7);
              writeln(utf8toansi('   Modificación de terreno   '));
              textbackground(8);
              gotoxy(43,11);
              writeln('No se ha modificado ningun campo del terreno.');
              gotoxy(43,12);
              writeln('Presione una tecla para continuar.');
              gotoxy(43,13);
              readkey;
              end;
      end
      else          //si no se encontro el terreno
      begin
        gotoxy(43,15);
        writeln('No se ha encontrado el terreno.');
        gotoxy(43,16);
        writeln('Presione una tecla para continuar.');
        gotoxy(43,17);
        readkey;
      end;
      cerrar_t_arch(arch);
      clrscr;
end;

procedure consulta_terreno(var arch:t_archivo);
var
    buscado:string;
    pos,l,j:byte;
    x:t_dato;
    enc:boolean;
begin
  clrscr;
  abrir_t_arch(arch);
  gotoxy(47,7);
  textbackground(3);
  writeln('   Consulta de terreno   ');
  textbackground(8);
  gotoxy(43,11);
  writeln('Ingrese el domicilio parcelario del');
  gotoxy(43,12);
  writeln('terreno que desea consultar: ');
  gotoxy(43,13);
  readln(buscado);
  enc:=false;
  buscar_t_arch(arch,buscado,pos,enc);
  if enc then
  begin
        seek(arch,pos);
        read(arch,x);
        gotoxy(8,15);
        campos_t();
        l:=16;
        mostrar_datos_t(x,j,l);
        gotoxy(43,18);
        writeln('Presione una tecla para continuar.');
        gotoxy(43,19);
        readkey;
  end else
  begin
    gotoxy(43,15);
    writeln('No se ha encontrado el terreno.');
    gotoxy(43,17);
    writeln('Presione una tecla para continuar.');
    gotoxy(43,18);
    readkey;
  end;
  cerrar_t_arch(arch);
  clrscr;
end;

end.

