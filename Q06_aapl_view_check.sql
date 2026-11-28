SELECT ticker, trade_date, ROUND(cum_return * 100, 2) AS cum_return_pct
FROM cumulative_returns
WHERE ticker = 'AAPL'
ORDER BY trade_date DESC
LIMIT 1;