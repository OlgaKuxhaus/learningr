# Load the packages
library(tidyverse)
library(NHANES)

# Check column names
colnames(NHANES)

# Look at contents
str(NHANES)
glimpse(NHANES)

# See summary
summary(NHANES)

# Look over the dataset documentation
?NHANES

#The pipe operator %>%
NHANES %>%
  colnames()

# The pipe way of chaining
NHANES %>%
  head() %>%
  glimpse()

#Transforming or adding variables
NHANES_modified <- NHANES %>% # dataset
  mutate(
    # 1. Calculate average urine volume
    UrineVolAverage = (UrineVol1 + UrineVol2) / 2,
    # 2. Modify Pulse variable
    Pulse = Pulse/60,
    # 3. Create YoungChild variable using a condition
    YoungChild= if_else(Age<6, "yes", "no")
  )
NHANES_modified

# Select specific data by the variables
NHANES %>%
  select(starts_with("BP"), contains("Vol"))

# Rename specific columns
NHANES %>%
  rename(NumberBabies = nBabies)

# Filtering/subsetting the data by row
NHANES %>%
  filter(BMI == 25 & Gender == "female")
NHANES %>%
  filter(BMI == 25 | Gender == "female") %>%
  #select(Gender,BMI)

#Sorting/(re)arranging your data by column
  NHANES %>%
  arrange(Age, Gender) %>%
  select(Age, Gender)

NHANES %>%
  arrange(desc(Age)) %>%
  select(Age)


# Exercise ----------------------------------------------------------------

# To see values of categorical data
summary(NHANES)

# 1. BMI between 20 and 40 and who have diabetes
NHANES %>%
  # format: variable >= number
  filter(BMI >= 20 & BMI <= 40 & Diabetes == 1)

# 2. Working or renting, and not diabetes
NHANES %>%
  filter(Work == 3 | HomeOwn == 2 & Diabetes != 1) %>%
  select(Age, Gender, Work, HomeOwn, Diabetes)

# 3. How old is person with most number of children.
NHANES %>%
  filter(nBabies == max(nBabies, na.rm=T)) %>%
  select(Age,nBabies)
# End of Exercise ----------------------------------------------------------------

#Create a summary of the data, alone or by a group(s)
NHANES %>%
  summarise(MaxAge = max(Age, na.rm = TRUE),
            MeanBMI = mean(BMI, na.rm = TRUE))
NHANES %>%
  group_by(Gender) %>%
  summarise(MaxAge = max(Age, na.rm = TRUE),
            MeanBMI = mean(BMI, na.rm = TRUE))
NHANES %>%
  group_by(Gender, Diabetes) %>%
  summarise(MeanAge = mean(Age, na.rm = TRUE),
            MeanBMI = mean(BMI, na.rm = TRUE))
# gather(): Converting from wide to long form
nhanes_chars <- NHANES %>%
  select(SurveyYr, Gender, Age, Weight, Height, BMI, BPSysAve)
nhanes_chars

# Convert to long form, excluding year and gender
nhanes_long <- nhanes_chars %>%
  gather(Measure, Value, -SurveyYr, -Gender)
nhanes_long
# Calculate mean on each measure, by gender and year
nhanes_long %>%
  group_by(SurveyYr, Gender, Measure) %>%
  summarise(MeanValue = mean(Value, na.rm = TRUE))

#spread(): (If time) Converting from long to wide form
# Convert to wide form
head(table2)
table2 %>%
  spread(key = type, value = count)

# Exercise ----------------------------------------------------------------
nhanes_table <- NHANES %>%
  rename(AgeDiabetesDiagnosis	= DiabetesAge,DrinksOfAlcoholInDay=AlcoholDay,
         NumberOfBabies=nBabies,TotalCholesterol=TotChol) %>%
  mutate(MoreThan5DaysActive=if_else(PhysActiveDays>=5,T,F)) %>%
  select(SurveyYr, Gender, Age, AgeDiabetesDiagnosis, BMI, BPDiaAve, BPSysAve,
         DrinksOfAlcoholInDay, MoreThan5DaysActive,NumberOfBabies,Poverty,TotalCholesterol) %>%
  filter(Age>=18 & Age<=75)
nhanes_table

nhanes_table %>%
  gather(Measure, Value, -SurveyYr, -Gender) %>%
  group_by(SurveyYr, Gender, Measure) %>%
  summarise(Mean = round(mean(Value, na.rm = T),2)) %>%
  arrange(Measure, Gender, SurveyYr) %>%
  spread(SurveyYr, Mean)

# End of Exercise ----------------------------------------------------------------
