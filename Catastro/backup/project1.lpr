program catastro;

uses menu;
begin
      catastromenu();
  end.

//Falta:
//Validar que sean fechas.                                                            Hecho
//Validar que escriban algo correcto, para que no puedan romper el programa.
//Al dar de alta un terreno validar que el propietario exista.                        Hecho
//Asignar automaticamente el numero de contribuyente.                                 Hecho
//Modificar el dar de alta para que los campos no se borren, puntero a la derecha.    Hecho
//Modificar listas para que se vean en planillas.                                     Hecho
//Verificar que ingrese bien las fechas en porcentajes.                               Hecho
//Modificar los procedimientos consulta en arboles.                                   Hecho
//Modificar los procedimientos de Terrenos con archaux.                               Hecho
//Try en fechas                                                                       Hecho
{Si es baja de la persona en forma lógica, deberían dar de baja todos los terrenos en
forma física (una forma..., Se podría averiguar cómo se hace en la realidad y simularlo
, pero, para acotar el proyecto podría ser una solución).                             Hecho

Si es baja de terreno, deben eliminar físicamente el mismo y verificar si era
el único terreno del propietario. Si era el único, deben hacer baja lógica del propietario.   Hecho
 }
