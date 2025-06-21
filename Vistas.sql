USE GESTION_STOCK;

GO

-- Vista a Stock actual
--      Muestra el stock actual de todos los productos activos, junto con la categoria, el proveedor y un indicador del estado del stock.
--      Esto permitie a los empleados visualizar rapidamente que productos estan en stock y cuales necesitan ser repuestos.

CREATE VIEW vw_Productos AS
SELECT 
    P.IdProducto,
    P.NombreProducto,
    C.NombreCategoria,
    P.Stock,
    P.StockMinimo,
    PR.Nombre AS NombreProveedor,
    PR.Apellido AS ApellidoProveedor,
    CASE 
        WHEN P.Stock <= P.StockMinimo THEN '¡Reponer!' 
        ELSE 'OK' 
    END AS 'Estado del Stock'
FROM Productos P
JOIN Categoria C ON P.IdCategoria = C.IdCategoria
JOIN Proveedores PR ON P.IdProveedor = PR.IdProveedor
WHERE P.Estado = 1;

GO

-- Vista de productos activos
--      Esta vista muestra todos los productos que se encuentran actualmente activos. 
--      Incluye informacion  relacionada con la categoria y el proveedor correspondiente, permitiendo obtener una vision completa de los productos disponibles para operaciones dentro del sistema.
--      El filtro se realiza sobre el campo Estado = 1.

CREATE VIEW vw_ProductosActivos
AS
SELECT 
    P.IdProducto,
    P.NombreProducto,
    P.Stock,
    P.StockMinimo,
    P.PrecioUnitario,
    P.Estado,
    C.NombreCategoria,
    PR.Nombre AS NombreProveedor,
    PR.Apellido AS ApellidoProveedor
FROM Productos P
INNER JOIN Categoria C ON P.IdCategoria = C.IdCategoria
INNER JOIN Proveedores PR ON P.IdProveedor = PR.IdProveedor
WHERE P.Estado = 1;

GO

-- Vista de productos inactivos
--      Esta vista muestra todos los productos que han sido marcados como inactivos en el sistema.
--      Es util para llevar un control de productos dados de baja de manera logica.
--      El filtro se realiza sobre el campo Estado = 0.

CREATE VIEW vw_ProductosInactivos
AS
SELECT 
    P.IdProducto,
    P.NombreProducto,
    P.Stock,
    P.StockMinimo,
    P.PrecioUnitario,
    P.Estado,
    C.NombreCategoria,
    PR.Nombre AS NombreProveedor,
    PR.Apellido AS ApellidoProveedor
FROM Productos P
INNER JOIN Categoria C ON P.IdCategoria = C.IdCategoria
INNER JOIN Proveedores PR ON P.IdProveedor = PR.IdProveedor
WHERE P.Estado = 0;

GO

-- Vista a Historial de movimientos
--      Muestra un historial de todos los movimientos de stock, incluyendo el producto, tipo de movimiento, cantidad y empleado que lo realizo.

CREATE VIEW vw_HistorialMovimientos AS
SELECT 
    M.IdMovimiento,
    TM.Descripcion AS TipoMovimiento,
    P.NombreProducto,
    M.Cantidad,
    M.Descripcion,
    E.Apellido + ', ' + E.Nombre AS Empleado,
    M.Fecha
FROM MovimientoStock M
JOIN Productos P ON M.IdProducto = P.IdProducto
JOIN Empleados E ON M.IdEmpleado = E.IdEmpleado
JOIN TipoMovimiento TM ON M.IdTipoMovimiento = TM.IdTipoMovimiento;

GO

-- Vista a Productos con stock bajo
--      Lista los productos cuyo stock actual es menor o igual al stock minimo definido, junto con su proveedor y categoria.
--      Permite identificar rapidamente que productos necesitan ser repuestos.
CREATE VIEW vw_ProductosConStockBajo AS
SELECT 
    P.IdProducto,
    P.NombreProducto,
    P.Stock,
    P.StockMinimo,
    C.NombreCategoria,
    PR.Apellido + ', ' + PR.Nombre AS Proveedor
FROM Productos P
JOIN Categoria C ON P.IdCategoria = C.IdCategoria
JOIN Proveedores PR ON P.IdProveedor = PR.IdProveedor
WHERE P.Stock <= P.StockMinimo AND P.Estado = 1;

GO

-- Vista a alertas generadas
--      Muestra todas las alertas de stock generadas, incluyendo el producto, la categoria, el proveedor y la fecha de alerta.
--      Permite realizar un seguimiento del historial de alertas de stock.

CREATE VIEW vw_AlertasGeneradas AS
SELECT 
    A.IdAlerta,
    P.NombreProducto,
    C.NombreCategoria,
    A.Descripcion,
    PR.Apellido + ', ' + PR.Nombre AS Proveedor,
    A.FechaAlerta
FROM AlertaStock A
JOIN Productos P ON A.IdProducto = P.IdProducto
JOIN Categoria C ON P.IdCategoria = C.IdCategoria
JOIN Proveedores PR ON P.IdProveedor = PR.IdProveedor;

GO

-- Vista a empleados con movimientos
--      Muestra los empleados que realizaron movimientos de stock, indicando el total de movimientos que cada uno registro. 
--      Permite conocer la participacion de cada empleado en los movimientos de stock.

CREATE VIEW vw_EmpleadosConMovimientos AS
SELECT 
    E.IdEmpleado,
    E.Apellido + ', ' + E.Nombre AS Empleado,
    COUNT(M.IdMovimiento) AS 'Total de Movimientos'
FROM Empleados E
JOIN MovimientoStock M ON E.IdEmpleado = M.IdEmpleado
GROUP BY E.IdEmpleado, E.Nombre, E.Apellido;

GO

-- Vista a empleados activos
--      Muestra informacion resumida de los empleados que se encuentran activos

CREATE VIEW vw_EmpleadosActivos AS
SELECT
    E.Apellido + ', ' + E.Nombre AS Empleado,
    E.Email,
    E.Telefono,
    TR.Descripcion AS 'Rol'
FROM Empleados AS E
INNER JOIN TipoRol TR ON E.IdTipoRol = TR.IdTipoRol
WHERE E.Activo = 1;

GO

-- Vistas de proveedores activos
--      Muestra informacion resumiad de los provedores que se encuentran activos
CREATE VIEW vw_ProveedoresActivos AS
SELECT
    P.Apellido + ', ' + P.Nombre AS Proveedor,
    P.Email,
    P.Telefono,
    P.FechaUltimaEntrega
FROM Proveedores AS P
WHERE P.Activo = 1;

GO