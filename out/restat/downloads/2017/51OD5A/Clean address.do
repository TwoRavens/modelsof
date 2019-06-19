clear

insheet using OrigData/customer_address.csv, comma

rename state state_raw
gen g= substr(state_raw,1,1)
gen state ="VIC" if g=="v" | g=="V"
keep if state =="VIC"
rename party_code account_number 
sort account_number

rename address2 suburb

replace suburb=proper(suburb)

save Data/address_temp

clear
insheet using OrigData/suburbs_typos.csv, comma

rename v1 suburb 

merge 1:m suburb using Data/address_temp

replace suburb = v2 if _merge==3

drop v2 _merge

*merge to fill in empty postcodes
merge m:1 suburb using Data/postcode_list.dta

replace postcode = pcode if postcode==.
replace postcode = 3219 if suburb =="Geelong East" & postcode==.
replace suburb = "South Yarra" if suburb =="3141"
replace suburb = "Carlton" if suburb =="18/116 Drummond Street"
replace suburb = "Mildura" if suburb == "3500"


erase Data/address_temp.dta

collapse (first) postcode site* address* suburb state_add=state, by(account_number)

rename postcode pcode

save Data/address, replace
