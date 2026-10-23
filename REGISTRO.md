# Registro de revisión de lo generado por IA

| Fase | Qué generó la IA | Qué corregí o rechacé | Por qué |

| 1 · D0 | D0.md con problema, usuarios, RF1–RF4, RNF1–RNF5, RN1–RN5, fuera de alcance y supuestos | Corregí "se escapada" por "se escapa" en RNF3 | Era un error de redacción |
| 1 · D0 | Supuestos del sistema | Agregué el SUPUESTO de que cada venta registra un solo producto | El caso dice "registrar una venta de un producto" y Kiro no lo había puesto |
| 1 · D0 | SUPUESTO "no se contemplan conflictos de concurrencia" | Lo cambié por "normalmente un solo cajero usa la app; aun así la venta se protege con una transacción" | Contradecía la RN5 y el RNF5, que exigen transacción en la venta |

FASE 2

| 2 · Especificación | requirements.md, RF3 criterios 2 y 3 (rechazos por cantidad) | Agregué que el sistema debe mostrar un mensaje claro al cajero | Kiro solo decía "sin modificar el stock"; el cajero necesita saber por qué se rechazó la venta |
| 2 · Especificación | requirements.md, RF1 (registro de productos) | Agregué el criterio 4: rechazar stock o stock mínimo negativos y datos obligatorios vacíos | Kiro solo validaba el precio y el código; un stock negativo rompería el control de inventario |
| 2 · Especificación | requirements.md, RF4 (ventas del día) | Detallé los datos que se muestran por venta: hora, producto, cantidad, precio unitario y total | El criterio original no decía qué datos mostrar y no se podía verificar |

DISEÑO

| 2 · Especificación | design.md, contrato de VentaService | Agregué PDO al constructor de VentaService y corregí la frase "los Service no conocen PDO" | El diseño decía que el Service hace beginTransaction/commit/rollBack, pero sin recibir PDO no podía hacerlo; era una contradicción |
| 2 · Especificación | design.md, Testing Strategy | Rechacé las pruebas de integración contra base de datos real; dejé solo tests/run.php con repositorios falsos | El examen pide pruebas sin base de datos, sin PHPUnit ni Composer |

FASE 3
| 3 · Base de datos | database/schema.sql con tablas producto y venta, PK, FK, UNIQUE y CHECK | Agregué CHECK (precio_unitario >= 0) y CHECK (total >= 0) en la tabla venta | Kiro solo validaba la cantidad en venta; un precio o total negativo rompería la RN3 y el total del día |