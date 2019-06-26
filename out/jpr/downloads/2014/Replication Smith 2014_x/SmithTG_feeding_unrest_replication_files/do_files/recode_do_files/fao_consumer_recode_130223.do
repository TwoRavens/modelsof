**** PREP FAO DATA *****

clear
import excel "data/FAOSTAT_consumer_prices_dld_120313.xlsx", sheet("Sheet1") firstrow

gen month = .
replace month = 1 if element == "January"replace month = 2 if element == "February"replace month = 3 if element == "March"replace month = 4 if element == "April"replace month = 5 if element == "May"replace month = 6 if element == "June"replace month = 7 if element == "July"replace month = 8 if element == "August"replace month = 9 if element == "September"replace month = 10 if element == "October"replace month = 11 if element == "November"replace month = 12 if element == "December"
lab def month 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
lab val month month

gen time = ((year - 1960) * 12) + (month - 1)
format time %tmMon_CCYY

gen int iso_num = .

replace iso_num = 012 if countries == "Algeria"replace iso_num = 024 if countries == "Angola, Luanda"replace iso_num = 204 if countries == "Benin, Cotonou"replace iso_num = 072 if countries == "Botswana"replace iso_num = 854 if countries == "Burkina Faso, Ouagadougou"replace iso_num = 108 if countries == "Burundi, Bujumbura"replace iso_num = 120 if countries == "Cameroon"replace iso_num = 132 if countries == "Cape Verde"replace iso_num = 132 if countries == "Cape Verde, Praia"replace iso_num = 140 if countries == "Central African Republic, Bangui"replace iso_num = 148 if countries == "Chad, N'Djamena"replace iso_num = 178 if countries == "Congo, Brazzaville"replace iso_num = 384 if countries == "Cote d'Ivoire, Abidjan"replace iso_num = 818 if countries == "Egypt"replace iso_num = 226 if countries == "Equatorial Guinea, Malabo"replace iso_num = 231 if countries == "Ethiopia"replace iso_num = 231 if countries == "Ethiopia, Addis Abeba"replace iso_num = 266 if countries == "Gabon, Libreville"replace iso_num = 270 if countries == "Gambia, Banjul"replace iso_num = 288 if countries == "Ghana"replace iso_num = 624 if countries == "Guinea-Bissau, Bissau"replace iso_num = 324 if countries == "Guinea, Conakry"replace iso_num = 404 if countries == "Kenya"replace iso_num = 404 if countries == "Kenya, Nairobi"replace iso_num = 426 if countries == "Lesotho"replace iso_num = 450 if countries == "Madagascar"replace iso_num = 450 if countries == "Madagascar, Antananarivo"replace iso_num = 450 if countries == "Madagascar, Antananarivo, Europ."replace iso_num = 454 if countries == "Malawi"replace iso_num = 466 if countries == "Mali, Bamako"replace iso_num = 478 if countries == "Mauritania"replace iso_num = 480 if countries == "Mauritius"replace iso_num = 504 if countries == "Morocco"replace iso_num = 508 if countries == "Mozambique"replace iso_num = 508 if countries == "Mozambique, Maputo"replace iso_num = 516 if countries == "Namibia"replace iso_num = 516 if countries == "Namibia, Windhoek"replace iso_num = 562 if countries == "Niger, Niamey"replace iso_num = 566 if countries == "Nigeria"replace iso_num = 646 if countries == "Rwanda"replace iso_num = 646 if countries == "Rwanda, Kigali"replace iso_num = 678 if countries == "Sao Tome and Principe"replace iso_num = 686 if countries == "Senegal"replace iso_num = 686 if countries == "Senegal, Dakar"replace iso_num = 690 if countries == "Seychelles"replace iso_num = 694 if countries == "Sierra Leone"replace iso_num = 694 if countries == "Sierra Leone, Freetown"replace iso_num = 710 if countries == "South Africa"
replace iso_num = 736 if countries == "South Sudan, Funafuti"replace iso_num = 748 if countries == "Swaziland"replace iso_num = 748 if countries == "Swaziland, Mbabane-Manzini"replace iso_num = 768 if countries == "Togo, Lome"replace iso_num = 788 if countries == "Tunisia"replace iso_num = 800 if countries == "Uganda"replace iso_num = 834 if countries == "United Republic of Tanzania, Tanganyika"replace iso_num = 834 if countries == "United Republic of Tanzania, Zanzibar"replace iso_num = 894 if countries == "Zambia"replace iso_num = 894 if countries == "Zambia, Low income group"replace iso_num = 716 if countries == "Zimbabwe"

rename ConsumerPricesFoodIndices2 food_price
rename ConsumerPricesGeneralIndices gen_price

replace food_price = food_price * 1000  if iso_num == 716 & year >= 2005
replace food_price = gen_price * 1000 if iso_num == 716 & year >= 2005

order iso_num countries countrycodes elementCode year month time food_price gen_price
collapse (mean) food_price gen_price, by(iso_num time)

xtset iso_num time
gen food_chg = (food_price - l.food_price) / l.food_price * 100
gen gen_chg = (gen_price - l.gen_price) / l.gen_price * 100

*tempfile `faostat'
save "data/fao_consumer_price_recode.dta", replace
