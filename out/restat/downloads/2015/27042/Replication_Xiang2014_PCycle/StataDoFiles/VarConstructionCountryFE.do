
#delimit;
  
sort msic87;
*egen x=sum(fobSng), by(msic87); 
*egen y=sum(fobNng), by(msic87);
*drop if x==0 & y==0; 
*drop x y; log on; 
************many many zero trade flows, even at country-industry-year levels, especially for new goods;
count; count if fobNng==0; count if fobNog==0; count if fobSng==0; count if fobSog==0; 
gen dd=(fobSng/fobSog)/(fobNng/fobNog); gen ddlog=log(dd+1); ***preserving dd==0 obs; log off; 

gen t=year-77; gen t2=t*t; 
encode msic87, gen (ind); ***from 1 to 265; sort ind; 
gen tb=.; gen tse=.; gen t2b=.; gen t2se=.; gen tblog=.; gen tselog=.; gen t2blog=.; 
gen t2selog=.;gen vt=fobSng+fobSog+fobNng+fobNog; by msic87 wtdbcode, sort: egen vtbar=mean(vt); egen time=group(t);

gen taoSng=(cifSng-fobSng)/fobSng; gen taoSog=(cifSog-fobSog)/fobSog;
gen taoNng=(cifNng-fobNng)/fobNng; gen taoNog=(cifNog-fobNog)/fobNog;

count if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0; 
sum tao* if taoSng>=0 & taoSog>=0 & taoNng>=0 & taoNog>=0; 
gen ddtao=(taoSng/taoSog)/(taoNng/taoNog);
replace ddtao=. if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0;
gen ddlogtao=log(ddtao+1); ***preserving ddtao==0 obs.;

*************minimize 0 issue: replace 0 flows with 1; 
foreach x of varlist fobNog fobNng cifNog cifNng fobSog fobSng cifSog cifSng {;
  replace `x'=1 if `x'==0;
};
gen dd2=(fobSng/fobSog)/(fobNng/fobNog); 
gen ddlog2=log(dd2);

gen vt2=fobSng+fobSog+fobNng+fobNog; by msic87 wtdbcode, sort: egen vtbar2=mean(vt2); 

replace taoSng=(cifSng-fobSng)/fobSng; replace taoSog=(cifSog-fobSog)/fobSog;
replace taoNng=(cifNng-fobNng)/fobNng; replace taoNog=(cifNog-fobNog)/fobNog;

count if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0; 
sum tao* if taoSng>=0 & taoSog>=0 & taoNng>=0 & taoNog>=0; 
gen ddtao2=(taoSng/taoSog)/(taoNng/taoNog);
replace ddtao2=. if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0;
gen ddlogtao2=log(ddtao2+1);

*************************************************manually run weighted LS, Stata aweight option***************;

gen ddlog2W=ddlog*sqrt(vtbar); gen tW=t*sqrt(vtbar); gen t2W=t2*sqrt(vtbar); gen ddlogtao2W=ddlogtao*sqrt(vtbar); 
gen constantW=sqrt(vtbar); 
