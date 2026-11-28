-- Purpose : Cumulative return per ticker from its first date, using log returns
-- Grain   : one row per ticker per day (view); one row per ticker (summary)
-- Question: Q06 - Cumulative Returns

-- Part 1: daily series (view)
CREATE OR REPLACE VIEW cumulative_returns AS
WITH lr AS (
  SELECT ticker, trade_date, close,
         LN(close / LAG(close) OVER (PARTITION BY ticker ORDER BY trade_date)) AS log_return
  FROM stock_prices
),
valid AS (
  SELECT * FROM lr WHERE log_return IS NOT NULL
)
SELECT ticker, trade_date, close, log_return,
       EXP(SUM(log_return) OVER (PARTITION BY ticker ORDER BY trade_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) - 1 AS cum_return
FROM valid;