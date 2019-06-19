
***************************************************************************
*  Creates proportion married and birth rates by one-year age group
*  RSFSR, 1959 census and vital statistics (birth) data
***************************************************************************

version 11
capture log close;
# delimit ;
set more 1;
set matsize 1000;

use pop_age_sex_1yr;  /*  Contains population counts by oblast, sex, urban/rural, married, by 1-year age group */
merge 1:1 regno using fert_age_1yr;  /* Contains births by oblast, urban/rural, by 1-year age group */
assert _merge==3;
drop _merge;
sort regno;
merge 1:1 regno using sexratios_1yr;  /*  Contains sex ratios; see create_sex_ratios_1yr.do for how these are created */
assert _merge==3;
drop _merge;
sort regno;

* Dropping small regions that are part of other regions;
drop if regno==4 | regno==45 | regno==48 | regno==57 | regno==60 | regno==67 | regno==68 |
        regno==73 | regno==74 | regno==76 | regno==78 | regno==80 |
        regno==81 | regno==86;

forval i = 18(1)44 {   ;
        gen age`i'=`i';
        } ;

forval i = 15(1)54  { ;
        gen popm`i' = popmu`i'+popmr`i';
        gen popf`i' = popfu`i'+popfr`i';
        }  ;

*  Creating proportion married;
forval i = 18(1)44 {   ;
        gen marrmu`i' = mpopmu`i'59/popmu`i'59;
        }  ;

forval i = 18(1)44 {    ;
        gen marrfu`i' = mpopfu`i'59/popfu`i'59;
        }  ;

forval i = 18(1)44 {    ;
        gen marrmr`i' = mpopmr`i'59/popmr`i'59 ;
        }  ;

forval i = 18(1)44 {    ;
        gen marrfr`i' = mpopfr`i'59/popfr`i'59 ;
        }  ;

forval i = 18(1)44 {   ;
        gen marrm`i' = (mpopmu`i'59+mpopmr`i'59)/(popmu`i'59+popmr`i'59);
        }  ;

forval i = 18(1)44 {   ;
        gen marrf`i' = (mpopfu`i'59+mpopfr`i'59)/(popfu`i'59+popfr`i'59);
        }  ;

*  Creating birth rate;
forval i = 18(1)44  { ;
        gen brateu`i' = brthu`i'/(popfu`i'/1000);
        gen brater`i' = brthr`i'/(popfr`i'/1000);
        gen brate`i'  = (brthu`i'+brthr`i')/((popfu`i'/1000)+(popfr`i'/1000));
        }  ;

*  Creating birth rate with smoothed denominator as in Russian official statistics;
capture program drop avgpop;
program define avgpop;
        local i = 18     ;
        local j = `i'-1  ;
        while `i' <= 44 {  ;
        gen sbrateu`i'=(brthu`i'/((popfu`i'59+popfu`j'59)/2))*1000;
        gen sbrater`i'=(brthr`i'/((popfr`i'59+popfr`j'59)/2))*1000;
        gen sbrate`i'=((brthu`i'+brthr`i')/((popfu`i'59+popfu`j'59+popfr`i'59+popfr`j'59)/2))*1000;
        local i = `i' + 1;
        local j = `j' + 1;
        }  ;
end;
avgpop;

stack region regno age18 popmu18 popfu18 popmr18 popfr18 marrmu18 marrfu18 marrmr18 marrfr18 sr10u18 sr10r18 brateu18 brater18 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm18 popf18 marrm18 marrf18 sr10a18 brate18 sr5a18 sr5u18 sr5r18 sr15a18 sr15u18 sr15r18 sbrateu18 sbrater18 sbrate18
      region regno age19 popmu19 popfu19 popmr19 popfr19 marrmu19 marrfu19 marrmr19 marrfr19 sr10u19 sr10r19 brateu19 brater19 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm19 popf19 marrm19 marrf19 sr10a19 brate19 sr5a19 sr5u19 sr5r19 sr15a19 sr15u19 sr15r19 sbrateu19 sbrater19 sbrate19
      region regno age20 popmu20 popfu20 popmr20 popfr20 marrmu20 marrfu20 marrmr20 marrfr20 sr10u20 sr10r20 brateu20 brater20 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm20 popf20 marrm20 marrf20 sr10a20 brate20 sr5a20 sr5u20 sr5r20 sr15a20 sr15u20 sr15r20 sbrateu20 sbrater20 sbrate20
      region regno age21 popmu21 popfu21 popmr21 popfr21 marrmu21 marrfu21 marrmr21 marrfr21 sr10u21 sr10r21 brateu21 brater21 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm21 popf21 marrm21 marrf21 sr10a21 brate21 sr5a21 sr5u21 sr5r21 sr15a21 sr15u21 sr15r21 sbrateu21 sbrater21 sbrate21
      region regno age22 popmu22 popfu22 popmr22 popfr22 marrmu22 marrfu22 marrmr22 marrfr22 sr10u22 sr10r22 brateu22 brater22 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm22 popf22 marrm22 marrf22 sr10a22 brate22 sr5a22 sr5u22 sr5r22 sr15a22 sr15u22 sr15r22 sbrateu22 sbrater22 sbrate22
      region regno age23 popmu23 popfu23 popmr23 popfr23 marrmu23 marrfu23 marrmr23 marrfr23 sr10u23 sr10r23 brateu23 brater23 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm23 popf23 marrm23 marrf23 sr10a23 brate23 sr5a23 sr5u23 sr5r23 sr15a23 sr15u23 sr15r23 sbrateu23 sbrater23 sbrate23
      region regno age24 popmu24 popfu24 popmr24 popfr24 marrmu24 marrfu24 marrmr24 marrfr24 sr10u24 sr10r24 brateu24 brater24 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm24 popf24 marrm24 marrf24 sr10a24 brate24 sr5a24 sr5u24 sr5r24 sr15a24 sr15u24 sr15r24 sbrateu24 sbrater24 sbrate24
      region regno age25 popmu25 popfu25 popmr25 popfr25 marrmu25 marrfu25 marrmr25 marrfr25 sr10u25 sr10r25 brateu25 brater25 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm25 popf25 marrm25 marrf25 sr10a25 brate25 sr5a25 sr5u25 sr5r25 sr15a25 sr15u25 sr15r25 sbrateu25 sbrater25 sbrate25
      region regno age26 popmu26 popfu26 popmr26 popfr26 marrmu26 marrfu26 marrmr26 marrfr26 sr10u26 sr10r26 brateu26 brater26 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm26 popf26 marrm26 marrf26 sr10a26 brate26 sr5a26 sr5u26 sr5r26 sr15a26 sr15u26 sr15r26 sbrateu26 sbrater26 sbrate26
      region regno age27 popmu27 popfu27 popmr27 popfr27 marrmu27 marrfu27 marrmr27 marrfr27 sr10u27 sr10r27 brateu27 brater27 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm27 popf27 marrm27 marrf27 sr10a27 brate27 sr5a27 sr5u27 sr5r27 sr15a27 sr15u27 sr15r27 sbrateu27 sbrater27 sbrate27
      region regno age28 popmu28 popfu28 popmr28 popfr28 marrmu28 marrfu28 marrmr28 marrfr28 sr10u28 sr10r28 brateu28 brater28 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm28 popf28 marrm28 marrf28 sr10a28 brate28 sr5a28 sr5u28 sr5r28 sr15a28 sr15u28 sr15r28 sbrateu28 sbrater28 sbrate28
      region regno age29 popmu29 popfu29 popmr29 popfr29 marrmu29 marrfu29 marrmr29 marrfr29 sr10u29 sr10r29 brateu29 brater29 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm29 popf29 marrm29 marrf29 sr10a29 brate29 sr5a29 sr5u29 sr5r29 sr15a29 sr15u29 sr15r29 sbrateu29 sbrater29 sbrate29
      region regno age30 popmu30 popfu30 popmr30 popfr30 marrmu30 marrfu30 marrmr30 marrfr30 sr10u30 sr10r30 brateu30 brater30 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm30 popf30 marrm30 marrf30 sr10a30 brate30 sr5a30 sr5u30 sr5r30 sr15a30 sr15u30 sr15r30 sbrateu30 sbrater30 sbrate30
      region regno age31 popmu31 popfu31 popmr31 popfr31 marrmu31 marrfu31 marrmr31 marrfr31 sr10u31 sr10r31 brateu31 brater31 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm31 popf31 marrm31 marrf31 sr10a31 brate31 sr5a31 sr5u31 sr5r31 sr15a31 sr15u31 sr15r31 sbrateu31 sbrater31 sbrate31
      region regno age32 popmu32 popfu32 popmr32 popfr32 marrmu32 marrfu32 marrmr32 marrfr32 sr10u32 sr10r32 brateu32 brater32 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm32 popf32 marrm32 marrf32 sr10a32 brate32 sr5a32 sr5u32 sr5r32 sr15a32 sr15u32 sr15r32 sbrateu32 sbrater32 sbrate32
      region regno age33 popmu33 popfu33 popmr33 popfr33 marrmu33 marrfu33 marrmr33 marrfr33 sr10u33 sr10r33 brateu33 brater33 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm33 popf33 marrm33 marrf33 sr10a33 brate33 sr5a33 sr5u33 sr5r33 sr15a33 sr15u33 sr15r33 sbrateu33 sbrater33 sbrate33
      region regno age34 popmu34 popfu34 popmr34 popfr34 marrmu34 marrfu34 marrmr34 marrfr34 sr10u34 sr10r34 brateu34 brater34 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm34 popf34 marrm34 marrf34 sr10a34 brate34 sr5a34 sr5u34 sr5r34 sr15a34 sr15u34 sr15r34 sbrateu34 sbrater34 sbrate34
      region regno age35 popmu35 popfu35 popmr35 popfr35 marrmu35 marrfu35 marrmr35 marrfr35 sr10u35 sr10r35 brateu35 brater35 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm35 popf35 marrm35 marrf35 sr10a35 brate35 sr5a35 sr5u35 sr5r35 sr15a35 sr15u35 sr15r35 sbrateu35 sbrater35 sbrate35
      region regno age36 popmu36 popfu36 popmr36 popfr36 marrmu36 marrfu36 marrmr36 marrfr36 sr10u36 sr10r36 brateu36 brater36 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm36 popf36 marrm36 marrf36 sr10a36 brate36 sr5a36 sr5u36 sr5r36 sr15a36 sr15u36 sr15r36 sbrateu36 sbrater36 sbrate36
      region regno age37 popmu37 popfu37 popmr37 popfr37 marrmu37 marrfu37 marrmr37 marrfr37 sr10u37 sr10r37 brateu37 brater37 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm37 popf37 marrm37 marrf37 sr10a37 brate37 sr5a37 sr5u37 sr5r37 sr15a37 sr15u37 sr15r37 sbrateu37 sbrater37 sbrate37
      region regno age38 popmu38 popfu38 popmr38 popfr38 marrmu38 marrfu38 marrmr38 marrfr38 sr10u38 sr10r38 brateu38 brater38 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm38 popf38 marrm38 marrf38 sr10a38 brate38 sr5a38 sr5u38 sr5r38 sr15a38 sr15u38 sr15r38 sbrateu38 sbrater38 sbrate38
      region regno age39 popmu39 popfu39 popmr39 popfr39 marrmu39 marrfu39 marrmr39 marrfr39 sr10u39 sr10r39 brateu39 brater39 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm39 popf39 marrm39 marrf39 sr10a39 brate39 sr5a39 sr5u39 sr5r39 sr15a39 sr15u39 sr15r39 sbrateu39 sbrater39 sbrate39
      region regno age40 popmu40 popfu40 popmr40 popfr40 marrmu40 marrfu40 marrmr40 marrfr40 sr10u40 sr10r40 brateu40 brater40 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm40 popf40 marrm40 marrf40 sr10a40 brate40 sr5a40 sr5u40 sr5r40 sr15a40 sr15u40 sr15r40 sbrateu40 sbrater40 sbrate40
      region regno age41 popmu41 popfu41 popmr41 popfr41 marrmu41 marrfu41 marrmr41 marrfr41 sr10u41 sr10r41 brateu41 brater41 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm41 popf41 marrm41 marrf41 sr10a41 brate41 sr5a41 sr5u41 sr5r41 sr15a41 sr15u41 sr15r41 sbrateu41 sbrater41 sbrate41
      region regno age42 popmu42 popfu42 popmr42 popfr42 marrmu42 marrfu42 marrmr42 marrfr42 sr10u42 sr10r42 brateu42 brater42 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm42 popf42 marrm42 marrf42 sr10a42 brate42 sr5a42 sr5u42 sr5r42 sr15a42 sr15u42 sr15r42 sbrateu42 sbrater42 sbrate42
      region regno age43 popmu43 popfu43 popmr43 popfr43 marrmu43 marrfu43 marrmr43 marrfr43 sr10u43 sr10r43 brateu43 brater43 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm43 popf43 marrm43 marrf43 sr10a43 brate43 sr5a43 sr5u43 sr5r43 sr15a43 sr15u43 sr15r43 sbrateu43 sbrater43 sbrate43
      region regno age44 popmu44 popfu44 popmr44 popfr44 marrmu44 marrfu44 marrmr44 marrfr44 sr10u44 sr10r44 brateu44 brater44 cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm44 popf44 marrm44 marrf44 sr10a44 brate44 sr5a44 sr5u44 sr5r44 sr15a44 sr15u44 sr15r44 sbrateu44 sbrater44 sbrate44,

      into(region regno age popmu popfu popmr popfr marrmu marrfu marrmr marrfr sr10u sr10r brateu brater cenchern central esib fareast ncauc north norwest povolzh urals volga wsib popm popf marrm marrf sr10a brate sr5a sr5u sr5r sr15a sr15u sr15r sbrateu sbrater sbrate) clear;



replace marrf=marrfu if regno==7 | regno==16;   /* Assigns urban variables to Moscow and St. Petersburg since these have only urban populations */
replace marrm=marrmu if regno==7 | regno==16;
replace popm=popmu if regno==7 | regno==16;
replace popf=popfu if regno==7 | regno==16;
replace brate=brateu if regno==7 | regno==16;
replace sbrate=sbrateu if regno==7 | regno==16;
replace sr10a=sr10u if regno==7 | regno==16;
replace sr5a=sr5u if regno==7 | regno==16;
replace sr15a=sr15u if regno==7 | regno==16;

gen urbshf=popfu/popf;
gen urbshm=popmu/popm;

gen pop=popm+popf;
gen popu=popmu+popfu;
gen popr=popmr+popfr;

gen lnpopm=log(popm);
gen lnpopmu=log(popmu);
gen lnpopmr=log(popmr);
gen lnpopf=log(popf);
gen lnpopfu=log(popfu);
gen lnpopfr=log(popfr);

replace brate=sbrate;    /* Uses 1959-1960 average pop. in denominator as in Russian vital statistics methods */
replace brateu=sbrateu;
replace brater=sbrater;
drop sbrate sbrateu sbrater;

gen lbrate=log(brate);
gen lbrateu=log(brateu);
gen lbrater=log(brater);

gen lgreg=0;
replace lgreg=1 if north==1;
replace lgreg=2 if norwest==1;
replace lgreg=3 if central==1;
replace lgreg=3 if regno==16;
replace lgreg=4 if cenchern==1;
replace lgreg=5 if volga==1;
replace lgreg=6 if povolzh==1;
replace lgreg=7 if ncauc==1;
replace lgreg=8 if urals==1;
replace lgreg=9 if esib==1;
replace lgreg=10 if wsib==1;
replace lgreg=11 if fareast==1;

label var pop "All pop.";
label var popu "Urban pop.";
label var popr "Rural pop.";
label var popm "Male pop.";
label var popf "Female pop.";
label var popmu "Male pop., urban";
label var popfu "Female pop., urban";
label var popmr "Male pop., rural";
label var popfr "Female pop., rural";
label var marrm "Proportion married, male";
label var marrf "Proportion married, female";
label var marrmu "Proportion married, male, urban";
label var marrfu "Proportion married, female, urban";
label var marrmr "Proportion married, male, rural";
label var marrfr "Proportion married, female, rural";
label var sr10a "Sex ratio";
label var sr10u "Sex ratio, urban";
label var sr10r "Sex ratio, rural";
label var sr5a "Sex ratio, narrow definition";
label var sr5u "Sex ratio, narrow definition, urban";
label var sr5r "Sex ratio, narrow definition, rural";
label var sr15a "Sex ratio, broad definition";
label var sr15u "Sex ratio, broad definition, urban";
label var sr15r "Sex ratio, broad definition, rural";
label var brate "Births per 1000 women";
label var brateu "Births per 1000 women, urban";
label var brater "Births per 1000 women, rural";
label var urbshm "% urban, men";
label var urbshf "% urban, women";

aorder;
sort regno;
save data_1yr_stacked, replace;



