* Table 1: Summary Stats
sum netmargin roa roe ece logassets age effic leverage transp jv relationship export sales asset_total worker equity intangible wageav profit_total benefit year disc_accrual_w 
tabstat netmargin roa roe ece logassets age effic leverage transp jv relationship export sales asset_total worker equity intangible wageav profit_total benefit year disc_accrual_w if disc_accrual_w!=., by(ece) stats(N mean sd min max) col(stat)

* Table 2a: static effects of ECE

xi: areg netmargin ece logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id) 
xi: areg roa ece logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roe ece logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)

xi: areg netmargin ece logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roa ece logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roe ece logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)


* Table 2b: transfer pricing

*gen transp = export/sales
xi: areg roa ece logassets age effic leverage i.province_id i.year if jv==1&export==0, absorb(firm_id) cluster(firm_id)

xi: areg transp ece logassets age effic leverage i.relationship i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg netmargin ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roa ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roa ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)


*xtile quart = transp if transp>0, nq(4)

xi: areg netmargin ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==1, absorb(sector_id) cluster(sector_id)
xi: areg netmargin ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==2, absorb(sector_id) cluster(sector_id)
xi: areg netmargin ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==3, absorb(sector_id) cluster(sector_id)
xi: areg netmargin ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==4, absorb(sector_id) cluster(sector_id)

xi: areg roa ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==1, absorb(sector_id) cluster(sector_id)
xi: areg roa ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==2, absorb(sector_id) cluster(sector_id)
xi: areg roa ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==3, absorb(sector_id) cluster(sector_id)
xi: areg roa ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==4, absorb(sector_id) cluster(sector_id)

xi: areg roe ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==1, absorb(sector_id) cluster(sector_id)
xi: areg roe ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==2, absorb(sector_id) cluster(sector_id)
xi: areg roe ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==3, absorb(sector_id) cluster(sector_id)
xi: areg roe ece transp logassets age effic leverage i.relationship i.province_id i.year if jv==1&quart==4, absorb(sector_id) cluster(sector_id)


*Mean-center age before interacting with ece dummy
gen eceage=ece*(age-6.357577)/5.054625  

*Table 3: Dynamic effects -- ece*age

xi: areg netmargin eceage ece logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage ece logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage ece logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)

xi: areg netmargin eceage ece logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage ece logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage ece logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)


* Table 4: Robustness checks with nonlinear terms for controls

xi: areg netmargin eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)

xi: areg netmargin eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)


* Table 5: Check robustness after adding more controls.

xi: areg netmargin eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)

xi: areg netmargin eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage ece logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)


** Explore the mechanisms of dynamic inefficiency

* Table 6: Showing the significant negative correlation between ece and intangibles/human capital.

xi: areg intangible logassets effic leverage age ece i.year i.province_id if jv==1, absorb(sector_id) cluster(sector_id)
xi: areg intangible logassets effic leverage age ece i.year i.province_id if jv==0, absorb(sector_id) cluster(sector_id)


xi: areg wageav logassets effic leverage age ece i.year i.province_id if jv==1, absorb(sector_id) cluster(sector_id)
xi: areg wageav logassets effic leverage age ece i.year i.province_id if jv==0, absorb(sector_id) cluster(sector_id)


* Table 7: Compare ece*age effects within the quintiles of the Intangible levels

	* Analyses within the intangible=0 JV subsample

xi: areg netmargin eceage ece wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&intangible==0, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&intangible==0, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&intangible==0, absorb(sector_id) cluster(sector_id)

	* Analyses within the intangible=0 non-JV subsample

xi: areg netmargin eceage ece wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&intangible==0, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&intangible==0, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&intangible==0, absorb(sector_id) cluster(sector_id)


	* Analyses within the positive intangible quintiles, which was the old Table 11. 
	*xtile inaquint = intangible if intangible>0, nq(5)

		* JV sample

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==1, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==1, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==1, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==2, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==2, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==2, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==3, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==3, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==3, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==4, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==4, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==4, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==5, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==5, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&inaquint==5, absorb(sector_id) cluster(sector_id)

		* non-jv sample

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==1, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==1, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==1, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==2, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==2, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==2, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==3, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==3, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==3, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==4, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==4, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==4, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==5, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==5, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&inaquint==5, absorb(sector_id) cluster(sector_id)


* Table 8, which was the old Table 12. ece*age effects in wage/worker quintiles

*xtile hkquint = wageav, nq(5)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==1, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==1, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==1, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==2, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==2, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==2, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==3, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==3, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==3, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==4, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==4, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==4, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==5, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==5, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==1&hkquint==5, absorb(sector_id) cluster(sector_id)

	* non-jv sample

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==1, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==1, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==1, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==2, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==2, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==2, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==3, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==3, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==3, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==4, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==4, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==4, absorb(sector_id) cluster(sector_id)

xi: areg netmargin eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==5, absorb(sector_id) cluster(sector_id)
xi: areg roa eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==5, absorb(sector_id) cluster(sector_id)
xi: areg roe eceage ece intangible wageav logassets age effic leverage lnassetssq agesq levsq efficsq export transp i.relationship i.province_id i.year if jv==0&hkquint==5, absorb(sector_id) cluster(sector_id)




* Append Table 9: Explore the mechanisms via intangibles and human capital

*gen eceIntangible=ece*intangible
*gen iasq=intangible*intangible

xi: areg netmargin eceIntangible ece intangible logassets age effic leverage iasq lnassetssq agesq levsq efficsq i.province_id i.year if jv==1, absorb(sector_id) cluster(sector_id) 
xi: areg roa eceIntangible ece intangible logassets age effic leverage iasq lnassetssq agesq levsq efficsq i.province_id i.year if jv==1, absorb(sector_id) cluster(sector_id) 
xi: areg roe eceIntangible ece intangible logassets age effic leverage iasq lnassetssq agesq levsq efficsq i.province_id i.year if jv==1, absorb(sector_id) cluster(sector_id) 

xi: areg netmargin eceIntangible ece intangible logassets age effic leverage iasq lnassetssq agesq levsq efficsq i.province_id i.year if jv==0, absorb(sector_id) cluster(sector_id) 
xi: areg roa eceIntangible ece intangible logassets age effic leverage iasq lnassetssq agesq levsq efficsq i.province_id i.year if jv==0, absorb(sector_id) cluster(sector_id) 
xi: areg roe eceIntangible ece intangible logassets age effic leverage iasq lnassetssq agesq levsq efficsq i.province_id i.year if jv==0, absorb(sector_id) cluster(sector_id) 

*gen ecewage=ece*wageav
*gen wagesq=wageav*wageav

xi: areg netmargin ecewage ece wageav logassets age effic leverage wagesq lnassetssq agesq levsq efficsq i.province_id i.year if jv==1, absorb(sector_id) cluster(sector_id) 
xi: areg roa ecewage ece wageav logassets age effic leverage wagesq lnassetssq agesq levsq efficsq i.province_id i.year if jv==1, absorb(sector_id) cluster(sector_id) 
xi: areg roe ecewage ece wageav logassets age effic leverage wagesq lnassetssq agesq levsq efficsq i.province_id i.year if jv==1, absorb(sector_id) cluster(sector_id)

xi: areg netmargin ecewage ece wageav logassets age effic leverage wagesq lnassetssq agesq levsq efficsq i.province_id i.year if jv==0, absorb(sector_id) cluster(sector_id) 
xi: areg roa ecewage ece wageav logassets age effic leverage wagesq lnassetssq agesq levsq efficsq i.province_id i.year if jv==0, absorb(sector_id) cluster(sector_id) 
xi: areg roe ecewage ece wageav logassets age effic leverage wagesq lnassetssq agesq levsq efficsq i.province_id i.year if jv==0, absorb(sector_id) cluster(sector_id)

* Table 10: mediation effect of intangibles and average wage on ECE*age effects

xi: areg netmargin eceage eceIntangible ece intangible logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage eceIntangible ece intangible logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage eceIntangible ece intangible logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)

xi: areg netmargin eceage eceIntangible ece intangible logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage eceIntangible ece intangible logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage eceIntangible ece intangible logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)


* Table 11: mediation effect of average wage on ECE*age effects

xi: areg netmargin eceage ecewage ece intangible logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage ecewage ece intangible logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage ecewage ece intangible logassets age effic leverage i.province_id i.year if jv==1, absorb(firm_id) cluster(firm_id)

xi: areg netmargin eceage ecewage ece wageav logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roa eceage ecewage ece wageav logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)
xi: areg roe eceage ecewage ece wageav logassets age effic leverage i.province_id i.year if jv==0, absorb(firm_id) cluster(firm_id)

