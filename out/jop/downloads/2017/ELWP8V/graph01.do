* Generate preferences for poor (under 17,000 PPP-corrected 2010 dollars below the country mean)

gen redpref1a=.
replace redpref1a=redpref1 if incomedif<=-1.7

* Generate preferences for rich (over 9,000 PPP-corrected 2010 dollars above the country mean)

gen redpref1b=.
replace redpref1b=redpref1 if incomedif>=.9

graph bar (mean) redpref1b redpref1 redpref1a, legend(label(1 "Rich") label(2 "Mean") label(3 "Poor") rows(1)) ///
over(country) plotregion(fcolor(white)) graphregion(fcolor(white)) scheme(sj)
graph export graph01.pdf, replace
