unit menu;

interface
uses
   crt, SysUtils, ABMC_terrenos, ABMC_personas, archivopersonas, archivoterrenos, modpersonas, modterrenos, arbolpersonas, procedimientosvarios;
var i:integer;

procedure catastromenu();
procedure abmc_propietarios(var archt:t_archivo;var archp:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
procedure abmc_terrenos(var archt:t_archivo;var archp:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
procedure listados_comprobante(var archt:t_archivo;var archp:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
procedure estadisticas(var archt:t_archivo;var archp:p_archivo);
implementation

procedure catastromenu();
var
    opcion:char;
    fallo:boolean;
    opcion2,ac:byte;
    raizdni: pa_punt;
    raizna: pa_punt;
    archt: t_archivo;
    archp: p_archivo;

begin
  //creas dos arboles;
  crear_arbol(raizdni);
  crear_arbol(raizna);
  //creas archivos;
  crear_t_arch(archt);
  crear_p_arch(archp);
  abrir_t_arch(archt);
  abrir_p_arch(archp);
  abrir_arbol(archp,raizna,raizdni);
  if filesize(archt)>=2 then ordenar_t_arch(archt);
  cantidad_baja2(archp);
  repeat
    clrscr;
    textbackground(white);
    textcolor(black);
    gotoxy(43,7);
    writeln('             Menu principal                 ');
    textbackground(black);
    textcolor(white);
    gotoXY(43,11);
    writeln('1 - Terrenos');
    gotoXY(43,12);
    writeln('2 - Propietarios');
    gotoXY(43,13);
    writeln('3 - Listados y comprobante');
    gotoXY(43,14);
    writeln(utf8toansi('4 - Estadísticas'));
    gotoXY(43,15);
    writeln('0 - Salir');
    ac:=1;
    repeat
       if ac=2 then
       begin
         gotoxy(43,16);
         writeln('                                        ');
         textbackground(red);
         gotoxy(43,17);
         Writeln('La opcion ingresada es invalida, intente nuevamente.');
         textbackground(black);
       end;
       fallo:=false;
       gotoXY(43,16);
       readln(opcion);
       if not(TryStrToInt(opcion,i)) then
          begin
             gotoxy(43,16);
             writeln('                                        ');
             textbackground(red);
             gotoxy(43,17);
             Writeln('La opcion ingresada es invalida, intente nuevamente.');
             textbackground(black);
             fallo:=true;
          end else opcion2:=StrToInt(opcion);

       ac:=2;
    until ((opcion2=0) or (opcion2=1) or (opcion2=2) or (opcion2=3) or (opcion2=4)) and (fallo=false);
    clrscr;
    case opcion2 of
    1: abmc_terrenos(archt,archp,raizdni,raizna);
    2: abmc_propietarios(archt,archp,raizdni,raizna);
    3: listados_comprobante(archt,archp,raizdni,raizna);
    4: estadisticas(archt,archp);
    end;

  until opcion2 = 0 ;
end;

procedure abmc_terrenos(var archt:t_archivo;var archp:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
var
   opcion:string;
   fallo:boolean;
   opcion2,ac:byte;
begin
  clrscr;

  repeat
    clrscr;
    textbackground(white);
    textcolor(black);
    gotoxy(43,7);
    writeln(utf8toansi(' Menu alta - baja - modificación - consulta '));
    textbackground(black);
    textcolor(white);
    gotoXY(43,11);
    writeln('1 - Alta terreno');
    gotoXY(43,12);
    writeln('2 - Baja terreno');
    gotoXY(43,13);
    writeln('3 - Modificar terreno');
    gotoXY(43,14);
    writeln('4 - Consultar terreno');
    gotoXY(43,15);
    writeln('0 - Volver a menu principal');
    ac:=1;
    repeat
       if ac=2 then
       begin
         gotoxy(43,16);
         writeln('                                        ');
         textbackground(red);
         gotoxy(43,17);
         Writeln('La opcion ingresada es invalida, intente nuevamente.');
         textbackground(black);
         end;
          fallo:=false;
          gotoXY(43,16);
          readln(opcion);
          if not(TryStrToInt(opcion,i))then
          begin
             gotoxy(43,16);
             writeln('                                        ');
             textbackground(red);
             gotoxy(43,17);
             Writeln('La opcion ingresada es invalida, intente nuevamente.');
             textbackground(black);
             fallo:=true;
          end else opcion2:=StrToInt(opcion);
       ac:=2;
    until ((opcion2=0) or (opcion2=1) or (opcion2=2) or (opcion2=3) or (opcion2=4)) and (fallo=false);
    clrscr;

    case opcion2 of
    1: alta_terreno(archt,archp,raizdni,raizna);
    2: baja_terreno(archt,archp);
    3: modificar_terreno(archt);
    4: consulta_terreno(archt);
    end;

  until opcion2 = 0 ;
  clrscr;
end;

procedure abmc_propietarios(var archt:t_archivo;var archp:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
var
   opcion:string;
   fallo:boolean;
   opcion2,ac:byte;
begin
  clrscr;
  repeat
    clrscr;
    textbackground(white);
    textcolor(black);
    gotoxy(43,7);
    writeln(utf8toansi(' Menu alta - baja - modificación - consulta '));
    textbackground(black);
    textcolor(white);
    gotoXY(43,11);
    writeln('1 - Alta propietario');
    gotoXY(43,12);
    writeln('2 - Baja propietario');
    gotoXY(43,13);
    writeln('3 - Modificar propietario');
    gotoXY(43,14);
    writeln('4 - Consultar propietario');
    gotoXY(43,15);
    writeln('0 - Volver a menu principal');
    ac:=1;
    repeat
       if ac=2 then
       begin
         gotoxy(43,16);
         writeln('                                        ');
         textbackground(red);
         gotoxy(43,17);
         Writeln('La opcion ingresada es invalida, intente nuevamente.');
         textbackground(black);
         end;
          fallo:=false;
          gotoXY(43,16);
          readln(opcion);
          if not(TryStrToInt(opcion,i))then
          begin
             gotoxy(43,16);
             writeln('                                        ');
             textbackground(red);
             gotoxy(43,17);
             Writeln('La opcion ingresada es invalida, intente nuevamente.');
             textbackground(black);
             fallo:=true;
          end else opcion2:=StrToInt(opcion);
       ac:=2;
    until ((opcion2=0) or (opcion2=1) or (opcion2=2) or (opcion2=3) or (opcion2=4)) and (fallo=false);
    clrscr;

    case opcion2 of

    1: alta_persona(archp,raizdni,raizna);
    2: baja_persona(archp, archt, raizdni, raizna);
    3: modificar_persona(archp, raizdni, raizna);
    4: consultar_persona(archp,raizdni,raizna);

    end;

  until opcion2 = 0 ;
  clrscr;
end;

procedure listados_comprobante(var archt:t_archivo;var archp:p_archivo; var raizdni:pa_punt; var raizna:pa_punt);
var
   opcion:string;
   fallo:boolean;
   opcion2,ac:byte;
begin
    clrscr;

    repeat
      clrscr;
      textbackground(white);
      textcolor(black);
      gotoxy(43,7);
      writeln(utf8toansi('          Listados y Comprobante          '));
      textbackground(black);
      textcolor(white);
      gotoXY(43,11);
      writeln('1 - Listado por nombre y apellido con terrenos valorizados');
      gotoXY(43,12);
      writeln('2 - Listado de inscripciones de un ',utf8toansi('año'),', ordenado por fecha');
      gotoXY(43,13);
      writeln('3 - Listado de terrenos ordenado por zona');
      gotoXY(43,14);
      writeln('4 - Comprobante de terreno');
      gotoXY(43,15);
      writeln('0 - Volver a menu principal');
      ac:=1;
      repeat
       if ac=2 then
       begin
         gotoxy(43,16);
         writeln('                                        ');
         textbackground(red);
         gotoxy(43,17);
         Writeln('La opcion ingresada es invalida, intente nuevamente.');
         textbackground(black);
         end;
          fallo:=false;
          gotoXY(43,16);
          readln(opcion);
          if not(TryStrToInt(opcion,i))then
          begin
             gotoxy(43,16);
             writeln('                                        ');
             textbackground(red);
             gotoxy(43,17);
             Writeln('La opcion ingresada es invalida, intente nuevamente.');
             textbackground(black);
             fallo:=true;
          end else opcion2:=StrToInt(opcion);
       ac:=2;
    until ((opcion2=0) or (opcion2=1) or (opcion2=2) or (opcion2=3) or (opcion2=4)) and (fallo=false);

      case opcion2 of

      1: listado_na(raizna,archt,archp);
      2: listado_fecha(archt);
      3: listado_zona(archt);
      4: comprobante(archt,archp);

    end;

  until opcion2 = 0 ;
  clrscr;
end;

procedure estadisticas(var archt:t_archivo;var archp:p_archivo);
var
   opcion:string;
   fallo:boolean;
   opcion2,ac:byte;
begin


  repeat
    clrscr;
    textbackground(white);
    textcolor(black);
    gotoxy(43,7);
    writeln(utf8toansi('            Menu de estadísticas            '));
    textbackground(black);
    textcolor(white);
    gotoXY(43,11);
    writeln('1 - Cantidad de inscriptos entre dos fechas');
    gotoXY(43,12);
    writeln(utf8toansi('2 - Porcentaje de personas con más de un terreno'));
    gotoXY(43,13);
    writeln(utf8toansi('3 - Porcentaje de terrenos por tipo de edificación'));
    gotoXY(43,14);
    writeln('4 - Cantidad de personas dadas de baja');
    gotoXY(43,15);
    writeln('0 - Volver a menu principal');
    ac:=1;
    repeat
       if ac=2 then
       begin
         gotoxy(43,16);
         writeln('                                        ');
         textbackground(red);
         gotoxy(43,17);
         Writeln('La opcion ingresada es invalida, intente nuevamente.');
         textbackground(black);
         end;
          fallo:=false;
          gotoXY(43,16);
          readln(opcion);
          if not(TryStrToInt(opcion,i))then
          begin
             gotoxy(43,16);
             writeln('                                        ');
             textbackground(red);
             gotoxy(43,17);
             Writeln('La opcion ingresada es invalida, intente nuevamente.');
             textbackground(black);
             fallo:=true;
          end else opcion2:=StrToInt(opcion);
       ac:=2;
    until ((opcion2=0) or (opcion2=1) or (opcion2=2) or (opcion2=3) or (opcion2=4)) and (fallo=false);
    clrscr;

    case opcion2 of
    1: dos_fechas(archt);
    2: porcentaje_prop(archt,archp);
    3: porcentaje_edif(archt);
    4: cantidad_baja();
    end;

  until opcion2 = 0 ;
  clrscr;
end;

end.

