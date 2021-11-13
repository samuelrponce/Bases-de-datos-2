CREATE TABLE Cliente(
ClienteID int primary key,
nombre varchar(100) NOT NULL
);

CREATE TABLE Departamentos(
DepartamentoID int primary key,
nombreDepartamento varchar(100) NOT NULL
);

CREATE TABLE Empleado(
EmpleadoID int primary key,
nombreEmpleado varchar(100) NOT NULL
);

CREATE TABLE Tiempo(
	tiempoId date primary key NOT NULL,
	a�o int NOT NULL,
	mes int NOT NULL,
	semana int NOT NULL,
	trimestre int NOT NULL,
	diaDeSemana varchar(20) NOT NULL,
	semestre int NOT NULL
);

CREATE TABLE Hechos(
	codigoID int IDENTITY(1,1) NOT NULL,
	EmpleadoID int NOT NULL,
	tiempoID date NOT NULL,
	DepartamentoID int NOT NULL,
	ClienteID int NOT NULL,
	total_pagos float NOT NULL,
	FOREIGN KEY (EmpleadoID) REFERENCES Empleado(EmpleadoID),
	FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
	FOREIGN KEY (DepartamentoID) REFERENCES Departamentos(DepartamentoID),
	FOREIGN KEY (tiempoId) REFERENCES Tiempo(tiempoId)
);




