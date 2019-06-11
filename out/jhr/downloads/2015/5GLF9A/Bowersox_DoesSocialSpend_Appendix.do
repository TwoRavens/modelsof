************************************************
************************************************
****		Appendix Models					****
****		For use with					****
****		Bowersox_DoesSocialSpend_Data	****
************************************************
************************************************

*.do file need be run twice; once for OECD states, and a second time for non-OECD states.

drop if oecd == 0
*drop if oecd == 1

* Appendices Table 5a & 5b *


xtgls part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim unemploy L.part, force corr(psar)

xtgls protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim unemploy L.protest, force corr(psar)

xtgls strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim unemploy L.strike, force corr(psar)

xtgls riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim unemploy L.riot, force corr(psar)



* Appendice Table 6a & 6b * 56% Imputed

xtgls part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim i_unemp L.part, force corr(psar)

xtgls protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim i_unemp L.protest, force corr(psar)

xtgls strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim i_unemp L.strike, force corr(psar)

xtgls riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim i_unemp L.riot, force corr(psar)


* Appendices Table 7a & 7b * 

xtgls part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim hringo L.part, force corr(psar)

xtgls protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim hringo L.protest, force corr(psar)

xtgls strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim hringo L.strike, force corr(psar)

xtgls riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim hringo L.riot, force corr(psar)



* Appendices Table 8a & 8b *

xtgls part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim war L.part, force corr(psar)

xtgls protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim war L.protest, force corr(psar)

xtgls strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim war L.strike, force corr(psar)

xtgls riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim war L.riot, force corr(psar)

**
****
****** LAGS
****
**
gen Spend_tm1 = Spend[_n-1]
gen Spend_tm2 = Spend[_n-2]
gen Spend_tm3 = Spend[_n-3]
gen Spend_tm4 = Spend[_n-4]
gen Spend_tm5 = Spend[_n-5]

gen Empower_tm1 = Empower[_n-1]
gen Empower_tm2 = Empower[_n-2]
gen Empower_tm3 = Empower[_n-3]
gen Empower_tm4 = Empower[_n-4]
gen Empower_tm5 = Empower[_n-5]

gen interact_tm1 = SpendEmpr[_n-1]
gen interact_tm2 = SpendEmpr[_n-2]
gen interact_tm3 = SpendEmpr[_n-3]
gen interact_tm4 = SpendEmpr[_n-4]
gen interact_tm5 = SpendEmpr[_n-5]

*
** Appendices Table 9 * 
*

xtgls part Spend_tm1 Empower_tm1 interact_tm1 lcapita poplog exconst logmilex Judiciary cim L.part, force corr(psar)

xtgls part Spend_tm2 Empower_tm2 interact_tm2 lcapita poplog exconst logmilex Judiciary cim L.part, force corr(psar)

xtgls part Spend_tm3 Empower_tm3 interact_tm3 lcapita poplog exconst logmilex Judiciary cim L.part, force corr(psar)

xtgls part Spend_tm4 Empower_tm4 interact_tm4 lcapita poplog exconst logmilex Judiciary cim L.part, force corr(psar)

xtgls part Spend_tm5 Empower_tm5 interact_tm5 lcapita poplog exconst logmilex Judiciary cim L.part, force corr(psar)

xtgls protest Spend_tm1 Empower_tm1 interact_tm1 lcapita poplog exconst logmilex Judiciary cim  L.protest, force corr(psar)

xtgls protest Spend_tm2 Empower_tm2 interact_tm2 lcapita poplog exconst logmilex Judiciary cim  L.protest, force corr(psar)

xtgls protest Spend_tm3 Empower_tm3 interact_tm3 lcapita poplog exconst logmilex Judiciary cim L.protest, force corr(psar)

xtgls protest Spend_tm4 Empower_tm4 interact_tm4 lcapita poplog exconst logmilex Judiciary cim L.protest, force corr(psar)

xtgls protest Spend_tm5 Empower_tm5 interact_tm5 lcapita poplog exconst logmilex Judiciary cim L.protest, force corr(psar)

xtgls strike Spend_tm1 Empower_tm1 interact_tm1 lcapita poplog exconst logmilex Judiciary cim L.strike, force corr(psar)

xtgls strike Spend_tm2 Empower_tm2 interact_tm2 lcapita poplog exconst logmilex Judiciary cim L.strike, force corr(psar)
	
xtgls strike Spend_tm3 Empower_tm3 interact_tm3 lcapita poplog exconst logmilex Judiciary cim L.strike, force corr(psar)

xtgls strike Spend_tm4 Empower_tm4 interact_tm4 lcapita poplog exconst logmilex Judiciary cim L.strike, force corr(psar)

xtgls strike Spend_tm5 Empower_tm5 interact_tm5 lcapita poplog exconst logmilex Judiciary cim L.strike, force corr(psar)

xtgls riot Spend_tm1 Empower_tm1 interact_tm1 lcapita poplog exconst logmilex Judiciary cim L.riot, force corr(psar)

xtgls riot Spend_tm2 Empower_tm2 interact_tm2 lcapita poplog exconst logmilex Judiciary cim L.riot, force corr(psar)

xtgls riot Spend_tm3 Empower_tm3 interact_tm3 lcapita poplog exconst logmilex Judiciary cim L.riot, force corr(psar)

xtgls riot Spend_tm4 Empower_tm4 interact_tm4 lcapita poplog exconst logmilex Judiciary cim L.riot, force corr(psar)

xtgls riot Spend_tm5 Empower_tm5 interact_tm5 lcapita poplog exconst logmilex Judiciary cim L.riot, force corr(psar)

*
** Appendices Table 10a & 10b *
*

gen proprep = 0
replace proprep = 1 if legislative_type == 2


xtgls part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim proprep L.part, force corr(psar)

xtgls protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim proprep L.protest, force corr(psar)

xtgls strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim proprep L.strike, force corr(psar)

xtgls riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim proprep L.riot, force corr(psar)

*
** Appendices Table 11a & 11b * 
*

gen major = 0
replace major = 1 if legislative_type == 1


xtgls part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim major L.part, force corr(psar)

xtgls protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim major L.protest, force corr(psar)

xtgls strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim major L.strike, force corr(psar)

xtgls riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim major L.riot, force corr(psar)

*
** Appendices Table 12a & 12b * 
*

xtgls part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim ht_partsz L.part, force corr(psar)

xtgls protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim ht_partsz L.protest, force corr(psar)

xtgls strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim ht_partsz L.strike, force corr(psar)

xtgls riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim ht_partsz L.riot, force corr(psar)


