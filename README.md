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
- 
- ## Day 3: Q05 and Q06

### Q05 Signal Forward Returns
**File:** Q05_signal_forward_return.sql
**Method:** Detected Golden/Death Crosses (50/200-day SMA, full 200-day window only), then used LEAD(close, 20) and LEAD(close, 60) to get forward returns. Compared against the average of all days.

| Group | n (20d) | Avg 20d | % up 20d | n (60d) | Avg 60d | % up 60d |
|---|---|---|---|---|---|---|
| All days | 608,940 | 1.14% | 58.2% | 588,756 | 3.24% | 63.2% |
| Death Cross | 1,436 | 1.17% | 57.7% | 1,402 | 3.26% | 64.1% |
| Golden Cross | 1,411 | 0.48% | 53.7% | 1,341 | 2.60% | 62.9% |

**Conclusion:** Neither signal added useful information in this period. Golden Crosses were followed by returns about 0.65 pp below the all-days average, and Death Crosses were in line with it.

**Notes:** Events in the last 20/60 trading days have no forward price, so counts are lower. 2013-2018 was a strong bull market, so the baseline is high. Averages only, with no significance test. Price returns only, with survivorship bias.

### Q06 Cumulative Returns
**Files:** Q06_daily_cumulative_returns.sql, Q06_cumulative_return_summary.sql, Q06_aapl_check.sql, Q06_aapl_view_check.sql
**Method:** Daily log returns (first row per ticker excluded), then EXP(SUM(log_return) OVER (PARTITION BY ticker ORDER BY trade_date ROWS UNBOUNDED PRECEDING)) - 1. Saved as the view `cumulative_returns`.

**Why not add percentage returns?** Returns compound. +50% then -50% is a 25% loss, not 0%. Log returns add up correctly, and EXP(sum) - 1 converts back to a normal percentage.

**Top 5 five-year returns:** NVDA 1,749.64%, NFLX 923.33%, ALGN 615.95%, EA 608.41%, STZ 572.37%.

**Check:** AAPL cumulative return is 135.12% from both the view and a simple (last close / first close - 1) calculation. They match.

**Note:** 35 tickers have less than 5 years of history (Q01), so their returns cover a shorter window and are not directly comparable.
