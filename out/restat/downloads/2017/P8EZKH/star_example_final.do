***************************************************************
**This will test for rank similarity across treatment and 
**control observations for the LaLonde job training stuff.;
***************************************************************

# delimit;

program drop _all;
clear;
capture log close;
set mat 800;
set more off;
log using star_example_final.log,replace text;


use STAR_Students;

gen free_lunch=gkfreelunch==1 if gkfreelunch~=.;
  label variable free_lunch "Eligible for free lunch in kindergarten";
  
gen treat=gkclasstype==1 if gkclasstype~=.;
  label variable treat "Assigned to small class in kindergarten";

  
**Let's keep only those observations that have all of the data
**we need.;

keep if treat~=. & free_lunch~=. & g1tmathss~=.;
  
**Let's look at first grade math scores.;

sort treat g1tmathss;

sum free_lunch;

**Note there are 1368 treated observations and 3040 control observations;
by treat: gen rank=_n;
gen treat_pct=rank/1368 if treat==1;
  label variable treat_pct "rank in treated distribution";


**There are some ties that we should clump together.;
egen tmpvar=mean(treat_pct), by(g1tmathss);
replace treat_pct=tmpvar if treat==1;
drop tmpvar;
  
  
gen control_pct=rank/3040 if treat==0;
  label variable control_pct "rank in control distribution";

  
**Dealing with ties again.;
egen tmpvar=mean(control_pct), by(g1tmathss);
replace control_pct=tmpvar if treat==0;
drop tmpvar;
  
   
gen pct=treat_pct if treat==1;
replace pct=control_pct if treat==0;

**Formal tests.;

ranktest g1tmathss treat treat free_lunch;


**Now let's look at some pictures.;

gen bin=ceil(pct*10)/.10;

tab treat free_lunch;

gen treat_freq=1/1368 if treat==1;
  label variable treat_freq "treatment observations";
gen control_freq=1/3040 if treat==0;
  label variable control_freq "control observations";

gen treat_freq_high=1/766 if treat==1 & free_lunch==0;
  label variable treat_freq_high "treatment observations with high income";
gen control_freq_high=1/1680 if treat==0 & free_lunch==0;
  label variable control_freq_high "control observations with high income";


gen treat_freq_low=1/602 if treat==1 & free_lunch==1;
  label variable treat_freq_low "treatment observations with low income";
gen control_freq_low=1/1360 if treat==0 & free_lunch==1;
  label variable control_freq_low "control observations with low income";
  



graph bar (sum) control_freq_low control_freq_high, over(bin) bar(1, color(black))
  bar(2, color(gray)) legend(subtitle("{stSerif}Fraction in Quantile of Control Outcome Distribution")
  label(1 "{stSerif}Lower Income")
  label(2 "{stSerif}Higher Income"))
  title("{stSerif}Rank Distribution in Control Distribution by Family" "{stSerif}Income (STAR Example)", color(black))
  saving(control_high_low_comp_STAR, replace);
graph export control_high_low_comp_STAR.pdf, as(pdf) replace;


graph bar (sum) control_freq_low treat_freq_low, over(bin) bar(1, color(black))
  bar(2, color(gray)) legend(subtitle("{stSerif}Fraction in Quantile of Outcome Distribution")
  label(1 "{stSerif}Control Group")
  label(2 "{stSerif}Treatment Group"))
  title("{stSerif}Rank Distribution of Subjects with Lower Family Income" "{stSerif}by Treatment Status (STAR Example)", color(black))
  saving(treat_control_low_comp_STAR, replace);
graph export treat_control_low_comp_STAR.pdf, as(pdf) replace;

