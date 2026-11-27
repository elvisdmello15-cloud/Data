-- Purpose : 50-day and 200-day simple moving averages of close
-- Grain   : one row per ticker per trading day
-- Question: Where is each stock's price relative to its trend?
SELECT ticker,
       trade_date,
       close,
       CASE WHEN COUNT(*) OVER w50 = 50
            THEN AVG(close) OVER w50 END   AS sma_50,
       CASE WHEN COUNT(*) OVER w200 = 200
            THEN AVG(close) OVER w200 END  AS sma_200
FROM stock_prices
WINDOW w50  AS (PARTITION BY ticker ORDER BY trade_date
                ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),
       w200 AS (PARTITION BY ticker ORDER BY trade_date
                ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
ORDER BY ticker, trade_date;