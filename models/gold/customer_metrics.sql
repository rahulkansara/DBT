{{ config(materialized="table") }}

WITH order_metrics AS (
    SELECT
        customer_id,
        COUNT(*) as total_orders,
        SUM(order_amount) as total_spent,
        AVG(order_amount) as avg_order_value,
        MIN(order_date) as first_order_date,
        MAX(order_date) as last_order_date,
        COUNT (CASE WHEN order_status = 'COMPLETED' THEN 1 END) as completed_orders
    FROM {{ref('fact_orders')}}
    group by customer_id
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.signup_date,
    COALESCE(om.total_orders,0) as total_orders,
    COALESCE(om.total_spent,0) as total_spent,
    COALESCE(om.avg_order_value,0) as avg_order_value,
    om.first_order_date,
    om.last_order_date,
    COALESCE(om.completed_orders,0) as completed_orders,
    case
        when om.total_spent >= 300 then 'HIGH VALUE'
        when om.total_spent >= 100 then 'MEDIUM VALUE'
        when om.total_spent > 0 then 'LOW VALUE'
        else 'NO PURCHASES'
    end as customer_sgement,
    current_timestamp() as processed_at
from {{ref('dim_customers')}} c
LEFT JOIN order_metrics om on c.customer_id = om.customer_id 