//Replication data for Democracy, Transparency, and Secrecy in Crisis
//Sam Bell & Carla Martinez Machain
// September 18, 2017



use "DataFPABellMartinezMachain.dta", clear

	//Table 1
	eststo clear
	
	la var private "Private Mobilization"
	la var spii "Retrospective Oversight"
	la var foi "Freedom of Information Index"
	la var lop "Legislative Oversight Index"
	la var cl "Civil Liberties Index"
	la var polity21 "Polity 2 Score, State A"
	la var contigdummy "Contiguous Dyad"
	la var alliance "Alliance"
	la var powerratio "Power Ratio"



	eststo: probit private spii , cluster (ccode1)
	
	eststo: probit private spii polity21 contigdummy alliance powerratio, cluster (ccode1)
	
	eststo: probit private foi lop cl, cluster(ccode1)
	
	eststo: probit private foi lop cl polity21 contigdummy alliance powerratio, cluster(ccode1)

	
	#delimit;
	esttab _all using Table1.rtf, se starlevels(* .10 ** .05 *** .01) label scalars(N pr2) nodepvars
	title("Table 1: Probit Models: Retroactive Oversight in Democracies and Private Mobilization, 1970-1994")  replace;

//Figure 1	
	
probit private spii polity21 contigdummy alliance powerratio, cluster (ccode1)
margins, at ((means) _all spii=(0(.1).75) contigdummy==1)  
marginsplot, recast (line) recastci(rarea)

	//point predictions (referenced in text)
	margins, at ((means) _all spii=.11 contigdummy==1)
	margins, at ((means) _all spii=.55 contigdummy==1)

//Figure 2

probit private foi lop cl polity21 contigdummy alliance powerratio, cluster(ccode1)
margins, at ((means) _all lop=(0(.1).6) contigdummy==1)  
marginsplot, recast (line) recastci(rarea)

	//point predictions (referenced in text)
	margins, at ((means) _all lop=.08 contigdummy==1)
	margins, at ((means) _all lop=.48 contigdummy==1)

//Other tests referenced (as robustness checks) in text

	//standard errors clustered on dyad (referenced in footnote 10)

gen dyad=(ccode1*1000)+ccode2

eststo: probit private spii , cluster (dyad)
	
eststo: probit private spii polity21 contigdummy alliance powerratio, cluster (dyad)
	
eststo: probit private foi lop cl, cluster(dyad)
	
eststo: probit private foi lop cl polity21 contigdummy alliance powerratio, cluster(dyad)

	