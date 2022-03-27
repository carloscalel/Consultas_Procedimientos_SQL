--procedimiento almacenado sin parametros
alter procedure listaEmpleados
as
	select * 
	from Employees
	where LastName like '%A%'
	and TitleOfCourtesy =  'ms.'
go

exec listaEmpleados

--listar nombre y telefono de los porveedore (suppliers)

create procedure sp_proveedores_seafood
as
select DISTINCT s.CompanyName, s.Phone
from Suppliers s inner join Products p on s.SupplierID = p.SupplierID
	inner join Categories c on p.CategoryID =  c.CategoryID
	inner join [Order Details] od on p.ProductID =  od.ProductID
	where c. CategoryName =  'SEAFOOD'
	go

	exec sp_proveedores_seafood

--procedimiento almacenado con parametros

select * from Employees

create procedure sp_eliminarEmpleado
--parametros
@codigoempleado int
as
	delete from Employees where EmployeeID =  @codigoempleado
	go



--triggers
select * into empleados_copia from empleados
select * into empleados_cancelados from empleados --para sacar una copia de una tabla identica

select * from empleados
select * from empleados_cancelados
select * from empleados_copia

insert into empleados values ('fenando','lopez','prueva', '2022-03-13','prueva')
go


create trigger trg_insertarEmpleados on empleados
for insert
as
	declare @id int
	declare @nombre varchar(20)
	declare @apellido varchar(20)
	declare @estado varchar(20)
	declare @fecha_contrato date
	declare @accion_trigger varchar(30)

	select @id = i.id from inserted i
	select @nombre =  i.nombre from inserted i
	select @apellido =  i.apellido from inserted i
	select @estado =  i.estado from inserted i
	select @fecha_contrato =  i.fecha_contrato from inserted i
	select @accion_trigger =  i.accion_trigger from inserted i
	
	insert into empleados_copia (nombre, apellido, estado, fecha_contrato, accion_trigger)
	values (@nombre, @apellido, @estado, @fecha_contrato, @accion_trigger)
	go

