--
select a.AlbumId, a.Title, t.TrackId, t.Name 
from Album a join Track t on a.AlbumId = t.AlbumId
order by a.AlbumId asc, t.TrackId asc;
--
select t.Name 
From Track t  join Album a on t.AlbumId = a.AlbumId 
where a.Title like 'Body Count'
order by t.Name asc;
--
select t.TrackId, t.Name 
from Track t join InvoiceLine il on t.TrackId = il.TrackId  
where il.InvoiceId = 3 or il.InvoiceId = 4;
--
select *
from Employee e
where e.ReportsTo like '_';
--
Select e.EmployeeId as empleado, e.FirstName, e.LastName, 
       e2.EmployeeId as jefe, e2.FirstName as nombreJefe, e2.LastName as apellidoJefe
from Employee e join Employee e2 on e2.ReportsTo = e.EmployeeId;
--
select i.InvoiceId, i.Total, c.CustomerId, i.InvoiceDate
from Invoice i join Customer c on i.CustomerId = c.CustomerId 
where i.InvoiceDate like "2012-11-%%"
order by i.InvoiceId asc;
--
select i.InvoiceId, i.Total, c.CustomerId, c.FirstName, c.LastName, i.InvoiceDate 
from Invoice i  join Customer c on i.CustomerId = c.CustomerId 
where i.InvoiceDate like "2012-11-%%"
order by i.InvoiceDate asc;
--
select i.InvoiceId, i.BillingCountry , i.CustomerId, c.FirstName, c.LastName
from Invoice i join Customer c on i.CustomerId = c.CustomerId 
where i.BillingCountry like 'Portugal'
		and i.Total >10
		or i.BillingCountry like 'Canada' 
		and i.Total >12
order by i.BillingCountry asc, i.InvoiceId asc;
--
select p.Name, pt.TrackId 
from Playlist p join PlaylistTrack pt on p.PlaylistId = pt.PlaylistId
where p.PlaylistId  like 3;
--
select p.PlaylistId, p.Name, pt.TrackId 
from Playlist p join PlaylistTrack pt on p.PlaylistId = p.PlaylistId
				join Track t on pt.TrackId = t.TrackId 
where p.PlaylistId in(3,5) and 
	  pt.TrackId between '3350' and '3370'
order by p.PlaylistId asc, pt.TrackId;
--
select p.PlaylistId, p.Name, t.TrackId, t.Name as cancion
from Playlist p join PlaylistTrack pt on p.PlaylistId = pt.PlaylistId 
				join Track t on pt.TrackId = t.TrackId 
where p.PlaylistId in(3,5) and 
	  pt.TrackId between '3350' and '3370'
order by p.PlaylistId asc, pt.TrackId;
--
select p.PlaylistId, p.Name as playlist, t.TrackId, t.Name, t.AlbumId, a.Title 
from Playlist p join PlaylistTrack pt on p.PlaylistId = pt.PlaylistId 
				join Track t on pt.TrackId = t.TrackId 
				join Album a on t.AlbumId = a.AlbumId 
where p.PlaylistId in(3,5) and 
	  pt.TrackId between '3350' and '3370'
order by p.PlaylistId asc, pt.TrackId;