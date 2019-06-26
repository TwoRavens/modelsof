*Author: Mitch Radtke and Hyeran Jo 
*Project: Fighting the Hydra (Supplemental Document, Part I)
*Date Last Modified: October 23, 2017

*Opening up macro-level data

use "E:\Hyeran\Hydra\RR2\Replication\Data\RadtkeJo_JPR_Macro.dta", clear

*Figure A1 (Histogram of Battle Deaths to display appropriateness of Negative Binomial)
hist bdbest_ucdp if bdbest_ucdp<=2000, freq graphr(fcolor(white)) ytitle("Frequency", height(7)) xtitle("Battle Deaths", height (5)) fc(black) lc(gray)

*Table A1 (Summary statistics for Battle Deaths across Adaptability Scale--appropriatness of Negative Binomial
summarize bdbest_ucdp if adapt_scale_c==0, detail
summarize bdbest_ucdp if adapt_scale_c==1, detail
summarize bdbest_ucdp if adapt_scale_c==2, detail
summarize bdbest_ucdp if adapt_scale_c==3, detail
summarize bdbest_ucdp if adapt_scale_c==4, detail


