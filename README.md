# HAIC — 26-cohort **conditional** evidence expansion

Generated 3 November 2026 from preserved 481-row R registry and recovered public source tables.

## Headline conditional arithmetic
- k = 26 distinct registered cohorts, enrolled participants summed = 4600 (not a verified contrast-level N)
- REML + Knapp–Hartung (Python reimplementation): g=0.5713; 95% CI [0.0042, 1.1384], tau²=1.7327, I²=98.6%.
- Previous k=22 sensitivity: g=0.6197, CI [-0.0627,1.3022].
- Lower-assumption k=18: g=0.2713, CI [-0.2070,0.7496].
- Egger classic SND intercept=1.6078, p=0.6407; Rosenthal FSN 1664.

## 4 newly mapped cohorts (2 reports)
- S0007 Doshi & Hauser: 293 **writer** sample, five-AI idea arm (n=100) vs no AI (n=98). Table S3 beta 0.311 and SE 0.087 estimated on repeated evaluator judgments (3,519 judgments). Conversion to a two-arm t-derived standardized effect is an **assumption-sensitive approximation** and *not* a directly validated writer-level SMD. Source: https://doi.org/10.1126/sciadv.adn5290 ; source tables: https://www.scribd.com/document/806384881/sciadv-adn5290 ; dataset: https://doi.org/10.5061/dryad.qfttdz0pm.
- S0014 Fisher — Entrepreneurship and Marketing analysed total 202 (based on F(1,198)), Management analysed 122 (F(1,120)). **No cohort-by-arm counts verified.** We imposed 50/50, 51/51 and 61/61 allocation for an explicitly conditional model. Table parenthetical precision interpreted as *SE* and SD=SE sqrt(n). Source: https://doi.org/10.1080/03075079.2025.2515512 . Do not misrepresent 1190 originally recruited as the 324 analysis N.

## Why k=26 is not a verified k≥25 primary model
The previously reconstructed 22 includes confidence-interval standardized approximations, inferred covariance designs, and extreme estimates. The extra four use unverified Fisher arm allocations or a nested-rater regression-derived proxy. Model results therefore belong in sensitivity work until valid writer-level SD and discipline arm counts are recovered. Even when the numeric row count meets 25, it does not meet a source-verified criterion.

## Reproduce in RStudio
From this folder:
```
source("R/33_conditional_26_reml.R")
```
Install `metafor` if necessary. `outputs/conditional26` contains study weights, forest/funnel plots, REML/HKSJ, leave-one-out, subgroup fits, Egger, fail-safe N, Duval–Tweedie trim-and-fill and sessionInfo.

## GitHub provenance and copyright
`data/underlying_source_effects_481.csv` preserves original effect extractions; `data/analysis_26_cohorts_CONDITIONAL.csv` holds analysis assumptions; `results/` outputs Python calculations. No source PDF is included, no original `approval_status` or gate field changed. Each conditional estimate explicitly states its assumptions.
