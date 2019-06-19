/************************************************************************************************************************************
Conti and Pudney
Survey Design and the Analysis of Satisfaction
Review of Economics and Statistics, 2011
************************************************************************************************************************************/

clear
set mem 100m
set more off
cap log c
log using bootstrapper_spj.log, replace

local bhps "s:/final"

u `bhps'/aindresp
renpfix a
g datayear=1991
*NB fieldwork starts September 1991 for wave 1 & finishes by december*
g doiy4=1991
g wave=1
keep pid hid datayear wave doiy4 doim doid ivfio doby sex jbsat jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 ///
    jssat1 jssat2 jssat3 jssat4 jssat5 jssat age12 oprlg1 hlstat qfedhi mlstat tenure region jbhrs jbotpd jbot paynu paygu fihhmn ///
    jbsic jbsoc jbsize tuin1 jbonus jbopps jbsect jbft iv2 iv4 iveb ived hhsize cjsten jbttwt
so pid wave
sa label1, replace

u `bhps'/bindresp
renpfix b
g datayear=1992
g wave=2
keep pid hid datayear wave doiy4 doim doid ivfio doby sex jbsat jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 ///
    jssat1 jssat2 jssat3 jssat4 jssat5 jssat age12 hlstat qfedhi mlstat tenure region jbhrs jbotpd jbot paynu paygu fihhmn ///
    jbsic jbsoc jbsize tuin1 jbonus jbopps jbsect jbft iv2 iv4 iveb ived hhsize cjsten jbttwt
so pid wave
sa label2, replace

u `bhps'/cindresp
renpfix c
g datayear=1993
g wave=3
keep pid hid datayear wave doiy4 doim doid ivfio doby sex jbsat jbsat1 jbsat2 jbsat3 jbsat4 jbsat5 jbsat6 jbsat7 ///
    jssat jssat1 jssat2 jssat3 jssat4 jssat5 jssat age12 hlstat qfedhi mlstat tenure region jbhrs jbotpd jbot paynu paygu fihhmn ///
    jbsic jbsoc jbsize tuin1 jbonus jbopps jbsect jbft iv2 iv4 iveb ived hhsize cjsten jbttwt
so pid wave
sa label3, replace

u label1, clear
append using label2
append using label3
so pid wave
sa mind.dta, replace

ren doiy4 year
la var year "Year of the Interview"
ren doim month
la var month "Month of the Interview"
so year month // I use the year and the month of the interview to deflate the wage

bys wave sex: tab1 jbsat* // fine, checked wave 1 against aindresp
so pid wave
recode sex (2=0)
ren sex male
recode jbsat (-9/0=.)
recode jbsat1 (-9/0=.)
recode jbsat2 (-9/0=.)
recode jbsat3 (-9/0=.)
recode jbsat4 (-9/0=.)
recode jbsat5 (-9/0=.)
recode jbsat6 (-9/0=.)
recode jbsat7 (-9/0=.)
bys wave male: tab1 jbsat*
so pid wave



program drop _all
program kl, rclass
***************************************************Kullback-Leibler Information Criterion***************************************************
*********************************************(measure of divergence between two distributions)**********************************************
*Note: the first number refers to the jbsat variable (0 is for the overall), the second refers to the wave (1,2,3), the third to the point
*on the scale (from 1 to 7).
***************************************************************jbsat-males******************************************************************
capture drop denom* 
capture drop num0*
capture drop p0*m
summ
quietly forvalues i=1(1)3 {
    cou if jbsat!=.&wave==`i'&male==1
    g denom0`i'm=r(N)
    cou if jbsat==1&wave==`i'&male==1
    g num0`i'1m=r(N)
    cou if jbsat==2&wave==`i'&male==1
    g num0`i'2m=r(N)
    cou if jbsat==3&wave==`i'&male==1
    g num0`i'3m=r(N)
    cou if jbsat==4&wave==`i'&male==1
    g num0`i'4m=r(N)
    cou if jbsat==5&wave==`i'&male==1
    g num0`i'5m=r(N)
    cou if jbsat==6&wave==`i'&male==1
    g num0`i'6m=r(N)
    cou if jbsat==7&wave==`i'&male==1
    g num0`i'7m=r(N)
    g p0`i'1m=num0`i'1m/denom0`i'm
    g p0`i'2m=num0`i'2m/denom0`i'm
    g p0`i'3m=num0`i'3m/denom0`i'm
    g p0`i'4m=num0`i'4m/denom0`i'm
    g p0`i'5m=num0`i'5m/denom0`i'm
    g p0`i'6m=num0`i'6m/denom0`i'm
    g p0`i'7m=num0`i'7m/denom0`i'm
}
capture drop KL*
g KL12m=(ln(p021m/p011m)*p021m)+(ln(p022m/p012m)*p022m)+(ln(p023m/p013m)*p023m)+(ln(p024m/p014m)*p024m)+(ln(p025m/p015m)*p025m)+ ///
    (ln(p026m/p016m)*p026m)+(ln(p027m/p017m)*p027m)
g KL23m=(ln(p021m/p031m)*p021m)+(ln(p022m/p032m)*p022m)+(ln(p023m/p033m)*p023m)+(ln(p024m/p034m)*p024m)+(ln(p025m/p035m)*p025m)+ ///
    (ln(p026m/p036m)*p026m)+(ln(p027m/p037m)*p027m)

***************************************************************jbsat-females****************************************************************
capture drop p0*f
forvalues i=1(1)3 {
    cou if jbsat!=.&wave==`i'&male==0
    g denom0`i'f=r(N)
    cou if jbsat==1&wave==`i'&male==0
    g num0`i'1f=r(N)
    cou if jbsat==2&wave==`i'&male==0
    g num0`i'2f=r(N)
    cou if jbsat==3&wave==`i'&male==0
    g num0`i'3f=r(N)
    cou if jbsat==4&wave==`i'&male==0
    g num0`i'4f=r(N)
    cou if jbsat==5&wave==`i'&male==0
    g num0`i'5f=r(N)
    cou if jbsat==6&wave==`i'&male==0
    g num0`i'6f=r(N)
    cou if jbsat==7&wave==`i'&male==0
    g num0`i'7f=r(N)
    g p0`i'1f=num0`i'1f/denom0`i'f
    g p0`i'2f=num0`i'2f/denom0`i'f
    g p0`i'3f=num0`i'3f/denom0`i'f
    g p0`i'4f=num0`i'4f/denom0`i'f
    g p0`i'5f=num0`i'5f/denom0`i'f
    g p0`i'6f=num0`i'6f/denom0`i'f
    g p0`i'7f=num0`i'7f/denom0`i'f
}
g KL12f=(ln(p021f/p011f)*p021f)+(ln(p022f/p012f)*p022f)+(ln(p023f/p013f)*p023f)+(ln(p024f/p014f)*p024f)+(ln(p025f/p015f)*p025f)+ ///
    (ln(p026f/p016f)*p026f)+(ln(p027f/p017f)*p027f)
g KL23f=(ln(p021f/p031f)*p021f)+(ln(p022f/p032f)*p022f)+(ln(p023f/p033f)*p023f)+(ln(p024f/p034f)*p024f)+(ln(p025f/p035f)*p025f)+ ///
    (ln(p026f/p036f)*p026f)+(ln(p027f/p037f)*p027f)

*************************************************************jbsat1-7-males******************************************************************
capture drop num*m num*f
forvalues j=1(1)7 {
    forvalues i=1(1)3 {
        cou if jbsat`j'!=.&wave==`i'&male==1
        g denom`j'`i'm=r(N)
        cou if jbsat`j'==1&wave==`i'&male==1
        g num`j'`i'1m=r(N)
        cou if jbsat`j'==2&wave==`i'&male==1
        g num`j'`i'2m=r(N)
        cou if jbsat`j'==3&wave==`i'&male==1
        g num`j'`i'3m=r(N)
        cou if jbsat`j'==4&wave==`i'&male==1
        g num`j'`i'4m=r(N)
        cou if jbsat`j'==5&wave==`i'&male==1
        g num`j'`i'5m=r(N)
        cou if jbsat`j'==6&wave==`i'&male==1
        g num`j'`i'6m=r(N)
        cou if jbsat`j'==7&wave==`i'&male==1
        g num`j'`i'7m=r(N)
capture drop p`j'`i'*
        g p`j'`i'1m=num`j'`i'1m/denom`j'`i'm
        g p`j'`i'2m=num`j'`i'2m/denom`j'`i'm
        g p`j'`i'3m=num`j'`i'3m/denom`j'`i'm
        g p`j'`i'4m=num`j'`i'4m/denom`j'`i'm
        g p`j'`i'5m=num`j'`i'5m/denom`j'`i'm
        g p`j'`i'6m=num`j'`i'6m/denom`j'`i'm
        g p`j'`i'7m=num`j'`i'7m/denom`j'`i'm
    }
    g KL12m`j'=(ln(p`j'21m/p`j'11m)*p`j'21m)+(ln(p`j'22m/p`j'12m)*p`j'22m)+(ln(p`j'23m/p`j'13m)*p`j'23m)+(ln(p`j'24m/p`j'14m)*p`j'24m)+ ///
        (ln(p`j'25m/p`j'15m)*p`j'25m)+(ln(p`j'26m/p`j'16m)*p`j'26m)+(ln(p`j'27m/p`j'17m)*p`j'27m)
    g KL23m`j'=(ln(p`j'21m/p`j'31m)*p`j'21m)+(ln(p`j'22m/p`j'32m)*p`j'22m)+(ln(p`j'23m/p`j'33m)*p`j'23m)+(ln(p`j'24m/p`j'34m)*p`j'24m)+ ///
        (ln(p`j'25m/p`j'35m)*p`j'25m)+(ln(p`j'26m/p`j'36m)*p`j'26m)+(ln(p`j'27m/p`j'37m)*p`j'27m)
}
    
***********************************************************jbsat1-7-females******************************************************************
forvalues j=1(1)7 {
    forvalues i=1(1)3 {
        cou if jbsat`j'!=.&wave==`i'&male==0
        g denom`j'`i'f=r(N)
        cou if jbsat`j'==1&wave==`i'&male==0
        g num`j'`i'1f=r(N)
        cou if jbsat`j'==2&wave==`i'&male==0
        g num`j'`i'2f=r(N)
        cou if jbsat`j'==3&wave==`i'&male==0
        g num`j'`i'3f=r(N)
        cou if jbsat`j'==4&wave==`i'&male==0
        g num`j'`i'4f=r(N)
        cou if jbsat`j'==5&wave==`i'&male==0
        g num`j'`i'5f=r(N)
        cou if jbsat`j'==6&wave==`i'&male==0
        g num`j'`i'6f=r(N)
        cou if jbsat`j'==7&wave==`i'&male==0
        g num`j'`i'7f=r(N)
capture drop p`j'`i'*
        g p`j'`i'1f=num`j'`i'1f/denom`j'`i'f
        g p`j'`i'2f=num`j'`i'2f/denom`j'`i'f
        g p`j'`i'3f=num`j'`i'3f/denom`j'`i'f
        g p`j'`i'4f=num`j'`i'4f/denom`j'`i'f
        g p`j'`i'5f=num`j'`i'5f/denom`j'`i'f
        g p`j'`i'6f=num`j'`i'6f/denom`j'`i'f
        g p`j'`i'7f=num`j'`i'7f/denom`j'`i'f
    }
    g KL12f`j'=(ln(p`j'21f/p`j'11f)*p`j'21f)+(ln(p`j'22f/p`j'12f)*p`j'22f)+(ln(p`j'23f/p`j'13f)*p`j'23f)+(ln(p`j'24f/p`j'14f)*p`j'24f)+ ///
        (ln(p`j'25f/p`j'15f)*p`j'25f)+(ln(p`j'26f/p`j'16f)*p`j'26f)+(ln(p`j'27f/p`j'17f)*p`j'27f)
    g KL23f`j'=(ln(p`j'21f/p`j'31f)*p`j'21f)+(ln(p`j'22f/p`j'32f)*p`j'22f)+(ln(p`j'23f/p`j'33f)*p`j'23f)+(ln(p`j'24f/p`j'34f)*p`j'24f)+ ///
        (ln(p`j'25f/p`j'35f)*p`j'25f)+(ln(p`j'26f/p`j'36f)*p`j'26f)+(ln(p`j'27f/p`j'37f)*p`j'27f)
}
matrix define b=J(48,1,0)
/** ordering: males KL12, KL23, (KL12-KL23); females KL12 KL23, (KL12-KL23) **/
su KL12m
matrix b[1,1]=r(mean)
su KL23m
matrix b[2,1]=r(mean)
matrix b[3,1]=b[1,1]-b[2,1]
su KL12f
matrix b[25,1]=r(mean)
su KL23f
matrix b[26,1]=r(mean)
matrix b[27,1]=b[25,1]-b[26,1]
forvalues j=1(1)7 {
	local j1=`j'*3+1
	su KL12m`j'
	matrix b[`j1',1]=r(mean)
	su KL23m`j'
	matrix b[`j1'+1,1]=r(mean)
	matrix b[`j1'+2,1]=b[`j1',1]-b[`j1'+1,1]
	local j1=24+`j'*3+1
	su KL12f`j'
	matrix b[`j1',1]=r(mean)
	su KL23f`j'
	matrix b[`j1'+1,1]=r(mean)
	matrix b[`j1'+2,1]=b[`j1',1]-b[`j1'+1,1]
}
noisily matrix list b
ereturn matrix _b b
ereturn list
end

/*set trace on*/
kl

bootstrap bum=_b[1], reps(100) cluster(hid):kl


***FIGURE 1: Overall job satisfaction 
histogram jbsat if male==0&wave==1, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(wave 1 - females)
graph save Graph "d:/home/spudney/bari\REStat files\wave1_females.gph", replace
histogram jbsat if male==1&wave==1, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(wave 1 - males)
graph save Graph "d:/home/spudney/bari\REStat files\wave1_males.gph", replace
histogram jbsat if male==0&wave==2, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(wave 2 - females)
graph save Graph "d:/home/spudney/bari\REStat files\wave2_females.gph", replace
histogram jbsat if male==1&wave==2, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(wave 2 - males)
graph save Graph "d:/home/spudney/bari\REStat files\wave2_males.gph", replace
histogram jbsat if male==0&wave==3, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(wave 3 - females)
graph save Graph "d:/home/spudney/bari\REStat files\wave3_females.gph", replace
histogram jbsat if male==1&wave==3, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(wave 3 - males)
graph save Graph "d:/home/spudney/bari\REStat files\wave3_males.gph", replace
graph combine "d:/home/spudney/bari\REStat files\wave1_males.gph" ///
    "d:/home/spudney/bari\REStat files\wave2_males.gph" ///
    "d:/home/spudney/bari\REStat files\wave3_males.gph" ///
    "d:/home/spudney/bari\REStat files\wave1_females.gph" ///
    "d:/home/spudney/bari\REStat files\wave2_females.gph" ///
    "d:/home/spudney/bari\REStat files\wave3_females.gph"
graph save Graph "d:/home/spudney/bari\REStat files\jbsat_gender_w13.gph", replace
