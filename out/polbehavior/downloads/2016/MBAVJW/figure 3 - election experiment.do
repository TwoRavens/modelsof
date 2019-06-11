set more off 

use "ssi", clear

keep if independent == 0

local j = 1

label variable ln_givsec "Non-Congregation Giving"

*** recode log scale ***

forvalues i = 1(1)1000 {
	local log`i' = log(`i'+1)
}
local loghalf = log(.5 + 1)

label variable change_eco "Economic perceptions"
label variable ln_vacation "Vacation spending ($)" 
label variable ln_totgiv "Total giving ($)"

foreach y in change_eco ln_vacation ln_totgiv {

	preserve

		local mytitle : var label `y'

		collapse `y' l`y' income, by(republican)

		rename `y' `y'2
		rename l`y' `y'1

		reshape i republican
		reshape j wave
		reshape xi
		reshape xij `y'
		reshape long
		
		su `y' if wave == 1 & republican == 0
		di exp(r(mean)) - 1
		su `y' if wave == 2 & republican == 0
		di exp(r(mean)) - 1
		
		su `y' if wave == 1 & republican == 1
		di exp(r(mean)) - 1
		su `y' if wave == 2 & republican == 1
		di exp(r(mean)) - 1
		
		if `j' == 1 local mytext1 `"3.75 1.25 "Democrats", col(black)"'
		if `j' != 1 local mytext1 " "

		if `j' == 1 local mytext2 `"3 1.25 "Republicans", col(black)"'
		if `j' != 1 local mytext2 " "

		if `j' == 1 local mytext3 `"4.5 1.75 "{&larr}Obama    ", col(black)"'
		if `j' == 1 local mytext4 `"4.35 1.82 "re-elected", col(black)"'
		if `j' != 1 local mytext3 " "
		if `j' != 1 local mytext4 " "

		if `j'  == 1 {
	
			#delimit;

			gr tw 
				(con `y' wave if republican == 0, col(black) lwid(thick))
				(con `y' wave if republican == 1, col(gray) lpat(solid) lwid(thick))
				,
					legend(off)
					nodraw
					xlab(1 "Before" 2 "After")
					ylab(
						1(1)5
 
						,
							angle(horiz)
					)	
					xtitle("")
					ytitle("")
					name(g`j', replace)
					plotregion(style(none))
					title(`mytitle')
					text(`mytext1')
					text(`mytext2')
					text(`mytext3')
					text(`mytext4')					
					xline(1.5, lpat(shortdash) lcol(gs12))
					
					;
					
			#delimit cr
		
		}
			
		if `j'  != 1 {
	
			#delimit;

			gr tw 
				(con `y' wave if republican == 0, col(black) lwid(thick))
				(con `y' wave if republican == 1, col(gray) lpat(solid) lwid(thick))
				,
					legend(off)
					nodraw
					xlab(1 "Before" 2 "After")
					ylab(
						
						`log15' "15"
						`log25' "25"
						`log50' "50"
						`log75' "75"
						`log100' "100"
						`log150' "150"
						,
							angle(horiz)
					)	
					xtitle("")
					ytitle("")
					name(g`j', replace)
					plotregion(style(none))
					title(`mytitle')
					text(`mytext1')
					text(`mytext2')
					text(`mytext3')
					xline(1.5, lpat(shortdash) lcol(gs12))
					;
					
			#delimit cr
		
		}
	
	restore

	local j = `j' + 1

}

gr combine g1 g2 g3, cols(3)  


local myfilename "figure3.eps"
gr export "`myfilename'", replace
shell epspdf "`myfilename'"
