SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT ticker) AS tickers,
       MIN(trade_date) AS first_date,
       MAX(trade_date) AS last_date,
       COUNT(DISTINCT trade_date) AS trading_days,
       COUNT(*) - COUNT(close) AS null_close,
       COUNT(*) - COUNT(volume) AS null_volume,
       pg_typeof(MIN(trade_date))::text AS date_type
FROM stock_prices;