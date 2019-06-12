/*-------------------------------------------------------HC_rev_dfig_hospptcdist.do
Creating plots of percent price-to-charge contracts at each hospital

Stuart Craig
Last updated	20180816
*/


	timestamp, output

	foreach proc of global proclist {
		if "`proc'"=="kmri" continue
		use ${ddHC}/HC_cdata_`proc'_i.dta, clear
		keep if ep_adm_y==2011&adj_price<.
		keep prov_e_npi ep_adm_y
		bys prov_e_npi ep_adm_y: keep if _n==1
		tempfile hs
		save `hs'

		use ${ddHC}/HC_cdata_`proc'_h.dta, clear
		keep if ep_adm_y==2011
		merge 1:1 prov_e_npi ep_adm_y using `hs', keep(3) nogen

		egen order1 = group(ptc_norest prov_e_npi)
		gen order2 = order/_N
		qui replace ptc_norest = 0.005 if ptc_norest==0 

		tw bar ptc_norest order2, barwidth(.001) ///
			xtitle("Hospitals") ///
			ytitle("Fraction of Admissions Paid as Share of Charges") ///
			ylab(0(.2)1, format("%2.1f")) /*xlab(0(.2)1, format("%2.1f")) */ ///
			xlab(,nolab)

		graph export HC_rev_dfig_hospptcdist_`proc'.png, replace

	}

exit
