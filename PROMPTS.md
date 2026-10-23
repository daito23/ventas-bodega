# Prompts usados (en orden)
## Fase 1 · D0
Actúa como analista de sistemas. Crea el archivo D0.md en español en la raíz del proyecto para este caso:

Minimarket «La Esquina» (San Vicente de Cañete) vende abarrotes, lácteos, bebidas, conservas y
limpieza. Hoy anota las ventas en un cuaderno y revisa el stock mirando los estantes; al final del
día no sabe cuánto vendió y se queda sin productos de alta rotación. Necesita una aplicación web
interna usada por el cajero.

D0.md debe tener exactamente estas secciones:
1. Problema en una sola frase.
2. Usuarios y qué hace cada uno (cajero: registra productos y ventas; dueño: consulta resultados).
3. Proceso actual y su dificultad.
4. Requisitos funcionales:
   RF1 Registrar productos (código, nombre, categoría, precio de venta, stock actual, stock mínimo).
   RF2 Listar productos resaltando los que están en o por debajo de su stock mínimo.
   RF3 Registrar una venta de un producto: el cajero elige el producto y la cantidad; el sistema
       toma el precio vigente, calcula el total, registra fecha y hora y descuenta el stock.
   RF4 Listar las ventas del día con el total vendido del día.
5. Requisitos no funcionales RNF1… de seguridad (PDO con sentencias preparadas, token CSRF,
   salida escapada, credenciales en .env) e integridad de datos (transacción en la venta), y
   el stack: PHP 8 orientado a objetos, MySQL/MariaDB de XAMPP, sin frameworks.
6. Reglas de negocio, las cinco, sin omitir ninguna:
   RN1 La cantidad vendida debe ser mayor que cero.
   RN2 No se puede vender más de lo que hay en stock.
   RN3 El precio de venta no puede ser negativo.
   RN4 El código de producto es único.
   RN5 La venta y el descuento de stock ocurren juntos o no ocurre ninguno.
7. Fuera de alcance: inicio de sesión, roles, clientes, boletas y facturación electrónica,
   agentes conversacionales, despliegue público.
8. Supuestos, cada uno empezando con la palabra SUPUESTO.

No agregues funcionalidades que no estén en el caso y no generes código.

## Fase 2 · requirements
Lee D0.md. Genera los requisitos en español con criterios de aceptación en formato EARS:
"CUANDO <evento> EL SISTEMA DEBERÁ <respuesta>" y "SI <condición> ENTONCES EL SISTEMA DEBERÁ <respuesta>".
Usa los mismos identificadores de D0.md: RF1, RF2, RF3, RF4 y RNF1…RNFn.
Cada regla RN1 a RN5 debe aparecer en al menos un criterio y al final incluye una tabla de
trazabilidad RN → criterio.
Incluye criterios para estos casos de rechazo: cantidad 0 o negativa, cantidad mayor al stock
(el stock no cambia), precio negativo, código de producto repetido, producto inexistente y
fallo a mitad del registro de la venta (se deshace todo).
No incluyas login, roles, clientes ni boletas.

## Fase 2 · design

Con los requisitos aprobados genera el diseño en español con estas secciones:

1. Arquitectura en capas Model → Repository → Service → Controller → views, más public/index.php
   como punto de entrada. Para cada capa indica qué hace y qué NO hace: las reglas de negocio
   solo en Services; los Repositories solo ejecutan SQL con PDO preparado; los Controllers solo
   leen la petición, validan el token CSRF y llaman al Service; las vistas solo muestran datos
   escapados.
2. Base de datos bodega_ventas (utf8mb4, InnoDB):
   - producto: id INT PK AUTO_INCREMENT, codigo VARCHAR(10) NOT NULL UNIQUE, nombre VARCHAR(100)
     NOT NULL, categoria VARCHAR(50) NOT NULL, precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
     stock INT NOT NULL CHECK (stock >= 0), stock_minimo INT NOT NULL CHECK (stock_minimo >= 0).
   - venta: id INT PK AUTO_INCREMENT, producto_id INT NOT NULL FK → producto(id),
     cantidad INT NOT NULL CHECK (cantidad > 0), precio_unitario DECIMAL(10,2) NOT NULL,
     total DECIMAL(10,2) NOT NULL, fecha_hora DATETIME NOT NULL.
3. Contratos de clases con firmas tipadas PHP 8 (declare(strict_types=1)): interfaces
   ProductoRepositoryInterface y VentaRepositoryInterface (para poder usar repositorios falsos
   en las pruebas), sus implementaciones PDO, ProductoService y VentaService, con parámetros y
   retornos tipados (por ejemplo buscarPorId(int $id): ?Producto).
4. Transacción de venta: beginTransaction, leer el producto con SELECT ... FOR UPDATE, validar
   las reglas, insertar la venta, descontar el stock, commit; rollBack en el catch.
5. Manejo de errores: excepciones propias (ValidacionException, StockInsuficienteException,
   ProductoNoEncontradoException); registro inexistente devuelve null, error de base de datos
   lanza excepción; al usuario solo se muestran mensajes claros, nunca trazas.
6. Seguridad: PDO preparado, token CSRF, htmlspecialchars, credenciales leídas desde .env.

No generes código de implementación.