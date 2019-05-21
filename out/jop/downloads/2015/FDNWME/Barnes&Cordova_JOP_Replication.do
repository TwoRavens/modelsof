//Created: Tiffany D. Barnes and Abby C—rdova, Department of Political Science, University of Kentucky 
//Date: 12/3/15
//Replication file for "Making Space for Women: Explaining Citizen Support for Legislative Gender Quotas in Latin America"  


*****Table 1 

set more off
***Model 1
meologit gen6 i.mujer c.gov_capabilities c.rolestado strength  incomeind_2011  i.b4.l1r ing4r gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

***Model 2
meologit gen6 i.mujer c.gov_capabilities c.rolestado strength  incomeind_2011 pf i.b4.l1r ing4r gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

***Model 3
meologit gen6 i.mujer##c.gov_capabilities##c.rolestado strength  incomeind_2011   i.b4.l1r ing4r	gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

***Model 4
meologit gen6 i.mujer##c.gov_capabilities##c.rolestado strength  incomeind_2011 pf  i.b4.l1r ing4r	gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  


****************ONLINE APPENDIX****************

***Table A7_Robustness Test_using Government Effectiveness Index from World Bank Governance Indicators

set more off
meologit gen6 i.mujer c.ge_estimater c.rolestado strength incomeind_2011  i.b4.l1r ing4r gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

meologit gen6 i.mujer c.ge_estimater c.rolestado strength incomeind_2011 pf  i.b4.l1r ing4r gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

set more off
meologit gen6 i.mujer##c.ge_estimater##c.rolestado strength incomeind_2011  i.b4.l1r ing4r gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

meologit gen6 i.mujer##c.ge_estimater##c.rolestado strength incomeind_2011 pf i.b4.l1r ing4r gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  


***Table A8_Controlling for percent of women in the legislature or years since the implementation of quota laws, instead of gender quota index
set more off
meologit gen6 i.mujer##c.gov_capabilities##c.rolestado p_women_11  incomeind_2011 pf i.b4.l1r ing4r	gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

meologit gen6 i.mujer##c.gov_capabilities##c.rolestado yearsquota_new incomeind_2011 pf   i.b4.l1r ing4r	gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

*****Table A9_Controlling for alternative measure of democracy, Polity 
set more off

meologit gen6 i.mujer##c.gov_capabilities##c.rolestado strength polity incomeind_2011 i.b4.l1r  ing4r	gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

*****Table A10_Controlling for corruption (at the national level) 

meologit gen6 i.mujer##c.gov_capabilities##c.rolestado strength  corruption_averaged  incomeind_2011 pf i.b4.l1r ing4r	gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

*****Table A11_Controlling for alternative measure of gender egalitarian attitudes (VB50)
set more off
meologit gen6 i.mujer##c.gov_capabilities##c.rolestado strength pf incomeind_2011  i.b4.l1r ing4r	i.b0.vb50r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

*****Table A12_Controlling for alternative measure of gender egalitarian attitudes (VB52)
set more off
meologit gen6 i.mujer##c.gov_capabilities##c.rolestado strength pf incomeind_2011  i.b4.l1r ing4r	i.b3.vb52recoded EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  
 
****Table_C1_Support for Gender Quotas (Interacting Quota Index, Support for Government Involvement, and Sex)
****Model 1
set more off
meologit gen6 i.mujer##c.rolestado##c.gov_capabilities i.mujer##c.rolestado##c.strength  incomeind_2011  i.b4.l1r ing4r gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

****Model 2
set more off
meologit gen6 i.mujer##c.rolestado##c.gov_capabilities c.rolestado##c.strength i.mujer##c.strength incomeind_2011  i.b4.l1r ing4r gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  

****Table C2_Support for Gender Quotas (Interacting Government Capability index with Quota index)
set more off
meologit gen6 i.mujer##c.gov_capabilities##c.rolestado c.gov_capabilities##c.strength  incomeind_2011  i.b4.l1r ing4r	gen1r EFICGOV quintall edr i.ur	i.b1.q11r q12 q2  ||  pais: , cov(uns)  
