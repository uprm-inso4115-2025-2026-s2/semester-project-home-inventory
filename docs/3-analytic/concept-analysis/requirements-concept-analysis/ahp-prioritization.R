#!/usr/bin/env Rscript

# AHP-based requirement prioritization for Section 3.1
# This script demonstrates how to compute criteria weights, local requirement weights,
# and a final global ranking using an AHP-style process.

if (!requireNamespace("ahp", quietly = TRUE)) {
  install.packages("ahp", repos = "https://cloud.r-project.org")
}

library(ahp)

compute_weights <- function(mat) {
  ev <- eigen(mat)
  principal <- Re(ev$vectors[, 1])
  principal <- abs(principal)
  weights <- principal / sum(principal)
  return(weights)
}

compute_consistency_ratio <- function(mat) {
  n <- nrow(mat)
  ev <- eigen(mat)$values
  lambda_max <- max(Re(ev))
  ci <- (lambda_max - n) / (n - 1)
  ri_values <- c(0.00, 0.00, 0.58, 0.90, 1.12, 1.24, 1.32, 1.41, 1.45, 1.49)
  if (n <= length(ri_values)) {
    ri <- ri_values[n]
    return(ifelse(ri == 0, NA, ci / ri))
  }
  return(NA)
}

create_pairwise_matrix <- function(values) {
  mat <- outer(values, 1 / values)
  dimnames(mat) <- list(names(values), names(values))
  return(mat)
}

aggregate_matrices <- function(matrices) {
  Reduce("+", matrices) / length(matrices)
}

criteria <- c(
  "User value",
  "Feasibility",
  "Impact",
  "Implementation complexity"
)

criteria_weights_input <- c(
  "User value" = 4,
  "Feasibility" = 2,
  "Impact" = 3,
  "Implementation complexity" = 1
)

criteria_matrix <- create_pairwise_matrix(criteria_weights_input)
criteria_weights <- compute_weights(criteria_matrix)

requirements <- c(
  "Core inventory capture",
  "Shared visibility",
  "Low-stock alerts",
  "Expiration awareness",
  "Restock list auto-add",
  "Transaction history"
)

# Example local importance weights for the sample requirements under each criterion.
user_value_weights <- c(4, 3, 3, 2, 1, 0.5)
feasibility_weights <- c(4, 2, 2, 1.5, 1, 3)
impact_weights <- c(2.5, 3, 4, 3.5, 1.5, 1)
complexity_weights <- c(4, 2.5, 2, 1.5, 1, 3)

local_matrices <- list(
  UserValue = create_pairwise_matrix(setNames(user_value_weights, requirements)),
  Feasibility = create_pairwise_matrix(setNames(feasibility_weights, requirements)),
  Impact = create_pairwise_matrix(setNames(impact_weights, requirements)),
  Complexity = create_pairwise_matrix(setNames(complexity_weights, requirements))
)

local_weights <- sapply(local_matrices, compute_weights)
rownames(local_weights) <- requirements

global_scores <- local_weights %*% criteria_weights
ranking <- order(global_scores, decreasing = TRUE)

cat("AHP-Based Requirement Prioritization\n")
cat("===============================\n\n")
cat("Criteria weights (aggregated):\n")
print(round(criteria_weights, 3))
cat("\n")
cat("Local requirement weights by criterion:\n")
print(round(local_weights, 3))
cat("\n")
cat("Consistency ratios:\n")
for (name in names(local_matrices)) {
  cr <- compute_consistency_ratio(local_matrices[[name]])
  cat(sprintf(" - %s: %s\n", name, ifelse(is.na(cr), "N/A", format(round(cr, 3), nsmall = 3))))
}
cat(sprintf(" - Criteria matrix: %s\n", ifelse(is.na(compute_consistency_ratio(criteria_matrix)), "N/A", format(round(compute_consistency_ratio(criteria_matrix), 3), nsmall = 3))))
cat("\n")
cat("Global requirement scores and ranking:\n")
result <- data.frame(
  Requirement = requirements,
  Score = round(as.numeric(global_scores), 4),
  Rank = rank(-as.numeric(global_scores), ties.method = "min")
)
result <- result[order(result$Rank), ]
print(result)
cat("\n")
cat("Final prioritized requirements (highest to lowest):\n")
cat(paste(result$Requirement, collapse = " -> "), "\n")

cat("\nNote: Replace the sample weights with actual team pairwise comparisons.\n")
cat("Use aggregate_matrices() to combine individual team matrices before computing weights.\n")
