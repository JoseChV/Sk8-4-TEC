--Funcion para registrar un artículo en una sucursal
CREATE OR REPLACE FUNCTION registrarArticulo(
    _Codigo TEXT,
    _Nombre TEXT,
    _Descripcion TEXT,
    _Precio INT,
    _IdCategoria INT,
    _Garantia INT,
    _FechaRegistro DATE,
    _PuntosCompra INT,
    _Sucursales INT[]
)
RETURNS VOID AS $$
    DECLARE new_id int;
            i integer = 0;
    BEGIN
        INSERT INTO Articulo(codigo, nombre, descripcion, precio, idcategoria, garantia, fecharegistro, puntoscompra)
        VALUES (_Codigo, _Nombre, _Descripcion, _Precio, _IdCategoria, _Garantia, _FechaRegistro, _PuntosCompra)
        RETURNING IdArticulo INTO new_id;
        FOREACH i IN ARRAY _Sucursales
        LOOP
            INSERT INTO ArticuloSucursal(IdSucursal, IdArticulo)
            VALUES (i, new_id);
        END LOOP;
    END;
    $$
LANGUAGE plpgsql;

--Permite cambiar el estado de un artículo para que quede como vendido o se indique que está en garantia.
CREATE OR REPLACE FUNCTION estadoProducto(
    _NuevoEstado TEXT,
    _IdProducto INT
)
RETURNS VOID AS $$
    BEGIN
        UPDATE Producto
        SET estado = _NuevoEstado
        WHERE IdProducto = _IdProducto;
    END;
    $$
LANGUAGE plpgsql;

--Crear Sucursal
CREATE OR REPLACE FUNCTION crearSucursal(
    _Codigo TEXT,
    _Nombre TEXT,
    _Descripcion TEXT,
    _Estado BOOLEAN,
    _IdDireccion INT
)
RETURNS VOID AS $$
    BEGIN
        INSERT INTO Sucursal(codigo, nombre, descripcion, estado, iddireccion)
        VALUES (_Codigo, _Nombre, _Descripcion, _Estado, _IdDireccion);
    END;
    $$
LANGUAGE plpgsql;

--Modificar Sucursal
CREATE OR REPLACE FUNCTION modificarSucursal(
    _IdSucursal INT,
    _Codigo TEXT,
    _Nombre TEXT,
    _Descripcion TEXT,
    _Estado BOOLEAN,
    _IdDireccion INT
)
RETURNS VOID AS $$
    BEGIN
        UPDATE Sucursal
        SET codigo = _Codigo,
            nombre = _Nombre,
            descripcion = _Descripcion,
            estado = _Estado,
            iddireccion = _IdDireccion
        WHERE IdSucursal = _IdSucursal;
    END;
    $$
LANGUAGE plpgsql;

--Eliminar Sucursal
CREATE OR REPLACE FUNCTION eliminarSucursal(
    _IdSucursal INT
)
RETURNS VOID AS $$
    BEGIN
        DELETE FROM Sucursal
        WHERE IdSucursal = _IdSucursal;
    END;
    $$
LANGUAGE plpgsql;

--Consultar Sucursal
CREATE OR REPLACE FUNCTION consultarSucursal(
    _IdSucursal INT
)
RETURNS TABLE(
    IdSucursal INT,
    Codigo TEXT,
    Nombre TEXT,
    Descripcion TEXT,
    Estado BOOLEAN,
    IdDireccion INT
             ) AS $$
    BEGIN
        RETURN QUERY
        SELECT * FROM Sucursal S
        WHERE S.IdSucursal = _IdSucursal;
    END;
    $$
LANGUAGE plpgsql;

--Crear Empleado
CREATE OR REPLACE FUNCTION crearEmpleado(
    _Cedula TEXT,
    _Nombre TEXT,
    _Apellidos TEXT,
    _Estado BOOLEAN,
    _IdSucursal INT,
    _FechaIngreso DATE,
    _IdPuesto INT
)
RETURNS VOID AS $$
    BEGIN
        INSERT INTO Empleado(cedula, nombre, apellidos, estado, idsucursal, fechaingreso, idpuesto)
        VALUES (_Cedula, _Nombre, _Apellidos, _Estado, _IdSucursal, _FechaIngreso, _IdPuesto);
    END;
    $$
LANGUAGE plpgsql;

--Modificar Empleado
CREATE OR REPLACE FUNCTION modificarEmpleado(
    _IdEmpleado INT,
    _Cedula TEXT,
    _Nombre TEXT,
    _Apellidos TEXT,
    _Estado BOOLEAN,
    _IdSucursal INT,
    _FechaIngreso DATE,
    _IdPuesto INT
)
RETURNS VOID AS $$
    BEGIN
        UPDATE Empleado
        SET cedula = _Cedula,
            nombre = _Nombre,
            apellidos = _Apellidos,
            estado = _Estado,
            idsucursal = _IdSucursal,
            fechaingreso = _FechaIngreso,
            idpuesto = _IdPuesto
        WHERE IdEmpleado = _IdEmpleado;
    END;
    $$
LANGUAGE plpgsql;

--Eliminar Empleado
CREATE OR REPLACE FUNCTION eliminarEmpleado(
    _IdEmpleado INT
)
RETURNS VOID AS $$
    BEGIN
        DELETE FROM Empleado
        WHERE IdEmpleado = _IdEmpleado;
    END;
    $$
LANGUAGE plpgsql;

--Consultar Empleado
CREATE OR REPLACE FUNCTION consultarEmpleado(
    _IdEmpelado INT
)
RETURNS TABLE(
    IdEmpleado INT,
    Cedula TEXT,
    Nombre TEXT,
    Apellidos TEXT,
    Estado BOOLEAN,
    IdSucursal INT,
    FechaIngreso DATE,
    IdPuesto INT
             ) AS $$
    BEGIN
        RETURN QUERY
        SELECT * FROM Empleado E
        WHERE E.IdEmpleado = _IdEmpelado;
    END;
    $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION crearPromocion(
    _IdSucursal INT,
    _IdArticulo INT,
    _FechaHoraI TIMESTAMP,
    _FechaHoraF TIMESTAMP,
    _Descuento INT,
    _Puntos INT
)
RETURNS VOID AS $$
    BEGIN
        INSERT INTO Promocion(idsucursal, idarticulo, fechahorai, fechahoraf, descuento, puntos)
        VALUES (_IdSucursal, _IdArticulo, _FechaHoraI, _FechaHoraF, _Descuento, _Puntos);
    END;
$$
LANGUAGE plpgsql;

--Consultar el empleado del mes
CREATE OR REPLACE FUNCTION empleadoDelMes(
    _Mes INT,
    _Ano INT
)
RETURNS TABLE(
    CantidadVentas INT,
    IdEmpleado INT,
    Nombre TEXT,
    Apellidos TEXT
             ) AS $$
    BEGIN
        RETURN QUERY
        SELECT cast(COUNT(F.IdEmpleado) AS INTEGER) AS CantidadVentas, E.IdEmpleado, E.Nombre, E.Apellidos
        FROM Empleado E
        INNER JOIN Factura F on E.IdEmpleado = F.IdEmpleado
        WHERE (EXTRACT(YEAR FROM F.FechaHora) = _Ano) AND (EXTRACT(MONTH FROM F.FechaHora) = _Mes)
        GROUP BY E.idempleado
        LIMIT 1;
    END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION consultarEstado(
    _IdProducto INT
)
RETURNS TABLE(
    IdProducto INT,
    IdArticulo INT,
    IdSucursal INT,
    Estado TEXT
             ) AS $$
    BEGIN
        RETURN QUERY
        SELECT * FROM Producto P
        WHERE P.IdProducto = _IdProducto;
    END;
    $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION consultarPromocion(
    _FechaHora timestamp
)
RETURNS TABLE(
    IdPromocion INT,
    IdSucursal INT,
    IdArticulo INT,
    FechaHoraI TIMESTAMP,
    FechaHoraF TIMESTAMP,
    Descuento INT,
    Puntos INT
             ) AS $$
    BEGIN
        RETURN QUERY
        SELECT * FROM Promocion P
        WHERE _FechaHora BETWEEN P.FechaHoraI AND P.FechaHoraF;
    END;
    $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION compra(
    _IdCliente INT,
    _IdEmpleado INT,
    _IdSucursal INT,
    _FechaHora TIMESTAMP,
    _IdProductos INT[],
    _IdMetodosPago INT[],
    _Precios INT[]
)
RETURNS VOID AS $$
    DECLARE new_IdFactura INTEGER;
            i INTEGER = 0;
            saldoPuntos INTEGER = 0;
            puntosProducto INTEGER = 0;
    BEGIN
        SELECT Puntos into saldoPuntos FROM Cliente Cl
        WHERE Cl.IdCliente = _IdCliente;

        INSERT INTO Factura(IdEmpleado, IdCliente, IdSucursal, FechaHora) VALUES
        (_IdEmpleado, _IdCliente, _IdSucursal, _FechaHora)
        RETURNING IdFactura INTO new_IdFactura;

        FOREACH i IN ARRAY _IdProductos
        LOOP
            INSERT INTO productofactura(IdFactura, IdProducto, IdMetodoPago, Precio)
            VALUES (new_IdFactura, i, _IdMetodosPago[i], _Precios);

            SELECT A.PuntosCompra INTO puntosProducto FROM Articulo A
            INNER JOIN Producto P ON A.idarticulo = P.idarticulo
            WHERE P.idproducto = i;

            IF _IdMetodosPago[i] = 0 THEN
                saldoPuntos = saldoPuntos + puntosProducto;
            ELSE
                saldoPuntos = saldoPuntos - puntosProducto;
            END IF;

        END LOOP;

        UPDATE cliente
        SET Puntos = saldoPuntos
        WHERE IdCliente = _IdCliente;
    END;
    $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generarCSVPuntos()
RETURNS VOID AS $$
    BEGIN
        COPY Cliente(IdCliente, Puntos) TO '\tmp\persons_db.csv' DELIMITER ',' CSV HEADER;
    END;
    $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generarCSVProductos()
RETURNS VOID AS $$
    BEGIN
        COPY Producto(IdProducto, IdSucursal, IdArticulo, Estado)
        TO 'C:\Users\Jose Andres Ch\Documents\TEC\2019-2\Bases de Datos\Sk8-4-TEC\Bodega\reporte_productos.csv' DELIMITER ',' CSV HEADER;
    END;
    $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION pedirProductos(
    _IdArticulo INTEGER,
    _Cantidad INTEGER
)
RETURNS VOID AS $$
    BEGIN
        WHILE _Cantidad > 0 LOOP
            INSERT INTO ProductoEnAlmacen(IdArticulo, Estado) VALUES (_IdArticulo, TRUE);
            _Cantidad = _Cantidad - 1;
            END LOOP;
    END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION enviarProductos(
    _IdArticulo INTEGER,
    _IdSucursal INTEGER,
    _Cantidad INTEGER,
    _IdCamion INTEGER
)
RETURNS VOID AS $$
    DECLARE new_IdEntrega INT = 0;
            estadoProducto BOOLEAN = TRUE;
            new_IdProducto INT = 0;
    BEGIN
        INSERT INTO Entrega(idcamion, idsucursal, fecha, horasalida, horallegada) VALUES
        (_IdCamion,_IdSucursal, current_date, current_time, current_time + '2:00:00')
        RETURNING IdEntrega into new_IdEntrega;
        WHILE _Cantidad > 0 LOOP
            SELECT estado Into estadoProducto FROM productoenalmacen
            WHERE idarticulo = _IdArticulo AND estado = TRUE
            LIMIT 1;

            IF estadoProducto = NULL THEN
                SELECT pedirProductos(_IdArticulo, _Cantidad);
            ELSE
                INSERT INTO producto(idarticulo, idsucursal, estado) VALUES
                (_IdArticulo, _IdSucursal, 'En Stock')
                RETURNING idproducto INTO new_IdProducto;

                INSERT INTO EntregaProducto(identrega, idproducto) VALUES
                (new_IdEntrega, new_IdProducto);

                _Cantidad = _Cantidad - 1;
            END IF;

        END LOOP;

    END;
$$
LANGUAGE plpgsql;

SELECT * FROM consultarEmpleado(7);

SELECT * FROM consultarSucursal(2);

select crearEmpleado('3318381','Jose','Chavarria',TRUE, 3, '10-10-2010', 1);

select crearPromocion(1,1,'2019-10-19 10:23:54', '2019-10-25 10:23:54', 10000, 50);

select crearSucursal('uuuu','ky','f',TRUE,1);

select eliminarEmpleado(15);

select eliminarSucursal(4);

SELECT * FROM empleadoDelMes(10,2004);

select estadoProducto('Regalado', 6);

SELECT modificarEmpleado(14, '207870287', 'Jose','Chavarria', TRUE, 3, '10-10-2010',1);

select modificarSucursal(1,'KY', 'La Calle', 'guaro pls', TRUE, 1);

select registrarArticulo('T', 'Pantalon','De mezclilla',50000,1,90,'2019-10-12',50, '{1,3}');

SELECT * from consultarestado(6);

SELECT * FROM consultarpromocion('2019-10-20 15:36:38');

select generarCSVPuntos();

select generarCSVProductos();

select pedirProductos(2,100);

select enviarProductos(1,3,70);