# ==========================================================
# run_all.R
# Purpose: Run all steps in sequence to generate final dataset
# ==========================================================

setwd(here::here())

# 1. Set up environment
source("code/00_setup.R")

# 2. Load data
source("code/01_loadData.R")

# 3. Data cleaning
source("code/02_cleanTransform.R")

# 4. Merge and export final dataset
source("code/03_mergeDatasets.R")


cat("\nAll scripts completed successfully.\n")
cat("Merged dataset available at: outputs/mergedDataset.csv\n")