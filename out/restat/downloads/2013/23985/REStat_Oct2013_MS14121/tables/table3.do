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
	

* Collapse to one obs per hotel
	
	local vlist roomprice revpar occrate totalrev nrooms age ///
		m_hcomp m_tour m_pop m_income ///
		h_resto h_outcafe h_ac h_fitness propofran h_hqdist density

		
	collapse (mean) `vlist' franchised, by(hotel_id)
	
	replace franchised = round(franchised)
	
	
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

	tab franchised
	
	foreach v of local vlist {
	
		local vlab : var lab `v'
		dis as txt %-30s "`vlab'" _c
		
		qui ttest `v', by(franchised)
		
		dis %15.2f r(mu_2) _c
		dis %15.2f r(mu_1) _c
		local star
		if inrange(r(p),.01,.1) local star *
		if inrange(r(p),.01,.05) local star **
		if inrange(r(p),0,.01) local star ***
		dis %15s "`star'"
		
		dis as txt %-30s " " _c
		
		local s = "(" + trim(string(r(sd_2),"%15.2f")) + ")"
		dis %15s "`s'" _c
		local s = "(" + trim(string(r(sd_1),"%15.2f")) + ")"
		dis %15s "`s'"
		
	}
