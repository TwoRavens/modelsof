use TTG_dataset_ii_2016, clear

/* Table 1 */
tab pat_pc trust, row

/* Table 3 */
tab approval


/* Figure 1 */
# delimit ;
reg approval T_economy_inter ;
coefplot, yline(0) ylabel(-0.4(0.1)0.2,nogrid) drop(_cons) level(90) vertical 
	rename(_cons = Constant) ciopts(lcolor(red))
	title("") ytitle("Treatment Effect") xlabel(1 "Interdependence Treatment")
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) ;

/* Figure 2 */
# delimit ;
reg approval T_economy_inter_hi_low ;
coefplot, yline(0) ylabel(-0.4(0.1)0.2,nogrid) drop(_cons) level(90) vertical 
	rename(_cons = Constant) ciopts(lcolor(red))
	title("") ytitle("Treatment Effect") xlabel(1 "High Interdependence Treatment")
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) ;


#delimit ;
reg approval T_trend ;
coefplot, yline(0) ylabel(-0.4(0.1)0.2,nogrid) drop(_cons) level(90) vertical 
	rename(_cons = Constant) ciopts(lcolor(red))
	title("") ytitle("Treatment Effect") xlabel(1 "Increasing Trend Treatment")
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) ;
	

# delimit ;
reg approval T_crucial ;
coefplot, yline(0) ylabel(-0.4(0.1)0.2,nogrid) drop(_cons) level(90) vertical 
	rename(_cons = Constant) ciopts(lcolor(red))
	title("") ytitle("Treatment Effect") xlabel(1 "Crucial Trade Treatment")
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) ;

#delimit ;
reg approval T_economy_dependence ;
coefplot, yline(0) ylabel(-0.4(0.1)0.2,nogrid) drop(_cons) level(90) vertical 
	rename(_cons = Constant) ciopts(lcolor(red))
	title("") ytitle("Treatment Effect") xlabel(1 "Dependence Treatment")
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) ;
