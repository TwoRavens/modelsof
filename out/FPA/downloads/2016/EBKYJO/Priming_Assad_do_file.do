



replace Q1="A1KA0S8EGE5XL8" if Q1=="A1KA0S8EGE5XL8  "
replace Q1="A28QG7I54E4XAD" if Q1=="A28QG7I54E4XAD "
replace Q1="AP8OG80OLCCMC" if Q1=="AP8OG80OLCCMC "
replace Q1="AQZXSZDUL578P" if Q1=="AQZXSZDUL578P "
replace Q1="A360B58589TBUS" if Q1=="A360B58589TBUS  "
replace Q1="A2UZCL6H1RWDSM" if Q1=="A2UZCL6H1RWDSM   "
replace Q1="AFUUPNBIKHRFZ" if Q1=="AFUUPNBIKHRFZ "
replace Q1="A13HA2K0RUU0W0" if Q1=="A13HA2K0RUU0W0 "
replace Q1="A2VFN2WZ2A14IN" if Q1=="A2VFN2WZ2A14IN "
replace Q1="A2VWZO1CNTM6T" if Q1=="A2VWZO1CNTM6T "
replace Q1="A1JOEK5QM0X6UD" if Q1=="a1joek5qm0x6ud"
replace Q1="A2H8TN1B8ZHL7U" if Q1=="a2h8tn1b8zhl7u"
replace Q1="A3HEPB210XUY20" if Q1=="a3hepb210xuy20"
replace Q1="A3W1LG4JXLNCL" if Q1=="a3w1lg4jxlncl"
replace Q1="AV2UZ196W6DQU" if Q1=="av2uz196w6dqu"
replace Q1="A1EF9H36ND8H2Q" if Q1=="A1EF9H36ND8H2Q "
replace Q1="A1R7JBOX7NSBVX" if Q1=="A1R7JBOX7NSBVX "
replace Q1="A1RT9VEXECILJ4" if Q1=="A1RT9VEXECILJ4 "
replace Q1="A1JOEK5QM0X6UD" if Q1=="A1joek5qm0x6ud"
replace Q1="A35VCFQVYX7UJX" if Q1=="A35vcfqvyx7ujx"



gen Repeat=.
replace Repeat=1 if Q1=="A11AC8ZZG6UC7U" & StartDate=="3/17/14 8:52"
replace Repeat=1 if Q1=="AL3U9R1JW2HN9" & StartDate=="3/16/14 18:56"
replace Repeat=1 if Q1=="AHPSD3ANF5SWT" & StartDate=="3/10/14 13:02"
replace Repeat=1 if Q1=="A3VAX2NYGYMTP8" & StartDate=="3/12/14 22:24"
replace Repeat=1 if Q1=="A3OTXZRTRS50ID" & StartDate=="3/24/14 18:22"
replace Repeat=1 if Q1=="A30ZBG4SIBCC2A" & StartDate=="3/24/14 21:16"
replace Repeat=1 if Q1=="A2CSV75E3JT58Y" & StartDate=="3/17/14 15:25"
replace Repeat=1 if Q1=="A29B5FCF883MKU" & StartDate=="3/17/14 10:07"
replace Repeat=1 if Q1=="A26UAJWMMNN351" & StartDate=="3/26/14 15:23"
replace Repeat=1 if Q1=="A1Z53763UXALP" & StartDate=="3/18/14 13:08"
replace Repeat=1 if Q1=="A1S88VQY8G8CNC" & StartDate=="3/21/14 7:16"
replace Repeat=1 if Q1=="A1KJ2WRVURHN5G" & StartDate=="3/11/14 5:16"
replace Repeat=1 if Q1=="A1JOEK5QM0X6UD" & StartDate=="3/16/14 19:54"
replace Repeat=1 if Q1=="A16NXG05LQH85L" & StartDate=="3/10/14 14:04"
replace Repeat=1 if Q1=="A16MDZ7O8KL9EC" & StartDate=="3/18/14 20:53"
replace Repeat=1 if Q1=="A14SHS3ZUA1RLZ" & StartDate=="3/11/14 4:26"



*Interview time
gen double start=clock(StartDate, "MD20Yhm")
gen double end=clock(EndDate, "MD20Yhm")
gen time=(end-start)/60000

generate date=date(StartDate,"MD20Yhm")
sort date
gen Wave=1 if date<=19795 & date!=11791
replace Wave=2 if date>19795 & date!=.



*Dependent Variables
gen Q12a=Q12
recode Q12a (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)

gen Q13a=Q13
recode Q13a (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)

gen Trait=Q8+Q9+Q10+Q11+Q12a+Q13a
replace Trait=Trait/6

gen Q2a=Q2
recode Q2a (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)
gen Q3a=Q3
recode Q3a (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)
gen Q4a=Q4
recode Q4a (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)
gen Q5a=Q5
recode Q5a (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)
gen Q6a=Q6
recode Q6a (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)
gen Q7a=Q7
recode Q7a (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)

gen Action=Q2a+Q3a+Q4a+Q5a+Q6a+Q7a
replace Action=Action/6


*Independent Variables
gen Treatment=1 if Condition==1
replace Treatment=0 if Condition==2



gen Race=1 if Q23a==1
replace Race=2 if Q23b==1
replace Race=3 if Q23c==1 
replace Race=4 if Q23d==1
replace Race=5 if Q23e==1
replace Race=6 if Q23f==1
replace Race=7 if Q23g==1
replace Race=8 if Q23h==1



gen vWhite=Q27
gen vAsian=Q28
gen vLatino=Q29
gen vBlack=Q30
gen vMiddleEast=Q31


gen Ethnocentrism=vWhite-((vAsian+vLatino+vBlack+vMiddleEast)/4) if Race==1
replace Ethnocentrism=vBlack-((vWhite+vAsian+vLatino+vMiddleEast)/4) if Race==2
replace Ethnocentrism=vLatino-((vWhite+vAsian+vBlack+vMiddleEast)/4) if Race==3
replace Ethnocentrism=vAsian-((vWhite+vLatino+vBlack+vMiddleEast)/4) if Race==4 | Race==6
replace Ethnocentrism=Ethnocentrism/6


*Table 1 models
regress Trait Treatment Ethnocentrism if Repeat!=1 & Finished==1, robust
regress Action Treatment Ethnocentrism if Repeat!=1 & Finished==1, robust

*Table 2 models and marginal effects
regress Trait Treatment##c.Ethnocentrism if Repeat!=1 & Finished==1, robust
margins, dydx(Treatment) at(Ethnocentrism=(-.15(.05).35)) level(90)
regress Action Treatment##c.Ethnocentrism if Repeat!=1 & Finished==1, robust
margins, dydx(Treatment) at(Ethnocentrism=(-.15(.05).35)) level(90)
