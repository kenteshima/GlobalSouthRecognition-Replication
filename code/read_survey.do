********************************************************************************
* メキシコ・ブラジル調査データ読み込みファイル
* 作成日: 2025年9月
* ファイル名: read_survey.do
* 
* 目的: メキシコとブラジルの調査データを読み込み、ラベル設定後に統合
********************************************************************************

* ==============================================================================
* 0. 初期設定
* ==============================================================================
clear all
set more off


* ==============================================================================
* PART A: メキシコデータの読み込みとラベル設定
* ==============================================================================
import delimited "${raw}mexico.csv", clear

display "メキシコ初期観測数: " _N

* 国識別変数の追加
gen country = 1
label variable country "国"

* 変数ラベルの設定
label variable f1 "性別"
label variable f2 "年齢"
label variable f3 "教育水準"
label variable f4 "世帯月収（最低賃金倍数）"
label variable q1 "政権評価"
label variable q2_1 "重要性評価：アメリカ"
label variable q2_2 "重要性評価：EU"
label variable q2_3 "重要性評価：中国"
label variable q2_4 "重要性評価：ブラジル"
label variable q3 "国際機関での利益代表"
label variable q5 "BRICS・CELAC等の重要性"
label variable q6 "大国間緊張への対応姿勢"
label variable q7 "対中経済関係の影響評価"
label variable q8 "グローバルサウス認知"
label variable q8s1 "GS役割評価（既知者）"
label variable q8s2 "GS役割評価（説明後）"
label variable transaction_id "トランザクションID"
label variable durationinseconds "回答時間（秒）"
label variable status "回答ステータス"
label variable progress "進捗率"
label variable finished "完了フラグ"
label variable recordeddate "記録日時"
label variable responseid "レスポンスID"

* 値ラベルの定義（メキシコ）
label define f1_lb 1 "女性" 2 "男性" 3 "その他" 4 "回答控える"
label values f1 f1_lb

label define f3_mx_lb 1 "小学校" 2 "中学校" 3 "高校" 4 "技術教育" ///
                      5 "大学" 6 "大学院"
label values f3 f3_mx_lb

label define f4_lb 1 "最低賃金以下" 2 "1-2倍" 3 "2-4倍" 4 "4-8倍" ///
                   5 "8-12倍" 6 "12-16倍" 7 "16-20倍" 8 "20倍以上" 9 "不明"
label values f4 f4_lb

label define q1_lb 1 "非常に肯定的" 2 "肯定的" 3 "どちらでもない" ///
                   4 "否定的" 5 "非常に否定的"
label values q1 q1_lb

label define importance_lb 1 "非常に重要" 2 "重要" 3 "どちらでもない" ///
                           4 "あまり重要でない" 5 "全く重要でない"
label values q2_1 q2_2 q2_3 q2_4 importance_lb

label define agree_lb 1 "強く同意" 2 "同意" 3 "どちらでもない" ///
                      4 "反対" 5 "強く反対" 6 "わからない"
label values q3 agree_lb
label values q8s1 q8s2 agree_lb

label define q5_lb 1 "非常に重要" 2 "重要" 3 "どちらでもない" ///
                   4 "あまり重要でない" 5 "全く重要でない" 6 "わからない"
label values q5 q5_lb

label define q6_lb 1 "米国優先" 2 "中露強化" 3 "中立維持" ///
                   4 "実利主義" 5 "わからない"
label values q6 q6_lb

label define q7_lb 1 "主に利益" 2 "利益とリスク両方" ///
                   3 "リスクが上回る" 4 "わからない"
label values q7 q7_lb

label define q8_lb 1 "知っている" 2 "聞いたことがある" 3 "知らない"
label values q8 q8_lb

* メキシコデータ一時保存
tempfile mexico_temp
save `mexico_temp'

* ==============================================================================
* PART B: ブラジルデータの読み込みとラベル設定
* ==============================================================================
clear
import delimited "${raw}brasil.csv", clear
display "ブラジル初期観測数: " _N

* 国識別変数の追加
gen country = 2
label variable country "国"

* 変数ラベルの設定（メキシコと共通）
label variable f1 "性別"
label variable f2 "年齢"
label variable f3 "教育水準"
label variable f4 "世帯月収（最低賃金倍数）"
label variable q1 "政権評価"
label variable q2_1 "重要性評価：アメリカ"
label variable q2_2 "重要性評価：EU"
label variable q2_3 "重要性評価：中国"
label variable q2_4 "重要性評価：メキシコ"  // ブラジルではメキシコ評価
label variable q3 "国際機関での利益代表"
label variable q5 "BRICS・CELAC等の重要性"
label variable q6 "大国間緊張への対応姿勢"
label variable q7 "対中経済関係の影響評価"
label variable q8 "グローバルサウス認知"
label variable q8s1 "GS役割評価（既知者）"
label variable q8s2 "GS役割評価（説明後）"
label variable transaction_id "トランザクションID"
label variable durationinseconds "回答時間（秒）"
label variable status "回答ステータス"
label variable progress "進捗率"
label variable finished "完了フラグ"
label variable recordeddate "記録日時"
label variable responseid "レスポンスID"

* 値ラベルの定義（共通部分はメキシコと同じ）
label define f1_lb 1 "女性" 2 "男性" 3 "その他" 4 "回答控える"
label values f1 f1_lb

label define f3_br_lb 1 "基礎教育" 2 "中等教育" 3 "技術教育" ///
                      4 "高等教育" 5 "大学院"
label values f3 f3_br_lb

label define f4_lb 1 "最低賃金以下" 2 "1-2倍" 3 "2-4倍" 4 "4-8倍" ///
                   5 "8-12倍" 6 "12-16倍" 7 "16-20倍" 8 "20倍以上" 9 "不明"
label values f4 f4_lb

label define q1_lb 1 "非常に肯定的" 2 "肯定的" 3 "どちらでもない" ///
                   4 "否定的" 5 "非常に否定的"
label values q1 q1_lb

label define importance_lb 1 "非常に重要" 2 "重要" 3 "どちらでもない" ///
                           4 "あまり重要でない" 5 "全く重要でない"
label values q2_1 q2_2 q2_3 q2_4 importance_lb

label define agree_lb 1 "強く同意" 2 "同意" 3 "どちらでもない" ///
                      4 "反対" 5 "強く反対" 6 "わからない"
label values q3 agree_lb
label values q8s1 q8s2 agree_lb

label define q5_lb 1 "非常に重要" 2 "重要" 3 "どちらでもない" ///
                   4 "あまり重要でない" 5 "全く重要でない" 6 "わからない"
label values q5 q5_lb

label define q6_lb 1 "米国優先" 2 "中露強化" 3 "中立維持" ///
                   4 "実利主義" 5 "わからない"
label values q6 q6_lb

label define q7_lb 1 "主に利益" 2 "利益とリスク両方" ///
                   3 "リスクが上回る" 4 "わからない"
label values q7 q7_lb

label define q8_lb 1 "知っている" 2 "聞いたことがある" 3 "知らない"
label values q8 q8_lb

* ==============================================================================
* PART C: データ統合
* ==============================================================================
* メキシコデータと統合
append using `mexico_temp'

* 国ラベルの設定
label define country_lb 1 "メキシコ" 2 "ブラジル"
label values country country_lb

* 統合後の統計表示
display "=========================================="
display "データ読み込み完了"
display "----------------------------------------"
tab country
display "----------------------------------------"
display "総観測数: " _N
display "=========================================="

* ==============================================================================
* PART D: 基本的な統合変数の作成（クリーニング用のみ）
* ==============================================================================



* 教育水準の統一変数（国間比較用）
gen edu_unified = .

    replace edu_unified = 1 if f3 <= 2  & country==1 // 小学校・中学校→基礎教育
    replace edu_unified = 2 if f3 == 3  & country==1 // 高校→中等教育
    replace edu_unified = 3 if f3 == 4  & country==1 // 技術教育
    replace edu_unified = 4 if f3 == 5  & country==1 // 大学→高等教育
    replace edu_unified = 5 if f3 == 6  & country==1 // 大学院

    replace edu_unified = f3 if country==2

label define edu_unified_lb 1 "基礎教育" 2 "中等教育" 3 "技術教育" ///
                            4 "高等教育" 5 "大学院"
label values edu_unified edu_unified_lb
label variable edu_unified "統一教育水準"

* ==============================================================================
* PART E: データ保存
* ==============================================================================
* 読み込み済みデータの保存
save "${created}globalsouthsurvey_raw.dta", replace
