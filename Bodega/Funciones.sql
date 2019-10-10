--Funcion para registrar un artículo en una sucursal
CREATE FUNCTION registrarArticulo(
    _Codigo TEXT,
    _Nombre TEXT,
    _Descripcion TEXT,
    _Precio INT,
    _IdCategoria INT,
    _Garantia INT,
    _FechaRegistro DATE,
    _PuntosCompra INT,
    _Sucursal INT[]
)
RETURNS VOID AS $$
    DECLARE new_id int;
            i integer = 0;
    BEGIN
        INSERT INTO Articulo(codigo, nombre, descripcion, precio, idcategoria, garantia, fecharegistro, puntoscompra)
        VALUES (_Codigo, _Nombre, _Descripcion, _Precio, _IdCategoria, _Garantia, _FechaRegistro, _PuntosCompra)
        RETURNING IdArticulo INTO new_id;
        FOREACH i IN ARRAY _Sucursal
        LOOP
            INSERT INTO ArticuloSucursal(IdSucursal, IdArticulo)
            VALUES (i, new_id);
        END LOOP;
    END;
    $$
LANGUAGE plpgsql;

--Permite cambiar el estado de un artículo para que quede como vendido o se indique que está en garantia.
CREATE FUNCTION estadoProducto(
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
CREATE FUNCTION crearSucursal(
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
CREATE FUNCTION modificarSucursal(
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
CREATE FUNCTION eliminarSucursal(
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
CREATE FUNCTION consultarSucursal(
    _IdSucursal INT
)
RETURNS VOID AS $$
    BEGIN
        SELECT * FROM Sucursal
        WHERE IdSucursal = _IdSucursal;
    END;
    $$
LANGUAGE plpgsql;

--Crear Empleado
CREATE FUNCTION crearEmpleado(
    _Cedula TEXT,
    _Nombre TEXT,
    _Estado BOOLEAN,
    _IdSucursal INT,
    _FechaIngreso DATE,
    _IdPuesto INT
)
RETURNS VOID AS $$
    BEGIN
        INSERT INTO Empleado(cedula, nombre, estado, idsucursal, fechaingreso, idpuesto)
        VALUES (_Cedula, _Nombre, _Estado, _IdSucursal, _FechaIngreso, _IdPuesto);
    END;
    $$
LANGUAGE plpgsql;

--Modificar Empleado
CREATE FUNCTION modificarEmpleado(
    _IdEmpleado INT,
    _Cedula TEXT,
    _Nombre TEXT,
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
            estado = _Estado,
            idsucursal = _IdSucursal,
            fechaingreso = _FechaIngreso,
            idpuesto = _IdPuesto
        WHERE IdEmpleado = _IdEmpleado;
    END;
    $$
LANGUAGE plpgsql;

--Eliminar Empleado
CREATE FUNCTION eliminarEmpleado(
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
CREATE FUNCTION consultarEmpleado(
    _IdEmpelado INT
)
RETURNS VOID AS $$
    BEGIN
        SELECT * FROM Empleado
        WHERE IdEmpleado = _IdEmpelado;
    END;
    $$
LANGUAGE plpgsql;

CREATE FUNCTION crearPromocion(
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
CREATE FUNCTION empleadoDelMes(
    _Mes INT,
    _Ano INT
)
RETURNS Empleado AS $$
    BEGIN
        SELECT COUNT(F.IdEmpleado) AS CantidadVentas, *
        FROM Empleado E
        INNER JOIN Factura F on E.IdEmpleado = F.IdEmpleado
        WHERE (EXTRACT(YEAR FROM F.FechaHora) = _Ano) AND (EXTRACT(MONTH FROM F.FechaHora) = _Mes)
        LIMIT 1;
    END;
$$
LANGUAGE plpgsql;
