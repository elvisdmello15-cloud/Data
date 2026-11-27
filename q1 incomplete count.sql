SELECT COUNT(*) FILTER (WHERE days = 1259) AS full_history,
       COUNT(*) FILTER (WHERE days < 1259) AS incomplete
FROM (SELECT ticker, COUNT(*) AS days
      FROM stock_prices
      GROUP BY ticker) t;