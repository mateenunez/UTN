unit archivopersonas;

interface                                               //UNIT PARA TENER LOS REGISTROS DE PROPIETARIOS/AS

uses Classes, SysUtils,crt;
const ruta1 = 'C:\archivos\archivopersonas.dat';

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



Procedure crear_p_arch(var arch:p_archivo);
procedure abrir_p_arch(var arch:p_archivo);
procedure cerrar_p_arch(var arch:p_archivo);

implementation

procedure crear_p_arch(var arch:p_archivo);       //crear archivo de personas
begin
  assign(arch,ruta1);
  //rewrite(arch);
end;

procedure abrir_p_arch(var arch:p_archivo);       //abrir archivo de personas
begin
    //assign(arch, ruta1);
    reset(arch);
end;

procedure cerrar_p_arch(var arch:p_archivo);      //cerrar archivo de personas
begin
    close(arch);
end;

end.

