# Mozambique
moz = SF_RAW_DATA_SPECIES[FLEET_CODE == "MOZ" & FISHERY_CODE == "LLO"]
moz_expanded = moz[rep(seq_len(.N), FISH_COUNT)][, -c("FISH_COUNT")]

moz[, {
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

# Malaysia
mys = SF_RAW_DATA_SPECIES[FLEET_CODE == "MYS" & FISHERY_CODE == "LLF"]

mys[, {
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
