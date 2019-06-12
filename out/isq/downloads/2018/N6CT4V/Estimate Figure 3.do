*********************************************************************************************
*Replication code for Oliver, Steven, Ryan Jablonski, Justin Hastings. 
*"The Tortuga Disease: The Perverse Effects of Illicit Wealth" Forthcoming International Studies Quarterly (Accepted May 2016)
*Creates Figure 3
*Version 10 June, 2016
*********************************************************************************************

clear *
cd "<directory location>"

use RansomsByYear.dta, clear

tsset year 
g puntland_exports_index = 0
g somaliland_exports_index = 0
sum puntland_exports if year==2002
replace puntland_exports_index = puntland_exports-`r(mean)'
sum somaliland_exports if year==2002
replace somaliland_exports_index = somaliland_exports-`r(mean)'


#delimit ;
twoway   line puntland_exports_index   year if year>2001 & year<2013, yaxis(1) lwidth(thick) lcolor(black) fcolor(black) lpattern(solid) 
		|| line somaliland_exports_index   year  if year>2001 & year<2013, yaxis(1) lwidth(thick) lcolor(black) fcolor(black) lpattern(dash) 
		xlabel(2002 "02" 2003 "03" 2004 "04" 2005 "05" 2006 "06" 2007 "07"  2008 "08" 2009 "09" 2010 "10" 2011 "11" 2012 "12" 2012.5 " ",   labsize(5))
		ylabel( -1000000  "-1"  0 "0" 1000000 "1" 2000000 "2" 3000000 "3" 3500000 " ", labsize(5) axis(1) glcolor(white))
			 title(" ", size(4))
             subtitle( "Livestock Exports, 2002-2002", size(6))
             xtitle( "Year", size(5)  )
			 ytitle("Change in Exports (mil. head)" "(2002=0)", size(5) axis(1))
             xsca(titlegap(2))
             ysca(titlegap(2))
             scheme(s2mono) graphregion(fcolor(white))
			 xsize(5) ysize(3)
			 graphregion( fcolor(white) style(none)  color(white) )
			 legend(order(1 "Puntland" 2 "Somaliland") size(5) position(10) ring(0) region(lcolor(white)))
			  ;
#delimit cr

graph export "Figure 3.tif", width(3000) replace