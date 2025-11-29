
/************************************************
* グローバルサウス認識調査 - 記述統計作成（改訂版）
* 主成分分析で使用する変数に合わせた記述統計
************************************************/

use "${created}analysis_data.dta", replace

* ===============================================
* 1. 反転変数の作成（PCA分析と同じ）
* ===============================================

* 反転変数を作成（create_variables.doで作成済みでない場合）
capture drop q1_r q2_1_r q2_2_r q2_3_r q2_4_r q3_r q5_r q7_r

gen q1_r = 6 - q1      // 政権評価（反転後：高いほど肯定的）
gen q2_1_r = 6 - q2_1  // 米国重要性（反転後：高いほど重要）
gen q2_2_r = 6 - q2_2  // EU重要性
gen q2_3_r = 6 - q2_3  // 中国重要性
gen q2_4_r = 6 - q2_4  // 相手国重要性
gen q3_r = 6 - q3      // 国際機関（反転後：高いほど代表されている）
gen q5_r = 6 - q5      // BRICS/CELAC重要性（反転後：高いほど重要）
gen q7_r = 4 - q7      // 中国の関係評価（反転後：高いほど肯定的）

* 変数ラベル設定
label variable q1_r "政権評価（：高=肯定的）"
label variable q2_1_r "米国重要性（高=重要）"
label variable q2_2_r "EU重要性（高=重要）"
label variable q2_3_r "中国重要性（高=重要）"
label variable q2_4_r "相手国重要性（高=重要）"
label variable q3_r "国際機関代表性（高=代表）"
label variable q5_r "BRICS/CELAC重要性（高=重要）"
label variable q7_r "対中経済関係（高=肯定的）"


* ===============================================
* 2. 変数リストの定義（論文の表1に合わせる）
* ===============================================

* 基本属性（全カテゴリを含む）
local demographics "female age_1 age_2 age_3 age_4 age_5 edu_1 edu_2 edu_3 edu_4 edu_5 inc_1 inc_2 inc_3"

* 態度変数（反転変数 + q6ダミー）
local attitudes "q1_r q2_1_r q2_2_r q2_3_r q2_4_r q3_r q5_r q6_1 q6_2 q6_3 q6_4 q7_r"

* すべての変数
local allvars "`demographics' `attitudes'"

* ===============================================
* 3. 国別の記述統計表を作成（表1）
* ===============================================

* Excelファイルを作成
putexcel set "${tables}comparison_table_revised.xlsx", replace

* ヘッダー（論文に合わせてブラジル→メキシコの順）
putexcel A1 = "変数" B1 = "ブラジル" C1 = "メキシコ" D1 = "差"

* 各変数の統計を計算
local row = 2

foreach var of local allvars {
    local vlab : variable label `var'
    
    * ブラジルの統計
    quietly sum `var' if country==2
    local br_m = r(mean)
    local br_se = r(sd)/sqrt(r(N))
    
    * メキシコの統計
    quietly sum `var' if country==1
    local mx_m = r(mean)
    local mx_se = r(sd)/sqrt(r(N))
    
    * t検定（ブラジル - メキシコ）
    quietly ttest `var', by(country)
    local diff = r(mu_2) - r(mu_1)  // country==2 (Brazil) - country==1 (Mexico)
    local p = r(p)
    
    * 有意性の星
    local stars = ""
    if `p' < 0.01 local stars = "***"
    else if `p' < 0.05 local stars = "**"
    else if `p' < 0.10 local stars = "*"
    
    * Excelに書き込み（平均値(標準誤差)形式、ブラジル→メキシコの順）
    putexcel A`row' = "`vlab'"
    putexcel B`row' = "`=string(`br_m',"%9.3f")' (`=string(`br_se',"%9.3f")')"
    putexcel C`row' = "`=string(`mx_m',"%9.3f")' (`=string(`mx_se',"%9.3f")')"
    putexcel D`row' = "`=string(`diff',"%9.3f")'`stars'"
    
    local row = `row' + 1
}

* 回答者数
putexcel A`row' = "回答者数"
quietly count if country==2
putexcel B`row' = `r(N)'
quietly count if country==1
putexcel C`row' = `r(N)'

* 注釈
local row = `row' + 1
putexcel A`row' = "注：括弧内は標本平均の標準誤差。*p<0.10, **p<0.05, ***p<0.01"

display "記述統計表（表1）を作成しました: ${tables}comparison_table_revised.xlsx"



/******************************************************************************
* グローバルサウス認知度と役割評価の統合図表作成（修正版）
* Figure 14 & 15 の結合
******************************************************************************/

/*** パネルA: グローバルサウス認知度（q8）***/
preserve
    gen dummy = 1
    collapse (count) n=dummy, by(country q8)
    
    bysort country: egen total = sum(n)
    gen percent = (n/total)*100
    gen label_text = string(n) + " (" + string(percent, "%3.1f") + "%)"
    
    * 国ごとにまとめた位置（3カテゴリ）- ブラジルとメキシコを逆に
    gen xpos = .
    replace xpos = 1 + (q8-1)*0.5 if country==2
    replace xpos = 2.8 + (q8-1)*0.5 if country==1
    
    * グラフ作成
    twoway (bar n xpos if country==2, barwidth(0.45) color(cranberry) base(0)) ///
           (bar n xpos if country==1, barwidth(0.45) color(navy) base(0)) ///
           (scatter n xpos, ms(none) mlabel(label_text) mlabpos(12) mlabsize(vsmall)), ///
        xlabel(1 "知っている" 1.5 "聞いた" 2.0 "知らない" ///
               2.8 "知っている" 3.3 "聞いた" 3.8 "知らない", ///
               noticks labsize(small)) ///
        xline(2.4, lcolor(gray) lpattern(dash) lwidth(thin)) ///
        text(400 1.5 "ブラジル", size(small)) ///
        text(400 3.3 "メキシコ", size(small)) ///
        xtitle("") ///
        ylabel(0(100)400, angle(0)) ///
        ytitle("人数") ///
        title("(a) グローバルサウス認知度", size(medium)) ///
        legend(off) ///
        scheme(s1mono) ///
        name(panel_a, replace)
restore

/*** パネルB: グローバルサウス役割評価（gs_role）***/
preserve
    gen dummy = 1
    collapse (count) n=dummy, by(country gs_role)
    
    * 欠損値を除外
    drop if missing(gs_role)
    
    bysort country: egen total = sum(n)
    gen percent = (n/total)*100
    gen label_text = string(n) + " (" + string(percent, "%3.1f") + "%)"
    
    * 国ごとにまとめた位置（5カテゴリ）- ブラジルとメキシコを逆に
    gen xpos = .
    replace xpos = 0.8 + (gs_role-1)*0.35 if country==2
    replace xpos = 3.2 + (gs_role-1)*0.35 if country==1
    
    * グラフ作成
    twoway (bar n xpos if country==2, barwidth(0.3) color(cranberry) base(0)) ///
           (bar n xpos if country==1, barwidth(0.3) color(navy) base(0)) ///
           (scatter n xpos, ms(none) mlabel(label_text) mlabpos(12) mlabsize(vsmall)), ///
        xlabel(0.8 "強く同意" 1.15 "同意" 1.5 "中立" 1.85 "反対" 2.2 "強く反対" ///
               3.2 "強く同意" 3.55 "同意" 3.9 "中立" 4.25 "反対" 4.6 "強く反対", ///
               noticks labsize(vsmall) angle(45)) ///
        xline(2.7, lcolor(gray) lpattern(dash) lwidth(thin)) ///
        text(400 1.5 "ブラジル", size(small)) ///
        text(400 3.9 "メキシコ", size(small)) ///
        xtitle("") ///
        ylabel(0(100)400, angle(0)) ///
        ytitle("人数") ///
        title("(b) グローバルサウスにおける自国役割評価", size(medium)) ///
        legend(off) ///
        scheme(s1mono) ///
        name(panel_b, replace)
restore

/*** 図の結合（縦配置）***/
graph combine panel_a panel_b, ///
    rows(2) cols(1) ///
    title("グローバルサウス認識：ブラジル・メキシコ比較", size(medlarge)) ///
    subtitle("(ブラジル 722名、メキシコ 734名)", size(small)) ///
    note("注：役割評価は「あなたの国はグローバルサウスにおいて重要な役割を果たしていると思う」への回答", ///
         size(vsmall)) ///
    scheme(s1mono) ///
    graphregion(color(white)) ///
    ysize(10) xsize(7)

graph export "${figures}globalsouth_responses_combined.png", replace width(1000) height(1400)

/*** クリーンアップ ***/
graph drop panel_a panel_b
