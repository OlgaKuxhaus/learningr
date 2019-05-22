
# Project management ------------------------------------------------------

# This is a dataframe:
head(iris)
# Column names
colnames(iris)


# Structure
str(iris)

# Summary statistics
summary(iris)

source(here::here("R/package-loading.R"))
write_csv(iris, here::here("data/iris.csv"))
imported_iris <- read_csv(here::here("data/iris.csv"))
head(imported_iris)


# Data management ---------------------------------------------------------
NHANES
glimpse(NHANES)

