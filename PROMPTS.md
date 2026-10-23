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