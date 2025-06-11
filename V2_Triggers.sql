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