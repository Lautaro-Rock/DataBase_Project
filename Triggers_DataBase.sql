USE GESTION_STOCK;

GO

CREATE TRIGGER trg_ValidarPrecio_Producto
ON Productos
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE PrecioUnitario < 0)
    BEGIN
        RAISERROR('NO SE PUEDE AGREGAR PRECIOS NEGATIVOS A LOS PRODUCTOS', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;

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

CREATE TRIGGER tgr_VerificarNumero
ON EMPLEADOS
AFTER INSERT 
AS
BEGIN
    IF EXISTS(SELECT 1 FROM inserted AS I INNER JOIN Empleados AS E ON I.Telefono=E.Telefono AND  I.IdEmpleado <> E.IdEmpleado) BEGIN
        RAISERROR('ESTE TELEFONO YA EXISTE EN LA BASE DE DATOS', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END

GO

CREATE TRIGGER trg_VerificarEmail
ON EMPLEADOS
AFTER INSERT 
AS
BEGIN
    IF EXISTS(SELECT 1 FROM inserted AS I INNER JOIN EMPLEADOS AS E ON I.Email=E.Email AND I.IdEmpleado <> E.IdEmpleado) BEGIN
        RAISERROR('ESTE CORREO YA EXISTE EN LA BASE DE DATOS', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END

GO

CREATE TRIGGER trg_EmpleadoRol
ON EMPLEADOS
AFTER INSERT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM inserted AS I WHERE I.IdTipoRol!=1) BEGIN
        RAISERROR('NO SE PUEDE INGRESAR EN LA TABLA YA QUE NO TIENE EL ROL DE EMPLEADO', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END

GO