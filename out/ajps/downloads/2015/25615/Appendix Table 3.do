 set more off 
  
  cd "~/Dropbox/Attribution Analysis Feb 2012/"

    use attribution.dta, clear
  
  egen overallsubid=group(session period sid)
	sort  session period sid vw
	egen DMid=seq(), from(1) to(5)
  
  /**** Note: these are ordered so that when the data set is rearranges varaibles marked "1" are for the smallest dm
        vars marked 2 are the next biggest, etc... up until those marked 5 are for the largest dm in the distribution ***/
		
	egen totalpunishment=total(ndp), by(overallsubid)
	egen marksubject=tag(overallsubid)
	gen insample=0
	replace insample=1  if  treat1==1& treat3==1&session~=1

	keep if insample==1
	
/* now make a composition for those people that did something */


gen percentpunish=ndp/totalpunishment  /* note this generated missing for those who allocated nothing */
replace percentpunish=.00001 if percentpunish==0

egen percentpunishtotal2=total(percentpunish), by(overallsubid)
gen percentpunish2=percentpunish/percentpunishtotal2

egen test=total(percentpunish2), by(overallsubid)

rename vw weight
drop vw*
drop admv
drop ndp
drop dp
drop marksubject percentpunish
reshape wide adm weight  percentpunish2  , i(overallsubid) j(DMid)

gen lrpun1_5=ln(percentpunish21/percentpunish25)
gen lrpun2_5=ln(percentpunish22/percentpunish25)
gen lrpun3_5=ln(percentpunish23/percentpunish25)
gen lrpun4_5=ln(percentpunish24/percentpunish25)

/* the variable names of these dummies refer to the order in the distribution and the distribution so the first number
   is the order in the distribution where 1 is smallest and 5 is biggest adn the second numnber is treatment 1 2 3 or 4, which are different
   distributions */
   

gen weight1_2=(weight1==2)      
gen weight1_8=(weight1==8)
gen weight1_11=(weight1==11)   
gen weight1_17=(weight1==17)   

gen weight2_6=(weight2==6)
gen weight2_11=(weight2==11) 
gen weight2_13=(weight2==13) 
gen weight2_19=(weight2==19)    

gen weight3_10=(weight3==10)
gen weight3_14=(weight3==14) 
gen weight3_17=(weight3==17) 
gen weight3_20=(weight3==20) 

gen weight4_29=(weight4==29) 
gen weight4_19=(weight4==19) 
gen weight4_21a=(weight4==21&treat2==3) 
gen weight4_21b=(weight4==21&treat2==4) 

gen weight5_53=(weight5==53)  
gen weight5_48=(weight5==48)  
gen weight5_38=(weight5==38)  
gen weight5_23=(weight5==23)  
  

  
  
egen subjectperm=group(subject session) 
	

local eq1vars "lrpun1_5 allocdm weight1_2 weight1_8 weight1_11  adm1 adm2 adm3 adm4  totalpunishment"
local eq2vars "lrpun2_5 allocdm weight2_6 weight2_11 weight2_13  adm1 adm2 adm3 adm4   totalpunishment"
local eq3vars "lrpun3_5 allocdm weight3_10 weight3_14 weight3_17 adm1 adm2 adm3 adm4  totalpunishment"
local eq4vars "lrpun4_5 allocdm weight4_29 weight4_19 weight4_21a  adm1 adm2 adm3 adm4  totalpunishment"


/* Table 2: results using dummies for weights */

# delimit ;
sureg (lrpun1_5 allocdm weight1_2 weight1_8 weight1_11  adm1 adm2 adm3 adm4  totalpunishment)
	(lrpun2_5 allocdm weight2_6 weight2_11 weight2_13  adm1 adm2 adm3 adm4   totalpunishment)
	(lrpun3_5 allocdm weight3_10 weight3_14 weight3_17 adm1 adm2 adm3 adm4  totalpunishment)
	(lrpun4_5 allocdm weight4_29 weight4_19 weight4_21a  adm1 adm2 adm3 adm4  totalpunishment) if totalpunishment>0;

# delimit cr


/* This is M1 in Appendix Table 4 */

# delimit ;
sureg (lrpun1_5 allocdm weight1_2 weight1_8 weight1_11  adm1 adm2 adm3 adm4  totalpunishment)
	(lrpun2_5 allocdm weight2_6 weight2_11 weight2_13  adm1 adm2 adm3 adm4   totalpunishment)
	(lrpun3_5 allocdm weight3_10 weight3_14 weight3_17 adm1 adm2 adm3 adm4  totalpunishment)
	(lrpun4_5 allocdm weight4_29 weight4_19 weight4_21a  adm1 adm2 adm3 adm4  totalpunishment) if totalpunishment>0;

	# delimit cr
	
/* This is M2 in Appendix Table 4 */

# delimit ;
reg (lrpun1_5 allocdm weight1_2 weight1_8 weight1_11  adm1 adm2 adm3 adm4  totalpunishment) if totalpunishment>0;
reg	(lrpun2_5 allocdm weight2_6 weight2_11 weight2_13  adm1 adm2 adm3 adm4   totalpunishment) if totalpunishment>0;
reg	(lrpun3_5 allocdm weight3_10 weight3_14 weight3_17 adm1 adm2 adm3 adm4  totalpunishment) if totalpunishment>0;
reg	(lrpun4_5 allocdm weight4_29 weight4_19 weight4_21a  adm1 adm2 adm3 adm4  totalpunishment) if totalpunishment>0;

# delimit cr

/* This is M3 in Appendix Table 4 */

# delimit ;
reg (lrpun1_5 allocdm weight1_2 weight1_8 weight1_11  adm1 adm2 adm3 adm4  totalpunishment) if totalpunishment>0, cluster(overallsubid);
reg	(lrpun2_5 allocdm weight2_6 weight2_11 weight2_13  adm1 adm2 adm3 adm4   totalpunishment) if totalpunishment>0, cluster(overallsubid);
reg	(lrpun3_5 allocdm weight3_10 weight3_14 weight3_17 adm1 adm2 adm3 adm4  totalpunishment) if totalpunishment>0, cluster(overallsubid);
reg	(lrpun4_5 allocdm weight4_29 weight4_19 weight4_21a  adm1 adm2 adm3 adm4  totalpunishment) if totalpunishment>0, cluster(overallsubid);

# delimit cr

/* This model in Table 5 that drops DM allocation */

# delimit ;
sureg (lrpun1_5 weight1_2 weight1_8 weight1_11  adm1 adm2 adm3 adm4  totalpunishment)
	(lrpun2_5 weight2_6 weight2_11 weight2_13  adm1 adm2 adm3 adm4   totalpunishment)
	(lrpun3_5 weight3_10 weight3_14 weight3_17 adm1 adm2 adm3 adm4  totalpunishment)
	(lrpun4_5 weight4_29 weight4_19 weight4_21a  adm1 adm2 adm3 adm4  totalpunishment) if totalpunishment>0, corr;

# delimit cr

