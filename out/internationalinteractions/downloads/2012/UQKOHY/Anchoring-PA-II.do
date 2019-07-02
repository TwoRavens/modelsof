***Replication do-file for "Anchoring the Peace: Civil Society Actors in Peace Accords and Durable Peace" by Desir�e Nilsson

*stset with signatory peace*
stset end_of_segment, origin(time first_year_of_peace) enter(time start_of_segment) failure(endsig2event==1) exit(time .) id(unique_id)

**correlate, summarize*
corr civ nowpcon degreepact duration intensity incompatibility Demo polinclu physint empinx fh_pr fh_cl
su civ nowpcon degreepact duration intensity incompatibility Demo polinclu physint empinx fh_pr fh_cl


*alternatives*
stcox polinclu nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog
stcox civorpol nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog 
stcox civ nondemciv nowpcon degreepact duration intensity incompatibility nondemocracy, cluster(id) robust nolog

*main models-trimmed-signatories*
stcox civ degreepact intensity, cluster(id) robust nolog
stcox civandpol degreepact intensity, cluster(id) robust nolog 
stcox civ demociv degreepact intensity incompatibility Demo, cluster(id) robust nolog

*main models-trimmed-signatories & non-signatories*
stcox civ nowpcon degreepact intensity, cluster(id) robust nolog 
stcox civandpol nowpcon degreepact intensity, cluster(id) robust nolog
stcox civ demociv nowpcon degreepact intensity Demo, cluster(id) robust nolog

*weibull*
streg civ nowpcon degreepact duration intensity incompatibility Demo, cluster(id) dist(weibull) robust nolog 

**CLUSTER ON COUNTRY**
stcox civ nowpcon degreepact duration intensity incompatibility Demo, cluster(country) robust nolog 

***Main models with TSMOcounts by pop-logged**
stcox civ nowpcon degreepact duration intensity incompatibility Demo TSMOpoplog, cluster(id) robust nolog 
stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo TSMOpoplog, cluster(id) robust nolog

**ALT.SPEC-CIRI**
stcox civ nowpcon degreepact duration intensity incompatibility Demo physint empinx, cluster(id) robust nolog 
stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo physint empinx, cluster(id) robust nolog

stcox civ nowpcon degreepact duration intensity incompatibility fh_pr fh_cl, cluster(id) robust nolog 


stcox civ inclusive nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog 
stcox civ inclusive demociv nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog

*polity-lagged*
stcox civ nowpcon degreepact duration intensity incompatibility politylag, cluster(id) robust nolog 

stcox civ nowpcon degreepact duration intensity incompatibility politylag politylagsquared, cluster(id) robust nolog 

*loggdp-lagged*
stcox civ nowpcon degreepact duration intensity incompatibility Demo loggdp, cluster(id) robust nolog 
stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo loggdp, cluster(id) robust nolog

stcox civandpol nowpcon degreepact duration incompatibility Demo if intensity==1, cluster(id) robust nolog 

stcox civ demociv nowpcon degreepact duration incompatibility Demo if intensity==1, cluster(id) robust nolog

***PROP TEST***

capture drop sch* sca*

capture drop sch* sca*
stphtest, detail

capture drop sch* sca*


capture drop sch* sca*

capture drop sch* sca*

capture drop sch* sca*


stcox civ nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog 

stcox civandpol nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog 

stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog
outreg2 using civsoc1, eform coefastr se dec(3) append

*appendix*
stcox nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog 
outreg2 using civsocappend, eform coefastr se dec(3) replace 

stcox civ nowpcon degreepact duration intensity incompatibility Demo anypk, cluster(id) robust nolog 
outreg2 using civsocappend, eform coefastr se dec(3) append 

stcox civandpol nowpcon degreepact duration intensity incompatibility Demo anypk, cluster(id) robust nolog 
outreg2 using civsocappend, eform coefastr se dec(3) append 

stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo anypk, cluster(id) robust nolog
outreg2 using civsocappend, eform coefastr se dec(3) append 

*civil society*
stcox civ nowpcon degreepact duration intensity incompatibility Demo physint empinx, cluster(id) robust nolog 
outreg2 using civsocappend1, eform coefastr se dec(3) replace 

stcox civandpol nowpcon degreepact duration intensity incompatibility Demo physint empinx, cluster(id) robust nolog 
outreg2 using civsocappend1, eform coefastr se dec(3) append 

stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo physint empinx, cluster(id) robust nolog
outreg2 using civsocappend1, eform coefastr se dec(3) append 

stcox civ nowpcon degreepact duration intensity incompatibility Demo TSMOpoplog, cluster(id) robust nolog 

stcox civandpol nowpcon degreepact duration intensity incompatibility Demo TSMOpoplog, cluster(id) robust nolog 
outreg2 using civsocappend2, eform coefastr se dec(3) append 

stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo TSMOpoplog, cluster(id) robust nolog
outreg2 using civsocappend2, eform coefastr se dec(3) append 



stcox civ nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog 

stcox civandpol nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog 

stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog
outreg2 using civsoc1, eform coefastr se dec(3) append

*online appendix, Table C*
stcox nowpcon degreepact duration intensity incompatibility Demo, cluster(id) robust nolog 
outreg2 using civsocappend, eform coefastr se dec(3) append 

stcox civ nowpcon degreepact duration intensity incompatibility Demo anypk, cluster(id) robust nolog 
outreg2 using civsocappend, eform coefastr se dec(3) append 

stcox civandpol nowpcon degreepact duration intensity incompatibility Demo anypk, cluster(id) robust nolog 
outreg2 using civsocappend, eform coefastr se dec(3) append 

stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo anypk, cluster(id) robust nolog
outreg2 using civsocappend, eform coefastr se dec(3) append 

*online appendix, Table A-B*
stcox civ nowpcon degreepact duration intensity incompatibility Demo physint empinx, cluster(id) robust nolog 
outreg2 using civsocappend1, eform coefastr se dec(3) append 

stcox civandpol nowpcon degreepact duration intensity incompatibility Demo physint empinx, cluster(id) robust nolog 
outreg2 using civsocappend1, eform coefastr se dec(3) append 

stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo physint empinx, cluster(id) robust nolog
outreg2 using civsocappend1, eform coefastr se dec(3) append 

stcox civ nowpcon degreepact duration intensity incompatibility Demo TSMOpoplog, cluster(id) robust nolog 

stcox civandpol nowpcon degreepact duration intensity incompatibility Demo TSMOpoplog, cluster(id) robust nolog 
outreg2 using civsocappend2, eform coefastr se dec(3) append 

stcox civ demociv nowpcon degreepact duration intensity incompatibility Demo TSMOpoplog, cluster(id) robust nolog
outreg2 using civsocappend2, eform coefastr se dec(3) append 

*****

**DESCRIPTIVE STATS**
