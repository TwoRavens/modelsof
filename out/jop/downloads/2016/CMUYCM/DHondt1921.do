use dta\Storting1921, clear

** THIS FILE IS BUILDING ON "MANDATFORDELNINGOLIKAMETODERMEDFELCHECK.DO" FROM 'POWER OF PARTIES'

gen antalmandat= rep

foreach parti in DNA NSA RF V SP H_FV OTH {
gen r`parti'=votes`parti'
*gen r`parti'=votes`parti'*antalmandat  /* DETTE SKULLE GI LISTESTEMMER, MEN ER IKKE 100% MATCH, ANTAGELIG PGA FORKASTEDE STEMMER? */
}

foreach sam in dh msl{
	foreach parti in DNA NSA RF V SP H_FV OTH {
		gen `sam'm`parti ' =0
	}
}

gen rm =0

******dhondt*************
while rm<9 {

foreach parti in DNA NSA RF V SP H_FV OTH {
gen j`parti '= r`parti'/(2+2*dhm`parti')
}
egen tm =rowtotal(dhmDNA -dhmOTH)
egen max = rowmax(jDNA-jOTH)
foreach parti in DNA NSA RF V SP H_FV OTH {
replace dhm`parti'= dhm`parti' +1 if j`parti '==max & tm<antalmandat & r`parti'!=.
}
drop jDNA-max tm
replace rm=rm+1
}

******Modified Saint Lague*************
replace rm=0
while rm<9{

foreach parti in DNA NSA RF V SP H_FV OTH {
gen p`parti'=mslm`parti'>=1 & mslm`parti'!=.
}
foreach parti in DNA NSA RF V SP H_FV OTH {
gen j`parti'= (1-p`parti')*r`parti'/1.4 + p`parti'* r`parti'/(1+2*mslm`parti')
}
egen tm =rowtotal(mslmDNA -mslmOTH)
egen max = rowmax(jDNA-jOTH)
foreach parti in DNA NSA RF V SP H_FV OTH {
replace mslm`parti'= mslm`parti' +1 if j`parti'==max & tm<antalmandat & r`parti'!=.
}
drop pDNA-max tm
replace rm=rm+1
}
replace rm=0

*********************************
***************************************************************************
*******************************************************************************

/* VOTES IF GOT PARTY GOT SEAT */

foreach sam in dh msl {
		foreach parti in DNA NSA RF V SP H_FV OTH {
		gen `sam'rm`parti'=r`parti' if `sam'm`parti'>0
	}
}

egen dhtm =rowtotal(dhmDNA -dhmOTH )      /* number of reps with dh */
egen msltm =rowtotal(mslmDNA -mslmOTH )  /* number of reps with msl */
egen tr =rowtotal(rDNA -rOTH )    /* this is approvedvotes */

/* SUM OF VOTES FOR PARTIES THAT GOT SEAT */

foreach sam in dh msl {
	egen `sam'trm =rowtotal(`sam'rmDNA -`sam'rmOTH)
}

/* VOTESHARE */
foreach parti in DNA NSA RF V SP H_FV OTH {
gen pr`parti'=r`parti'/tr
}

/* SEATSHARE */
foreach sam in dh msl {
	foreach parti in DNA NSA RF V SP H_FV OTH {
	gen `sam'pm`parti'=`sam'm`parti'/`sam'tm
	}
}

*********** DO I NEED THIS ONE ???
*foreach sam in dh msl{
*	foreach parti in DNA NSA RF V SP H_FV OTH {
*	gen `sam'prm`parti'=r`parti'/`sam'trm
*	}
*}

**********Number of parties with seats********

gen P=0
foreach parti in DNA NSA RF V SP H_FV OTH {
replace P= P+1 if dhm`parti'>0
}

**********average deviation from the threshold where a party is guaranteed a seat

*gen dev=  (P-2) / (2* ( antalmandat+1) ) 

**********indices - i think only for idea of doing fuzzy rdd *************

*foreach parti in DNA NSA RF V SP H_FV OTH {
*gen forcing`parti'= LVoteShare`parti'* ( antalmandat+1)* (1+dev)
*}

************dh loopen delar ut fel antal mandat*******************
gen av_totseats_dh= antalmandat!=dhtm

************msl loopen delar ut fel antal mandat*******************
gen av_totseats_msl= antalmandat!=msltm

keep pr* mslm* dhm* dhpm* mslpm* votesh* valgkrets year antalmandat

save dta\DHondt1921BeforeReshape, replace


*reshape long pr mslm dhm dhpm mslpm, j(parti) i(year valgkrets) string


/**************************************Main Program************************************************/

run do\Distance  /* PROGRAM FILES FOR COMPUTING DISTANCE TO THRESHOLD */

drop *msl*

*calmindiff_msl "DNA NSA RF V SP H_FV OTH" "DNA NSA RF V SP H_FV OTH"
*drop start-stop
calmindiff_dh "DNA NSA RF V SP H_FV OTH" "DNA NSA RF V SP H_FV OTH"
*drop start-stop

foreach parti in DNA NSA RF V SP H_FV OTH {
replace mindiff`parti'n=. if  mindiff`parti'n <0
replace mindiff`parti'n=. if  mindiff`parti'n <0
}

*dum_mindiffpartycalvs "DNA NSA RF V SP H_FV OTH" "10 5 1 05 025 01"

*dum_diffpartyclosevs "DNA NSA RF V SP H_FV OTH"  "10 5 1 05 025 01"

keep valgkrets pr* dhm* mindiff*p mindiff*n year antalmandat mindiff*p1 mindiff*n1

foreach party in DNA NSA RF V SP H_FV OTH {
	foreach rank in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
	gen margin`party'`rank'=.
	}
}

** mindiff*p gives the distance to winning a seat, so these guys are to the left of the treshold

foreach party in DNA NSA RF V SP H_FV OTH {
	foreach rank in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
	replace margin`party'`rank'=-mindiff`party'p if dhm`party'==`rank'-1
	}
}

** mindiff*n gives the distance to losing the seat,, so these guys are to the right of the threshold

foreach party in DNA NSA RF V SP H_FV OTH {
	foreach rank in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
	replace margin`party'`rank'=mindiff`party'n if dhm`party'==`rank'
	}
}


** candidate winning seat?
foreach party in DNA NSA RF V SP H_FV OTH {
	foreach rank in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
	gen seat`party'`rank'=0
	replace seat`party'`rank'=1 if dhm`party'>=`rank' 
	}
}

rename valgkrets districtid

save dta\DHondt1921_wide, replace

keep districtid seat* margin*

reshape long seatDNA seatNSA seatRF seatV seatSP seatH_FV seatOTH marginDNA marginNSA marginRF marginV marginSP marginH_FV marginOTH , i(districtid)
rename _j rank
reshape long seat margin, i(districtid rank) string
rename _j party

sort districtid party rank

save dta\DHondt1921, replace
