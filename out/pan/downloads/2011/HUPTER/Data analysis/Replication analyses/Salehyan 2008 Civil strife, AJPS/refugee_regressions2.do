
*********************************************
********** Directed dyad analysis ***********
*********************************************

*generate interaction terms.
gen mccapshare = capshare-.5
gen capref1 = mccapshare*logref1
gen capref2 = mccapshare*logref2

* Run probits with pcyears variables

local vars "uppcivcon "

foreach v in `vars' {

capture drop civwar1
capture drop civwar2

gen civwar1=`v'1
gen civwar2=`v'2

probit mzinit_lead logref1 logref2 civwar1 civwar2 dem1 dem2 demdem trans1 trans2 transtrans contig colcont capshare s_wt_glo depend1 depend2 igos lpcyrs* if year >=1955, cluster(dyad)

*include interactions
probit mzinit_lead logref1 logref2 capref1 capref2 civwar1 civwar2 dem1 dem2 demdem trans1 trans2 transtrans contig colcont capshare s_wt_glo depend1 depend2 igos lpcyrs* if year >=1955, cluster(dyad)



}

local vars "uppcivcon "

foreach v in `vars' {

capture drop civwar1
capture drop civwar2

gen civwar1=`v'1
gen civwar2=`v'2

*flow model.  Refugee flow rather than stock.
probit mzinit_lead logflow1 logflow2 civwar1 civwar2 dem1 dem2 demdem trans1 trans2 transtrans contig colcont capshare s_wt_glo depend1 depend2 igos lpcyrs* if year >=1955, cluster(dyad)

}
