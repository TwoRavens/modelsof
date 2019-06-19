*/* Stata implementation of GLS estimator of spatially-robust standard errors		*/
*/*                                                           				*/
*/* Jordan Rappaport                           							*/
*/* Federal Reserve Bank of Kansas City 							*/
*/*                                                           				*/
*/* Spatial estimator based on:									*/
*/*														*/
*/*	1. Conley, Timothy G. (1999). "GMM Estimation with Cross Sectional Dependence."	*/
*/*	   Journal of Econometrics, 92, 1 (September), pp. 1-45	              		*/
*/*														*/
*/*	2. Rappaport, Jordan (2007). "Moving to Nice Weather." Regional Science and */
*/*     Urban Economics 37, 3 (May), pp. 375-398										*/
*/*														*/
*/*	Kernel code (gls_sp.ado) derived from code written by 				*/
*/*	Jean-Pierre Dube, Northwestern University, October 11, 1997				*/
*
*
*/* format for usage:													*/
*/* gls_sptl dep_var indep_variables_to_report : indep_variables_not_reported...			*/
*/* ..., obsweight(weighting_variable) sptlcoef(power at which correlation falls off - see below)... 
*/* ..., crdlst(lattitude_variable longitude_variable) cut(distance in km) [optional if/in condition (currently not working)]	      */ 
*
*
*/* Revision History                                                                                                                */
*/* Version 1.0: quadratic weighting only, 150,000 meter default cutoff (11/20/98)	                                                */
*/* Version 1.1: can handle no controls (01/01/99)						                                                                      */
*/* Version 1.2 uses latitude and longitude for distance calculation (6/9/00)		                                                    */
*/* Version 1.3: renamed to "rg_ols" with internal routine "x_ols"                                                                  */
*/*              loops only over non-missing observations to save time  			                                                      */
*/* Version 1.31: fixed missing "hascons" when no control variables included                                                        */
*/*               I think hascons may not be correct for some other branches (01/05/2004)                                           */
*/* Version 1.32: included citation info (03/08/2004)                                                                               */
*/* Version 1.4:  1. This allows for weighting of observations  ("analytical weighting" in stata speak)                             */
*/*                  Results are identical to unweighted if weighting variable is a constant or excluded                            */
*/*               2. Also uses double precision for some of variables  (09/04/2005)                                                 */
*/* Version 1.5:  I changed weighting in accumulation to multiply by square root of weighting rather than actual.                   */
*/*               This is consistent with Stata weighting being equivalent to premultiplying by sqrt(weight)  (1/9/2005)            */
*/* Version 1.51: previous x_ols has pos 2nd derivative; this has negative 2nd derivative (5/8/2006)                                */
*/* Version 1.52: fixed a mistaken label on distance weighting to be consistentent with 1.51                                        */
*/*                                                                                                                                 */
*/* Version 2.0:  generalized distance decline function: use an input coeffiecient to determine convexity  (11/30/2010)             */
*                 assumes all regressions should include a constant which is reported with robust standard error
*

****************************************************************************************************
*!!   CRITICAL PROGRAMMING NOTE: I think local macros in version 5 can be at most 8 characters!!   *
****************************************************************************************************

*  does NOT work for hascons.
*  no if/in functionality

*try rolling intercept into mainlist, if that doesn't work, just make it part of control list
*or just role intercept into control variables.


capture program drop gls_sptl
program define gls_sptl, sortpreserve /*arguments are: LHS variable, all RHS variables*/
version 5.0   /*stata compatability*/

local method "weighted GLS w spatially correlated errors" /* For display purposes only */
local frstcf "6"    /* Row on which first coefficient is printed */ 
local adjust "11"   /* The number of additional rows in output matrix:  i.e. for headings and summary statistics */ 

local input "`*'"  
di "`input'"
di "`*'"                                                                               

/* dec 2010: I can't get it to accept if and in conditions */
*local if "opt"
*local in "opt"
*local in "optional"  /* !! not working correctly */  
*local if "optional"  /* !! not working correctly */
*di "if:                 `if'"
*di "in:                 `in'"

parse "`*'", parse(" :,")   /* this is a legacy command not used since version 5; it creates local macro varlist with all variable names passed in  */

* local if "optional"
* local in "optional"
local depvar "`1'"
mac shift

local mainlst ""
local j = 1
while ("`1'"!=":" & "`1'"!="," & "`1'"!="") {
	local mainlst "`mainlst' `1'"
	mac shift}  /*putting dep variable and all rhs variables (for which we want coefficients reported) into local macro `mainlst' */
if ("`1'" == ":") { mac shift } 
local rmndr "`*'"  /* local macro rmndr is everything to right of ":" if there is a colon OR ELSE any conditioning and options following a "," OR ELSE empty */
local varlist "required existing"   /*I think this is the original set of variables (dependent, rhs before and after a ":") */
parse "`mainlst'"		/* check that all to the left of a colon/comma,end of variable name exist" */
local mainlst "`varlist'"     /*I think this is putting back in `mainlst' the results of the parse on it*/
local varlist "optional existing none"
local options "sptlcoef(real 1) cut(real 200)  crdlst(string)  obsweight(string) iff(string)"  /*    nocons and hascons not allowed; possible future upgrade */
/* when "nocons" specified, "`cons'"="nocons"; otherwise "`cons'" = ""*/
/* when "hascons" specified, "`hascons'"="hascons"; otherwise "`hascons'"="" */  
/* stata built in weighting ("aweight fweight pweight iweight")not compatible with hardwired weighting function. */
parse "`rmndr'"  /* want to distingush the actual control variables (i.e. to right of colon and so not reported)from any ending options or if condition) */
local cntrlst "`varlist'"   /* `varlist' created by the parse command; list variables on right hand side of preliminary regressions*/

local nmain : word count `mainlst' 
local ncntrl : word count `cntrlst'

di ""
di "dependent var:  (1) `depvar'"
di "mainlst:        (`nmain') `mainlst'"
di "cntrlst:        (`ncntrl') `cntrlst'"
di "weight:             `obsweight'"
di "coords:             `crdlst'"
di "sptlcoef:           `sptlcoef'" 
di "cut dist:           `cut'" 
di "iff:                `iff' "
* di "in:                 `in' (may not be functional)"
di ""


** CREATE CONSTANT VARIABLE
capture drop intrcpt
generate     intrcpt = 1

** GET NAMES OF COORDINATE VARIABLES
if ("`crdlst'" == ""){local crdlst "GEO_LAT GEO_LNG"}

** IF NO WEIGHT SPECIFIED, WEIGHT EACH OBS BY 1
    /* note that character length of macros limited: took me 1 hour debugging to figure out */ 
if ("`obsweight'" == ""){
     capture drop     _wght
     generate double  _wght = 1
     local oweight   "_wght"}
else{local oweight   "`obsweight'"}


*** DEALING WITH MISSING OBSERVATIONS;
tempvar touse
quietly{
mark `touse' `iff'     /* `if' and `in' non-functional; `iff' must explicitly include "if" or "in" */
* sum `touse'
markout `touse' `mainlst' `cntrlst' `oweight' `crdlst' 
* sum `touse'
gsort -`touse'
}



*** CALCULATE WEIGHT
tempvar sum min max norm number
quietly egen            `sum'    = sum(`oweight')             if `touse'
quietly egen            `min'    = min(`oweight')             if `touse'
quietly egen            `max'    = max(`oweight')             if `touse'
quietly egen            `number' = count(`oweight')           if `touse'
quietly generate double `norm'   = `number' * `oweight'/`sum' if `touse'  /* premultiply by `number' so that aggregate weight is unchanged from non-weighted version */
local   ratio                    = `max'[1]/`min'[1]

*di "cntrlst: `cntrlst'"
/** PRELIMINARY REGRESSIONS: for "control" variables listed after colon, regress LHS variable and all "main" RHS variables of of the control **/
if("`cntrlst'" ~= ""){
      local stage1 "yes"
      local args_wc = `nmain'}      
else {
      local stage1 "no"
      local args_wc = `nmain' + 1}

/* 1ST STAGE REGRESSIONS: regressing all of `main list variables' off of all of cntrl variables; purpose is to cut execution time  */

if ("`stage1'"=="yes"){ /*regress dependent variable "off" of control variables: */
     local curvar "`depvar'"
     tempvar resid0
     quietly{
     di "regress `curvar' `cntrlst' if `touse' [aweight=`norm']"
         regress `curvar' `cntrlst' if `touse' [aweight=`norm']   /*why nocons? */ 
     di "predict `resid0'     if `touse',residuals"
         predict `resid0'     if `touse',residuals   /* residuals stored in `resid_depvar' */ }
    
  /* now regress `mainlst' variables off of control variables */
  local resid_main ""   /* string macro to accumulate the temp names of variables */
  local j = 1        
  while `j' <= (`nmain') { 
     local curvar : word `j' of `mainlst'
	   tempvar resid`j'
	   local topass "`topass' `resid`j''"
     quietly{
     regress `curvar' `cntrlst' if `touse' [aweight=`norm']   /*why nocons?*/ 
     predict `resid`j''         if `touse',residuals}
     local j = `j' + 1 } }

*  /* now regress intrcpt off of control variables */
*  local j = `nmain' + 1
*  tempvar resid`j'
*  di "residj: `resid`j''"
*  local topass "`topass' `resid`j''"   /*this is variable list */
*  di "topass: `topass'"
*  regress intrcpt `cntrlst' if `touse' [aweight=`norm'], nocons   /*nocons because intrcpt variable remains in main regression; with aweight, either `oweight' variable or rescaled `norm' are fine */ 
*  predict `resid`j''         if `touse',residuals
*  sum `resid`j''
  
  di "first-stage regressions off of passive control variables complete"
  di ""
}
else if ("`stage1'"=="no"){
  di "no preliminary regressions"
  di ""}

***** 1 column regression ********

if ("`stage1'"=="yes"){ /* i.e. two stages */
*di      "gls_sp `resid0' `topass' (`crdlst'), sptlcoef(`sptlcoef') cut(`cut') iff(`iff') nweight(`norm') nocons"         
quietly gls_sp `resid0' `topass' (`crdlst'), sptlcoef(`sptlcoef') cut(`cut') iff(`iff') nweight(`norm') nocons 
*         gls_sp `resid0' `topass' (`crdlst'), sptlcoef(`sptlcoef') cut(`cut') iff(`iff') nweight(`norm') nocons                  
}
else{
*di      "gls_sp `depvar' `mainlst' intrcpt (`crdlst') , sptlcoef(`sptlcoef') cut(`cut') iff(`iff') nweight(`norm') nocons"   
quietly gls_sp `depvar' `mainlst' intrcpt (`crdlst') , sptlcoef(`sptlcoef') cut(`cut') iff(`iff') nweight(`norm') nocons   
*       gls_sp `depvar' `mainlst' intrcpt (`crdlst') , sptlcoef(`sptlcoef') cut(`cut') iff(`iff') nweight(`norm') nocons
}
di ""
di "spatially-robust regression complete"
di ""

/* SETUP OUTPUT MATRIX TO HOLD RESULTS OF SPATIALLY ROBUST REGRESSION */



**Construct rownames for output matrix
local rname "________  sptlcoef cut(km) w_ratio ________ "  /* 5 rows above args and args_wc*/
local j = 1           
   while `j' <= (`nmain'){  /* mainlst does not include depvar or constant*/
   local curvar : word `j' of `mainlst'
   local rname "`rname' `curvar':_b `curvar':se "
   local j = `j' + 1 
}
if("`stage1'"=="no"){/* additional entry for constant */
  local rname "`rname' _cons:_b _cons:se ________ N R_Sqrd AdjRSqrd e_e IndVar" /*6 rows above `nmain'; 4 rows above `args_wc' */};
else{
  local rname "`rname' ________ N R_Sqrd AdjRSqrd e_e IndVar" /* 4 rows above both `nmain' and `args_wc' */}
 
  
*** Setup output matrix
local rows = 2 * `args_wc' + `adjust'

tempname outpt
matrix define  `outpt' = J(`rows',1,0)
matrix colname `outpt' = `depvar' 
matrix rowname `outpt' = `rname' 
                            
matrix `outpt'[2,1] = `sptlcoef'  /* coefficient governing decline of pair distance */
matrix `outpt'[3,1] = `cut'       /* distance beyond which zero spatial correlation */
matrix `outpt'[4,1] = `ratio'     /* ratio of highest weighting to lowest weighting */ 

** placing results in a column format **
local r1 = `frstcf'
local r2 = `r1' + 1

*di "marker 1"
*
** Rows for all variables in main variable list plus constant
*local j = 1
*di "marker 2"

* Rows for all variables in main variable list plus constant
local j = 1
*di "r1 `r1'" 
*di "r2 `r2'"
*di "args_wc `args_wc'"

while `j' <= (`args_wc'){
  matrix `outpt'[`r1',1] = ${beta`j'}
  matrix `outpt'[`r2',1] = ${se2`j'}
  local r1 = `r1' + 2
  local r2 = `r2' + 2
  local j  =  `j' + 1
}


while `j' <= (`args_wc'){
  * di "marker j`j'"
  matrix `outpt'[`r1',1] = ${beta`j'}
  matrix `outpt'[`r2',1] = ${se2`j'}
  local r1 = `r1' + 2
  local r2 = `r2' + 2
  local j  =  `j' + 1
}


* Number of Observations and Adjusted R-squared (results are from straight OLS)
local r1 = `r1' + 1  /* N (adjust row to take account of offset row ) */
local r2 = `r1' + 1  /* R^2  */
local r3 = `r2' + 1  /* Adj R^2 */
local r4 = `r3' + 1  /* e'e  */
local r5 = `r4' + 1  /* # independent variables  */

* di "OLS regression for R-squared and other statistics"

quietly{regress `depvar' `mainlst' `cntrlst' [aweight=`oweight'] if `touse' /* drop explicit use of constant as a check that we handled constant correctly */}

matrix `outpt'[`r1',1] = _result(1)
matrix `outpt'[`r2',1] = _result(7)
matrix `outpt'[`r3',1] = _result(8)
matrix `outpt'[`r4',1] = _result(4)
matrix `outpt'[`r5',1] = _result(3)


** Display Output
di ""
di "method: `method' "  /* comment out this line if you do not want method displayed */
di "spatial weight: (1 - (dist/`cut')^-`sptlcoef')^-1"
di "condition:  `iff'"

matrix list `outpt', noheader format(%9.0g)

*capture mat drop regout  /* if you want to carry the results...     */
*mat regout=`outpt'       /* over to another program, erase the "*"  */
                          /* at the beginning of these two lines     */

capture drop intrcpt
capture drop _wght

end 

/************************************************************************/
/* gls_sp.ado								*/
/* weighted GLS ESTIMATION FOR X-SECTIONAL DATA WITH LOCATION-BASED DEPENDENCE	*/
/*				                                */
/* weighted version by Jordan Rappaport   */
/*	non-weighted version by	Jean-Pierre Dube		*/
/*					Northwestern University		*/
/*					October 11, 1997		*/
/*									*/
/*			reference:					*/
/*									*/
/*	Conley, Timothy G.[1996].  "Econometric Modelling of Cross	*/
/*	Sectional Dependence." Northwestern University Working Paper.	*/
/*									*/
/************************************************************************/

/************************************************************************/
/* modified version: works with latitude and longitude in decimal degrees */
/* cut(distance in km) crdlst(GEO_LAT GEO_LNG)  Hascons NOConstant*/
/*To invoke this command type:						*/
/*   >>gls_sp depvar regressorlist, nweight(weighting_variable) crdlst(lattitude_variable longitude_variable) cut(distance in km)[if in Hascons NOConstant] 	*/
/*									*/
/*	(1)If you want a constant in the regression, specify one of the	*/
/*	input variables as a 1. (ie. include it in list of regressors).	*/
/*									*/
/*	(2) You MUST specify the xreg() and coord() options.		*/
/*									*/
/*	(3)	xreg() denotes # regressors				*/
/*		coord()	denotes dimension of coordinates		*/
/*									*/
/*	(4) Your cutofflist must correspond to coordlist (same order)	*/
/*									*/
/*									*/
/*OUTPUT: all the standard `reg' procedure matrices will be in memory.	*/
/*	There will also be a matrix cov_dep, the corrected variance-	*/
/*	covariance matrix.						*/
/************************************************************************/

capture program drop gls_sp  
program define gls_sp, sortpreserve
version 5.0

*right now no if functionality 

#delimit ;				


local input "`*'";
local varlist "required existing";
local in "optional";
local if "optional";
*local options "Cut(real -1)  crdlst(string)  nweight(string) iff(string) Hascons noCons";
local options "sptlcoef(real 2) Cut(real -1)  crdlst(string)  iff(string) nweight(string) Hascons noCons";
local weight "aweight fweight pweight iweight";

parse "`*'";   /* High Level Parse  */
parse "`*'", parse(" )([,");

** GET NUMBER OF ARGUMENTS;
local j = 1;
while (("``j''" ~= "") & ("``j''" ~= "(" ) & ("``j''" ~= "[" ) & ("``j''" ~= ",")) {local j =`j'+1};
local args = `j'-2;     /* j=1 is LHS variable; the last j is the increment that caused loop exit */

tempvar Y;

quietly{generate double `Y'=`1'};			/*get dep variable*/
local depend : word 1 of `varlist';

** SHOULD CONSTANT BE ADDED;
if (("`cons'" == "")&("`hascons'" == "")){;
	local intcpt "true";
	local args_wc = `args'+1;
	tempvar _c;
	generate double `_c'=1; /* to be used as constant */
	};
else{;
	local args_wc = `args';
	};

local xreg =`args_wc';

/* this is where constant is assigned as a column of ones */
if "`intcpt'" == "true" {;
	tempvar X1;
	/* local ind1 "Intercpt";  not actually used in code */
	*di "`ind1'";
	generate double `X1'= 1;
	local b=2;
	};
else {;
	local b=1;
	};

local a=2;

/*quietly*/{;
  while `b'<=`args_wc'{;
	  tempvar X`b';
	  local ind`b' : word `a' of `varlist';
	  generate double `X`b''= ``a'';
	  local a=`a'+1;
	  local b=`b'+1;
	};			/*get indep var(s)...rest of list*/ 
};

local j = `j'+1;
local k = `j';
while (("``j''" ~= "") & ("``j''" ~= ")" ) & ("``j''" ~= "[" ) & ("``j''" ~= ",")) {local j =`j'+1};
local coord = `j'-`k';     /* the last j is the increment that caused loop exit */
if `coord'~=2{;
	di in red "exactly two coordinate variables must be specified";
	exit 198};
tempvar lat long;
local k=`j'-2;
quietly{generate double `lat'=``k''};
local k=`j'-1;
quietly{generate double `long'=``k''};
** CHECK THAT CUTOFFS ARE SPECIFIED ;
if `cut'<1{;
	if `cut'==-1{;
		di in red "option cut() required!!!";
		exit 198};
	di in red "cut(`cut') is invalid";
	exit 198};	
 
 
** DEALING WITH MISSING OBSERVATIONS;
tempvar to_use;
quietly{mark `to_use' `iff' [`weight']};
quietly{markout `to_use' `varlist' `lat' `long' `nweight'};
gsort -`to_use';


/*NOW I RUN THE REGRESSION AND COMPUTE THE COV MATRIX*/

quietly{;			/*so that steps are not printed on screen*/
	/*(1) RUN REGRESSION*/
	/*W connotes an N-by-N matrix with elements of `nweight' along its diagonal*/
	tempname XWX XWX_N invXWX invN;  
	if `xreg'==1 {;
		di "`varlist'";
		reg `Y' `X1' [aweight=`nweight'] if `to_use' , robust  noconstant};  /* this is calculating white standard error for comparison */
	else{;
		reg `Y' `X1'-`X`xreg'' [aweight=`nweight'] if `to_use' ,robust  noconstant};
	tempvar epsilon wepsilon;
	predict `epsilon' if `to_use',residuals;	/* unweighted OLS residuals */
	****generate double `wepsilon' = sqrt(`nweight') * `epsilon' ; /* weighted OLS residuals */
	local _n = _result(1);
	scalar `invN'=1/`_n';     /* note weights are normalized so that they sum to _n */
	if `xreg'==1 {;
		mat accum `XWX'=`X1' [aweight=`nweight'] if `to_use',noconstant};
	else{;
		mat accum `XWX'=`X1'-`X`xreg'' [aweight=`nweight'] if `to_use',noconstant};
	mat `XWX_N'=`XWX'*`invN';    /* creates X'WX/N   */
	mat `invXWX'=inv(`XWX_N');	/* creates (X'WX/N)^(-1)*/

	/*(2) COMPUTE CORRECTED COVARIANCE MATRIX*/
	tempname XUWWUX XUWWUX1 XUWWUX2 XUWWUXt;
	tempvar XUWUk;
	tempvar window;
	tempvar dist;
	tempvar dis1;
	tempvar dis2;
	mat `XUWWUX'=J(`xreg',`xreg',0);
	generate double `XUWUk'=0;
	generate double `window'=1;			/*initializes mat.s/var.s to be used*/
	generate double `dist'=0;
	generate double `dis1' =0;
	generate double `dis2' =0;
	** convert coordinates to radians;
	replace `long' = `long'*(_pi/180);
	replace `lat' = `lat'*(_pi/180);


	local i=1;
	while `to_use'[`i']==1{			/*loop through non-missing observations*/
		replace `window'=0;
		replace `dist' = acos((sin(`lat')*sin(`lat'[`i'])+
			cos(`lat')*cos(`lat'[`i'])*cos(`long'[`i']-`long')))*6378.137;
		
		**vvvvvv for testing purposes vvvvvv;
		*these come within 2% of standard errors calculated by stata built-in routines ;
		*I believe the difference may be due to accumulated rounding errors ;
		*replace `window'=1 if ID_FIPST[`i']==ID_FIPST; /* analogous to cluster(ID_FIPST) */ 
		*replace `window'= 1 if (`dist'<0.00014);       /* analogous to "robust" */
		**^^^^^^ for testing purposes ^^^^^^;
		
		**vvvvvv quadratic declining geogaphic distance weighting vvvvvv;
		/*replace `window'=(1-`dist'/`cut')^2 if (`dist'<`cut'); */
	  /* vvvvvv declining geogaphic distance weighting with user set convexity vvvv */
		replace `window'=1-(`dist'/`cut')^`sptlcoef' if (`dist'<`cut');   
		/* first deriv = (-sptlcoef/(cut^sptlcoef))*dist^(sptlcoef -1)                */
		/* secnd deriv = -(sptlcoef-1)(sptlcoef)/(cut^sptlcoef) * dist^(sptlcoef-2)   */
		/* so sptlcoef = 1 -> linear decline                                          */
		/* so sptlcoef > 1 -> neg second deriv, fall off increasin with distance      */
		/* so sptlcoef < 1 -> pos second deriv, fall off slowing with distance        */

		
		capture mat drop `XUWWUX2';  /* this is the k-by-k matrix into which error contributions from each observation will be accumulated */
		local k=1;
		while `k'<=`xreg'{;

      **!!  two equivalent ways to handle weighting  !!**
			** version 1 weighting ;
			***      note:  intuitively it seemed to me that would want to use sqrt(`nweight') rather than linear;
			***             but comparison to pre-multiplied optimal estimator shows the weighting that follows is correct;
			replace `XUWUk'=(`X`k''[`i'])*(`nweight'[`i'])*(`epsilon'[`i'])*`epsilon'*(`nweight')*`window'; /*creates N-by-1 vector */
			mat vecaccum `XUWWUX1'=`XUWUk' `X1'-`X`xreg'' if `to_use', noconstant; /* creates 1-by-k vector*/

			** version 2 weighting; 
			*replace `XUWUk'=(`X`k''[`i'])*sqrt(`nweight'[`i'])*(`epsilon'[`i'])*`epsilon'*`window'; /*creates N-by-1 vector */
			*mat vecaccum `XUWWUX1'=`XUWUk' `X1'-`X`xreg'' [aweight=(`nweight')] if `to_use', noconstant; /* creates 1-by-k vector*/
		
			mat `XUWWUX2'=`XUWWUX2' \ `XUWWUX1';  /*stacks latter below former to eventually get a k-by-k matrix */
		local k=`k'+1};
		mat `XUWWUXt'=`XUWWUX2'';  /* transpose */
		mat `XUWWUX1'=`XUWWUX2'+`XUWWUXt';  /* adding transpose to original: still k-by-k */
		scalar fix=.5;		/*to correct for double-counting*/
		mat `XUWWUX1'=`XUWWUX1'*fix;
		mat `XUWWUX'=`XUWWUX'+`XUWWUX1';  /*add current observation k-by-k into all observation k-by-k matrix */
	local i=`i'+1};			/*loop through all non-missing observations*/
	mat `XUWWUX'=`XUWWUX'*`invN'; 

};					/*end quietly command*/

tempname V VV;
mat `V'=`invXWX'*`XUWWUX';
mat `VV'=`V'*`invXWX';

matrix cov_dep=`VV'*`invN';		/*corrected covariance matrix*/


/*THIS PART CREATES AND PRINTS THE OUTPUT TABLE IN STATA*/
{;			/*so that steps are not printed on screen*/
local z=1;
local v=`a';
di _newline(2) _skip(5)
"Results for Weighted Cross Sectional GLS corrected for Spatial Dependence";
di _newline	_col(35)	" number of observations=  "  _result(1);
di " Dependent Variable= " "`depend'";
di _newline
"variable" _col(13) "ols estimates" _col(29) "White s.e." _col(42) 
	"s.e. corrected for spatial dependence";
di 
"--------" _col(13) "-------------" _col(29) "----------" _col(42) 
	"-------------------------------------";

/* here's where actual assignment of coefficients and standard errors occurs: need to get it for constant */
while `z'<=`xreg'{;
	global beta`z'=_b[`X`z''];
	local se`z'=_se[`X`z''];
	local  se1`z'=cov_dep[`z',`z'];
	global  se2`z'=sqrt(`se1`z'');
	di "`ind`z''" _col(13)  ${beta`z'}  _col(29)  `se`z'' _col(42) ${se2`z'};
local z=`z'+1};
};					/*end quietly command*/


end;
exit;


