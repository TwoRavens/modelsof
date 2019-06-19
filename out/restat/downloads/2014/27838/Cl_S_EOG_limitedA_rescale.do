* Cl_S_EOG_limitedA_rescale.do is the file that adds rescaled test scores
* to Cl_S_EOG_limitedA.dta. Since the scale of the reading score was changed
* in 2003 and the scale of math scores was changed in 2001 and 2006
* this file creates two sets of equivalent scores rescaling scores both before 
* and after change. If more recent scores are rescaled back to the older
* scale they are called old*scal. If older scores are rescaled to the newer
* scale they are called new*scal. Math scores from 2006 do not have 
* an equivalent scale so both old and new scale scores are left missing
* for 2006 math scores.


#delimit;
clear;
pause off;
set more off;
set mem 800m;
capture log close;


local infile S_EOG_limitedA;
local scalefile S_EOG_testrescale;
local outfile S_EOG_limitedA_rescale;


************************;
use Cl_`infile', clear;

sort grade readscal mastid;
merge grade readscal using `direc2'Co_`scalefile'_read.dta, _merge(mergeread);
* Assume readscal==0 is miscoded since it is not actually possible to score 0;
replace readscal=. if readscal==0;
replace newreadscal=readscal if year>=2003;
replace oldreadscal=readscal if year<2003;
tab mergeread;
tab grade readscal if mergeread==2;
drop if mergeread==2;
count if mergeread==1 & readscal!=.;
drop mergeread;

sort grade mathscal mastid;
merge grade mathscal using Co_`scalefile'_math.dta, _merge(mergemath);
* Assume mathscal==0 is miscoded since it is not actually possible to score 0;
replace mathscal=. if mathscal==0;
replace newmathscal=mathscal if year>=2001 & year<2006;
replace oldmathscal=mathscal if year<2001;
tab grade mathscal if mergemath==2;
drop if mergemath==2;
count if mergemath==1 & mathscal!=. & year!=2006;
drop mergemath;
sort year grade school mastid;
order mastid mathscal newmathscal oldmathscal readscal newreadscal oldreadscal grade year lea;

save Cl_`outfile', replace;
