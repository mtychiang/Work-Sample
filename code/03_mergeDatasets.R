# ==========================================================
# 03_mergeDatasets.R
# Purpose: Join clean datasets into one analysis-ready table
# Note: Run 02_cleanTransform.R first
# ==========================================================

# Check datasets have been processed
stopifnot(
  exists("smartMeter_clean"),
  exists("householdInfo_clean"),
  exists("bankHols_clean"),
  exists("rainfall_clean"),
  exists("weather_clean"))


# Join smartMeter and Household info by LCLid
merged_df <- dplyr::left_join(
  smartMeter_clean,
  householdInfo_clean,
  by = "LCLid")

# Join with weather by day and hour
merged_df <- dplyr::left_join(
  merged_df,
  weather_clean,
  by = c("day", "hour"))

# Join with rainfall by day
merged_df <- dplyr::left_join(
  merged_df,
  rainfall_clean,
  by = "day")

# Add bank holiday flag
merged_df <- dplyr::left_join(
  merged_df,
  bankHols_clean,
  by = "day")

merged_df$Holiday <- replace_na(merged_df$Holiday, "N")

# Tidy column order and remove NA
merged_df <- merged_df %>%
  dplyr::relocate(LCLid, day, hour, sumHour) %>%
  dplyr::relocate(stdorToU, Acorn, Acorn_grouped, .after = sumHour) %>%
  dplyr::relocate(visibility, temperature, dewPoint, pressure, windSpeed, humidity, condition, .after = Acorn_grouped) %>%
  dplyr::relocate(dailyRainfall, Holiday, .after = condition) %>%
  na.omit()

# Confirmation message
cat("03_mergeDatasets complete.\n")
cat(" merged rows :", nrow(merged_df), "\n")

# ==========================================================
# Export
# ==========================================================
output_path <- here::here("outputs", "mergedDataset.csv")
readr::write_csv(merged_df, output_path)
cat(" Exported:", output_path, "\n")


