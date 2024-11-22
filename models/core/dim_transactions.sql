{{ config(
    materialized="table",
    database="dbt_hiive",
    schema="core")
}}

with transactions as (
    select
      transaction_id,
      bid_id,
      company_id,
      current_transaction_state,
      transfer_method,
      termination_reason,
      transaction_bid_accepted_at::date as transaction_bid_accepted_date,
      transaction_pending_approval_at::date transaction_pending_approval_date,
      transaction_closed_at::date transaction_closed_date

    from {{ ref('int_transactions_information_joined') }}
)

select 
  * 
from transactions
