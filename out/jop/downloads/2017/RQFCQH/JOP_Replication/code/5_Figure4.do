

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure 4: Dynamic Effect 
	**					of Mining Tribunal on Civil Administration 
	**					and on Tax Revenue from Trade and 
	**					Agriculture (1759-1786)
	**
	** 
	**
	**				
	**		Versi—n: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Data
*-------------------------------------------------------------------------------



clear all
set mat 11000
local datadir $data
use "`datadir'NuevaEspana_cajas.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure 4:	Dynamic Effect of Mining Tribunal on Civil Administration and on 
*			Tax Revenue from Trade and Agriculture (1759-1786)
*-------------------------------------------------------------------------------



* Panel A
*--------
set more off				
		xi: reg prRec														/// 
			i.year i.year*inilogtotal_c	i.cajacode 							///
			near_tabasco near_zimapan near_rosario							///				
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			F4switchtrib F3switchtrib F2switchtrib 							///
			Fswitchtrib switchtrib Lswitchtrib L2switchtrib 				///
			L3switchtrib L4tribunalm, cl(cajacode)

#delimit;
coefplot, 
	keep(F4switchtrib F3switchtrib F2switchtrib 
	Fswitchtrib switchtrib Lswitchtrib L2switchtrib L3switchtrib 
	L4tribunalm) 
	coeflabels(F4switchtrib="-4" F3switchtrib="-3" 
	F2switchtrib="-2" Fswitchtrib="-1" switchtrib="0" Lswitchtrib="1" 
	L2switchtrib="2" L3switchtrib="3" L4tribunalm="4+")
	yline(0, lp(dash)) vertical byopts(yrescale) levels(90)
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(,labsize(2.5) nogrid) ciopts(recast(rcap))
	title("") xtitle("Years Before/After the Mining Tribunal", size(3.5))
	ytitle("Change in % Administration Expenditures", size(3.5))
	xsca(noline titlegap(2) lcolor(white)) 
	ysca(noline titlegap(2) lcolor(white)) note("");
local figuresdir $figures;
graph export "`figuresdir'Figure4_a.pdf", replace;
#delimit cr;




* Panel B
*--------
set more off				
		xi: reg logComTax													/// 
			i.year i.year*inilogtotal_c	i.cajacode							///
			near_tabasco near_zimapan near_rosario							///				
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			F4switchtrib F3switchtrib F2switchtrib 							///
			Fswitchtrib switchtrib Lswitchtrib L2switchtrib 				///
			L3switchtrib L4tribunalm, cl(cajacode)

#delimit;
coefplot, 
	keep(F4switchtrib F3switchtrib F2switchtrib 
	Fswitchtrib switchtrib Lswitchtrib L2switchtrib L3switchtrib 
	L4tribunalm) 
	coeflabels( F4switchtrib="-4" F3switchtrib="-3" 
	F2switchtrib="-2" Fswitchtrib="-1" switchtrib="0" Lswitchtrib="1" 
	L2switchtrib="2" L3switchtrib="3" L4tribunalm="4+")
	yline(0, lp(dash)) vertical byopts(yrescale) levels(90)
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(-10(5)10, labsize(2.75) nogrid) 
	xlabel(,labsize(2.5) nogrid) ciopts(recast(rcap))
	title("") xtitle("Years Before/After the Mining Tribunal", size(3.5))
	ytitle("Change in Trade Revenue (log pesos)", size(3.5))
	xsca(noline titlegap(2) lcolor(white)) 
	ysca(noline titlegap(2) lcolor(white)) note("");
graph export "`figuresdir'Figure4_b.pdf", replace;
#delimit cr;


		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



