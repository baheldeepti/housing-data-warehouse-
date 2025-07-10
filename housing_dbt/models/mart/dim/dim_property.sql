{{ config(materialized='table', schema='mart') }}

with ranked as (
    select
        *,
        row_number() over (
            partition by parcel_id
            order by sale_date desc nulls last   -- keep the most-recent attributes
        ) as rn
    from {{ ref('stg_nashville_housing') }}
)

select
    parcel_id,
    md5(parcel_id)                              as property_key,
    land_use,
    year_built,
    bedrooms,
    full_bath,
    half_bath,
    finished_area_sqft,
    grade,
    neighborhood_id,
    tax_district
from ranked
where rn = 1          -- one row per parcel
