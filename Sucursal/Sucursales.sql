CREATE DATABASE IF NOT EXISTS Base_Sucursal;

USE Base_Sucursal;

SHOW DATABASES;

CREATE TABLE Articulo(
    IdArticulo INT AUTO_INCREMENT PRIMARY KEY,
    Codigo VARCHAR(40) NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    Descripcion VARCHAR(120) NOT NULL,
    Precio INT NOT NULL,
    IdCategoria INT NOT NULL,
    Garantia VARCHAR(40) NOT NULL,
    FechaRegistro DATE NOT NULL,
    PuntosCompra FLOAT NOT NULL,
    FOREIGN KEY(IdCategoria) REFERENCES Categoria(IdCategoria)
);

CREATE TABLE Categoria(
    IdCategoria INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL
);

CREATE TABLE Promocion(
    IdPromocion INT AUTO_INCREMENT PRIMARY KEY,
    IdArticulo INT NOT NULL,
    FechaHoraI DATE NOT NULL,
    FechaHoraF DATE NOT NULL,
    Descuento INT NOT NULL,
    Puntos INT NOT NULL,
    FOREIGN KEY(IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE Empleado(
    IdEmpleado INT AUTO_INCREMENT PRIMARY KEY,
    Cedula VARCHAR(40) NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    Apellido VARCHAR(70) NOT NULL,
    FechaIngreso DATE NOT NULL,
    IdPuesto INT NOT NULL,
    FOREIGN KEY(IdPuesto) REFERENCES Puesto(IdPuesto)
);

CREATE TABLE Puesto(
    IdPuesto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL,
    Salario INT NOT NULL
);

CREATE TABLE Direccion(
    IdDireccion INT AUTO_INCREMENT PRIMARY KEY,
    IdDistrito INT NOT NULL,
    Direccion VARCHAR(60) NOT NULL,
    FOREIGN KEY(IdDistrito) REFERENCES Distrito(IdDistrito)
);

CREATE TABLE Distrito(
    IdDistrito INT AUTO_INCREMENT PRIMARY KEY,
    IdCanton INT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    FOREIGN KEY(IdCanton) REFERENCES Canton(IdCanton)
);

CREATE TABLE Canton(
    IdCanton INT AUTO_INCREMENT PRIMARY KEY,
    IdProvincia INT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    FOREIGN KEY(IdProvincia) REFERENCES Provincia(IdProvincia)
);

CREATE TABLE Provincia(
    IdProvincia INT AUTO_INCREMENT PRIMARY KEY,
    IdPais INT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    FOREIGN KEY(IdPais) REFERENCES Pais(IdPais)
);

CREATE TABLE Pais(
    IdPais INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL
);

CREATE TABLE Entrega(
    IdEntrega INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE NOT NULL,
    HoraSalida DATE NOT NULL,
    HoraLlegada DATE NOT NULL
);

CREATE TABLE EntregaArticulo(
    IdEntrega INT NOT NULL,
    IdProducto INT NOT NULL,
    FOREIGN KEY(IdEntrega) REFERENCES Entrega(IdEntrega),
    FOREIGN KEY(IdProducto) REFERENCES Producto(IdProducto)
);

CREATE TABLE Cliente(
    IdCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL,
    Apellido VARCHAR(70) NOT NULL,
    Cedula VARCHAR(40) NOT NULL,
    Telefono VARCHAR(40) NOT NULL,
    Puntos INT NOT NULL
);

CREATE TABLE Factura(
    IdFactura INT AUTO_INCREMENT PRIMARY KEY,
    IdEmpleado INT NOT NULL,
    IdCliente INT NOT NULL,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,    
    FOREIGN KEY(IdEmpleado) REFERENCES Empleado(IdEmpleado),
    FOREIGN KEY(IdCliente) REFERENCES Cliente(IdCliente)
);

CREATE TABLE MetodoPago(
    IdMetodoPago INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL
);

CREATE TABLE ArticuloFactura(
    IdFactura INT NOT NULL,
    IdProducto INT NOT NULL,
    IdMetodoPago INT NOT NULL,
    FOREIGN KEY(IdFactura) REFERENCES Factura(IdFactura),
    FOREIGN KEY(IdProducto) REFERENCES Producto(IdProducto),
    FOREIGN KEY(IdMetodoPago) REFERENCES MetodoPago(IdMetodoPago)
);

CREATE TABLE Producto(
    IdProducto INT AUTO_INCREMENT PRIMARY KEY,
    IdArticulo INT NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    FOREIGN KEY(IdArticulo) REFERENCES Articulo(IdArticulo)
);

INSERT INTO Categoria(Nombre)
	VALUES 
	("Camiseta");