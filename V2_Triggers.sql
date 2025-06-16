USE GESTION_STOCK;

GO

CREATE TRIGGER tr_Modificar_Stock
ON MovimientoStock
AFTER INSERT
AS
BEGIN
    DECLARE @idTipoMovimiento INT
    DECLARE @idProducto INT
    DECLARE @cantidad INT

    SELECT
        @idTipoMovimiento = I.IdTipoMovimiento,
        @idProducto = I.IdProducto,
        @cantidad = I.Cantidad
    FROM inserted I;

    -- SI EL TIPO DE MOVIMIENTO ES "ENTRADA" (1)
    IF @idTipoMovimiento = 1 BEGIN
        UPDATE Productos
        SET Stock = Stock + @cantidad
        WHERE IdProducto = @idProducto
    END

    -- SI EL TIPO DE MOVIMIENTO ES "SALIDA" (2)
    IF @idTipoMovimiento = 2 BEGIN
        UPDATE Productos
        SET Stock = Stock - @cantidad
        WHERE IdProducto = @idProducto;
    END

    -- TENER EN CUENTA QUE YA ESTA VALIDADO QUE SI EL TIPO DE MOVIMIENTO ES "SALIDA", LA CANTIDAD NO PUEDE SER MENOR AL STOCK DEL PRODUCTO
END

GO

CREATE TRIGGER trg_StockMinimoAlerta_Producto
ON Productos
AFTER UPDATE
AS 
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Stock<StockMinimo) BEGIN
        RAISERROR('EL STOCK ES MENOS QUE EL MINIMO PERMITIDO, NO SE PUEDE DESCONTAR ESA CANTIDAD', 16, 1);
        ROLLBACK TRANSACTION
        RETURN;
    END
END

GO

CREATE TRIGGER trg_AlertaStockCeroNew
ON Productos
AFTER UPDATE
AS
BEGIN
    INSERT INTO AlertaStock (IdProducto, FechaAlerta, Descripcion)
    SELECT 
        i.IdProducto,
        GETDATE(),
        'EL STOCK ES IGUAL A 0, REPONER'
    FROM inserted i
    WHERE i.Stock = 0;
END

GO

CREATE TRIGGER trg_sumaStock
ON Productos
AFTER UPDATE
AS
BEGIN
    INSERT INTO AlertaStock(IdProducto,FechaAlerta,Descripcion)
    Select
    I.IdProducto,
    GETDATE(),
    'EL STOCK DEL PRODUCTO FUE REPUESTO'
    FROM inserted AS I
    INNER JOIN deleted AS D ON I.IdProducto=D.IdProducto
    Where I.Stock>D.Stock
END

GO

CREATE TRIGGER trg_restaStock
ON Productos
AFTER UPDATE
AS
BEGIN
    INSERT INTO AlertaStock(IdProducto,FechaAlerta,Descripcion)
    Select 
        I.IdProducto,
        GETDATE(),
        'EL STOCK DEL PRODUCTO SE HA REDUCIDO'
    FROM inserted AS I
    INNER JOIN deleted AS D
    ON I.IdProducto = D.IdProducto
    Where I.Stock<D.Stock
END

GO

