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

test_game <- pa_data$game_pk[1]

test_game

test_lineup <- mlb_batting_orders(
  game_pk = test_game,
  type = "all"
)

View(test_lineup)

test_pbp <- mlb_pbp(test_game)
View(test_pbp)
names(test_pbp) 
substitutions <- test_pbp %>%
  filter(isSubstitution == TRUE)
View(substitutions)
substitutions_clean <- substitutions %>%
  select(
    about.inning,
    about.halfInning,
    details.description,
    details.event,
    details.eventType,
    player.id,
    replacedPlayer.id,
    position.name,
    battingOrder
  )
View(substitutions_clean)
pinch_hit_subs <- substitutions_clean %>%
  filter(
    str_detect(
      details.description,
      regex("pinch", ignore_case = TRUE)
    )
  )
View(pinch_hit_subs)

# connect the managerial decision to the actual plate appearance in Statcast

pinch_hit_subs %>%
  select(
    about.inning,
    about.halfInning,
    details.description,
    player.id,
    replacedPlayer.id
  )

mountcastle_id <- test_lineup %>%
  filter(fullName == "Ryan Mountcastle") %>%
  pull(id)

mountcastle_pa <- pa_data %>%
  filter(
    game_pk == test_game,
    batter == mountcastle_id
  )
View(mountcastle_pa)
mountcastle_pa %>%
  select(
    inning,
    inning_topbot,
    at_bat_number,
    events,
    pitcher,
    stand,
    p_throws,
    outs_when_up,
    on_1b,
    on_2b,
    on_3b,
    home_score,
    away_score,
    woba_value,
    delta_run_exp,
    delta_home_win_exp,
    des
  )

# --------------------------------------------------
# IDENTIFY PINCH-HITTING DECISIONS
# --------------------------------------------------

pinch_hit_subs %>%
  select(
    details.description,
    details.event,
    details.eventType,
    position.name
  ) %>%
  as.data.frame()

# Function to identify all pinch-hitting decisions in a game

get_pinch_hit_decisions <- function(game_id) {
  
  # Pull play-by-play data for the game
  pbp <- mlb_pbp(game_id)
  
  # If this game has no substitution information, return nothing
  if (!"isSubstitution" %in% names(pbp)) {
    return(tibble())
  }
  
  # Identify pinch-hitting substitutions
  pinch_hits <- pbp %>%
    filter(
      isSubstitution == TRUE,
      position.name == "Pinch Hitter"
    ) %>%
    select(
      any_of(c(
        "about.inning",
        "about.halfInning",
        "batting_team",
        "player.id",
        "replacedPlayer.id",
        "battingOrder",
        "details.description"
      ))
    ) %>%
    mutate(
      game_pk = game_id
    )
  
  return(pinch_hits)
}

# test the new function
test_pinch_decisions <- get_pinch_hit_decisions(test_game)

View(test_pinch_decisions)

# test for a new game

game_ids <- pa_data %>%
  distinct(game_pk) %>%
  pull(game_pk)

length(game_ids)
head(game_ids)

second_game_test <- get_pinch_hit_decisions(game_ids[2])
View(second_game_test)

# apply function to every game

all_pinch_hit_decisions <- map_dfr(
  game_ids,
  get_pinch_hit_decisions
)
nrow(all_pinch_hit_decisions)
View(all_pinch_hit_decisions)
all_pinch_hit_decisions %>%
  count(batting_team, sort = TRUE)

# test game 8 (no pinch-hit substitutions)
game_8_pbp <- mlb_pbp(game_ids[8])
game_ids[8]
game_8_pbp %>%
  filter(
    isSubstitution == TRUE,
    position.name == "Pinch Hitter"
  ) %>%
  select(
    any_of(c(
      "details.description",
      "player.id",
      "replacedPlayer.id",
      "position.name"
    ))
  )

# --------------------------------------------------
# IDENTIFY MANAGER RESPONSIBLE FOR EACH DECISION
# --------------------------------------------------

# TODO: attach the responsible manager to each team/game
