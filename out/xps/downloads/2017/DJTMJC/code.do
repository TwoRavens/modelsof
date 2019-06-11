**replication codes***

**Change working directory to the folder containing the data.

*cd XXX

**Install coefplot for the plotting

*ssc install coefplot

use data.dta

*********************

*Summary Statistics: Low skilled Wave 1 + 2 (Table 1)

sum age han male rural eastern central western college ccp cyl socialstatus ///
income SOE foreign private manu if college==0 & (_n<2225 | _n>22146)

*Main results in paper (Figure 1)
*Low skilled (no college degree) with rating as DV (OLS)

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if college==0, cluster(v1)

coefplot, xline(0) msize(small) drop(_cons) omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))

*********************
*Appendix

**summary Statistics

*Wave 1 (Table C2)
sum age han male rural eastern central western college ccp cyl socialstatus ///
income SOE foreign private manu if _n<2225

*Wave 2 (Table C3)
sum age han male rural eastern central western college ccp cyl socialstatus ///
income SOE foreign private manu if wave == 2 & _n<18415

*Low skilled (no college degree) with binary measure as DV (Figure D1)		 
reg prefer i.country i.industry i.method i.job i.value i.policy i.wage if college==0, cluster(v1)

coefplot, xline(0) msize(small) drop(_cons) omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Pr(FDI Project Chosen)) ///
graphregion(color(white)) ylab(, labs(vsmall))

**Interactive Effects of Industry and Job Impact (Figure D2)

reg rating i.country i.industry##i.job i.method i.value i.policy i.wage if college==0 , cluster(v1)

coefplot, xline(0) msize(small) drop(_cons) omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))

**Excluding Young and Jobless Respondents (Figure D3)

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if college==0 & age>1 & q39<=10, cluster(v1)

coefplot, xline(0) msize(small) drop(_cons) omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))

**Conditional Effects of the FDI Attributes by Income Level (Figure E1)
reg rating i.country i.industry i.method i.job i.value i.policy i.wage if income>4 & college==0, cluster(v1)
estimates store A

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if income<5 & college==0, cluster(v1)
estimates store B

coefplot (A, label(High Income) msize(small)) (B, label(Low Income) msymbol(Oh) msize(small)), ///
xline(0) drop(_cons)  omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))

**Conditional Effects of the FDI Attributes by Perceived Social Status (Figure E2)

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if socialstatus>4 & college==0, cluster(v1)
estimates store A

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if socialstatus<5 & college==0, cluster(v1)
estimates store B

coefplot (A, label(Perceived Social Status: High) msize(small)) ///
(B, label(Perceived Social Status: Low) msymbol(Oh) msize(small)), ///
xline(0) drop(_cons)  omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))

**Conditional Effects of the FDI Attributes by Sector of Employment (Figure E3)

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if manu==1 & college==0, cluster(v1)
estimates store A

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if manu==0 & college==0, cluster(v1)
estimates store B

coefplot (A, label(Manufacturing) msize(small)) ///
(B, label(Non-Manufacturing) msymbol(Oh) msize(small)), ///
xline(0) drop(_cons)  omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))

**Conditional Effects of the FDI Attributes by Gender (Figure E4)

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if male==1 & college==0, cluster(v1)
estimates store A

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if male==0 & college==0, cluster(v1)
estimates store B

coefplot (A, label(Male) msize(small)) ///
(B, label(Female) msymbol(Oh) msize(small)), ///
xline(0) drop(_cons)  omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))

**Conditional Effects of the FDI Attributes by CCP/CYL Membership& CYL (Figure E5)

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if (ccp==1 | cyl ==1) & college==0, cluster(v1)
estimates store A

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if (ccp==0 & cyl==0) & college==0, cluster(v1)
estimates store B

coefplot (A, label(CCP/CYL member) msize(small)) ///
(B, label(Non-member) msymbol(Oh) msize(small)), ///
xline(0) drop(_cons)  omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))

**Conditional Effects of the FDI Attributes by State/Non-state Sector (Figure E6)

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if SOE==1 & college==0, cluster(v1)
estimates store A

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if SOE==0 & college==0, cluster(v1)
estimates store B

coefplot (A, label(State Sector) msize(small)) ///
(B, label(Non-state Sector) msymbol(Oh) msize(small)), ///
xline(0) drop(_cons)  omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))


**Conditional Effects of the FDI Attributes by Household Registration (Figure E7)

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if rural==1 & college==0, cluster(v1)
estimates store A

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if rural==0 & college==0, cluster(v1)
estimates store B

coefplot (A, label(Rural) msize(small)) ///
(B, label(Urban) msymbol(Oh) msize(small)), ///
xline(0) drop(_cons)  omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))

**Conditional Effects of the FDI Attributes by Age Cohort (Figure E8) 

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if age<=2 & college==0, cluster(v1)
estimates store A

reg rating i.country i.industry i.method i.job i.value i.policy i.wage if age>=3 & college==0, cluster(v1)
estimates store B

coefplot (A, label(29 & younger) msize(small)) ///
(B, label(30 & older) msymbol(Oh) msize(small)), ///
xline(0) drop(_cons)  omitted baselevels headings( ///
1.country = "{bf: Home Country}" 1.industry = "{bf: Industry}" ///
1.method = "{bf: Entry Mode}" 1.job = "{bf:Impact on Local Job Market}" ///
1.value = "{bf: Amount of Investment}" 1.policy = "{bf: Local Policy Concessions}" ///
1.wage = "{bf: Wage Level}", labsize(small)) xtitle (Change in Rating (on a 7-point Scale)) ///
graphregion(color(white)) ylab(, labs(vsmall))







