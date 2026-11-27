# BlackRock Portfolio Performance & Volatility Tracker

Individual capstone project, Internmo (Financial Analyst).

## Data
Kaggle: https://www.kaggle.com/datasets/camnugent/sandp500
File used: all_stocks_5yr.csv (dataset not uploaded here)

## Day 1 reconciliation
- Total rows: 619,040
- Tickers: 505
- First date: 2013-02-08
- Last date: 2018-02-07
- Distinct trading days: 1,259
- Nulls in close / volume: 0 / 0
- trade_date type: date

## Tools
PostgreSQL 16, pgAdmin 4, Power BI Desktop

## Day 2 - Coverage check (Q01)
- Tickers in dataset: 505 (matches Day 1)
- 470 tickers have the full 1,259 trading days; 35 have fewer (late listings / spin-offs, e.g. APTV, DWDP, BHF)
- All tickers end on 2018-02-07
## Day 2 - Q02 to Q04
- Q02: daily_returns view (618,535 rows = 619,040 minus 505 first days)
- Q03: 50/200-day SMAs, shown only when the window is full (verified on ticker A: 1,210 and 1,060 filled rows)
- Q04: 2,903 Golden/Death Cross events; summaries by year, by ticker and latest signal per ticker (492 tickers had at least one cross; 13 had none)
