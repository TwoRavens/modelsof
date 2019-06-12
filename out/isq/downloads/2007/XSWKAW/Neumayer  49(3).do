set matsize 800

* Table 2
quietly xi: areg lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free freesq pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead i.year if developing==1, absorb(country) cluster(country)
su lneuplusasyl euplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free polity pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead bnksum distmineurope christ colsec aidi tradei arrivalsi if e(sample)
su freesq if e(sample)


* Appendix 1
preserve
collapse euplusasyl  if e(sample), by(name)
list name
restore

* Table 3
xi: areg lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free freesq pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead i.year if developing==1, absorb(country) cluster(country)
xi: xtgee lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free freesq pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead distmineurope christ colsec i.year if developing==1, robust
xi: xtgee lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free freesq pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead bnksum distmineurope christ colsec i.year if developing==1, robust
xi: xtgee lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free  pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead bnksum distmineurope christ colsec aidi tradei arrivalsi i.year if developing==1, robust

*Outlier analysis, excluding Yugoslavia
xi: areg lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free freesq pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead i.year if developing==1 & balkan!=1, absorb(country) cluster(country)
xi: xtgee lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free freesq pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead distmineurope christ colsec i.year if developing==1 & balkan!=1, robust

*Outlier analysis more formally
preserve
quietly  xi: fit lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free freesq pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead i.year if developing==1
capture drop dfits
fpredict dfits, dfits
gsort -dfits
* list name dfits shcode6 if dfits~=.
capture drop excl1
generate excl1=0
replace excl1=1 if abs(dfits)> 2*((_result(3)+1)/(_result(1)))^(1/2)
list name dfits if dfits~=. & excl1==1
xi: areg lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free freesq pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead i.year if developing==1 & excl1!=1, absorb(country) cluster(country)
xi: xtgee lneuplusasyl year52lneuplusasyl lngdp growthrate3years  lnpop ecdis free freesq pts sfallmax genpoliticidemag uppsalaexternalintensity urban sharepop1564 food sumdead distmineurope christ colsec i.year if developing==1 & excl1!=1, robust
restore



