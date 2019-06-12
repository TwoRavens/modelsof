use "Data_programs/Data/MFQ_Ind.dta", clear


* Figure 7

preserve
keep if isocode_curr=="USA"

collapse s_mfq_disgusting corigin_kinship_score (count) no=s_mfq_disgusting, by(isocode_past)
keep if no>=20

tw (scatter s_mfq_disgusting corigin_kinship_score,mlabel(isocode)) (lfit s_mfq_disgusting corigin_kinship_score, title("Kinship tightness and moral relevance of disgust") xtitle("Kinship tightness") xscale(range(0 1.02)) ytitle("Moral relevance of disgust") ylabel(-.4 0 .4 .8) yline(.8,lstyle(grid)) legend(off) note("") graphregion(fcolor(white) lcolor(white)))
graph export Source_files/Figs/Disgust_kinship.pdf, replace
restore


