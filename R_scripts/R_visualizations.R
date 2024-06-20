### Visualization code for SQL Query 1 ###

# Load necessary libraries
library(ggplot2)
library(readr) # For reading CSV file
library(scales) # For formatting

# Read the CSV file
data <- read_csv("top_salaries_data_scientist.csv")  # Replace with your location of the file

# Ensure salary_year_avg is numeric
data$salary_year_avg <- as.numeric(data$salary_year_avg)

# Take top 10 salaries
top_10 <- head(data, 10)

# Truncate job titles to make them shorter
top_10$job_title <- substr(top_10$job_title, 1, 23)

# Create a horizontal bar plot with formatted salary labels
ggplot(top_10, aes(x = salary_year_avg, y = reorder(job_title, -salary_year_avg))) +
  geom_bar(stat = "identity", fill = "skyblue", alpha = 0.7) +
  labs(title = "Top 10 Highest Paying Data Scientist Jobs",
       x = "Average Yearly Salary",
       y = "Job Title") +
  scale_x_continuous(labels = dollar_format(prefix = "$", suffix = "k", scale = 1e-3)) +  # Format salary labels
  theme_minimal() +
  theme(axis.text.y = element_text(face = "bold", size = 10),
        axis.text.x = element_text(size = 10),
        axis.title = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"))



##########################

### Visualization code for SQL Query 2 ###

# Load necessary library
library(ggplot2)

# Read the CSV file
skills_data <- read.csv("top_paying_job_skills_data_scientist.csv")

# Count the frequency of each skill
skill_counts <- table(skills_data$skill)
skill_counts <- as.data.frame(skill_counts)
colnames(skill_counts) <- c("skill", "count")

# Create a bar plot for skill counts with reversed order and gradient color
ggplot(skill_counts, aes(x = reorder(skill, count), y = count, fill = count)) +
  geom_bar(stat = "identity") +
  coord_flip() +  # Flip coordinates to make it horizontal
  labs(title = "Skill Count for Top 10 Highest Paying Data Scientist Jobs",
       x = "Skill",
       y = "Frequency") +
  scale_fill_gradient(low = "lightblue", high = "blue") +  # Gradient color
  theme_minimal() +
  theme(legend.position = "none")  # Hide the legend


