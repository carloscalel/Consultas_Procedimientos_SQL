--tabla unica
use BDVentas
--1. mostrar todos los datos de la tblProductos
select p.*
from tblProductos p

--2. mostrar los campos COD_PROD, NOM_PROD, COS_PROM_C y
--ordenarlos por nom_prod de la talba tlbproductos
select p.COD_PROD,
		p.NOM_PROD,
		p.COS_PROM_C
from tblProductos p
order by NOM_PROD desc

--3. incrementar el campo COS_PROM  a un 15% de la tabla tblproductos
select p.COD_PROD,
		p.NOM_PROD,
		p.COD_LIN,
		p.MARCA,
		p.COS_PROM_C,
		p.COS_PROM_C * 1.15 as Cos_prom_C_Actual,
		p.PRECIO_VTA,
		p.PRECIO_VTA * 1.15 as Precio_Vta_Actual
from tblProductos p

--mostrar todos los datos de la tabla tblventas entre un rango de fechas
select @@LANGUAGE
--espanol dd/mm/yyyy
--ingles mm/dd/yyyy

set dateformat dmy --para asignar un fomato de fecha 

select *
from tblVentas v
where v.FECHA between '01/01/2014' and '31/12/2014'

--5. utilizando alias forma 1
select p.COD_PROD as [Codigo Producto]
from tblProductos p 

select p.COD_PROD as 'Codigo Producto'
from tblProductos p 

--6. utilizando alias forma 2
select [codigo producto] = p.COD_PROD
from tblProductos p 

--7. select que elimine duplicadas de la tabla tblventas
select distinct v.COD_ID
from tblVentas v

--8. select registros utilizando la clausula top
select top 10 c.*
from tblClientes c
order by c.COD_ID desc

--9. select registro utilizando la clausula top percent
select top 10 percent c.*
from tblClientes c

--10. utilizando la clausula top inbluyendo el with ties.  filas adicinales 'match'
--incluye mas valores si coinciden con los valores seleccionados por el top
select top 10 with ties v.*
from tblVentas v
order by v.COD_ID desc

--11. mostrar los datos de la tabla tblventas utilizando where e in
--'0000', '01013', '01020'
select v.*
from tblVentas v
where v.COD_ID in ('0000', '01013', '01020')
order by COD_ID

--12. mostrar los datos de la tabla tblventas utilizando where y or
select v.*
from tblVentas v
where v.COD_ID = '0000' or
		v.COD_ID = '01013' or  
		v.COD_ID = 'COD_ID'
order by COD_ID

--13. mostrar los datos de la tabla tblventas utiliznado un where con subconsultas
select v.*
from tblVentas v
where v.COD_ID in (select c.COD_ID from tblClientes c)
order by COD_ID

--14. mostrar todos los clientes que an realizado una venta
select v.*
from tblVentas v
where v.COD_ID in (select c.COD_ID from tblClientes c where CONDICIONES is not null)
order by COD_ID

select c.*
from tblClientes as c
where c.COD_ID in (select v.COD_ID from tblVentas v)

--15. mostrar todos los clientes que no existen en a talba ventas
select c.COD_ID
from tblClientes c
where c.COD_ID not in (select v.cod_id from tblventas v)

--16. mostrar todos los productos que contengan la palabra  CERVEZA, utilizando 
-- la tabla tblproductos
select P.COD_PROD,
		p.NOM_PROD
from tblProductos P
where p.NOM_PROD like '%CERVEZA%'

--17 mostrar todos los datos tblproductos que enel campo marca contega valores nulos
select p.*
from tblProductos p
where p.MARCA is null

--18 mostrar todos los campos de la tabla tblproductos que  enel camp marca no contengan 
--valores nulos
select p.*
from tblProductos p
where p.MARCA is not null

--19 mostrar resultados de la tabla vendedores usando paginacion con la clausula offset
--offset (obviar las nfilas que la definan)
select v.*
from tblVendedores v
order by v.COD_VEND desc
OFFSET 10 rows

--20 utilizando un ofset con fetch elija cuantas filas se van a mostrar a partir'
--de los registros que se van a obviar o ignorar con el offset
select v.*
from tblVendedores v
order by v.COD_VEND desc
OFFSET 10 rows
fetch next 5 rows only

--------------------------------------------------
--------------------------------------------------
/*consultas con vairas tablas */
--1 inner join la tabla tblventas y la tabla tblclientes
select v.COD_ID,
		v.COD_DIA,
		v.NUM_DOC,
		v.CONDICIONES,
		c.NOMBRE
from tblVentas v inner join tblClientes c on v.COD_ID = c.COD_ID

/*tres tablas */
--2 mostrar los 10 productos que tienen mas utilidad, entre un rango de fechas
--comprendido entre 01/01/2014 y 31/12/2014, los campos que se desean mostrar son
--cod_suc, fecha, cod_prod, nom_prod, utilidad
--tablas a utilizar tblventas, tblventasdetalle, tblproduto

SELECT dbo.tblVentas.COD_SUC, dbo.tblVentas.FECHA, dbo.tblProductos.COD_PROD, dbo.tblProductos.NOM_PROD
FROM     dbo.tblVentas INNER JOIN
                  dbo.tblVentas_Detalle ON dbo.tblVentas.ID = dbo.tblVentas_Detalle.ID INNER JOIN
                  dbo.tblProductos ON dbo.tblVentas_Detalle.COD_PROD = dbo.tblProductos.COD_PROD
where dbo.tblVentas.FECHA between '01/01/2014' and '31/12/2014'
-----------------------------------------------
-----------------------------------------------
select top 10 v.COD_SUC,
		v.FECHA,
		vd.COD_PROD,
		p.NOM_PROD,
		round((vd.CANTIDAD * vd.VALOR) - (vd.CANTIDAD * vd.COSTO),2) as utilidad
from tblVentas v inner join tblVentas_Detalle vd on v.ID = vd.ID
		inner join tblProductos p on vd.COD_PROD = p.COD_PROD
where v.FECHA between '01/01/2014' and '31/12/2014'
order by utilidad desc

--3 mostrar las 10 ventas mas grandes que se ha echo entre un rango 
--de fechas comprendido entre 01/01/2014 al 31/12/2014, los campos se desean mostrar son 
--cod_suc, fecha, cod_id,cliente, ventas
--tablas a utilizar tblventas, tblventas_detalle, tlbclietes

select top 10 v.COD_SUC,
		v.FECHA,
		vd.COD_PROD,
		c.NOMBRE,
		round((vd.CANTIDAD * vd.VALOR),2) as venta_total
from tblVentas v inner join tblVentas_Detalle vd on v.ID = vd.ID
		inner join tblClientes c on v.COD_ID= c.COD_ID
where v.FECHA between '01/01/2014' and '31/12/2014'
order by venta_total desc

---4 utilizar left outer join para listar los clientes que no han relizado ninguna compra
select *
from tblClientes c left outer join tblVentas v on c.COD_ID =  v.COD_ID
where v.ID is null

--5 utilizar righ outer join ver los clientes que no han realizado ninguna compra
--recuerde, la tabla de izquierda es tblventas y la derecha es tblcleitnes
--outer es opcional
select *
from tblVentas v right outer join tblClientes c on c.COD_ID =  v.COD_ID
where v.COD_ID is null

--6 utilizar full outer join
select *
from tblVentas v full outer join tblClientes c on v.COD_ID =  c.COD_ID

--7 utilizando cross apply (producto cartesiano) 29*12=348
select * from tblZonas z
select * from tblSucursales s

select *
from tblZonas z cross apply tblSucursales s
order by ZONA

--8 union o union all (uniendo datos de al misma tabla o de otras tablas)
select * from (
select p.*
from tblProductos p
where p.COD_LIN = '005'
union all
select p.*
from tblProductos p
where p.COD_LIN = '006'
union
select p.*
from tblProductos p
where p.COD_LIN = '018') tblUnion

--funciones de agregacion count, min, max, sum, avg

--1
select count(*) as total_Registro,
	min(p.precio_vta)as precio_minimo,
	max(p.precio_vta) as precio_maximo,
	sum(p.precio_vta) as total_precio,
	avg(p.precio_vta) as precio_promedio
from tblProductos p

--2 agrupar por sucursal calcular cual es la venta mayo y menor por sucursal, calcular 
--
--utilizar las tablas tblventas y tblventas_detalle

select v.COD_SUC,
		max(vd.CANTIDAD * vd.VALOR) as venta_maxima,
		min (vd.CANTIDAD * vd.VALOR) as venta_minima,
		min (v.FECHA) as venta_primera,
		max (v.FECHA) as venta_ultima,
		count(*) as Cantidad_por_sucursal,
		avg(vd.cantidad * vd.valor) as venta_promedio
from tblVentas v inner join tblVentas_Detalle vd on v.ID = vd.ID
group by v.COD_SUC
order by v.COD_SUC

--3 calcular total costo, total ventam, total utilidad, porcenta de utilidad, agruparlo

select l.NOM_LIN,
		sum(vd.CANTIDAD * vd.COSTO) as costo_total,
		sum(vd.CANTIDAD * vd.VALOR) as venta_total,
		sum((vd.CANTIDAD * vd.VALOR) - (vd.CANTIDAD * vd.COSTO)) as utilidad_total,
		round(sum((vd.CANTIDAD * vd.VALOR) - (vd.CANTIDAD * vd.COSTO)) / sum(vd.CANTIDAD * vd.VALOR),2) * 100 as porcentajeUtilidad
from tblVentas v inner join tblVentas_Detalle vd on v.ID =  vd.ID
		inner join tblProductos p on vd.COD_PROD =  p.COD_PROD
		inner join tblLineas l on p.COD_LIN = l.COD_LIN
group by l.NOM_LIN
order by porcentajeUtilidad desc

--having 
select l.NOM_LIN,
		sum(vd.CANTIDAD * vd.COSTO) as costo_total,
		sum(vd.CANTIDAD * vd.VALOR) as venta_total,
		sum((vd.CANTIDAD * vd.VALOR) - (vd.CANTIDAD * vd.COSTO)) as utilidad_total,
		round(sum((vd.CANTIDAD * vd.VALOR) - (vd.CANTIDAD * vd.COSTO)) / sum(vd.CANTIDAD * vd.VALOR),2) * 100 as porcentajeUtilidad
from tblVentas v inner join tblVentas_Detalle vd on v.ID =  vd.ID
		inner join tblProductos p on vd.COD_PROD =  p.COD_PROD
		inner join tblLineas l on p.COD_LIN = l.COD_LIN
where v.FECHA between '01/01/2014' and '31/12/2015'
group by l.NOM_LIN
having round(sum((vd.CANTIDAD * vd.VALOR) - (vd.CANTIDAD * vd.COSTO)) / sum(vd.CANTIDAD * vd.VALOR),2) * 100 < 10


