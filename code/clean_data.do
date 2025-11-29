********************************************************************************
* 調査データクリーニングファイル
* 作成日: 2025年9月
* ファイル名: clean_data.do
* 前提: read_survey.do 実行後、またはsurvey_raw.dtaが存在すること
********************************************************************************

* ==============================================================================
* 0. 初期設定とデータ確認
* ==============================================================================
clear all
set more off

* データ読み込み（メモリにない場合はファイルから）

use "${created}globalsouthsurvey_raw.dta", clear

* データ確認
display "=========================================="
display "クリーニング開始"
display "初期観測数: " _N
tab country
display "=========================================="

* ==============================================================================
* 1. 重複の確認と除去
* ==============================================================================
* 国別に処理
foreach c in 1 2 {
    preserve
    keep if country == `c'
    
    * 重複確認
    duplicates report responseid
    
    * 重複がある場合、最新の回答を残す
    gsort responseid -recordeddate
    duplicates drop responseid, force
    
    tempfile country_`c'
    save `country_`c''
    restore
}

* 国別データを再統合
use `country_1', clear
append using `country_2'

display "重複除去後の観測数: " _N


* ==============================================================================
* 2. 回答時間チェック
* ==============================================================================
* 極端に短い（60秒未満）または長い（600秒=10分超）回答にフラグ
gen duration_problematic = 0
replace duration_problematic = 1 if durationinseconds < 60 | durationinseconds > 600
label variable duration_problematic "問題のある回答時間"

tab duration_problematic country, row

* ==============================================================================
* 3. ストレートライナー（同一回答）チェック
* ==============================================================================
* 各選択肢を何回選んだかカウント
forval v = 1/6 {
    egen count_`v' = anycount(q1 q2_1 q2_2 q2_3 q2_4 q3 q5 q6 q7 q8), values(`v')
}

* 最も多く選んだ回数を取得
egen max_same = rowmax(count_1 count_2 count_3 count_4 count_5 count_6)

* ストレートライナーフラグ（10問中8問以上同じ）
gen straightliner = 0
replace straightliner = 1 if max_same >= 8
label variable straightliner "ストレートライナー"

tab straightliner country, row

* 一時変数削除
drop count_* max_same

* ==============================================================================
* 4. 「わからない」回答の処理
* ==============================================================================
* わからない回答のカウント
gen dontknow_count = 0
replace dontknow_count = dontknow_count + 1 if f4 == 9
replace dontknow_count = dontknow_count + 1 if q2_2 == .
replace dontknow_count = dontknow_count + 1 if q3 == 6
replace dontknow_count = dontknow_count + 1 if q5 == 6
replace dontknow_count = dontknow_count + 1 if q6 == 5
replace dontknow_count = dontknow_count + 1 if q7 == 4



* フラグ作成（1つでもわからないがある）
gen dontknow_flag = 0
replace dontknow_flag = 1 if dontknow_count >= 1
label variable dontknow_flag "わからない回答あり"

tab dontknow_flag country, row
tab dontknow_count country if dontknow_flag == 1

* 一時変数削除
drop dontknow_count

* ==============================================================================
* 5. 論理チェック
* ==============================================================================
* q8とq8s1/q8s2の整合性確認
* q8=1,2の場合はq8s1、q8=3の場合はq8s2に回答すべき
gen logic_error = 0
replace logic_error = 1 if (q8 <= 2 & !missing(q8s2))
replace logic_error = 1 if (q8 == 3 & !missing(q8s1))
label variable logic_error "論理エラー"

tab logic_error country, row

* ==============================================================================
* 6. フラグに基づく除外処理
* ==============================================================================
* 除外前の観測数を記録
local n_before = _N

* 問題のある回答を除外
keep if straightliner == 0 & duration_problematic == 0
display "ストレートライナーと問題時間除去後: " _N

* 論理エラーも除外する場合（オプション）
* drop if logic_error == 1
* display "論理エラー除去後: " _N

* わからない回答の除外（回帰分析用、オプション）
keep if dontknow_flag == 0
display "わからない除去後: " _N

local n_after = _N
display "除外された観測数: " (`n_before' - `n_after')
display "除外率: " round((`n_before' - `n_after')/`n_before' * 100, 0.1) "%"

tab country


* データ保存
save "${created}survey_cleaned.dta", replace
