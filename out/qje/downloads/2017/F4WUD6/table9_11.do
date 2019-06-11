clear
set more off

cap program drop regs_geo
program regs_geo
	args outcome add
		
	regress `outcome' treat lat lon seg2 if (abs(dbnd)<=25) [aw=oweight], robust cluster(villageid)	
	summ `outcome' if e(sample)==1
	local mean : display %4.2f `r(mean)'
	outreg, varlabel nocons `add' se bdec(3) nostars summstat(N) summtitles("Obs") keep(treat) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend	
end

cap program drop regs_discon
program regs_discon
	args outcome add
	
	regress `outcome' treat lat lon elev slope seg2 if (abs(dbnd)<=25) [aw=oweight], robust cluster(villageid)	
	summ `outcome' if e(sample)==1
	local mean : display %4.2f `r(mean)'
	outreg, varlabel nocons `add' se bdec(3) nostars summstat(N) summtitles("Obs") keep(treat) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend	
end


cap program drop regs_paas
program regs_paas
	args outcome add

	regress `outcome' treat elev slope if abs(dbnd)<=100 [aw=n_`outcome'], robust cluster(villageid)	
	summ `outcome'  [aw=n_`outcome'] if e(sample)==1
	local mean : display %4.2f `r(mean)'
	outreg, varlabel nocons `add' se bdec(3) nostars summstat(N) summtitles("Obs") keep(treat) addrows(Clusters, `e(N_clust)' \ Mean, `mean') nolegend
end

cap program drop regs_vndba
program regs_vndba
	**data prep
	use marines_hamlet, clear
	keep usid 
	count
	
	*create a 1964-65 panel
	foreach Y in 1964 1965 {
		g v`Y'=1
	}
	
	reshape long v, i(usid) j(yr)
	drop v
	
	forvalues Y=1/12 {
		g v`Y'=1
	}
	
	reshape long v, i(usid yr) j(mth)
	drop v
	
	g date=ym(yr, mth)
	format date %tm
	
	merge 1:n usid date using vndba_all_2k
	/*_merge==1 - no vndba incident within 2 km in that year x month
	_merge==2 - hamlets that are not near the threshold at all*/
	drop if _merge==2
	drop _merge
	
	recode en_init (.=0)
	
	label var en_init "dummy for enemy initiated attack"
	
	keep if date<ym(1965, 5)
	
	*aggregate to the hamlet x quarter level
	collapse (mean) en_init, by( usid)
	rename en_init en_init_vndba
	merge 1:1 usid using marines_hamlet
	drop _merge
	
	regs_discon en_init_vndba replace
end

******************
*****Paper
******************

*********Run data prep files

do marines_hamlet 25

**********Make table 9
****Paper
quietly regs_vndba

use  marines_hamlet, clear
quietly regs_geo urban merge
quietly regs_geo elev merge
quietly regs_geo slope merge

quietly regs_discon factory merge
quietly regs_discon market merge
quietly regs_discon milpost merge
quietly regs_discon telegraph merge
quietly regs_discon traintram merge
quietly regs_discon all_roads merge
quietly regs_discon colonial_roads merge

outreg using table8, replay replace tex ctitles("", "Dependent variable is:" \ "", "VC", "", "", "", "", "", "Military", "", "Tram or", "Total", "Colonial" \"", "Attack", "Urban", "Elev.", "Slope", "Factory", "Market", "Post", "Telegraph", "Train", "Road (Km)", "" \ "",  "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)", "(10)", "(11)") multicol(1, 2, 11; 3, 11, 2) hlines(11001{0}1) plain fragment nocenter

*******Table 10: Public Goods, Security
*public goods /*includes village level outcomes*/


***Paper
use marines_hamlet, clear
quietly regs_discon educ_p1 replace
quietly regs_discon health_p1 merge

*Security
quietly regs_discon sec_p1 merge
quietly regs_discon en_pres merge
quietly regs_discon all_atk merge

**participation in VC infrastructure
quietly regs_discon vc_infr merge

**Sitra
quietly regs_discon en_init_sitra merge
quietly replace fr_d=fr_d+fw_d
quietly regs_discon fr_d merge
quietly regs_discon en_d merge

*Other LCAs
quietly regs_discon admin_p1 merge
quietly regs_discon soccap_p1 merge
quietly regs_discon econ_p1 merge

outreg using table9, replay replace tex ctitles("", "Dependent variable is:" \ "","Educ", "Health", "Secur", "Armed", "VC", "Active", "VC", "Friendly", "VC", "Admin", "Civic Soc", "Econ" \ "", "Posterior", "", "", "VC",  "Init",  "VC", "Attacks", "Troop", "", "Posterior", "", ""  \ "", "Probability", "", "", "Present",  "Attack", "Infr.", "Troops", "Deaths", "", "Probability", "", "" \ "",  "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)", "(10)", "(11)", "(12)") hlines(110001{0}1) plain fragment nocenter multicol(1, 2, 11; 3, 2, 3; 4, 2, 3; 3, 11, 3; 4, 11, 3; 3, 9, 2; 4, 9, 2)

*****PAAS

*Paper
use marines_paas, clear

quietly regs_paas likesamer replace
foreach V in hatesamer vnamhost_vlow vnamer_harm amepres {
	quietly regs_paas `V' merge
}

*Attitudes towards SVN
quietly regs_paas vconf merge
foreach V in arvn pf rf npvc npord lofsuc {
	quietly regs_paas `V' merge
}

outreg using table10, replay replace tex ctitles("", "Dependent variable is:"  \"","Respondent", "", "No", "America", "", "Fully", "", "", "", "Police", "", "Local" \ "", "Likes", "Hates", "Hostility", "Promotes", "Presence", "Conf", "ARVN", "PF", "RF", "Effective", "" , "Officials" \ "", "Americans", "", "Am.", "Harmony", "Beneficial", "in GVN", "Effective", "", "", "VC", "Order" , "Effective" \ "",  "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)", "(10)", "(11)", "(12)") multicol(1, 2, 12; 2, 2, 2; 2, 5, 2; 2, 11, 2; 3, 11, 2; 4, 2, 2; 4, 8, 3) hlines(110001{0}1) plain fragment nocenter


