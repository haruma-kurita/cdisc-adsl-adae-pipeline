# CDISC ADaM Derivation Pipeline: ADSL & ADAE

## Project Overview
This repository contains a SAS-based clinical trial data pipeline that transforms standard Study Data Tabulation Model (SDTM) datasets into analysis-ready Analysis Data Model (ADaM) datasets. The project specifically focuses on deriving the **Analysis Data Subject Level (ADSL)** and **Adverse Events Analysis (ADAE)** datasets in accordance with CDISC standards.

## Clinical Data Flow
The pipeline is divided into two sequential SAS scripts, representing the standard dependency of adverse event data on demographic baseline records.

### 1. `01_adsl.sas` (Subject Level Analysis Dataset)
* **Inputs:** `SDTM.DM` (Demographics), `SDTM.EX` (Exposure), `SDTM.DS` (Disposition)
* **Output:** `ADAM.ADSL`
* **Key Derivations:** 
  * Age categorization (`AGEGR1`).
  * Intent-to-Treat (`ITTFL`) and Safety (`SAFFL`) population flags.
  * Treatment Start/End dates (`TRTSDT`, `TRTEDT`) and Duration (`TRTDUR`) using `first.USUBJID` and `last.USUBJID` record compression.
  * Study completion status (`COMPLFL`).

### 2. `02_adae.sas` (Adverse Events Analysis Dataset)
* **Inputs:** `SDTM.AE` (Adverse Events), `ADAM.ADSL`
* **Output:** `ADAM.ADAE`
* **Key Derivations:**
  * Merges raw occurrences with the ADSL demographic roster.
  * Analysis Start Date (`ASTDT`) and Analysis Relative Day (`ASTDY`).
  * Treatment Emergent Flag (`TRTEMFL`), utilizing computationally safe handling of missing numeric dates to prevent false positive flags.
  * Enforces strict left-to-right column ordering via pre-merge `RETAIN` statements to perfectly match target metadata specifications.

## Technical Highlights & Programming Standards
* **Defensive Programming:** Implements `nmiss()` logic to safeguard date math and Boolean evaluations against standard SAS missing value behavior (e.g., preventing missing dates from evaluating as negative infinity).
* **Robust String Comparison:** Utilizes `upcase()` functions to standardize raw clinical text before evaluating condition logic.
* **Memory Management:** Leverages the `WORK` library for intermediate dataset generation (`ADSL01`, `ADSL02`) before committing final merged outputs to the permanent `ADAM` directory.
* **Version Control:** Repository managed via Git/GitHub, with a `.gitignore` configured to exclude raw `.sas7bdat` clinical data and log files, ensuring PHI/data privacy compliance and repository efficiency.

## Setup & Execution
To run this pipeline locally:
1. Clone this repository.
2. Ensure the local `sdtm` folder is populated with the requisite raw `.sas7bdat` files (`dm`, `ex`, `ds`, `ae`).
3. Update the macro variables `%let sdtm_path` and `%let adam_path` at the top of the scripts to match your local directory structure.
4. Execute `01_adsl.sas` first to generate the foundational demographic data, followed by `02_adae.sas`.

## Acknowledgments & AI Assistance
The implementation guidelines for this CDISC pipeline were developed using Google Gemini. Gemini was also utilized to check the SAS code for logical accuracy and CDISC compliance, and to generate this README documentation.
