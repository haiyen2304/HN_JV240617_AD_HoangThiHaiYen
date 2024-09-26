create database QUANLYBANHANG;
use QUANLYBANHANG;

create table customers (
	customer_id varchar(4) primary key ,
    name varchar(100) not null,
    email varchar(255) unique not null,
    phone varchar(25) unique not null,
    address varchar(255) not null
);

create table orders (
	order_id varchar(4) primary key,
    customer_id varchar(4) ,
    foreign key(customer_id) references CUSTOMERS(customer_id),
    order_date DATE,
    total_amount double
);
create table products(
	product_id varchar(4) primary key,
    name varchar(255) not null,
    description text,
    price double not null,
    status bit(1)
);
create table ORDERS_DETAILS (
	order_id varchar(4),
    foreign key (order_id) references orders(order_id),
    product_id varchar(4),
    foreign key(product_id) references products(product_id),
    primary key(order_id,product_id),
    quantity int(11) not null,
    price double not null
);
-- B2: Thêm dữ liệu
INSERT INTO CUSTOMERS(customer_id,name,email,phone,address) VALUES
('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984758926', 'Ba Đình, Hà Nội'),
('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904727584', 'Mỹ Châu, Sơn La'),
('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

INSERT INTO PRODUCTS(product_id,name,description,price,status) VALUES
('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999, 1),
('P002', 'Dell Vostro V3510', 'Core i5, RAM8GB', 14999999, 1),
('P003', 'Macbook Pro M2', 'CPU I9CPU |8GB|256GB|', 18999999, 1),
('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
('P005', 'Apple Airpods 2', 'Spatial Audio', 409900, 1);

INSERT INTO ORDERS(order_id,customer_id,total_amount,order_date) VALUES
('H001', 'C001', 52999997, str_to_date('22/2/2023','%d/%c/%Y')),
('H002', 'C001', 80999987, str_to_date('11/3/2023','%d/%c/%Y')),
('H003', 'C002', 54399958, str_to_date('22/1/2023','%d/%c/%Y')),
('H004', 'C003', 102999957, str_to_date('14/3/2023','%d/%c/%Y')),
('H005', 'C003', 80999997, str_to_date('12/3/2023','%d/%c/%Y')),
('H006', 'C004', 110499994, str_to_date('1/2/2023','%d/%c/%Y')),
('H007', 'C004', 17999996, str_to_date('29/3/2023','%d/%c/%Y')),
('H008', 'C004', 29999998, str_to_date('14/2/2023','%d/%c/%Y')),
('H009', 'C005', 28999999, str_to_date('10/1/2023','%d/%c/%Y')),
('H010', 'C005', 14999994, str_to_date('1/4/2023','%d/%c/%Y'));

INSERT INTO ORDERS_DETAILS(order_id,product_id,price,quantity) VALUES
('H001', 'P002', 14999999, 1),
('H001', 'P004', 18999999, 2),
('H002', 'P001', 22999999, 1),
('H002', 'P003', 28999999, 2),
('H003', 'P004', 18999999, 2),
('H003', 'P005', 40900000, 4),
('H004', 'P002', 14999999, 3),
('H004', 'P003', 28999999, 2),
('H005', 'P001', 22999999, 1),
('H005', 'P003', 28999999, 2),
('H006', 'P005', 40900000, 5),
('H006', 'P002', 14999999, 6),
('H007', 'P004', 18999999, 3),
('H007', 'P001', 22999999, 1),
('H008', 'P002', 14999999, 2),
('H009', 'P003', 28999999, 9),
('H010', 'P003', 28999999, 4),
('H010', 'P001', 22999999, 4);

-- Bài 3: Truy vấn dữ liệu : 
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .    
select customers.name, customers.email, customers.phone ,customers.address from customers;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 
-- (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng). 
select customers.name, customers.phone,customers.address from customers
join orders on customers.customer_id=orders.customer_id
where orders.order_date between '2023-03-01' and '2023-03-31';

-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 
-- (thông tin bao gồm tháng và tổng doanh thu ). 
select month(orders.order_date) as 'tháng', sum(orders.total_amount) as 'tổng doanh thu' from orders
WHERE YEAR(orders.order_date) = 2023
group by month(orders.order_date);

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 
-- (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại). 
select customers.name,customers.address,customers.email,customers.phone from customers
	   where  customers.customer_id not in (select orders.customer_id from orders
										    where orders.order_date between '2023-02-01' and '2023-02-28');

-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 
-- (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra). 
select products.product_id , products.name, SUM(orders_details.quantity) AS'số lượng bán ra' from orders_details
join products on products.product_id = orders_details.product_id
join orders on orders.order_id = orders_details.order_id
where orders.order_date between '2023-03-01' and '2023-03-31'
group by products.product_id;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi  tiêu
-- (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). 
select customers.customer_id , customers.name ,sum(orders.total_amount) as 'mức chi tiêu' from customers
join orders on orders.customer_id = customers.customer_id
where year(orders.order_date) = 2023
group by customers.customer_id
order by sum(orders.total_amount) desc;

-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên 
-- (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . 
select customers.name as 'tên người mua',orders.total_amount as 'tổng tiền',orders.order_date as'ngày tạo hoá đơn',sum(orders_details.quantity) as'tổng số lượng sản phẩm' from orders
join orders_details on orders_details.order_id = orders.order_id
join customers on customers.customer_id = orders.customer_id
group by orders.order_id
having sum(orders_details.quantity) >= 5;

-- Bài 4:  Tạo View, Procedure : 
-- 1. Tạo VIEW  lấy các thông tin hoá đơn bao gồm : 
-- Tên khách  hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn . 
create view view_details as
select customers.name as 'Tên khách  hàng',customers.phone as 'số điện thoại', customers.address as 'địa chỉ', orders.total_amount as 'tổng tiền' ,orders.order_date as 'ngày tạo hoá đơn'
from orders
join customers on customers.customer_id = orders.customer_id;

select * from view_details;
  
-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : 
-- tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt.
create view show_customers_1 as
select
	customers.name as 'tên khách hàng', customers.address as 'địa chỉ', customers.phone as 'số điện thoại', count(orders.order_id) as 'tổng số đơn đã đặt'
from customers
join orders on orders.customer_id = customers.customer_id 
group by customers.customer_id ,customers.name;
select * from show_customers_1;


-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: 
-- tên sản phẩm, mô tả, giá và tổng số lượng đã bán  ra của mỗi sản phẩm. 
create view view_product as
select products.name as 'tên sản phẩm', 
		products.description as 'mô tả', 
		products.price as 'giá' , 
		sum(orders_details.quantity) as 'tổng số lượng đã bán' 
from products
join orders_details on orders_details.product_id = products.product_id
group by products.product_id;
select * from view_product;

-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer. 
create index index_phone on customers(phone);
create index index_email on customers(email);

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên 
-- mã số khách hàng.
delimiter // 
create procedure get_customer (in customersid varchar(4))
	begin
		select * from customers
        where customer_id = customersid;
	end
// delimiter ;
CALL get_customer('C005');

-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
delimiter // 
create procedure get_products ()
	begin
		select * from products;
	end
// delimiter ;
CALL get_products();

-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. 
delimiter // 
create procedure list_order ( in customer_ID varchar(4))
	begin
		select * from orders
        where orders.customer_id = customer_ID;
	end
// delimiter ;
CALL list_order('C001');

-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là 
-- mã khách hàng, tổng tiền và  ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
delimiter //
create procedure create_orders (in IdCustomers varchar(4),
								in total double, 
								in dateOrder date, 
								out newOrdersId varchar(4))
begin
	set newOrdersId = (select CONCAT('H', LPAD(COALESCE(MAX(CAST(SUBSTRING(order_id, 2) AS UNSIGNED)), 0) + 1, 3, '0'))
						from ORDERS
    );
    insert into orders (order_id, customer_id, total_amount, order_date)
    value (newOrdersId,IdCustomers,total,dateOrder);
end
// delimiter ;
CALL create_orders('C001', 10000, '2024-09-25', @newOrdersId);
SELECT @newOrdersId;
-- 9. Tạo PROCEDURE  thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể với 2 tham số là 
-- ngày bắt đầu và ngày kết thúc.
delimiter //
create procedure thong_ke (in start_date date,in end_date date)
	begin
		select orders_details.product_id as 'id sản phẩm',
				products.name as 'tên sản phẩm',
                COALESCE(sum(orders_details.quantity)) as 'số lượng bán ra'
		from orders_details
        join products on products.product_id=orders_details.product_id
        join orders on orders.order_id = orders_details.order_id
        where orders.order_date between start_date and end_date
        group by orders_details.product_id;
    end
// delimiter ;
CALL thong_ke('2023-02-01','2023-03-01');

-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần của tháng đó 
-- với tham số vào là tháng và năm cần thống kê. 
delimiter // 
create procedure thong_ke_2 (in monthInput int,in yearInput int)
	begin
		select orders_details.product_id as 'id sản phẩm',
				products.name as 'tên sản phẩm',
                COALESCE(sum(orders_details.quantity)) as 'số lượng bán ra'
		from orders_details
        join products on products.product_id=orders_details.product_id
        join orders on orders.order_id = orders_details.order_id
        where month(orders.order_date) = monthInput and year(orders.order_date) = yearInput
        group by orders_details.product_id
        order by sum(orders_details.quantity) desc;
	end
// delimiter ;
call thong_ke_2 (2,2023);





