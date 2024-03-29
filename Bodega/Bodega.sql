CREATE TABLE Pais(
    IdPais SERIAL PRIMARY KEY,
    Nombre TEXT NOT NULL
);

CREATE TABLE Provincia(
    IdProvincia SERIAL PRIMARY KEY,
    IdPais INT NOT NULL REFERENCES Pais(IdPais),
    Nombre TEXT
);

CREATE TABLE Canton(
    IdCanton SERIAL PRIMARY KEY,
    IdProvincia INT NOT NULL REFERENCES Provincia(IdProvincia),
    Nombre TEXT
);

CREATE TABLE Distrito(
    IdDistrito SERIAL PRIMARY KEY,
    IdCanton INT NOT NULL REFERENCES Canton(IdCanton),
    Nombre TEXT
);

CREATE TABLE Direccion(
    IdDireccion SERIAL PRIMARY KEY,
    IdDistrito INT NOT NULL REFERENCES Distrito(IdDistrito),
    Direccion TEXT
);

CREATE TABLE Sucursal(
    IdSucursal SERIAL PRIMARY KEY,
    Codigo TEXT NOT NULL,
    Nombre TEXT NOT NULL,
    Descripcion TEXT NOT NULL,
    Estado BOOLEAN NOT NULL,
    IdDireccion INT NOT NULL REFERENCES Direccion(IdDireccion)
);

CREATE TABLE Categoria(
    IdCategoria SERIAL PRIMARY KEY,
    Nombre TEXT NOT NULL
);

CREATE TABLE Articulo(
    IdArticulo SERIAL PRIMARY KEY,
    Codigo TEXT NOT NULL,
    Nombre TEXT NOT NULL,
    Descripcion TEXT NOT NULL,
    Precio INT NOT NULL,
    IdCategoria INT NOT NULL REFERENCES Categoria(IdCategoria),
    Garantia INT NOT NULL,
    FechaRegistro DATE NOT NULL,
    PuntosCompra INT NOT NULL
);

CREATE TABLE Puesto(
    IdPuesto SERIAL PRIMARY KEY,
    Nombre TEXT NOT NULL,
    Salario INT NOT NULL
);

CREATE TABLE Empleado(
    IdEmpleado SERIAL PRIMARY KEY,
    Cedula TEXT NOT NULL,
    Nombre TEXT NOT NULL,
    Apellidos TEXT NOT NULL,
    Estado BOOLEAN NOT NULL,
    IdSucursal INT NOT NULL REFERENCES Sucursal(IdSucursal),
    FechaIngreso DATE NOT NULL,
    IdPuesto INT NOT NULL REFERENCES Puesto(IdPuesto)
);

CREATE TABLE EmpleadoAdministrador(
    IdEmpleado INT NOT NULL REFERENCES Empleado(IdEmpleado),
    IdSucursal INT NOT NULL REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE ArticuloSucursal(
    IdSucursal INT NOT NULL REFERENCES Sucursal(IdSucursal),
    IdArticulo INT NOT NULL REFERENCES Articulo(IdArticulo)
);

CREATE TABLE Promocion(
    IdPromocion SERIAL PRIMARY KEY,
    IdSucursal INT NOT NULL REFERENCES Sucursal(IdSucursal),
    IdArticulo INT NOT NULL REFERENCES Articulo(IdArticulo),
    FechaHoraI TIMESTAMP NOT NULL,
    FechaHoraF TIMESTAMP NOT NULL,
    Descuento INT NOT NULL,
    Puntos INT NOT NULL
);

CREATE TABLE Camion(
    IdCamion SERIAL PRIMARY KEY,
    IdEmpleado INT NOT NULL REFERENCES Empleado(IdEmpleado),
    Placa TEXT NOT NULL,
    Marca TEXT NOT NULL,
    Modelo TEXT NOT NULL,
    Ano INT NOT NULL,
    Estado BOOLEAN NOT NULL
);

CREATE TABLE Entrega(
    IdEntrega SERIAL PRIMARY KEY,
    IdCamion INT NOT NULL REFERENCES Camion(IdCamion),
    IdSucursal INT NOT NULL REFERENCES Sucursal(IdSucursal),
    Fecha DATE NOT NULL,
    HoraSalida TIME NOT NULL,
    HoraLlegada TIME NOT NULL
);

CREATE TABLE Producto(
    IdProducto SERIAL PRIMARY KEY,
    IdArticulo INT NOT NULL REFERENCES Articulo(IdArticulo),
    IdSucursal INT NOT NULL REFERENCES Sucursal(IdSucursal),
    Estado TEXT
);

CREATE TABLE EntregaProducto(
    IdEntrega INT NOT NULL REFERENCES Entrega(IdEntrega),
    IdProducto INT NOT NULL REFERENCES Producto(IdProducto)
);

CREATE TABLE MetodoPago(
    IdMetodoPago SERIAL PRIMARY KEY,
    Nombre TEXT
);

CREATE TABLE Cliente(
    IdCliente SERIAL PRIMARY KEY,
    Nombre TEXT NOT NULL,
    Apellido TEXT NOT NULL,
    Cedula TEXT NOT NULL,
    Telefono TEXT NOT NULL,
    Puntos INT NOT NULL
);

CREATE TABLE Factura(
    IdFactura SERIAL PRIMARY KEY,
    IdEmpleado INT NOT NULL REFERENCES Empleado(IdEmpleado),
    IdCliente INT NOT NULL REFERENCES Cliente(IdCliente),
    IdSucursal INT NOT NULL REFERENCES Sucursal(IdSucursal),
    FechaHora TIMESTAMP NOT NULL
);

CREATE TABLE ProductoFactura(
    IdFactura INT NOT NULL REFERENCES Factura(IdFactura),
    IdProducto INT NOT NULL REFERENCES Producto(IdProducto),
    IdMetodoPago INT NOT NULL REFERENCES MetodoPago(IdMetodoPago),
    Precio INT NOT NULL
);

CREATE TABLE ProductoEnAlmacen(
    IdArticulo INT NOT NULL REFERENCES Articulo(IdArticulo),
    Estado BOOLEAN NOT NULL
);