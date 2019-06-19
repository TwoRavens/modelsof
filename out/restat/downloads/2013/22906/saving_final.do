/* THIS TABLE CREATES THE DATA for TABLE A.2 in the APPENDIX, using the same input database as all the other programs
the very bottom portion of the table is created by summarizing the saving rate after conditioning on the sample
used in the baseline estimates */


drop _all
clear matrix
set more off


use ~/restat_rev/data/revdat_419_wmdebt_fin, clear

gen srate1 = rstoth/(faminc5yr/def5yr) if year <=1999
replace srate1 = rstoth/(famincr2yr) if year>1999

gen srate2 = rstot/(faminc5yr/def5yr) if year <=1999
replace srate2 = rstot/(famincr2yr) if year>1999

* also want to do with regular stock mkt saving

local vars "shouse sore sira scash sbond svehic sstk sstki sbusi sodebt"
 
foreach x of local vars {

gen sr1_`x' = `x'/(faminc5yr) if year <=1999
replace sr1_`x' = `x'/(famincr2yr*def2yr) if year >=2001

}


* calculate total saving using imputed stock market saving data and not

egen sr1_stot = rowtotal(sr1_shouse sr1_sore sr1_scash sr1_sbond sr1_svehic sr1_sstk sr1_sodebt sr1_sira  sr1_sbusi)
egen sr1a_stot = rowtotal(sr1_shouse sr1_sore sr1_scash sr1_sbond sr1_svehic sr1_sstki sr1_sodebt sr1_sira  sr1_sbusi)

replace srate1 = sr1a_stot



* THIS CODE CALCULATES THE SAVING RATES FOR THE TOP PART OF TABLE A.2 trimming the top and bottom 1% of the respective
* overall saving distribution 


#delimit ;
* this is dropping overall 1%...;

replace sr1_stot = sr1_stot*100;
replace srate1= srate1*100;

foreach x of numlist 1989 1994 1999 2001 2003 2005 2007 {; 


_pctile srate1 if year == `x', percentiles(1(98)99);

gen  minc`x' = r(r1);
gen  maxc`x' = r(r2);

_pctile srate2 if year == `x', percentiles(1(98)99);

gen  minc2`x' = r(r1);
gen  maxc2`x' = r(r2);

_pctile sr1_stot if year == `x', percentiles(1(98)99);

gen  minc11`x' = r(r1);
gen  maxc11`x' = r(r2);




estpost sum srate1, d quietly, 
		     if year == `x' & srate1 >minc`x' & srate1 <maxc`x'  ;
	eststo ss`x';

estpost sum sr1_stot, d quietly, 
		     if year == `x' & sr1_stot >minc11`x' & sr1_stot <maxc11`x'   ;
	eststo ss2`x';



};


estout ss21989 ss21994 ss21999 ss22001 ss22003 ss22005 ss22007
       using ~/restat_rev/saving.out, append cells(mean(fmt(1)) p50(fmt(1)) count(fmt(0))) style(tex)
       varlabels(sr1_stot "Saving rate ");



estout ss1989 ss1994 ss1999 ss2001 ss2003 ss2005 ss2007
       using ~/restat_rev/saving.out, replace cells(mean(fmt(1)) p50(fmt(1)) count(fmt(0))) style(tex)
       varlabels(srate1 "Saving rate- imputed stock");
		



#delimit cr

* SECOND PART OF TABLE
* Code that follows the trimming routine in Bosworth and Anders (2008) 


local vars "shouse sore sira scash sbond svehic sstk sstki sbusi sodebt"
 
foreach x of local vars {

*gen sr_`x' = r`x'/(faminc5yr/def5yr) if year <=1999
*replace sr_`x' = r`x'/famincr2yr if year >=2001

gen sr_`x' = `x'/(faminc5yr) if year <=1999
replace sr_`x' = `x'/(famincr2yr*def2yr) if year >=2001


* adjust the saving rates

gen adj_sr_`x' =.
foreach xx of numlist 1989 1994 1999 2001 2003 2005 2007 { 

* gen new variable and sort on it...
gen tmpsv = sr_`x' if year == `xx'
sort tmpsv
gen cs_`x'`xx' = _n if sr_`x'~=. & year ==`xx'
summ cs_`x'`xx'
local rmax = r(max)
gen rmax_10 = `rmax' -9
replace adj_sr_`x' = sr_`x' if year ==`xx'
replace adj_sr_`x' =. if (cs_`x'`xx' <=10 | cs_`x'`xx' >= rmax_10) & cs_`x'`xx' ~=.
drop rmax_10 tmpsv
}
}

egen adj_sr_stot = rowtotal(adj_sr_shouse adj_sr_sore adj_sr_scash adj_sr_sbond adj_sr_svehic adj_sr_sstk adj_sr_sodebt adj_sr_sira  adj_sr_sbusi)
egen adj_sr_stoti = rowtotal(adj_sr_shouse adj_sr_sore adj_sr_scash adj_sr_sbond adj_sr_svehic adj_sr_sstki adj_sr_sodebt adj_sr_sira  adj_sr_sbusi)

replace adj_sr_stot = adj_sr_stot*100
replace adj_sr_stoti = adj_sr_stoti*100


foreach x of numlist 1989 1994 1999 2001 2003 2005 2007 { 

	estpost sum adj_sr_stot adj_sr_stoti, d quietly,  if year == `x' 
	eststo sss`x'

}


#delimit ;
estout sss1989 sss1994 sss1999 sss2001 sss2003 sss2005 sss2007
       using ~/restat_rev/saving.out, append cells(mean(fmt(1)) p50(fmt(1)) count(fmt(0))) style(tex)
       varlabels(adj_sr_stot "total saving" adj_sr_stoti "total saving-- imputed sstk");




