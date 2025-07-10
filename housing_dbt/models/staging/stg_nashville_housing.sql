{{ config(
    materialized = 'view',
    schema       = 'staging'
) }}

with source as (

    -- raw table
    select *
    from {{ ref('nashville_model') }}

), renamed as (

    -- rename + basic casts
    select
        "unnamed:_0.1"                        :: bigint          as row_id_1,
        "unnamed:_0"                          :: bigint          as row_id_2,
        parcel_id                             :: text            as parcel_id,
        upper(trim(land_use))                 :: text            as land_use,
        trim(property_address)                :: text            as property_address,
        "suite/_condo___#"                    :: text            as suite_condo_no,
        initcap(property_city)                :: text            as property_city,
        sale_date                             :: date            as sale_date_raw,      -- keep raw for audit
        sale_date::date                       as sale_date,
        sale_price                            :: bigint          as sale_price,
        legal_reference                       :: text            as legal_reference,
        upper(trim(sold_as_vacant))           :: text            as sold_as_vacant_raw,
        case
            when upper(trim(sold_as_vacant)) in ('YES','Y','1','TRUE') then 'Y'
            when upper(trim(sold_as_vacant)) in ('NO','N','0','FALSE') then 'N'
            else null
        end                                                    as sold_as_vacant,
        upper(trim(multiple_parcels_involved_in_sale))         as multi_parcel_flag_raw,
        case
            when multiple_parcels_involved_in_sale ~* 'y|yes|true|1' then 'Y'
            when multiple_parcels_involved_in_sale ~* 'n|no|false|0' then 'N'
            else null
        end                                                    as multi_parcel_flag,
        initcap(trim(owner_name))             :: text            as owner_name,
        trim(address)                         :: text            as owner_address,
        initcap(city)                         :: text            as owner_city,
        upper(state)                          :: text            as owner_state,
        acreage                               :: double precision as acreage,
        tax_district                          :: text            as tax_district,
        neighborhood                          :: double precision as neighborhood_id,
        image                                 :: text            as image_url,
        land_value                            :: double precision as land_value,
        building_value                        :: double precision as building_value,
        total_value                           :: double precision as total_value,
        finished_area                         :: double precision as finished_area_sqft,
        foundation_type                       :: text            as foundation_type,
        year_built::int                                           as year_built,
        exterior_wall                         :: text            as exterior_wall,
        grade                                 :: text            as grade,
        bedrooms::int                                             as bedrooms,
        full_bath::int                                            as full_bath,
        half_bath::int                                            as half_bath
    from source

), filtered as (

    select *
    from renamed
    where
        parcel_id is not null
      and parcel_id <> ''
      and sale_price > 0
      and sale_date between date '1990-01-01' and current_date
      and (bedrooms is null or bedrooms between 0 and 20)
      and (full_bath is null or full_bath between 0 and 20)
      and (half_bath is null or half_bath between 0 and 20)

)

select * from filtered
