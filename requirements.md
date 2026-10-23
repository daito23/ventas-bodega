# Requirements Document

## Introduction

Este documento describe los requisitos del sistema de ventas y control de stock para el minimarket «La Esquina» (San Vicente de Cañete). El sistema es una aplicación web interna ejecutada en el entorno local de XAMPP, usada principalmente por el cajero para registrar productos y ventas, y por el dueño para consultar el stock bajo y las ventas del día con su total. El objetivo es reemplazar el control manual en cuaderno por un registro digital confiable que permita saber cuánto se vendió al final del día y detectar a tiempo los productos de alta rotación que se agotan.

Stack tecnológico: PHP 8 orientado a objetos sin frameworks, MySQL/MariaDB de XAMPP como motor de base de datos, aplicación web servida en entorno local.

## Glossary

- **Sistema**: La aplicación web interna del minimarket «La Esquina».
- **Cajero**: Usuario principal que registra productos y registra las ventas de los productos.
- **Dueño**: Usuario que consulta los resultados: productos con stock bajo y ventas del día con el total vendido.
- **Producto**: Artículo vendido en el minimarket, identificado por un código único y compuesto por nombre, categoría, precio de venta, stock actual y stock mínimo.
- **Codigo_Producto**: Identificador único de cada producto en la Base de Datos.
- **Precio_Venta**: Precio vigente del producto, expresado en soles (S/), que se toma al momento de registrar la venta.
- **Stock_Actual**: Cantidad de unidades disponibles de un producto en un momento dado.
- **Stock_Minimo**: Cantidad límite que dispara la alerta de stock bajo cuando el Stock_Actual está en o por debajo de ella.
- **Venta**: Registro de la venta de un solo producto, con la cantidad vendida, el total calculado, la fecha y la hora.
- **Base_Datos**: Instancia de MySQL/MariaDB de XAMPP donde se almacenan productos y ventas.
- **Transaccion**: Operación atómica de Base de Datos que agrupa el registro de la venta y el descuento de stock.
- **Token_CSRF**: Token incluido en formularios que modifican datos para prevenir la falsificación de petición en sitios cruzados.
- **PDO**: Extensión de PHP para acceso a bases de datos mediante sentencias preparadas.
- **.env**: Archivo externo al control de versiones que contiene las credenciales de la Base de Datos y datos sensibles.

## Requirements

### RF1 — Registrar productos

**Historia de usuario:** Como cajero, quiero registrar cada producto con sus datos, para mantener un catálogo digital actualizado en lugar de revisar los estantes físicamente.

#### Criterios de aceptación

1. CUANDO el cajero registra un producto con código (texto no vacío de hasta 20 caracteres), nombre (texto no vacío de hasta 100 caracteres), categoría (texto no vacío de hasta 50 caracteres), precio de venta (número decimal de S/ 0.00 a S/ 999,999.99), stock actual (número entero de 0 a 999,999) y stock mínimo (número entero de 0 a 999,999), EL SISTEMA DEBERÁ almacenar el producto en la Base de Datos y mostrar una confirmación de registro exitoso.
2. SI el precio de venta del producto es negativo (RN3), ENTONCES EL SISTEMA DEBERÁ rechazar el registro del producto y mostrar un mensaje de error indicando que el precio de venta no puede ser negativo.
3. SI el Codigo_Producto ya existe en la Base de Datos (RN4), ENTONCES EL SISTEMA DEBERÁ rechazar el registro del producto y mostrar un mensaje de error indicando que ya existe un producto con ese código.
4. SI el stock actual o el stock mínimo es negativo, o falta algún dato obligatorio, ENTONCES EL SISTEMA DEBERÁ rechazar el registro del producto y mostrar un mensaje de error.

### RF2 — Listar productos con alerta de stock mínimo

**Historia de usuario:** Como dueño, quiero ver la lista de productos con alertas de stock mínimo, para detectar a tiempo los productos que se agotan.

#### Criterios de aceptación

1. CUANDO se solicita la lista de productos, EL SISTEMA DEBERÁ mostrar todos los productos con su Codigo_Producto, nombre, categoría, Precio_Venta, Stock_Actual y Stock_Minimo.
2. SI un producto tiene un Stock_Actual en o por debajo de su Stock_Minimo, ENTONCES EL SISTEMA DEBERÁ resaltarlo en la lista con un estilo visual que lo distinga de los productos con stock suficiente y mostrar un indicador textual de stock mínimo alcanzado.

### RF3 — Registrar una venta de un producto

**Historia de usuario:** Como cajero, quiero registrar la venta de un producto eligiendo el producto y la cantidad, para llevar un control digital de las ventas y descontar el stock automáticamente.

#### Criterios de aceptación

1. CUANDO el cajero elige un producto existente y una cantidad mayor que cero (RN1) y menor o igual al Stock_Actual del producto (RN2), EL SISTEMA DEBERÁ tomar el Precio_Venta vigente, calcular el total de la venta como Precio_Venta multiplicado por la cantidad vendida, registrar la fecha y la hora, y descontar la cantidad vendida del Stock_Actual.
2. SI la cantidad vendida es cero o negativa (RN1), ENTONCES EL SISTEMA DEBERÁ rechazar la venta, mostrar un mensaje claro al cajero y no modificar el Stock_Actual del producto.
3. SI la cantidad vendida es mayor al Stock_Actual del producto (RN2), ENTONCES EL SISTEMA DEBERÁ rechazar la venta, mostrar un mensaje claro indicando el stock disponible y no modificar el Stock_Actual del producto.
4. SI el producto elegido no existe en la Base de Datos, ENTONCES EL SISTEMA DEBERÁ rechazar la venta y mostrar un mensaje de error.
5. SI ocurre un fallo a mitad del registro de la venta (RN5), ENTONCES EL SISTEMA DEBERÁ deshacer toda la operación mediante un rollback de la Transaccion, de modo que ni la venta ni el descuento de stock queden registrados.

### RF4 — Listar las ventas del día

**Historia de usuario:** Como dueño, quiero ver las ventas del día y el total vendido, para saber cuánto se vendió al final del día.

#### Criterios de aceptación

1. CUANDO se solicita el listado de ventas del día, EL SISTEMA DEBERÁ mostrar todas las ventas registradas en la fecha actual (desde 00:00 hasta 23:59), mostrando por cada venta el producto vendido, la cantidad vendida, el total calculado, la fecha y la hora.
2. CUANDO se muestran las ventas del día, EL SISTEMA DEBERÁ mostrar el total vendido del día, calculado como la suma de los totales de todas las ventas de la fecha actual, expresado en soles (S/) con dos decimales.
3. SI no existen ventas registradas para la fecha actual, ENTONCES EL SISTEMA DEBERÁ mostrar una lista vacía y un total vendido del día de S/ 0.00.

### RNF1 — PDO y sentencias preparadas

**Historia de usuario:** Como desarrollador, quiero que toda interacción con la Base de Datos use PDO con sentencias preparadas, para prevenir la inyección SQL.

#### Criterios de aceptación

1. CUANDO el Sistema ejecuta una consulta de lectura o escritura en la Base de Datos, EL SISTEMA DEBERÁ utilizar PDO con sentencias preparadas, vinculando todo valor proporcionado por el usuario como parámetro en lugar de concatenarlo en la cadena SQL.

### RNF2 — Token CSRF

**Historia de usuario:** Como desarrollador, quiero que los formularios que modifican datos incluyan un Token_CSRF, para evitar la falsificación de petición en sitios cruzados.

#### Criterios de aceptación

1. CUANDO se muestra un formulario que modifica datos (registro de producto o registro de venta), EL SISTEMA DEBERÁ incluir un Token_CSRF en el formulario.
2. CUANDO se envía un formulario que modifica datos (registro de producto o registro de venta), EL SISTEMA DEBERÁ validar que el Token_CSRF recibido coincide con el token generado antes de procesar la solicitud.
3. SI el Token_CSRF está ausente o no coincide con el token esperado, ENTONCES EL SISTEMA DEBERÁ rechazar la solicitud sin procesarla y mostrar un mensaje de error.

### RNF3 — Salida escapada (XSS)

**Historia de usuario:** Como desarrollador, quiero que toda información mostrada en la interfaz se escape, para prevenir ataques de tipo XSS (Cross-Site Scripting).

#### Criterios de aceptación

1. CUANDO el Sistema muestra información proveniente de la Base de Datos o ingresada por el usuario en la interfaz, EL SISTEMA DEBERÁ escapar la salida de modo que el contenido se muestre como texto literal y no se interprete como código HTML o JavaScript.
2. SI el contenido mostrado en la interfaz contiene etiquetas HTML o scripts JavaScript, ENTONCES EL SISTEMA DEBERÁ mostrarlos como texto literal en lugar de ejecutarlos o interpretarlos como código.

### RNF4 — Credenciales en archivo .env

**Historia de usuario:** Como desarrollador, quiero que las credenciales de la Base de Datos se almacenen en un archivo .env fuera del control de versiones, para proteger los datos sensibles.

#### Criterios de aceptación

1. CUANDO el Sistema carga las credenciales de la Base de Datos (host, nombre de base de datos, usuario y contraseña), EL SISTEMA DEBERÁ leerlas desde un archivo .env que está excluido del control de versiones mediante la configuración de ignorados del repositorio.
2. SI el archivo .env no existe o no contiene todas las credenciales necesarias para la conexión, ENTONCES EL SISTEMA DEBERÁ mostrar un mensaje de error indicando que no se pudieron cargar las credenciales y no iniciar la conexión a la Base de Datos.
3. SI el código fuente del Sistema está bajo control de versiones, ENTONCES EL SISTEMA DEBERÁ mantener las credenciales de la Base de Datos exclusivamente en el archivo .env, sin incluir valores de credenciales en el código fuente.

### RNF5 — Transacción de base de datos (atomicidad)

**Historia de usuario:** Como desarrollador, quiero que el registro de la venta y el descuento de stock se ejecuten dentro de una transacción, para garantizar que ambas operaciones se completen juntas o se reviertan juntas.

#### Criterios de aceptación

1. CUANDO el Sistema registra una venta, EL SISTEMA DEBERÁ ejecutar el registro de la Venta y el descuento de Stock_Actual dentro de una Transaccion (RN5) de modo que, al completarse ambas operaciones sin error, la Venta quede registrada y el Stock_Actual quede descontado en la Base_Datos.
2. SI ocurre un error durante el registro de la Venta o durante el descuento de Stock_Actual (RN5), ENTONCES EL SISTEMA DEBERÁ revertir la Transaccion mediante rollback, de modo que ni la Venta quede registrada ni el Stock_Actual quede modificado en la Base_Datos.

## Tabla de trazabilidad

La siguiente tabla mapea cada regla de negocio (RN1 a RN5) a los criterios de aceptación que la cubren.

| Regla de negocio | Descripción | Criterios de aceptación que la cubren |
|---|---|---|
| RN1 | La cantidad vendida debe ser mayor que cero | RF3-AC2 |
| RN2 | No se puede vender más unidades de las que hay en stock | RF3-AC3 |
| RN3 | El precio de venta no puede ser negativo | RF1-AC2 |
| RN4 | El código de producto es único; no pueden existir dos productos con el mismo código | RF1-AC3 |
| RN5 | La venta y el descuento de stock ocurren juntos o no ocurre ninguno (atomicidad) | RF3-AC5, RNF5-AC1, RNF5-AC2 |
