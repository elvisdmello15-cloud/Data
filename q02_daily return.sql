-- Purpose : Daily % return and log return per ticker, saved as a view
-- Grain   : one row per ticker per trading day (first day of each ticker excluded)
-- Question: How much did each stock move each day?
CREATE OR REPLACE VIEW daily_returns AS
WITH prev AS (
    SELECT ticker,
           trade_date,
           close,
           LAG(close) OVER (PARTITION BY ticker
                            ORDER BY trade_date) AS prev_close
    FROM stock_prices
)
SELECT ticker,
       trade_date,
       close,
       prev_close,
       (close - prev_close) / prev_close AS daily_return,
       LN(close / prev_close)            AS log_return
FROM prev
WHERE prev_close IS NOT NULL;