USE Base_Sucursal;

DELIMITER //
CREATE FUNCTION ContarProductos(_IdArticulo INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE TotalProductos INT DEFAULT 0;
    
    SELECT COUNT(P.IdProducto) INTO TotalProductos
    FROM Producto P
    WHERE P.IdArticulo = _IdArticulo AND (P.Estado = "En Stock" OR P.Estado = "Con Garantia");
    
    RETURN TotalProductos;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION CantidadPts(_IdProducto INT, _IdMetodoPago INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE _IdArticulo INT DEFAULT 0;
	DECLARE PtsArticulo FLOAT DEFAULT 0.00;
	DECLARE PtsPromocion FLOAT DEFAULT 0.00;
   
    SELECT PR.IdArticulo INTO _IdArticulo 
    FROM Producto PR
    WHERE PR.IdProducto = _IdProducto
    LIMIT 1;
    
    SELECT A.PuntosCompra INTO PtsArticulo 
    FROM Articulo A
    WHERE A.IdArticulo = _IdArticulo
    LIMIT 1;
    
    SELECT P.Puntos INTO PtsPromocion 
    FROM Promocion P
    INNER JOIN Articulo A ON A.IdArticulo = P.IdArticulo
    WHERE P.IdArticulo = _IdArticulo
    LIMIT 1;
    
	 IF _IdMetodoPago = 5 THEN
		RETURN PtsArticulo * 10;
	ELSE
		RETURN PtsArticulo + PtsPromocion;
	END IF;
	
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RegistroArticulo(
	_Codigo VARCHAR(40),
    _Nombre VARCHAR(60),
    _Descripcion VARCHAR(120),
    _Precio INT,
    _IdCategoria INT,
    _Garantia VARCHAR(40),
    _FechaRegistro DATE,
    _CantidadProductos INT
)
BEGIN
	DECLARE _IdArticulo INT DEFAULT 0;
    DECLARE _Estado VARCHAR(50);
    DECLARE i INT;
    SET i = 0;
    
	INSERT INTO Articulo(Codigo, Nombre, Descripcion, Precio, IdCategoria, Garantia, FechaRegistro, PuntosCompra)
	VALUES 
	(_Codigo, _Nombre, _Descripcion, _Precio, _IdCategoria, _Garantia, _FechaRegistro, _Precio / 100);
    
    SET _IdArticulo = LAST_INSERT_ID();
    
    IF _Garantia = "Si" THEN
		SET _Estado = "Con Garantia";
	ELSE
		SET _Estado = "En Stock";
	END IF;
    
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
    _Apellido VARCHAR(60),
    _FechaIngreso DATE,
    _IdPuesto INT
)
BEGIN
	INSERT INTO Empleado(Cedula, Nombre, Apellido, FechaIngreso, IdPuesto)
	VALUES 
	(_Cedula, _Nombre, _Apellido, _FechaIngreso, _IdPuesto);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModificarEmpleado(
	_IdEmpleado INT,
    _Cedula VARCHAR(40),
    _Nombre VARCHAR(60),
    _Apellido VARCHAR(60),
    _FechaIngreso DATE,
    _IdPuesto INT
)
BEGIN
		UPDATE Empleado
        SET Cedula = _Cedula,
            Nombre = _Nombre,
            Apellido = _Apellido,
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
    _FechaI DATE,
    _FechaF DATE,
    _HoraI TIME,
    _HoraF TIME,
    _Descuento INT
)
BEGIN
	INSERT INTO Promocion(IdArticulo, FechaI, FechaF, HoraI, HoraF, Descuento, Puntos)
	VALUES 
	(_IdArticulo, _FechaI, _FechaF, _HoraI, _HoraF, _Descuento, _Descuento / 100);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EmpleadoMes(
	_Fecha DATE
)
BEGIN
	SELECT COUNT(F.IdFactura) AS EmpleadoDelMes, E.IdEmpleado, E.Nombre, E.Apellido
    FROM Factura F
    INNER JOIN Empleado E ON E.IdEmpleado = F.IdEmpleado
    WHERE EXTRACT(YEAR FROM F.Fecha) = EXTRACT(YEAR FROM _Fecha) AND EXTRACT(MONTH FROM F.Fecha) = EXTRACT(MONTH FROM _Fecha)
    GROUP BY E.IdEmpleado
    ORDER BY EmpleadoDelMes DESC
    LIMIT 1;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ConsultarGarantia(
	_IdArticulo INT
)
BEGIN
	SELECT Codigo, Nombre, Descripcion, Precio, Garantia 
    FROM Articulo A
	WHERE A.IdArticulo = _IdArticulo;
END //
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE ConsultarPromocion()
BEGIN
	SELECT A.IdArticulo, A.Nombre, A.Precio, P.FechaI, P.FechaF, P.HoraI, P.HoraF, P.Descuento, P.Puntos 
    FROM Promocion P
    INNER JOIN Articulo A ON A.IdArticulo = P.IdArticulo
    ORDER BY P.FechaF DESC,
			 P.HoraF DESC;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertarCliente(
    _Nombre VARCHAR(60),
    _Apellido VARCHAR(60),
    _Cedula VARCHAR(40),
    _Telefono VARCHAR(40),
    _Puntos FLOAT
)
BEGIN
	INSERT INTO Cliente(Nombre, Apellido, Cedula, Telefono, Puntos)
	VALUES 
	(_Nombre, _Apellido, _Cedula, _Telefono, _Puntos);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AñadirPtsCliente(
    _IdCliente INT,
    _Puntos FLOAT
)
BEGIN
	UPDATE Cliente
	SET Puntos = Puntos + _Puntos
	WHERE IdCliente = _IdCliente;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE QuitarPtsCliente(
    _IdCliente INT,
    _Puntos FLOAT
)
BEGIN
	UPDATE Cliente
	SET Puntos = Puntos - _Puntos
	WHERE IdCliente = _IdCliente;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CrearFactura(
    _IdEmpleado INT,
    _IdCliente INT,
    _Fecha DATE,
    _Hora TIME, 
    _IdProducto INT,
    _IdMetodoPago INT
)
BEGIN
	DECLARE _IdArticulo INT DEFAULT 0;
	DECLARE _IdFactura INT DEFAULT 0;
    DECLARE _Precio INT DEFAULT 0;
    
    INSERT INTO Factura(IdEmpleado, IdCliente, Fecha, Hora)
	VALUES 
	(_IdEmpleado, _IdCliente, _Fecha, _Hora);
    
    SET _IdFactura = LAST_INSERT_ID();
    
    SELECT PR.IdArticulo INTO _IdArticulo 
    FROM Producto PR
    WHERE PR.IdProducto = _IdProducto;
    
    SELECT A.Precio INTO _Precio 
    FROM Articulo A
    WHERE A.IdArticulo = _IdArticulo;
    
    INSERT INTO ArticuloFactura(IdFactura, IdProducto, IdMetodoPago, Precio)
	VALUES 
    (_IdFactura, _IdProducto, _IdMetodoPago, _Precio);
    
    CALL EgresoArticulo(_IdProducto, "Vendido");
    
    IF _IdMetodoPago = 5 THEN
		CALL QuitarPtsCliente(_IdCliente, CantidadPts(_IdProducto, _IdMetodoPago));
	ELSE
		CALL AñadirPtsCliente(_IdCliente, CantidadPts(_IdProducto, _IdMetodoPago));
	END IF;
    
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerarCSVPuntos()
BEGIN 
	SELECT IdCliente, Nombre, Apellido, Cedula, Puntos
	FROM Cliente
	INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/PuntosCSV.csv'
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n';
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerarCSVProductos()
BEGIN 
	SELECT COUNT(P.IdProducto) AS Productos, C.Nombre, A.Nombre, A.Precio, A.PuntosCompra, P.Estado
	FROM Producto P
    INNER JOIN Articulo A ON A.IdArticulo = P.IdArticulo
    INNER JOIN Categoria C ON C.IdCategoria = A.IdCategoria
    GROUP BY A.Nombre, P.Estado, C.Nombre
    ORDER BY Productos DESC
	INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/ProductosCSV.csv'
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n';
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerarCSVCompras()
BEGIN 
	SELECT COUNT(P.IdProducto) AS Compras, C.Nombre, A.Nombre, A.Precio
	FROM Producto P
    INNER JOIN Articulo A ON A.IdArticulo = P.IdArticulo
    INNER JOIN Categoria C ON C.IdCategoria = A.IdCategoria
    WHERE P.Estado = "Vendido"
    GROUP BY A.Nombre, C.Nombre
    ORDER BY Compras DESC
	INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/ComprasCSV.csv'
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n';
END //
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE CierreCaja()
BEGIN
	DECLARE _CantidadArticulos INT DEFAULT 0;
	DECLARE i INT;
    SET i = 1;
    
    SELECT COUNT(A.IdArticulo) INTO _CantidadArticulos
    FROM Articulo A;
    
	ContarProductos: WHILE i < (_CantidadArticulos + 1) DO
    
    	IF ContarProductos(i) < 5 THEN
			SET i = i + 1;
		END IF;
        
	END WHILE ContarProductos;
   
END //
DELIMITER ;


CALL RegistroArticulo("1233124", "Royal", "Camiseta con el logo de Royal centrado", 15000, 1, "Si", "2019-08-11", 200);
CALL RegistroArticulo("1233124", "SK", "Camiseta con el logo de SK centrado", 10000, 1, "Si", "2019-09-22", 100);
CALL RegistroArticulo("1233124", "Royal", "Pantalon con el logo de Royal centrado", 20000, 2, "Si", "2019-08-11", 3);
 
CALL EgresoArticulo(195, "Vendido");
CALL EgresoArticulo(195, "En Stock");

CALL InsertarEmpleado("804450323", "Joseju", "FernandezJu", "2018-09-09", 1);
CALL InsertarEmpleado("701430353", "Alberto","Fernandez","2019-09-09", 3);
CALL InsertarEmpleado("804256323", "Ramiro","Ramirez","2019-11-07", 3);
CALL InsertarEmpleado("104254243", "Jonathan","Joestar","2019-04-23", 4);
CALL InsertarEmpleado("192302803", "Jotaro","Kujo","2019-08-26", 4);
CALL InsertarEmpleado("731283218", "Giorno","Giovana","2019-11-30", 3);
CALL InsertarEmpleado("403218338", "Josue","Hernandez","2019-02-28", 4);
CALL InsertarEmpleado("532817098", "Angelo","Segura","2019-06-14", 4);
CALL InsertarEmpleado("323172338", "Maria","Blanco","2019-08-17", 3);

CALL ModificarEmpleado(1,"690938098", "Jose", "Fernandez", "2019-09-09", 2);

CALL EliminarEmpleado(2);

CALL ConsultarEmpleado(1);

CALL InsertarPromocion(1, "2018-08-10", "2019-09-24", "01:00:00", "23:00:00", 10000);
CALL InsertarPromocion(1, "2018-08-10", "2019-11-24", "07:00:00", "22:00:00", 10000);
CALL InsertarPromocion(1, "2018-08-10", "2019-10-23", "13:00:00", "24:00:00", 10000);
CALL InsertarPromocion(1, "2018-08-10", "2019-10-25", "07:00:00", "15:00:00", 10000);
CALL InsertarPromocion(1, "2018-08-10", "2019-10-25", "07:00:00", "24:00:00", 10000);
CALL InsertarPromocion(1, "2018-08-10", "2019-10-25", "07:00:00", "22:00:00", 10000);

CALL ConsultarGarantia(1);

CALL ConsultarPromocion();

CALL InsertarCliente("Camilo", "Bosquini", "423131233", "83123322", 0.00);

CALL CrearFactura(1, 1, "2019-12-12", "12:00:00", 200, 1);
CALL CrearFactura(1, 1, "2019-12-12", "12:00:00", 199, 1);
CALL CrearFactura(1, 1, "2019-12-12", "12:00:00", 198, 1);
CALL CrearFactura(2, 1, "2019-11-12", "12:00:00", 197, 1);
CALL CrearFactura(2, 1, "2019-11-12", "12:00:00", 196, 1);
CALL CrearFactura(2, 1, "2019-12-12", "12:00:00", 194, 1);
CALL CrearFactura(2, 1, "2019-12-12", "12:00:00", 193, 1);
CALL CrearFactura(2, 1, "2019-12-12", "12:00:00", 192, 5);

CALL EmpleadoMes("2019-11-12");

CALL GenerarCSVPuntos();

CALL GenerarCSVProductos();

CALL GenerarCSVCompras();