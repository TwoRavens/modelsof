
global dir  "enter path name here/CSS_REStat_2016"


clear
set more off
local groups=100
local gsize=25
local totsubtract=10
local totalobs=`groups'*`totsubtract'
set obs `totalobs'

forvalues i=1/`groups' { 
gen g`i'=`gsize'
}
gen design=_n

forvalues l=1/`totsubtract' {
local e=`l'*`groups'
local b=`e'-`groups'+1
forvalues i=1/`groups' {
local j=`i'-1
local d=`groups'*`l'+`i'-`groups'
replace g1=`gsize'+`j'*`l' if design==`d'
replace g`i'=`gsize'-`l' if inrange(design,`d',`e') & `i'>1
}
}


egen obs=rowtotal(g*)

egen sd=rowsd(g*)
egen mean=rowmean(g*)
gen coef_var=sd/mean

gen keep=0
replace keep=1 if design==1
forvalues i=10(10)1500 {
replace keep=1 if `i'==design
}
drop if keep==0

save "$dir/groupsizes.dta", replace


***
* 1) Sim1 - simulate relationship between design and effective number of clusters
*    

forvalues type=1/5{ 
forvalues xtype=1/4{

local sims=1000
local design=101


set more off
postutil clear
postfile CSS_sim_type`type'_xtype`xtype' numclusters effclusters_CSS effclusters_CSS_BOUND design simnum  ///
 using $dir/CSS_sim_type`type'_xtype`xtype'.dta, replace 
  

forvalues d=1/`design' {
timer clear
timer on 1
qui {
use "$dir/groupsizes.dta" in `d', clear
keep g* design
reshape long g, j(group_id) i(design)
gen groupobs=g
expand groupobs

local N = _N
gen obsn=_n

*generate xg through xg100
gen xg=. 
gen eg=.
gen xi=.
gen ei=.
gen y=.
gen x=.
gen e=.
qui sum group_id
local maxg=r(max)


forvalues s=1/`sims' {

if `xtype'==1{
forvalues g=1/`maxg' {
scalar xg`g'=runiform()<=.5
replace xg=xg`g' if group_id==`g'
}
}
if `xtype'>=2{
forvalues g=1/`maxg' {
scalar xg`g'=rnormal(0,1)
replace xg=xg`g' if group_id==`g'
}
}

replace xi=rnormal(0,1)

if `xtype'==1{
replace x=sqrt(4)*xg
}
if `xtype'==2{
replace xg=xg*sqrt(2)
replace x=xg
}
if `xtype'==3{
replace x=xg+xi
}
if `xtype'==4{
replace xi=xi*sqrt(2)
replace x=xi
}

forvalues g=1/`maxg' {
scalar eg`g'=rnormal(0,1)
qui replace eg=eg`g' if group_id==`g'
}

if `type'==1 {
replace ei=rnormal(0,1)
}
*low degree of het
if `type'==2 {
forvalues i = 1/`N' {
scalar vX`i'=0.9*xi[`i']*xi[`i']
scalar e`i'=rnormal(0,vX`i')
qui replace ei=e`i' if obsn==`i' 
}
}
*high degree of het
if `type'==3 {
forvalues i = 1/`N' {
scalar vX`i'=9*xi[`i']*xi[`i']
scalar e`i'=rnormal(0,vX`i')
qui replace ei=e`i' if obsn==`i' 
}
}
*t distribution
if `type'==4 {
replace ei=rt(4)
}
*log normal
if `type'==5 {
replace ei=exp(rnormal(0,1))
}


replace e=ei+eg


replace y=1+x+e
qui reg y x, vce(cluster group_id)


effclusters_CSS, key_rhs(x) clustvar(group_id)
scalar effclusters_CSS_BOUND=r(effclusters_CSS_BOUND)
scalar effclusters_CSS=r(effclusters_CSS)

scalar design=`d'
scalar simnum=`s'

post CSS_sim_type`type'_xtype`xtype' (numclusters) (effclusters_CSS) (effclusters_CSS_BOUND) (design)  (simnum) 
}

}

display "design=`d'" 
timer off 1
timer list 1
}
postclose CSS_sim_type`type'_xtype`xtype'




set more off
postutil clear
postfile CSS_sim_testsize_type`type'_xtype`xtype' numclusters effclusters_CSS effclusters_CSS_BOUND design p_value simnum  ///
 using "$dir/CSS_sim_testsize_type`type'_xtype`xtype'.dta", replace 
  
forvalues d=1/`design' {
timer clear
timer on 1
qui {
use "$dir/groupsizes.dta" in `d', clear
keep g* design
reshape long g, j(group_id) i(design)
gen groupobs=g
expand groupobs


local N = _N
gen obsn=_n
gen xg=. 
gen eg=.
gen xi=.
gen ei=.
gen y=.
gen x=.
gen e=.
qui sum group_id
local maxg=r(max)

if `xtype'==1{
forvalues g=1/`maxg' {
scalar xg`g'=runiform()<=.5
replace xg=xg`g' if group_id==`g'
}
}
if `xtype'>=2{
forvalues g=1/`maxg' {
scalar xg`g'=rnormal(0,1)
replace xg=xg`g' if group_id==`g'
}
}

replace xi=rnormal(0,1)

if `xtype'==1{
replace x=sqrt(4)*xg
}
if `xtype'==2{
replace xg=xg*sqrt(2)
replace x=xg
}
if `xtype'==3{
replace x=xg+xi
}
if `xtype'==4{
replace xi=xi*sqrt(2)
replace x=xi
}


forvalues s=1/`sims' {

forvalues g=1/`maxg' {
scalar eg`g'=rnormal(0,1)
qui replace eg=eg`g' if group_id==`g'
}

if `type'==1 {
replace ei=rnormal(0,1)
}
*low degree of het
if `type'==2 {
forvalues i = 1/`N' {
scalar vX`i'=0.9*xi[`i']*xi[`i']
scalar e`i'=rnormal(0,vX`i')
qui replace ei=e`i' if obsn==`i' 
}
}
*high degree of het
if `type'==3 {
forvalues i = 1/`N' {
scalar vX`i'=9*xi[`i']*xi[`i']
scalar e`i'=rnormal(0,vX`i')
qui replace ei=e`i' if obsn==`i' 
}
}
*t distribution
if `type'==4 {
replace ei=rt(4)
}
*log normal
if `type'==5 {
replace ei=exp(rnormal(0,1))
}

replace e=ei+eg

replace y=1+x+e
qui reg y x, vce(cluster group_id)
test x=1
scalar p_value=r(p)


effclusters_CSS, key_rhs(x) clustvar(group_id)
scalar effclusters_CSS_BOUND=r(effclusters_CSS_BOUND)
scalar effclusters_CSS=r(effclusters_CSS)

scalar design=`d'
scalar simnum=`s'

post CSS_sim_testsize_type`type'_xtype`xtype' (numclusters) (effclusters_CSS) (effclusters_CSS_BOUND) (design) (p_value) (simnum) 
}

}
display "design=`d'" 
timer off 1
timer list 1
}


postclose CSS_sim_testsize_type`type'_xtype`xtype'

}
}




forvalues type=1/5{
forvalues xtype=1/4{
use $dir/CSS_sim_testsize_type`type'_xtype`xtype'.dta, clear
gen type=`type'
gen xtype=`xtype'
gen tsize=p_value<=0.05
collapse (mean) type xtype tsize (median) effclusters_CSS_BOUND_med=effclusters_CSS_BOUND , by(design)
tempfile f`type'`xtype'
save `f`type'`xtype'', replace
}
}
forvalues type=1/5{
forvalues xtype=1/4{
use `f`type'`xtype'', clear
if `type'==1 & `xtype'==1{
save $dir/CSS_sim_testsize.dta, replace
}
else {
append using $dir/CSS_sim_testsize.dta
save $dir/CSS_sim_testsize.dta, replace
}
}
}



forvalues type=1/5{
forvalues xtype=1/4{
use $dir/CSS_sim_type`type'_xtype`xtype'.dta, clear
gen type=`type'
gen xtype=`xtype'
collapse (mean) type xtype (median) effclusters_CSS_med=effclusters_CSS ///
 (min) effclusters_CSS_min=effclusters_CSS (max) effclusters_CSS_max=effclusters_CSS ///
 , by(design)
tempfile f`type'`xtype'
save `f`type'`xtype'', replace
}
}
forvalues type=1/5{
forvalues xtype=1/4{
use `f`type'`xtype'', clear
if `type'==1 & `xtype'==1{
save $dir/CSS_sim.dta, replace
}
else {
append using $dir/CSS_sim.dta
save $dir/CSS_sim.dta, replace
}
}
}




 

