with

stg_item as (select * from {{ ref('stg_item') }}),
stg_product as (select * from {{ ref('stg_product') }}),

stg_supply as (
    select
        sku,
        count(distinct supply_name) as cnt_supplies,
        sum(supply_cost) as total_supply_cost
    from {{ ref('stg_supply') }}
    group by sku
)

select
    i.item_id,
    i.order_id,
    i.sku,
    p.product_name,
    p.product_type,
    p.product_description,
    p.selling_price,
    s.cnt_supplies,
    s.total_supply_cost
from stg_item as i
left join stg_product as p
    on i.sku = p.sku
left join stg_supply as s
    on i.sku = s.sku