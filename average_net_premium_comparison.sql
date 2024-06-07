-- Assumptions: A new policy is the first policy for a user (policy_rank = 1), 
-- and a returning policy is the second or subsequent policy (policy_rank > 1).
-- The `total_amount` column in the `invoice` table represents the net premium received.
-- The `effective_date` column in the `policy` table indicates the order of policies.

WITH policy_rank AS (
    SELECT
        p.user_id,
        p.policy_number,
        ROW_NUMBER() OVER (PARTITION BY p.user_id ORDER BY p.effective_date) AS policy_rank
    FROM
        policy p
),
invoice_data AS (
    SELECT
        i.policy_number,
        i.total_amount
    FROM
        invoice i
),
policy_invoice AS (
    SELECT
        pr.user_id,
        pr.policy_number,
        pr.policy_rank,
        id.total_amount
    FROM
        policy_rank pr
    JOIN
        invoice_data id ON pr.policy_number = id.policy_number
)
SELECT
    CASE
        WHEN policy_rank = 1 THEN 'New Policy'
        ELSE 'Returning Policy'
    END AS policy_type,
    AVG(total_amount) AS average_net_premium
FROM
    policy_invoice
GROUP BY
    policy_type;
