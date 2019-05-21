clear all
use "01_data/production_data/shale_production.dta"

set scheme s1mono
twoway (line amount year) (line marc year),  xscale(range(1990 2012)) xlabel(1990(2)2012) ytitle (Billion Cubic Feet / Day) xtitle (Year)

graph export "03_figures/figure_A1_shaleproduction.pdf"
