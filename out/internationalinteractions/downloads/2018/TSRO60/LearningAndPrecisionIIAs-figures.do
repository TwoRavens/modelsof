// Replication code to generate the figures in Manger & Peinhardt (2016), "Learning and the Precision of
// International Investment Agreements"
// Estimated with Stata 14.2. Data files are in Stata 11 format.
clear
//
//
//
//
// For  Figure 1: Precision Mean and Range, 1959-2009
//
use LearningAndPrecisionIIAs-figure1.dta
twoway  (rbar precAnnualMax precAnnualMin year, color(gs13)) ///
(line precAnnualMean year, color(gs0)), ytitle(Precision score) xtitle(Year) legend(off) scheme(s1mono) ylabel(, grid)
//
// optionally you can save it as a PDF by uncommenting this line
// graph export figure1.pdf
//
// Figure 2: Precision in Canadian, German and US Model BITs, 1984-2012
//
use LearningAndPrecisionIIAs-figure2.dta
twoway (scatter precision year if iso1=="USA" | iso1=="DEU" | iso1=="CAN", msize(small) mlabel( modelLabel ) ///
 mlabsize(small)),  ytitle(Year) xtitle(Precision) legend(off) scheme(s2mono)
//
// graph export figure2.pdf
//
// For the last figure we can use the analysis data set
//
// Figure 3: Precision in German BITs, 1959-2009
//
use LearningAndPrecisionIIAs-analysis.dta
twoway (scatter precision year if iso1=="DEU", msize(tiny) mlabel(iso2) mlabsize(tiny)), ///
 ytitle(Year) xtitle(Precision) legend(off) scheme(s2mono)
//
// graph export figure3.pdf
//


