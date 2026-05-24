SELECT * FROM shipments_tbl;
-- 1. Remove leading and trailing spaces and convert in upper case
SELECT shipment_id,
proper_case(trim(origin_warehouse)) AS origin_warehouse,
    proper_case(trim(destination_city)) AS destination_city,
    ucase(destination_state) AS destination_state,
    proper_case(trim(carrier)) AS carrier,

-- 2. Change DATE format for ship date and delivery date

str_to_date(delivery_date, '%Y-%m-%d') as delivery_date,
str_to_date(ship_date, '%Y-%m-%d') as ship_date,

-- 3. Validate Date entries for delivery and shipment
datediff(delivery_date,ship_date) as No_of_days_delivered,
CASE
WHEN(delivery_date < ship_date) THEN 'Invalid'
    WHEN(delivery_date) = (ship_date) THEN 'Same Day Delivery'
    ELSE 'Valid'
END as delivery_status,

-- 4. Validate Weights_kg
CASE
WHEN weight_kg < 0 THEN abs(weight_kg)
    WHEN weight_kg = 0 THEN 0
    ELSE weight_kg
END as valid_weight,

-- 5. Look for Duplicates and Remove using Row_Num window function in SQL
row_number()
over (
partition by origin_warehouse, destination_city, destination_state,
ship_date, carrier,
CONVERT(weight_kg, char),
CONVERT(freight_cost, char)
ORDER BY shipment_id) as row_num
FROM shipments_tbl;

-- 6. REMOVE DUPLICATES
DELETE FROM shipments_tbl
WHERE shipment_id IN
(
SELECT shipment_id FROM (
SELECT  shipment_id, row_number() over
(partition by origin_warehouse, destination_city, carrier,
ship_date ORDER BY shipment_id) as row_num
FROM shipments_tbl
) as sub
WHERE row_num > 1
);