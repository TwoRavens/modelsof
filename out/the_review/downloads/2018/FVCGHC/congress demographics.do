clear all
cd "~/Dropbox/Ties that Double Bind Replication Data/data"

insheet using "candidate_bios_pvs.csv", clear names

gen married = 0
	replace married = 1 if regex(candidatefamily, "Husband")
	replace married = 1 if regex(candidatefamily, "Wife")
	replace married = 1 if regex(candidatefamily, "Married")
	
gen children = 0
	replace children = 1 if regex(candidatefamily, "Children:")
	replace children = 1 if regex(candidatefamily, "Child:")
	
split candidatefamily if children == 1, p(";") gen(children_number)
split children_number2, p(":") gen(kids)
drop children_number1 children_number2 children_number3 kids2
rename kids1 number_children
replace number_children = "1 Children" if number_children == "1 Child"
destring number_children, ignore(" Children") replace
replace number_children = 0 if missing(number_children)

gen number_children_fix = ""
	replace number_children_fix = substr(candidatefamily, 1, 2) if number_children == 0 & children == 1
destring number_children_fix, replace
replace number_children = number_children_fix if number_children == 0 & children == 1
drop number_children_fix

tab married candidategender, col //68 percent of Congresswomen are married compared with 89 percent of Congressmen
tab children candidategender, col //While men and women officeholders are as likely to have children (around 70 percent), 
tabstat number_children, by(candidategender) //male officeholders have more: women have an average of 1.5 children compared to 1.9 for men

