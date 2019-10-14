CREATE DATABASE IF NOT EXISTS Base_Sucursal1;
CREATE DATABASE IF NOT EXISTS Base_Sucursal2;
CREATE DATABASE IF NOT EXISTS Base_Sucursal3;

USE Base_Sucursal1;
USE Base_Sucursal2;
USE Base_Sucursal3;

CREATE TABLE Categoria(
    IdCategoria INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL
);

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

CREATE TABLE Producto(
    IdProducto INT AUTO_INCREMENT PRIMARY KEY,
    IdArticulo INT NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    FOREIGN KEY(IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE Promocion(
    IdPromocion INT AUTO_INCREMENT PRIMARY KEY,
    IdArticulo INT NOT NULL,
    FechaI DATE NOT NULL,
    FechaF DATE NOT NULL,
    HoraI TIME NOT NULL,
    HoraF TIME NOT NULL,
    Descuento INT NOT NULL,
    Puntos FLOAT NOT NULL,
    FOREIGN KEY(IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE Puesto(
    IdPuesto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL,
    Salario INT NOT NULL
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

CREATE TABLE Pais(
    IdPais INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL
);

CREATE TABLE Provincia(
    IdProvincia INT AUTO_INCREMENT PRIMARY KEY,
    IdPais INT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    FOREIGN KEY(IdPais) REFERENCES Pais(IdPais)
);

CREATE TABLE Canton(
    IdCanton INT AUTO_INCREMENT PRIMARY KEY,
    IdProvincia INT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    FOREIGN KEY(IdProvincia) REFERENCES Provincia(IdProvincia)
);

CREATE TABLE Distrito(
    IdDistrito INT AUTO_INCREMENT PRIMARY KEY,
    IdCanton INT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    FOREIGN KEY(IdCanton) REFERENCES Canton(IdCanton)
);

CREATE TABLE Direccion(
    IdDireccion INT AUTO_INCREMENT PRIMARY KEY,
    IdDistrito INT NOT NULL,
    Direccion VARCHAR(60) NOT NULL,
    FOREIGN KEY(IdDistrito) REFERENCES Distrito(IdDistrito)
);

CREATE TABLE Entrega(
    IdEntrega INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE NOT NULL,
    HoraSalida TIME NOT NULL,
    HoraLlegada TIME NOT NULL
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
    Puntos FLOAT NOT NULL
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
    Precio INT NOT NULL,
    FOREIGN KEY(IdFactura) REFERENCES Factura(IdFactura),
    FOREIGN KEY(IdProducto) REFERENCES Producto(IdProducto),
    FOREIGN KEY(IdMetodoPago) REFERENCES MetodoPago(IdMetodoPago)
);

INSERT INTO Categoria(Nombre)
VALUES 
("Camiseta"),
("Pantalon");
    
INSERT INTO Puesto(Nombre, Salario)
VALUES 
("Administrador", 900000),
("Gerente", 1000000),
("Vendedor", 600000),
("Conserje", 400000);


INSERT INTO MetodoPago(Nombre)
VALUES 
("Efectivo"),
("Tarjeta de Debito"),
("Tarjeta de Credito"),
("Paypal"),
("Puntos");

SHOW VARIABLES LIKE "secure_file_priv";

SHOW DATABASES;