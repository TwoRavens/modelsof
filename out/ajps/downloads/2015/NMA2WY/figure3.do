set scheme s1mono

use "study 1 wave 1.dta", clear

keep if trained == 0

replace screen = screen * 4

#delimit;

gr bar (mean) correct_color correct_feel correct_web correct_int
	,
		bar(1, fcolor(gray) lcol(black) lwidth(medium))
		bar(2, fcolor(gray) lcol(black) lwidth(medium))
		bar(3, fcolor(gray) lcol(black) lwidth(medium))
		bar(4, fcolor(gray) lcol(black) lwidth(medium))
		
		showyvars
		bargap(15)
		legend(off)
		
		ylab(0(.2)1.0, nogrid)
		yvaroptions(
			relabel(
				1 "Color"
				2 "Feeling"
				3 "Web"
				4 "Interest"
			)
		)
		
		title("Passage by Question Type", size(huge))

		name(g1, replace)
		
		;

#delimit cr


#delimit;

catplot screen
	,
		vertical
		ytitle("")
		
		ylab(0 "0" 20 ".2" 40 ".4" 60 ".6" 80 ".8" 100 "1", nogrid)
				
		bar(1, fcolor(gray) lcol(black) lwidth(medium))
		percent
		
		bargap(15)
		b1title("")
		
		
		
		title("Number of Screeners Passed", size(huge))
	
		name(g2, replace)	
		
		;
		
#delimit cr

gr combine g1 g2, ysize(1) xsize(2.5)
gr export "figure3.eps", replace
