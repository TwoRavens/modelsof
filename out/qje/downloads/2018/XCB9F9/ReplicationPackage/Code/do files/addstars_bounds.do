if `pvalue_RI_`yvarname'_`j'_1' < 0.01 {
	file write output_file "\$^{***}\$ "
} 
else if `pvalue_RI_`yvarname'_`j'_1' < 0.05 {
	file write output_file "\$^{**}\$ "	
}
else if `pvalue_RI_`yvarname'_`j'_1' < 0.10 {
	file write output_file "\$^{*}\$ "
}
