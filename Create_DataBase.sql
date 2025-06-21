CREATE DATABASE GESTION_STOCK;

GO

USE GESTION_STOCK;

GO

-- Tabla de tipos de rol
CREATE TABLE TipoRol (
    IdTipoRol TINYINT PRIMARY KEY IDENTITY(1,1),
    Descripcion NVARCHAR(50) NOT NULL
);

GO

-- Tabla de empleados
CREATE TABLE Empleados (
    IdEmpleado INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20),
    Email NVARCHAR(100) NOT NULL,
    IdTipoRol TINYINT NOT NULL,
    Activo BIT NOT NULL,
    FOREIGN KEY (IdTipoRol) REFERENCES TipoRol(IdTipoRol)
);

GO

-- Tabla de proveedores
CREATE TABLE Proveedores (
    IdProveedor INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20),
    Email NVARCHAR(100) NOT NULL,
    FechaUltimaEntrega DATE NOT NULL,
    Activo BIT NOT NULL
);

GO

-- Tabla de categor�as
CREATE TABLE Categoria (
    IdCategoria TINYINT PRIMARY KEY IDENTITY(1,1),
    NombreCategoria NVARCHAR(100) NOT NULL
);

GO

-- Tabla de productos
CREATE TABLE Productos (
    IdProducto INT PRIMARY KEY IDENTITY(1,1),
    NombreProducto NVARCHAR(100),
    IdCategoria TINYINT NOT NULL,
    Stock INT NOT NULL,
    StockMinimo INT NOT NULL, -- se movi� ac�
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    IdProveedor INT NOT NULL,
    Estado BIT NOT NULL,
    FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria),
    FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IdProveedor)
);

GO

-- Tabla de alertas
CREATE TABLE AlertaStock (
    IdAlerta INT PRIMARY KEY IDENTITY(1,1),
    IdProducto INT NOT NULL,
    FechaAlerta DATE NOT NULL,
    Descripcion NVARCHAR(255), -- nueva columna
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);

GO

-- Tabla tipo de movimiento
CREATE TABLE TipoMovimiento (
    IdTipoMovimiento TINYINT PRIMARY KEY IDENTITY(1,1),
    Descripcion NVARCHAR(50) NOT NULL
);

GO

-- Tabla movimientos
CREATE TABLE MovimientoStock (
    IdMovimiento INT PRIMARY KEY IDENTITY(1,1),
    IdProducto INT NOT NULL,
    IdEmpleado INT NOT NULL,
    Fecha DATE NOT NULL,
    IdTipoMovimiento TINYINT NOT NULL,
    Descripcion NVARCHAR(255),
    Cantidad INT NOT NULL,
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto),
    FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado),
    FOREIGN KEY (IdTipoMovimiento) REFERENCES TipoMovimiento(IdTipoMovimiento)
);

GO

-- EJECUTAR PARA AGREGAR LOS ROLES Y LOS TIPOS DE MOVIMIENTOS
INSERT INTO TipoRol(Descripcion)
VALUES('Empleado');

GO

INSERT INTO TipoRol(Descripcion)
VALUES('Administrador');

GO

INSERT INTO TipoMovimiento(Descripcion)
VALUES('Entrada');

GO

INSERT INTO TipoMovimiento(Descripcion)
VALUES('Salida');