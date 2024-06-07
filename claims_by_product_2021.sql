SELECT
    p.product,
    COUNT(c.id) AS number_of_claims
FROM
    claim c
JOIN
    policy p ON c.policy_number = p.policy_number
WHERE
    strftime('%Y', c.submit_date) = '2021'
GROUP BY
    p.product;


