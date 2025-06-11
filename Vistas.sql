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
