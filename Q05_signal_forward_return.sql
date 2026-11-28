-- Purpose : Do Golden/Death Crosses add information about 20/60-day forward returns?
-- Grain   : one row per group (Golden Cross, Death Cross, All days)
-- Question: Q05 - Signal Forward Returns
WITH base AS (
  SELECT ticker, trade_date, close,
         AVG(close)  OVER w50  AS sma50,
         COUNT(*)    OVER w50  AS n50,
         AVG(close)  OVER w200 AS sma200,
         COUNT(*)    OVER w200 AS n200,
         LEAD(close,20) OVER t AS close_20,
         LEAD(close,60) OVER t AS close_60
  FROM stock_prices
  WINDOW t   AS (PARTITION BY ticker ORDER BY trade_date),
         w50 AS (PARTITION BY ticker ORDER BY trade_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),
         w200 AS (PARTITION BY ticker ORDER BY trade_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
),
spread AS (
  SELECT *,
         CASE WHEN n200 = 200 THEN sma50 - sma200 END AS spread
  FROM base
),
signals AS (
  SELECT *,
         LAG(spread) OVER (PARTITION BY ticker ORDER BY trade_date) AS prev_spread
  FROM spread
),
tagged AS (
  SELECT ticker, trade_date,
         CASE WHEN spread > 0 AND prev_spread <= 0 THEN 'Golden Cross'
              WHEN spread < 0 AND prev_spread >= 0 THEN 'Death Cross'
              ELSE 'All days' END AS grp,
         close_20 / close - 1 AS fwd_20,
         close_60 / close - 1 AS fwd_60
  FROM signals
),
combined AS (
  SELECT grp, fwd_20, fwd_60 FROM tagged WHERE grp <> 'All days'
  UNION ALL
  SELECT 'All days', fwd_20, fwd_60 FROM tagged   -- unconditional baseline
)
SELECT grp,
       COUNT(fwd_20)                          AS n_20d,
       ROUND(AVG(fwd_20)*100, 2)              AS avg_20d_pct,
       ROUND(AVG((fwd_20 > 0)::int)*100, 1)   AS pct_positive_20d,
       COUNT(fwd_60)                          AS n_60d,
       ROUND(AVG(fwd_60)*100, 2)              AS avg_60d_pct,
       ROUND(AVG((fwd_60 > 0)::int)*100, 1)   AS pct_positive_60d
FROM combined
GROUP BY grp
ORDER BY grp;