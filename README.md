# CDISC ADaM Pipeline (SDTM to ADSL & ADAE)

## Project Overview
This repository contains a complete, end-to-end clinical SAS programming workflow that translates raw Study Data Tabulation Model (SDTM) datasets into CDISC-compliant Analysis Data Model (ADaM) datasets. The objective is to demonstrate industry-standard data derivation, merging techniques, and documentation practices used in clinical trials. 

## Project Status: In Progress
* **Phase 1 (Setup):** Complete. `00_setup.sas` unpacks raw FDA-standard `.xpt` transport files into native `.sas7bdat` format.
* **Phase 2 (ADSL Build):** In development. `01_adsl_derivation.sas` is currently being written to establish the foundational Analysis Data Subject Level master roster, merging demographics, treatment dates, and population flags from `DM`, `EX`, and `DS` domains.
* **Phase 3 (ADAE Build):** Pending. `02_adae_derivation.sas` will merge the completed ADSL with the raw `AE` domain to derive treatment-emergent adverse event flags and relative timing variables.

## Repository Structure
```text
cdisc-adsl-adae-pipeline/
├── adam/                                  # Final ADaM datasets (adsl, adae)
├── programs/                              # SAS programs for data derivation
│   ├── 00_setup.sas
│   └── 01_adsl_derivation.sas             # (In Progress)
├── sdtm/                                  # Raw CDISC SDTM datasets (dm, ex, ds, ae)
├── ADaM_Pipeline_Specifications.xlsx      # Central derivation specification document
├── .gitignore                             # Excludes SAS system logs and lock files
└── README.md
```

## Note on Data Privacy & Version Control
The datasets included in this repository are public, anonymized mock CDISC Pilot data. The `.sas7bdat` files are included directly in the repository solely for portfolio convenience, allowing reviewers to clone the repository and run the code instantly without hunting for source files. In a true clinical production environment, raw patient data files are strictly excluded from version control to maintain HIPAA and GCP compliance. 

## Acknowledgments
* **AI Assistance:** Google Gemini was utilized to architect the standard `ADaM_Pipeline_Specifications.xlsx` document and served as a secondary code review assistant for SAS syntax and macro resolution troubleshooting.
