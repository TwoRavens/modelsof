sort generation fitness_criterion run
by generation: egen genmedian = median(fitness) if fitness_criterion == 1
by generation: egen genmean = mean(fitness) if fitness_criterion == 1
twoway (line genmean generation, clpat(solid)) (line genmedian generation, clpat(longdash_dot)), ytitle(Periods of Discord) ylabel(10(10)60) xtitle(Generation) legend(textfirst cols(1) symxsize(8) order(1 "mean" 2 "median") size(small)) legend(position(11) ring(0) region(lcolor(none))) scheme(s2mono)
drop genmean genmedian
