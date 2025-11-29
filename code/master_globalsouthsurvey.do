/*******************************************************************************
* Master Do File: Global South Recognition Survey Replication Package
* 
* Project: Public Perceptions of the Global South in Latin America:
*          Cases of Brazil and Mexico
* Authors: Yuriko Takahashi, Kaori Baba, Kensuke Teshima
* Journal: Latin American Report, Vol. 43, No. 2, 2026
* 
* Last Updated: November 2025
* Status: Principal Component Analysis as Main Analytical Method
*******************************************************************************/

clear all
set more off
capture log close

* Note: Before running this master file, you must first run housekeeping.do
* to set up the global paths. See README.md for instructions.

* Start log file
log using "$basedir/master_log.txt", replace text

display "=========================================="
display "Global South Recognition Survey - Replication"
display "Working directory: $basedir"
display "Code directory: $code"
display "=========================================="

/*------------------------------------------------------------------------------
* Analysis Flow (Final Version)
* 1. Data Import and Merging
* 2. Data Cleaning
* 3. Variable Creation
* 4. Descriptive Statistics (using reversed variables)
* 5. Principal Component Analysis (Main Analysis) + Regression with PC Scores
*------------------------------------------------------------------------------*/

* STEP 1: Data Import and Merging
* Input: $raw/mexico.csv, $raw/brasil.csv
* Output: $created/globalsouthsurvey_raw.dta (1,862 observations)
display "STEP 1: Data Import and Merging"
do "${code}/read_survey.do"

* STEP 2: Data Cleaning
* Input: $created/globalsouthsurvey_raw.dta
* Output: $created/survey_cleaned.dta (Mexico: 734, Brazil: 722)
display "STEP 2: Data Cleaning"
do "${code}/clean_data.do"

* STEP 3: Variable Creation
* Input: $created/survey_cleaned.dta
* Output: $created/analysis_data.dta (creates dependent/independent variables, dummies)
display "STEP 3: Variable Creation"
do "${code}/create_variables.do"

* STEP 4: Descriptive Statistics (using reversed variables)
* Input: $created/analysis_data.dta
* Output: $tables/comparison_table_revised.xlsx (Table 1: Country Comparison)
*         $figures/globalsouth_responses_combined.png (Figure 2)
* Note: Attitude variables use reversed versions (q1_r, q2_*_r, etc.)
display "STEP 4: Descriptive Statistics (using reversed variables)"
do "${code}/summary_statistics_pcavariable.do"

* STEP 5: Principal Component Analysis (Main Analytical Method)
* Input: $created/analysis_data.dta
* Output: $tables/table_pca_mexico.txt (Table 2: Mexico PCA + Regression)
*         $tables/table_pca_brazil.txt (Table 3: Brazil PCA + Regression)
* Structure:
*   - Panel A: PCA Results (loadings, eigenvalues, variance explained)
*   - Panel B: Regression using PC scores (6 models)
display "STEP 5: Principal Component Analysis (Main Analysis)"
do "${code}/principal_component.do"

display "=========================================="
display "Analysis complete!"
display "Please check the following output files:"
display "  - Tables: $tables"
display "  - Figures: $figures"
display "=========================================="

* End log file
log close

* End of master do file
