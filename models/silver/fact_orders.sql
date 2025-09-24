{{ config(materialized="table") }}

select
    order_id,
    customer_id,
    TO_DATE(order_date) as order_date,
    ROUND(order_amount,2) as order_amount,
    UPPER(TRIM(order_status)) as order_status,
    case
        when order_amount < 100 then 'SMALL'
        when order_amount BETWEEN 100 AND 200 then 'MEDIUM'
        else 'LARGE'
    end as order_size,
    current_timestamp() as processed_at
from {{ source("raw_data", "raw_orders") }}
where order_amount > 0
