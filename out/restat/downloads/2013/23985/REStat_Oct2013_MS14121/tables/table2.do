/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/


	version 12

	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name
	local sig {bind:{hi:[RP : `dofile'.do]}}		// a signature in notes
	
	
* Start from the data combo

	project, uses("`pdir'/data_combo.dta")
	use "`pdir'/data_combo.dta"


* Brand groups

	gen brandgroup = 1 if inlist(brand_id,5,6)
	replace brandgroup = 2 if brand_id == 4
	replace brandgroup = 3 if brand_id == 3
	replace brandgroup = 4 if brand_id == 1
	replace brandgroup = 5 if brand_id == 2


* Collapse to one obs per hotel
	
	local vlist franchised roomprice revpar occrate totalrev nrooms ///
		age m_hcomp m_tour m_pop m_income ///
		h_resto h_outcafe h_ac h_fitness propofran h_hqdist density

		
	collapse (mean) `vlist', by(hotel_id brandgroup)
	
	
* Adjust variable labels

	label var roomprice	"Price (room rate)"
	label var revpar	"RevPar"
	label var occrate	"Occupancy rate (%)"
	label var totalrev	"Revenues/month (000s)"
	label var nrooms	"Number of rooms"
	label var age		"Hotel age"
	label var m_hcomp	"Other hotels in market"
	label var m_tour	"Tourism intensity"
	label var m_pop		"Population"
	label var m_income	"Income"
	label var franchised	"% franchised"
	label var h_resto	"Restaurant on site"
	label var h_outcafe	"Outdoor café"
	label var h_ac		"Air conditioning"
	label var h_fitness	"Fitness facility"
	label var propofran	"Prop other hotels franchised"
	label var h_hqdist	"Distance from headquarters"
	label var density	"hotel density"
	

* Make a pretty table with the formatting as close as possible to what's published

	bysort brandgroup: gen hotelN = _N
	replace franchised = franchised * 100
	label var hotelN "Number of hotels"
	
	local vlist hotelN `vlist'

	foreach v of local vlist {
	
		local vlab : var lab `v'
		dis as txt %-30s "`vlab'" _c
		
		forvalues i = 1/5 {
			sum `v' if brandgroup == `i', meanonly
			dis %15.2f r(mean) _c
		}
		dis
		
		if "`v'" != "hotelN" {
			dis as txt %-30s " " _c
			forvalues i = 1/5 {
				qui sum `v' if brandgroup == `i'
				local s = "(" + trim(string(r(sd),"%15.2f")) + ")"
				dis %15s "`s'" _c
			}
			dis
		}
	}
