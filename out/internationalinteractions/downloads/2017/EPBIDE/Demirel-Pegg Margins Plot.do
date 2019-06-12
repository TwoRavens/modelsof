
***For Predicted Probabilities

use "E:\Demirel-Pegg.dta", clear



zinb protcamp weeknum i.treat weeknumafter repression accommodation, inflate(weeknum i.treat weeknumafter repression accommodation)

***Margins for after weeknumbers


margins, at(weeknumafter =(0(4)125))

marginsplot, legend(position(1) ring(0) cols(3))

marginsplot, legend(position(1) ring(0) cols(3)) recastci(rarea)


