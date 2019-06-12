
*******************************************************

*Reproducing Results - All regressions okay

use Sautmann-BiasedBeliefs-Data.dta, clear
xtset ID
gen p1=1    
replace p1=0 if (period>10 & period<19) | period>27

gen troc = treat*oc
gen wgapoc=wgap*oc
gen wgaptr=wgap*treat
gen wgaptroc=wgap*troc
gen sucprob_a2=sucprob_a-0.3*investment 
gen wexp2=3*(wageb + sucprob_a2*wgap)  
replace wexp2=wexp if reject==1
gen wexpoc=wexp2*oc
gen wexptr=wexp2*treat 
gen wexptroc=wexp2*troc

gen dum23=0
replace dum23=1 if wgap>=23
gen dumneg=0
replace dumneg=1 if wgap<0
gen dumPC=0
replace dumPC=1 if wexp2>=100

bysort ID: egen profitend=max(totalprofit) if role==1 
bysort grtr: egen pcpe=pctile(profitend),p(90)  


*Table 5 - All okay
foreach X in "" "0" {
	xtreg prexp trocp`X' treatp`X' oc`X', re cluster(session) 
	}

foreach X in poexp poexp_a {
	xtreg `X' troca treata oc, re cluster(session)
	}

*Table 6 - All okay
foreach X in "" "0" {
	xtreg prexp trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
	}

foreach X in poexp poexp_a {
	xtreg `X' troca treata oc if p1 == 1, re cluster(session)
	testparm troca treata
	}

*Table 7 - All okay
foreach Y in wexp wgap {
	foreach X in "" "0" {
		xtreg `Y' trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
		}
	}

xtreg investment troca0 treata0 oc if p1==1, re cluster(session)
xtreg reject troca treata oc if p1==1, re cluster(session)

*Table B4 - All okay
foreach X in "" "dumneg" {
	xtprobit investment wgaptr wgaptroc treat troc wgap wgapoc dum23 oc `X' if reject==0 & role==2 , re
	}

foreach X in "" "dumneg" {
	xtprobit reject wgaptr wgaptroc treat troc wexptr wexptroc wgap wgapoc oc wexp2 wexpoc dumPC `X' if role==2, re
	}


*Table B5 - All okay
foreach Y in wexp wgap {
	foreach X in "" "0" {
		xtreg `Y' trocp`X' treatp`X' oc`X', re cluster(session) 
		}
	}

xtreg investment troca0 treata0 oc, re cluster(session)
xtreg reject troca treata oc, re cluster(session)

rename N Treat

save DatS, replace



