-- Purpose : Detect Golden Cross / Death Cross events (50d vs 200d SMA)
-- Grain   : one row per ticker per cross event
-- Question: When did each stock's short-term trend cross its long-term trend?
WITH sma AS (
    SELECT ticker, trade_date, close,
           CASE WHEN COUNT(*) OVER w50 = 50
                THEN AVG(close) OVER w50 END   AS sma_50,
           CASE WHEN COUNT(*) OVER w200 = 200
                THEN AVG(close) OVER w200 END  AS sma_200
    FROM stock_prices
    WINDOW w50  AS (PARTITION BY ticker ORDER BY trade_date
                    ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),
           w200 AS (PARTITION BY ticker ORDER BY trade_date
                    ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
), spread AS (
    SELECT *,
           sma_50 - sma_200 AS spread,
           LAG(sma_50 - sma_200) OVER (PARTITION BY ticker
                                       ORDER BY trade_date) AS prev_spread
    FROM sma
)
SELECT ticker, trade_date, close, sma_50, sma_200,
       CASE WHEN prev_spread <= 0 AND spread > 0 THEN 'Golden Cross'
            ELSE 'Death Cross' END AS signal
FROM spread
WHERE (prev_spread <= 0 AND spread > 0)
   OR (prev_spread >= 0 AND spread < 0)
ORDER BY ticker, trade_date;