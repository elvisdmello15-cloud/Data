-- Purpose : Summaries of Golden/Death Cross events (Q04)
-- Grain   : see each query
-- Question: How many crosses happened per year and per ticker, and what was each ticker's latest signal?

-- Step 1: view that stores the cross events
CREATE OR REPLACE VIEW cross_events AS
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
    SELECT *, sma_50 - sma_200 AS spread,
           LAG(sma_50 - sma_200) OVER (PARTITION BY ticker
                                       ORDER BY trade_date) AS prev_spread
    FROM sma
)
SELECT ticker, trade_date, close, sma_50, sma_200,
       CASE WHEN prev_spread <= 0 AND spread > 0 THEN 'Golden Cross'
            ELSE 'Death Cross' END AS signal
FROM spread
WHERE (prev_spread <= 0 AND spread > 0)
   OR (prev_spread >= 0 AND spread < 0);

-- Step 2: events by year
SELECT EXTRACT(YEAR FROM trade_date)::int AS year, signal, COUNT(*) AS events
FROM cross_events
GROUP BY 1, 2
ORDER BY 1, 2;

-- Step 3: events by ticker
SELECT ticker, signal, COUNT(*) AS events
FROM cross_events
GROUP BY ticker, signal
ORDER BY ticker, signal;

-- Step 4: most recent signal per ticker
SELECT DISTINCT ON (ticker) ticker, trade_date, signal
FROM cross_events
ORDER BY ticker, trade_date DESC;