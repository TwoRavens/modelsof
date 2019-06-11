
 use "italian_municipal.dta"


 rename comune Municipality

 rename anno Year
 
 *Dropping dublications in master*
sort Municipality Year
quietly by Municipality Year:  gen dup = cond(_N==1,0,_n)
drop if dup!=0

merge 1:m Municipality Year using "italian_municipal_turnout.dta"


ssc install cdfplot, replace
net install rdrobust, from("https://sites.google.com/site/rdpackages/rdrobust/stata") replace 
ssc install outreg2, replace

*Generation of numerical identification for municipalities and regions*
encode Municipality, gen (id_comune)
rename codente id_codente

*diff-in-disc sample selection:
drop if Year<1999|Year>2004
drop if popcens<3500|popcens>7000


*generatation of analysis variables (From Grembi et al. (2016):
gen treatment_t=(popcens<5000&Year>2000&Year<2005) if Year!=.|popcens!=.
gen treatment_t_int1=(popcens-5000) if popcens!=.&treatment_t!=. 
replace treatment_t_int1=0 if treatment_t==0
gen treatment_t_int2=treatment_t_int1*treatment_t_int1
gen treatment_t_int3=treatment_t_int1*treatment_t_int1*treatment_t_int1
gen treatment_t_int4= treatment_t_int1*treatment_t_int1*treatment_t_int1*treatment_t_int1
gen treatment_t_int5=treatment_t_int1*treatment_t_int1*treatment_t_int1*treatment_t_int1*treatment_t_int1
gen postper=(Year>2000&Year<2005) if Year!=.
gen postper_int1=(popcens-5000) if popcens!=.&postper!=. 
replace postper_int1=0 if postper==0
gen postper_int2=postper_int1*postper_int1
gen postper_int3=postper_int1*postper_int1*postper_int1
gen postper_int4= postper_int1*postper_int1*postper_int1*postper_int1
gen postper_int5=postper_int1*postper_int1*postper_int1*postper_int1*postper_int1
g pop5000=popcens-5000
g t5000=0 & popcens!=.
replace t5000=1 if popcens<5000
g t5000_int1=t5000*pop5000
gen t5000_int4=t5000_int1*t5000_int1*t5000_int1*t5000_int1
gen t5000_int5=t5000_int1*t5000_int1*t5000_int1*t5000_int1*t5000_int1
gen pop5000_4=pop5000*pop5000*pop5000*pop5000 
gen pop5000_5=pop5000*pop5000*pop5000*pop5000*pop5000
g pop5000_2= pop5000^2
g t5000_int2=t5000*pop5000_2
g pop5000_3= pop5000^3
g t5000_int3=t5000*pop5000_3




*Difference-in distance estimation for turnout*



*Manuel generation of bandwiths*
foreach var in Turnout {
rdrobust `var' pop5000 if Year>2000&Year<2005
local band1=e(h_bw)
rdrobust `var' pop5000 if Year<2001&Year>1998 
local band2=e(h_bw)
local band=(`band1'+`band2')/2
display "`band'"
}



*Table 3: Estmation Removal of the municipality (PANTIGLIATE) with turnout above 100 (2004 election)*

* Average off the two bandwidths above (based on Calonico, Cattaneo and Titiunik 2014)*
reg Turnout treatment_t t5000 pop5000 treatment_t_int1 t5000_int1 postper postper_int1 if abs(pop5000)<564.386 & id_comune!=5580 , r cluster(id_codente)
 *Lower bandwidth*
reg Turnout treatment_t t5000 pop5000 treatment_t_int1 t5000_int1 postper postper_int1 if abs(pop5000)<400 & id_comune!=5580 , r cluster(id_codente)

 *Higher bandwidth*
reg Turnout treatment_t t5000 pop5000 treatment_t_int1 t5000_int1 postper postper_int1 if abs(pop5000)<800 & id_comune!=5580 , r cluster(id_codente)
 *Much higher bandwidth*
reg Turnout treatment_t t5000 pop5000 treatment_t_int1 t5000_int1 postper postper_int1 if abs(pop5000)<1000 & id_comune!=5580 , r cluster(id_codente)



*Appendix: Table G1 :* 


* Average off the two bandwidths above (based on Calonico, Cattaneo and Titiunik 2014)*
 reg Turnout treatment_t t5000 pop5000 treatment_t_int1 t5000_int1 postper postper_int1 if abs(pop5000)<564.386, r cluster(id_codente)


 *Lower bandwidth*
 reg Turnout treatment_t t5000 pop5000 treatment_t_int1 t5000_int1 postper postper_int1 if abs(pop5000)<400, r cluster(id_codente)


 *Higher bandwidth*
 reg Turnout treatment_t t5000 pop5000 treatment_t_int1 t5000_int1 postper postper_int1 if abs(pop5000)<800, r cluster(id_codente)

 
 *Much higher bandwidth*
reg Turnout treatment_t t5000 pop5000 treatment_t_int1 t5000_int1 postper postper_int1 if abs(pop5000)<1000, r cluster(id_codente)


*______________________*

*Automatic generation of bandwith, which do not seem to work*
foreach var in Turnout {
rdrobust `var' pop5000 if Year>2000&Year<2005
local band1=e(h_bw)
rdrobust `var' pop5000 if Year<2001&Year>1998 
local band2=e(h_bw)
local band=(`band1'+`band2')/2
display "`band'"

xi: reg `var' treatment_t t5000 pop5000 treatment_t_int1 t5000_int1 postper postper_int1 if abs(pop5000)<`band', r cluster(id_codente)
outreg2 treatment_t using tab_base_`var', bdec(3) nocons tex(nopretty) 
}

