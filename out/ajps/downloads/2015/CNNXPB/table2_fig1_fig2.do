* Date: May 23, 2013
* Apply to: table2_fig1_fig2.dta
* Description: Replicate Table 2 logit models 
*			   Replicate predicted support levels in Figures 1 and 2

clear
clear matrix

set matsize 1000

set more off


use "\table2_fig1_fig2.dta", clear


* All Respondents Model

logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control, noconstant cluster(caseid)

estsimp logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control, noconstant cluster(caseid)
 

* Estimate levels of support for Figure 1

* REINFORCING INFORMATION

setx median
setx rei_control 1

simqi, listx

setx median
setx rei_party 1

simqi, listx

setx median
setx rei_policy 1

simqi, listx

setx median
setx rei_party_policy 1

simqi, listx


* BALANCED INFORMATION

setx median
setx bal_control 1

simqi, listx

setx median
setx bal_party 1

simqi, listx

setx median
setx bal_policy 1

simqi, listx

setx median
setx bal_party_policy 1

simqi, listx


* CONFLICTING INFORMATION

setx median
setx con_control 1

simqi, listx

setx median
setx con_party 1

simqi, listx

setx median
setx con_policy 1

simqi, listx

setx median
setx con_party_policy 1

simqi, listx

 
* Examine significance of treatment effects

* REINFORCING INFORMATION
* Set rei_control to 1

setx median
setx rei_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(rei_control 1 0 rei_party 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_policy 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_party_policy 0 1) l(90)


* Set rei_party to 1

setx rei_control 0
setx rei_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(rei_party 1 0 rei_party_policy 0 1) l(90)


* BALANCED INFORMATION
* Set bal_control to 1

setx median
setx bal_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(bal_control 1 0 bal_party 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_policy 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_party_policy 0 1) l(90)


* Set bal_party to 1

setx bal_control 0
setx bal_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(bal_party 1 0 bal_party_policy 0 1) l(90)


* CONFLICTING INFORMATION
* Set con_control to 1

setx median
setx con_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(con_control 1 0 con_party 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_policy 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_party_policy 0 1) l(90)


* Set con_party to 1

setx con_control 0
setx con_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(con_party 1 0 con_party_policy 0 1) l(90)


drop b1-b12


* High Knowledge Respondents Model

logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control if know_high==1, noconstant cluster(caseid)

estsimp logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control if know_high==1, noconstant cluster(caseid)


* Estimate levels of support for Figure 2a

* REINFORCING INFORMATION

setx median
setx rei_control 1

simqi, listx

setx median
setx rei_party 1

simqi, listx

setx median
setx rei_policy 1

simqi, listx

setx median
setx rei_party_policy 1

simqi, listx


* BALANCED INFORMATION

setx median
setx bal_control 1

simqi, listx

setx median
setx bal_party 1

simqi, listx

setx median
setx bal_policy 1

simqi, listx

setx median
setx bal_party_policy 1

simqi, listx


* CONFLICTING INFORMATION

setx median
setx con_control 1

simqi, listx

setx median
setx con_party 1

simqi, listx

setx median
setx con_policy 1

simqi, listx

setx median
setx con_party_policy 1

simqi, listx


* Examine significance of treatment effects

* REINFORCING INFORMATION
* Set rei_control to 1

setx median
setx rei_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(rei_control 1 0 rei_party 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_policy 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_party_policy 0 1) l(90)


* Set rei_party to 1

setx rei_control 0
setx rei_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(rei_party 1 0 rei_party_policy 0 1) l(90)


* BALANCED INFORMATION
* Set bal_control to 1

setx median
setx bal_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(bal_control 1 0 bal_party 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_policy 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_party_policy 0 1) l(90)


* Set bal_party to 1

setx bal_control 0
setx bal_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(bal_party 1 0 bal_party_policy 0 1) l(90)


* CONFLICTING INFORMATION
* Set con_control to 1

setx median
setx con_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(con_control 1 0 con_party 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_policy 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_party_policy 0 1) l(90)


* Set con_party to 1

setx con_control 0
setx con_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(con_party 1 0 con_party_policy 0 1) l(90)


drop b1-b12


* Low Knowledge Respondents Model

logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control if know_high==0, noconstant cluster(caseid)

estsimp logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control if know_high==0, noconstant cluster(caseid)


* Estimate levels of support for Figure 2c

* REINFORCING INFORMATION

setx median
setx rei_control 1

simqi, listx

setx median
setx rei_party 1

simqi, listx

setx median
setx rei_policy 1

simqi, listx

setx median
setx rei_party_policy 1

simqi, listx


* BALANCED INFORMATION

setx median
setx bal_control 1

simqi, listx

setx median
setx bal_party 1

simqi, listx

setx median
setx bal_policy 1

simqi, listx

setx median
setx bal_party_policy 1

simqi, listx


* CONFLICTING INFORMATION

setx median
setx con_control 1

simqi, listx

setx median
setx con_party 1

simqi, listx

setx median
setx con_policy 1

simqi, listx

setx median
setx con_party_policy 1

simqi, listx


* Examine significance of treatment effects

* REINFORCING INFORMATION
* Set rei_control to 1

setx median
setx rei_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(rei_control 1 0 rei_party 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_policy 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_party_policy 0 1) l(90)


* Set rei_party to 1

setx rei_control 0
setx rei_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(rei_party 1 0 rei_party_policy 0 1) l(90)


* BALANCED INFORMATION
* Set bal_control to 1

setx median
setx bal_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(bal_control 1 0 bal_party 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_policy 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_party_policy 0 1) l(90)


* Set bal_party to 1

setx bal_control 0
setx bal_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(bal_party 1 0 bal_party_policy 0 1) l(90)


* CONFLICTING INFORMATION
* Set con_control to 1

setx median
setx con_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(con_control 1 0 con_party 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_policy 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_party_policy 0 1) l(90)


* Set con_party to 1

setx con_control 0
setx con_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(con_party 1 0 con_party_policy 0 1) l(90)


drop b1-b12


* Strong Partisan Respondents Model

logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control if pty_strong==1, noconstant cluster(caseid)

estsimp logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control if pty_strong==1, noconstant cluster(caseid)


* Estimate levels of support for Figure 2b

* REINFORCING INFORMATION

setx median
setx rei_control 1

simqi, listx

setx median
setx rei_party 1

simqi, listx

setx median
setx rei_policy 1

simqi, listx

setx median
setx rei_party_policy 1

simqi, listx


* BALANCED INFORMATION

setx median
setx bal_control 1

simqi, listx

setx median
setx bal_party 1

simqi, listx

setx median
setx bal_policy 1

simqi, listx

setx median
setx bal_party_policy 1

simqi, listx


* CONFLICTING INFORMATION

setx median
setx con_control 1

simqi, listx

setx median
setx con_party 1

simqi, listx

setx median
setx con_policy 1

simqi, listx

setx median
setx con_party_policy 1

simqi, listx


* Examine significance of treatment effects

* REINFORCING INFORMATION
* Set rei_control to 1

setx median
setx rei_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(rei_control 1 0 rei_party 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_policy 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_party_policy 0 1) l(90)


* Set rei_party to 1

setx rei_control 0
setx rei_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(rei_party 1 0 rei_party_policy 0 1) l(90)


* BALANCED INFORMATION
* Set bal_control to 1

setx median
setx bal_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(bal_control 1 0 bal_party 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_policy 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_party_policy 0 1) l(90)


* Set bal_party to 1

setx bal_control 0
setx bal_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(bal_party 1 0 bal_party_policy 0 1) l(90)


* CONFLICTING INFORMATION
* Set con_control to 1

setx median
setx con_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(con_control 1 0 con_party 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_policy 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_party_policy 0 1) l(90)


* Set con_party to 1

setx con_control 0
setx con_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(con_party 1 0 con_party_policy 0 1) l(90)


drop b1-b12


* Weak Partisan Respondents Model

logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control if pty_strong==0, noconstant cluster(caseid)

estsimp logit sup_init rei_party rei_policy rei_party_policy rei_control ///
     con_party con_policy con_party_policy con_control ///
     bal_party bal_policy bal_party_policy bal_control if pty_strong==0, noconstant cluster(caseid)


* Estimate levels of support for Figure 2d

* REINFORCING INFORMATION

setx median
setx rei_control 1

simqi, listx

setx median
setx rei_party 1

simqi, listx

setx median
setx rei_policy 1

simqi, listx

setx median
setx rei_party_policy 1

simqi, listx


* BALANCED INFORMATION

setx median
setx bal_control 1

simqi, listx

setx median
setx bal_party 1

simqi, listx

setx median
setx bal_policy 1

simqi, listx

setx median
setx bal_party_policy 1

simqi, listx


* CONFLICTING INFORMATION

setx median
setx con_control 1

simqi, listx

setx median
setx con_party 1

simqi, listx

setx median
setx con_policy 1

simqi, listx

setx median
setx con_party_policy 1

simqi, listx


* Examine significance of treatment effects

* REINFORCING INFORMATION
* Set rei_control to 1

setx median
setx rei_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(rei_control 1 0 rei_party 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_policy 0 1) l(90)
simqi, fd(pr) changex(rei_control 1 0 rei_party_policy 0 1) l(90)


* Set rei_party to 1

setx rei_control 0
setx rei_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(rei_party 1 0 rei_party_policy 0 1) l(90)


* BALANCED INFORMATION
* Set bal_control to 1

setx median
setx bal_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(bal_control 1 0 bal_party 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_policy 0 1) l(90)
simqi, fd(pr) changex(bal_control 1 0 bal_party_policy 0 1) l(90)


* Set bal_party to 1

setx bal_control 0
setx bal_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(bal_party 1 0 bal_party_policy 0 1) l(90)


* CONFLICTING INFORMATION
* Set con_control to 1

setx median
setx con_control 1

simqi, listx


* Treatments vs. control

simqi, fd(pr) changex(con_control 1 0 con_party 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_policy 0 1) l(90)
simqi, fd(pr) changex(con_control 1 0 con_party_policy 0 1) l(90)


* Set con_party to 1

setx con_control 0
setx con_party 1


* Party + Policy Treatment vs. Party Treatment

simqi, fd(pr) changex(con_party 1 0 con_party_policy 0 1) l(90)


drop b1-b12


* End 
