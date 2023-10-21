Unit archivoterrenos;

interface                                                           //UNIT PARA TENER LOS REGISTROS DE TERRENOS
uses
  crt, SysUtils;

const
  ruta2 = 'C:\archivos\archivoterrenos.dat';

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


implementation

procedure abrir_t_arch(var arch:t_archivo);          //abrir archivo de terreno
begin
    reset(arch);
end;

procedure crear_t_arch(var arch:t_archivo);          //crear archivo de terreno
begin
  assign(arch,ruta2);
  //rewrite(arch);
end;

procedure cerrar_t_arch(var arch:t_archivo);         //cerrar archivo de terreno
begin
   close(arch);
end;

end.
