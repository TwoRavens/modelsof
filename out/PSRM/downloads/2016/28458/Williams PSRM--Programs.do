***********************************************************
*** Do file to run the programs necessary for the replication file for "Opposition Parties and the Timing of Successful No-Confidence Motions", PSRM
***
*** Created: 12-21-14
***
***********************************************************

***********************************************************
*** Statistical backwards induction
***********************************************************
capture program drop sbi
program sbi, rclass
	capture drop pr_sbi

	logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode) iter(100)
	predict pr_sbi
	grab_a, n(2)

	foreach i of varlist surplus minority gparties ciep_perc ts_govt ts_challenge no_challenge annual_ch_rgdppc {
		gen z_`i' = (1 - pr_sbi) * `i'
	}

	foreach j of varlist annual_ch_rgdppc eff_par {
		gen y_`j' = pr_sbi * `j'
	}

	logit opp_conf_dummy z_surplus z_minority z_gparties z_ciep_perc z_ts_govt z_ts_challenge z_no_challenge z_annual_ch_rgdppc y_annual_ch_rgdppc y_eff_par, nocons iterate(100) robust cluster(ccode)
	mat B = e(b)

	drop pr_sbi z_* y_*
	ret scalar surplus = B[1,1]
	ret scalar minority = B[1,2]
	ret scalar gparties = B[1,3]
	ret scalar ciep_perc = B[1,4]
	ret scalar ts_govt = B[1,5]
	ret scalar ts_challenge = B[1,6]
	ret scalar no_challenge = B[1,7]
	ret scalar annual_ch_rgdppc_F = B[1,8]
	ret scalar annual_ch_rgdppc_P = B[1,9]
	ret scalar eff_par = B[1,10]
end

************************************************************************************
************************************************************************************
capture program drop sbi2
program sbi2, rclass
	logit opp_conf_dummy z_surplus z_minority z_gparties z_ciep_perc z_ciep_perc2 z_ts_govt z_ts_govt2 z_ts_challenge z_no_challenge z_annual_ch_rgdppc y_annual_ch_rgdppc y_eff_par, nocons iterate(50) robust cluster(ccode)
	mat B = e(b)

	ret scalar surplus = B[1,1]
	ret scalar minority = B[1,2]
	ret scalar gparties = B[1,3]
	ret scalar ciep_perc = B[1,4]
	ret scalar ciep_perc2 = B[1,5]
	ret scalar ts_govt = B[1,6]
	ret scalar ts_govt2 = B[1,7]
	ret scalar ts_challenge = B[1,8]
	ret scalar no_challenge = B[1,9]
	ret scalar annual_ch_rgdppc_F = B[1,10]
	ret scalar annual_ch_rgdppc_P = B[1,11]
	ret scalar eff_par = B[1,12]
end
************************************************************************************
************************************************************************************

************************************************************************************
************************************************************************************
capture program drop sbi3
program sbi3, rclass
	logit opp_conf_dummy z_surplus z_minority z_gparties z_ciep_perc z_ts_govt z_ts_challenge z_no_challenge z_annual_ch_rgdppc y_surplus y_minority y_gparties y_ciep_perc y_ts_govt y_annual_ch_rgdppc y_eff_par, nocons iterate(50) robust cluster(ccode)
	mat B = e(b)

	ret scalar surplus = B[1,1]
	ret scalar minority = B[1,2]
	ret scalar gparties = B[1,3]
	ret scalar ciep_perc = B[1,4]
	ret scalar ts_govt = B[1,5]
	ret scalar ts_challenge = B[1,6]
	ret scalar no_challenge = B[1,7]
	ret scalar annual_ch_rgdppc_F = B[1,8]
	ret scalar surplus_P = B[1,9]
	ret scalar minority_P = B[1,10]
	ret scalar gparties_P = B[1,11]
	ret scalar ciep_perc_P = B[1,12]
	ret scalar ts_govt_P = B[1,13]
	ret scalar annual_ch_rgdppc_P = B[1,14]
	ret scalar eff_par = B[1,15]
end
************************************************************************************
************************************************************************************

************************************************************************************
************************************************************************************
capture program drop grab_a
program define grab_a
	syntax, n(real)
	mat b = e(b)
	mat vcov = e(V)
	preserve
		svmat b, names(eqcol)
		outsheet no_conf_dummy* in 1 using "a_beta`n'.txt", replace nolabel
	restore
	preserve
		local names: colnames vcov
		forvalues i = 1(1)`e(rank)' {
			local value_`i' = vcov[`i',`i']
			gen var_`i' = sqrt(`value_`i'') in 1
		}
		keep in 1
		mkmat var_1 - var_`e(rank)', matrix(se)
		matrix colnames se = `names'
		svmat se, names(eqcol)
		outsheet no_conf_dummy* in 1 using "a_se`n'.txt", replace nolabel
	restore
end

