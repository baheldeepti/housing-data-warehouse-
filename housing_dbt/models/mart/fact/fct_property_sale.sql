{{ config(materialized='table', schema='mart') }}

with base as (

    select
        parcel_id,
        sale_date,
        sale_price,
        sold_as_vacant,
        multi_parcel_flag
    from {{ ref('stg_nashville_housing') }}
    where sale_price > 0                       -- keep only paid sales
)

select
    b.parcel_id,
    p.property_key,
    o.owner_key,
    d.date_id,

    b.sale_date,
    b.sale_price,
    b.sold_as_vacant,
    b.multi_parcel_flag

from base b
left join {{ ref('dim_property') }} p  using (parcel_id)
left join {{ ref('dim_owner')    }} o  using (parcel_id)
left join {{ ref('dim_date')     }} d  on b.sale_date = d.full_date
