
select p.ProductName [Ürün İsmi ], p.UnitPrice Fiyat from Products as p
where p.UnitPrice > 50 
order by p.UnitPrice desc

--İlk 5 tedarikçimi getir  
select top 5 * from Suppliers

--İlk 5 tedarikçimi getir. Sadece ID ve CompanyName yazsın
select top 5 SupplierID,CompanyName from Suppliers 

--Ürünleri ad sırasına göre (A-Z) listele 
select * from Products p order by p.ProductName
 
--Ürünleri ad sırasına göre tersten listele (Z-A) 
select * from Products order by ProductName desc

--mevcut metni büyültür
select UPPER(ProductName) [ürün adı] from Products
 
--mevcut metni küçültür
select LOWER(ProductName) [ürün adı]  from Products

--Region alanı NULL olan kaç tedarikçim var? ( Supplier ) ( İnternetten bakılmalı )
select COUNT(*) from Suppliers where Region is null
--Null olmayanlar
select COUNT(*) from Suppliers where Region is not null

--en ucuz 5 ürünü getir
select top 5 * from Products order by UnitPrice

--en Pahalı 5 ürünü getir
select top 5 * from Products order by UnitPrice desc
 
--En ucuz 5 ürünün ortalama fiyatı nedir? 
select top 5 AVG(UnitPrice) from Products order by UnitPrice

--Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
select 'TR ' + UPPER(ProductName) from Products

--Ürün adı, fiyatı ve kdv ekrana yazdır
select P.ProductName [Ürün ismi] , P.UnitPrice Fiyat , P.UnitPrice + P.UnitPrice * 0.18 [Fiyat + Kdv] FROM Products P
 
--Fiyatı 20den küçük ürünlerin adının başına TR ekle
select 'TR-' + ProductName [Ürün Ad] from Products where UnitPrice < 20

--Ürünün adı içerisinde a harfi geçenler
select * from Products where ProductName like '%a%'
 
--Ürün adı a ile başlayanlar
select * from Products where ProductName like 'a%'
 
--Ürün adı a ile bitenler
select * from Products where ProductName like '%a'

-- tüm ürünlerin toplamı
select SUM(UnitPrice) from Products
 
-- tüm ürünlerin ortalaması
select AVG(UnitPrice) from Products

------- Sorular

-- 1. Çalışanlarım ne kadarlık satış yapmışlar? (Gelir bazında) ?

select e.FirstName + ' ' + e.LastName [İsim Soyisim], SUM(Quantity*UnitPrice) Ciro
from Employees e
inner join Orders o
on e.EmployeeID=o.EmployeeID
inner join [Order Details] od
on o.OrderID=od.OrderID
group by e.FirstName,e.LastName

-- 2. Hangi ülkelere ihracat yapıyorum?

select distinct country
from customers

-- 3. Ürünlere göre satışım nasıl? (Ürün-Adet-Gelir)

select p.ProductName,SUM(od.Quantity) as Adet,sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as Gelir
from Products p
inner join [Order Details] od
on p.ProductID=od.ProductID
group by p.ProductName
order by 3 desc

-- 4. Ürün kategorilerine göre satışlarım nasıl? (Gelir bazında)

select c.CategoryName, SUM(od.Quantity*od.UnitPrice) as Gelir
from Categories c
inner join Products p 
on c.CategoryID = p.CategoryID
inner join [Order Details] od
on od.ProductID = p.ProductID
group by CategoryName
order by 2 desc

-- 5. Ürün kategorilerine göre satışlarım nasıl? (Adet bazında)

select c.CategoryName, SUM(od.Quantity) as Adet
from Categories c
inner join Products p 
on c.CategoryID = p.CategoryID
inner join [Order Details] od
on od.ProductID = p.ProductID
group by CategoryName
order by 2 desc

-- 6. Çalışanlarım ürün bazında ne kadarlık satış yapmışlar? (Çalışan  –  Ürün – Adet – Gelir)

select (e.FirstName + e.LastName) as Çalisan, p.ProductName, sum(od.Quantity) Adet, SUM(od.Quantity*od.UnitPrice) Ciro
from Products p
inner join [Order Details] od
on p.ProductID=od.ProductID
inner join Orders o
on od.OrderID=o.OrderID
inner join Employees e
on o.EmployeeID=e.EmployeeID
group by e.FirstName + e.LastName,p.ProductName
order by 4 desc


-- 7. Hangi kargo şirketine toplam ne kadar ödeme yapmışım?
select s.CompanyName, Sum(o.Freight) from Shippers s
inner join Orders o
on o.ShipVia = s.ShipperID
group by s.CompanyName


-- 8. En değerli müşterim hangisi? (en fazla satış yaptığım müşteri) (Gelir ve adet bazında)
select c.CompanyName,SUM(od.Quantity) as Adet, SUM(od.Quantity*od.UnitPrice) as Gelir, c.Phone
from Customers c
inner join Orders o
on o.CustomerID = c.CustomerID
inner join [Order Details] od
on od.OrderID = o.OrderID
group by c.CompanyName, c.Phone
order by 3 desc	

-- 9. Hangi ülkelere ne kadarlık satış yapmışım?
select c.Country,  sum(od.Quantity) as [Satış Adeti],sum(od.Quantity*od.UnitPrice) as [Satış Geliri]
from Customers c
inner join Orders o
on o.CustomerID = c.CustomerID
inner join [Order Details] od 
on od.OrderID = o.OrderID
group by c.Country
order by 2 desc

-- 10. Satışlarımı kaç günde teslim etmişim?

select OrderID,datediff(DAY,OrderDate,ShippedDate) as Gün
from Orders
where ShippedDate not like 'NULL'
order by 2 desc
