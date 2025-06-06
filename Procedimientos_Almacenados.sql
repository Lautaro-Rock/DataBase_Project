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
            INSERT INTO Productos (NombreProducto, IdCategoria, Stock, StockMinimo, PrecioUnitario, IdProveedor, Estado)
            Values (@NombreProducto, @IdCategoria, @Stock, @StockMinimo, @PrecioUnitario, @IdProveedor, @Estado);
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

--Procedimiento almacenado para eliminar de manera logica un producto de la tabla "Productos"
CREATE PROCEDURE sp_BajaLogicaProducto
    @IdProducto INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE Productos
            SET Estado = 0
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
            SELECT * 
            FROM Productos;
    END TRY
    BEGIN CATCH
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
            INSERT INTO Empleados (Nombre, Apellido, Telefono, Email, IdTipoRol, Activo)
            VALUES (@Nombre, @Apellido, @Telefono, @Email, @IdTipoRol, @Activo);
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
        COMMIT TRANSACTION;
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
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

--Procedimiento almacenado para eliminar de manera logica, un empleado de la tabla "Empleados"
CREATE PROCEDURE sp_BajaLogicaEmpleado
    @IdEmpleado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE Empleados
            SET Activo = 0
            WHERE IdEmpleado = @IdEmpleado;
        COMMIT TRANSACTION;
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
        SELECT *
        FROM Empleados;
    END TRY
    BEGIN CATCH
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
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @telefono NVARCHAR(20),
    @email NVARCHAR(100),
    @fechaUltimaEntrega DATE,
    @activo BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO Proveedores (Nombre, Apellido, Telefono, Email, FechaUltimaEntrega, Activo)
            VALUES (@nombre, @apellido, @telefono, @email, @fechaUltimaEntrega, @activo);
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
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @telefono NVARCHAR(20),
    @email NVARCHAR(100),
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

--Procedimiento almacenado para eliminar de forma logica, un proveedor de la tabla "Proveedores"
CREATE PROCEDURE sp_BajaLogicaProveedor
    @IdProveedor INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE Proveedores
            SET Activo = 0
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
            SELECT *
            FROM Proveedores;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;

GO

-- ==================================================================================================================================================
--
--                                                                     TABLA MOVIMIENTOSTOCK
--
-- ==================================================================================================================================================

-- Procedimiento almacenado para registrar un movimientos de la tabla "MovimientoStock"
CREATE PROCEDURE sp_RegistrarMovimientoStock
    @IdTipoMovimiento INT,
    @IdProducto INT,
    @Cantidad INT,
    @IdEmpleado INT,
    @Descripcion NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO MovimientoStock (IdTipoMovimiento, IdProducto, Cantidad, Fecha, IdEmpleado, Descripcion) 
            VALUES (@IdTipoMovimiento, @IdProducto, @Cantidad, GETDATE(), @IdEmpleado, @Descripcion);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para editar un movimiento de la tabla "MovimientoStock"
CREATE PROCEDURE sp_ModificarMovimientoStock
    @IdMovimiento INT,
    @IdTipoMovimiento INT,
    @IdProducto INT,
    @Cantidad INT,
    @IdEmpleado INT,
    @Descripcion NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE MovimientoStock
            SET IdTipoMovimiento = @IdTipoMovimiento, IdProducto = @IdProducto, Cantidad = @Cantidad, IdEmpleado = @IdEmpleado, Descripcion = @Descripcion
            WHERE IdMovimiento = @IdMovimiento;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento Almacenado para eliminar un movimiento de la tabla "MovimientoStock"
CREATE PROCEDURE sp_EliminarMovimientoStock
    @IdMovimiento INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM MovimientoStock
            WHERE IdMovimiento = @IdMovimiento;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para listar los movimientos de la tabla "MovimientoStock"
CREATE PROCEDURE sp_ListarMovimientoStock
AS
BEGIN
    BEGIN TRY
        SELECT *
        FROM MovimientoStock;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;

GO

-- ==================================================================================================================================================
--
--                                                                     TABLA ALERTASTOCK
--
-- ==================================================================================================================================================

-- Procedimiento almacenado para eliminar una alerta de la tabla "AlertaStock"
CREATE PROCEDURE sp_EliminarAlertaStock
    @IdAlerta INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM AlertaStock
            WHERE IdAlerta = @IdAlerta;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para listar las alertas de la tabla "AlertaStock"
CREATE PROCEDURE sp_ListarAlertasStock
AS
BEGIN
    BEGIN TRY
        SELECT *
        FROM AlertaStock;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;

GO

-- ==================================================================================================================================================
--
--                                                                     TABLA CATEGORIAS
--
-- ==================================================================================================================================================

-- Procedimiento almacenado para registrar una categoria a la tabla "Categorias"
CREATE PROCEDURE sp_AgregarCategoria
    @NombreCategoria NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO Categoria (NombreCategoria)
            VALUES (@NombreCategoria);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para editar una categoria de la tabla "Categorias"
CREATE PROCEDURE sp_ModificarCategoria
    @IdCategoria INT,
    @nombre NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE Categoria
            SET NombreCategoria = @nombre
            WHERE IdCategoria = @IdCategoria;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para eliminar una categoria de la tabla "Categorias"
CREATE PROCEDURE sp_EliminarCategoria
    @IdCategoria INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM Categoria
            WHERE IdCategoria = @IdCategoria;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

GO

-- Procedimiento almacenado para listar categorias
CREATE PROCEDURE sp_ListarCategorias
AS
BEGIN
    BEGIN TRY
        SELECT *
        FROM Categoria;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;

GO