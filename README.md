# Global South Recognition Survey - Replication Package

## 概要 / Overview

本リポジトリは、以下の論文の分析を再現するためのレプリケーションパッケージです。

This repository contains the replication package for the following paper:

**論文 / Paper:**
- タイトル: ラテンアメリカにおけるグローバルサウスについての市民認識：ブラジルとメキシコの事例
- Title: Public Perceptions of the Global South in Latin America: Cases of Brazil and Mexico
- 著者 / Authors: 高橋百合子 (Yuriko Takahashi)・馬場香織 (Kaori Baba)・手島健介 (Kensuke Teshima)
- 掲載誌 / Journal: 『ラテンアメリカ・レポート』/ Latin American Report
- 巻号 / Volume: 第43巻2号 / Vol. 43, No. 2
- 発行年 / Year: 2026年

## ディレクトリ構成 / Directory Structure

```
GlobalSouthRecognition-Replication/
├── README.md                      # このファイル / This file
├── LICENSE                        # ライセンス情報 / License information
├── data/                          # データフォルダ / Data folder
│   ├── raw/                       # 生データ / Raw data
│   │   ├── mexico.csv             # メキシコ調査データ / Mexico survey data
│   │   └── brasil.csv             # ブラジル調査データ / Brazil survey data
│   └── created/                   # 分析過程で作成されるデータ / Created datasets
│       └── .gitkeep
├── code/                          # 分析コード / Analysis code
│   ├── housekeeping.do            # パス設定 / Path settings
│   ├── master_globalsouthsurvey.do # マスターファイル / Master file
│   ├── read_survey.do             # データ読み込み / Data import
│   ├── clean_data.do              # データクリーニング / Data cleaning
│   ├── create_variables.do        # 変数作成 / Variable creation
│   ├── summary_statistics_pcavariable.do # 記述統計 / Descriptive statistics
│   └── principal_component.do     # 主成分分析 / Principal component analysis
├── output/                        # 出力フォルダ / Output folder
│   ├── tables/                    # 表出力 / Tables
│   │   └── .gitkeep
│   └── figures/                   # 図出力 / Figures
│       └── .gitkeep
└── docs/                          # 文書 / Documentation
    └── (codebooks will be placed here)
```

## 必要環境 / Requirements

- **Stata**: Version 15以降 / Version 15 or later
- **必要パッケージ / Required packages**:
  - `estout` (esttabコマンド用 / for esttab command)
  - その他標準的なStataパッケージ / Other standard Stata packages

## 使用方法 / Usage Instructions

### 1. リポジトリのクローン / Clone the Repository

```bash
git clone https://github.com/[username]/GlobalSouthRecognition-Replication.git
cd GlobalSouthRecognition-Replication
```

### 2. パス設定 / Set up Paths

`code/housekeeping.do`を開き、あなたのローカル環境に合わせてパスを設定してください。

Open `code/housekeeping.do` and modify the path to match your local environment:

```stata
* 例 / Example:
if "`user'" == "your_username" {
    global basedir "C:\path\to\GlobalSouthRecognition-Replication"
}
```

### 3. 分析の実行 / Run the Analysis

Stataで以下のコマンドを**順番に**実行してください：

In Stata, execute the following commands **in order**:

```stata
* ステップ1: パス設定ファイルを実行 / Step 1: Run the path setup file
do "C:\path\to\GlobalSouthRecognition-Replication\code\housekeeping.do"

* ステップ2: マスターファイルを実行 / Step 2: Run the master file
do "${code}/master_globalsouthsurvey.do"
```

**重要 / Important**: 
- 必ず`housekeeping.do`を先に実行してグローバル変数を設定してください
- First, run `housekeeping.do` to set up global variables
- その後、`master_globalsouthsurvey.do`を実行すると全ての分析が実行されます
- Then, running `master_globalsouthsurvey.do` will execute the complete analysis

### 4. 出力の確認 / Check Output

分析が完了すると、以下のファイルが生成されます：

After completion, the following files will be generated:

**表 / Tables** (`output/tables/`):
- `comparison_table_revised.xlsx` - 表1：記述統計（国別比較）/ Table 1: Descriptive statistics (country comparison)
- `table_pca_mexico.txt` - 表2 パネルB：メキシコ主成分を説明変数とした回帰分析結果 / Table 2 Panel B: Mexico regression results using PCA as independent variables
- `table_pca_brazil.txt` - 表3 パネルB：ブラジル主成分を説明変数とした回帰分析結果 / Table 3 Panel B: Brazil regression results using PCA as independent variables

**図 / Figures** (`output/figures/`):
- `globalsouth_responses_combined.png` - 図2：グローバルサウス認知度・役割評価 / Figure 2: Global South recognition and role assessment

**ログファイル / log file**
-`master_log.txt`-表2 パネル A 表3 パネル Aはログファイルにある主成分分析結果から直接作成 / Table 2 Panel A and Table 3 Panel A are created directly from the results of PCAs stored in the log file


## 引用 / Citation

本データまたはコードを使用する場合は、以下のように引用してください：

If you use this data or code, please cite as follows:

```
高橋百合子・馬場香織・手島健介 (2026)「ラテンアメリカにおけるグローバルサウスについての市民認識：ブラジルとメキシコの事例」『ラテンアメリカ・レポート』43巻2号

Takahashi, Yuriko, Kaori Baba, and Kensuke Teshima (2026) 
"Public Perceptions of the Global South in Latin America: Cases of Brazil and Mexico," 
Latin American Report, Vol. 43, No. 2.
```

## ライセンス / License

[ライセンス情報を記入 / Insert license information]

## 連絡先 / Contact

質問やフィードバックがある場合は、以下にお問い合わせください：

For questions or feedback, please contact:

- [連絡先情報を記入 / Insert contact information]

## 謝辞 / Acknowledgments

[謝辞を記入 / Insert acknowledgments]

---

最終更新 / Last updated: 2025年11月 / November 2025
