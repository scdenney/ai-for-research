Make one revision:

- Report the task structure unambiguously: **8 primary randomized tasks + 1 repeated reliability task = 9 administered choice tasks per respondent**. Keep 6,400 as the balance-check denominator because the repeated task reuses task-1 profiles and adds no new randomized profiles.
- Compute tasks per respondent and profiles per respondent-task directly, then assert they are constant; the current code counts globally unique task/profile IDs.
- Add the equal-allocation benchmark or percentage-point deviation to the balance table. That turns the frequency listing into an explicit balance check without adding an inappropriate significance test.
- Replace the slightly inaccurate caption claim that each facet is “scaled.” Suggested caption: “Observed shares of the 6,400 randomized profiles assigned to each attribute level; percentages sum to 100 within each facet.”

Everything else satisfies the brief: human-readable labels, one figure, no in-plot title, 320 dpi, declared theme and Okabe–Ito palette, deterministic script, and correct exclusion of the repeated task from balance counts.