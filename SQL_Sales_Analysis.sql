-- Creating Customers Table
CREATE TABLE Customers (customer_id INT PRIMARY KEY,customer_name VARCHAR(50),city VARCHAR(50),age INT);

-- Inserting Data into Customers Table
INSERT INTO Customers (customer_id, customer_name, city, age) VALUES (1, 'John Smith', 'New York', 28),
(2, 'Jane Doe', 'Los Angeles', 34),(3, 'Mike Johnson', 'Chicago', 45),(4, 'Emily Davis', 'Houston', 25),(5, 'David Wilson', 'Phoenix', 38),
(6, 'Sarah Brown', 'Philadelphia', 50),(7, 'Chris Taylor', 'San Antonio', 32),(8, 'Jessica Moore', 'San Diego', 29),
(9, 'Daniel Anderson', 'Dallas', 42),(10, 'Ashley Thompson', 'Austin', 36),(11, 'Megan Martinez', 'New York', 30),(12, 'Joshua Robinson', 'Los Angeles', 39),
(13, 'Sophia Harris', 'Chicago', 27),(14, 'Matthew Clark', 'Houston', 49),(15, 'Olivia Lewis', 'Phoenix', 44);

-- Creating Sales Table
CREATE TABLE Sales (sale_id INT PRIMARY KEY,customer_id INT,product_id INT,sale_date DATE,quantity INT,total_sale_amount DECIMAL(10, 2),
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id));

-- Inserting Data into Sales Table
INSERT INTO Sales (sale_id, customer_id, product_id, sale_date, quantity, total_sale_amount) VALUES
(1, 1, 1, '2024-09-01', 2, 1600.00),(2, 2, 3, '2024-09-03', 1, 300.00),(3, 3, 2, '2024-09-04', 3, 1800.00),(4, 4, 5, '2024-09-05', 1, 400.00),
(5, 5, 6, '2024-09-06', 4, 200.00),(6, 6, 7, '2024-09-07', 5, 100.00),(7, 7, 9, '2024-09-08', 2, 200.00),(8, 8, 4, '2024-09-09', 3, 600.00),
(9, 9, 10, '2024-09-10', 1, 100.00),(10, 10, 1, '2024-09-11', 1, 800.00),(11, 11, 2, '2024-09-12', 2, 1200.00),
(12, 12, 3, '2024-09-13', 4, 1200.00),(13, 13, 4, '2024-09-14', 1, 200.00),(14, 14, 5, '2024-09-15', 1, 400.00),(15, 15, 6, '2024-09-16', 6, 300.00),
(16, 1, 7, '2024-09-17', 2, 40.00),(17, 2, 8, '2024-09-18', 3, 120.00),(18, 3, 9, '2024-09-19', 2, 200.00),(19, 4, 10, '2024-09-20', 1, 100.00),
(20, 5, 1, '2024-09-21', 1, 800.00),(21, 6, 3, '2024-09-22', 2, 600.00),(22, 7, 4, '2024-09-23', 1, 200.00),
(23, 8, 5, '2024-09-24', 1, 400.00),(24, 9, 6, '2024-09-25', 5, 250.00),(25, 10, 7, '2024-09-26', 3, 60.00),(26, 11, 8, '2024-09-27', 2, 80.00),
(27, 12, 9, '2024-09-28', 1, 100.00),(28, 13, 10, '2024-09-29', 1, 100.00),(29, 14, 1, '2024-09-30', 1, 800.00),(30, 15, 2, '2024-10-01', 3, 1800.00);

select * from customers;
select * from sales;

-- Q1 Calculate the total sales amount for each product and assign a rank to each product based on the total sales, with the highest sales ranked first?
select product_id,sum(total_sale_amount) as total_amount,dense_rank() over(order by sum(total_sale_amount) desc) as rnk from sales group by product_id;

-- Q2 List the customers who have purchased more than 3 items in total?
select cus.customer_name ,sum(sal.quantity) as total_items from sales as sal join customers as cus on sal.customer_id=cus.customer_id 
group by cus.customer_name having sum(sal.quantity) >3;

-- Q3 Retrieve top 3 (highest selling) products sales records from the month of September 2024?
select product_id,sum(total_sale_amount) as total_amounts from sales where year(sale_date)= 2024 and month(sale_date)=9 group by product_id order by total_amounts desc
limit 3;

-- Q4 Find the total quantity of products sold in each city?
select cus.city , sum(sal.quantity) as total_product from sales as sal join customers as cus on sal.customer_id=cus.customer_id group by cus.city;

-- Q5 List the average age of customers who bought each product?
select sal.product_id, round(avg(age),1) as avg_age from sales as sal join customers as cus on sal.customer_id=cus.customer_id group by sal.product_id;

-- Q6 Find the top 3 cities with the highest total sales?
select cus.city,sum(total_sale_amount) as total_amount from sales as sal join customers as cus on sal.customer_id=cus.customer_id group by cus.city order by
total_amount desc limit 3;

-- Q7 Find the customer who spent the most money overall?
select cus.customer_name ,sum(total_sale_amount) as total_amount from sales as sal join customers as cus on sal.customer_id = cus.customer_id group by cus.customer_name
order by total_amount desc limit 1;

-- Q8 Find the percentage of total sales contributed by each product?
select  product_id ,(sum(total_sale_amount)/(select sum(total_sale_amount) from sales))*100 as percentage_sales from sales group by product_id;

-- Q9 Calculate the cumulative total sales for each product, ordered by the sale date within September 2024?
select sale_date,sum(total_sale_amount) over(order by sale_date) as cumulative_sales from sales where year(sale_date)=2024 and month(sale_date)=09;

-- Q10 For each customer, calculate the difference in total sales amount between their current purchase and their previous purchase, ordered by sale date?
with cte as (select customer_id,sale_date,sum(total_sale_amount) as total_amount from sales group by  customer_id,sale_date order by sale_date)
select *,total_amount - lag(total_amount,1,0) over(partition by customer_id order by sale_date) sales_difference from cte;







