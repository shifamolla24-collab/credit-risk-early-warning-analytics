# Key Business Insights

## Portfolio Snapshot

- Total customers: 2,500
- Total loans: 3,500
- Payment records: 8,500
- Transaction records: 6,500
- Approximate loan exposure: 297.08M
- Approximate customer-level profit: 13.78M
- Approximate customer-level credit loss: 9.98M


## Customer Profitability

The dataset contains 2,500 customers.

Total customer-level profit is approximately 13.78M.

Average customer profit is approximately 5,510.58.

Approximately 1,262 customers are above the overall average customer-profit level.

### Interpretation

Customer profitability is not evenly distributed across the customer base.

This supports customer-level profitability analysis rather than relying only on portfolio-level totals.

## Customer Segment Analysis

| Segment | Customers | Profit | Profit Share | Default Rate |

| Subprime | 965 | 5.34M | 38.76% | 1.55% |
| Standard | 818 | 4.46M | 32.40% | 0.61% |
| Premium | 717 | 3.97M | 28.84% | 1.12% |

### Interpretation

The Subprime segment generated the largest share of customer-level profit in the supplied dataset.

It also had the highest observed customer-level default rate among the three customer segments.

This highlights the importance of evaluating customer profitability together with credit risk.



## Risk Score Analysis

| Risk Band | Customers | Default Rate |

| Low | 1,121 | 0.00% |
| Moderate | 630 | 0.63% |
| High | 729 | 0.96% |
| Very High | 20 | 85.00% |

### Interpretation

The Very High risk group is small but has a substantially higher observed default rate than the other risk groups.

This population is therefore useful for risk-monitoring and early-warning analysis.



## Delinquency Analysis

| DPD Band | Customers | Default Rate |

| Current | 1,332 | 0.00% |
| 1–30 DPD | 860 | 0.00% |
| 31–60 DPD | 155 | 0.00% |
| 61–90 DPD | 79 | 0.00% |
| 90+ DPD | 74 | 37.84% |

### Interpretation

The 90+ DPD population has a substantially higher observed default rate.

Severe delinquency is therefore an important dimension for early-warning monitoring.


## Debt-to-Income Analysis

| DTI Band | Customers | Default Rate |

| Low | 979 | 0.31% |
| Moderate | 87 | 1.15% |
| High | 80 | 1.25% |
| Very High | 1,354 | 1.70% |

### Interpretation

Observed default rates increase across the DTI bands in this dataset.

DTI can therefore be used as one component of a broader risk-monitoring framework.



## Utilization Analysis

| Utilization Band | Customers | Default Rate |

| Low | 693 | 0.14% |
| Moderate | 84 | 1.19% |
| High | 63 | 1.59% |
| Very High | 1,660 | 1.51% |

### Interpretation

The Low utilization group has the lowest observed default rate.

Higher utilization groups show higher observed default rates, although the relationship is not perfectly monotonic.

Utilization should therefore be interpreted together with other risk indicators.



## Credit Score Analysis

| Credit Score Band | Default Rate |

| Poor | 0.83% |
| Fair | 1.72% |
| Good | 0.68% |
| Very Good | 1.06% |
| Excellent | 1.21% |

### Interpretation

Observed default rates are not strictly monotonic across the credit-score bands.

This supports combining credit score with risk score, DTI, utilization, delinquency and payment behavior.



## Loan Exposure

| Loan Type | Loans | Loan Amount | Default Rate |

| Home | 1,214 | 191.55M | 0.66% |
| Personal | 1,067 | 25.04M | 1.22% |
| Auto | 685 | 22.88M | 0.44% |
| Business | 347 | 49.45M | 0.86% |
| Education | 187 | 8.16M | 0.53% |

### Interpretation

Home loans represent the largest loan exposure.

Personal loans have the highest observed default rate among the listed loan types.

Loan exposure and default rate therefore provide different views of portfolio risk.



## Geographic Concentration

| Country | Customers | Profit Share | Default Rate |

| USA | 1,934 | 78.49% | 1.19% |
| India | 375 | 13.72% | 1.07% |
| UK | 191 | 7.79% | 0.52% |

### Interpretation

The USA represents the largest customer and profit concentration in the dataset.

Geographic concentration is therefore an important portfolio dimension.



## Profitable and High-Risk Customers

Using Risk Score >= 71 as the high-risk threshold:

- 325 customers were classified as high risk.
- 152 customers were both high risk and above average in customer profit.
- These 152 customers represented approximately 1.46M in customer profit.
- They also represented approximately 0.50M in credit loss.

### Interpretation

Customer value and credit risk can coexist.

A customer may contribute significant profit while also carrying elevated credit risk.

This makes profitable high-risk customers an important monitoring population.



# Overall Analytical Themes

## Theme 1 — Profitability concentration

Customer profitability is concentrated across a subset of customers.

## Theme 2 — Risk concentration

The highest-risk and severe-delinquency groups show substantially higher observed default rates.

## Theme 3 — Exposure versus default

The loan type with the largest exposure is not necessarily the loan type with the highest default rate.

## Theme 4 — Multi-factor risk analysis

Credit score alone does not fully describe observed default behavior.

## Theme 5 — Value versus risk

Some profitable customers also carry elevated risk, making combined customer-value and risk analysis useful.


# Interpretation Note

These findings are descriptive observations from the supplied dataset.

They identify patterns, concentrations and associations within the dataset.

They do not establish causal relationships and should not be interpreted as financial advice or as a real-world credit policy.
