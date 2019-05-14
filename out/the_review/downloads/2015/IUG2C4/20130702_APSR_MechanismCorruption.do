


cd "C:\Users\ejm5\Dropbox\District People Councils\Statafiles" 
use statapapi963_final_with_treatment.dta, clear

sort tinh
merge tinh using pci_id_crosswalk2.dta, _merge(_CROSS)
sort pci_id
merge pci_id using provincial_covariates.dta, _merge(_PCI)

generate ln_gdp_cap=ln( gdp_cap)
generate ln_pop=ln(population)
generate ln_distance=ln(distance_hn)
generate ln_area=ln(area)
generate paved_road=1 if d608==4
replace paved_road=0 if d608 <4

generate city=1 if tinh==79|tinh==1|tinh==48|tinh==92|tinh==3
replace city=0 if city==.


by tinh, sort: egen treatment_province=max(treatment)
tab treatment_province
by huyen, sort: egen treatment_district=max(treatment)
tab treatment_district

generate minority=1 if a005 !=1
replace minority=0 if a005==1


egen local_governance_quality=rowmean(d305a d305b d305c d305d)
egen national_governance_quality=rowmean(d305e d305f)
pwcorr local_governance_quality dimension*, star(5)
egen stuff=rowtotal (d611*)
sum stuff


generate ratio_localnational=local_governance/national_governance
tab region, gen(regiondum)

#delimit;
split tenhuyen, generate(district_type) parse(.);
replace district_type1="Q" if  district_type1=="Quan 1"|district_type1=="Quan 11"|district_type1=="Quan 7" 
|district_type1=="Quan Dong Da" |district_type1=="Quan Hai An"|district_type1=="Quan Hoan Kiem"
|district_type1=="Quan Hong Bang"|district_type1=="Quan Ngo Quyen"|district_type1=="Quan Phu Nhuan"
|district_type1=="Quan Tan Phu";
replace district_type1="TP" if  district_type1=="TP Nam Dinh"|district_type1=="TP Ninh Binh"|district_type1=="TP Phu Ly"|district_type1=="TP Thai Binh";
replace district_type1="TX" if  district_type1=="TX Dong Xoai"|district_type1=="TX Gia Nghia"|district_type1=="TX Ha Tien"|district_type1=="TX Phuoc Long"|district_type1=="TX Tay Ninh";

encode district_type1, generate(district_type_code);




#delimit;
set more off;
generate male=a001;
replace male=0 if a001==2;


/********************************************************REPLICATION PUBLIC SERVICE DELIVERY -- APPENDIX F******************************************/


#delimit;
set more off;
mvdecode  a002 minority a017a a003* a009 a004a a011*, mv(111=.a\888=.b\999=.c);
svy: reg paved_road treatment if district_type_code==1 & region !=5;
outreg2 using PAPI, e(rmse) bdec(3) tdec(3) replace;
svy: reg paved_road  treatment i.region i.city if district_type_code==1 & region !=5;
outreg2 using PAPI, e(rmse) bdec(3) tdec(3);

/*Recode d402*/
#delimit;
replace d402a=1 if d402a==2;
replace d402b=1 if d402b==2;
replace d402c=1 if d402c==2;
replace d402d=1 if d402d==2;
replace d402e=1 if d402e==2;
replace d402f=1 if d402f==2;

foreach x in paved_road d609 total_hospital minutes_school total_educ unclean d402a d402b d402c d402d d402e d402f{;
svy: mean `x'  if district_type_code !=2 & district_type_code !=3 & region !=5;
svy: mean `x'  if district_type_code !=2 & district_type_code !=3 & region !=5, over(treatment);
svy: reg  `x' treatment male  a002 minority a017a a011a   i.region i.city  if district_type_code==1 & region !=5;
outreg2 using PAPI, e(rmse) bdec(3) tdec(3);
};

svy: reg paved_road treatment if district_type_code==1 & region !=5;
outreg2 using PAPI, e(rmse) bdec(3) tdec(3) excel;





/********************************************************CORRUPTION ANALYSIS -- APPENDIX G******************************************/
#delimit;
set more off;
svy: reg d402a treatment if district_type_code==1 & region !=5;
outreg2 using PAPI_Corruption, e(rmse) bdec(3) tdec(3) replace;


foreach x in d402a d402e d402f{;
svy: mean `x'  if district_type_code !=2 & district_type_code !=3 & region !=5;
svy: mean `x'  if district_type_code !=2 & district_type_code !=3 & region !=5, over(treatment);
svy: reg  `x' treatment i.region i.city if district_type_code==1 & region !=5;
outreg2 using PAPI_Corruption, e(rmse) bdec(3) tdec(3);
svy: reg  `x' treatment male  a002 minority a017a a011a   i.region i.city  if district_type_code==1 & region !=5;
outreg2 using PAPI_Corruption, e(rmse) bdec(3) tdec(3);
};


/********************Nearest Geographical Neighbor*****************/
#delimit;
drop _merge;
sort huyen;
merge huyen using closest_control.dta;

#delimit;
foreach x in d402a d402e d402f{;
svy: mean `x' if match1==1| match2==1|treatment==1;
};

foreach x in d402a  d402e d402f{;
svy: reg `x' treatment male  a002 minority a017a a011a i.region i.city  if match1==1| match2==1|treatment==1;
outreg2 using PAPI_Corruption, e(rmse) bdec(3) tdec(3);
};





/*Ebalance*/
#delimit;
ebalance treatment male  a002 minority a017a a011a region city ln_gdp_cap ln_pop ln_distance ln_area paved_road electricity_price;

foreach x in d402a  d402e d402f{;
ivreg2 `x' treatment [aweight=_webal], cluster(huyen);
outreg2 using PAPI_Corruption, e(rmse) bdec(3) tdec(3);
};

svy: reg d402a treatment if district_type_code==1 & region !=5;
outreg2 using PAPI_Corruption, e(rmse) bdec(3) tdec(3) excel;



/*Propensity Score Matching*/
#delimit;
generate random=uniform();
sort random;

#delimit;
foreach x in d402a d402e d402f{;
psmatch2  treatment male  a002 minority a017a a011a region city ln_gdp_cap ln_pop ln_distance ln_area paved_road electricity_price, out(`x' ) neighbor(3) quietly;
};



/********************************************************REPLICATION CITIZEN SATISFACTION -- APPENDIX G******************************************/
#delimit;
set more off;
svy: reg d305c treatment if district_type_code==1 & region !=5;
outreg2 using PAPI_Satisfaction, e(rmse) bdec(3) tdec(3) replace;
svy: reg d305c treatment i.region i.city if district_type_code==1 & region !=5;
outreg2 using PAPI_Corruption, e(rmse) bdec(3) tdec(3);


foreach x in d305c d305a d305b d305d d305e d305f d305g d305h local_governance national_governance{;
svy: mean `x'  if district_type_code !=2 & district_type_code !=3 & region !=5;
svy: mean `x'  if district_type_code !=2 & district_type_code !=3 & region !=5, over(treatment);
svy: reg  `x' treatment  if district_type_code==1 & region !=5;
outreg2 using PAPI_Satisfaction, e(rmse) bdec(3) tdec(3);
svy: reg  `x' treatment male  a002 minority a017a a011a   i.region i.city  if district_type_code==1 & region !=5;
outreg2 using PAPI_Satisfaction, e(rmse) bdec(3) tdec(3);
};


svy: reg d305c treatment if district_type_code==1 & region !=5;
outreg2 using PAPI_Satisfaction, e(rmse) bdec(3) tdec(3) excel;
















/*****************************************************************************************************************************/
use "C:\Users\emalesky\Dropbox\District People Councils\Statafiles\corruption_treat.dta", clear
generate low_ate= coeff_treat-1.6*(se_treat)
generate hi_ate= coeff_treat+1.6*(se_treat)
generate coeff_treat2=round(coeff_treat, .001)


#delimit;

label define id 1 "Officials Divert $"  2 "Land Title Birbe" 3 "Hospital Bribe" 4 "Bribe to Teacher" 
5 "Construction Kickback" 6 "Bribe for Gov't Job", replace;
label values id id;

#delimit;
twoway (rcap low_ate hi_ate id,  lcolor(dkgreen) lwidth(thick) msize(medium)) 
(scatter coeff_treat id, msymbol(square) mcolor(green) msize(large) mlab(coeff_treat) mlabsize(small) mlabcolor(black)) , 
xlabel(1(1)6, labels labsize(small) labcolor(black) angle(forty_five) valuelabel) xtitle("") legend(size(small) 
rows(2) label(1 90% CI) label(2 Average Treatment Effect) position(7) ring(0)) ylabel(-.4(.1).2, labsize(small)) 
ytitle("Agree with Statement (%)", size(medium) margin(medsmall)) yline(0, lcolor(red) lpattern(dash) 
lwidth(medthick)) legend(off);

graph save trad.gph, replace;











