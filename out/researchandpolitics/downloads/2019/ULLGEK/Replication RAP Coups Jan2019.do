set more off

use "coups_RAP.dta", clear

**Model 1 (Table 2)
heckprob hcoup autleg3 lrgdppc h_sp*, ///
select (coup_a = autleg3 i.defacto2 lrgdppc a_*) vce(cluster ccode)
outreg2 using table1, append label word 

**Model 2 (Table 2)
heckprob hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h h_sp*, ///
select (coup_a = autleg3 i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode)
outreg2 using table1, append label word 

**Model 3
heckprob hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h h_sp*, ///
select (coup_a = i.closed i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode)
outreg2 using table1, append label word 

*test of coefficient difference for legislature
test [coup_a]1.closed=[coup_a]2.closed

*Obtain marginal effects from selection equation
margins, at(closed=(0 1 2)) predict(psel)
marginsplot, recast(scatter) xscale(range(0 2)) scheme(s1mono) 

margins, at(defacto2=(0 1 2)) predict(psel)
marginsplot, recast(scatter) xscale(range(0 2)) scheme(s1mono)

***Appendix

use "coups_RAP.dta", clear
 
 ****TABLE A1***
 
 ** 1. replication of Bove and Rivera (2015)
  **Model A1, Table 1
probit hcoup  autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups, cluster(ccode)
outreg2 using appendix1, replace label word

// Model A2, Table 1 (with pre_h)
probit hcoup  autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h, cluster(ccode)
outreg2 using appendix1, append label word

**Model A3 **Time controls for B&R and corrected sum of previous successful coups
probit hcoup  autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h h_sp*, cluster(ccode)
outreg2 using appendix1, append label word

**Model A4** Success B&R
probit hcoup i.closed Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h, cluster(ccode)
outreg2 using appendix1, append label word
test 0.closed=1.closed
test 1.closed=2.closed


***TABLE A2*****
**Alternative specifications of the Heckman probit

**Model A5. Naked model
heckprob hcoup autleg3 pre_h h_sp*, select (coup_a = i.closed i.defacto2 pre_a a_*)
outreg2 using appendix3, replace label word onecol


// Model A6 without time controls in the success equation
heckprob hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h, ///
select (coup_a = i.closed i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode)
outreg2 using appendix3, append label word onecol

***TABLE A3****

** Model A7. coup success from Powell and Thyne
heckprob coup_s autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_s s_**, ///
select (coup_a = i.closed i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode)
outreg2 using appendix4, replace label word onecol

***Alternative specifications of the probit model

***TABLE A4****
** Model A8. Attempt** Same as model 2 from main text, but more IV legislature
probit coup_a i.closed i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*, cluster(ccode)
outreg2 using appendix5, replace label word
test 0.closed=1.closed
test 1.closed=2.closed

 **Model A9. Accounting for regime type from Geddes
probit coup_a legis2 i.defacto2 Purges gwf_party gwf_military gwf_personal lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*, cluster(ccode)
outreg2 using appendix5, append label word

**TABLE A5
** Model A9. Accounting for structural coup-proofing.
probit coup_a legis2 i.defacto2 effective_number eff2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*, cluster(ccode)
outreg2 using table4, append label word 

**Table A6. Summary statistics (Table 1)
outreg2 using x2.doc, label replace sum(log) keep(coup_a hcoup autleg3 closed defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a pre_h) 
 
**Assumption of identification

**Model A10. Spatial Lag of Coups (distance <950km)
heckprob hcoup autleg3 i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h h_sp*, ///
select (coup_a = autleg3 i.defacto2 SL_lag_coupa Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode) 
outreg2 using table5, append label word 

**Model A11 - Miller EBA
heckprob hcoup autleg3 i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h h_sp*, ///
select (coup_a = autleg3 i.defacto2 mjo_region_s_np_nbc_2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode) 
outreg2 using table5, append label word 

***Model A12. Institutionalized succession rules
 heckprob hcoup autleg3 i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h h_sp*, ///
select (coup_a = autleg3 i.defacto2 succession Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode) 
outreg2 using table6, append label word 

***Model A13. SL Democracies 
heckprob hcoup autleg3 i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h h_sp*, ///
select (coup_a = autleg3 i.defacto2 SL_polyarchy_neigh Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode) 
outreg2 using table6, append label word 

**Model A14 and 15
heckprob hcoup autleg3 i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h h_sp*, ///
select (coup_a = autleg3 i.defacto2 SL_lag_coupa SL_elected_neigh Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode) 
outreg2 using table7, append label word 


heckprob hcoup autleg3 i.defacto2 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h h_sp*, ///
select (coup_a = autleg3 i.defacto2 SL_lag_coupa SL_singlep_neigh Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_a a_*) vce(cluster ccode) 
outreg2 using table7, append label word 


**Model A15 - Sartori
sartsel dv_sartori autleg3 single_party mparty Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc pre_h pre_a, corr (-.5)
outreg2 using table8, append label word 
