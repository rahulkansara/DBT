{{ config(materialized="table") }}

select
    product_id,
    trim(product_name) as product_name,
    trim(upper(category)) as category,
    ROUND(price,2) as price,
    is_active,
    case
        when price < 50 then 'LOW'
        when price BETWEEN 50 AND 200 then 'MEDIUM'
        else 'HIGH'
    end as price_category,
    current_timestamp() as processed_at
from {{ source("raw_data", "raw_products") }}
where product_name is not null
