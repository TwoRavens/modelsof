*****************************************************
*READ WAIVER FOR HOW TO GET ACCESS TO THE DATA*******
*****************************************************

use "noncitizenvoting.dta", clear

*TABLE 1
rdrobust age days
rdrobust male days
rdrobust unmarried days
rdrobust europe days
rdrobust easteur days
rdrobust africa days
rdrobust asia days
rdrobust prvote days

*TABLE 2
rdrobust vote days, h(183)
rdrobust vote days 
rdrobust vote days, bwselect(cerrd)

*TABLE 3
scalar cutoff = 6.5
rdrobust vote days if eiu_dpc < cutoff
rdrobust vote days if eiu_dpc < cutoff, p(2)
rdrobust vote days if eiu_dpc < cutoff, bwselect( cerrd ) 
rdrobust vote days if eiu_dpc >= cutoff
rdrobust vote days if eiu_dpc >= cutoff, p(2)
rdrobust vote days if eiu_dpc >= cutoff, bwselect( cerrd ) 
rdrobust vote days if dem_wholelife==0
rdrobust vote days if dem_wholelife==0, p(2)
rdrobust vote days if dem_wholelife==0, bwselect(cerrd)
rdrobust vote days if dem_wholelife==1
rdrobust vote days if dem_wholelife==1, p(2)
rdrobust vote days if dem_wholelife==1, bwselect(cerrd)

*TABLE 4
use "union.dta"
scalar cutoff = 6.5
rdrobust inedu days if eiu_dpc < cutoff 
rdrobust ijobb1g days if eiu_dpc < cutoff 
rdrobust inedu days if eiu_dpc >= cutoff
rdrobust ijobb1g days if eiu_dpc >= cutoff 
rdrobust inedu days if dem_wholelife==0
rdrobust ijobb1g days if dem_wholelife==0
rdrobust inedu days if dem_wholelife==0
rdrobust ijobb1g days if dem_wholelife==1

*TABLE 5
use "survey.dta"
reg polint treat i.AlderKat year2 ed1 ed2 ed3 yearsincountry male, robust 
reg contact treat i.AlderKat year2 ed1 ed2 ed3 yearsincountry male, robust 
reg influence treat i.AlderKat year2 ed1 ed2 ed3 yearsincountry male, robust 
reg trust_national treat i.AlderKat year2 ed1 ed2 ed3 yearsincountry male, robust 
reg civic_count treat i.AlderKat year2 ed1 ed2 ed3 yearsincountry male, robust 

*TABLE A2
use "noncitizenvoting.dta", clear
rdrobust age days, h(63)
rdrobust male days, h(63)
rdrobust unmarried days, h(63)
rdrobust europe days, h(63)
rdrobust easteur days, h(63)
rdrobust africa days, h(63)
rdrobust asia days, h(63)
rdrobust prvote days, h(63)

*TABLE A5
scalar cutoff = 6.5
rdrobust male days if eiu_dpc < cutoff
rdrobust age days if eiu_dpc < cutoff
rdrobust unmarried days if eiu_dpc < cutoff
rdrobust male days if dem_wholelife==0
rdrobust age days if dem_wholelife==0
rdrobust unmarried days if dem_wholelife==0

*TABLE A6
rdrobust vote days if eiu_dpc < cutoff, covs(age male unmarried)
rdrobust vote days if eiu_dpc < cutoff, p(2) covs(age male unmarried)
rdrobust vote days if eiu_dpc < cutoff, bwselect( cerrd ) covs(age male unmarried)
rdrobust vote days if dem_wholelife==0, covs(age male unmarried)
rdrobust vote days if dem_wholelife==0, p(2) covs(age male unmarried)
rdrobust vote days if dem_wholelife==0, bwselect( cerrd ) covs(age male unmarried)

*TABLE A7
rdrobust vote days if eiu_dpc < cutoff & age<38
rdrobust vote days if eiu_dpc < cutoff & age<38
rdrobust vote days if dem_wholelife==0 & age<38
rdrobust vote days if dem_wholelife==1 & age<38

*TABLE A8
rdrobust vote days if eiu_dpc < cutoff & days>=0, c(195)
rdrobust vote days if eiu_dpc < cutoff & days<0, c(-176)
rdrobust vote days if dem_wholelife==0 & days>=0, c(195)
rdrobust vote days if dem_wholelife==0 & days<0, c(-176)
use "nordic_placebo.dta"
rdrobust vote days  

*TABLE A9
use "union.dta"
scalar cutoff = 6.5
rdrobust fagf2010 days if eiu_dpc < cutoff 
rdrobust sosd_2010 days if (eiu_dpc < cutoff 
rdrobust fagf2010 days if eiu_dpc >= cutoff
rdrobust sosd_2010 days if eiu_dpc >= cutoff 
rdrobust fagf2010 days if dem_wholelife==0
rdrobust sosd_2010 days if dem_wholelife==0
rdrobust fagf2010 days if dem_wholelife==0
rdrobust sosd_2010 days if dem_wholelife==1

*TABLE A10
use "survey.dta"
reg polint treat i.AlderKat year2 ed1 ed2 ed3  male if imyr==2008, robust   
reg contact treat i.AlderKat year2 ed1 ed2 ed3  male if imyr==2008, robust   
reg influence treat i.AlderKat year2 ed1 ed2 ed3  male if imyr==2008, robust 
reg trust_national treat i.AlderKat year2 ed1 ed2 ed3  male if imyr==2008, robust 
reg civic_count treat i.AlderKat year2 ed1 ed2 ed3  male if imyr==2008, robust 
  

*TABLE A11
use "noncitizenvoting.dta", clear
rdrobust vote days if demstock<21.6 & demstock!=.
rdrobust vote days if demstock<21.6 & demstock!=.,p(2)
rdrobust vote days if demstock<21.6 & demstock!=., bwselect(cerrd)
rdrobust vote days if demstock>21.6 & demstock!=.
rdrobust vote days if demstock>21.6 & demstock!=.,p(2)
rdrobust vote days if demstock>21.6 & demstock!=., bwselect(cerrd)

*TABLE A12
scalar yearcutoff = 30
rdrobust vote days if democracy==0 
rdrobust vote days if democracy==0, p(2)
rdrobust vote days if democracy==0, bwselect(cerrd)
rdrobust vote days if (democracy != (yearcutoff + 1) 
rdrobust vote days if (democracy != (yearcutoff + 1), p(2)
rdrobust vote days if (democracy != (yearcutoff + 1), bwselect(cerrd)
rdrobust vote days if (democracy == (yearcutoff + 1) 
rdrobust vote days if (democracy == (yearcutoff + 1), p(2)
rdrobust vote days if (democracy == (yearcutoff + 1), bwselect(cerrd)

*TABLE A13
scalar cutoff = 6
rdrobust vote days if eiu_dpc < cutoff
rdrobust vote days if eiu_dpc < cutoff, p(2)
rdrobust vote days if eiu_dpc < cutoff, bwselect( cerrd ) 
rdrobust vote days if eiu_dpc >= cutoff
rdrobust vote days if eiu_dpc >= cutoff, p(2)
rdrobust vote days if eiu_dpc >= cutoff, bwselect( cerrd ) 

*TABLE A14
scalar cutoff = 7
rdrobust vote days if eiu_dpc < cutoff
rdrobust vote days if eiu_dpc < cutoff, p(2)
rdrobust vote days if eiu_dpc < cutoff, bwselect( cerrd ) 
rdrobust vote days if eiu_dpc >= cutoff
rdrobust vote days if eiu_dpc >= cutoff, p(2)
rdrobust vote days if eiu_dpc >= cutoff, bwselect( cerrd ) 

*TABLE A15
gen count = 1
sort origin_id
by origin_id: egen total_imm = sum(count)
keep if total_imm > 100
tabulate origincntry, generate(g)
foreach d of numlist 1/25{
rdrobust g`d' days, bwselect(cerrd)
		}	

*TABLE A16
rdrobust vote days, h(183)
rdrobust vote days 
rdrobust vote days, bwselect(cerrd)

*TABLE A17
use "survey.dta"
*treated 2007-2008
reg polint yearsincountry i.AlderKat year2 ed1 ed2 ed3  male if treat==1 & imyr >= 2007, robust 
reg contact yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2007, robust 
reg influence yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2007, robust 
reg trust_national yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2007, robust 
reg civic_count yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2007, robust 
*control 2008-2009
reg polint yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2009, robust 
reg contact yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2009, robust 
reg influence yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2009, robust 
reg trust_national yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2009, robust 
reg civic_count yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2009, robust 
*treated 2006-2008
replace treat = 0 if imyr==2010
replace treat = 1 if imyr==2006
reg polint yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2006, robust 
reg contact yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2006, robust   
reg influence yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2006, robust 
reg trust_national yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2006, robust 
reg civic_count yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2006, robust 
*control 2008-2010
reg polint  yearsincountryi.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2010, robust 
reg contact yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2010, robust   
reg influence yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2010, robust 
reg trust_national yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2010, robust 
reg civic_count yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2010, robust 
*treated 2005-2008
replace treat = 0 if imyr==2011
replace treat = 1 if imyr==2005
reg polint yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2005, robust 
reg contact yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2005, robust   
reg influence yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2005, robust 
reg trust_national yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2005, robust 
reg civic_count yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==1 & imyr >= 2005, robust 
*control 2008-2011
reg polint yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2011, robust  
reg contact yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2011, robust 
reg influence yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2011, robust 
reg trust_national yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2011, robust   
reg civic_count yearsincountry i.AlderKat year2 ed1 ed2 ed3 male if treat==0 & imyr <= 2011, robust 

*FIGURE 2
use "noncitizenvoting.dta", clear
rddensity days
hist days if days > -60 & days < 60, bin(121) freq xline(0)

*FIGURE 4
rdplot vote days if days>=-100 & days<=100 & (eiu_dpc < cutoff), p(1) kernel(tri) graph_options(title("Weak Democratic Culture") graphregion(color(white)) legend(off) 
rdplot vote days if days>=-110 & days<=110  & (eiu_dpc >=cutoff), p(1) kernel(tri) graph_options(title("Strong Democratic culture") graphregion(color(white))  legend(off) 
rdplot vote days if days>-99 & days<99 & (dem_wholelife==0), p(1) kernel(tri) nbins(80 80)   graph_options(title("Not Born in Democracy") graphregion(color(white)) legend(off) 
rdplot vote days if days>=-109 & days<=109 & (dem_wholelife==1), p(1) nbins(80 80) kernel(tri)  graph_options(title("Born in a Democracy") graphregion(color(white)) legend(off) 

*FIGURE A1
rdplot age days if days>-45 & days<45, p(1) kernel(tri) graph_options(title("Age") legend(off) saving(age, replace))
rdplot male days if days>-53 & days<53, p(1) kernel(tri) graph_options(title("Male") legend(off) saving(male, replace))
rdplot europe days if days>-35 & days<35, p(1) kernel(tri) graph_options(title("European country") legend(off) saving(europe, replace))
rdplot easteur days if days>-43 & days<43, p(1) kernel(tri) graph_options(title("East Eur. country") legend(off) saving(easteur, replace))
rdplot africa days if days>-39 & days<39, p(1) kernel(tri) graph_options(title("African country") legend(off) saving(african, replace))
rdplot asia days if days>-63 & days<63, p(1) kernel(tri) graph_options(title("Asian country") legend(off) saving(asian, replace))
rdplot prvote days if days>-45 & days<45, p(1) kernel(tri) graph_options(title("Expected turnout") legend(off) saving(prvote, replace))

*FIGURE A2
rdplot age days if days>-53 & days<53, p(2) kernel(tri) graph_options(title("Age") legend(off) saving(age2, replace))
rdplot male days if days>-78 & days<78, p(2) kernel(tri) graph_options(title("Male") legend(off) saving(male2, replace))
rdplot europe days if days>-66 & days<66, p(2) kernel(tri) graph_options(title("European country") legend(off) saving(europe2, replace))
rdplot easteur days if days>-66 & days<66, p(2) kernel(tri) graph_options(title("East Eur. country") legend(off) saving(easteur2, replace))
rdplot africa days if days>-67 & days<67, p(2) kernel(tri) graph_options(title("African country") legend(off) saving(african2, replace))
rdplot asia days if days>-52 & days<52, p(2)kernel(tri) graph_options(title("Asian country") legend(off) saving(asian2, replace))
rdplot prvote days if days>-55 & days<55, p(2) kernel(tri) graph_options(title("Expected turnout") legend(off) saving(prvote, replace))

