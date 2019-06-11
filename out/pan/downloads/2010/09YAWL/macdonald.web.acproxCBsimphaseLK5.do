version 6.0 
#delimit ;

/* set up post files */

/* obtain temporary names for post file buffers */
tempname LK  LK5  ;


postfile `LK' 
nsim
bsiLKlfr bsiLKagr bsiLKenv bsiLKimm bsiLKpri bsiLKalc 
bl_LKlfr bl_LKagr bl_LKenv bl_LKimm bl_LKpri bl_LKalc 
blpLKlfr blpLKagr blpLKenv blpLKimm blpLKpri blpLKalc bconLKi

esiLKlfr esiLKagr esiLKenv esiLKimm esiLKpri esiLKalc 
el_LKlfr el_LKagr el_LKenv el_LKimm el_LKpri el_LKalc 
elpLKlfr elpLKagr elpLKenv elpLKimm elpLKpri elpLKalc econLKi

iLKnobs iLKss iLKdf iLKrss iLKrdf iLKF iLKRsq iLKaRsq iLKrmse  


bsmLKlfr bsmLKagr bsmLKenv bsmLKimm bsmLKpri bsmLKalc 
blrLKlfr blrLKagr blrLKenv blrLKimm blrLKpri blrLKalc 
blmLKlfr blmLKagr blmLKenv blmLKimm blmLKpri blmLKalc bconLKm

esmLKlfr esmLKagr esmLKenv esmLKimm esmLKpri esmLKalc 
elrLKlfr elrLKagr elrLKenv elrLKimm elrLKpri elrLKalc 
elmLKlfr elmLKagr elmLKenv elmLKimm elmLKpri elmLKalc econLKm

mLKnobs mLKss mLKdf mLKrss mLKrdf mLKF mLKRsq mLKaRsq mLKrmse  
using c:\stata\data\LK5set\acproxCBLK, replace
;   



postfile `LK5' 
nsim
bsiL5lfr bsiL5agr bsiL5env bsiL5imm bsiL5pri bsiL5alc 
bl_L5lfr bl_L5agr bl_L5env bl_L5imm bl_L5pri bl_L5alc 
blpL5lfr blpL5agr blpL5env blpL5imm blpL5pri blpL5alc bconL5i

esiL5lfr esiL5agr esiL5env esiL5imm esiL5pri esiL5alc 
el_L5lfr el_L5agr el_L5env el_L5imm el_L5pri el_L5alc 
elpL5lfr elpL5agr elpL5env elpL5imm elpL5pri elpL5alc econL5i

iL5nobs iL5ss iL5df iL5rss iL5rdf iL5F iL5Rsq iL5aRsq iL5rmse  


using c:\stata\data\LK5set\acproxCBLK5, replace
;   


/* Initialize relevant variables */
initvar s_50 posdum negdum psymp ;
scalar nsim=1 ;
                    
/* *******    BEGIN ACTIVE SIMULATION ***** */
while nsim<=maxsim { ;

/* means are set equal to their original (actual data) values */
do c:\stata\do\updatemn;

/* calcualte dmsm as base for simulating symp values and assim-contrast */ 
do c:\stata\do\dmsm ;

/* ** calculate the assimilated and contrasted perceptions ** */
/* SV */

*replace psymp=50.0-3.67*penalty1+1.71*smlfrt1+0.46*smagri1
    +0.40*smenvi1+0.72*smimmi1+0.48*smpriv1+0.44*smalco1 if (symp1 ~=.);
replace psymp=75.4 - (4.37*dmlfrt1+1.00*dmagri1 +0.50*dmenvi1
           +1.40*dmimmi1 + 1.63*dmpriv1+1.02*dmalco1) if (symp1 ~=.);

*replace psymp=65.0 - (0.60*dmxlfrt1+0.23*dmxagri1 +0.12*dmxenvi1
           +0.14*dmximmi1 + 0.21*dmxpriv1 + 0.22*dmxalco1) if (symp1 ~=.);

replace gsymp1=psymp+20.52*invnorm(uniform()) ;

replace s_50=gsymp1 - 50.0 ;
replace posdum=0;
replace posdum=1 if (s_50>0 & s_50 ~= .)  ;
replace negdum=1-posdum ;
replace plfrt1=2.4407+0.0072*posdum*(rlfrt-mnlfrt1)*s_50
                     +0.0033*negdum*(rlfrt-mnlfrt1)*s_50 - 5.5 ;
replace plfrt1=plfrt1 + 1.33337*invnorm(uniform())  ;
replace pagri1=6.7873+0.0082*posdum*(ragri-mnagri1)*s_50
                     +0.0053*negdum*(ragri-mnagri1)*s_50 - 5.5 ;
replace pagri1=pagri1 + 2.25062*invnorm(uniform()) ;
replace penvi1=2.4961+0.0110*posdum*(renvi-mnenvi1)*s_50
                     -0.0017*negdum*(renvi-mnenvi1)*s_50 - 5.5 ;
replace penvi1=penvi1 + 2.18910*invnorm(uniform()) ;
replace pimmi1=3.1794+0.0067*posdum*(rimmi-mnimmi1)*s_50
                     +0.0031*negdum*(rimmi-mnimmi1)*s_50 - 5.5 ;
replace pimmi1=pimmi1 + 1.86939*invnorm(uniform()) ;
replace ppriv1=8.7128+0.0053*posdum*(rpriv-mnpriv1)*s_50
                     +0.0026*negdum*(rpriv-mnpriv1)*s_50 - 5.5 ;
replace ppriv1=ppriv1 + 1.81163*invnorm(uniform()) ;
replace palco1=6.5745+0.0061*posdum*(ralco-mnalco1)*s_50
                     +0.0036*negdum*(ralco-mnalco1)*s_50 - 5.5 ;
replace palco1=palco1 + 1.78820*invnorm(uniform()) ;
replace pcrim1=6.4271+0.0109*posdum*(rcrim-mncrim1)*s_50
                     +0.0048*negdum*(rcrim-mncrim1)*s_50 - 5.5 ;
replace pcrim1=pcrim1 + 1.96395*invnorm(uniform()) ;
/* AP */
*replace psymp=50.0-3.67*penalty2+1.71*smlfrt2+0.46*smagri2
    +0.40*smenvi2+0.72*smimmi2+0.48*smpriv2+0.44*smalco2 if (symp2 ~=.);
replace psymp=75.4 - (4.37*dmlfrt2+1.00*dmagri2 +0.50*dmenvi2
           +1.40*dmimmi2 + 1.63*dmpriv2+1.02*dmalco2) if (symp2 ~=.);
*replace psymp=65.0 - (0.60*dmxlfrt2+0.23*dmxagri2 +0.12*dmxenvi2
           +0.14*dmximmi2 + 0.21*dmxpriv2 + 0.22*dmxalco2) if (symp2 ~=.);

replace gsymp2=psymp+20.52*invnorm(uniform()) ;

replace s_50=gsymp2 - 50.0 ;
replace posdum=0;
replace posdum=1 if (s_50>0 & s_50 ~= .)  ;
replace negdum=1-posdum ;
replace plfrt2=3.9703+0.0109*posdum*(rlfrt-mnlfrt2)*s_50
                     +0.0075*negdum*(rlfrt-mnlfrt2)*s_50 - 5.5 ;
replace plfrt2=plfrt2 + 1.43870*invnorm(uniform())  ;
replace pagri2=7.1071+0.0084*posdum*(ragri-mnagri2)*s_50
                     +0.0033*negdum*(ragri-mnagri2)*s_50 - 5.5 ;
replace pagri2=pagri2 + 1.74165*invnorm(uniform())  ; 
replace penvi2=5.0429+0.0114*posdum*(renvi-mnenvi2)*s_50
                     +0.0004*negdum*(renvi-mnenvi2)*s_50 - 5.5 ;
replace penvi2=penvi2 + 1.59466*invnorm(uniform())  ;
replace pimmi2=5.0484+0.0033*posdum*(rimmi-mnimmi2)*s_50
                     +0.0053*negdum*(rimmi-mnimmi2)*s_50 - 5.5 ;
replace pimmi2=pimmi2 + 1.54041*invnorm(uniform())  ;
replace ppriv2=8.5292+0.0040*posdum*(rpriv-mnpriv2)*s_50
                     +0.0032*negdum*(rpriv-mnpriv2)*s_50 - 5.5 ;
replace ppriv2=ppriv2 + 1.58050*invnorm(uniform())  ;
replace palco2=6.5161+0.0057*posdum*(ralco-mnalco2)*s_50
                     +0.0040*negdum*(ralco-mnalco2)*s_50 - 5.5 ;
replace palco2=palco2 + 1.49366*invnorm(uniform())  ;
replace pcrim2=5.6991+0.0044*posdum*(rcrim-mncrim2)*s_50
                     +0.0063*negdum*(rcrim-mncrim2)*s_50 - 5.5 ;
replace pcrim2=pcrim2 + 1.63103*invnorm(uniform())  ;

/* VE */
*replace psymp=50.0-3.67*penalty3+1.71*smlfrt3+0.46*smagri3
    +0.40*smenvi3+0.72*smimmi3+0.48*smpriv3+0.44*smalco3 if (symp3 ~=.);
replace psymp=75.4 - (4.37*dmlfrt3+1.00*dmagri3 +0.50*dmenvi3
           +1.40*dmimmi3 + 1.63*dmpriv3+1.02*dmalco3) if (symp3 ~=.);
*replace psymp=65.0 - (0.60*dmxlfrt3+0.23*dmxagri3 +0.12*dmxenvi3
           +0.14*dmximmi3 + 0.21*dmxpriv3 + 0.22*dmxalco3) if (symp3 ~=.);

replace gsymp3=psymp+20.52*invnorm(uniform()) ;

replace s_50=gsymp3 - 50.0 ;
replace posdum=0;
replace posdum=1 if (s_50>0 & s_50 ~= .)  ;
replace negdum=1-posdum ;
replace plfrt3=4.5691+0.0110*posdum*(rlfrt-mnlfrt3)*s_50
                     +0.0082*negdum*(rlfrt-mnlfrt3)*s_50 - 5.5 ;
replace plfrt3=plfrt3 + 1.75132*invnorm(uniform())  ;
replace pagri3=6.1965+0.0128*posdum*(ragri-mnagri3)*s_50
                     +0.0012*negdum*(ragri-mnagri3)*s_50 - 5.5 ;
replace pagri3=pagri3 + 1.80434*invnorm(uniform())  ;
replace penvi3=2.7458+0.0204*posdum*(renvi-mnenvi3)*s_50
                     -0.0038*negdum*(renvi-mnenvi3)*s_50 - 5.5 ;
replace penvi3=penvi3 + 2.08183*invnorm(uniform())  ;
replace pimmi3=4.6217+0.0029*posdum*(rimmi-mnimmi3)*s_50
                     +0.0018*negdum*(rimmi-mnimmi3)*s_50 - 5.5 ;
replace pimmi3=pimmi3 + 1.53630*invnorm(uniform())  ;
replace ppriv3=6.1143+0.0091*posdum*(rpriv-mnpriv3)*s_50
                     +0.0053*negdum*(rpriv-mnpriv3)*s_50 - 5.5 ;
replace ppriv3=ppriv3 + 1.65152*invnorm(uniform())  ;
replace palco3=6.5186+0.0055*posdum*(ralco-mnalco3)*s_50
                     +0.0012*negdum*(ralco-mnalco3)*s_50 - 5.5 ;
replace palco3=palco3 + 1.58609*invnorm(uniform())  ;
replace pcrim3=5.1598+0.0036*posdum*(rcrim-mncrim3)*s_50
                     +0.0000*negdum*(rcrim-mncrim3)*s_50 - 5.5 ;
replace pcrim3=pcrim3 + 1.51810*invnorm(uniform())  ;

/* SP */
*replace psymp=50.0-3.67*penalty4+1.71*smlfrt4+0.46*smagri4
    +0.40*smenvi4+0.72*smimmi4+0.48*smpriv4+0.44*smalco4 if (symp4 ~=.);
replace psymp=75.4 - (4.37*dmlfrt4+1.00*dmagri4 +0.50*dmenvi4
           +1.40*dmimmi4 + 1.63*dmpriv4+1.02*dmalco4) if (symp4 ~=.);
*replace psymp=65.0 - (0.60*dmxlfrt4+0.23*dmxagri4 +0.12*dmxenvi4
           +0.14*dmximmi4 + 0.21*dmxpriv4 + 0.22*dmxalco4) if (symp4 ~=.);

replace gsymp4=psymp+20.52*invnorm(uniform()) ;

replace s_50=gsymp4 - 50.0 ;
replace posdum=0;
replace posdum=1 if (s_50>0 & s_50 ~= .)  ;
replace negdum=1-posdum ;
replace plfrt4=5.4029+0.0061*posdum*(rlfrt-mnlfrt4)*s_50
                     +0.0106*negdum*(rlfrt-mnlfrt4)*s_50 - 5.5 ;
replace plfrt4=plfrt4 + 1.34672*invnorm(uniform())  ;
replace pagri4=9.3595+0.0054*posdum*(ragri-mnagri4)*s_50
                     +0.0006*negdum*(ragri-mnagri4)*s_50 - 5.5 ;
replace pagri4=pagri4 + 1.54754*invnorm(uniform())  ;
replace penvi4=5.1557+0.0164*posdum*(renvi-mnenvi4)*s_50
                     +0.0016*negdum*(renvi-mnenvi4)*s_50 - 5.5 ;
replace penvi4=penvi4 + 1.84902*invnorm(uniform())  ;
replace pimmi4=5.5030+0.0054*posdum*(rimmi-mnimmi4)*s_50
                     +0.0000*negdum*(rimmi-mnimmi4)*s_50 - 5.5 ;
replace pimmi4=pimmi4 + 1.34401*invnorm(uniform())  ;
replace ppriv4=5.8356+0.0110*posdum*(rpriv-mnpriv4)*s_50
                     +0.0031*negdum*(rpriv-mnpriv4)*s_50 - 5.5 ;
replace ppriv4=ppriv4 + 1.62055*invnorm(uniform())  ;
replace palco4=6.0900+0.0118*posdum*(ralco-mnalco4)*s_50
                     +0.0015*negdum*(ralco-mnalco4)*s_50 - 5.5 ;
replace palco4=palco4 + 1.31729*invnorm(uniform())  ;
replace pcrim4=4.6224+0.0080*posdum*(rcrim-mncrim4)*s_50
                     +0.0021*negdum*(rcrim-mncrim4)*s_50 - 5.5 ;
replace pcrim4=pcrim4 + 1.29774*invnorm(uniform())  ;

/* KR */
*replace psymp=50.0-3.67*penalty5+1.71*smlfrt5+0.46*smagri5
    +0.40*smenvi5+0.72*smimmi5+0.48*smpriv5+0.44*smalco5 if (symp5 ~=.);
replace psymp=75.4 - (4.37*dmlfrt5+1.00*dmagri5 +0.50*dmenvi5
           +1.40*dmimmi5 + 1.63*dmpriv5+1.02*dmalco5) if (symp5 ~=.);
*replace psymp=65.0 - (0.60*dmxlfrt5+0.23*dmxagri5 +0.12*dmxenvi5
           +0.14*dmximmi5 + 0.21*dmxpriv5 + 0.22*dmxalco5) if (symp5 ~=.);

replace gsymp5=psymp+20.52*invnorm(uniform()) ;

replace s_50=gsymp5 - 50.0 ;
replace posdum=0;
replace posdum=1 if (s_50>0 & s_50 ~= .)  ;
replace negdum=1-posdum ;
replace plfrt5=6.4643+0.0054*posdum*(rlfrt-mnlfrt5)*s_50
                     +0.0075*negdum*(rlfrt-mnlfrt5)*s_50 - 5.5 ;
replace plfrt5=plfrt5 + 1.33656*invnorm(uniform())  ;
replace pagri5=6.1361+0.0107*posdum*(ragri-mnagri5)*s_50
                     -0.0012*negdum*(ragri-mnagri5)*s_50 - 5.5 ;
replace pagri5=pagri5 + 1.60913*invnorm(uniform())  ;
replace penvi5=5.2453+0.0124*posdum*(renvi-mnenvi5)*s_50
                     +0.0009*negdum*(renvi-mnenvi5)*s_50 - 5.5 ;
replace penvi5=penvi5 + 1.61250*invnorm(uniform())  ;
replace pimmi5=4.8820+0.0012*posdum*(rimmi-mnimmi5)*s_50
                     +0.0067*negdum*(rimmi-mnimmi5)*s_50 - 5.5 ;
replace pimmi5=pimmi5 + 1.86132*invnorm(uniform())  ;
replace ppriv5=5.4749+0.0112*posdum*(rpriv-mnpriv5)*s_50
                     +0.0039*negdum*(rpriv-mnpriv5)*s_50 - 5.5 ;
replace ppriv5=ppriv5 + 1.91055*invnorm(uniform())  ;
replace palco5=9.4442+0.0004*posdum*(ralco-mnalco5)*s_50
                     +0.0005*negdum*(ralco-mnalco5)*s_50 - 5.5 ;
replace palco5=palco5 + 1.39310*invnorm(uniform())  ;
replace pcrim5=4.9906+0.0044*posdum*(rcrim-mncrim5)*s_50
                     +0.0036*negdum*(rcrim-mncrim5)*s_50 - 5.5 ;
replace pcrim5=pcrim5 + 1.94933*invnorm(uniform())  ;
                                                            
/* HP */
*replace psymp=50.0-3.67*penalty6+1.71*smlfrt6+0.46*smagri6
    +0.40*smenvi6+0.72*smimmi6+0.48*smpriv6+0.44*smalco6 if (symp6 ~=.);
replace psymp=75.4 - (4.37*dmlfrt6+1.00*dmagri6 +0.50*dmenvi6
           +1.40*dmimmi6 + 1.63*dmpriv6+1.02*dmalco6) if (symp6 ~=.);
*replace psymp=65.0 - (0.60*dmxlfrt6+0.23*dmxagri6 +0.12*dmxenvi6
           +0.14*dmximmi6 + 0.21*dmxpriv6 + 0.22*dmxalco6) if (symp6 ~=.);

replace gsymp6=psymp+20.52*invnorm(uniform()) ;

replace s_50=gsymp6 - 50.0 ;
replace posdum=0;
replace posdum=1 if (s_50>0 & s_50 ~= .)  ;
replace negdum=1-posdum ;
replace plfrt6=8.2152+0.0040*posdum*(rlfrt-mnlfrt6)*s_50
                     +0.0017*negdum*(rlfrt-mnlfrt6)*s_50 - 5.5 ;
replace plfrt6=plfrt6 + 1.21467*invnorm(uniform())  ;
replace pagri6=5.3503+0.0101*posdum*(ragri-mnagri6)*s_50
                     +0.0045*negdum*(ragri-mnagri6)*s_50 - 5.5 ;
replace pagri6=pagri6 + 1.82024*invnorm(uniform())  ;
replace penvi6=6.1420+0.0095*posdum*(renvi-mnenvi6)*s_50
                     +0.0055*negdum*(renvi-mnenvi6)*s_50 - 5.5 ;
replace penvi6=penvi6 + 1.60806*invnorm(uniform())  ;
replace pimmi6=6.4148+0.0047*posdum*(rimmi-mnimmi6)*s_50
                     +0.0071*negdum*(rimmi-mnimmi6)*s_50 - 5.5 ;
replace pimmi6=pimmi6 + 1.48517*invnorm(uniform())  ;
replace ppriv6=3.3501+0.0126*posdum*(rpriv-mnpriv6)*s_50
                     +0.0042*negdum*(rpriv-mnpriv6)*s_50 - 5.5 ;
replace ppriv6=ppriv6 + 1.81315*invnorm(uniform())  ;
replace palco6=4.2368+0.0089*posdum*(ralco-mnalco6)*s_50
                     +0.0036*negdum*(ralco-mnalco6)*s_50 - 5.5 ;
replace palco6=palco6 + 1.81113*invnorm(uniform())  ;
replace pcrim6=4.0081+0.0103*posdum*(rcrim-mncrim6)*s_50
                     +0.0033*negdum*(rcrim-mncrim6)*s_50 - 5.5 ;
replace pcrim6=pcrim6 + 1.46813*invnorm(uniform())  ;

/* FR */
*replace psymp=50.0-3.67*penalty7+1.71*smlfrt7+0.46*smagri7
    +0.40*smenvi7+0.72*smimmi7+0.48*smpriv7+0.44*smalco7 if (symp7 ~=.);
replace psymp=75.4 - (4.37*dmlfrt7+1.00*dmagri7 +0.50*dmenvi7
           +1.40*dmimmi7 + 1.63*dmpriv7+1.02*dmalco7) if (symp7 ~=.);
*replace psymp=65.0 - (0.60*dmxlfrt7+0.23*dmxagri7 +0.12*dmxenvi7
           +.14*dmximmi7 + 0.21*dmxpriv7 + 0.22*dmxalco7) if (symp7 ~=.);

replace gsymp7=psymp+20.52*invnorm(uniform()) ;

replace s_50=gsymp7 - 50.0 ;
replace posdum=0;
replace posdum=1 if (s_50>0 & s_50 ~= .)  ;
replace negdum=1-posdum ;
replace plfrt7=8.9989+0.0054*posdum*(rlfrt-mnlfrt7)*s_50
                     +0.0019*negdum*(rlfrt-mnlfrt7)*s_50 - 5.5 ;
replace plfrt7=plfrt7 + 1.54281*invnorm(uniform())  ;
replace pagri7=2.1873+0.0051*posdum*(ragri-mnagri7)*s_50
                     +0.0023*negdum*(ragri-mnagri7)*s_50 - 5.5 ;
replace pagri7=pagri7 + 1.62122*invnorm(uniform())  ;
replace penvi7=7.0628+0.0051*posdum*(renvi-mnenvi7)*s_50
                     +0.0072*negdum*(renvi-mnenvi7)*s_50 - 5.5 ;
replace penvi7=penvi7 + 2.14482*invnorm(uniform())  ;
replace pimmi7=9.2764+0.0038*posdum*(rimmi-mnimmi7)*s_50
                     +0.0015*negdum*(rimmi-mnimmi7)*s_50 - 5.5 ;
replace pimmi7=pimmi7 + 1.41549*invnorm(uniform())  ;
replace ppriv7=1.6701+0.0045*posdum*(rpriv-mnpriv7)*s_50
                     +0.0009*negdum*(rpriv-mnpriv7)*s_50 - 5.5 ;
replace ppriv7=ppriv7 + 1.43088*invnorm(uniform())  ;
replace palco7=2.0918+0.0034*posdum*(ralco-mnalco7)*s_50
                     +0.0016*negdum*(ralco-mnalco7)*s_50 - 5.5 ;
replace palco7=palco7 + 1.55774*invnorm(uniform())  ;
replace pcrim7=1.8200+0.0129*posdum*(rcrim-mncrim7)*s_50
                     +0.0018*negdum*(rcrim-mncrim7)*s_50 - 5.5 ;
replace pcrim7=pcrim7 + 1.51000*invnorm(uniform())  ;            

/* ** end of calculating the assimilated and contrasted perceptions */

/* recalculate means */
meancalc plfrt1 mlfrt1;
meancalc pagri1 magri1;
meancalc penvi1 menvi1;
meancalc pimmi1 mimmi1;
meancalc ppriv1 mpriv1;
meancalc palco1 malco1;
meancalc pcrim1 mcrim1;
                      
meancalc plfrt2 mlfrt2;
meancalc pagri2 magri2;
meancalc penvi2 menvi2;
meancalc pimmi2 mimmi2;
meancalc ppriv2 mpriv2;
meancalc palco2 malco2;
meancalc pcrim2 mcrim2;
                      
meancalc plfrt3 mlfrt3;
meancalc pagri3 magri3;
meancalc penvi3 menvi3;
meancalc pimmi3 mimmi3;
meancalc ppriv3 mpriv3;
meancalc palco3 malco3;
meancalc pcrim3 mcrim3;
                      
meancalc plfrt4 mlfrt4;
meancalc pagri4 magri4;
meancalc penvi4 menvi4;
meancalc pimmi4 mimmi4;
meancalc ppriv4 mpriv4;
meancalc palco4 malco4;
meancalc pcrim4 mcrim4;
                      
meancalc plfrt5 mlfrt5;
meancalc pagri5 magri5;
meancalc penvi5 menvi5;
meancalc pimmi5 mimmi5;
meancalc ppriv5 mpriv5;
meancalc palco5 malco5;
meancalc pcrim5 mcrim5;
                      
meancalc plfrt6 mlfrt6;
meancalc pagri6 magri6;
meancalc penvi6 menvi6;
meancalc pimmi6 mimmi6;
meancalc ppriv6 mpriv6;
meancalc palco6 malco6;
meancalc pcrim6 mcrim6;
                      
meancalc plfrt7 mlfrt7;
meancalc pagri7 magri7;
meancalc penvi7 menvi7;
meancalc pimmi7 mimmi7;
meancalc ppriv7 mpriv7;
meancalc palco7 malco7;
meancalc pcrim7 mcrim7;

/* calcuate new distance and scalar product values */
do c:\stata\do\dmsm ;
do c:\stata\do\disi ;

/*** time for regression runs ***/
/*** reshape the data matrix ***/

reshape long ; 

/*** regression runs ***/
/* Lewis-King individual perception */
display 
"Simul data Lewis King style analysis -- individual perception";
regress gsymp  si2lfrt  si2agri  si2envi  si2immi  si2priv  si2alco
               rlnlfrt  rlnagri  rlnenvi  rlnimmi  rlnpriv  rlnalco 
               plnlfrt  plnagri  plnenvi  plnimmi  plnpriv  plnalco ;
matrix bLKi=get(_b) ;
matrix vce=get(VCE) ;
getstde vce 19;
matrix seLKi=std_errs ;
matrix LKires=(_result(1),_result(2),_result(3),_result(4),_result(5),
              _result(6),_result(7),_result(8),_result(9));

/* Lewis-King mean perceptions */
display 
"Simul data Lewis King style analysis -- mean perception";
regress gsymp  sm2lfrt  sm2agri  sm2envi  sm2immi  sm2priv  sm2alco
               rlnlfrt  rlnagri  rlnenvi  rlnimmi  rlnpriv  rlnalco 
               mlnlfrt  mlnagri  mlnenvi  mlnimmi  mlnpriv  mlnalco ;
matrix bLKm=get(_b) ;
matrix vce=get(VCE) ;
getstde vce 19;
matrix seLKm=std_errs ;
matrix LKmres=(_result(1),_result(2),_result(3),_result(4),_result(5),
              _result(6),_result(7),_result(8),_result(9));

post `LK'
nsim
bLKi[1,1] bLKi[1,2] bLKi[1,3] bLKi[1,4] bLKi[1,5] bLKi[1,6] 
bLKi[1,7] bLKi[1,8] bLKi[1,9] bLKi[1,10] bLKi[1,11] bLKi[1,12] 
bLKi[1,13] bLKi[1,14] bLKi[1,15] bLKi[1,16] bLKi[1,17] bLKi[1,18] 
bLKi[1,19] 
seLKi[1,1] seLKi[1,2] seLKi[1,3] seLKi[1,4] seLKi[1,5] seLKi[1,6] 
seLKi[1,7] seLKi[1,8] seLKi[1,9] seLKi[1,10] seLKi[1,11] seLKi[1,12] 
seLKi[1,13] seLKi[1,14] seLKi[1,15] seLKi[1,16] seLKi[1,17] seLKi[1,18] 
seLKi[1,19] 
LKires[1,1] LKires[1,2] LKires[1,3] LKires[1,4] LKires[1,5] 
         LKires[1,6] LKires[1,7] LKires[1,8] LKires[1,9] 
bLKm[1,1] bLKm[1,2] bLKm[1,3] bLKm[1,4] bLKm[1,5] bLKm[1,6] 
bLKm[1,7] bLKm[1,8] bLKm[1,9] bLKm[1,10] bLKm[1,11] bLKm[1,12] 
bLKm[1,13] bLKm[1,14] bLKm[1,15] bLKm[1,16] bLKm[1,17] bLKm[1,18] 
bLKm[1,19] 
seLKm[1,1] seLKm[1,2] seLKm[1,3] seLKm[1,4] seLKm[1,5] seLKm[1,6] 
seLKm[1,7] seLKm[1,8] seLKm[1,9] seLKm[1,10] seLKm[1,11] seLKm[1,12] 
seLKm[1,13] seLKm[1,14] seLKm[1,15] seLKm[1,16] seLKm[1,17] seLKm[1,18] 
seLKm[1,19] 
LKmres[1,1] LKmres[1,2] LKmres[1,3] LKmres[1,4] LKmres[1,5] 
         LKmres[1,6] LKmres[1,7] LKmres[1,8] LKmres[1,9]
;

/* Lewis-King individual perception five party analysis */
display 
"Simul data Lewis King style analysis -- individual perception 5 party";
regress gsymp  si2lfrt  si2agri  si2envi  si2immi  si2priv  si2alco
               rlnlfrt  rlnagri  rlnenvi  rlnimmi  rlnpriv  rlnalco 
               plnlfrt  plnagri  plnenvi  plnimmi  plnpriv  plnalco 
               if penalty<0.001;
matrix bL5i=get(_b) ;
matrix vce=get(VCE) ;
getstde vce 19;
matrix seL5i=std_errs ;
matrix L5ires=(_result(1),_result(2),_result(3),_result(4),_result(5),
              _result(6),_result(7),_result(8),_result(9));

post `LK5'
nsim
bL5i[1,1] bL5i[1,2] bL5i[1,3] bL5i[1,4] bL5i[1,5] bL5i[1,6] 
bL5i[1,7] bL5i[1,8] bL5i[1,9] bL5i[1,10] bL5i[1,11] bL5i[1,12] 
bL5i[1,13] bL5i[1,14] bL5i[1,15] bL5i[1,16] bL5i[1,17] bL5i[1,18] 
bL5i[1,19] 
seL5i[1,1] seL5i[1,2] seL5i[1,3] seL5i[1,4] seL5i[1,5] seL5i[1,6] 
seL5i[1,7] seL5i[1,8] seL5i[1,9] seL5i[1,10] seL5i[1,11] seL5i[1,12] 
seL5i[1,13] seL5i[1,14] seL5i[1,15] seL5i[1,16] seL5i[1,17] seL5i[1,18] 
seL5i[1,19] 
L5ires[1,1] L5ires[1,2] L5ires[1,3] L5ires[1,4] L5ires[1,5] 
         L5ires[1,6] L5ires[1,7] L5ires[1,8] L5ires[1,9] 
;




reshape wide ;

scalar nsim=nsim+1 ;
} ; /* **** end of while loop**** */

/* close post files */
/* definition of post files */

postclose `LK' ;
postclose `LK5' ;
