# ==========================================================
# 01_loadData.R
# Purpose: Load raw datasets from /data into memory
# Note: Run 00_setup.R first
# ==========================================================

# Filepaths
path_smartMeter <- here::here("data", "raw_A_smart_meter.csv")
path_households <- here::here("data", "raw_B_information_households.csv")
path_bank <- here::here("data", "raw_C_UK_bank_holidays.csv")
path_weather <- here::here("data", "raw_D_weather.csv")
path_rain <- here::here("data", "raw_E_rainfall.csv")

# Check files exist. Stop code if missing
paths <- c(path_smartMeter, path_households, path_bank, path_weather, path_rain)
missing <- paths[!file.exists(paths)]
if (length(missing)) {
  stop("Missing expected data file(s):\n - ", paste(basename(missing), collapse = "\n - "))
}

# Read data
smartMeter <- read.csv(path_smartMeter)
householdInfo <- read.csv(path_households)
bankHols <- read.csv(path_bank)
weather <- read.csv(path_weather)
rainfall <- read.csv(path_rain)

# Confirmation message
cat("Loaded tables:\n")
cat(" smartMeter   :", nrow(smartMeter), "rows\n")
cat(" householdInfo:", nrow(householdInfo), "rows\n")
cat(" bankHols     :", nrow(bankHols), "rows\n")
cat(" weather      :", nrow(weather), "rows\n")
cat(" rainfall     :", nrow(rainfall), "rows\n")

# Clean environment
rm(list = ls(pattern = "^(path|paths)"), missing)
