# MLB Managerial Decision-Making
# Initial project setup


library(tidyverse)
library(baseballr)

# Pull a small sample of Statcast data
sample_data <- statcast_search(
  start_date = "2025-04-01",
  end_date = "2025-04-03"
)

View(sample_data)
dim(sample_data)
names(sample_data)

# Keep variables relevant to managerial decision-making
manager_data <- sample_data %>%
  select(
    game_pk,
    game_date,
    home_team,
    away_team,
    inning,
    inning_topbot,
    at_bat_number,
    batter,
    pitcher,
    stand,
    p_throws,
    events,
    description,
    des,
    outs_when_up,
    on_1b,
    on_2b,
    on_3b,
    home_score,
    away_score,
    estimated_ba_using_speedangle,
    estimated_woba_using_speedangle,
    woba_value,
    delta_run_exp,
    delta_home_win_exp
  )
View(manager_data)

#keep only completed plate appearances
pa_data <- manager_data %>%
  filter(!is.na(events))
View(pa_data)
nrow(manager_data)
nrow(pa_data)
pa_data %>%
  count(events, sort = TRUE)

# next goal is identifying pinch hitters within the data

