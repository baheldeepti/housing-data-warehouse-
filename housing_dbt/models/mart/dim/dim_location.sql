{{ config(materialized='table', schema='mart') }}

select distinct
    neighborhood_id,
    property_city,
    tax_district
from {{ ref('stg_nashville_housing') }}