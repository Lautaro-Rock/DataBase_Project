USE GESTION_STOCK;

GO

CREATE TRIGGER tr_Modificar_Stock
ON MovimientoStock
AFTER INSERT
AS
BEGIN
    DECLARE @idTipoMovimiento TINYINT
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

CREATE TRIGGER tr_Generar_Alerta
ON Productos
AFTER UPDATE
AS
BEGIN
    DECLARE @idProducto INT
    DECLARE @stock INT
    DECLARE @stockMinimo INT

    SELECT
        @idProducto = i.IdProducto,
        @stock = i.Stock
    FROM inserted i;

    SELECT
        @stockMinimo = StockMinimo
    FROM Productos;

    IF @stock <= @stockMinimo BEGIN
        -- EN CASO DE QUE EL STOCK SEA MENOR O IGUAL AL STOCK MINIMO, AGREGO LA ALERTA
        -- SE CONSIDERA EL = YA QUE SE PEUDE VENDER UNA CANTIDAD DE PRODUCTO IGUAL AL STOCK MINIMO
        INSERT INTO AlertaStock(IdProducto, FechaAlerta)
        VALUES(@idProducto, GETDATE());
    END
END;

GO

CREATE TRIGGER tr_Producto_Sin_Stock
ON Productos
AFTER UPDATE
AS
BEGIN
    DECLARE @idProducto INT
    DECLARE @stock INT

    SELECT
        @idProducto = i.IdProducto,
        @stock = i.Stock
    FROM inserted i;
    
    IF @stock = 0 BEGIN
        -- BAJA LOGICA DEL PRODUCTO
        UPDATE Productos
        SET Estado = 0
        WHERE IdProducto = @idProducto
    END
END