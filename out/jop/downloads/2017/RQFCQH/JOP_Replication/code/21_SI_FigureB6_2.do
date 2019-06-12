

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Figure B.6.2: Dynamic 
	**					Effect of Mining Tribunal on the Indian 
	**					Poll Tax
	**					
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
local datadir $data
use "`datadir'NuevaEspana_cajas_Bourbon.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure B.6.2: Dynamic Effect of Mining Tribunal on the Indian Poll Tax
*-------------------------------------------------------------------------------


* Panel A
*--------
set more off				
		xi: reg logtributo													/// 
			i.year i.year*inilogtotal_c	i.cajacode							///
			near_tabasco near_zimapan near_rosario							///				
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			F4switchtrib F3switchtrib F2switchtrib 							///
			Fswitchtrib switchtrib Lswitchtrib L2switchtrib 				///
			L3switchtrib L4tribunalm										///
			if CarlosIIIReign==1, cl(cajacode)
	
#delimit;
coefplot, 
	keep( F4switchtrib F3switchtrib F2switchtrib 
	Fswitchtrib switchtrib Lswitchtrib L2switchtrib L3switchtrib 
	 L4tribunalm) 
	coeflabels( F4switchtrib="-4" F3switchtrib="-3" 
	F2switchtrib="-2" Fswitchtrib="-1" switchtrib="0" Lswitchtrib="1" 
	L2switchtrib="2" L3switchtrib="3"  L4tribunalm="4+")
	yline(0, lp(dash)) vertical byopts(yrescale) levels(90)
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(,labsize(2.5) nogrid) ciopts(recast(rcap))
	title("") xtitle("Years Before/After the Mining Tribunal", size(3.5))
	ytitle("Change in Income From Indian Poll Tax (log pesos)", size(3.5))
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("");
local figuresdir $figures;
graph export "`figuresdir'FigureB6_2_a.pdf", replace;
#delimit cr;


* Panel B
*--------			
		xi: reg logtributo													/// 
			i.year i.year*inilogtotal_c	i.cajacode							///
			near_tabasco near_zimapan near_rosario							///				
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			F4switchtrib F3switchtrib F2switchtrib 							///
			Fswitchtrib switchtrib Lswitchtrib L2switchtrib 				///
			L3switchtrib L4tribunalm, cl(cajacode)
	
#delimit;
coefplot, 
	keep( F4switchtrib F3switchtrib F2switchtrib 
	Fswitchtrib switchtrib Lswitchtrib L2switchtrib L3switchtrib 
	 L4tribunalm) 
	coeflabels( F4switchtrib="-4" F3switchtrib="-3" 
	F2switchtrib="-2" Fswitchtrib="-1" switchtrib="0" Lswitchtrib="1" 
	L2switchtrib="2" L3switchtrib="3"  L4tribunalm="4+")
	yline(0, lp(dash)) vertical byopts(yrescale) levels(90)
	graphregion(fcolor(white) lcolor(white) margin(small))
	plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
	scheme(s2mono) 	ylabel(, labsize(2.75) nogrid) 
	xlabel(,labsize(2.5) nogrid) ciopts(recast(rcap))
	title("") xtitle("Years Before/After the Mining Tribunal", size(3.5))
	ytitle("Change in Income From Indian Poll Tax (log pesos)", size(3.5))
	xsca(noline titlegap(2) lcolor(white)) 
	ysca( noline titlegap(2) lcolor(white)) note("");
graph export "`figuresdir'FigureB6_2_b.pdf", replace;
#delimit cr;



		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



