file write output_file " & {\scriptsize [" %`of1'.`of2'f (`coeff_`yvarname'_`j'_`b1'') 

if `pvalue_RI_`yvarname'_`j'_`b1'' < 0.01 {
	file write output_file "\$^{***}\$"
} 
else if `pvalue_RI_`yvarname'_`j'_`b1'' < 0.05 {
	file write output_file "\$^{**}\$"	
}
else if `pvalue_RI_`yvarname'_`j'_`b1'' < 0.10 {
	file write output_file "\$^{*}\$"
}

file write output_file "," %`of1'.`of2'f (`coeff_`yvarname'_`j'_`b2'') 

if `pvalue_RI_`yvarname'_`j'_`b2'' < 0.01 {
	file write output_file "\$^{***}\$"
} 
else if `pvalue_RI_`yvarname'_`j'_`b2'' < 0.05 {
	file write output_file "\$^{**}\$"	
}
else if `pvalue_RI_`yvarname'_`j'_`b2'' < 0.10 {
	file write output_file "\$^{*}\$"
}

file write output_file "] } "
