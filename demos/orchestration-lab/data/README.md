# Data

This demo commits no data files. Every run loads the same real, public dataset at runtime:

- **Source:** `exampleData1` from the [projoint](https://cran.r-project.org/package=projoint) R package — a wide-format Qualtrics export from a community-choice conjoint experiment (400 respondents, 8 choice tasks, 2 profiles per task, 7 attributes, one repeated task for reliability checks).
- **Install:** `install.packages("projoint")`
- **Load:** `library(projoint); data(exampleData1)`
- **Attributes:** Housing Cost, Presidential Vote (2020), Racial Composition, School Quality, Total Daily Driving Time, Type of Place, and Violent Crime Rate (vs national rate).
- **Cite:** the projoint package and its accompanying paper (see `citation("projoint")` for the current reference).

Using package-shipped data keeps the demo reproducible with zero downloads and no redistribution questions.
