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

-- ==================================================================================================================================================
--
--                                                                     TABLA PRODUCTOS
--
-- ==================================================================================================================================================


-- Procedimiento almacenado para registrar movimientos de la tabla "MovimientoStock"

CREATE PROCEDURE sp_RegistrarMovimientoStock
    @IdProducto INT,
    @IdTipoMovimiento INT,
    @Cantidad INT,
    @IdEmpleado INT,
    @Descripcion NVARCHAR(255) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @StockActual INT, @StockNuevo INT, @StockMinimo INT;

        SELECT @StockActual = Stock, @StockMinimo = StockMinimo
        FROM Productos
        WHERE IdProducto = @IdProducto;

        IF @IdTipoMovimiento = 1
            SET @StockNuevo = @StockActual + @Cantidad;
        ELSE IF @IdTipoMovimiento = 2
            SET @StockNuevo = @StockActual - @Cantidad;
        ELSE
            THROW 50001, 'Tipo de movimiento inválido.', 1;

        INSERT INTO MovimientoStock (IdProducto, IdEmpleado, Fecha, IdTipoMovimiento, Descripcion, Cantidad)
        VALUES (@IdProducto, @IdEmpleado, GETDATE(), @IdTipoMovimiento, @Descripcion, @Cantidad);

        UPDATE Productos SET Stock = @StockNuevo WHERE IdProducto = @IdProducto;

        IF @StockNuevo < @StockMinimo
        BEGIN
            INSERT INTO AlertaStock (IdProducto, FechaAlerta, Descripcion)
            VALUES (@IdProducto, GETDATE(), 'El stock actual está por debajo del mínimo.');
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

-- Procedimiento almacenado para listar los movimientos del stock de la tabla "ListarMovimientosStock"

CREATE PROCEDURE sp_ListarMovimientosStock
AS
BEGIN
    SELECT MS.IdMovimiento, MS.Fecha, MS.Cantidad, MS.Descripcion,
           P.NombreProducto, E.Nombre + ' ' + E.Apellido AS Empleado,
           TM.Descripcion AS TipoMovimiento
    FROM MovimientoStock MS
    INNER JOIN Productos P ON MS.IdProducto = P.IdProducto
    INNER JOIN Empleados E ON MS.IdEmpleado = E.IdEmpleado
    INNER JOIN TipoMovimiento TM ON MS.IdTipoMovimiento = TM.IdTipoMovimiento
    ORDER BY MS.Fecha DESC;
END;

-- ==================================================================================================================================================
--
--                                                                     TABLA PRODUCTOS
--
-- ==================================================================================================================================================


-- AlertaStock

-- Procedimiento almacenado para listar las alertas de stock 
--
CREATE PROCEDURE sp_ListarAlertasStock
AS
BEGIN
    SELECT A.IdAlerta, A.FechaAlerta, A.Descripcion,
           P.NombreProducto, P.Stock, P.StockMinimo
    FROM AlertaStock A
    INNER JOIN Productos P ON A.IdProducto = P.IdProducto
    ORDER BY A.FechaAlerta DESC;
END;

-- Procedimiento almacenado para eliminar las alertas de stock

CREATE PROCEDURE sp_EliminarAlertaStock
    @IdAlerta INT
AS
BEGIN
    DELETE FROM AlertaStock WHERE IdAlerta = @IdAlerta;
END;