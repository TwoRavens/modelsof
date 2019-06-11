
/*****************************************************************************

This do file creates all tables and figures in
"Ban the Box, Criminal Records, and Racial Discrimination: A Field Experiment"
Requires .dta file "AganStarrQJEData.dta"

Last Modified: 6/7/2017 by AA
*****************************************************************************/

clear

use "AganStarrQJEData.dta"


/************************************************************************************************************************************
 
 /********** Table I: Means of Applicant and Application Characteristics and Callback Rates by Period **********/
 
************************************************************************************************************************************/


summarize white crime ged empgap crimbox response  interview response_black response_white  response_ged response_hsd response_empgap response_noempgap if pre==1  & remover!=-1
summarize white crime ged empgap crimbox response  interview response_black  response_white  response_ged response_hsd response_empgap response_noempgap if pre==0   & remover!=-1  
summarize white crime ged empgap crimbox response  interview response_black  response_white   response_ged response_hsd response_empgap response_noempgap  if remover!=-1


/************************************************************************************************************************************
 
 /********** Table II: Callback Rates by Crime Status for Stores with the Box in the Pre-Period **********/
 
************************************************************************************************************************************/


summarize response  response_black response_white if crimbox==1  & crime==0 & pre==1  & remover!=-1
summarize response  response_black response_white if crimbox==1  & crime==1 & pre==1  & remover!=-1
summarize response  response_black response_white if crimbox==1  & propertycrime==1 & pre==1   & remover!=-1
summarize response  response_black response_white if crimbox==1  & drugcrime==1 & pre==1   & remover!=-1
summarize response  response_black response_white if crimbox==1  & pre==1   & remover!=-1


/************************************************************************************************************************************
 
 /********** Table III: Effects of Applicant Characteristics on Callback Rates  **********/

************************************************************************************************************************************/

  

reg response white crime ged empgap pre i.center i.cogroup_comb if  remover!=-1 , cl(chain_id)
reg response white crime ged empgap i.center i.cogroup_comb  if  crimbox==1   & remover!=-1 , cl(chain_id)
reg response white  drugcrime propertycrime ged empgap i.center i.cogroup_comb  if crimbox==1  & remover!=-1  , cl(chain_id)


 
/************************************************************************************************************************************
 
 /********** Figures I and II **********/
 
************************************************************************************************************************************/

 * Figure I call back rates by race in pre-period for box and no box companies 
graph bar (mean) response if  pre==1 & remover!=-1, over(nocrime_box) over(nocrimbox)    over(white)   blabel(total, format(%9.3f)  )  bar(1, color(black)) bar(2, color(white) lcolor(black) lwidth(medium)) ///
   ytitle(Callback Rate) scheme(s1mono) ylab(, nogrid)
 /* the below code will then change the appropriate bars to gray. */ 
 * change bar 1 to gray
 gr_edit .plotregion1.bars[3].EditCustomStyle , j(-1) style(shadestyle(color(gray)))
 gr_edit .plotregion1.bars[3].EditCustomStyle , j(-1) style(linestyle(color(gray)))
 * change bar 4 to gray
 gr_edit .plotregion1.bars[6].EditCustomStyle , j(-1) style(shadestyle(color(gray)))
 gr_edit .plotregion1.bars[6].EditCustomStyle , j(-1) style(linestyle(color(gray))) 



 * Figure II call back rates by race for treated companies pre/post in balanced sample

graph bar (mean) response if remover==1 & balanced==1  , over(nocrime_pre) over(post)    over(white)   blabel(total, format(%9.3f)  )  bar(1, color(black)) bar(2, color(white) lcolor(black) lwidth(medium)) ///
   ytitle(Callback Rate) scheme(s1mono) ylab(, nogrid)
 * change bar 1 to gray
 gr_edit .plotregion1.bars[3].EditCustomStyle , j(-1) style(shadestyle(color(gray)))
 gr_edit .plotregion1.bars[3].EditCustomStyle , j(-1) style(linestyle(color(gray)))
 * change bar 4 to gray
 gr_edit .plotregion1.bars[6].EditCustomStyle , j(-1) style(shadestyle(color(gray)))
 gr_edit .plotregion1.bars[6].EditCustomStyle , j(-1) style(linestyle(color(gray))) 


/************************************************************************************************************************************
 
 /**** Table IV:  Effects of the Box on Racial Discrimination: Differences-in-Differences ****/

************************************************************************************************************************************/



reg response box_white white crimbox ged empgap i.center if post==0 & remover~=-1, cl(chain_id)
reg response box_white white crimbox ged empgap if remover==1 & balanced==1, cl(chain_id)
reg response box_white white crimbox ged empgap i.center if remover==1, cl(chain_id)
reg response box_white white crimbox ged empgap i.center i.white_cogroup_njnyc i.post_cogroup_njnyc i.cogroup_njnyc if remover==1, cl(chain_id)
reg response pre_white white pre ged empgap if remover==0 & balanced==1 , cl(chain_id)


/************************************************************************************************************************************
 
 /********** Table V: Effects of Ban the Box on Racial Discrimination: Triple Differences **********/
 
************************************************************************************************************************************/


reg response post_remover_white post_white post_remover remover_white remover white post ged empgap if remover~=-1 & balanced==1, cl(chain_id) 
reg response post_remover_white post_white post_remover remover_white remover white post ged empgap i.center if remover~=-1, cl(chain_id) 
reg response post_remover_white post_white white post ged empgap i.center i.white_cogroup_njnyc i.post_cogroup_njnyc i.cogroup_njnyc if remover~=-1, cl(chain_id)

 
/************************************************************************************************************************************
 
 /********** Table VI: Effects of Ban the Box on Racial Discrimination: Robustness Checks, Balanced Sample **********/


************************************************************************************************************************************/
	 

* Panel A:
reg response box_white white crimbox ged empgap if remover==1 & balanced==1, cl(chain_id)
reg interview box_white white crimbox ged empgap if remover==1 & balanced==1, cl(chain_id)
reg response box_white white crimbox ged empgap if remover~=0 & balanced==1, cl(chain_id)
reg response box_white white crimbox ged empgap if remover==1 & balanced==1 & raerror~=1, cl(chain_id)
reg response box_white white crimbox ged empgap if remover==1 & balanced==1 & nj==1, cl(chain_id)
reg response box_white white pre ged empgap if remover==1 & balanced==1 & nj==0, cl(chain_id)
reg response pre_white white pre ged empgap if (remover==1|noncomplier_store==1) & balanced==1, cl(chain_id)


	

*Panel B

* Need to create itt vars:
gen itt=remover==1
replace itt=1 if noncomplier_store==1
replace itt=. if remover==-1
gen itt_white=itt*white
gen itt_post=itt*post
gen itt_post_white=itt*post*white
label var itt_post_white "PrePeriodBox x Post x White"





reg response post_remover_white post_white post_remover remover_white remover white post ged empgap if remover~=-1 & balanced==1, cl(chain_id) 
reg interview post_remover_white post_white post_remover remover_white remover white post ged empgap if remover~=-1 & balanced==1, cl(chain_id) 
reg response post_remover_white post_white post_remover remover_white remover white post ged empgap if balanced==1, cl(chain_id) 
reg response post_remover_white post_white post_remover remover_white remover white post ged empgap if remover~=-1 & balanced==1 & raerror~=1, cl(chain_id) 
reg response post_remover_white post_white post_remover remover_white remover white post ged empgap if remover~=-1 & balanced==1 & nj==1, cl(chain_id) 
reg response post_remover_white post_white post_remover remover_white remover white post ged empgap if remover~=-1 & balanced==1 & nj==0, cl(chain_id) 
reg response itt_post_white itt_white itt_post post_white itt white post ged empgap if remover~=-1 & balanced==1, cl(chain_id) 
reg response post_remover_white post_white post_remover remover_white remover white post ged empgap retail retail_post retail_post_white retail_white if remover~=-1 & balanced==1, cl(chain_id) 

		
/************************************************************************************************************************************
 
 /********** Table VII: Effects of Ban the Box on GED vs High School Diploma, Triple Differences**********/


************************************************************************************************************************************/
	 

reg response post_remover_ged post_ged  post_remover remover_ged remover ged post empgap white if remover~=-1 & balanced==1, cl(chain_id)
reg response post_remover_ged post_ged post_remover remover_ged remover ged post  ged white i.center if remover~=-1, cl(chain_id)
reg response post_remover_ged post_ged ged post empgap white i.center i.ged_cogroup_njnyc i.post_cogroup_njnyc i.cogroup_njnyc if remover~=-1, cl(chain_id)


/************************************************************************************************************************************
 ************************************************************************************************************************************
 
								APPENDIX TABLES 
							
 ************************************************************************************************************************************
************************************************************************************************************************************/

	
/************************************************************************************************************************************
 
 /**********ONLINE APPENDIX A3: COMPARING BOX and NO BOX STORES IN THE PRE-PERIOD (Appendix A3) **********/
 
************************************************************************************************************************************/

* Generate some new variables
bysort storeid pre: gen n_store=_n
bysort chain_id pre: gen n_chain=_n

gen lntot_crime_rate=ln(tot_crime_rate)
replace percwhite=percwhite*100
replace percblack=percblack*100
gen avg_salesvolume_1000=avg_salesvolume/1000
gen avg_num_employees_10=avg_num_employees/10
gen num_stores_10=num_stores/10

gen lnavg_salesvolume=ln(avg_salesvolume)
gen ln_avg_num_employees=ln(avg_num_employees)

label var avg_num_employees_10 "Avg Num Employees (10s)"
label var avg_salesvolume_1000 "Avg Sales Volume ($1000s)"

label var tot_crime_rate "Crime Rate"
label var retail "Retail"
label var avg_num_employees "Avg Num Employees"
label var avg_salesvolume "Avg Sales Volume"


 /*Table A3.1:  Characteristics of Stores With and Without the Box Before BTB */


summarize percwhite percblack tot_crime_rate avg_num_employees avg_salesvolume retail if pre==1 & n_store==1 & crimbox==1
summarize percwhite percblack tot_crime_rate avg_num_employees avg_salesvolume retail if pre==1 & n_store==1 & crimbox==0

/* Table A3.2:  Regression of Presence of Box (Before BTB) on Store Characteristics */

reg crimbox percwhite percblack tot_crime_rate avg_num_employees_10 avg_salesvolume_1000  retail if pre==1 & n_store==1

/************************************************************************************************************************************
 
 /********** Robustness Checks - Main Effects of Race and Crime (Appendix A4) **********/
 
************************************************************************************************************************************/

***ROBUSTNESS CHECKS for Main Effects Analysis  

/* Table A4.1:  Robustness Checks on Main Effect of White */
** Race

reg response white crime ged empgap pre i.center i.cogroup_comb if  remover!=-1, cl(chain_id)
reg interview white crime ged empgap pre i.center i.cogroup_comb if  remover!=-1, cl(chain_id)
reg response white crime ged empgap pre i.center i.chain_id if  remover!=-1, cl(chain_id)
reg response white crime ged empgap pre i.center i.cogroup_comb if nj==1 & remover!=-1, cl(chain_id)
reg response white crime ged empgap pre i.center i.cogroup_comb if nj==0 & remover!=-1, cl(chain_id)


/*Table A4.2: Robustness Checks on Main Effect of Crime in the Box Sample Only*/

reg response white crime ged empgap i.center i.cogroup_comb  if  crimbox==1  & remover!=-1  , cl(chain_id)
reg interview white crime ged empgap i.center i.cogroup_comb  if  crimbox==1 & remover!=-1  , cl(chain_id)
reg response white crime ged empgap i.center i.chain_id  if  crimbox==1  & remover!=-1 , cl(chain_id)
reg response white crime ged empgap i.center i.cogroup_comb  if  crimbox==1 & nj==1 & remover!=-1  , cl(chain_id)
reg response white crime ged empgap i.center i.cogroup_comb  if  crimbox==1 & nj==0  & remover!=-1, cl(chain_id)



/************************************************************************************************************************************
              
 /********** Re-Run Analysis Separately for NJ and NY **********/
     Appendix A5 and A6
************************************************************************************************************************************/

local nj=1
foreach region in nj nyc {

 
	* Figure 1 call back rates by race in R1 for box and no box companies 
	graph bar (mean) response if  pre==1 & remover!=-1 & nj==`nj', over(nocrime_box) over(nocrimbox)    over(white)   blabel(total, format(%9.3f)  )  bar(1, color(black)) bar(2, color(white) lcolor(black) lwidth(medium)) ///
   ytitle(Callback Rate) scheme(s1mono) ylab(, nogrid)
	/* the below code will then change the appropriate bars to gray. */ 
	* change bar 1 to gray
	gr_edit .plotregion1.bars[3].EditCustomStyle , j(-1) style(shadestyle(color(gray)))
	gr_edit .plotregion1.bars[3].EditCustomStyle , j(-1) style(linestyle(color(gray)))
	* change bar 4 to gray
	gr_edit .plotregion1.bars[6].EditCustomStyle , j(-1) style(shadestyle(color(gray)))
	gr_edit .plotregion1.bars[6].EditCustomStyle , j(-1) style(linestyle(color(gray))) 


 * Figure 2 call back rates by race for treated companies pre/post, balanced sample only

	graph bar (mean) response if remover==1 & nj==`nj' & balanced==1  , over(nocrime_pre) over(post)    over(white)   blabel(total, format(%9.3f)  )  bar(1, color(black)) bar(2, color(white) lcolor(black) lwidth(medium)) ///
   ytitle(Callback Rate) scheme(s1mono) ylab(, nogrid)
	* change bar 1 to gray
	gr_edit .plotregion1.bars[3].EditCustomStyle , j(-1) style(shadestyle(color(gray)))
	gr_edit .plotregion1.bars[3].EditCustomStyle , j(-1) style(linestyle(color(gray)))
	* change bar 4 to gray
	gr_edit .plotregion1.bars[6].EditCustomStyle , j(-1) style(shadestyle(color(gray)))
	gr_edit .plotregion1.bars[6].EditCustomStyle , j(-1) style(linestyle(color(gray))) 
   
  
   /* Summary Stats */
    * I by round - responses broken out by characteristics

	summarize white crime ged empgap crimbox response  interview response_black response_white response_ged response_hsd response_empgap response_noempgap if pre==1  & remover!=-1 & nj==`nj'
	summarize white crime ged empgap crimbox response interview response_black  response_white  response_ged response_hsd response_empgap response_noempgap if pre==0   & remover!=-1  & nj==`nj'
	summarize white crime ged empgap crimbox response interview response_black  response_white  response_ged response_hsd response_empgap response_noempgap  if remover!=-1 & nj==`nj'
	
   *II: responses by race and crime status for pre==1

	summarize response  response_black response_white if crimbox==1  & crime==0 & pre==1  & remover!=-1 & nj==`nj'
	summarize response  response_black response_white if crimbox==1  & crime==1 & pre==1  & remover!=-1 & nj==`nj'
	summarize response  response_black response_white if crimbox==1  & propertycrime==1 & pre==1   & remover!=-1 & nj==`nj'
	summarize response  response_black response_white if crimbox==1  & drugcrime==1 & pre==1   & remover!=-1 & nj==`nj'
	summarize response  response_black response_white if crimbox==1  & pre==1   & remover!=-1 & nj==`nj'
  
  /* Table III - Main Effects */
 

	reg response white crime ged empgap pre i.center i.cogroup_comb if  remover!=-1 & nj==`nj' , cl(chain_id)
	reg response white crime ged empgap i.center i.cogroup_comb  if  crimbox==1   & remover!=-1 & nj==`nj' , cl(chain_id)
	reg response white  drugcrime propertycrime ged empgap i.center i.cogroup_comb  if crimbox==1  & remover!=-1 & nj==`nj'  , cl(chain_id)

  
     /* Table IV Double Differences */
	 

	reg response box_white white crimbox ged empgap i.center if post==0 & remover~=-1 & nj==`nj', cl(chain_id)
	reg response box_white white crimbox ged empgap if remover==1 & balanced==1 &  nj==`nj', cl(chain_id)
	reg response box_white white crimbox ged empgap i.center if remover==1 &  nj==`nj', cl(chain_id)
	reg response box_white white crimbox ged empgap i.center i.white_cogroup_njnyc i.post_cogroup_njnyc i.cogroup_njnyc if remover==1 & nj==`nj', cl(chain_id)
	reg response pre_white white pre ged empgap if remover==0 & balanced==1 &  nj==`nj' , cl(chain_id)

	
	
   /* Table V - Triple Differences */
   
	reg response post_remover_white post_white post_remover remover_white remover white post ged empgap if remover~=-1 & balanced==1 & nj==`nj', cl(chain_id) 
	reg response post_remover_white post_white post_remover remover_white remover white post ged empgap i.center if remover~=-1 & nj==`nj', cl(chain_id) 
	reg response post_remover_white post_white white post ged empgap i.center i.white_cogroup_njnyc i.post_cogroup_njnyc i.cogroup_njnyc if remover~=-1 & nj==`nj', cl(chain_id)
   
   local nj=0
 }
 	
 /************************************************************************************************************************************
              APPENDIX A7
 /********** Table A7.1: Effects of Ban the Box on Emp Gap vs No Emp Gap, Triple Differences**********/
 
************************************************************************************************************************************/


reg response post_remover_empgap post_empgap post_remover remover_empgap remover empgap post ged white if remover~=-1 & balanced==1, cl(chain_id)
reg response post_remover_empgap post_empgap post_remover remover_empgap remover empgap post  ged white i.center if remover~=-1, cl(chain_id)
reg response post_remover_empgap post_empgap empgap post ged white i.center i.empgap_cogroup_njnyc i.post_cogroup_njnyc i.cogroup_njnyc if remover~=-1, cl(chain_id)




	 



