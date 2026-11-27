SELECT ticker,
       COUNT(*) AS days,
       MIN(trade_date) AS first_date,
       MAX(trade_date) AS last_date
FROM stock_prices
GROUP BY ticker
ORDER BY days ASC;