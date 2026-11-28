-- Purpose : Cumulative return per ticker from its first date, using log returns
-- Grain   : one row per ticker per day (view); one row per ticker (summary)
-- Question: Q06 - Cumulative Returns
-- Part 3: check for AAPL (the two numbers must match)
SELECT ROUND((MAX(close) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM stock_prices WHERE ticker='AAPL'))
            / MAX(close) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM stock_prices WHERE ticker='AAPL')) - 1) * 100, 2) AS simple_check_pct
FROM stock_prices WHERE ticker = 'AAPL';