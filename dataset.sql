CREATE TABLE stock_prices (
    trade_date DATE NOT NULL,
    open NUMERIC(12,4),
    high NUMERIC(12,4),
    low NUMERIC(12,4),
    close NUMERIC(12,4) NOT NULL,
    volume BIGINT NOT NULL,
    ticker VARCHAR(6) NOT NULL,
    PRIMARY KEY (ticker, trade_date)
);