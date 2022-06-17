############
# Helper functions for Bisnode analysis

twoClassSummaryExtended <- function (data, lev = NULL, model = NULL)
{
  lvls <- levels(data$obs)
  rmse <- sqrt(mean((data[, lvls[1]] - ifelse(data$obs == lev[2], 0, 1))^2))
  c(defaultSummary(data, lev, model), "RMSE" = rmse)
}


createRocPlot <- function(r, file_name,  myheight_small = 5.625, mywidth_small = 7.5) {
  all_coords <- coords(r, x="all", ret="all", transpose = FALSE)
  
  roc_plot <- ggplot(data = all_coords, aes(x = fpr, y = tpr)) +
    geom_line(color='red', size = 0.7) +
    geom_area(aes(fill = 'green', alpha=0.4), alpha = 0.3, position = 'identity', color = 'red') +
    scale_fill_viridis(discrete = TRUE, begin=0.6, alpha=0.5, guide = "none") +
    xlab("False Positive Rate (1-Specifity)") +
    ylab("True Positive Rate (Sensitivity)") +
    geom_abline(intercept = 0, slope = 1,  linetype = "dotted", col = "black") +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, .1), expand = c(0, 0.01)) +
    scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, .1), expand = c(0.01, 0)) +
    theme_bw()
  
  roc_plot
}


create_calibration_plot <- function(data, prob_var, actual_var, y_lab = "Actual event probability" , n_bins = 10, breaks = NULL) {
  
  if (is.null(breaks)) {
    breaks <- seq(0,1,length.out = n_bins + 1)
  }
  
  binned_data <- data %>%
    mutate(
      prob_bin = cut(!!as.name(prob_var), 
                     breaks = breaks,
                     include.lowest = TRUE)
    ) %>%
    group_by(prob_bin, .drop=FALSE) %>%
    summarise(mean_prob = mean(!!as.name(prob_var)), mean_actual = mean(!!as.name(actual_var)), n = n())
  
  p <- ggplot(data = binned_data) +
    geom_line(aes(mean_prob, mean_actual), color='red', size=0.6, show.legend = TRUE) +
    geom_point(aes(mean_prob,mean_actual), color = 'red', size = 1, shape = 16, alpha = 0.7, show.legend=F, na.rm = TRUE) +
    geom_segment(x=min(breaks), xend=max(breaks), y=min(breaks), yend=max(breaks), color='blue', size=0.3) +
    theme_bw() +
    labs(x= "Predicted event probability",
         y= y_lab) +
    coord_cartesian(xlim=c(0,1), ylim=c(0,1))+
    expand_limits(x = 0.01, y = 0.01) +
    scale_y_continuous(expand=c(0.01,0.01),breaks=c(seq(0,1,0.1))) +
    scale_x_continuous(expand=c(0.01,0.01),breaks=c(seq(0,1,0.1))) 
  
  p
}


createLossPlot <- function(r, best_coords,  myheight_small = 5.625, mywidth_small = 7.5) {
  t <- best_coords$threshold[1]
  sp <- best_coords$specificity[1]
  se <- best_coords$sensitivity[1]
  n <- rowSums(best_coords[c("tn", "tp", "fn", "fp")])[1]
  
  all_coords <- coords(r, x="all", ret="all", transpose = FALSE)
  all_coords <- all_coords %>%
    mutate(loss = (fp*FP + fn*FN)/n)
  l <- all_coords[all_coords$threshold == t, "loss"]
  
  loss_plot <- ggplot(data = all_coords, aes(x = threshold, y = loss)) +
    geom_line(color='red', size=0.7) +
    scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.1)) +
    geom_vline(xintercept = t , color = 'blue' ) +
    annotate(geom = "text", x = t, y= min(all_coords$loss),
             label=paste0("best threshold: ", round(t,2)),
             colour='blue', angle=90, vjust = -1, hjust = -0.5, size = 7) +
    annotate(geom = "text", x = t, y= l,
             label= round(l, 2), hjust = -0.3, size = 7) +
    theme_bw()
  
  loss_plot
}


createRocPlotWithOptimal <- function(r, best_coords, file_name,  myheight_small = 5.625, mywidth_small = 7.5) {
  
  all_coords <- coords(r, x="all", ret="all", transpose = FALSE)
  t <- best_coords$threshold[1]
  sp <- best_coords$specificity[1]
  se <- best_coords$sensitivity[1]
  
  roc_plot <- ggplot(data = all_coords, aes(x = specificity, y = sensitivity)) +
    geom_line(color='red', size=0.7) +
    scale_y_continuous(breaks = seq(0, 1, by = 0.1)) +
    scale_x_reverse(breaks = seq(0, 1, by = 0.1)) +
    geom_point(aes(x = sp, y = se)) +
    annotate(geom = "text", x = sp, y = se,
             label = paste(round(sp, 2),round(se, 2),sep = ", "),
             hjust = 1, vjust = -1, size = 7) +
    xlab("False Positive Rate (1-Specifity)") +
    ylab("True Positive Rate (Sensitivity)") +
    theme_bw()

  
  roc_plot
}
