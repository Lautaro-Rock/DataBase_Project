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
    @StockMinimo INT,
    @PrecioUnitario Decimal(10,2),
    @IdProveedor INT,
    @IdEmpleado INT
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

            -- VERIFICAR EL STOCK MINIMO
            IF @StockMinimo < 1 BEGIN
                RAISERROR('EL STOCK MINIMO INGRESADO NO ES VALIDO', 16, 1);
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

            -- VERIFICAR QUE EL EMPLEADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleado INT
            DECLARE @auxRolEmpleado INT
            DECLARE @auxActivo INT
            SET @auxIdEmpleado = NULL;

            SELECT
                @auxIdEmpleado = IdEmpleado,
                @auxRolEmpleado = IdTipoRol,
                @auxActivo = Activo
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxIdEmpleado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivo != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL INSERT
            INSERT INTO Productos(NombreProducto, IdCategoria, Stock, StockMinimo, PrecioUnitario, IdProveedor, Estado)
            VALUES(@NombreProducto, @IdCategoria, 0, @StockMinimo, @PrecioUnitario, @IdProveedor, 1);
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
    @StockMinimo INT,
    @PrecioUnitario Decimal(10,2),
    @IdProveedor INT,
    @IdEmpleado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
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

            -- VERIFICAR QUE EL EMPLEADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleado INT
            DECLARE @auxRolEmpleado INT
            DECLARE @auxActivo INT
            SET @auxIdEmpleado = NULL;

            SELECT
                @auxIdEmpleado = IdEmpleado,
                @auxRolEmpleado = IdTipoRol,
                @auxActivo = Activo
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxIdEmpleado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivo != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
            UPDATE Productos 
            SET
                StockMinimo = @StockMinimo,
                PrecioUnitario = @PrecioUnitario,
                IdProveedor = @IdProveedor
            WHERE IdProducto = @IdProducto;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para eliminar de manera logica un producto de la tabla "Productos"
CREATE PROCEDURE sp_Baja_Logica_Producto
    @IdProducto INT,
    @IdEmpleado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL PRODUCTO EXISTA
            DECLARE @auxIdProducto INT
            SET @auxIdProducto = NULL;

            SELECT
                @auxIdProducto = IdProducto
            FROM Productos
            WHERE @IdProducto = IdProducto;

            IF @auxIdProducto IS NULL BEGIN
                RAISERROR('EL PRODUCTO INGRESADO NO EXISTE EN EL SISSTEMA', 16, 1);
            END

            -- VERIFICAR QUE EL ESTADO SEA (1)
            DECLARE @auxEstado INT

            SELECT
                @auxEstado = Estado
            FROM Productos
            WHERE @IdProducto = IdProducto;

            IF @auxEstado = 0 BEGIN
                RAISERROR('EL PRODUCTO YA SE ENCUENTRA INACTIVO', 16, 1);
            END

            -- VERIFICAR QUE EL EMPLEADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleado INT
            DECLARE @auxRolEmpleado INT
            DECLARE @auxActivo INT
            SET @auxIdEmpleado = NULL;

            SELECT
                @auxIdEmpleado = IdEmpleado,
                @auxRolEmpleado = IdTipoRol,
                @auxActivo = Activo
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxIdEmpleado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivo != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
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

-- Procedimiento almacenado para agregar de manera logica un producto de la tabla "Productos"
CREATE PROCEDURE sp_Alta_Logica_Producto
    @IdProducto INT,
    @IdEmpleado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL PRODUCTO EXISTA
            DECLARE @auxIdProducto INT
            SET @auxIdProducto = NULL;

            SELECT
                @auxIdProducto = IdProducto
            FROM Productos
            WHERE @IdProducto = IdProducto;

            IF @auxIdProducto IS NULL BEGIN
                RAISERROR('EL PRODUCTO INGRESADO NO EXISTE EN EL SISSTEMA', 16, 1);
            END

            -- VERIFICAR QUE EL ESTADO SEA (0)
            DECLARE @auxEstado INT

            SELECT
                @auxEstado = Estado
            FROM Productos
            WHERE @IdProducto = IdProducto;

            IF @auxEstado = 1 BEGIN
                RAISERROR('EL PRODUCTO YA SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- VERIFICAR QUE EL EMPLEADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleado INT
            DECLARE @auxRolEmpleado INT
            DECLARE @auxActivo INT
            SET @auxIdEmpleado = NULL;

            SELECT
                @auxIdEmpleado = IdEmpleado,
                @auxRolEmpleado = IdTipoRol,
                @auxActivo = Activo
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxIdEmpleado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivo != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
            UPDATE Productos
            SET Estado = 1
            WHERE IdProducto = @IdProducto;
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
CREATE PROCEDURE sp_Agregar_Empleado
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(100),
    @IdTipoRol INT,
    @IdEmpleado INT
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

            -- VERIFICAR QUE EL EMPLEADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleado INT
            DECLARE @auxRolEmpleado INT
            DECLARE @auxActivo INT
            SET @auxIdEmpleado = NULL;

            SELECT
                @auxIdEmpleado = IdEmpleado,
                @auxRolEmpleado = IdTipoRol,
                @auxActivo = Activo
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxIdEmpleado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivo != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
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
    @IdTipoRol INT,
    @IdEmpleadoEncargado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL EMPLEADO EXISTA
            DECLARE @auxIdEmpleado INT
            SET @auxIdEmpleado = NULL

            SELECT
                @auxIdEmpleado = IdEmpleado
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxIdEmpleado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE', 16, 1);
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

            -- VERIFICAR QUE EL EMPLEADO ENCARGADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleadoEncargado INT
            DECLARE @auxRolEmpleadoEncargado INT
            DECLARE @auxActivo INT
            SET @auxIdEmpleadoEncargado = NULL;

            SELECT
                @auxIdEmpleadoEncargado = IdEmpleado,
                @auxRolEmpleadoEncargado = IdTipoRol,
                @auxActivo = Activo
            FROM Empleados
            WHERE @IdEmpleadoEncargado = IdEmpleado;

            IF @auxIdEmpleadoEncargado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleadoEncargado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivo != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
            UPDATE Empleados
            SET IdTipoRol = @IdTipoRol
            WHERE IdEmpleado = @IdEmpleado;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para eliminar de manera logica, un empleado de la tabla "Empleados"
CREATE PROCEDURE sp_BajaLogica_Empleado
    @IdEmpleado INT,
    @IdEmpleadoEncargado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL EMPLEADO A DAR DE BAJA EXISTA Y NO ESTE INACTIVO
            DECLARE @auxEmpleado INT
            DECLARE @auxActivo INT
            SET @auxEmpleado = NULL

            SELECT
                @auxEmpleado = IdEmpleado,
                @auxActivo = Activo
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxEmpleado IS NULL BEGIN
                RAISERROR('EL EMPLEADO A DAR DE BAJA NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxActivo = 0 BEGIN
                RAISERROR('EL EMPLEADO A DAR DE BAJA YA SE ENCUENTRA INACTIVO', 16, 1);
            END

            -- VERIFICAR QUE EL EMPLEADO ENCARGADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleadoEncargado INT
            DECLARE @auxRolEmpleadoEncargado INT
            DECLARE @auxActivoEncargado INT
            SET @auxIdEmpleadoEncargado = NULL;

            SELECT
                @auxIdEmpleadoEncargado = IdEmpleado,
                @auxRolEmpleadoEncargado = IdTipoRol,
                @auxActivoEncargado = Activo
            FROM Empleados
            WHERE @IdEmpleadoEncargado = IdEmpleado;

            IF @auxIdEmpleadoEncargado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleadoEncargado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivoEncargado != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
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

-- Procedimiento almacenado para agregar de manera logica, un empleado de la tabla "Empleados"
CREATE PROCEDURE sp_Alta_Logica_Empleado
    @IdEmpleado INT,
    @IdEmpleadoEncargado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL EMPLEADO A DAR DE BAJA EXISTA Y NO ESTE ACTIVO
            DECLARE @auxEmpleado INT
            DECLARE @auxActivo INT
            SET @auxEmpleado = NULL

            SELECT
                @auxEmpleado = IdEmpleado,
                @auxActivo = Activo
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxEmpleado IS NULL BEGIN
                RAISERROR('EL EMPLEADO A DAR DE BAJA NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxActivo = 1 BEGIN
                RAISERROR('EL EMPLEADO A DAR DE BAJA YA SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- VERIFICAR QUE EL EMPLEADO ENCARGADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleadoEncargado INT
            DECLARE @auxRolEmpleadoEncargado INT
            DECLARE @auxActivoEncargado INT
            SET @auxIdEmpleadoEncargado = NULL;

            SELECT
                @auxIdEmpleadoEncargado = IdEmpleado,
                @auxRolEmpleadoEncargado = IdTipoRol,
                @auxActivoEncargado = Activo
            FROM Empleados
            WHERE @IdEmpleadoEncargado = IdEmpleado;

            IF @auxIdEmpleadoEncargado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleadoEncargado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivoEncargado != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
            UPDATE Empleados
            SET Activo = 1
            WHERE IdEmpleado = @IdEmpleado;
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
CREATE PROCEDURE sp_Agregar_Proveedor
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(100),
    @IdEmpleadoEncargado INT
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

            -- VERIFICAR QUE EL EMPLEADO ENCARGADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleadoEncargado INT
            DECLARE @auxRolEmpleadoEncargado INT
            DECLARE @auxActivoEncargado INT
            SET @auxIdEmpleadoEncargado = NULL;

            SELECT
                @auxIdEmpleadoEncargado = IdEmpleado,
                @auxRolEmpleadoEncargado = IdTipoRol,
                @auxActivoEncargado = Activo
            FROM Empleados
            WHERE @IdEmpleadoEncargado = IdEmpleado;

            IF @auxIdEmpleadoEncargado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleadoEncargado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivoEncargado != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
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
    @fechaUltimaEntrega DATE,
    @IdEmpleadoEncargado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL PROVEEDOR EXISTA
            DECLARE @auxProveedor INT
            SET @auxProveedor = NULL;

            SELECT
                @auxProveedor = IdProveedor
            FROM Proveedores
            WHERE @IdProveedor = IdProveedor;

            IF @auxProveedor IS NULL BEGIN
                RAISERROR('EL PROVEEDOR INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            -- VERIFICAR QUE EL EMPLEADO ENCARGADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleadoEncargado INT
            DECLARE @auxRolEmpleadoEncargado INT
            DECLARE @auxActivoEncargado INT
            SET @auxIdEmpleadoEncargado = NULL;

            SELECT
                @auxIdEmpleadoEncargado = IdEmpleado,
                @auxRolEmpleadoEncargado = IdTipoRol,
                @auxActivoEncargado = Activo
            FROM Empleados
            WHERE @IdEmpleadoEncargado = IdEmpleado;

            IF @auxIdEmpleadoEncargado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleadoEncargado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivoEncargado != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END
            
            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
            UPDATE Proveedores
            SET FechaUltimaEntrega = @fechaUltimaEntrega
            WHERE IdProveedor = @IdProveedor;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

-- Procedimiento almacenado para eliminar de forma logica, un proveedor de la tabla "Proveedores"
CREATE PROCEDURE sp_Baja_Logica_Proveedor
    @IdProveedor INT,
    @IdEmpleadoEncargado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL PROVEEDOR EXISTA Y NO ESTE INACTIVO
            DECLARE @auxIdProveedor INT
            DECLARE @auxActivoProveedor INT
            SET @auxIdProveedor = NULL

            SELECT
                @auxIdProveedor = IdProveedor,
                @auxActivoProveedor = Activo
            FROM Proveedores
            WHERE @IdProveedor = IdProveedor;

            IF @auxIdProveedor IS NULL BEGIN
                RAISERROR('EL PROVEEDOR INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxActivoProveedor = 0 BEGIN
                RAISERROR('EL PROVEEDOR INGRESADO YA SE ENCUENTRA INACTIVO', 16, 1);
            END

            -- VERIFICAR QUE EL EMPLEADO ENCARGADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleadoEncargado INT
            DECLARE @auxRolEmpleadoEncargado INT
            DECLARE @auxActivoEncargado INT
            SET @auxIdEmpleadoEncargado = NULL;

            SELECT
                @auxIdEmpleadoEncargado = IdEmpleado,
                @auxRolEmpleadoEncargado = IdTipoRol,
                @auxActivoEncargado = Activo
            FROM Empleados
            WHERE @IdEmpleadoEncargado = IdEmpleado;

            IF @auxIdEmpleadoEncargado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleadoEncargado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivoEncargado != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END
            
            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
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

-- Procedimiento almacenado para agregar de forma logica, un proveedor de la tabla "Proveedores"
CREATE PROCEDURE sp_Alta_Logica_Proveedor
    @IdProveedor INT,
    @IdEmpleadoEncargado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL PROVEEDOR EXISTA Y NO ESTE ACTIVO
            DECLARE @auxIdProveedor INT
            DECLARE @auxActivoProveedor INT
            SET @auxIdProveedor = NULL

            SELECT
                @auxIdProveedor = IdProveedor,
                @auxActivoProveedor = Activo
            FROM Proveedores
            WHERE @IdProveedor = IdProveedor;

            IF @auxIdProveedor IS NULL BEGIN
                RAISERROR('EL PROVEEDOR INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxActivoProveedor = 1 BEGIN
                RAISERROR('EL PROVEEDOR INGRESADO YA SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- VERIFICAR QUE EL EMPLEADO ENCARGADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleadoEncargado INT
            DECLARE @auxRolEmpleadoEncargado INT
            DECLARE @auxActivoEncargado INT
            SET @auxIdEmpleadoEncargado = NULL;

            SELECT
                @auxIdEmpleadoEncargado = IdEmpleado,
                @auxRolEmpleadoEncargado = IdTipoRol,
                @auxActivoEncargado = Activo
            FROM Empleados
            WHERE @IdEmpleadoEncargado = IdEmpleado;

            IF @auxIdEmpleadoEncargado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleadoEncargado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivoEncargado != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END
            
            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
            UPDATE Proveedores
            SET Activo = 1
            WHERE IdProveedor = @IdProveedor;
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

            -- VERIFICAR QUE SE PUEDA REALIZAR LA OPERACION DE SALIDA / LA ENTRADA SIEMPRE ES VALIDA
            DECLARE @stock INT

            SELECT
                @stock = Stock
            FROM Productos
            WHERE @IdProducto = IdProducto

            IF @Cantidad < 1 BEGIN
                RAISERROR('LA CANTIDAD NO PUEDE SER MENOR A 1 O NULA', 16, 1);
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
-- COMO TAMBIEN QUE RESTE O SUME CANTIDAD AL STOCK

GO

-- Procedimiento almacenado para agregar la descripcion de un movimiento de la tabla "MovimientoStock"
CREATE PROCEDURE sp_Modificar_MovimientoStock
    @IdMovimiento INT,
    @Descripcion NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL MOVIMIENTO EXISTA
            DECLARE @auxIdMovimiento INT
            SET @auxIdMovimiento = NULL;

            SELECT
                @auxIdMovimiento = IdMovimiento
            FROM MovimientoStock
            WHERE IdMovimiento = @IdMovimiento;

            IF @auxIdMovimiento IS NULL BEGIN
                RAISERROR('EL PRODUCTO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
            UPDATE MovimientoStock
            SET Descripcion = @Descripcion
            WHERE IdMovimiento = @IdMovimiento;
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
--                                                                     TABLA CATEGORIAS
--
-- ==================================================================================================================================================

-- Procedimiento almacenado para registrar una categoria a la tabla "Categorias"
CREATE PROCEDURE sp_Agregar_Categoria
    @NombreCategoria NVARCHAR(100),
    @IdEmpleado INT
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

            -- VERIFICAR QUE EL EMPLEADO ENCARGADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleadoEncargado INT
            DECLARE @auxRolEmpleadoEncargado INT
            DECLARE @auxActivoEncargado INT
            SET @auxIdEmpleadoEncargado = NULL;

            SELECT
                @auxIdEmpleadoEncargado = IdEmpleado,
                @auxRolEmpleadoEncargado = IdTipoRol,
                @auxActivoEncargado = Activo
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxIdEmpleadoEncargado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleadoEncargado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivoEncargado != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
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

-- Procedimiento almacenado para elimibar una categoria de la tabla "Categorias"
CREATE PROCEDURE sp_Eliminar_Categoria
    @nombreCategoria NVARCHAR(100),
    @IdEmpleado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE EL EMPLEADO ENCARGADO EXISTA, SEA ADMINISTRADOR (ID = 2) Y ESTE ACTIVO
            DECLARE @auxIdEmpleadoEncargado INT
            DECLARE @auxRolEmpleadoEncargado INT
            DECLARE @auxActivoEncargado INT
            SET @auxIdEmpleadoEncargado = NULL;

            SELECT
                @auxIdEmpleadoEncargado = IdEmpleado,
                @auxRolEmpleadoEncargado = IdTipoRol,
                @auxActivoEncargado = Activo
            FROM Empleados
            WHERE @IdEmpleado = IdEmpleado;

            IF @auxIdEmpleadoEncargado IS NULL BEGIN
                RAISERROR('EL EMPLEADO INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            IF @auxRolEmpleadoEncargado != 2 BEGIN
                RAISERROR('SOLO LOS ADMINISTRADORES PUEDEN REALIZAR ESTA ACCION', 16, 1);
            END

            IF @auxActivoEncargado != 1 BEGIN
                RAISERROR('EL EMPLEADO QUE SE ENCARGA DE LA OPERACION NO SE ENCUENTRA ACTIVO', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL DELETE
            DELETE
            FROM Categoria
            WHERE NombreCategoria = @nombreCategoria;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END


GO

-- ==================================================================================================================================================
--
--                                                                     TABLA ALERTAS
--
-- ==================================================================================================================================================

-- Procedimiento almacenado para escribir la descripcion de una alerta en la tabla "AlertaStock"
CREATE PROCEDURE sp_Agregar_Descripcion_Alerta
    @idAlerta INT,
    @descripcion NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- VERIFICAR QUE LA ALERTA EXISTA
            DECLARE @auxIdAlerta INT
            SET @auxIdAlerta = NULL;

            SELECT
                @auxIdAlerta = IdAlerta
            FROM AlertaStock
            WHERE @idAlerta = IdAlerta;

            IF @auxIdAlerta IS NULL BEGIN
                RAISERROR('EL ID DE ALERTA INGRESADO NO EXISTE EN EL SISTEMA', 16, 1);
            END

            -- SI LOS DATOS INGRESADOS SON CORRECTOS, SE REALIZA EL UPDATE
            UPDATE AlertaStock
            SET Descripcion = @descripcion
            WHERE IdAlerta = @idAlerta;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;