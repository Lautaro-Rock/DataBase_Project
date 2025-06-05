Use GESTION_STOCK;

GO

-- ==================================================================================================================================================
--
--                                                                     TABLA PRODUCTOS
--
-- ==================================================================================================================================================

-- Procedimiento almacenado para agregar un producto a la tabla "Productos"
CREATE PROCEDURE sp_AgregarProducto
    @NombreProducto NVARCHAR(100),
    @IdCategoria INT,
    @Stock INT,
    @StockMinimo INT,
    @PrecioUnitario Decimal(10,2),
    @IdProveedor INT,
    @Estado BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO Productos(NombreProducto, IdCategoria, Stock, StockMinimo, PrecioUnitario, IdProveedor, Estado)
            Values(@NombreProducto, @IdCategoria, @Stock, @StockMinimo, @PrecioUnitario, @IdProveedor, @Estado);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para editar un producto de la tabla "Productos"
CREATE PROCEDURE sp_EditarProducto
    @IdProducto INT,
    @NombreProducto NVARCHAR(100),
    @IdCategoria INT,
    @Stock INT,
    @StockMinimo INT,
    @PrecioUnitario Decimal(10,2),
    @IdProveedor INT,
    @Estado BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE Productos 
            SET NombreProducto = @NombreProducto, IdCategoria = @IdCategoria, Stock = @Stock, StockMinimo = @StockMinimo, PrecioUnitario = @PrecioUnitario, IdProveedor = @IdProveedor, Estado = @Estado 
            WHERE IdProducto = @IdProducto;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para eliminar un producto de la tabla "Productos"

CREATE PROCEDURE sp_EliminarProducto
    @IdProducto INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM Productos
            WHERE IdProducto = @IdProducto;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

--- Procedimiento almacenado para listar los productos de la tabla "Productos"
CREATE PROCEDURE sp_ListarProductos
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            SELECT * FROM Productos;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- ==================================================================================================================================================
--
--                                                                     TABLA EMPLEADOS
--
-- ==================================================================================================================================================

-- Procedimiento almacenado para agregar un empleado a la tabla "Empleados"
Create Procedure sp_AgregarEmpleado
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(100),
    @IdTipoRol INT,
    @Activo BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO Empleados(Nombre, Apellido, Telefono, Email, IdTipoRol, Activo)
            VALUES(@Nombre, @Apellido, @Telefono, @Email, @IdTipoRol, @Activo);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almanceado para editar un empleado de la tabla "Empleados"
Create Procedure sp_EditarEmpleado
    @IdEmpleado INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(100),
    @IdTipoRol INT,
    @Activo BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE Empleados
            SET Nombre = @Nombre, Apellido = @Apellido, Telefono = @Telefono, Email = @Email, IdTipoRol = @IdTipoRol, Activo = @Activo
            WHERE IdEmpleado = @IdEmpleado;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para eliminar un empleado de la tabla "Empleados"
CREATE PROCEDURE sp_EliminarEmpleado
    @IdEmpleado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM Empleados
            WHERE IdEmpleado = @IdEmpleado;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para listar los empleados de la tabla "Empleados"
CREATE PROCEDURE sp_ListarEmpleados
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            SELECT * FROM Empleados;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- ==================================================================================================================================================
--
--                                                                     TABLA PROVEEDORES
--
-- ==================================================================================================================================================

-- Procedimiento almacenado para agregar un proveedor a la tabla "Proveedores"
CREATE PROCEDURE sp_AgregarProveedor
    @nombre VARCHAR(100),
    @apellido VARCHAR(100),
    @telefono VARCHAR(20),
    @email VARCHAR(100),
    @fechaUltimaEntrega DATE,
    @activo BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO Proveedores(Nombre, Apellido, Telefono, Email, FechaUltimaEntrega, Activo)
            VALUES(@nombre, @apellido, @telefono, @email, @fechaUltimaEntrega, @activo);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para editar un proveedor de la tabla "Proveedores"
CREATE PROCEDURE sp_EditarProveedor
    @IdProveedor INT,
    @nombre VARCHAR(100),
    @apellido VARCHAR(100),
    @telefono VARCHAR(20),
    @email VARCHAR(100),
    @fechaUltimaEntrega DATE,
    @activo BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE Proveedores
            SET Nombre = @nombre, Apellido = @apellido, Telefono = @telefono, Email = @email, FechaUltimaEntrega = @fechaUltimaEntrega, Activo = @activo
            WHERE IdProveedor = @IdProveedor;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para eliminar un proveedor de la tabla "Proveedores"
CREATE PROCEDURE sp_EliminarProveedor
    @IdProveedor INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM Proveedores
            WHERE IdProveedor = @IdProveedor;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para listar los proveedores de la tabla "Proveedores"
CREATE PROCEDURE sp_ListarProveedores
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            SELECT * FROM Proveedores;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO