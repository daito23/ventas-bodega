-- ============================================================
--  Schema de la base de datos «bodega_ventas»
--  Sistema de ventas y control de stock — Minimarket «La Esquina»
--  Motor: MariaDB / MySQL (XAMPP) — InnoDB
-- ============================================================

DROP DATABASE IF EXISTS bodega_ventas;
CREATE DATABASE bodega_ventas
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE bodega_ventas;

-- ------------------------------------------------------------
--  Tabla: producto
-- ------------------------------------------------------------
CREATE TABLE producto (
    id           INT           NOT NULL AUTO_INCREMENT,
    codigo       VARCHAR(10)   NOT NULL,
    nombre       VARCHAR(100)  NOT NULL,
    categoria    VARCHAR(50)   NOT NULL,
    precio       DECIMAL(10,2) NOT NULL,
    stock        INT           NOT NULL,
    stock_minimo INT           NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_producto_codigo (codigo),
    CHECK (precio       >= 0),
    CHECK (stock         >= 0),
    CHECK (stock_minimo  >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
--  Tabla: venta
-- ------------------------------------------------------------
CREATE TABLE venta (
    id              INT           NOT NULL AUTO_INCREMENT,
    producto_id     INT           NOT NULL,
    cantidad        INT           NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    total           DECIMAL(10,2) NOT NULL,
    fecha_hora      DATETIME      NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_venta_producto
        FOREIGN KEY (producto_id) REFERENCES producto(id),
    CHECK (cantidad > 0),
    CHECK (precio_unitario >= 0),
    CHECK (total >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;
