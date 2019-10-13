USE Base_Sucursal;

DELIMITER //
CREATE PROCEDURE RegistroArticulo(
	_Codigo VARCHAR(40),
    _Nombre VARCHAR(60),
    _Descripcion VARCHAR(120),
    _Precio INT,
    _IdCategoria INT,
    _Garantia VARCHAR(40),
    _FechaRegistro DATE,
    _CantidadProductos INT,
    _Estado VARCHAR(60)
)
BEGIN
	DECLARE _IdArticulo INT DEFAULT 0;
    DECLARE i INT;
    SET i = 0;
	INSERT INTO Articulo(Codigo, Nombre, Descripcion, Precio, IdCategoria, Garantia, FechaRegistro, PuntosCompra)
	VALUES 
	(_Codigo, _Nombre, _Descripcion, _Precio, _IdCategoria, _Garantia, _FechaRegistro, _Precio / 100);
    SET _IdArticulo = LAST_INSERT_ID();
    InsertarProductos: WHILE i < _CantidadProductos DO
		INSERT INTO Producto(IdArticulo, Estado)
        VALUES
        (_IdArticulo, _Estado);
        SET i = i + 1;
        END WHILE InsertarProductos;
END // 
DELIMITER ;


DELIMITER //
CREATE PROCEDURE EgresoArticulo(
    _IdProducto INT,
    _NuevoEstado VARCHAR(50)
)
BEGIN
	UPDATE Producto
	SET estado = _NuevoEstado
	WHERE IdProducto = _IdProducto;
END // 
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertarEmpleado(
    _Cedula VARCHAR(40),
    _Nombre VARCHAR(60),
    _Estado VARCHAR(60),
    _FechaIngreso DATE,
    _IdPuesto INT
)
BEGIN
	INSERT INTO Empleado(codigo, Nombre, Estado, FechaIngreso, IdPuesto)
	VALUES 
	(_Codigo, _Nombre, _Estado, _FechaIngreso, _IdPuesto);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModificarEmpleado(
	_IdEmpleado INT,
    _Cedula VARCHAR(40),
    _Nombre VARCHAR(60),
    _Estado BOOLEAN,
    _FechaIngreso DATE,
    _IdPuesto INT
)
BEGIN
		UPDATE Empleado
        SET Cedula = _Cedula,
            Nombre = _Nombre,
            Estado = _Estado,
            FechaIngreso = _FechaIngreso,
            IdPuesto = _IdPuesto
        WHERE IdEmpleado = _IdEmpleado;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarEmpleado(
	_IdEmpleado INT
)
BEGIN
	DELETE FROM Empleado
	WHERE IdEmpleado = _IdEmpleado;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ConsultarEmpleado(
	_IdEmpleado INT
)
BEGIN
	SELECT * FROM Empleado
	WHERE IdEmpleado = _IdEmpleado;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertarPromocion(
    _IdArticulo INT,
    _FechaHoraI DATE,
    _FechaHoraF DATE,
    _Descuento INT,
    _Puntos INT
)
BEGIN
	INSERT INTO Promocion(IdArticulo, FechaHoraI, FechaHoraF, Descuento, Puntos)
	VALUES 
	(_IdArticulo, _FechaHoraI, _FechaHoraF, _Descuento, _Puntos);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EmpleadoMes(
	_Fecha DATE
)
BEGIN
	SELECT COUNT (F.IdFactura) AS EmpleadoDelMes, E.IdEmpleado, E.Nombre, E.Apellido
    FROM Factura F
    INNER JOIN Empleado E ON E.IdEmpleado = F.IdEmpleado
    GROUP BY E.IdEmpleado
    ORDER BY EmpleadoDelMes
    LIMIT 1;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ConsultarGarantia(
	_IdArticulo INT
)
BEGIN
	SELECT Codigo, Nombre, Descripcion, Precio FROM Articulo A
	WHERE A.IdArticulo = _IdArticulo AND A.Garantia = "Si";
END //
DELIMITER ;

-- CALL RegistroArticulo("12345567", "Royal", "Camiseta Edicion Royal", 15000, 1, "Si","2019-06-15", 15, 2000);