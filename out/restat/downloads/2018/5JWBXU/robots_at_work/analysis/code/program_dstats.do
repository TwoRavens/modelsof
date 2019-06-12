** robots: dstats in levels and changes
** inputs are lists of variables and labels, and the variable of aggregation

	cap program drop dstats
	program define dstats
	syntax namelist, elements_lev(string) elements_ch(string) aggregvar(name) wt(string) outfile(string) [ Nochanges ]
	
		preserve 
	
	* define lists of variables
		if "`nochanges'"=="" { 
		
			local varlist_lev ""
			local varlist_ch ""
		
			tokenize `namelist'
			local i = 1
			while "``i''"!="" {
				local varlist_lev "`varlist_lev' ``i''0"
				local varlist_ch "`varlist_ch' ch_``i''"
				
				local ++i
			}
		}
		if "`nochanges'"=="nochanges" {
			
			local varlist "`namelist'"
		}
		
		
	* short names
		do shortname `aggregvar' LaTeX 
		
	* esttab options
		local tabopt "noobs nonum booktabs replace fragment"
	
	* calculating and tabulating summary statistics
		gen mean = "Mean"
		
		eststo clear
		
		if "`nochanges'"=="" {
			foreach item in lev ch {
				
				estpost tabstat `varlist_`item'' [ w=`wt' ], by(`aggregvar'_name) notot
				esttab using "$outpath\dstats_`outfile'_`item'.tex", cells("`elements_`item''") `tabopt'
				
				estpost tabstat `varlist_`item'' [ w=`wt' ], by(mean) notot
				esttab using "$outpath\dstats_`outfile'_`item'_mean.tex", cells("`elements_`item''") `tabopt'
			}
		}
		if "`nochanges'"=="nochanges" {
							
			estpost tabstat `varlist' [ w=`wt' ], by(`aggregvar'_name) notot
			esttab using "$outpath\dstats_`outfile'.tex", cells("`elements_lev'") `tabopt'
				
			estpost tabstat `varlist' [ w=`wt' ], by(mean) notot
			esttab using "$outpath\dstats_`outfile'_mean.tex", cells("`elements_lev'") `tabopt'
		}
	end
