_Base de datos utilizada:_  https://drive.google.com/file/d/1yI4ZkyJA7sKFADOVZwr5HOaxOLFoK6UU/view?usp=drive_link
_Resolución en TXT._

**El proyecto**
La institución que hace uso de estos datos necesita realizar ciertas mejoras para agilizar las operaciones
diarias. Para ello es necesario realizar ciertos ajustes, mejoras y reportes.

**El objetivo del trabajo**
Desde este momento usted y sus colegas, que conforman un “grupo de trabajo” en la cátedra de Bases
de Datos, serán parte de un equipo que encarará el proyecto. Vuestro rol será el de “Equipo DBA ” por lo 1
que el alcance de sus tareas comprenden la implementación, soporte y gestión de los datos del proyecto.

### Lista de requerimientos:

**Nuevos turnos de atención**
No se debe permitir almacenar nuevos turnos de atención anteriores al día actual. Se debe mostrar un
cartel que rece: “El turno tiene fecha anterior al día de hoy.” (sea en nuevos registros o actualizaciones).
Tabla: Appointment

**Cambio de campo**
Debe modificar el campo “gender” por “sex”, el campo no puede ser nulo, no debe permitirse tener
nuevos registros o actualizaciones donde el campo quede en nulo. Valores permitidos “M”, “F”, “N/A”.
Tabla: patient

**Nuevos campos para pacientes**
Agregar campo blood_type (tipos permitidos : A+, A-, B+, B-, AB+, AB-, O+, O-) y emergency_contact
(es el número de teléfono en caso de emergencia)
Tabla: patient

**Nuevo campo en turnos**
Agregar un campo llamado status para indicar si la cita está agendada, completada o cancelada; los
posibles estados son: Scheduled, Completed, Canceled. Esto debe ser obligatorio para cada turno nuevo.
En cuanto a los turnos que ya se encuentran en la base de datos, realizar un proceso de carga de este
campo siguiente la siguiente instrucción: si el turno es anterior al día 3/06/2024 , indicar “Completed”, de
otra forma indicar “Scheduled”.
Tabla: appointment

**Cambio en campo teléfono para doctor y enfermero**
Se debe aumentar la longitud del campo phone (a 20 caracteres) y se debe agregar una verificación para
el formato del número que se cargue. En caso de que el formato no sea adecuado, indicar un cartel que
rece “Wrong phone number.”.
Tablas: doctor , nurse

**Relación entre medicación y proveedor**
La tabla medication no tiene relación con la tabla supplier, se debe realizar una relación entre las mismas
(un medicamente un proveedor, un proveedor muchos medicamentos). Si el supplier_id de la tabla
medicament no existe en la tabla supplier: crear un registro “Others” en la tabla supplier y relacionar el
medicamento a éste.
Realizar pruebas de inserción de un nuevo medicamento.
Tablas: medication, supplier

**Nueva tabla**
Se debe crear una nueva tabla llamada: prescription, la misma almacenará las recetas que los médicos
indican a los pacientes. Esta tabla debe tener:
● prescription_id (identificador de la receta) clave primaria y generación serial.
● patient_id (id de paciente)
● doctor_id (id de doctor)
● medication_id (id de medicación)
● prescription_date (fecha de la prescripción)
● dosage (dosis) varchar de 100 no nulo
● frequency (frecuencia de toma) varchar de 50 no nulo
● start_date (fecha inicio de toma) formato fecha no nulo
● end_date (fecha fin de toma) formato fecha no nulo

**Actualización de stock**
Cuando se carga una nueva receta (prescription) se debe actualizar el stock del medicamento en la tabla
“medication_inventory”. Para ello, se debe reducir en uno al campo quantity. Además, se debe actualizar
el campo “last_updated” con en que se actualiza éste registro. Si el registro del medicamento no existe:
se debe crear en el momento.
Tablas: prescription, medication_inventory

**Nuevo stock**
Cuando se agrega un nuevo producto, se debe crear su registro de stock en la tabla
“medication_inventory”, tener presente actualizar el campo last_updated.
Tablas: product, medication_inventory

**Historia Clínica del paciente**
Se debe unificar la información de la historia clínica de un paciente para que desde cualquier área del
hospital se reciba la misma información. Para ello, crear una vista llamada patient_medical_history con la
siguiente información:
● id de paciente
● nombre del paciente
● apellido del paciente
● nombre del doctor
● apellido del doctor
● descripción del diagnóstico
● descripción del tratamiento
● descripción del procedimiento
● notas registro médico

Adicionalmente, se requieren los siguientes reportes:

● Reporte de montos por aseguradora: se requiere un listado de las aseguradoras y los montos que
deben afrontar por las facturas realizadas a los pacientes en toda la historia. Se necesita que el
reporte contenga: id de la aseguradora, nombre de la aseguradora, cantidad de pacientes a que
se les facturó, monto total facturado a la aseguradora.
● Cantidad de turnos atendidos por doctor: se necesita un reporte donde se muestre la cantidad de
de atenciones realizadas por cada doctor, agrupado a su vez por departamento del hospital;
tómese todos los datos almacenados. El reporte debe contener: Nombre del departamento,
nombre+apellido del doctor, cantidad de turnos atendidos.
● Reporte de medicamentos a reponer: se requiere un listado de medicamentos que se encuentran
con 5 unidades o menos. El reporte debe tener: id del medicamento, nombre del medicamento, id
del proveedor, nombre del proveedor, cantidad actual, cantidad utilizada (de las prescripciones).
