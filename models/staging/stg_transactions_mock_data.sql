{{ config(
    materialized="view",
    database="dbt_hiive",
    schema="staging")
}}

with source as (
  select
    md5(id) as transaction_id,
    md5(bid_id) as bid_id,
    md5(company_id) as company_id,
    state as current_transaction_state,
    transfer_method,
    num_shares::integer as num_shares,
    price_per_share::integer as price_per_share,
    gross_proceeds::integer as gross_proceeds,
    inserted_at::timestamp as inserted_at

    from {{ source('transactions', 'transactions_mockdata') }}
)

select 
  * 
from 
  source