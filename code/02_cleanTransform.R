# ==========================================================
# 02_cleanTransform.R
# Purpose: Clean data, standardise formats
# Note: Run 01_loadData.R first
# ==========================================================

# Check datasets have been loaded
stopifnot(exists("smartMeter"), 
          exists("householdInfo"),
          exists("bankHols"), 
          exists("weather"), 
          exists("rainfall"))

# Format hour function
fmt_hour <- function(x) sprintf("%02d:00", x)

# ==========================================================
# DATASET A: Smart Meter Data
#  - transform into long format
#  - derive hour from half-hour slot robustly
#  - sum to hourly totals
#  - standardise day format as dd/mm/YYYY (to match your pipeline)
# ==========================================================

# Transform into long form
smartMeter1 <- smartMeter %>%
  tidyr::gather(key, 
                value, 
                -LCLid, -day)

# Derive hour from half-hour slot number 
key_map <- smartMeter1 %>%
  dplyr::distinct(key) %>%
  dplyr::mutate(hour = fmt_hour(rep(00:23, each = 2))) %>%
  dplyr::select(key, hour)

smartMeter1 <- dplyr::left_join(smartMeter1, key_map, by = "key")

# Keep needed columns
smartMeter1 <- smartMeter1 %>%
  dplyr::select(LCLid, day, hour, value)

# Aggregate to hourly totals per meter/day/hour
smartMeter_clean <- smartMeter1 %>%
  dplyr::group_by(LCLid, day, hour) %>%
  dplyr::summarise(sumHour = sum(value, na.rm = TRUE), .groups = "drop")

# Standardise date to dd/mm/YYYY
smartMeter_clean$day <- lubridate::dmy(smartMeter_clean$day)
smartMeter_clean$day <- format(as.POSIXct(smartMeter_clean$day, format = "%Y-%m-%d"), "%d/%m/%Y")


# ==========================================================
# DATASET B: Household info 
# ==========================================================
# Keep needed columns
householdInfo_clean <- householdInfo %>%
  dplyr::select(LCLid, stdorToU, Acorn, Acorn_grouped)


# ==========================================================
# DATASET C: Bank holidays
#  - Clean & standardise date + flag
# ==========================================================

bankHols_clean <- bankHols %>%
  dplyr::rename(day = Bank.holidays) %>%
  dplyr::mutate(Holiday = "Y") %>%
  dplyr::select(day, Holiday) %>%
  dplyr::distinct()

bankHols_clean$day <- as.Date(bankHols_clean$day)
bankHols_clean$day <- format(as.POSIXct(bankHols_clean$day, format = "%Y-%m-%d"), "%d/%m/%Y")


# ==========================================================
# DATASET D: Rainfall
#  - Compute daily average across regions
#  - Coerce numeric cols
#  - Create 'day' (dd/mm/YYYY) and 'dailyRainfall'
# ==========================================================

# Select needed columns and remove first row
rainfall1 <- rainfall %>%
  dplyr::select(X, North.London, South.London, North.Downs.South.London, Lower.Lee, Roding) %>%
  dplyr::slice(-1) %>%
  # Average rainfall across whole of London
  dplyr::mutate(across(-X, as.numeric)) %>%
  dplyr::mutate(
    dailyRainfall = rowMeans(dplyr::across(-X), na.rm = TRUE),
    day = X
  ) %>%
  dplyr::select(day, dailyRainfall)

rainfall_clean <- rainfall1

# ==========================================================
# DATASET E: Weather
#  - Standardise day/hour + reduce categories
#  - Split datetime into day (dd/mm/YYYY) + hour ("HH:00")
#  - Keep key weather fields
#  - Reduce icon categories (keep your original mapping idea)
# ==========================================================
weather1 <- weather

# Separate and standardise day and time 
weather1$day <- as.Date(weather1$time)
weather1$day <- format(as.POSIXct(weather1$day,format='%Y/%m/%d'),format='%d/%m/%Y')
weather1$hour <- substr(weather1$time, 12,16)

# Select needed columns
weather_clean <- weather1 %>%
  dplyr::select(day, hour, visibility, temperature, dewPoint, pressure, 
                windSpeed, icon, humidity) %>%
  # collapse weather conditions
  dplyr::mutate(
    condition = dplyr::case_when(
      icon %in% c("partly-cloudy-night", "partly-cloudy-day") ~ "partly-cloudy",
      icon %in% c("clear-night", "clear-day") ~ "clear",
      TRUE ~ icon
    )
  ) %>%
  dplyr::select(-icon)


# ==========================================================
# Housekeeping
# ==========================================================

# Confirmation Message
cat("02_cleanTransform complete.\n",
    " smartMeter_clean        :", nrow(smartMeter_clean), "rows\n",
    " householdInfo_clean:", nrow(householdInfo_clean), "rows\n",
    " bankHols_clean     :", nrow(bankHols_clean), "rows\n",
    " rainfall_clean     :", nrow(rainfall_clean), "rows\n",
    " weather_clean      :", nrow(weather_clean), "rows\n")

# Clean environment
rm(weather1, rainfall1, smartMeter1, key_map)
