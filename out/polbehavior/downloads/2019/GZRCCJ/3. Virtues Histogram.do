
clear
set more off

quiet: do "1. Virtues Prepare Variables.do"

hist partybonding, percent discrete xla(1/4, valuelabel noticks) xtitle("Partisan Bonding") gap(10) graphregion(color(white)) bgcolor(white) bcolor(black)
graph export "Histogram Partisan Bonding.png", replace

hist partybridging, percent discrete xla(1/4, valuelabel noticks) xtitle("Partisan Bridging") gap(10) graphregion(color(white)) bgcolor(white) bcolor(black)
graph export "Histogram Partisan Bridging.png", replace
