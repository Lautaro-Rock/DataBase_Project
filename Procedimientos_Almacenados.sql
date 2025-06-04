Use GESTION_STOCK;
go
--Almacenamiento procesado para agregar producto a la tabla Productos
Create Procedure sp_AgregarProducto
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
END
GO
--Almacenamiento procesado para editar producto en la tabla Productos
Create Procedure sp_EditarProducto
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
UPDATE Productos SET NombreProducto=@NombreProducto, IdCategoria=@IdCategoria, Stock=@Stock,StockMinimo=@StockMinimo,PrecioUnitario=@PrecioUnitario,IdProveedor=@IdProveedor,Estado=@Estado WHERE IdProducto=@IdProducto;
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
THROW;
END CATCH
END





