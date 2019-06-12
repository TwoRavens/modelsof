/**************************************************************/
/*  Bidding for aid-for-policy deals  (January 2015)
Expanding on 2007 JCR paper by looking for when single bidder versus multiple bidders */ 
/* BdM and Smith February 2004: use logic data and greenbook data (http://qesdb.cdie.org/gbk) */
/* Test predictions of formal model */ 
/**************************************************************/

#delimit;
clear; set mem 80m; set more off;
 ; 

/* use data directly from 2007 jcr paper with the 
addition UN affintiy score for UNGA voting and US and 
USSr tauB score from Eugene*/ 


#delimit;
use Aid_Bidding_data_August2015;

drop if ccode==2 | ccode==.;

sort ccode year;
tsset ccode year;

gen LlnGDP=L.lnGDP;
gen LlnEaid=L.lnEaid;
gen LlnTaid=L.lnTaid;
gen LEaid=L.Eaid;
gen LTaid=L.Taid; 
gen WLlnGDP=W*LlnGDP;
gen WlnPOP=W*lnPOP;
gen time=year-1980; 
gen time2=time^2;
tsset ccode year;
gen LW=L.W;
gen  LlnPOP=L.lnPOP;
capture gen anyaid=(lnEaid>0&lnEaid~=.);
 

#delimit;
gen  ColdWar=year>=1955&year<=1989;
gen Tperiod=1 if year<1955; 
replace Tperiod=2 if ColdWar==1; 
replace Tperiod=3 if year>1989; 
gen rival=0 if Tp==1;
replace rival=1 if Tp==2 |Tp==3;

 
tsset ccode year;
gen laglnEaid=L1.lnEaid;


/*****************************/
/* Table 1 */ 
/*****************************/

#delimit;
tab anyaid Tperiod if s3un4608~=., col all;
tab anyaid Tperiod if s3un4608~=. &Tp<3 , col all;
tab anyaid Tperiod if s3un4608~=. &Tp>1 , col all;
tab anyaid Tperiod if s3un4608~=. &(Tp==1|Tp==3) , col all;

#delimit;
 ttest lnEaid if lnEaid>0 &Tperiod <3 &s3un4608~=.&tau~=., by(Tperiod);
  ttest lnEaid if lnEaid>0& Tperiod >1& s3un4608~=.&tau~=., by(Tperiod);
    ttest lnEaid if lnEaid>0& Tperiod ~=2&s3un4608~=.&tau~=., by(Tperiod);
	ranksum lnEaid if lnEaid>0 &Tperiod <3 &s3un4608~=.&tau~=., by(Tperiod);
  ranksum lnEaid if lnEaid>0& Tperiod >1& s3un4608~=.&tau~=., by(Tperiod);
   ranksum lnEaid if lnEaid>0& Tperiod ~=2&s3un4608~=.&tau~=., by(Tperiod); 


ttest   tau if Tperiod==1 , by(anyaid);
 ranksum tau if Tperiod==1 , by(anyaid)  ;
 ttest   tau if Tperiod==2 , by(anyaid);
 ranksum tau if Tperiod==2 , by(anyaid) ;
  ttest   tau if Tperiod==3 , by(anyaid);
 ranksum tau if Tperiod==3 , by(anyaid)    ;
   
  #delimit; 
ttest   s3un4608 if Tperiod==1 , by(anyaid);
 ranksum s3un4608 if Tperiod==1 , by(anyaid)  ;
 ttest   s3un4608 if Tperiod==2 , by(anyaid);
 ranksum s3un4608 if Tperiod==2 , by(anyaid) ;
  ttest   s3un4608 if Tperiod==3 , by(anyaid);
 ranksum s3un4608 if Tperiod==3 , by(anyaid) ;
   


#delimit;


/*****************************/
/* Table 2 */ 
/*****************************/

regr lnEaid  LW  LlnGDP LlnPOP logdstab  tau s3un4608  if lnEaid>0 & lnEaid~=. &Tperiod==1 ,  cluster(ccode);
estimates store m1, title(Model 1);test tau s3un4608; test tau +s3un4608==0;
regr lnEaid  LW  LlnGDP LlnPOP  tau s3un4608 logdstab  if lnEaid>0 & lnEaid~=. &Tperiod==2 ,  cluster(ccode);
estimates store m2, title(Model 2);test tau s3un4608; test tau +s3un4608==0;
regr lnEaid  LW  LlnGDP LlnPOP  tau s3un4608 logdstab  if lnEaid>0 & lnEaid~=. &Tperiod==3 ,  cluster(ccode);
estimates store m3, title(Model 3);test tau s3un4608; test tau +s3un4608==0;
#delimit;
estout m1 m2 m3 , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
	varlabel(_cons	Constant LW \$W_{t-1}$  LlnGDP \$ln(GDPpc_{t-1})$
	LlnPOP \$ln(Population_{t-1})$  tau \$SecurityAlignment$ s3un4608 \$UNvoting$ logdstab  \$ln(distance)$ )
   	stats(N  , fmt(%9.0f) ) ///
   	style(tex);
stop;
regr lnEaid  LW  LlnGDP LlnPOP logdstab  s3un4608  if lnEaid>0 & lnEaid~=. &Tperiod==1 ,  cluster(ccode);
estimates store m1, title(Model 1);
regr lnEaid  LW  LlnGDP LlnPOP   s3un4608 logdstab  if lnEaid>0 & lnEaid~=. &Tperiod==2 ,  cluster(ccode);
estimates store m2, title(Model 2);
regr lnEaid  LW  LlnGDP LlnPOP   s3un4608 logdstab  if lnEaid>0 & lnEaid~=. &Tperiod==3 ,  cluster(ccode);
estimates store m3, title(Model 3);

/*Magnitude of aid */
#delimit;
capture drop b1 b2 b3 b4 b5 b6 b7;
estsimp regr lnEaid  LW  LlnGDP LlnPOP logdstab  s3un4608  if lnEaid>0 & lnEaid~=. &Tperiod==1 ,  cluster(ccode);
setx  (LlnGDP LlnPOP logdstab  s3un4608 ) mean  (LW) 0;
simqi;
setx LW 1;
simqi;
 capture drop b1 b2 b3 b4 b5 b6 b7;
estsimp regr lnEaid  LW  LlnGDP LlnPOP logdstab  s3un4608  if lnEaid>0 & lnEaid~=. &Tperiod==2 ,  cluster(ccode);
setx  (LlnGDP LlnPOP logdstab  s3un4608 ) mean  (LW) 0;
simqi;
setx LW 1;
simqi;
capture drop b1 b2 b3 b4 b5 b6 b7;
estsimp regr lnEaid  LW  LlnGDP LlnPOP logdstab  s3un4608  if lnEaid>0 & lnEaid~=. &Tperiod==3 ,  cluster(ccode);
setx  (LlnGDP LlnPOP logdstab  s3un4608 ) mean  (LW) 0;
simqi;
setx LW 1;
simqi;
capture drop b1 b2 b3 b4 b5 b6 b7;

/*****************************/
/* Table 4 */ 
/*****************************/
/* matching */

/* Models to Report */ 

#delimit; 
teffects psmatch (lnEaid) (ColdWar LW  LlnGDP LlnP  s3un4608 ) if (Tperiod==1|Tperiod==2);
#delimit; 
teffects psmatch (lnEaid) (ColdWar LW  LlnGDP LlnP  s3un4608 ) if (Tperiod==1|Tperiod==2) &LW==1 ;
#delimit; 
teffects psmatch (lnEaid) (ColdWar LW  LlnGDP LlnP  s3un4608 ) if (Tperiod==1|Tperiod==2) &LW<1 ;



#delimit; 
teffects psmatch (s3un4608 ) (ColdWar LW  LlnGDP LlnP  s3un4608 lnE) if (Tperiod==1|Tperiod==2);
#delimit; 
teffects psmatch (s3un4608 ) (ColdWar LW  LlnGDP LlnP  s3un4608 lnE) if (Tperiod==1|Tperiod==2) &LW==1 ;
#delimit; 
teffects psmatch (s3un4608 ) (ColdWar LW  LlnGDP LlnP  s3un4608 lnE) if (Tperiod==1|Tperiod==2) &LW<1 ;

 
/* Compare Pre-Cold war with early Cold War as diff in diff */ 

/* Average presence of aid in each period*/ 
sort ccode year;
by ccode: egen mAnyAidPre=mean(anyaid) if  year<1955 & year>1945 & s3un4608~=.;
by ccode: egen mAnyAidPre2=mean(anyaid) if  year<1955 & year>1945 & W~=.;
by ccode: egen mAnyAidPre3=mean(anyaid) if  year<1955 & year>1945 ;
by ccode: egen mAnyAidearly=mean(anyaid) if  year>=1955 & year<1965 & s3un4608~=.;
by ccode: egen mAnyAidearly2=mean(anyaid) if  year>=1955 & year<1965 & W~=.;
by ccode: egen mAnyAidearly3=mean(anyaid) if  year>=1955 & year<1965 ;

/* Average amount of aid in each period */ 
by ccode: egen mlnEPreq=mean(exp(lnE)) if  year<1955 & year>1945;
replace mlnEPre=log(mlnEPre);
by ccode: egen mlnEearly=mean(exp(lnE)) if  year>=1955 & year<1965;
replace mlnEearly=log(mlnEearly);


gen difflnE=mlnEearly-mlnEPre[_n-1] if year==1955 & ccode==ccode[_n-1] & year[_n-1]<1955;



/************************************/
/*********** Table 3 ****************/
/************************************/
/******** Simple Regression Framework *********/
 

reg difflnE  ;
estimates store d4, title(Model 4);
reg difflnE W   /********* LOVE this one ******/ ;
estimates store d5, title(Model 5);
reg difflnE W lnGDP lnPOP ;
estimates store d6, title(Model 6);
 
#delimit;
estout d4 d5 d6 , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
	varlabel(_cons	ConstantLW \$W$  lnGDP \$ln(GDPpc)$
	lnPOP \$ln(Population)$  )
   	stats(N  , fmt(%9.0f) ) ///
   	style(tex);
	


