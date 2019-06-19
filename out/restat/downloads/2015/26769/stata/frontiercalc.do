#delim;

qui {;
set more off;
pause on;
/*Oct-27-2009*/ 
/*calculates frontier proxy for gmm_structural.do*/

/*truncate tau distribution before calc mean of top decile*/
by touse $ind $yr, sort: egen p99=pctile($tau), p(99);
by touse $ind $yr, sort: egen p90=pctile($tau), p(90);
*by touse      $yr, sort: egen p99=pctile($tau), p(99);
*by touse      $yr, sort: egen p90=pctile($tau), p(90);

gen infro=1 if $tau<p99 & $tau>=p90 & touse==1;

sort $id $yr;
gen x=($tau+L.$tau)/2 if infro==1 & L.infro==1;

preserve;
	keep if infro==1;
	by $ind $yr, sort: egen x1=mean(x);
	format x1 %20.0g;
	gen str24 y=(string($yr)+string($ind)+string(x1,"%20.0g"));
	destring y, replace force; format y %24.0g;
	tab y, matrow(z); 
	drop _all;
	svmat double z;
	gen $yr  = real(substr(string(z1,"%20.0g"),1,4));
	gen $ind = real(substr(string(z1,"%20.0g"),5,2));
	gen fro  = real(substr(string(z1,"%20.0g"),7,length(string(z1,"%20.0g"))));
	sort $ind $yr;
	save "$temppath\temp.dta", replace;
restore;
drop x p90 p99 infro;
sort $ind $yr;
merge $ind $yr using "$temppath\temp", keep(fro) update;
tab _merge; drop if _merge==2; drop _merge;

}; /*end of main qui block*/;
