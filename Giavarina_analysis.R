#--------------------------------------Giavarina Analysis (does not need normality)------------------------------#

library(blandr)
library(ggplot2)
library(mcr)
library(scales)
library(tidyverse)
df <- read.csv2("Dlcsolo.csv", sep = ",", dec = ".", fileEncoding="UTF-8-BOM")
dlc <- df$Dlc_sleep_row
sol <- df$Sol_sleep_row

means <- (sol + dlc) / 2
diffs <- sol-dlc
percent_diffs = diffs / means * 100
df2 <- data.frame(means = means,
                  percent_diffs = percent_diffs
                  )
df2 = drop_na(df2)
bias <- mean(df2$percent_diffs)
sd <- sd(df2$percent_diffs)
upper_loa <- bias + 1.96 * sd
lower_loa <- bias - 1.96 * sd

n <- nrow(df2)
# We want 95% confidence intervals
conf_int <- 0.95
# Endpoints of the range that contains 95% of the Student's t distribution
t1 <- qt((1 - conf_int) / 2, df = n - 1)
t2 <- qt((conf_int + 1) / 2, df = n - 1)
# Variance
var <- sd**2
# Standard error of the bias
se_bias <- sqrt(var / n)
# Standard error of the limits of agreement
se_loas <- sqrt(3 * var / n)
# Confidence intervals
upper_loa_ci_lower <- upper_loa + t1 * se_loas
upper_loa_ci_upper <- upper_loa + t2 * se_loas
bias_ci_lower <- bias + t1 * se_bias
bias_ci_upper <- bias + t2 * se_bias
lower_loa_ci_lower <- lower_loa + t1 * se_loas
lower_loa_ci_upper <- lower_loa + t2 * se_loas



# Maximise the size of the plot
par(pty = "m")
# Get domain and range
domain <- max(df2$means) - min(df2$means)
range <- max(df2$percent_diffs) - min(df2$percent_diffs)
# Scatter plot
plot(
  # Data to plot
  df2$means, df2$percent_diffs,
  # Axis labels
  main = "Giavarina Plot for Two Hypothetical Measurement Methods", xlab = "Mean", ylab = "Percentage Difference (%)",
  pch = 21, col = "black", bg="gray",
  # Axis control
  xlim = c(min(df2$means) - 0.1 * domain, max(df2$means) + 0.25 * domain),
 ylim = c(min(df2$percent_diffs) - 0.3 * range, max(df2$percent_diffs) + 0.3 * range),
  xaxs = "i", yaxs = "i"
)
# Zero line
abline(h = 0, col = "darkgrey")
# Upper confidence interval
abline(h = upper_loa, lty = "dashed", col = "gray18")
# Bias
abline(h = bias, lty = "dashed", col = "gray18")
# Lower confidence interval
abline(h = lower_loa, lty = "dashed", col = "gray18")
# Upper confidence interval labels
text(max(df2$means) + 0.13 * domain, upper_loa + 0.04 * range, labels = "+1.96×SD")
text(max(df2$means) + 0.13 * domain, upper_loa - 0.04 * range, labels = sprintf("%+4.2f%%", upper_loa))
# Bias labels
text(max(df2$means) + 0.13 * domain, bias + 0.04 * range, labels = "Bias")
text(max(df2$means) + 0.13 * domain, bias - 0.04 * range, labels = sprintf("%+4.2f%%", bias))
# Lower confidence interval labels
text(max(df2$means) + 0.13 * domain, lower_loa + 0.04 * range, labels = "-1.96×SD")
text(max(df2$means) + 0.13 * domain, lower_loa - 0.04 * range, labels = sprintf("%+4.2f%%", lower_loa))
# X-values for confidence interval lines
left <- min(df2$means) - 0.08 * domain
mid <- min(df2$means) - 0.05 * domain
right <- min(df2$means) - 0.02 * domain
# Upper confidence interval lines
segments(left, upper_loa_ci_upper, x1 = right, y1 = upper_loa_ci_upper, lty = "dashed", col = "gray68")
segments(mid, upper_loa_ci_lower, x1 = mid, y1 = upper_loa_ci_upper, lty = "dashed", col = "gray68")
segments(left, upper_loa_ci_lower, x1 = right, y1 = upper_loa_ci_lower, lty = "dashed", col = "gray68")
# Bias confidence interval lines
segments(left, bias_ci_upper, x1 = right, y1 = bias_ci_upper, lty = "dashed", col = "gray68")
segments(mid, bias_ci_lower, x1 = mid, y1 = bias_ci_upper, lty = "dashed", col = "gray68")
segments(left, bias_ci_lower, x1 = right, y1 = bias_ci_lower, lty = "dashed", col = "gray68")
# Lower confidence interval lines
segments(left, lower_loa_ci_upper, x1 = right, y1 = lower_loa_ci_upper, lty = "dashed", col = "gray68")
segments(mid, lower_loa_ci_lower, x1 = mid, y1 = lower_loa_ci_upper, lty = "dashed", col = "gray68")
segments(left, lower_loa_ci_lower, x1 = right, y1 = lower_loa_ci_lower, lty = "dashed", col = "gray68")



