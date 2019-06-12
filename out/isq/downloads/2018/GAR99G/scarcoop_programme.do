clear
cd C:\data

use scarcoop_dataset

program drop _all

program define errorplot
predict xb, xb
predict res, resid
plot res xb
drop res xb
end

program define regfitcoeff

/*--------------full model--------------------*/ 
local ll_beta=e(ll) 
local n=e(N) /*---get number of correctly specified obs---*/ 
predict mu if e(sample) 
gen cnt=(mu>=0.5) if e(sample) 
count if cnt==numtreaties&e(sample) 
local count=r(N) 

/*---------constant-only model----------------*/ 
glm numtreaties if e(sample),robust
local ll_alpha=e(ll) 
/*----------compute measures------------------*/ 
local mcfad=1-(`ll_beta'/`ll_alpha')
local cragg=(1-(exp(`ll_alpha')/exp(`ll_beta'))^(2/`n'))/(1-(exp(`ll_alpha'))^(2/`n'))
local maddala=`count'/`n'
di in yellow "McFadden LR index = " `mcfad'
di in yellow "Cragg and Uhler normed measure = " `cragg'
di in yellow "Count (Maddala) R2 = " `maddala'
macro drop _all
drop mu cnt
/***end do file***/
end


program define mimpacts_slopewatsca
display "mimpacts_slope" 
nlcom (slope_watsca: _b[slope_watsca] + 2*_b[slope_watsca2]*Mslope_watsca)
end

program define mimpacts_intwatsca
display "mimpacts_slope" 
nlcom (int_watsca: _b[int_watsca] + 2*_b[int_watsca2]*Mint_watsca)
end

program define mimpacts_trd2imf 
display "mtrd2imf" 
nlcom (trd2imf: _b[trd2imf] + 2*_b[trd2imf2]*Mtrd2imf)
end

program define mimpacts_trd1imf 
display "mtrd1imf" 
nlcom (trd1imf: _b[trd1imf] + 2*_b[trd1imf2]*Mtrd1imf)
end

program define mimpacts_trd2un 
display "mtrd2un" 
nlcom (trd2un: _b[trd2un] + 2*_b[trd2un2]*Mtrd2un)
end

program define mimpacts_trd1un 
display "mtrd1un" 
nlcom (trd1un: _b[trd1un] + 2*_b[trd1un2]*Mtrd1un)
end


sum int_watsca slope_watsca corruption_cntry1 corruption_cntry2 ecnpowr welpowr bordercreator crossborder ///
	trd2imf trd2un trd1imf trd1un mildispu diprela1 treaty numtreaties share_wq M* numtreaties_wq wtrallociss  

label variable	int_watsca "Water scarcity intercept"
label variable int_watsca2   "Water scarcity intercept Squared"  
label variable	slope_watsca "Water scarcity slope"
label variable	slope_watsca2   "Water scarcity slope Squared"
label variable	corruption_cntry1 "Country 1 governance"
label variable corruption_1_2 "Country 1 governance Squared"
label variable	corruption_cntry2 "Country 2 governance"
label variable	ecnpowr	"Economic power"
label variable	welpowr	"Welfare power"
label variable	bordercreator	"Border-creator"
label variable	crossborder	"Through-border"
label variable	trd2imf	"Trade dependency (IMF)"
label variable	trd2imf2 "Trade dependency (IMF) Squared"
label variable	trd2un	"Trade dependency (UN)"
label variable 	trd2un2 	"Trade dependency (UN) Squared"
label variable	trd1imf	"Trade importance (IMF)"
label variable	trd1imf2 "Trade importance (IMF) Squared"
label variable	trd1un	"Trade importance (UN)"
label variable	trd1un2 "Trade importance (UN) Squared"
label variable	mildispu "Militarized disputes"
label variable	diprela1 "Diplomatic relations"
label variable	treaty "Treaty/no-treaty"
label variable	numtreaties "Number of treaties"
label variable	share_wq "Share of water allocation issues"
label variable 	Mslope_wat~a "Mean - Water scarcity slope"
label variable 	Mint_watsca "Mean-Water scarcity intercept" 
label variable 	Mtrd2imf "Mean- Mean-Trade dependency (IMF)"
label variable 	Mtrd1imf "Mean-Trade importance (IMF)"
label variable 	Mtrd2un "Mean-Trade dependency (UN)"
label variable 	Mtrd1un "Mean--Trade importance (UN)" 
label variable 	numtreaties_wq  "Number of treaties with water allocation issues"
label variable 	wtrallociss "water allocation issues"



/*TABLE 1*/

glm numtreaties slope_watsca slope_watsca2, robust 
est store tab1_1
mfx
mimpacts_slopewatsca
*regplot


glm numtreaties  int_watsca  int_watsca2 , robust
est store tab1_2
mfx
mimpacts_intwatsca
*regplot


/*TABLE 2*/

sum  

logit treaty int_watsca int_watsca2  crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1un trd1un2 mildispu ecnpowr diprela1, robust
estat class
est store tab2_1
mfx
mimpacts_intwatsca
mimpacts_trd1un

logit treaty int_watsca int_watsca2  crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2  ///
	trd1un trd1un2 mildispu welpowr diprela1, robust
estat class
est store tab2_2
mfx
mimpacts_intwatsca
mimpacts_trd1un

logit treaty int_watsca int_watsca2  crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2 mildispu ecnpowr diprela1, robust
estat class
est store tab2_3
mfx
mimpacts_intwatsca
mimpacts_trd1imf


logit treaty int_watsca int_watsca2  crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2 mildispu welpowr diprela1
estat class
est store tab2_4
mfx
mimpacts_intwatsca
mimpacts_trd1imf

/*TABLE 3*/

glm numtreaties int_watsca int_watsca2  crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2, robust
regfitcoeff
glm numtreaties int_watsca int_watsca2  crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2, robust
est store tab3_1
mfx
mimpacts_intwatsca
mimpacts_trd1imf

glm  numtreaties int_watsca  int_watsca2 crossborder bordercreator  corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2, robust
regfitcoeff
glm  numtreaties int_watsca  int_watsca2 crossborder bordercreator  corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2, robust
est store tab3_2
mfx
mimpacts_intwatsca
mimpacts_trd2imf

glm numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2 mildispu welpowr diprela1, robust
regfitcoeff
glm numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2 mildispu welpowr diprela1, robust
est store tab3_3
mfx
mimpacts_intwatsca
mimpacts_trd2imf

glm  numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2, robust
regfitcoeff
glm  numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2, robust
est store tab3_4
mfx
mimpacts_intwatsca
mimpacts_trd1imf

glm  numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2, robust
regplot, plottype(qfit)



regress numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2, robust
est store tab3_4ols
mfx
mimpacts_intwatsca
mimpacts_trd1imf


glm numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2, robust
regfitcoeff
glm numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2, robust
est store tab3_5
mfx
mimpacts_intwatsca
mimpacts_trd2imf


regress numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2, robust
est store tab3_5ols
mfx
mimpacts_intwatsca
mimpacts_trd2imf

glm numtreaties slope_watsca slope_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2 mildispu ecnpowr, robust
regfitcoeff
glm numtreaties slope_watsca slope_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2 mildispu ecnpowr, robust
est store tab3_6
mfx
mimpacts_slopewatsca
mimpacts_trd1imf


regress numtreaties slope_watsca slope_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1imf trd1imf2 mildispu ecnpowr, robust
est store tab3_6ols
mfx
mimpacts_slopewatsca
mimpacts_trd1imf



/*TABLE 4*/

regress  numtreaties int_watsca  int_watsca2 crossborder bordercreator ///
	corruption_1_2 trd2imf trd2imf2 if treaty==1, robust
est store tab4_1
mfx
mimpacts_intwatsca
mimpacts_trd2imf

poisson numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_1_2 trd2imf trd2imf2  if treaty==1, robust
est store tab4_1pois
mfx
mimpacts_intwatsca
mimpacts_trd2imf


regress  numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2un trd2un2  if treaty==1, robust
est store tab4_2
mfx
mimpacts_intwatsca
mimpacts_trd2un

poisson numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2un trd2un2   if treaty==1, robust
est store tab4_2pois
mfx
mimpacts_intwatsca
mimpacts_trd2un


regress  numtreaties slope_watsca slope_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2 mildispu   if treaty==1, robust
est store tab4_3
mfx
mimpacts_slopewatsca
mimpacts_trd2imf

poisson numtreaties slope_watsca slope_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2 mildispu   if treaty==1, robust
est store tab4_3pois
mfx
mimpacts_slopewatsca
mimpacts_trd2imf


regress numtreaties slope_watsca slope_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2 mildispu ecnpowr   if treaty==1, robust
est store tab4_4
mfx
mimpacts_slopewatsca
mimpacts_trd2imf

poisson numtreaties slope_watsca slope_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2 mildispu ecnpowr  if treaty==1, robust
est store tab4_4pois
mfx
mimpacts_slopewatsca
mimpacts_trd2imf



/*TABLE 5*/

poisson numtreaties  int_watsca  int_watsca2 crossborder bordercreator corruption_1_2 trd2imf trd2imf2 if treaty==1 & numtreaties_wq>0 , robust
est store tab5_1
mfx
mimpacts_intwatsca
mimpacts_trd2imf

regress numtreaties  int_watsca  int_watsca2 crossborder bordercreator corruption_1_2 trd2imf trd2imf2 if treaty==1 & numtreaties_wq>0 , robust
est store tab5_1ols
mfx
mimpacts_intwatsca
mimpacts_trd2imf

poisson numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_1_2 trd2un trd2un2 if treaty==1 & numtreaties_wq>0 , robust
est store tab5_2
mfx
mimpacts_intwatsca
mimpacts_trd2un

regress numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_1_2 trd2un trd2un2 if treaty==1 & numtreaties_wq>0 , robust
est store tab5_2ols
mfx
mimpacts_intwatsca
mimpacts_trd2un

poisson numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1un trd1un2 ecnpowr if treaty==1 & numtreaties_wq>0 , robust
est store tab5_3
mfx
mimpacts_intwatsca
mimpacts_trd1un

regress numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1un trd1un2 ecnpowr if treaty==1 & numtreaties_wq>0 , robust
est store tab5_3ols
mfx
mimpacts_intwatsca
mimpacts_trd1un


poisson numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2 mildispu if treaty==1 & numtreaties_wq>0 , robust
est store tab5_4
mfx
mimpacts_intwatsca
mimpacts_trd2imf

regress numtreaties int_watsca  int_watsca2 crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd2imf trd2imf2 mildispu if treaty==1 & numtreaties_wq>0 , robust
est store tab5_4ols
mfx
mimpacts_intwatsca
mimpacts_trd2imf


regress wtrallociss  int_watsca int_watsca2  crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1un trd1un2 if treaty==1 & share_wq>0 , robust
est store tab5_5
mfx
mimpacts_intwatsca
mimpacts_trd1un

poisson wtrallociss  int_watsca int_watsca2  crossborder bordercreator corruption_cntry1 corruption_cntry2 corruption_1_2 ///
	trd1un trd1un2 if treaty==1 & share_wq>0 , robust
est store tab5_5pois
mfx
mimpacts_intwatsca
mimpacts_trd1un



/*TABLE 1*/
est table tab1_1  tab1_2, star (0.05 0.01 .001) stats(N r2 F ) b(%9.4f)

/*TABLE 2*/
est table tab2_1  tab2_2 tab2_3 tab2_4, star (0.05 0.01 .001) stats(N r2 F ) b(%9.4f)

/*TABLE 3*/
est table tab3_1  tab3_2 tab3_3 tab3_4 tab3_5 tab3_6, star (0.05 0.01 .001) stats(N r2 F ) b(%9.4f)

/*TABLE 3- OLS VERSIONS*/
est table tab3_4ols tab3_5ols tab3_6ols, star (0.05 0.01 .001) stats(N r2 F ) b(%9.4f)

/*TABLE 4*/
est table tab4_1  tab4_2 tab4_3 tab4_4, star (0.05 0.01 .001) stats(N r2 F ) b(%9.4f)

/*TABLE 4- POISSON VERSIONS*/
est table tab4_1pois  tab4_2pois tab4_3pois tab4_4pois, star (0.05 0.01 .001) stats(N r2 F ) b(%9.4f)

/*TABLE 5*/
est table tab5_1  tab5_2 tab5_3 tab5_4 , star (0.05 0.01 .001) stats(N r2 F ) b(%9.4f)

/*TABLE 5- OLS VERSIONS*/
est table tab5_1ols  tab5_2ols tab5_3ols tab5_4ols , star (0.05 0.01 .001) stats(N r2 F ) b(%9.4f)

est table tab5_5 tab5_5pois, star (0.05 0.01 .001) stats(N r2 F ) b(%9.4f)



