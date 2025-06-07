USE GESTION_STOCK;
GO
--EJECUTAR PARA AGREGAR LOS ROLES Y LOS TIPOS DE MOVIMIENTOS
INSERT TipoRol(Descripcion)
VALUES('Empleado');
GO
INSERT TipoRol(Descripcion)
VALUES('Administrador');
GO
INSERT TipoMovimiento(Descripcion)
VALUES('Entrada');
GO
INSERT TipoMovimiento(Descripcion)
VALUES('Salida');

