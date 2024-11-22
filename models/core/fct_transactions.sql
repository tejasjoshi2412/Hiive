{{ config(
    materialized="table",
    database="dbt_hiive",
    schema="core")
}}

with transactions as (
  select
      transaction_id,
      num_shares,
      price_per_share,
      gross_proceeds,
      transaction_duration_month,
      transaction_bid_accepted_at::date as transaction_bid_accepted_date,
      transaction_pending_approval_at::date transaction_pending_approval_date,
      transaction_closed_at::date transaction_closed_date

  from {{ ref('int_transactions_information_joined') }}
)

select
  *
from 
 transactions
