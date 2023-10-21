unit arbolpersonas;

interface                                                    //UNIT CON PROCEDIMIENTOS DE ARBOLES ASOCIADOS A PROPIETARIOS/AS
uses
  crt, modterrenos, modpersonas, archivopersonas, archivoterrenos;
  type
  pa_punt = ^pa_nodo;
  pa_nodo = record
            clave: string;
            sai, sad: pa_punt;
  end;

procedure abrir_arbol(var arch:p_archivo; var raizna:pa_punt; var raizdni:pa_punt);
procedure agregar_arbol(var raiz:pa_punt; x:string);
procedure crear_arbol (var raiz:pa_punt);
function eliminar_min (var raiz:pa_punt):string;
procedure eliminar_arbol (var raiz:pa_punt ; x:string);
function arbol_vacio (raiz:pa_punt): boolean;
function preorden(raiz:pa_punt; x:string):pa_punt;
procedure recorrer_inorden(var raiz:pa_punt;var archt:t_archivo;var archp:p_archivo;var acgotoxy:byte);


implementation

procedure abrir_arbol(var arch:p_archivo; var raizna:pa_punt; var raizdni:pa_punt);
var
   x:p_dato;                                                                                      //Procedimiento para que cuando comienze el programa
   nom:string;                                                                                    //carge los datos del archivo de personas en los arboles
begin
   abrir_p_arch(arch);
   seek(arch,0);
   while not(eof(arch)) do
   begin
      read(arch,x);
      if x.estado=true then
      begin
         nom:=concat(x.apellido+' '+x.nombre);
         agregar_arbol(raizna,nom);
         agregar_arbol(raizdni,x.dni);
      end;
   end;
   cerrar_p_arch(arch);
end;

procedure agregar_arbol(var raiz:pa_punt; x:string);
begin
  if raiz = nil then
  begin
    new(raiz);
    raiz^.clave:= x;
    raiz^.sai:= nil;
    raiz^.sad:= nil;
  end
  else if (raiz^.clave) > (x) then agregar_arbol(raiz^.sai,x)
  else agregar_arbol(raiz^.sad,x)
end;

procedure crear_arbol (var raiz:pa_punt);
begin
raiz:= nil;
end;

function eliminar_min (var raiz:pa_punt):string;
begin
     if raiz^.sai = nil then
     begin
          eliminar_min := raiz^.clave ;
          raiz := raiz^.sad ;
     end
     else eliminar_min:=eliminar_min(raiz^.sai);
end;

procedure eliminar_arbol (var raiz:pa_punt ; x:string);
begin
     if raiz<>nil then
     begin
          if (x) < (raiz^.clave) then
          eliminar_arbol(raiz^.sai,x)
          else
            if (x) > (raiz^.clave) then
                 eliminar_arbol(raiz^.sad,x)
            else
                 if (raiz^.sai=nil) and (raiz^.sad=nil) then
                      raiz:=nil
                 else
                      if raiz^.sai = nil then
                         raiz:=raiz^.sad
                      else
                          if raiz^.sad = nil then
                             raiz:=raiz^.sai
                          else
                          raiz^.clave:=eliminar_min(raiz^.sad);
     end;
end;

function arbol_vacio (raiz:pa_punt): boolean;
begin
arbol_vacio:= raiz = nil;
end;

function preorden(raiz:pa_punt; x:string):pa_punt;
begin
   if (raiz = nil) then preorden := nil
   else
   if (raiz^.clave) = (x)  then
   preorden:= raiz
   else if (raiz^.clave) > (x) then
   preorden := preorden(raiz^.sai,x)
   else
   preorden := preorden(raiz^.sad,x)
end;

procedure recorrer_inorden(var raiz:pa_punt;var archt:t_archivo;var archp:p_archivo;var acgotoxy:byte);
var
  x:string;
  y:t_dato;
  j:p_dato;
  buscado:string;
  pos:byte;
  n_contrib:string;
  enc:boolean;

begin
  if raiz <> nil then
  begin
     abrir_t_arch(archt);
     abrir_p_arch(archp);
     recorrer_inorden(raiz^.sai, archt, archp,acgotoxy);
     x:= raiz^.clave;
     enc:=false;
     buscar_p_arch_na(archp,x,pos,enc);
     seek(archp,pos);
     read(archp,j);
     buscado:=j.n_contrib;
     buscar_t_arch_contrib(archt,buscado,x,acgotoxy);
     recorrer_inorden(raiz^.sad, archt, archp,acgotoxy);
  end
end;


end.


