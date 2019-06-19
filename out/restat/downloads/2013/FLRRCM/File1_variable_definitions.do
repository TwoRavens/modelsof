#delimit;
clear;
use premerge;

gen sklab=ownersm +ownersf+empsm +empsf+execsm+execsf+adminsm+adminsf;
gen unsklab=dirwkrsm+dirwkrsf+indwkrsm+indwkrsf+homewkrm+homewkrf+salesm+salesf;
gen skwages=wageswc+ bonuswc+ prtaxwc+ fataxwc;
gen unskwages=wagesbc+ bonusbc+ prtaxbc+ fataxbc;
gen totwages=skwages+unskwages;
gen skwages2=wageswc+ bonuswc;
gen unskwages2=wagesbc+ bonusbc;
gen totwages2=skwages2+unskwages2;

label var sklab "Skilled labor (number of employees)";
label var unsklab "Unskilled labor (number of employees)";
label var skwages "Total wages(cost) of skilled labor";
label var unskwages "Total wages(cost) of unskilled labor";
label var totwages "Total wages: Skilled + Unskilled";

label var skwages2 "Total wages(cost) of skilled labor (excluding 
Family allowance and payroll taxes)";
label var unskwages2 "Total wages(cost) of unskilled labor(excluding 
Family allowance and payroll taxes)";
label var totwages2 "Total wages: Skilled + Unskilled (excluding Family allowance and payroll taxes)";
gen matls= totrawma+ rawmatsi+ goodspch+ cstwtp+ watival+ watdval;
label var matls "Total material input (nominal value)";

gen intmat= totrawma+ rawmatsi+ goodspch+ cstwtp;


gen elecy=elecbval+((elecbval/elecbvol)*elecgvol)-elecsval;
label var elecy "Total electricty input (nominal value)";
/** Note that generated electricity's costs are reflected in higher purchase if fuels/labor etc, hence
when we estimate value added below, we exclude elecgval **/

gen fuels= coalval+ carbval+ cokeval+ petrval+ diesval+ benzval+ parafval+
lgasval+ pgasval+ fwoodval+ ofuelval+ greasval+ lubeval;
label var fuels "Total fuel input (nominal value)";
/** This definition is fuels=totfuel+greasval+lubeval **/

/* Some other useful variables */
gen servpur= freight+insuran+rent+communic+techsupp
+accnting+adverts+ inhouse+ salescom+ othserv;

label var servpur "SERVICES PURCHASED: freight+insuran+rent+communic    
+techsupp+accnting+adverts+ inhouse+ salescom+ othserv";

label var income "TOTAL INCOME: salegds+shipgds+resales+contract
+conrepai+coninsta";

label var groutput "GROSS OUTPUT: income+elecsval+prodbld
+prodmach+prodveh+(finvufgd+finvfgds)-(iinvufgd+iinvfgds)";

label var totrawma "TOTAL PURCHASES OF RAW MATERIALS:
rawmats1 +rawmats2 +rawmats3";
label var totipurc "TOTAL INTERMEDIATE PURCHASES: totrawma+
goodspch+cstwtp+watival+ totfuel+greasval+lubeval (this is 
also equal to (matls+fuels -rawmatsi))";

label var valadded "VALUE ADDED: groutput-totipurc-elecbval
+(finvrm-iinvrm)";

gen val2 = valadded - servpur;
label var val2 "VALUE ADDED - Services Purchased";
gen val3 = val2 - taxvaeff;
label var val3 "VALUE ADDED - Services Purchased - Effective VAT";

gen netinv= invnbld+ invnmach+ invnveh+ invubld+ invumach+ invuveh- salesbld
- salesuma- salesuve+ impbld+ impmach+ impveh+ prodbld+ prodmach+ prodveh;
label var netinv "Net new investment in blg, machinery, and vehicles";

***************************************************
************ Deflated variables *******************
***Merge in Hernando deflators **;

#delimit;
sort ciiu_3d year;
merge ciiu_3d year using def_energy79;
drop _merge;

**** Since many firms enter after 1979, it is difficult to construct
**** a consistent (in 1979 prices) real variable series using only the
**** company specific information.  So we construct industry (4 digit)
**** specific 1979 price index for each variable to construct the real
**** series in 1979 prices.;

/*** FUELS***/

egen indyr=group(ciiu_3d year);
sort indyr;
egen prind80=max(pr_ind_dom*(year==1980));
#delimit ;
program drop _all;
program define prindex;
syntax newvarlist;
    by indyr: egen t1=sum(`varlist'val) 
        if `varlist'vol>0 & `varlist'val>0;
    egen t`varlist'val=max(t1), by(indyr);
    replace t`varlist'val=0 if t`varlist'val==.;
    by indyr: egen t2=sum(`varlist'vol)
        if `varlist'vol>0 & `varlist'val>0;
      egen t`varlist'vol=max(t2), by(indyr);
    replace t`varlist'vol=0 if t`varlist'vol==.;
    gen `varlist'pr=t`varlist'val/t`varlist'vol;
    replace `varlist'pr=0 if `varlist'pr==.;
    egen `varlist'pr79=max(`varlist'pr*(year==1979)), by(ciiu);
    egen `varlist'pr80=max(`varlist'pr*(year==1980)), by(ciiu);
    replace `varlist'pr79=`varlist'pr80*100/prind80 
            if `varlist'pr79 <=0;
    gen r`varlist'val=`varlist'val if year==1979;
    replace r`varlist'=`varlist'val*`varlist'pr79/`varlist'pr 
            if year~=1979;
    replace r`varlist'=0 if r`varlist'==.;
    drop t1 t2 `varlist'pr80;
end;
prindex coal;
prindex carb;
prindex coke;
prindex petr;
prindex dies;
prindex benz;
prindex paraf;
prindex lgas;
prindex pgas;
prindex fwood;
prindex greas;
prindex lube;

/*** Treat price index for other fuels as a weighted average of prices
of all other fuels ***/
gen ofuelpr=(coalpr*tcoalval+carbpr*tcarbval 
        +cokepr*tcokeval+petrpr*tpetrval
        +diespr*tdiesval+ benzpr*tbenzval 
        +parafpr*tparafval+lgaspr*tlgasval
        +pgaspr*tpgasval+ fwoodpr*tfwoodval
        +greaspr*tgreasval +lubepr*tlubeval)/
        (tcoalval+tcarbval+tcokeval+tpetrval 
         +tdiesval+ tbenzval +tparafval+tlgasval    
         +tpgasval+ tfwoodval+ tgreasval +tlubeval);

egen ofuelpr79=max(ofuelpr*(year==1979)), by(ciiu);
gen rofuelval=ofuelval*ofuelpr79/ofuelpr;
replace rofuelval=0 if rofuel==.;

/***Total value fuel input (real value)***/
gen rfuels=rcoalval+rcarbval+rcokeval+rpetrval+rdiesval+rbenzval
    +rparafval+rlgasval+rpgasval+rfwoodval+rgreasval
    +rlubeval+rofuelval;
label var rfuels "Total fuel input (real value)";

**** Using Hernando's deflators;
gen rcoalval2=coalval*100/def_coal_charc79;
gen rcarbval2=carbval*100/def_coal_charc79;
#delimit;
gen rcokeval2=cokeval*100/def_coal_charc79;
gen rpetrval2=petrval*100/def_gas79;
gen rdiesval2=diesval*100/def_oil79;
gen rbenzval2=benzval*100/def_gas79;
gen rparafval2=rparafval; ** No deflator in Hernando's data;
gen rlgasval2=lgasval*100/def_lgas79;
gen rpgasval2=pgasval*100/def_pipegas79;
gen rfwoodval2=fwoodval*100/def_firewood79;
gen rgreasval2=rgreasval;** No deflator in Hernando's data;
gen rlubeval2=rlubeval;  ** No deflator in Hernando's data;
gen rofuelval2=rofuelval;** No deflator in Hernando's data;

gen rfuels2=rcoalval2+rcarbval2+rcokeval2+rpetrval2+rdiesval2+rbenzval2
    +rparafval2+rlgasval2+rpgasval2+rfwoodval2+rgreasval2
    +rlubeval2+rofuelval2;

/*** ELECTRICITY***/
/*** Here, we treat real electricity input as the net amount of 
    electricity used ***/
gen relecvol= elecbvol+ elecgvol- elecsvol;
label var relecvol "Total electricity input (Volume/amount)";

/*** Real electricity at 1979 (average) prices ***/
gen epr=elecbval/elecbvol;
egen mepr=mean(epr), by(year);
gen tt=mepr if year==1979;
egen epr_79=max(tt); drop tt;
gen relecv=relecvol*epr_79;
label var relecv "Total electricity input (in 1979 pesos)";

** Using Hernando's deflators;
gen relecbval=elecbval*100/def_elec_bght79;
label var relecbval "Total electricity bought (in 1979 pesos)";
gen relecsval=elecsval*100/def_elec_sold79;
label var relecsval "Total electricity sold (in 1979 pesos)";

** Hernando doesn't have a deflator/price for elec generated
--seem to use energy in units only.  We use our price index for
elec generated;
gen relecv2=relecbval-relecsval+elecgvol*epr_79;


/*** MATERIALS***/

/**Use deflator -- variable inputs (obtained from Prof Parker) 
to deflate materials excluding water **/
gen rintmat=intmat/defvaria;
gen intmatusd=intmat-(finvrm-iinvrm);
gen rintmatusd=intmatusd/defvaria;

/**Use information available in the raw data to deflate water
(analogous to deflation of fuel variables, use same programs)**/
prindex wati; ** Wati -- industrial;
prindex watd; ** Watd -- domestic;

gen rwat=rwatival+rwatdval;
gen rmatls=rintmat+rwat;
label var rmatls "Total material input (real value)";
gen rmatusd=rintmatusd+rwat;
label var rmatusd "Total material input used (real value)
(rmatls-change in inventory)";

#delimit;
***Hernando's deflators;
sort ciiu_3d year;
merge ciiu_3d year using def_matls79;
drop _merge;
sort ciiu_3d year;
merge ciiu_3d year using def_water79;
drop _merge;

gen rwat2=watival*100/def_wat79;
gen rintmat2=intmat*100/def_mat79;
gen rmatls2=rintmat2+rwat2;
gen rmatusd2=rmatls2 - (finvrm-iinvrm)*100/def_mat79;
label var rmatusd "Total material input used (real value)
(rmatls-change in inventory)";

/*** SERVICES PURCHASED **/
gen rserv=servpur*100/pr_ind_dom;
label var rserv "Total services purchased(real)";
** Here we use the overall index, as services could be
purchased from a general pool;

/*** OUTPUT ***/
/** We assume groutput is inclusive of the valueadded tax**/
gen netop=groutput-taxvaeff;

** Alternative, using new output deflators **;
sort ciiu_3d year;
merge ciiu_3d year using deflators;
drop _merge;
drop if year>1996;

gen rnetop=netop*100/def_op79;
label var rnetop "Net Output (real) (net of value added tax)";

gen rva=valadded*100/def_op79;
label var rva "Total value added (real)";
gen rva2=val2*100/def_op79;
label var rva2 "Total value added (adj for services purchased)(real)";
gen rva3=val3*100/def_op79;
label var rva3 "Total value added (adj for serv purch and VAT)(real)";

************************************************
**** Program to drop all the newly created variables 
**** that are not required in other programs
************************************************
program drop _all;
program define mydrop;
syntax newvarlist;
   drop `varlist'pr `varlist'pr79 t`varlist'val t`varlist'vol 
        r`varlist'val;
end;
mydrop coal;
mydrop carb;
mydrop coke;
mydrop petr;
mydrop dies;
mydrop benz;
mydrop paraf;
mydrop lgas;
mydrop pgas;
mydrop fwood;
mydrop greas;
mydrop lube;
mydrop wati;
mydrop watd;
drop ofuelpr rofuelval ofuelpr79 intmat rintmat intmatusd 
rintmatusd rwat indyr prind80 epr mepr; 

save merged3, replace;

