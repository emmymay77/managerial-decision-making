# managerial-decision-making
# Quantifying Managerial "Feel" in Major League Baseball

## Motivation

One of the recurring debates in baseball is the role of **data versus managerial "feel."** As analytics have become increasingly influential in on-field strategy, managerial decisions are often discussed as either analytically driven or based on a manager's intuition, experience, and feel for the game.

But are data and feel necessarily opposites?

Player value can be quantified using statistics such as Wins Above Replacement (WAR), but evaluating managers is more difficult. Managers influence games through a series of individual decisions, such as choosing a pinch hitter, deploying a pinch runner, deciding when to remove a starting pitcher, or selecting a reliever from the bullpen.

Each of these decisions has a different context and a different potential effect on the outcome of a game.

This project asks whether the concept of managerial **"feel" can itself be quantified.**

Rather than evaluating managers based only on whether their decisions happened to work, I aim to estimate the value created or lost by each managerial decision given the information available when the decision was made.

## Research Question

**Can managerial "feel" be quantified?**

More specifically:

**Can individual managerial decisions be assigned values based on their effects on expected runs and win probability, and can those values be aggregated into a WAR-style statistic for managerial decision-making?**

## Manager Decision Value

This project develops a working framework called **Manager Decision Value (MDV).**

For each managerial decision:

**MDV = Expected Value of Chosen Action - Expected Value of Baseline Action**

For example, if a manager chooses to pinch hit Player B for Player A:

**Pinch-Hit MDV = Expected Value(Player B) - Expected Value(Player A)**

Decision value can be considered through two related measures:

- **Run Value:** How much does the decision change the team's expected runs?
- **Win Value:** How much does the decision change the team's probability of winning?

The long-term goal is to determine how much weight different managerial decisions carry and whether those values can be aggregated into a season-level measure of managerial decision-making.

## Decision Quality vs. Outcome

A central part of this project is separating the **quality of a decision** from the **outcome of a decision**.

A pinch hitter recording a double does not necessarily mean the manager made a good decision. Similarly, a pinch hitter striking out does not necessarily mean the manager made a poor decision.

Instead, the decision should be evaluated using the information available when the manager made it.

If a manager replaces Player A with Player B, the relevant question is not simply:

**What did Player B do?**

Instead, the question is:

**Given the game situation and matchup, how did the expected value of using Player B compare with the expected value of leaving Player A in the game?**

Actual results can then be tracked separately from expected decision value.

## Initial Analysis: Pinch-Hitting Decisions

The first stage of this project focuses on **pinch-hitting decisions**.

For each pinch-hit substitution, the analysis will identify:

- Pinch hitter
- Player replaced
- Inning
- Score
- Number of outs
- Baserunner state
- Opposing pitcher
- Batter handedness
- Pitcher handedness
- Expected offensive value of the pinch hitter
- Expected offensive value of the original hitter
- Change in run expectancy
- Change in win expectancy

For the initial model, the baseline decision is **no substitution**.

Therefore:

**Pinch-Hit MDV = Expected Value(Pinch Hitter) - Expected Value(Original Hitter)**

## Downstream Effects

A pinch-hitting decision can affect more than the immediate plate appearance.

If the pinch hitter remains in the game, the substitution may also affect:

- Later plate appearances
- Defensive alignment
- Future batter-pitcher matchups

For example, if a player pinch hits in the sixth inning and remains in the game, both his sixth-inning plate appearance and his later plate appearances are consequences of the original managerial decision.

The long-term model will therefore consider both the immediate and downstream effects of a substitution.

## Data

This project uses MLB play-by-play and Statcast data accessed in R using the `baseballr` package.

MLB play-by-play data is used to identify managerial actions, including:

- Who entered the game
- Who was replaced
- When the substitution occurred
- What type of substitution occurred

Statcast data provides information about:

- Game state
- Batter-pitcher matchup
- Handedness
- Plate-appearance outcomes
- Run expectancy
- Win expectancy

## Long-Term Framework

The goal is to apply the same decision-value framework to several types of managerial decisions:

1. Pinch-hitting decisions
2. Pinch-running decisions
3. Starting-pitcher removal
4. Bullpen selection

Each type of decision requires a different model because the available alternatives and potential consequences differ.

Ultimately, the project will explore whether the values of individual decisions can be aggregated into a broader measure of how much value a manager creates or loses through in-game decision-making.

Conceptually, the goal is a **WAR-style statistic for managers**.

However, defining a true "replacement-level manager" will require additional research. For now, the project uses **Manager Decision Value (MDV)** as a working framework.

## Project Status

**Active Development**

The current implementation focuses on identifying and validating pinch-hitting decisions before estimating their expected run and win value across a larger MLB sample.