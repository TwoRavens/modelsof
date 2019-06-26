***use dataset1993-2003.dta"
tsset idr year
sort idr year


*******************
***table 1 paper: Violence by province, descriptive statistics
*******************
by idr,sort: sum yconf

*******************
***table 5 paper: Variables: definitions, sources and descriptive statistics
*******************
sum yconf mvar_tmin_dec_lag mvar_tmax_dec_lag mvar_rain_dec_lag popbps grdpc_pcths hhwater hharea paddy_tons_pc_bps decent share_poors 

*******************
***table 6 paper: Reduced Form: Emergence of Violence and Climate Variables
*******************
reg yconf mvar_tmin_dec_lag mvar_rain_dec_lag lnpopbps lngrdpc_pcths_bps share_poors decent yconf_lag, cluster(idr)
reg yconf mvar_tmin_dec_lag mvar_rain_dec_lag lnpopbps lngrdpc_pcths_bps share_poors decent hharea hhwater yconf_lag, cluster(idr)
reg yconf mvar_tmin_dec_lag mvar_rain_dec_lag lngrdpc_pcths_bps share_poors decent hharea hhwater yconf_lag, cluster(idr)
reg yconf mvar_tmin_dec_lag mvar_rain_dec_lag share_poors decent hharea hhwater yconf_lag, cluster(idr)
reg yconf mvar_tmin_dec_lag mvar_rain_dec_lag lngrdpc_pcths_bps decent hharea hhwater yconf_lag, cluster(idr)

*******************
***table 7 paper: Emergence of Violence – (IV estimation, NB regression)
*******************
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps hhwater hharea share_poors decent (yconf_lag hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea decent (yconf_lag lngrdpc_pcths_bps hhwater hharea decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 

***robustness of table 7: paddy area (footnote 14 and 15)
*******************
qvf yconf yconf_lag lnpaddy_area_pc_bps lnpopbps lngrdpc_pcths_bps share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_area_pc_bps lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_area_pc_bps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_area_pc_bps hhwater hharea share_poors decent (yconf_lag hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_area_pc_bps lngrdpc_pcths_bps hhwater hharea decent (yconf_lag lngrdpc_pcths_bps hhwater hharea decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 

pwcorr lnpaddy_tons_pc_bps lnpaddy_area_pc_bps, sig 

***robustness of table 7: panel negative binomial without the instrument (footnote 16)
*******************
xtnbreg yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps share_poors decent, re
xtnbreg yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent , re
xtnbreg yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea share_poors decent , re 
xtnbreg yconf yconf_lag lnpaddy_tons_pc_bps hhwater hharea share_poors decent , re 
xtnbreg yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea decent , re 

***robustness of table 7: OLS instrumental variable (footnote 14 and 16)
*******************
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) lnpopbps lngrdpc_pcths_bps share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent , first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) lngrdpc_pcths_bps hhwater hharea share_poors decent , first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) hhwater hharea share_poors decent , first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) lngrdpc_pcths_bps hhwater hharea decent , first cluster(idr) 

*******************
***table 8 paper: IV-NB estimation, instruments in cubic form (footnote 17)
*******************
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps hhwater hharea share_poors decent (yconf_lag hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea decent (yconf_lag lngrdpc_pcths_bps hhwater hharea decent mvar_tmin_dec_lag mvar_rain_dec_lag mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu), family(nbinomial) cluster(idr) 

*******************
***table 9 paper: NB estimation, interaction of the instruments (footnote 17)
*******************
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag climax), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent climax mvar_tmin_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmin_dec_lag climax mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps hhwater hharea share_poors decent (yconf_lag hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag climax), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea decent (yconf_lag lngrdpc_pcths_bps hhwater hharea decent mvar_tmin_dec_lag mvar_rain_dec_lag climax), family(nbinomial) cluster(idr) 

********************
***table 10 paper: IV NB, Maximum temperature
********************
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps share_poors decent mvar_tmax_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr)
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent (lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmax_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmax_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps hhwater hharea share_poors decent (yconf_lag hhwater hharea share_poors decent mvar_tmax_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea decent (yconf_lag lngrdpc_pcths_bps hhwater hharea decent mvar_tmax_dec_lag mvar_rain_dec_lag), family(nbinomial) cluster(idr) 


*APPENDIX:
***Appendix 2 (first stages only)
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) lnpopbps lngrdpc_pcths_bps share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) lngrdpc_pcths_bps hhwater hharea share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) hhwater hharea share_poors decent, first cluster(idr)  
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag) lngrdpc_pcths_bps hhwater hharea decent, first cluster(idr)  

*robustness with cubic instrument (footnote 19)

ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu) lnpopbps lngrdpc_pcths_bps share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu) lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu) lngrdpc_pcths_bps hhwater hharea share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu) hhwater hharea share_poors decent, first cluster(idr)  
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag_cu mvar_rain_dec_lag_cu) lngrdpc_pcths_bps hhwater hharea decent, first cluster(idr)  

*robustness with interacted instrument (footnote 19)
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag climax) lnpopbps lngrdpc_pcths_bps share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag climax) lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag climax) lngrdpc_pcths_bps hhwater hharea share_poors decent, first cluster(idr) 
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag climax) hhwater hharea share_poors decent, first cluster(idr)  
ivreg2 yconf yconf_lag (lnpaddy_tons_pc_bps=mvar_tmin_dec_lag mvar_rain_dec_lag climax) lngrdpc_pcths_bps hhwater hharea decent, first cluster(idr)  
******************************
*tabel Appendix 3: iv poisson*
******************************
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(poisson) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lnpopbps lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(poisson) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea share_poors decent (yconf_lag lngrdpc_pcths_bps hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(poisson) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps hhwater hharea share_poors decent (yconf_lag hhwater hharea share_poors decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(poisson) cluster(idr) 
qvf yconf yconf_lag lnpaddy_tons_pc_bps lngrdpc_pcths_bps hhwater hharea decent (yconf_lag lngrdpc_pcths_bps hhwater hharea decent mvar_tmin_dec_lag mvar_rain_dec_lag), family(poisson) cluster(idr) 

******************************
******************************
******************************
******************************
******************************
