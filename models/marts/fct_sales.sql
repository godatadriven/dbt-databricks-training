with

int_enriched_order as (select * from {{ ref('int_enriched_order') }}),
int_enriched_item as (select * from {{ ref('int_enriched_item') }}),

calculate_margin_per_item as (
    select
        item_id,
        order_id,
        sku,
        product_name,
        selling_price,
        total_supply_cost,
        (selling_price - total_supply_cost) as margin_per_item
    from int_enriched_item
),

calculate_margin_per_order as (
    select
        cio.order_id,
        cio.order_date,
        cio.customer_id,
        sum(cpi.selling_price) as total_selling_price,
        sum(cpi.total_supply_cost) as total_cost,
        sum(cpi.margin_per_item) as total_margin
    from int_enriched_order as cio
    left join calculate_margin_per_item as cpi
        on cio.order_id = cpi.order_id
    group by cio.order_id, cio.order_date, cio.customer_id
)

select
    cmo.order_id,
    cmo.order_date,
    cmo.customer_id,
    cmo.total_selling_price,
    cmo.total_cost,
    cmo.total_margin
from calculate_margin_per_order as cmo
