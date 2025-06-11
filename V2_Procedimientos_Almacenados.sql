Use GESTION_STOCK;

GO

-- ==================================================================================================================================================
--
--                                                                     TABLA PRODUCTOS
--
-- ==================================================================================================================================================

-- Procedimiento almacenado para agregar un producto a la tabla "Productos"
CREATE PROCEDURE sp_Agregar_Producto
    @NombreProducto NVARCHAR(100),
    @IdCategoria INT,
    @Stock INT,
    @StockMinimo INT,
    @PrecioUnitario Decimal(10,2),
    @IdProveedor INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL NOMBRE DE PRODUCTO NO EXISTA EN LA TABLA
            DECLARE @auxNombreProducto NVARCHAR(100)
            SET @auxNombreProducto = NULL;

            SELECT
                @auxNombreProducto = NombreProducto
            FROM Productos
            WHERE @NombreProducto = NombreProducto;

            IF @auxNombreProducto IS NOT NULL BEGIN
                RAISERROR('EL PRODUCTO INGRESADO YA EXISTE EN EL SISTEMA', 16, 1);
            END

            -- VERIFICAR QUE LA CATEGORIA EXISTA
            DECLARE @auxIdCategoria INT
            SET @auxIdCategoria = NULL;

            SELECT
                @auxIdCategoria = IdCategoria
            FROM Categoria
            WHERE @IdCategoria = IdCategoria;

            IF @auxIdCategoria IS NULL BEGIN
                RAISERROR('LA CATEGORIA INGRESADA NO EXISTE EN EL SISTEMA', 16, 1);
            END

            -- VERIFICAR EL STOCK
            IF @Stock < 1 BEGIN
                RAISERROR('EL STOCK INGRESADO NO ES VALIDO', 16, 1);
            END

            -- VERIFICAR EL STOCK MINIMO
            IF @StockMinimo < 1 BEGIN
                RAISERROR('EL STOCK MINIMO INGRESADO NO ES VALIDO', 16, 1);
            END

            -- VERIFICAR QUE EL STOCK SEA MAYOR AL STOCK MINIMO
            IF @stock < @stockMinimo BEGIN
                RAISERROR('EL STOCK NO PUEDE SER MENOR AL STOCK MINIMO', 16, 1);
            END

            -- VERIFICAR EL PRECIO UNITARIO
            IF @PrecioUnitario <= 0 BEGIN
                RAISERROR('EL PRECIO UNITARIO INGRESADO NO ES VALIDO', 16, 1);
            END

            -- VERIFICAR SI EL PROVEEDOR EXISTE
            DECLARE @auxIdProveedor INT
            SET @auxIdProveedor = NULL;

            SELECT
                @auxIdProveedor = IdProveedor
            FROM Proveedores
            WHERE @IdProveedor = IdProveedor;

            IF @auxIdProveedor IS NULL BEGIN
                RAISERROR('EL PROVEEDOR INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL INSERT
            INSERT INTO Productos(NombreProducto, IdCategoria, Stock, StockMinimo, PrecioUnitario, IdProveedor, Estado)
            VALUES(@NombreProducto, @IdCategoria, @Stock, @StockMinimo, @PrecioUnitario, @IdProveedor, 1);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH
END;

GO

-- Procedimiento almacenado para editar un producto de la tabla "Productos"
CREATE PROCEDURE sp_Editar_Producto
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
CREATE PROCEDURE sp_Eliminar_Producto
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
CREATE PROCEDURE sp_BajaLogica_Producto
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
CREATE PROCEDURE sp_Listar_Productos
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
CREATE PROCEDURE sp_Agregar_Empleado
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(100),
    @IdTipoRol INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL NUMERO DE TELEFONO NO EXISTA
            DECLARE @auxTelefono NVARCHAR(20)
            SET @auxTelefono = '0';

            IF @Telefono IS NOT NULL BEGIN
                SELECT
                    @auxTelefono = Telefono
                FROM Empleados
                WHERE @Telefono = Telefono;
            END
            
                -- SI TELEFONO ES NULL POR PARAMETRO POR OMISION, ESTA SENTENCIA NO SE VA A EJCUTAR, YA QUE NO ENTRA AL IF ANTERIOR
            IF @auxTelefono != '0' BEGIN
                RAISERROR('EL TELEFONO INGRESADO YA EXISTE EN EL SISTEMA', 16, 1);
            END  

            -- VERIFICAR QUE EL EMAIL NO EXISTA
            DECLARE @auxEmail NVARCHAR(100)
            SET @auxEmail = NULL;

            SELECT
                @auxEmail = Email
            FROM Empleados
            WHERE @Email = Email;

            IF @auxEmail IS NOT NULL BEGIN
                RAISERROR('EL EMAIL INGRESADO YA EXISTE EN EL SISTEMA', 16, 1);
            END

            -- VERIFICAR QUE EL TIPO DE ROL EXISTA
            DECLARE @auxIdRol INT
            SET @auxIdRol = NULL

            SELECT
                @auxIdRol = IdTipoRol
            FROM TipoRol
            WHERE @IdTipoRol = IdTipoRol;

            IF @auxIdRol IS NULL BEGIN
                RAISERROR('EL ROL INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END 

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL INSERT
            INSERT INTO Empleados(Nombre, Apellido, Telefono, Email, IdTipoRol, Activo)
            VALUES(@Nombre, @Apellido, @Telefono, @Email, @IdTipoRol, 1);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH
END;

GO

-- Procedimiento almanceado para editar un empleado de la tabla "Empleados"
Create Procedure sp_Editar_Empleado
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
CREATE PROCEDURE sp_Eliminar_Empleado
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
CREATE PROCEDURE sp_BajaLogica_Empleado
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
CREATE PROCEDURE sp_Listar_Empleados
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
ALTER PROCEDURE sp_Agregar_Proveedor
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL TELEFONO NO EXISTA
            DECLARE @auxTelefono NVARCHAR(20)
            SET @auxTelefono = '0';

            IF @Telefono IS NOT NULL BEGIN
                SELECT
                    @auxTelefono = Telefono
                FROM Empleados
                WHERE @Telefono = Telefono;
            END
            
                -- SI TELEFONO ES NULL, ESTA SENTENCIA NO SE VA A EJCUTAR, YA QUE NO ENTRA AL IF ANTERIOR
            IF @auxTelefono != '0' BEGIN
                RAISERROR('EL TELEFONO INGRESADO YA EXISTE EN EL SISTEMA', 16, 1);
            END

           -- VERIFICAR QUE EL EMAIL NO EXISTA
            DECLARE @auxEmail NVARCHAR(100)
            SET @auxEmail = NULL;

            SELECT
                @auxEmail = Email
            FROM Proveedores
            WHERE @Email = Email;

            IF @auxEmail IS NOT NULL BEGIN
                RAISERROR('EL EMAIL INGRESADO YA EXISTE EN EL SISTEMA', 16, 1);
            END

            -- NO SE VALIDA LA FECHA YA QUE CUANDO SE REGISTRA UN PROVEEDOR EN EL SISTEMA, ES PORQUE ES LA PRIMERA VEZ QUE ENTREGO UN PEDIDO
            -- POR LO TANTO SE ASINGA LA FECHA DE LA ULTIMA ENTREGA AUTOMATICAMENTE EN EL INSTANTE QUE SE REGISTRA EL PROVEEDOR

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL INSERT
            INSERT INTO Proveedores(Nombre, Apellido, Telefono, Email, FechaUltimaEntrega, Activo)
            VALUES(@Nombre, @Apellido, @Telefono, @Email, GETDATE(), 1);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH
END;

GO

-- Procedimiento almacenado para editar un proveedor de la tabla "Proveedores"
CREATE PROCEDURE sp_Editar_Proveedor
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
CREATE PROCEDURE sp_Eliminar_Proveedor
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
CREATE PROCEDURE sp_BajaLogica_Proveedor
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
CREATE PROCEDURE sp_Listar_Proveedores
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
CREATE PROCEDURE sp_Agregar_MovimientoStock
    @IdProducto INT,
    @IdEmpleado INT,
    @IdTipoMovimiento INT,
    @Descripcion NVARCHAR(255),
    @Cantidad INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            -- VERIFICAR QUE EL PRODUCTO EXISTA
            DECLARE @auxIdProducto INT
            SET @auxIdProducto = NULL;

            SELECT
                @auxIdProducto = IdProducto
            FROM Productos
            WHERE @IdProducto = IdProducto;

            IF @auxIdProducto IS NULL BEGIN
                RAISERROR('EL PRODUCTO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            -- VERIFICAR QUE EL EMPLEADO EXISTA
            DECLARE @auxIdEmpleado INT
            SET @auxIdEmpleado = NULL;

            SELECT
                @auxIdEmpleado = IdEmpleado
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxIdEmpleado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            -- VERIFICAR QUE EL TIPO DE MOVIMIENTO EXISTA
            DECLARE @auxIdTipoMovimiento INT
            SET @auxIdTipoMovimiento = NULL;

            SELECT
                @auxIdTipoMovimiento = IdTipoMovimiento
            FROM TipoMovimiento
            WHERE @IdTipoMovimiento = IdTipoMovimiento;

            IF @auxIdTipoMovimiento IS NULL BEGIN
                RAISERROR('EL TIPO DE MOVIMIENTO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            -- VERIFICAR QUE LA CANTIDAD NO SEA MENOR A CERO Y MAYOR O IGUAL AL STOCK
            DECLARE @stock INT

            SELECT
                @stock = Stock
            FROM Productos
            WHERE @IdProducto = IdProducto

            IF @Cantidad < 1 BEGIN
                RAISERROR('LA CANTIDAD NO PUEDE SER MENOR A 1', 16, 1);
            END

            IF @Cantidad > @stock BEGIN
                RAISERROR('LA CANTIDAD NO PUEDE SER MAYOR AL STOCK DISPONIBLE', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL INSERT
            INSERT INTO MovimientoStock(IdProducto, IdEmpleado, Fecha, IdTipoMovimiento, Descripcion, Cantidad)
            VALUES(@IdProducto, @IdEmpleado, GETDATE(), @IdTipoMovimiento, @Descripcion, @Cantidad)
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH
END;

-- EN EL TRIGGER SE VAN A RESOLVER TANTO EL CASO DE GENERAR ALERTAS
-- COMO TAMBIEN QUE RESTE CANTIDAD AL STOCK

GO

-- Procedimiento almacenado para editar un movimiento de la tabla "MovimientoStock"
CREATE PROCEDURE sp_Modificar_MovimientoStock
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
CREATE PROCEDURE sp_Eliminar_MovimientoStock
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
CREATE PROCEDURE sp_Listar_MovimientoStock
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
CREATE PROCEDURE sp_Eliminar_AlertaStock
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
CREATE PROCEDURE sp_Listar_AlertasStock
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
CREATE PROCEDURE sp_Agregar_Categoria
    @NombreCategoria NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL NOMBRE DE CATEGORIA NO EXISTA
            DECLARE @nombre NVARCHAR(100)
            SET @nombre = NULL

            SELECT
                @nombre = NombreCategoria
            FROM Categoria
            WHERE @NombreCategoria = NombreCategoria

            IF @nombre IS NOT NULL BEGIN
                RAISERROR('YA EXISTE EL NOMBRE DE CATEGORIA INGRESADO', 16, 1);
            END
            
            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL INSERT
            INSERT INTO Categoria (NombreCategoria)
            VALUES (@NombreCategoria);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH
END;

GO

-- Procedimiento almacenado para editar una categoria de la tabla "Categorias"
CREATE PROCEDURE sp_Modificar_Categoria
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
CREATE PROCEDURE sp_Eliminar_Categoria
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
CREATE PROCEDURE sp_Listar_Categorias
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