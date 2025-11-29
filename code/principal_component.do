/*******************************************************************************
* Principal Component Analysis and Regression Analysis
* 
* Purpose: Conduct principal component analysis on demographic and attitude
*          variables, then use component scores in regression analysis
* Output: Table 2 (Brazil) and Table 3 (Mexico)
*******************************************************************************/

// ==============================================================================
// Data Preparation
// ==============================================================================

use "${created}analysis_data.dta", replace

// Create reversed variables for consistency
capture drop q1_r q2_1_r q2_2_r q2_3_r q2_4_r q3_r q5_r q7_r

gen q1_r = 6 - q1       // 政権評価（反転後：高いほど肯定的）
gen q2_1_r = 6 - q2_1   // 米国重要性（反転後：高いほど重要）
gen q2_2_r = 6 - q2_2   // EU重要性
gen q2_3_r = 6 - q2_3   // 中国重要性
gen q2_4_r = 6 - q2_4   // 相手国重要性
gen q3_r = 6 - q3       // 国際機関（反転後：高いほど代表されている）
gen q5_r = 6 - q5       // BRICS重要性（反転後：高いほど重要）
gen q7_r = 4 - q7       // 対中経済関係評価（反転後：高いほど肯定的）

// Variable lists for PCA
local demographics "female age_1 age_2 age_4 age_5 edu_1 edu_2 edu_4 edu_5 inc_1 inc_3"

// ==============================================================================
// Table 2: Brazil - Principal Component Analysis and Regression
// ==============================================================================

display "=========================================="
display "Table 2: Brazil Analysis"
display "=========================================="

// Principal Component Analysis for Brazil (country==2)
pca `demographics' q1_r q2_1_r q2_2_r q2_3_r q2_4_r q3_r q5_r q6_1 q6_2 q6_3 q6_4 q7_r if country==2

// Generate principal component scores
predict pc1-pc10, score

// Label principal components
label variable pc1 "第1主成分：政権支持・新興国重視"
label variable pc2 "第2主成分：社会経済的地位"
label variable pc3 "第3主成分：バランス型国際協調志向"

// Clear previous estimation results
eststo clear

// Regression Analysis - Global South Recognition (2 models)
eststo b1: quietly dprobit gs_know pc1-pc10 if country==2, robust
eststo b2: quietly dprobit gs_any pc1-pc10 if country==2, robust

// Regression Analysis - Global South Role Evaluation (2 models)
eststo b3: quietly dprobit gs_strong pc1-pc10 if country==2, robust
eststo b4: quietly dprobit gs_agree pc1-pc10 if country==2, robust

// Export results for Brazil (Table 2)
esttab b1 b2 b3 b4 using "${tables}table_pca_brazil.txt", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    star(* 0.1 ** 0.05 *** 0.01) ///
    title("表2：主成分分析とグローバルサウス認知・役割分析（ブラジル）") ///
    mtitles("知っている" "知っている+聞いた" "強く同意" "強く同意+同意") ///
    label ///
    stats(N, labels("観測数") fmt(0)) ///
    legend ///
    addnotes("注：(1)(2)(3)(4)はすべて限界効果を表示。()内はロバスト標準誤差。") ///
    fixed

display "Brazil analysis complete. Results saved to: ${tables}table_pca_brazil.txt"

// Clean up
capture drop pc1-pc10

// ==============================================================================
// Table 3: Mexico - Principal Component Analysis and Regression
// ==============================================================================

display "=========================================="
display "Table 3: Mexico Analysis"
display "=========================================="

// Principal Component Analysis for Mexico (country==1)
pca `demographics' q1_r q2_1_r q2_2_r q2_3_r q2_4_r q3_r q5_r q6_1 q6_2 q6_3 q6_4 q7_r if country==1

// Generate principal component scores
predict pc1-pc10, score

// Label principal components
label variable pc1 "第1主成分：バランス型国際協調志向"
label variable pc2 "第2主成分：政権支持・新興国重視"
label variable pc3 "第3主成分：中立・非同盟志向"

// Clear previous estimation results
eststo clear

// Regression Analysis - Global South Recognition (2 models)
eststo m1: quietly dprobit gs_know pc1-pc10 if country==1, robust
eststo m2: quietly dprobit gs_any pc1-pc10 if country==1, robust

// Regression Analysis - Global South Role Evaluation (2 models)
eststo m3: quietly dprobit gs_strong pc1-pc10 if country==1, robust
eststo m4: quietly dprobit gs_agree pc1-pc10 if country==1, robust

// Export results for Mexico (Table 3)
esttab m1 m2 m3 m4 using "${tables}table_pca_mexico.txt", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    star(* 0.1 ** 0.05 *** 0.01) ///
    title("表3：主成分分析とグローバルサウス認知・役割分析（メキシコ）") ///
    mtitles("知っている" "知っている+聞いた" "強く同意" "強く同意+同意") ///
    label ///
    stats(N, labels("観測数") fmt(0)) ///
    legend ///
    addnotes("注：(1)(2)(3)(4)はすべて限界効果を表示。()内はロバスト標準誤差。") ///
    fixed

display "Mexico analysis complete. Results saved to: ${tables}table_pca_mexico.txt"

// Clean up
capture drop pc1-pc10

display "=========================================="
display "Principal Component Analysis Complete"
display "Table 2 (Brazil): ${tables}table_pca_brazil.txt"
display "Table 3 (Mexico): ${tables}table_pca_mexico.txt"
display "=========================================="
