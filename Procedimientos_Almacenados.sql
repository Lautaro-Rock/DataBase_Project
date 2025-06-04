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

--Procedimiento almacenado para elminiar un producto de la tabla Productos
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