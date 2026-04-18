# Small SWO in 2016
syc          = FL_STD_DATA_SPECIES[FLEET_CODE == "SYC" & GEAR_CODE == "ELL"]
syc_extended = syc[rep(seq_len(.N), FISH_COUNT)][, -c("FISH_COUNT")]

ggplot(data = syc_extended[YEAR>2012], aes(x = CLASS_LOW)) + 
  geom_histogram() + 
  facet_wrap(~YEAR, scale = "free_y", nrow = 6)


syc[, {
  x <- (CLASS_LOW + CLASS_HIGH)/2
  w <- FISH_COUNT
  
  qs <- wtd.quantile(x, weights = w,
                     probs = c(0.05, 0.25, 0.50, 0.75, 0.95),
                     normwt = FALSE)
  
  .(
    mean = weighted.mean(x, w),
    q05 = qs[1],
    q25 = qs[2],
    q50 = qs[3],
    q75 = qs[4],
    q95 = qs[5]
  )
}, keyby = YEAR]