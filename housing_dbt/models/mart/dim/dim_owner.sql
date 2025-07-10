{{ config(materialized='table', schema='mart') }}

with owners as (
    select distinct
        parcel_id,
        coalesce(owner_name, 'UNKNOWN')         as owner_name_clean,
        owner_address,
        owner_city,
        owner_state
    from {{ ref('stg_nashville_housing') }}
)

select
    parcel_id,
    md5(parcel_id || owner_name_clean)         as owner_key,    -- guaranteed not NULL
    owner_name_clean  as owner_name,
    owner_address,
    owner_city,
    owner_state
from owners
