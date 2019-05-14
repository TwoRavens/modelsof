*** Note: this figure approximates the one in the paper, 
*** which was created using the QGIS software program

set more off

use dataset_dataverse_with_leip, clear

replace z = 2 if z == 0 & mi(x)
replace z = 3 if z == 1 & mi(x)

drop if (mi(statea) | statea=="HI" | statea=="AK") & !mi(z)

collapse z, by(_id)

#delimit;

spmap 
	z 
		using "dataset_coords"
		,
			id(_id)
			fcolor(gs13 gray gs13 gray)
			clmethod(unique)
			ndfcolor(white) 
			osize(thick thick vthin vthin)
			legend(
				order(
					3 "Expanded Medicaid"
					2 "Did not"
				)
				size(vlarge)
			)
			;

#delimit cr

//gr export "figure1.eps", replace
//shell epspdf "figure1.eps"
