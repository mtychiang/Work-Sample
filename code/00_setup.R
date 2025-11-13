# ==========================================================
# 00_setup.R
# Project: Work Sample - Smart Meter Consumption and Weather Analysis
# Purpose: Prepare R environment and load required packages
# ==========================================================

rm(list = ls())

# Load or install required packages
required <- c(
  "tidyverse", "readr", "lubridate", "janitor", "here"
)

for (pkg in required) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
}

# Set up paths
data_path  <- here::here("data")
code_path  <- here::here("code")
output_path <- here::here("outputs")

# Create dirs if missing
dir.create(data_path, showWarnings = FALSE)
dir.create(output_path, showWarnings = FALSE)

# Confirmation message
cat("00_setup: Environment setup complete. Packages loaded and paths initialised.\n")

# Clean environment
rm(required, pkg)