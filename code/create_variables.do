********************************************************************************
* 分析用変数作成ファイル
* 作成日: 2025年9月
* ファイル名: create_variables.do
* 前提: clean_data.do 実行後、またはsurvey_cleaned.dtaが存在すること
********************************************************************************

* ==============================================================================
* 0. 初期設定とデータ確認
* ==============================================================================

use "${created}survey_cleaned.dta", replace


* ==============================================================================
* 1. 従属変数の作成
* ==============================================================================


* 女性ダミー
gen female = (f1 == 1) if f1 <= 2
label variable female "女性"

* 年齢カテゴリ
gen age_cat = .
replace age_cat = 1 if f2 >= 18 & f2 <= 29
replace age_cat = 2 if f2 >= 30 & f2 <= 39
replace age_cat = 3 if f2 >= 40 & f2 <= 49
replace age_cat = 4 if f2 >= 50 & f2 <= 59
replace age_cat = 5 if f2 >= 60
label define agecat_lb 1 "18-29歳" 2 "30-39歳" 3 "40-49歳" ///
                       4 "50-59歳" 5 "60歳以上"
label values age_cat agecat_lb
label variable age_cat "年齢カテゴリ"

* 収入カテゴリ
gen income_cat = .
replace income_cat = 1 if f4 >= 1 & f4 <= 2  // 低所得（最低賃金2倍以下）
replace income_cat = 2 if f4 >= 3 & f4 <= 4  // 中所得（2-4倍）
replace income_cat = 3 if f4 >= 5 & f4 <= 8  // 高所得（5倍以上）
replace income_cat = 4 if f4 == 9             // 不明
label define inccat_lb 1 "低所得" 2 "中所得" 3 "高所得" 4 "不明"
label values income_cat inccat_lb
label variable income_cat "収入カテゴリ"

* 5.2 グローバルサウス関連変数
* GS役割評価の統合変数
gen gs_role = .
replace gs_role = q8s1 if !missing(q8s1)
replace gs_role = q8s2 if missing(q8s1) & !missing(q8s2)
label variable gs_role "GS役割評価（統合）"
label values gs_role agree_lb


* グローバルサウス認知関連
gen gs_know = (q8==1) if !missing(q8)
gen gs_any = (q8<=2) if !missing(q8)
gen gs_strong = (gs_role==1) if !missing(gs_role)
gen gs_agree = (gs_role<=2) if !missing(gs_role)

label variable gs_know "GS認知（知っている）"
label variable gs_any "GS認知（知っている＋聞いた）"
label variable gs_strong "GS役割（強く同意）"
label variable gs_agree "GS役割（強く同意＋同意）"

* 順序変数版
gen q8_ordered = 2 if q8==1
replace q8_ordered = 1 if q8==2
replace q8_ordered = 0 if q8==3
label define q8_ord_lb 0 "知らない" 1 "聞いた" 2 "知っている"
label values q8_ordered q8_ord_lb
label variable q8_ordered "GS認知（順序）"

gen gs_role_ordered = 4 if gs_role==1
replace gs_role_ordered = 3 if gs_role==2
replace gs_role_ordered = 2 if gs_role==3
replace gs_role_ordered = 1 if gs_role==4
replace gs_role_ordered = 0 if gs_role==5
label define role_ord_lb 0 "強く反対" 1 "反対" 2 "どちらでもない" 3 "同意" 4 "強く同意"
label values gs_role_ordered role_ord_lb
label variable gs_role_ordered "GS役割（順序）"

* ==============================================================================
* 2. ダミー変数の作成（回帰分析用）
* ==============================================================================

* 年齢（基準：40-49歳）
tab age_cat, gen(age_)
label variable age_1 "18-29歳"
label variable age_2 "30-39歳"
label variable age_3 "40-49歳[基準]"
label variable age_4 "50-59歳"
label variable age_5 "60歳以上"

* 教育（基準：技術教育）
tab edu_unified, gen(edu_)
label variable edu_1 "基礎教育"
label variable edu_2 "中等教育"
label variable edu_3 "技術教育[基準]"
label variable edu_4 "高等教育"
label variable edu_5 "大学院"

* 収入（基準：不明）
tab income_cat, gen(inc_)
label variable inc_1 "低所得"
label variable inc_2 "中所得"
label variable inc_3 "高所得"
*label variable inc_4 "収入不明[基準]"

* 政権評価（基準：どちらでもない）
tab q1, gen(q1_)
label variable q1_1 "政権評価：非常に肯定的"
label variable q1_2 "政権評価：肯定的"
label variable q1_3 "政権評価：どちらでもない[基準]"
label variable q1_4 "政権評価：否定的"
label variable q1_5 "政権評価：非常に否定的"

* 米国重要性（基準：どちらでもない）
tab q2_1, gen(q2_1_)
label variable q2_1_1 "米国：非常に重要"
label variable q2_1_2 "米国：重要"
label variable q2_1_3 "米国：どちらでもない[基準]"
label variable q2_1_4 "米国：あまり重要でない"
label variable q2_1_5 "米国：全く重要でない"

* EU重要性（基準：どちらでもない）
tab q2_2, gen(q2_2_)
label variable q2_2_1 "EU：非常に重要"
label variable q2_2_2 "EU：重要"
label variable q2_2_3 "EU：どちらでもない[基準]"
label variable q2_2_4 "EU：あまり重要でない"
label variable q2_2_5 "EU：全く重要でない"

* 中国重要性（基準：どちらでもない）
tab q2_3, gen(q2_3_)
label variable q2_3_1 "中国：非常に重要"
label variable q2_3_2 "中国：重要"
label variable q2_3_3 "中国：どちらでもない[基準]"
label variable q2_3_4 "中国：あまり重要でない"
label variable q2_3_5 "中国：全く重要でない"

* 相手国重要性（基準：どちらでもない）
tab q2_4, gen(q2_4_)
label variable q2_4_1 "相手国：非常に重要"
label variable q2_4_2 "相手国：重要"
label variable q2_4_3 "相手国：どちらでもない[基準]"
label variable q2_4_4 "相手国：あまり重要でない"
label variable q2_4_5 "相手国：全く重要でない"

* 国際機関（基準：わからない）
tab q3, gen(q3_)
label variable q3_1 "国際機関：強く同意"
label variable q3_2 "国際機関：同意"
label variable q3_3 "国際機関：どちらでもない"
label variable q3_4 "国際機関：反対"
label variable q3_5 "国際機関：強く反対"
*label variable q3_6 "国際機関：わからない[基準]"

* BRICS重要性（基準：わからない）
tab q5, gen(q5_)
label variable q5_1 "BRICS等：非常に重要"
label variable q5_2 "BRICS等：重要"
label variable q5_3 "BRICS等：どちらでもない"
label variable q5_4 "BRICS等：あまり重要でない"
label variable q5_5 "BRICS等：全く重要でない"
*label variable q5_6 "BRICS等：わからない[基準]"

* 大国間対応（基準：わからない）
tab q6, gen(q6_)
label variable q6_1 "対外姿勢：米国優先"
label variable q6_2 "対外姿勢：中露強化"
label variable q6_3 "対外姿勢：中立維持"
label variable q6_4 "対外姿勢：実利主義"
*label variable q6_5 "対外姿勢：わからない[基準]"

* 対中経済（基準：わからない）
tab q7, gen(q7_)
label variable q7_1 "対中関係：主に利益"
label variable q7_2 "対中関係：利益とリスク両方"
label variable q7_3 "対中関係：リスクが上回る"
*label variable q7_4 "対中関係：わからない[基準]"

* ==============================================================================
* 3. 二値変数の作成（簡略版の独立変数）
* ==============================================================================

* 政権評価
gen gov_positive = (q1<=2) if !missing(q1)
gen gov_very_positive = (q1==1) if !missing(q1)
gen gov_moderate_positive = (q1==2) if !missing(q1)

label variable gov_positive "政権評価：肯定的"
label variable gov_very_positive "政権評価：非常に肯定的"
label variable gov_moderate_positive "政権評価：肯定的"

* 各国の重要性（重要＋非常に重要）
gen usa_important = (q2_1<=2) if !missing(q2_1)
gen eu_important = (q2_2<=2) if !missing(q2_2)
gen china_important = (q2_3<=2) if !missing(q2_3)
gen other_important = (q2_4<=2) if !missing(q2_4)

label variable usa_important "米国は重要"
label variable eu_important "EUは重要"
label variable china_important "中国は重要"
label variable other_important "相手国は重要"

* 国際機関での代表性
gen intl_represented = (q3<=2) if !missing(q3)
gen intl_not_represented = (q3>=4) if !missing(q3)

label variable intl_represented "国際機関で利益は代表されている"
label variable intl_not_represented "国際機関で利益は代表されていない"

* BRICS等の重要性
gen brics_important = (q5<=2) if !missing(q5)
label variable brics_important "BRICS等は重要"

* 対中経済関係
gen china_benefit = (q7==1) if !missing(q7)
gen china_mixed = (q7==2) if !missing(q7)

label variable china_benefit "対中関係は主に利益"
label variable china_mixed "対中関係は利益とリスク両方"

* ==============================================================================
* 4. 分析用マクロの定義
* ==============================================================================

* 基本的な個人属性の変数（ダミー版）
global demographics "female age_1 age_2 age_4 age_5 edu_1 edu_2 edu_4 edu_5 inc_1 inc_3"

* 態度や認識に関する変数（二値版）
global attitudes "gov_very_positive gov_moderate_positive usa_important eu_important china_important other_important intl_represented intl_not_represented brics_important q6_1 q6_2 q6_4 china_benefit"

* 全独立変数
global allvars "$demographics $attitudes"

* カテゴリカルダミー版（詳細分析用）
global demographics_full "female age_1 age_2 age_4 age_5 edu_1 edu_2 edu_4 edu_5 inc_1 inc_2 inc_3"

global attitudes_full "q1_1 q1_2 q1_4 q1_5 q2_1_1 q2_1_2 q2_1_4 q2_1_5 q2_2_1 q2_2_2 q2_2_4 q2_2_5 q2_3_1 q2_3_2 q2_3_4 q2_3_5 q2_4_1 q2_4_2 q2_4_4 q2_4_5 q3_1-q3_5 q5_1-q5_5 q6_1-q6_4 q7_1-q7_3"

* ==============================================================================
* 5. データ保存
* ==============================================================================

* 分析用データの保存
save "${created}analysis_data.dta", replace

