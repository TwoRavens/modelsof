* Date: March 18, 2015
* Apply to: various
* Description: create demand-side variables file

clear

set more off


use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Farm Value\Population\state_year_pop.dta", clear


* Interpolate population values

sort state year

by state: ipolate pop_tot year, gen(i_pop_tot)
by state: ipolate pop_urban year, gen(i_pop_urban)

gen i_pop_urban_p =  round((i_pop_urban / i_pop_tot) * 100, .01)

drop pop_tot pop_urban i_pop_urban


* Year State Admitted

gen year_state_entry = 0
replace year_state_entry = 1776 if state==1
replace year_state_entry = 1776 if state==11
replace year_state_entry = 1818 if state==21
replace year_state_entry = 1816 if state==22
replace year_state_entry = 1792 if state==51
replace year_state_entry = 1776 if state==52
replace year_state_entry = 1776 if state==34
replace year_state_entry = 1776 if state==12
replace year_state_entry = 1776 if state==13
replace year_state_entry = 1803 if state==24
replace year_state_entry = 1776 if state==14
replace year_state_entry = 1776 if state==5
replace year_state_entry = 1863 if state==56

replace year_state_entry = 1819 if state==41
replace year_state_entry = 1836 if state==42
replace year_state_entry = 1845 if state==43
replace year_state_entry = 1776 if state==44
replace year_state_entry = 1812 if state==45
replace year_state_entry = 1817 if state==46
replace year_state_entry = 1776 if state==47
replace year_state_entry = 1776 if state==48
replace year_state_entry = 1796 if state==54
replace year_state_entry = 1776 if state==49
replace year_state_entry = 1776 if state==40

replace year_state_entry = 1846 if state==31
replace year_state_entry = 1861 if state==32
replace year_state_entry = 1820 if state==2
replace year_state_entry = 1776 if state==3
replace year_state_entry = 1837 if state==23
replace year_state_entry = 1858 if state==33
replace year_state_entry = 1867 if state==35
replace year_state_entry = 1776 if state==4
replace year_state_entry = 1889 if state==36
replace year_state_entry = 1907 if state==53
replace year_state_entry = 1889 if state==37
replace year_state_entry = 1791 if state==6
replace year_state_entry = 1848 if state==25

replace year_state_entry = 1959 if state==81
replace year_state_entry = 1912 if state==61
replace year_state_entry = 1850 if state==71
replace year_state_entry = 1876 if state==62
replace year_state_entry = 1959 if state==82
replace year_state_entry = 1890 if state==63
replace year_state_entry = 1889 if state==64
replace year_state_entry = 1864 if state==65
replace year_state_entry = 1912 if state==66
replace year_state_entry = 1859 if state==72
replace year_state_entry = 1896 if state==67
replace year_state_entry = 1889 if state==73
replace year_state_entry = 1890 if state==68


gen admitted = 0
replace admitted = 1 if year>=year_state_entry


rename state_year stateyear
sort stateyear


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Farm Value\Population\pop_1.dta", replace

* End
