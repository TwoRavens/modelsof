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
	
	local vlist roomprice revpar occrate totalrev nrooms age m_hcomp ///
		m_tour m_pop m_income franchised h_resto ///
		h_outcafe h_ac h_fitness propofran h_hqdist density


	collapse (mean) `vlist', by(hotel_id)
	
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
	label var franchised	"Franchised"
	label var h_resto	"Restaurant on site"
	label var h_outcafe	"Outdoor café"
	label var h_ac		"Air conditioning"
	label var h_fitness	"Fitness facility"
	label var propofran	"Prop other hotels franchised"
	label var h_hqdist	"Distance from headquarters"
	label var density	"hotel density"


* Make a pretty table with the formatting as close as possible to what's published
	
	foreach v of local vlist {
		qui sum `v'
		foreach stat in mean sd min max {
			local s = string(r(`stat'),"%15.2fc")
			local val`stat' = subinstr("`s'",".00","",1)
		}
		local vlab : var lab `v'
		dis as txt %-30s "`vlab'" %15s "`valmean'" %15s "`valsd'"%15s "`valmin'"%15s "`valmax'"
	}
