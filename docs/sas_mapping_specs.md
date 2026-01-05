# Financial Mapping Specifications (Standardized Audit Schema)

## Overview
This document defines the logic used to transform proprietary General Ledger (G/L) accounts from Dynamics 365 Business Central into a **Standardized Audit Schema (SAS)**. 

Using a standardized schema ensures that financial data is portable across different cloud providers and is immediately ready for automated "Continuous Audit" tools.


## Mapping Logic & Taxonomy
Internal Dutch ERP terms are mapped to the following international financial classifications:

| ERP Category | Source Term (NL) | Global Classification | Standard Code |
| :--- | :--- | :--- | :--- |
| 1000..1099 | Voorraden | **Inventory** | `BEveVrdVor` |
| 2000..2099 | Debiteuren | **Accounts Receivable** | `BDebDebHan` |
| 3000..3099 | Bank / Kas | **Cash & Equivalents** | `BCasKas` |
| 4000..4999 | Omzet | **Revenue** | `WBedOmzNet` |
| 7000..7099 | Lonen | **Payroll & Wages** | `WBedLonSal` |

## Transformation Rules
1. **Normalization:** All proprietary ERP account structures are flattened into a unified Level 4 (Sub-ledger) format.
2. **Closing Logic:** System-generated "Year-End Closing" entries are filtered to ensure transaction volume accuracy for audit sampling.
3. **Validation Gate:** Any ledger entry missing a valid Standard Code is blocked by the **Sentinel Governance Engine** until reconciled.
