{{ config(
    materialized="view",
    database="dbt_hiive",
    schema="intermediate")
}}

with source as (
  select 
    transaction_id, 
    min(case when transaction_state = 'bid_accepted' then transaction_transitioned_at else null end) as transaction_bid_accepted_at,
    min(case when transaction_state = 'pending_approval' then transaction_transitioned_at else null end) as transaction_pending_approval_at,
    min(case when transaction_state in ('expired','closed_paid','cancelled','approval_declined') then transaction_transitioned_at else null end) as transaction_closed_at,

  from  {{ ref('stg_transaction_transitions_mock_data') }}

  group by 1 
)

select 
  transaction_id,
  transaction_bid_accepted_at,
  transaction_pending_approval_at,
  transaction_closed_at,
  datediff(month,transaction_bid_accepted_at, transaction_closed_at) as transaction_duration_month

from source