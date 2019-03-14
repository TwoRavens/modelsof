
*ONLINE APPENDIX

*trust

recode kj207_1 (1=5) (2=4) (4=2) (5=1) (99999997 99999998 99999999 =.) , gen(gov_trust)
label variable gov_trust "Fed Gov't"
recode kj207_2 (1=5) (2=4) (4=2) (5=1) (99999997 99999998 99999999 =.) , gen(duma_trust)
label variable duma_trust "Duma"
recode kj207_3 (1=5) (2=4) (4=2) (5=1) (99999997 99999998 99999999 =.) , gen(court_trust)
label variable court_trust "Court"
recode kj207_5 (1=5) (2=4) (4=2) (5=1) (99999997 99999998 99999999 =.) , gen(army_trust)
label variable army_trust "Army"
recode kj207_6 (1=5) (2=4) (4=2) (5=1) (99999997 99999998 99999999 =.) , gen(police_trust)
label variable police_trust "Police"

gen trust_5inst = (gov_trust + duma_trust + court_trust + army_trust + police_trust)/5
label variable trust_5inst "Gov't Index"

*potential confounders 

rename kh7_1 date
label variable date "Date of the interview"
rename kh7_2 month

recode k_age (99999997=.), gen(age)
label variable age "Age"

recode kh5 (2=0), gen(male)
label variable male "Male"

tab kj1, gen(employement)
rename employement5 unempl
label variable unempl "Unemployed"

rename k_diplom_1 edu
label variable edu "Education"

tab region, gen(region)


*Table OL-4
 
reg trust_5inst date male age edu unempl region1-region38 if month==12
outreg2 using Trust_rlms.xml, keep(date male age edu unempl) addtext(FE for the regions, YES) dec(2) alpha(0.001, 0.05) symbol(*,*) label replace 

reg gov_trust date male age edu unempl region1-region38 if month==12
outreg2 using Trust_rlms.xml, keep(date male age edu unempl) addtext(FE for the regions, YES) dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg duma_trust date male age edu unempl region1-region38 if month==12
outreg2 using Trust_rlms.xml, keep(date male age edu unempl) addtext(FE for the regions, YES) dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg court_trust date male age edu unempl region1-region38 if month==12
outreg2 using Trust_rlms.xml, keep(date male age edu unempl) addtext(FE for the regions, YES) dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg army_trust date male age edu unempl region1-region38 if month==12
outreg2 using Trust_rlms.xml, keep(date male age edu unempl) addtext(FE for the regions, YES) dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg police_trust date male age edu unempl region1-region38 if month==12
outreg2 using Trust_rlms.xml, keep(date male age edu unempl) addtext(FE for the regions, YES) dec(2) alpha(0.001, 0.05) symbol(*,*) label
