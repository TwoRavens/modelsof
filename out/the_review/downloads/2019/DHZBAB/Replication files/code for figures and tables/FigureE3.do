*----------------------------------------
* By year of declaration (upper panel)
*----------------------------------------

use ILPAdataset, clear
drop if year_decl<1910
drop if year_decl>1923

replace yrsinusd=. if yrsinusd<0

collapse yrsinusd age_decl, by(german year_decl)

twoway  line yrsinusd year_decl if german==1, lcolor(black) xline(1917, lcolor(cranberry)) || ///
		line yrsinusd year_decl if german==0, ///
		legend(size(small) rows(2) label(1 "German") label(2 "Other")) ///
		plotregion(style(none)) ysca(titlegap(2)) lcolor(gs7) ///
		xtitle("Year of declaration", size(small)) ytitle("Years in the US at time of declaration", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
graph save FigE3a.gph, replace


twoway  line age year_decl if german==1, lcolor(black) xline(1917, lcolor(cranberry)) || ///
		line age year_decl if german==0, ///
		legend(size(small) rows(2) label(1 "German") label(2 "Other")) ///
		plotregion(style(none)) ysca(titlegap(2)) lcolor(gs7) ///
		xtitle("Year of declaration", size(small)) ytitle("Age at time of declaration", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
graph save FigE3b.gph, replace


*----------------------------------------
* By year of petition (lower panel)
*----------------------------------------

use ILPAdataset, clear
drop if year_pet<1910

replace yrsinusp=. if yrsinusp<0

collapse yrsinusp waitdp, by(german year_pet)

twoway  line yrsinusp year_pet if german==1, lcolor(black) xline(1917, lcolor(cranberry)) || ///
		line yrsinusp year_pet if german==0, ///
		legend(size(small) rows(2) label(1 "German") label(2 "Other")) ///
		plotregion(style(none)) ysca(titlegap(2)) lcolor(gs7) ///
		xtitle("Year of petition", size(small)) ytitle("Years in the US at time of petition", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
graph save FigE3c.gph, replace


twoway  line waitdp year_pet if german==1, lcolor(black) xline(1917, lcolor(cranberry)) || ///
		line waitdp year_pet if german==0, ///
		legend(size(small) rows(2) label(1 "German") label(2 "Other")) ///
		plotregion(style(none)) ysca(titlegap(2)) lcolor(gs7) ///
		xtitle("Year of petition", size(small)) ytitle("Years elapsed between declaration and petition", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))
graph save FigE3d.gph, replace


grc1leg FigE3a.gph FigE3b.gph FigE3c.gph FigE3d.gph, altshrink legendfrom(FigE3a.gph)

