use F4.dta, clear
twoway(scatter entmax day, xline(16.5) xline(18.5) xtitle("Day") ytitle("Entry at mode")), name(a, replace)
twoway(scatter exitmax day, xline(16.5) xline(18.5) xtitle("Day") ytitle("Exit at mode")), name(b, replace)
twoway(scatter duration day, xline(16.5) xline(18.5) xtitle("Day") ytitle("Mean duration (mins.)")), name(c, replace)
twoway(scatter sd_dur day, xline(16.5) xline(18.5) xtitle("Day") ytitle("Standard deviation duration")), name(d, replace)
graph combine a b c d
