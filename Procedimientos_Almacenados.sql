Use GESTION_STOCK;
GO
--Procedimiento almacenado para agregar producto a la tabla Productos
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
            INSERT INTO Productos(NombreProducto,IdCategoria,Stock,StockMinimo,PrecioUnitario,IdProveedor,Estado)
            Values(@NombreProducto,@IdCategoria,@Stock,@StockMinimo,@PrecioUnitario,@IdProveedor,@Estado);
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

--Procedimiento almacenado para editar producto en la tabla Productos
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
            SET NombreProducto=@NombreProducto, IdCategoria=@IdCategoria, Stock=@Stock,StockMinimo=@StockMinimo,PrecioUnitario=@PrecioUnitario,IdProveedor=@IdProveedor,Estado=@Estado 
            WHERE IdProducto=@IdProducto;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

--Procedimiento almacenado para eliminiar un producto de la tabla Productos
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

---Procedimiento almacenado para listar los productos de la tabla Productos
CREATE PROCEDURE sp_ListarProductos
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            SELECT * FROM Productos
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
--EMPLEADOS
--Procedimiento almacenado para agregar empleados a la tabla Empleados
Create Procedure sp_AgregarEmpleados
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
INSERT INTO Empleados(Nombre,Apellido,Telefono,Email,IdTipoRol,Activo)
VALUES(@Nombre,@Apellido,@Telefono,@Email,@IdTipoRol,@Activo);
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK
THROW;
END CATCH
END
GO
--Procedimiento almanceado para editar empleados de la tabla empleados
Create Procedure sp_EditarEmpleados
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
UPDATE Empleados SET Nombre=@Nombre, Apellido=@Apellido,Telefono=@Telefono,Email=@Email,IdTipoRol=@IdTipoRol,Activo=@Activo WHERE @IdEmpleado=@IdEmpleado;
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK
THROW
END CATCH
END
GO
