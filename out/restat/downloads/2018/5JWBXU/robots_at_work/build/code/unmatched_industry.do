* diagnose observations that are unmatched - to do with industry

	gen unmatched_industry = "na" if _merge==3

	replace unmatched_industry = "too disaggregated in EUKLEMS data" if  	///
		code_euklems=="A" | code_euklems=="1" | code_euklems=="2"| ///
		code_euklems=="B"| code_euklems=="10t12"|code_euklems=="10"| code_euklems=="11"| code_euklems=="12"| code_euklems=="13t14"| ///
		code_euklems=="13"| code_euklems=="14"| code_euklems=="15"| code_euklems=="16"| ( code_euklems=="17t18" & country!="china" ) | code_euklems=="17"| ///
		code_euklems=="18"| ( code_euklems=="19" & country!="china" ) | code_euklems=="21"| code_euklems=="22"| code_euklems=="221"| code_euklems=="22x"| ///
		code_euklems=="23"|  code_euklems=="24"| code_euklems=="25"| ///
		code_euklems=="244"| code_euklems=="24x"| code_euklems=="27"| code_euklems=="28"| code_euklems=="30"| code_euklems=="31t32"| ///
		code_euklems=="31"| code_euklems=="313"| code_euklems=="31x"| code_euklems=="32"| code_euklems=="321"| code_euklems=="322"| ///
		code_euklems=="323"| code_euklems=="33"| code_euklems=="331t3"| code_euklems=="334t5"| code_euklems=="34"|code_euklems=="40"| ///
		code_euklems=="40x"| code_euklems=="402"| code_euklems=="41"

	replace unmatched_industry = "too aggregated in EUKLEMS data" if  	///		
		code_euklems=="TOT" | code_euklems=="D" | code_euklems=="TT" |		///
		code_euklems=="G" | code_euklems=="I" | code_euklems=="K" | code_euklems=="JtK" | code_euklems=="LtQ" | ///
		code_euklems=="Q" | code_euklems=="P" 
	
	replace unmatched_industry = "industry not covered in EUKLEMS data" if 	///
		code_robots=="91" | code_robots=="99"
	
	replace unmatched_industry = "industry not covered in World Robotics data" if 	///
		code_euklems=="29" | code_euklems=="50" | code_euklems=="51" | code_euklems=="52" |	///
		code_euklems=="60t63" | code_euklems=="64" | code_euklems=="70" | code_euklems=="71t74" | ///
		code_euklems=="H" | code_euklems=="J" | code_euklems=="L" | code_euklems=="N" | code_euklems=="O"
