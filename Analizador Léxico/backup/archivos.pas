unit Archivos;

interface
uses
  crt, SysUtils;
const
  ruta = 'C:\UTN\codigofuente.txt';

type

archivofuente = file of char;

procedure abrir_arch(var CodigoFuente:archivofuente);
procedure crear_arch(var CodigoFuente:archivofuente);
procedure cerrar_arch(var CodigoFuente:archivofuente);
Procedure leer_arch(var CodigoFuente:archivofuente;var control:Longint; var caracter:char);

Implementation

procedure abrir_arch(var CodigoFuente:archivofuente);
begin
    assign(CodigoFuente,ruta);
    reset(CodigoFuente);
end;

procedure crear_arch(var CodigoFuente:archivofuente);
begin
  assign(CodigoFuente,ruta);
  rewrite(CodigoFuente);
end;

procedure cerrar_arch(var CodigoFuente:archivofuente);
begin
    close(CodigoFuente);
end;

Procedure leer_arch(var CodigoFuente:archivofuente;var control:Longint; var caracter:char);
begin
  if (control<filesize(CodigoFuente)) then
    begin
      seek(CodigoFuente,control);
      read(CodigoFuente,caracter);

    end
  else
      begin
        caracter:=#0;
      end;
end;

Begin

end.

