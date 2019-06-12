*********************************************************************************************
*Replication code for Oliver, Steven, Ryan Jablonski, Justin Hastings. 
*"The Tortuga Disease: The Perverse Effects of Illicit Wealth" Forthcoming International Studies Quarterly (Accepted May 2016)
*Creates Figures 2 
*Version 10 June, 2016
*********************************************************************************************

clear *
cd "<directory location>"

use RansomData.dta, clear

keep if region==1
sort year month
egen month_display = group(year month)
tsset month_display 
gen  ransom_amount_exports=  (ransom_amount_clean/puntland_exports)
tssmooth ma ma_ransom_amount_exports = ransom_amount_exports,  weights(1 <1> 1)

#delimit ;
twoway  spike ransom_amount_clean   month_display,  lcolor(black) fcolor(black) fintensity(100) 
			xlabel(0 "05" 12 "06"  24 "07" 36 "08" 48 "09" 60 "10" 72 "11" 84 "12" 96 "13",   labsize(5))
			ylabel(0 "0" 5000000 " "  10000000 "10" 15000000 " " 20000000 "20" 25000000 " " 30000000 "30", labsize(5) axis(1) glcolor(white)) 
             title("", size(6))
             subtitle(" " "" " ", size(3))
             xtitle( "Year", size(5)  )
			 ytitle( "Ransoms" "(USD million)", size(5) )
             xsca(titlegap(2))
             ysca(titlegap(2))
             scheme(s2mono) graphregion(fcolor(white))
			 xsize(5) ysize(5)
			  ;
#delimit cr

graph export "Fig1panelA.tif", width(3000) replace


#delimit ;
twoway  spike ma_ransom_amount_exports   month_display, lcolor(black) fcolor(black) fintensity(100) 
			xlabel(0 "05" 12 "06"  24 "07" 36 "08" 48 "09" 60 "10" 72 "11" 84 "12" 96 "13",   labsize(5))
			ylabel(0 "0" .5 "50" 1 "100" 1.5 "150" 2 "200" 2.5 "250"  , labsize(5) glcolor(white)) 
             title(" ", size(4))
             subtitle(" " "" " ", size(3))
             xtitle( "Year", size(5)  )
			 ytitle("Ransoms" "(% of Export Income)", size(5) )
             xsca(titlegap(2))
             ysca(titlegap(2))
             scheme(s2mono) graphregion(fcolor(white))
			 xsize(5) ysize(5)
			  ;
#delimit cr
graph export "Fig1panelB.tif", width(3000) replace

