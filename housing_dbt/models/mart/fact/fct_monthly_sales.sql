{{ config(
    materialized = 'table',
    schema = 'mart'
) }}

with monthly as (

    select
        date_trunc('month', sale_date) as month,
        count(*)                       as transactions,
        sum(sale_price)                as total_sales,
        avg(sale_price)                as avg_sale_price
    from {{ ref('stg_nashville_housing') }}
    group by 1

)

select * from monthly
