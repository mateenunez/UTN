{

 Notas:


  }
Program ProgramaFinal;
uses Archivos, TablaDeSimbolos, ManejoConLista, crt, analizadorSintactico,
  analizadorLexico, Evaluador;
var arbol:TApuntNodo; Estado:tipoEstado; funcionamiento:0..2;
begin
  funcionamiento:=0;                                            // empieza con funcionamiento = 0
  analizadorPredictivo(ruta,arbol,funcionamiento);              // si hay error funcionamiento = 1
  if funcionamiento = 2 then
  begin                                                         // si no hay errores sintacticos
       GuardarArbol(rutaarbol, arbol);                          //       funcionamiento = 2
       eval_Programa(arbol,Estado);
  end;
  readkey;
end.

