****Rogowski-Tucker Newtown Replication File
use "PSRM_Replication_Data.dta"
***Creating Variables from raw data
** Treating neithers as 0
gen guns_dec12=IGUNS13
recode guns_dec12 (1 2=1) (3 4 5=0) (-1=.)

gen guns_jan13=IGUNS14
recode guns_jan13 (1 2=1) (3 4 5=0) (-1=.)


gen newtown=before_newtown
recode newtown (0=1) (1=0)
svyset [pw=dec2012wt1]

gen NorthEast=.
replace NorthEast=1 if newregion==1
replace NorthEast=0 if newregion>=2 & newregion<=4

***Figure 2
**Panel A
***Information also completes Table A1
*****OUTPUT FROM THE FOLLOWING PROVIDES CELLS FOR TABLE A1
*******guns_dec12=0 mean is column 1 for TABLE A1
*******guns_dec12=1 mean is column 2 for TABLE A1

** All
svy: mean guns_dec,over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** Democrats
svy: mean guns_dec,subpop(if PID3_MAXN ==1) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** Independents
svy: mean guns_dec,subpop(if PID3_MAXN ==3) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

***Republicans
svy: mean guns_dec,subpop(if PID3_MAXN ==2) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** Liberal
svy: mean guns_dec,subpop(if IDEOL4SP ==1) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** Moderate
svy: mean guns_dec,subpop(if IDEOL4SP ==2) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** Conservative
svy: mean guns_dec,subpop(if IDEOL4SP ==3) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** Women
svy: mean guns_dec,subpop(if ppgender==2) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** Men
svy: mean guns_dec,subpop(if ppgender==1) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** Have children
svy: mean guns_dec,subpop(if CHLDUNDR18SP ==1) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** No children
svy: mean guns_dec,subpop(if CHLDUNDR18SP ==2) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** NRA nonmember
svy: mean guns_dec,subpop(if MEM1C_2_3 ==0) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

** Northeast State
svy: mean guns_dec,subpop(if NorthEast ==1) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0
** Non-Northeast State
svy: mean guns_dec,subpop(if NorthEast ==0) over(newtown)
lincom [guns_dec12]1-[guns_dec12]0

***Figure 2
**Panel B
***Information provided also completes Table A2
*****OUTPUT FROM THE FOLLOWING PROVIDES CELLS FOR TABLE A1
*******guns_dec12 mean is column 1 for TABLE A2
*******guns_jan13 mean is column 2 for TABLE A2


** All
svy: mean guns_dec guns_jan,subpop(if newtown==0)
lincom guns_jan13-guns_dec12

** Dems
svy: mean guns_dec guns_jan,subpop(if PID3_MAXN ==1 & newtown==0) 
lincom guns_jan13-guns_dec12

** Inds
svy: mean guns_dec guns_jan,subpop(if PID3_MAXN ==3 & newtown==0) 
lincom guns_jan13-guns_dec12

** Reps
svy: mean guns_dec guns_jan,subpop(if PID3_MAXN ==2 & newtown==0) 
lincom guns_jan13-guns_dec12

** Liberal
svy: mean guns_dec guns_jan,subpop(if IDEOL4SP ==1 & newtown==0) 
lincom guns_jan13-guns_dec12

** Moderate
svy: mean guns_dec guns_jan,subpop(if IDEOL4SP ==2 & newtown==0) 
lincom guns_jan13-guns_dec12

** Conservative
svy: mean guns_dec guns_jan,subpop(if IDEOL4SP ==3 & newtown==0) 
lincom guns_jan13-guns_dec12

** Women
svy: mean guns_dec guns_jan,subpop(if ppgender==2 & newtown==0) 
lincom guns_jan13-guns_dec12

** Men
svy: mean guns_dec guns_jan,subpop(if ppgender==1 & newtown==0) 
lincom guns_jan13-guns_dec12

** Have children
svy: mean guns_dec guns_jan,subpop(if CHLDUNDR18SP ==1 & newtown==0) 
lincom guns_jan13-guns_dec12

** No children
svy: mean guns_dec guns_jan,subpop(if CHLDUNDR18SP ==2 & newtown==0) 
lincom guns_jan13-guns_dec12

** NRA nonmember
svy: mean guns_dec guns_jan,subpop(if MEM1C_2_3 ==0 & newtown==0) 
lincom guns_jan13-guns_dec12

***Non- Northeast State
svy: mean guns_dec guns_jan,subpop(if NorthEast ==0 & newtown==0) 
lincom guns_jan13-guns_dec12
***Northeast State
svy: mean guns_dec guns_jan,subpop(if NorthEast ==1 & newtown==0) 
lincom guns_jan13-guns_dec12


***************************
** Opinion polarization? **
***************************
gen guns5_dec12=IGUNS13
recode guns5_dec12  (1=5) (2=4) (4=2) (5=1) (-1=.)

gen guns5_jan13=IGUNS14
recode guns5_jan13 (1=5) (2=4) (4=2) (5=1) (-1=.)
** Supporters vs. Opponents
gen support=1 if guns_dec==1
replace support=0 if IGUNS13==4|IGUNS13==5
***Figure 3
svy: mean guns5_dec guns5_jan,over(support) subpop(if newtown==0)
lincom ([guns5_jan13]1 - [guns5_jan13]0) 
lincom ([guns5_dec12]1 - [guns5_dec12]0)
lincom ([guns5_jan13]1- [guns5_jan13]0)  - ([guns5_dec12]1 - [guns5_dec12]0)


** Democrats vs. Republicans

svy: mean guns5_dec guns5_jan,over(PID3_MAXN) subpop(if newtown==0) 
lincom ([guns5_jan13]Democrat - [guns5_jan13]Republican) 
lincom ([guns5_dec12]Democrat - [guns5_dec12]Republican)
lincom ([guns5_jan13]Democrat - [guns5_jan13]Republican) - ([guns5_dec12]Democrat - [guns5_dec12]Republican)

** Liberals vs. Conservatives

svy: mean guns5_dec guns5_jan,over(IDEOL4SP) subpop(if newtown==0) 
lincom ([guns5_jan13]Liberal - [guns5_jan13]Conservative) 
lincom ([guns5_dec12]Liberal - [guns5_dec12]Conservative) 
lincom ([guns5_jan13]Liberal - [guns5_jan13]Conservative) - ([guns5_dec12]Liberal - [guns5_dec12]Conservative) 


***Figure A1
***Left Panel
** All
svy: mean guns5_dec,over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Dems
svy: mean guns5_dec,subpop(if PID3_MAXN ==1) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Inds
svy: mean guns5_dec,subpop(if PID3_MAXN ==3) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Reps
svy: mean guns5_dec,subpop(if PID3_MAXN ==2) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Liberal
svy: mean guns5_dec,subpop(if IDEOL4SP ==1) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Moderate
svy: mean guns5_dec,subpop(if IDEOL4SP ==2) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Conservative
svy: mean guns5_dec,subpop(if IDEOL4SP ==3) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Women
svy: mean guns5_dec,subpop(if ppgender==2) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Men
svy: mean guns5_dec,subpop(if ppgender==1) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Have children
svy: mean guns5_dec,subpop(if CHLDUNDR18SP ==1) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** No children
svy: mean guns5_dec,subpop(if CHLDUNDR18SP ==2) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** NRA nonmember
svy: mean guns5_dec,subpop(if MEM1C_2_3 ==0) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Northeasterner
svy: mean guns5_dec,subpop(if NorthEast ==1) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0

** Non-Northeasterner
svy: mean guns5_dec,subpop(if NorthEast ==0) over(newtown)
lincom [guns5_dec12]1-[guns5_dec12]0


***Figure A2 Right panel
** All
svy: mean guns5_dec guns5_jan,subpop(if newtown==0)
lincom guns5_jan13-guns5_dec12

** Dems
svy: mean guns5_dec guns5_jan,subpop(if PID3_MAXN ==1 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Inds
svy: mean guns5_dec guns5_jan,subpop(if PID3_MAXN ==3 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Reps
svy: mean guns5_dec guns5_jan,subpop(if PID3_MAXN ==2 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Liberal
svy: mean guns5_dec guns5_jan,subpop(if IDEOL4SP ==1 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Moderate
svy: mean guns5_dec guns5_jan,subpop(if IDEOL4SP ==2 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Conservative
svy: mean guns5_dec guns5_jan,subpop(if IDEOL4SP ==3 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Women
svy: mean guns5_dec guns5_jan,subpop(if ppgender==2 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Men
svy: mean guns5_dec guns5_jan,subpop(if gendersp==1 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Have children
svy: mean guns5_dec guns5_jan,subpop(if CHLDUNDR18SP ==1 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** No children
svy: mean guns5_dec guns5_jan,subpop(if CHLDUNDR18SP ==2 & newtown==0) 
lincom guns5_jan13-guns5_dec12


** NRA nonmember
svy: mean guns5_dec guns5_jan,subpop(if MEM1C_2_3 ==0 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Northeasterner
svy: mean guns5_dec guns5_jan,subpop(if NorthEast ==1 & newtown==0) 
lincom guns5_jan13-guns5_dec12

** Non-Northeasterner
svy: mean guns5_dec guns5_jan,subpop(if NorthEast ==0 & newtown==0) 
lincom guns5_jan13-guns5_dec12


***Figure 1 River Plot Values 
tab guns5_dec guns5_jan if newtown==0, row
tab guns5_dec guns5_jan if newtown==0, col
