unit ABMC_personas;

interface                                                             // UNIT PARA ABMC DE PROPIETARIOS

uses
   SysUtils, crt, archivopersonas, arbolpersonas, modpersonas, modterrenos, archivoterrenos;
var bajapersonas:byte;

procedure alta_persona(var arch:p_archivo; var raizdni:pa_punt;var raizna:pa_punt);
procedure baja_persona(var archp:p_archivo;var archt:t_archivo; var raizdni:pa_punt; var raizna:pa_punt);
procedure modificar_persona(var arch:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
procedure consultar_persona(var arch:p_archivo; var raizdni:pa_punt;var raizna:pa_punt);

implementation

procedure alta_persona(var arch:p_archivo; var raizdni:pa_punt;var raizna:pa_punt);
   var
     x:p_dato;
     pos:byte;
     i:integer;
     res,res2:string[2];
     nom,dnibuscado,num,dni2:string;
     fallo,enc:boolean;
begin
  clrscr;
  abrir_p_arch(arch);
  textbackground(3);
  gotoxy(47,7);
  writeln('   Alta de persona   ');
  textbackground(8);
  gotoxy(43,11);
  fallo:=false;
  repeat
    repeat
       clrscr;
       textbackground(3);
       gotoxy(47,7);
       writeln('   Alta de persona   ');
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
       end else x.dni := dni2;
    until  fallo=false;
    gotoxy(43,12);
    writeln(utf8toansi('¿Es correcto el DNI ingresado?  (SI/NO)                             '));
    gotoxy(43,13);
    readln(res2);
  until (res2='SI') or (res2='Si') or (res2='si') or (res2='sI');
  gotoxy(43,12);
  writeln('                                                            ');
  gotoxy(43,13);
  writeln('                                                            ');
  dnibuscado:=x.dni;
  enc:=false;
  if filesize(arch)>=1 then buscar_p_arch_dni2(arch,dnibuscado,pos,enc) else enc:=false;
  if not(enc) then
  begin
     num:= intToStr(filesize(arch));
     x.n_contrib:=num;
     cargar_datos_p(x);
     gotoxy(43,20);
     writeln(Utf8toAnsi('¿Confirma los datos ingresados? (SI/NO)'));
     gotoxy(43,21);
     readln(res);
     if (res='SI') or (res='Si') or (res='si') or (res='sI') then
     begin
        agregar_p_arch(arch,x);                                     //agrega en ultima posicion
        agregar_arbol(raizdni, x.dni);
        nom:=concat(x.apellido+' '+x.nombre);
        agregar_arbol(raizna, nom);
        gotoxy(43,22);
        writeln('La persona se ha dado de alta exitosamente.');
        gotoxy(43,23);
        writeln('Presione una tecla para continuar.');
        gotoxy(43,24);
        readkey;
        clrscr;
        cerrar_p_arch(arch);
     end else alta_persona(arch,raizdni,raizna);
  end else
  begin
   seek(arch,pos);
   read(arch,x);
   if x.estado then
   begin
     gotoxy(43,13);
     writeln('La persona sujeta al DNI ingresado ya se encuentra registrada');
     gotoxy(43,15);
     writeln('Presione una tecla para continuar.');
     gotoxy(43,16);
     readkey;
     clrscr;
   end else
   begin
     gotoxy(43,13);
     writeln('La persona sujeta al DNI ingresado fue registrada y dada de baja.');
     gotoxy(43,14);
     writeln(Utf8ToAnsi('¿Desea darla de alta nuevamente?  (SI/NO)'));
     gotoxy(43,15);
     readln(res2);
     If (res2='SI') OR (res2='Si') or (res2='si') then
     begin
       bajapersonas:= bajapersonas-1;
       x.estado:=true;
       seek(arch,pos);
       write(arch,x);
       gotoxy(43,16);
       writeln('La persona ha sido dada de alta exitosamente.');
       gotoxy(43,17);
       writeln('Presione una tecla para continuar.');
       gotoxy(43,18);
       readkey;
     end else
     begin
       gotoxy(43,16);
       writeln('La persona no ha sido dada de alta.');
       gotoxy(43,17);
       writeln('Presione una tecla para continuar.');
       gotoxy(43,18);
       readkey;
     end;
    end;
    cerrar_p_arch(arch);
  end;
end;

procedure baja_persona(var archp:p_archivo;var archt:t_archivo; var raizdni:pa_punt; var raizna:pa_punt);
var
    dnibuscado,nom,dni2,n_contrib,opcion,dni: string;
    x,xnuevo:p_dato;
    y:t_dato;
    pos,pos2,pos3,l,j,acgotoxy,i,imostrar,ac: byte;
    r,res2:string[2];
    r2:1..2;
    enc,fallo:boolean;
    k:integer;

begin
  clrscr;
  abrir_p_arch(archp);
  abrir_t_arch(archt);
  j:=0;
  fallo:=false;
  repeat
    repeat
       clrscr;
       textbackground(3);
       gotoxy(47,7);
       writeln('   Baja de Persona   ');
       textbackground(8);
       gotoxy(43,11);
       writeln('Ingrese DNI:');
       if fallo=true then
       begin
          gotoxy(56,11);
          writeln('                                        ');
          textbackground(4);
          gotoxy(43,12);
          Writeln('El DNI ingresado es invalido, intente nuevamente.');
          textbackground(8);
       end;
       gotoxy(56,11);
       readln(dni2);
       fallo:=false;
       if not(TryStrToInt(dni2,k))  then
       begin
             fallo:=true;
       end else dnibuscado := dni2;
    until  fallo=false;
    gotoxy(43,12);
    writeln(utf8toansi('¿Es correcto el DNI ingresado?  (SI/NO)                             '));
    gotoxy(43,13);
    readln(res2);
  until (res2='SI') or (res2='Si') or (res2='si') or (res2='sI');
  enc:=false;
  buscar_p_arch_dni(archp,dnibuscado,pos,enc);
  if enc then
  begin
    seek(archp,pos);
    read(archp,x);
    gotoxy(43,14);
    writeln('Datos de la persona: ');
    gotoxy(8,16);
    campos_p();
    l:=17;
    mostrar_datos_p(x,l);
    gotoxy(43,19);
    writeln(utf8toansi('¿Desea dar de baja a esta persona? (SI/NO)'));
    gotoxy(43,20);
    readln(r);
    if (r='SI') or (r='Si') or (r='si') then
    begin
      n_contrib:=x.n_contrib;
      nom:=concat(x.apellido+' '+x.nombre);
      acgotoxy:=23;
      buscar_t_arch_contrib(archt,n_contrib,nom,acgotoxy);
      bajapersonas:=bajapersonas+1;
      if acgotoxy<>23 then
      begin
        gotoxy(1,22);
        writeln(' Apellido y nombre|');
        gotoxy(20,22);
        campos_t();
        acgotoxy:=acgotoxy+1;
        gotoxy(27,acgotoxy);
        writeln(Utf8toAnsi('Estos terrenos están sujetos a la persona que se desea dar de baja, elija una opción.'));
        acgotoxy := acgotoxy+1;
        gotoxy(43,acgotoxy);
        writeln(Utf8toAnsi('1-Dar de baja los terrenos.'));
        acgotoxy := acgotoxy+1;
        gotoxy(43,acgotoxy);
        writeln(Utf8toAnsi('2-Cambiar de propietarios los terrenos.'));
        acgotoxy := acgotoxy+1;
        gotoxy(43,acgotoxy);
        acgotoxy := acgotoxy+1;
        ac:=1;
        repeat
         if ac=2 then
         begin
          gotoxy(43,acgotoxy-1);
          writeln('                                        ');
          gotoxy(43,acgotoxy);
          Writeln('La opcion ingresada es invalida, intente nuevamente.');
         end;
         fallo:=false;
         try
          readln(opcion);
          StrToInt(opcion);
          r2:=StrToInt(opcion);
         except
         On E : EConvertError do
          begin
             gotoxy(43,acgotoxy-1);
             writeln('                                        ');
             gotoxy(43,acgotoxy);
             Writeln('La opcion ingresada es invalida, intente nuevamente.');
             fallo:=true;
          end;
         end;
         ac:=2;
        until ((r2=1) or (r2=2)) and (fallo=false);

      if r2=1 then                         //elimina los terrenos
      begin
        for i:=1 to acgotoxy-22 do
        begin
        abrir_t_arch(archt);
        seek(archt,0);
        while not(eof(archt)) do
        begin
          read(archt,y);
          if y.n_contrib=x.n_contrib then
          begin
               pos2:=filepos(archt)-1;
               eliminar_datos_t(archt,pos2);
          end;
        end;
        end;
        clrscr;
        textbackground(3);
        gotoxy(47,7);
        writeln('   Baja de persona   ');
        textbackground(8);
        gotoxy(43,11);
        writeln('Los terrenos se han dado de baja exitosamente.');
        gotoxy(43,12);
        writeln('Presione una tecla para continuar');
        gotoxy(43,13);
        readkey;
      end else                           //Cambia de propietarios
      begin
        abrir_t_arch(archt);
        seek(archt,0);
        while not(eof(archt)) do
        begin
          read(archt,y);
          if y.n_contrib=x.n_contrib then
          begin                                     //pos3 : pos de nuevo propietario
               pos2:=filepos(archt)-1;              //pos2 : pos de terrenos que tenes que cambiar
               clrscr;                              //pos  : pos de la persona a dar de baja
               textbackground(3);                  //x    : propietario a dar de baja
               gotoxy(47,7);                       //y    : terrenos a cambiar de propietario
               writeln('   Baja de persona   ');
               textbackground(8);
               gotoxy(8,11);
               campos_t();
               imostrar:=12;
               mostrar_datos_t(y,j,imostrar);
               gotoxy(43,14);
               writeln('Ingrese DNI del nuevo propietario/a:');
               repeat
                 repeat
                 fallo:=false;
                 try
                   gotoxy(80,14);
                   readln(dni2);
                   StrToInt(dni2);
                   dni:=dni2;
                 except
                 On E : EConvertError do
                 begin
                   gotoxy(80,14);
                   writeln('                                        ');
                   gotoxy(43,15);
                   Writeln('El DNI ingresado es invalido, intente nuevamente.');
                   fallo:=true;
                 end;
                 end;
                until  fallo=false;
                gotoxy(43,16);
                writeln(utf8toansi('¿Es correcto el DNI ingresado?  (SI/NO)                             '));
                gotoxy(43,17);
                readln(res2);
               until (res2='SI') or (res2='Si') or (res2='si') or (res2='sI');

               enc:=false;
               buscar_p_arch_dni(archp,dni,pos3,enc);
               if not(enc) then
               begin
               gotoxy(43,16);
               writeln('La persona no se encuentra registrada.    ');
               gotoxy(43,17);
               writeln(utf8toansi('¿Desea dar de alta al nuevo propietario? (SI/NO)'));
               gotoxy(43,18);
               readln(r);
               if (r='si') or (r='Si') or (r='sI') or (r='SI') then
               begin
               alta_persona(archp, raizdni, raizna);
               end else
               begin
               baja_persona(archp,archt,raizdni,raizna);
               end;
               end;
               abrir_p_arch(archp);
               enc:=false;
               buscar_p_arch_dni(archp,dni,pos3,enc);
               if (enc) then
               begin
               seek(archp,pos3);
               read(archp,xnuevo);
               y.n_contrib:=xnuevo.n_contrib;
               seek(archt,pos2);
               write(archt,y);
               gotoxy(43,18);
               writeln('El terreno ha cambiado de propietario exitosamente.');
               gotoxy(43,19);
               writeln('Presione una tecla para continuar.');
               gotoxy(43,20);
               readkey;
               clrscr;
               end;
          end;
        end;
      end;
    end;
      abrir_p_arch(archp);
    x.estado:=false;                                 //Elimina al propietario
    seek(archp,pos);
    write(archp,x);
    eliminar_arbol(raizdni,x.dni);
    nom:=concat(x.apellido+' '+x.nombre);
    eliminar_arbol(raizna,nom);
    clrscr;
    textbackground(3);
    gotoxy(47,7);
    writeln('   Baja de persona   ');
    textbackground(8);
    gotoxy(43,11);
    writeln('La persona se ha dado de baja exitosamente.');
    gotoxy(43,12);
    writeln('Presiona una tecla para continuar.');
    gotoxy(43,13);
    readkey();
    clrscr;
    end else
    begin
      gotoxy(43,22);
      writeln('No se ha dado de baja a la persona.');
      gotoxy(43,23);
      writeln('Presiona una tecla para continuar.');
      gotoxy(43,24);
      readkey();
      clrscr;
    end;
  end else
  begin
    gotoxy(43,14);
    writeln('No se ha encontrado a la persona');
    gotoxy(43,15);
    writeln('Presiona una tecla para continuar');
    gotoxy(43,16);
    readkey();
  end;
  clrscr;
  cerrar_p_arch(archp);
  cerrar_t_arch(archt);
end;

procedure modificar_persona(var arch:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
var dnibuscado:string;
  x:p_dato;
  pos,l,ac:byte;
  r,r3,res2:string[2];
  r2:1..9;
  enc,fallo:boolean;
  dni2,nom,opcion:string;
  k:integer;
begin
  clrscr;
  enc:=false;
  textbackground(3);
  gotoxy(47,7);
  writeln(utf8toansi('   Modificación de persona   '));
  textbackground(8);
  gotoxy(43,11);
  writeln('Ingrese DNI de la persona a modificar:');
  gotoxy(43,12);
  readln(dnibuscado);
  fallo:=false;
  repeat
    repeat
       clrscr;
       textbackground(3);
       gotoxy(47,7);
       writeln('   Baja de Persona   ');
       textbackground(8);
       gotoxy(43,11);
       writeln('Ingrese DNI:');
       if fallo=true then
       begin
          gotoxy(56,11);
          writeln('                                        ');
          textbackground(4);
          gotoxy(43,12);
          Writeln('El DNI ingresado es invalido, intente nuevamente.');
          textbackground(8);
       end;
       gotoxy(56,11);
       readln(dni2);
       fallo:=false;
       if not(TryStrToInt(dni2,k))  then
       begin
             fallo:=true;
       end else dnibuscado := dni2;
    until  fallo=false;
    gotoxy(43,12);
    writeln(utf8toansi('¿Es correcto el DNI ingresado?  (SI/NO)                             '));
    gotoxy(43,13);
    readln(res2);
  until (res2='SI') or (res2='Si') or (res2='si') or (res2='sI');
  abrir_p_arch(arch);
  seek(arch,0);
  buscar_p_arch_dni(arch,dnibuscado,pos,enc);
  if enc then
  begin
        seek(arch,pos);
        read(arch,x);
        gotoxy(8,14);
        campos_p();
        l:=15;
        mostrar_datos_p(x,l);
        gotoxy(43,17);
        writeln(utf8toansi('¿Desea modificar algun campo de la persona? (SI/NO)'));
        gotoxy(43,18);
        readln(r);
        if (r='SI') or (r='Si') or (r='si') then
        begin
        repeat                          //Hicimos un repeat por si la persona desea modificar mas de un campo.
              clrscr;
              textbackground(3);
              gotoxy(47,7);
              writeln(utf8toansi('   Modificación de persona   '));
              textbackground(8);
              gotoxy(43,11);
              writeln('Ingrese el campo que desee modificar: ');
              gotoxy(43,12);
              writeln('1-Apellido');
              gotoxy(43,13);
              writeln('2-Nombre');
              gotoxy(43,14);
              writeln(utf8toansi('3-DirecciÓn'));
              gotoxy(43,15);
              writeln('4-Ciudad');
              gotoxy(43,16);
              writeln('5-Fecha de nacimiento');
              gotoxy(43,17);
              writeln(utf8toansi('6-Teléfono'));
              gotoxy(43,18);
              writeln('7-Email');

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
              try
                gotoXY(43,19);
                readln(opcion);
                StrToInt(opcion);
                r2:=StrToInt(opcion);
              except
              On E : EConvertError do
              begin
                gotoxy(43,19);
                writeln('                                        ');
                gotoxy(43,20);
                Writeln('La opcion ingresada es invalida, intente nuevamente.');
                fallo:=true;
                end;
              end;
              ac:=2;
              until ((r2=0) or (r2=1) or (r2=2) or (r2=3) or (r2=4) or (r2=5) or (r2=6) or (r2=7)) and (fallo=false);

              clrscr;
              case r2 of

              1: begin
                clrscr;
                nom:=concat(x.apellido+' '+x.nombre);                        //Si se elimina un nombre o apellido, se lo elimina del arbol
                eliminar_arbol(raizna,nom);                                  //y se lo vuelve a agregar nuevamente.
                textbackground(3);
                gotoxy(47,7);
                writeln(utf8toansi('   Modificación de persona   '));
                textbackground(8);
                gotoxy(43,11);
                writeln('Ingrese nuevo apellido');
                gotoxy(43,12);
                readln(x.apellido);
                nom:=concat(x.apellido+' '+x.nombre);
                agregar_arbol(raizna,nom);
                end;
              2: begin
                clrscr;
                nom:=concat(x.apellido+' '+x.nombre);
                eliminar_arbol(raizna,nom);
                textbackground(3);
                gotoxy(47,7);
                writeln(utf8toansi('   Modificación de persona   '));
                textbackground(8);
                gotoxy(43,11);
                writeln('Ingrese nuevo nombre');
                gotoxy(43,12);
                readln(x.nombre);
                nom:=concat(x.apellido+' '+x.nombre);
                agregar_arbol(raizna,nom);
                end;
              3: begin
                clrscr;
                textbackground(3);
                gotoxy(47,7);
                writeln(utf8toansi('   Modificación de persona   '));
                textbackground(8);
                gotoxy(43,11);
                writeln(utf8toansi('Ingrese nueva dirección'));
                gotoxy(43,12);
                readln(x.direccion);
                end;
              4: begin
                clrscr;
                textbackground(3);
                gotoxy(47,7);
                writeln(utf8toansi('   Modificación de persona   '));
                textbackground(8);
                gotoxy(43,11);
                writeln('Ingrese nueva ciudad');
                gotoxy(43,12);
                readln(x.ciudad);
                end;
              5: begin
                clrscr;
                textbackground(3);
                gotoxy(47,7);
                writeln(utf8toansi('   Modificación de persona   '));
                textbackground(8);
                gotoxy(43,11);
                writeln('Ingrese nueva fecha de nacimiento');
                gotoxy(43,12);
                readln(x.fecha_n);
                end;
              6: begin
                clrscr;
                textbackground(3);
                gotoxy(47,7);
                writeln(utf8toansi('   Modificación de persona   '));
                textbackground(8);
                gotoxy(43,11);
                writeln(utf8toansi('Ingrese nuevo teléfono'));
                gotoxy(43,12);
                readln(x.tel);
                end;
              7: begin
                clrscr;
                textbackground(3);
                gotoxy(47,7);
                writeln(utf8toansi('   Modificación de persona   '));
                textbackground(8);
                gotoxy(43,11);
                writeln('Ingrese nuevo email');
                gotoxy(43,12);
                readln(x.email);
                end;

              end;
              gotoxy(43,14);
              writeln(utf8toansi('¿Desea modificar otro campo? (SI/NO)'));
              gotoxy(43,15);
              read(r3);

        until (r3='NO') or (r3='No') or (r3='no');                         //Aqui se termino de modificar los campos de la persona
        seek(arch,pos);
        write(arch,x);
        clrscr;
        textbackground(3);
        gotoxy(47,7);
        writeln(utf8toansi('   Modificación de persona   '));
        textbackground(8);
        gotoxy(43,11);
        writeln('Los campos de la persona se han modificado exitosamente.');
        gotoxy(43,12);
        writeln('Presione una tecla para continuar.');
        gotoxy(43,13);
        readkey;
        clrscr;
        end else     // entra aqui si se encontro la persona pero no desea modificarle nada
        begin
        gotoxy(43,28);
        writeln('No se modifico ningun campo de la persona');
        gotoxy(43,29);
        writeln('Presione una tecla para continuar');
        gotoxy(43,30);
        readkey;
        clrscr;
        end;
  end
  else                                     //Si no encontro a la persona buscada
  begin
   clrscr;
   textbackground(3);
   gotoxy(47,7);
   writeln(utf8toansi('   Modificación de persona   '));
   textbackground(8);
   gotoxy(43,11);
   writeln('No se ha encontrado a la persona.');
   gotoxy(43,12);
   writeln('Presione una tecla para continuar.');
   gotoxy(43,14);
   readkey;
  end;
  clrscr;
  cerrar_p_arch(arch);
end;

procedure consultar_persona(var arch:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
var
  r:1..2;
  x,opcion,dni2:string;
  res2:string[2];
  enc,fallo:boolean;
  pos,l:byte;
  j:p_dato;
  ac:byte;
  k:integer;
begin
  abrir_p_arch(arch);
  clrscr;
  textbackground(3);
  gotoxy(47,7);
  writeln('   Consulta de persona   ');
  textbackground(8);
  gotoxy(43,11);
  writeln('1-Consulta por DNI');
  gotoxy(43,12);
  writeln('2-Consulta por nombre y apellido');
  ac:=1;
  repeat
       if ac=2 then
       begin
          gotoxy(43,13);
          writeln('                                        ');
          gotoxy(43,14);
          Writeln('La opcion ingresada es invalida, intente nuevamente.');
       end;
       fallo:=false;
       gotoXY(43,13);
       readln(opcion);

       if not(TryStrToInt(opcion,k)) then
       begin
            gotoxy(43,13);
            writeln('                                        ');
            gotoxy(43,14);
            Writeln('La opcion ingresada es invalida, intente nuevamente.');
            fallo:=true;
       end else r:=strtoint(opcion);
       ac:=2;
  until ((r=1) or (r=2)) and (fallo=false);

  if filesize(arch)=0 then
    begin
     clrscr;
     textbackground(3);
     gotoxy(47,7);
     writeln('   Consulta de persona   ');
     textbackground(8);
     gotoxy(43,11);
     writeln('El archivo de personas esta vacio.');
     gotoxy(43,12);
     writeln('Presione una tecla para continuar.');
     gotoxy(43,13);
     readkey;
     clrscr;
    end
  else
  begin
   clrscr;
   textbackground(3);
   gotoxy(47,7);
   writeln('   Consulta de persona   ');
   textbackground(8);
   gotoxy(43,11);
   if r=1 then
   begin
        fallo:=false;
        repeat
              repeat
                    clrscr;
                    textbackground(3);
                    gotoxy(47,7);
                    writeln('   Consulta de Persona   ');
                    textbackground(8);
                    gotoxy(43,11);
                    writeln('Ingrese DNI:');
                    if fallo=true then
                    begin
                         gotoxy(56,11);
                         writeln('                                        ');
                         textbackground(4);
                         gotoxy(43,12);
                         Writeln('El DNI ingresado es invalido, intente nuevamente.');
                         textbackground(8);
                    end;
                    gotoxy(56,11);
                    readln(dni2);
                    fallo:=false;
                    if not(TryStrToInt(dni2,k))  then
                    begin
                         fallo:=true;
                    end else x := dni2;
              until  fallo=false;
              gotoxy(43,12);
              writeln(utf8toansi('¿Es correcto el DNI ingresado?  (SI/NO)                             '));
              gotoxy(43,13);
              readln(res2);
        until (res2='SI') or (res2='Si') or (res2='si') or (res2='sI');
   end else
   begin
      if r=2 then
      begin
        writeln('Ingrese apellido y nombre de la persona a buscar: ');
        gotoxy(43,12);
        readln (x);
      end;
   end;
   gotoxy(43,12);
   readln (x);
   enc:=false;
   if r=1 then
   begin
   buscar_p_arch_dni(arch,x,pos,enc);
   end
   else
   begin
      if r=2 then
      begin
         buscar_p_arch_na(arch,x,pos,enc);
      end;
   end;
   if not(enc) then
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
      seek(arch,pos);
      read(arch,j);
      textbackground(3);
      gotoxy(47,7);
      writeln('   Consulta de persona   ');
      textbackground(8);
      gotoxy(43,12);
      writeln('Datos de la persona buscada:');
      gotoxy(8,14);
      campos_p();
      l:=15;
      mostrar_datos_p(j,l);
      gotoxy(43,17);
      writeln('Presione una tecla para continuar.');
      gotoxy(43,18);
      readkey;
      clrscr;
   end;
  end;
  cerrar_p_arch(arch);
end;





end.

