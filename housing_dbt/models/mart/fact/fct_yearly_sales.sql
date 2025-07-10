{{ config(materialized='table', schema='mart') }}

with yearly as (
    select
        extract(year from sale_date)::int     as year,
        count(*)                              as transactions,
        sum(sale_price)                       as total_sales,
        avg(sale_price)                       as avg_sale_price
    from {{ ref('fct_property_sale') }}
    group by 1
)

select * from yearly
