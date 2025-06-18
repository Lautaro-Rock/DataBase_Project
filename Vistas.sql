USE GESTION_STOCK;
GO

-- Vista a Stock actual
-- Muestra el stock actual de todos los productos activos, junto con la categoría, el proveedor y un indicador del estado del stock.
-- Esto permitirá al los empleados visualizar rápidamente qué productos están en stock y cuáles necesitan ser repuestos.

CREATE VIEW vw_StockActual AS
SELECT 
    P.IdProducto,
    P.NombreProducto,
    C.NombreCategoria,
    PR.Nombre AS NombreProveedor,
    PR.Apellido AS ApellidoProveedor,
    P.Stock,
    P.StockMinimo,
    CASE 
        WHEN P.Stock <= P.StockMinimo THEN '¡Reponer!' 
        ELSE 'OK' 
    END AS EstadoStock
FROM Productos P
JOIN Categoria C ON P.IdCategoria = C.IdCategoria
JOIN Proveedores PR ON P.IdProveedor = PR.IdProveedor
WHERE P.Estado = 1;
GO

-- Vista a Historial de movimientos
-- Muestra un historial de todos los movimientos de stock, incluyendo el producto, tipo de movimiento, cantidad y empleado que lo realizó.

CREATE VIEW vw_HistorialMovimientos AS
SELECT 
    M.IdMovimiento,
    M.Fecha,
    P.NombreProducto,
    E.Nombre + ' ' + E.Apellido AS Empleado,
    TM.Descripcion AS TipoMovimiento,
    M.Cantidad,
    M.Descripcion
FROM MovimientoStock M
JOIN Productos P ON M.IdProducto = P.IdProducto
JOIN Empleados E ON M.IdEmpleado = E.IdEmpleado
JOIN TipoMovimiento TM ON M.IdTipoMovimiento = TM.IdTipoMovimiento;
GO

-- Vista a Productos con stock bajo
-- Lista los productos cuyo stock actual es menor o igual al stock mínimo definido, junto con su proveedor y categoría.
-- Permite identificar rápidamente qué productos necesitan ser repuestos.
CREATE VIEW vw_ProductosConStockBajo AS
SELECT 
    P.IdProducto,
    P.NombreProducto,
    P.Stock,
    P.StockMinimo,
    C.NombreCategoria,
    PR.Nombre + ' ' + PR.Apellido AS Proveedor
FROM Productos P
JOIN Categoria C ON P.IdCategoria = C.IdCategoria
JOIN Proveedores PR ON P.IdProveedor = PR.IdProveedor
WHERE P.Stock <= P.StockMinimo AND P.Estado = 1;
GO

-- Vista a alertas generadas
-- Muestra todas las alertas de stock generadas, incluyendo el producto, la categoría, el proveedor y la fecha de alerta.
-- Permite realizar un seguimiento del historial de alertas de stock.

CREATE VIEW vw_AlertasGeneradas AS
SELECT 
    A.IdAlerta,
    A.FechaAlerta,
    P.NombreProducto,
    C.NombreCategoria,
    PR.Nombre + ' ' + PR.Apellido AS Proveedor,
    A.Descripcion
FROM AlertaStock A
JOIN Productos P ON A.IdProducto = P.IdProducto
JOIN Categoria C ON P.IdCategoria = C.IdCategoria
JOIN Proveedores PR ON P.IdProveedor = PR.IdProveedor;
GO

-- Vista a empleados con movimientos
-- Muestra los empleados que realizaron movimientos de stock, indicando el total de movimientos que cada uno registró. 
--Permite conocer la participación de cada empleado en los movimientos de stock.

CREATE VIEW vw_EmpleadosConMovimientos AS
SELECT 
    E.IdEmpleado,
    E.Nombre + ' ' + E.Apellido AS Empleado,
    COUNT(M.IdMovimiento) AS TotalMovimientos
FROM Empleados E
JOIN MovimientoStock M ON E.IdEmpleado = M.IdEmpleado
GROUP BY E.IdEmpleado, E.Nombre, E.Apellido;
GO

--Vista a empleados activos
--Muestra informacion resumida de los empleados que se encuentran activos
CREATE VIEW vw_EmpleadosActivos AS
SELECT
E.Nombre,
E.Apellido,
E.Email,
E.Telefono,
E.IdTipoRol,
E.Activo
FROM Empleados AS E
WHERE Activo=1;
GO

--Vistas de proveedores activos
--Muestra informacion resumiad de los provedores que se encuentran activos
CREATE VIEW vw_ProveedoresActivos AS
SELECT
P.Nombre,
P.Apellido,
P.Email,
P.Telefono,
p.Activo
FROM Proveedores AS P
WHERE Activo=1;
GO