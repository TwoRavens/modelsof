# delimit ;
clear;
*version 12;
set matsize 400;
set more off;



log using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Duration/Distribution/PostEstimation/PredictedValues.log", replace;

***********************************************************************************;
*Author: Jeff Carter                                                              *;
*Date: Wednesday, December 10, 2014                                                   *;
*Purpose: Predicted Distribution with Duration                                    *;
***********************************************************************************;



use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Duration/Distribution/PostEstimation/SimData.dta", clear;

postutil clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 prob_hat2 lo2 hi2  prob_hat3 lo3 hi3 prob_hat4 lo4 hi4 prob_hat5 lo5 hi5 prob_hat6 lo6 hi6
                prob_hat7 lo7 hi7 prob_hat8 lo8 hi8 prob_hat9 lo9 hi9 prob_hat10 lo10 hi10  diff_hat diff_lo diff_hi
                probd_hat0 dlo0 dhi0 probd_hat1 dlo1 dhi1 probd_hat2 dlo2 dhi2  probd_hat3 dlo3 dhi3 probd_hat4 dlo4 dhi4 probd_hat5 dlo5 dhi5 probd_hat6 dlo6 dhi6
                probd_hat7 dlo7 dhi7 probd_hat8 dlo8 dhi8 probd_hat9 dlo9 dhi9 probd_hat10 dlo10 dhi10  diffd_hat diffd_lo diffd_hi
                diff0 diff0_lo diff0_hi diff1 diff1_lo diff1_hi diff2 diff2_lo diff2_hi diff3 diff3_lo diff3_hi diff4 diff4_lo diff4_hi diff5 diff5_lo diff5_hi
                diff6 diff6_lo diff6_hi diff7 diff7_lo diff7_hi diff8 diff8_lo diff8_hi diff9 diff9_lo diff9_hi diff10 diff10_lo diff10_hi using PredictedValues,
replace;

noisily display "start";


local a=0 ;
while `a' < .1 { ;

{;


scalar h_AutLag=   77.41446  ;
scalar h_DemLag= 85.92596  ;
scalar h_Duration = 0;
scalar h_Polity = 0;
scalar h_PolityDuration =0;
scalar h_Cap =0.007137105;
scalar h_GDPpc =8.203136;
scalar h_Number=3;
scalar h_Constant = 1;
scalar h_RPC =0.9622963;
scalar h_RelCap=0.6661795;



generate x_betahat0 = MG_b1*h_AutLag
    + MG_b2*h_AutLag
    + MG_b3*h_Duration
    + MG_b4*(h_Duration)
    + MG_b5*(h_Duration)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahat1 = MG_b1*x_betahat0
    + MG_b2*h_AutLag
    + MG_b3*(h_Duration+.1)
    + MG_b4*(h_Duration+.1)
    + MG_b5*(h_Duration+.1)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahat2 = MG_b1*x_betahat1
    + MG_b2*x_betahat0
    + MG_b3*(h_Duration+.2)
    + MG_b4*(h_Duration+.4)
    + MG_b5*(h_Duration+.8)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;

generate x_betahat3 = MG_b1*x_betahat2
    + MG_b2*x_betahat1
    + MG_b3*(h_Duration+.3)
    + MG_b4*(h_Duration+.9)
    + MG_b5*(h_Duration+2.7)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;

generate x_betahat4 = MG_b1*x_betahat3
    + MG_b2*x_betahat2
    + MG_b3*(h_Duration+.4)
    + MG_b4*(h_Duration+1.6)
    + MG_b5*(h_Duration+6.4)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;

generate x_betahat5 = MG_b1*x_betahat4
    + MG_b2*x_betahat3
    + MG_b3*(h_Duration+.5)
    + MG_b4*(h_Duration+2.5)
    + MG_b5*(h_Duration+12.5)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;

generate x_betahat6 = MG_b1*x_betahat5
    + MG_b2*x_betahat4
    + MG_b3*(h_Duration+.6)
    + MG_b4*(h_Duration+3.6)
    + MG_b5*(h_Duration+21.6)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahat7 = MG_b1*x_betahat6
    + MG_b2*x_betahat5
    + MG_b3*(h_Duration+.7)
    + MG_b4*(h_Duration+4.9)
    + MG_b5*(h_Duration+34.3)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;

generate x_betahat8 = MG_b1*x_betahat7
    + MG_b2*x_betahat6
    + MG_b3*(h_Duration+.8)
    + MG_b4*(h_Duration+6.4)
    + MG_b5*(h_Duration+51.2)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;

generate x_betahat9 = MG_b1*x_betahat8
    + MG_b2*x_betahat7
    + MG_b3*(h_Duration+.9)
    + MG_b4*(h_Duration+8.1)
    + MG_b5*(h_Duration+72.9)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;

generate x_betahat10 = MG_b1*x_betahat9
    + MG_b2*x_betahat8
    + MG_b3*(h_Duration+1)
    + MG_b4*(h_Duration+10)
    + MG_b5*(h_Duration+100)
    + MG_b6*h_Polity
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;





generate x_betahatd0 = MG_b1*h_DemLag
    + MG_b2*h_DemLag
    + MG_b3*h_Duration
    + MG_b4*(h_Duration)
    + MG_b5*(h_Duration)
    + MG_b6*(h_Polity+20)
    + MG_b7*h_PolityDuration
    + MG_b8*(h_PolityDuration)
    + MG_b9*(h_PolityDuration)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;



 
generate x_betahatd1 = MG_b1*x_betahatd0
    + MG_b2*h_DemLag
    + MG_b3*(h_Duration+.1)
    + MG_b4*(h_Duration+.1)
    + MG_b5*(h_Duration+.1)
    + MG_b6*(h_Polity+20)
    + MG_b7*(2)
    + MG_b8*(2)
    + MG_b9*(2)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;



generate x_betahatd2 = MG_b1*x_betahatd1
    + MG_b2*x_betahatd0
    + MG_b3*(h_Duration+.2)
    + MG_b4*(h_Duration+.4)
    + MG_b5*(h_Duration+.8)
    + MG_b6*(h_Polity+20)
    + MG_b7*(4)
    + MG_b8*(8)
    + MG_b9*(16)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahatd3 = MG_b1*x_betahatd2
    + MG_b2*x_betahatd1
    + MG_b3*(h_Duration+.3)
    + MG_b4*(h_Duration+.9)
    + MG_b5*(h_Duration+2.7)
    + MG_b6*(h_Polity+20)
    + MG_b7*(6)
    + MG_b8*(18)
    + MG_b9*(54)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahatd4 = MG_b1*x_betahatd3
    + MG_b2*x_betahatd2
    + MG_b3*(h_Duration+.4)
    + MG_b4*(h_Duration+1.6)
    + MG_b5*(h_Duration+6.4)
    + MG_b6*(h_Polity+20)
    + MG_b7*(8)
    + MG_b8*(32)
    + MG_b9*(128)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahatd5 = MG_b1*x_betahatd4
    + MG_b2*x_betahatd3
    + MG_b3*(h_Duration+.5)
    + MG_b4*(h_Duration+2.5)
    + MG_b5*(h_Duration+12.5)
    + MG_b6*(h_Polity+20)
    + MG_b7*(10)
    + MG_b8*(50)
    + MG_b9*(250)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahatd6 = MG_b1*x_betahatd5
    + MG_b2*x_betahatd4
    + MG_b3*(h_Duration+.6)
    + MG_b4*(h_Duration+3.6)
    + MG_b5*(h_Duration+21.6)
    + MG_b6*(h_Polity+20)
    + MG_b7*(12)
    + MG_b8*(72)
    + MG_b9*(432)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;



generate x_betahatd7 = MG_b1*x_betahatd6
    + MG_b2*x_betahatd5
    + MG_b3*(h_Duration+.7)
    + MG_b4*(h_Duration+4.9)
    + MG_b5*(h_Duration+34.3)
    + MG_b6*(h_Polity+20)
    + MG_b7*(14)
    + MG_b8*(98)
    + MG_b9*(686)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahatd8 = MG_b1*x_betahatd7
    + MG_b2*x_betahatd6
    + MG_b3*(h_Duration+.8)
    + MG_b4*(h_Duration+6.4)
    + MG_b5*(h_Duration+51.2)
    + MG_b6*(h_Polity+20)
    + MG_b7*(16)
    + MG_b8*(128)
    + MG_b9*(1024)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahatd9 = MG_b1*x_betahatd8
    + MG_b2*x_betahatd7
    + MG_b3*(h_Duration+.9)
    + MG_b4*(h_Duration+8.1)
    + MG_b5*(h_Duration+72.9)
    + MG_b6*(h_Polity+20)
    + MG_b7*(18)
    + MG_b8*(162)
    + MG_b9*(1458)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;


generate x_betahatd10 = MG_b1*x_betahatd9
    + MG_b2*x_betahatd8
    + MG_b3*(h_Duration+1)
    + MG_b4*(h_Duration+10)
    + MG_b5*(h_Duration+100)
    + MG_b6*(h_Polity+20)
    + MG_b7*(20)
    + MG_b8*(200)
    + MG_b9*(2000)
    + MG_b10*h_Cap
    + MG_b11*h_GDPpc
    + MG_b12*h_Number
    + MG_b13*h_RPC + MG_b14*h_Constant;



gen diff=x_betahat10-x_betahat0 ;
gen diffd=x_betahatd10-x_betahatd0 ;



gen diff0 = x_betahat0-x_betahatd0 ;
gen diff1 = x_betahat1-x_betahatd1 ;
gen diff2 = x_betahat2-x_betahatd2 ;
gen diff3 = x_betahat3-x_betahatd3 ;
gen diff4 = x_betahat4-x_betahatd4 ;
gen diff5 = x_betahat5-x_betahatd5 ;
gen diff6 = x_betahat6-x_betahatd6 ;
gen diff7 = x_betahat7-x_betahatd7 ;
gen diff8 = x_betahat8-x_betahatd8 ;
gen diff9 = x_betahat9-x_betahatd9 ;
gen diff10 = x_betahat10-x_betahatd10 ;
 

 
 
egen probhat0=mean(x_betahat0) ;
egen probhat1=mean(x_betahat1) ;
egen probhat2=mean(x_betahat2);
egen probhat3=mean(x_betahat3);
egen probhat4=mean(x_betahat4);
egen probhat5=mean(x_betahat5);
egen probhat6=mean(x_betahat6);
egen probhat7=mean(x_betahat7);
egen probhat8=mean(x_betahat8);
egen probhat9=mean(x_betahat9);
egen probhat10=mean(x_betahat10);
egen diffhat=mean(diff) ;



egen probhatd0=mean(x_betahatd0) ;
egen probhatd1=mean(x_betahatd1) ;
egen probhatd2=mean(x_betahatd2);
egen probhatd3=mean(x_betahatd3);
egen probhatd4=mean(x_betahatd4);
egen probhatd5=mean(x_betahatd5);
egen probhatd6=mean(x_betahatd6);
egen probhatd7=mean(x_betahatd7);
egen probhatd8=mean(x_betahatd8);
egen probhatd9=mean(x_betahatd9);
egen probhatd10=mean(x_betahatd10);
egen diffhatd=mean(diffd) ;

egen diff0hat=mean(diff0) ;
egen diff1hat=mean(diff1);
egen diff2hat=mean(diff2);
egen diff3hat=mean(diff3);
egen diff4hat=mean(diff4);
egen diff5hat=mean(diff5);
egen diff6hat=mean(diff6);
egen diff7hat=mean(diff7);
egen diff8hat=mean(diff8);
egen diff9hat=mean(diff9);
egen diff10hat=mean(diff10);

 
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 prob_hat2 lo2 hi2 prob_hat3 lo3 hi3 prob_hat4 lo4 hi4 prob_hat5 lo5 hi5 prob_hat6 lo6 hi6
         prob_hat7 lo7 hi7 prob_hat8 lo8 hi8 prob_hat9 lo9 hi9 prob_hat10 lo10 hi10  diff_hat diff_lo diff_hi
         prob_hatd0 dlo0 dhi0 prob_hatd1 dlo1 dhi1 prob_hatd2 dlo2 dhi2 prob_hatd3 dlo3 dhi3 prob_hatd4 dlo4 dhi4 prob_hatd5 dlo5 dhi5 prob_hatd6 dlo6 dhi6
         prob_hatd7 dlo7 dhi7 prob_hatd8 dlo8 dhi8 prob_hatd9 dlo9 dhi9 prob_hatd10 dlo10 dhi10  diffd_hat diffd_lo diffd_hi
         diff0_hat diff0_lo diff0_hi diff1_hat diff1_lo diff1_hi diff2_hat diff2_lo diff2_hi diff3_hat diff3_lo diff3_hi diff4_hat diff4_lo diff4_hi diff5_hat diff5_lo diff5_hi
         diff6_hat diff6_lo diff6_hi diff7_hat diff7_lo diff7_hi diff8_hat diff8_lo diff8_hi diff9_hat diff9_lo diff9_hi diff10_hat diff10_lo diff10_hi;

    _pctile x_betahat0, p(2.5,97.5) ;
    scalar `lo0'=r(r1) ;
    scalar `hi0'=r(r2) ;

    _pctile x_betahat1, p(2.5,97.5) ;
    scalar `lo1'=r(r1) ;
    scalar `hi1'=r(r2) ;

    _pctile x_betahat2, p(2.5,97.5) ;
    scalar `lo2'=r(r1) ;
    scalar `hi2'=r(r2) ;

    _pctile x_betahat3, p(2.5,97.5) ;
    scalar `lo3'=r(r1) ;
    scalar `hi3'=r(r2) ;

    _pctile x_betahat4, p(2.5,97.5) ;
    scalar `lo4'=r(r1) ;
    scalar `hi4'=r(r2) ;


    _pctile x_betahat5, p(2.5,97.5) ;
    scalar `lo5'=r(r1) ;
    scalar `hi5'=r(r2) ;

    _pctile x_betahat6, p(2.5,97.5) ;
    scalar `lo6'=r(r1) ;
    scalar `hi6'=r(r2) ;

    _pctile x_betahat7, p(2.5,97.5) ;
    scalar `lo7'=r(r1) ;
    scalar `hi7'=r(r2) ;

    _pctile x_betahat8, p(2.5,97.5) ;
    scalar `lo8'=r(r1) ;
    scalar `hi8'=r(r2) ;

    _pctile x_betahat9, p(2.5,97.5) ;
    scalar `lo9'=r(r1) ;
    scalar `hi9'=r(r2) ;


    _pctile x_betahat10, p(2.5,97.5) ;
    scalar `lo10'=r(r1) ;
    scalar `hi10'=r(r2) ;



    _pctile diff, p(2.5,97.5) ;
    scalar `diff_lo'= r(r1) ;
    scalar `diff_hi'=r(r2) ;











 
    _pctile x_betahatd0, p(2.5,97.5) ;
    scalar `dlo0'=r(r1) ;
    scalar `dhi0'=r(r2) ;

    _pctile x_betahatd1, p(2.5,97.5) ;
    scalar `dlo1'=r(r1) ;
    scalar `dhi1'=r(r2) ;

    _pctile x_betahatd2, p(2.5,97.5) ;
    scalar `dlo2'=r(r1) ;
    scalar `dhi2'=r(r2) ;

    _pctile x_betahatd3, p(2.5,97.5) ;
    scalar `dlo3'=r(r1) ;
    scalar `dhi3'=r(r2) ;

    _pctile x_betahatd4, p(2.5,97.5) ;
    scalar `dlo4'=r(r1) ;
    scalar `dhi4'=r(r2) ;


    _pctile x_betahatd5, p(2.5,97.5) ;
    scalar `dlo5'=r(r1) ;
    scalar `dhi5'=r(r2) ;

    _pctile x_betahatd6, p(2.5,97.5) ;
    scalar `dlo6'=r(r1) ;
    scalar `dhi6'=r(r2) ;

    _pctile x_betahatd7, p(2.5,97.5) ;
    scalar `dlo7'=r(r1) ;
    scalar `dhi7'=r(r2) ;

    _pctile x_betahatd8, p(2.5,97.5) ;
    scalar `dlo8'=r(r1) ;
    scalar `dhi8'=r(r2) ;

    _pctile x_betahatd9, p(2.5,97.5) ;
    scalar `dlo9'=r(r1) ;
    scalar `dhi9'=r(r2) ;


    _pctile x_betahatd10, p(2.5,97.5) ;
    scalar `dlo10'=r(r1) ;
    scalar `dhi10'=r(r2) ;



    _pctile diffd, p(2.5,97.5) ;
    scalar `diffd_lo'= r(r1) ;
    scalar `diffd_hi'=r(r2) ;


    _pctile diff0, p(2.5,97.5) ;
    scalar `diff0_lo'= r(r1) ;
    scalar `diff0_hi'=r(r2) ;

     _pctile diff1, p(2.5,97.5) ;
    scalar `diff1_lo'= r(r1) ;
    scalar `diff1_hi'=r(r2) ;

     _pctile diff2, p(2.5,97.5) ;
    scalar `diff2_lo'= r(r1) ;
    scalar `diff2_hi'=r(r2) ;

     _pctile diff3, p(2.5,97.5) ;
    scalar `diff3_lo'= r(r1) ;
    scalar `diff3_hi'=r(r2) ;

     _pctile diff4, p(2.5,97.5) ;
    scalar `diff4_lo'= r(r1) ;
    scalar `diff4_hi'=r(r2) ;

     _pctile diff5, p(2.5,97.5) ;
    scalar `diff5_lo'= r(r1) ;
    scalar `diff5_hi'=r(r2) ;

     _pctile diff6, p(2.5,97.5) ;
    scalar `diff6_lo'= r(r1) ;
    scalar `diff6_hi'=r(r2) ;

     _pctile diff7, p(2.5,97.5) ;
    scalar `diff7_lo'= r(r1) ;
    scalar `diff7_hi'=r(r2) ;

     _pctile diff8, p(2.5,97.5) ;
    scalar `diff8_lo'= r(r1) ;
    scalar `diff8_hi'=r(r2) ;

     _pctile diff9, p(2.5,97.5) ;
    scalar `diff9_lo'= r(r1) ;
    scalar `diff9_hi'=r(r2) ;

     _pctile diff10, p(2.5,97.5) ;
    scalar `diff10_lo'= r(r1) ;
    scalar `diff10_hi'=r(r2) ;



 
    scalar `prob_hat0'=probhat0 ;
    scalar `prob_hat1'=probhat1 ;
    scalar `prob_hat2'=probhat2 ;
    scalar `prob_hat3'=probhat3 ;
    scalar `prob_hat4'=probhat4 ;
    scalar `prob_hat5'=probhat5 ;
    scalar `prob_hat6'=probhat6 ;
    scalar `prob_hat7'=probhat7 ;
    scalar `prob_hat8'=probhat8 ;
    scalar `prob_hat9'=probhat9 ;
    scalar `prob_hat10'=probhat10 ;
    scalar `diff_hat'=diffhat ;

    scalar `prob_hatd0'=probhatd0 ;
    scalar `prob_hatd1'=probhatd1 ;
    scalar `prob_hatd2'=probhatd2 ;
    scalar `prob_hatd3'=probhatd3 ;
    scalar `prob_hatd4'=probhatd4 ;
    scalar `prob_hatd5'=probhatd5 ;
    scalar `prob_hatd6'=probhatd6 ;
    scalar `prob_hatd7'=probhatd7 ;
    scalar `prob_hatd8'=probhatd8 ;
    scalar `prob_hatd9'=probhatd9 ;
    scalar `prob_hatd10'=probhatd10 ;
    scalar `diffd_hat'=diffhatd ;

    scalar `diff0_hat'=diff0hat ;
    scalar `diff1_hat'=diff1hat ;
    scalar `diff2_hat'=diff2hat ;
    scalar `diff3_hat'=diff3hat ;
    scalar `diff4_hat'=diff4hat ;
    scalar `diff5_hat'=diff5hat ;
    scalar `diff6_hat'=diff6hat ;
    scalar `diff7_hat'=diff7hat ;
    scalar `diff8_hat'=diff8hat ;
    scalar `diff9_hat'=diff9hat ;
    scalar `diff10_hat'=diff10hat ;



 
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1')
    (`prob_hat2') (`lo2') (`hi2')  (`prob_hat3') (`lo3') (`hi3')  (`prob_hat4') (`lo4') (`hi4')
     (`prob_hat5') (`lo5') (`hi5')  (`prob_hat6') (`lo6') (`hi6')
     (`prob_hat7') (`lo7') (`hi7')  (`prob_hat8') (`lo8') (`hi8')  (`prob_hat9') (`lo9') (`hi9')
     (`prob_hat10') (`lo10') (`hi10')  
     (`diff_hat') (`diff_lo') (`diff_hi')
    (`prob_hatd0') (`dlo0') (`dhi0') (`prob_hatd1') (`dlo1') (`dhi1')
    (`prob_hatd2') (`dlo2') (`dhi2')  (`prob_hatd3') (`dlo3') (`dhi3')  (`prob_hatd4') (`dlo4') (`dhi4')
     (`prob_hatd5') (`dlo5') (`dhi5')  (`prob_hatd6') (`dlo6') (`dhi6')
     (`prob_hatd7') (`dlo7') (`dhi7')  (`prob_hatd8') (`dlo8') (`dhi8')  (`prob_hatd9') (`dlo9') (`dhi9')
     (`prob_hatd10') (`dlo10') (`dhi10')  
     (`diffd_hat') (`diffd_lo') (`diffd_hi')
     (`diff0_hat') (`diff0_lo') (`diff0_hi') (`diff1_hat') (`diff1_lo') (`diff1_hi') (`diff2_hat') (`diff2_lo') (`diff2_hi') (`diff3_hat') (`diff3_lo') (`diff3_hi')
     (`diff4_hat') (`diff4_lo') (`diff4_hi') (`diff5_hat') (`diff5_lo') (`diff5_hi') (`diff6_hat') (`diff6_lo') (`diff6_hi') (`diff7_hat') (`diff7_lo') (`diff7_hi')
     (`diff8_hat') (`diff8_lo') (`diff8_hi') (`diff9_hat') (`diff9_lo') (`diff9_hi') (`diff10_hat') (`diff10_lo') (`diff10_hi');

    } ;

    drop x_betahat0 x_betahat1 x_betahat2 x_betahat3 x_betahat4 x_betahat5 x_betahat6
         x_betahat7 x_betahat8 x_betahat9 x_betahat10 diff
         probhat0 probhat1 probhat2  probhat3  probhat4 probhat5  probhat6
         probhat7  probhat8  probhat9 probhat10   diffhat
x_betahatd0 x_betahatd1 x_betahatd2 x_betahatd3 x_betahatd4 x_betahatd5 x_betahatd6
         x_betahatd7 x_betahatd8 x_betahatd9 x_betahatd10  diffd
         probhatd0 probhatd1 probhatd2  probhatd3  probhatd4 probhatd5  probhatd6
         probhatd7  probhatd8  probhatd9 probhatd10   diffhatd
         diff0 diff1 diff2 diff3 diff4 diff5 diff6 diff7 diff8 diff9 diff10
         diff0hat diff1hat diff2hat diff3hat diff4hat diff5hat diff6hat diff7hat diff8hat diff9hat diff10hat;

    local a=`a'+ .1 ;

    display "." _c ;
    } ;
display "" ; postclose mypost ;


use PredictedValues, clear;

saveold PredictedValues.dta, replace;

