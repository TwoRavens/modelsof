* Table 1
preserve
drop if name=="Azerbaijan"
drop if name=="Belarus"
drop if name=="Czech Republic"
drop if name=="Croatia"
drop if name=="Ethiopia"
drop if name=="Guinea-Bissau"
drop if name=="Kazakhstan"
drop if name=="Kenya"
drop if name=="Kyrgyz Republic"
drop if name=="Lithuania"
drop if name=="Madagascar"
drop if name=="Mauritania"
drop if name=="Moldova"
drop if name=="Morocco"
drop if name=="Nicaragua"
drop if name=="Rwanda"
drop if name=="Swaziland"
drop if name=="Trinidad and Tobago"
drop if name=="Tunisia"
drop if name=="Turkey"
drop if name=="Uzbekistan"
drop if name=="Yugoslavia, FR (Serbia/Montenegro)"
drop if name=="Zimbabwe"
quietly xi: xtreg lnrobberyrate giniwider lngdp lngdpsq femlab politypositive humanrights, fe
su lnrobberyrate giniwider  incratioalltop lngdp econgrowth emtotunem  urban femlab male1564 politypositive humanrights  if e(sample)
restore

* Table 2
preserve
quietly xtdata giniwider incratioalltop lnrobberyrate lngdp lngdpsq econgrowth emtotunem  urban femlab male1564   politypositive humanrights , fe
corr lnrobberyrate giniwider incratioalltop lngdp lngdpsq econgrowth emtotunem  urban femlab male1564   politypositive humanrights 
restore

* Table 3
* Deleting countries with only one observation
preserve
drop if name=="Azerbaijan"
drop if name=="Belarus"
drop if name=="Czech Republic"
drop if name=="Kazakhstan"
drop if name=="Lithuania"
drop if name=="Moldova"
drop if name=="Morocco"
drop if name=="Nicaragua"
drop if name=="Trinidad and Tobago"
drop if name=="Tunisia"
drop if name=="Turkey"
drop if name=="Uzbekistan"
drop if name=="Ukraine"
xi: xtreg lnrobberyrate giniwider lngdp econgrowth urban if flldummyrobbery==1, fe
outreg using c:\table1, replace 3aster se
xi: xtreg lnrobberyrate giniwider lngdp lngdpsq econgrowth emtotunem   urban femlab male1564    politypositive humanrights   if flldummyrobbery==1, fe
outreg using c:\table1, append 3aster se
xi: xtreg lnrobberyrate giniwider lngdp lngdpsq econgrowth emtotunem   urban femlab male1564    politypositive humanrights  , fe
outreg using c:\table1, append 3aster se
xi: xtreg lnrobberyrate giniwider lngdp lngdpsq emtotunem   femlab politypositive humanrights if e(sample) , fe
outreg using c:\table1, append 3aster se
restore

* Deleting countries with only one observation
preserve
drop if name=="Azerbaijan"
drop if name=="Belarus"
drop if name=="Czech Republic"
drop if name=="Croatia"
drop if name=="Ethiopia"
drop if name=="Guinea-Bissau"
drop if name=="Kazakhstan"
drop if name=="Kenya"
drop if name=="Kyrgyz Republic"
drop if name=="Lithuania"
drop if name=="Madagascar"
drop if name=="Mauritania"
drop if name=="Moldova"
drop if name=="Morocco"
drop if name=="Nicaragua"
drop if name=="Rwanda"
drop if name=="Swaziland"
drop if name=="Trinidad and Tobago"
drop if name=="Tunisia"
drop if name=="Turkey"
drop if name=="Uzbekistan"
drop if name=="Yugoslavia, FR (Serbia/Montenegro)"
drop if name=="Zimbabwe"
xi: xtreg lnrobberyrate giniwider lngdp lngdpsq femlab politypositive humanrights, fe
outreg using c:\table1, append 3aster se
restore

xi: xtabond2 lnrobberyrate llnrobberyrate giniwider  lngdp lngdpsq econgrowth emtotunem  urban femlab male1564  politypositive humanrights , gmm(llnrobberyrate giniwider  lngdp lngdpsq econgrowth emtotunem   urban femlab male1564  politypositive humanrights)
*outreg using c:\table1, append 3aster se
xi: xtabond2 lnrobberyrate llnrobberyrate giniwider  econgrowth emtotunem  , gmm(llnrobberyrate giniwider  econgrowth emtotunem )
*outreg using c:\table1, append 3aster se
* Deleting countries with only one observation
preserve
drop if name=="Azerbaijan"
drop if name=="Belarus"
drop if name=="Czech Republic"
drop if name=="Kazakhstan"
drop if name=="Lithuania"
drop if name=="Moldova"
drop if name=="Morocco"
drop if name=="Nicaragua"
drop if name=="Trinidad and Tobago"
drop if name=="Tunisia"
drop if name=="Turkey"
drop if name=="Uzbekistan"
drop if name=="Ukraine"
xi: xtreg lnrobberyrate giniwider  lngdp lngdpsq econgrowth emtotunem   urban femlab male1564    politypositive humanrights  , re
outreg using c:\table1, append 3aster se
xthaus
restore

* Table 4
* Deleting countries with only one observation
preserve
drop if name=="Belarus"
drop if name=="Colombia"
drop if name=="Czech Republic"
drop if name=="Ecuador"
drop if name=="Honduras"
drop if name=="Japan"
drop if name=="Latvia"
drop if name=="Luxembourg"
drop if name=="Morocco"
drop if name=="Nicaragua"
drop if name=="Slovak Republic"
drop if name=="Sri Lanka"
drop if name=="Thailand"
drop if name=="Tunisia"
xi: xtreg lnrobberyrate incratioalltopto lngdp econgrowth urban if flldummyrobbery==1, fe
outreg using c:\table2, replace 3aster se
xi: xtreg lnrobberyrate incratioalltopto lngdp lngdpsq econgrowth emtotunem   urban femlab male1564    politypositive humanrights   if flldummyrobbery==1, fe
outreg using c:\table2, append 3aster se
xi: xtreg lnrobberyrate incratioalltopto lngdp lngdpsq econgrowth emtotunem   urban femlab male1564    politypositive humanrights  , fe
outreg using c:\table2, append 3aster se
xi: xtreg lnrobberyrate incratioalltopto lngdp lngdpsq   femlab politypositive humanrights if e(sample) , fe
outreg using c:\table2, append 3aster se
restore

* Deleting countries with only one observation
preserve
drop if name=="Armenia"
drop if name=="Belarus"
drop if name=="Colombia"
drop if name=="Czech Republic"
drop if name=="Ecuador"
drop if name=="Guinea-Bissau"
drop if name=="Honduras"
drop if name=="Japan"
drop if name=="Kenya"
drop if name=="Latvia"
drop if name=="Luxembourg"
drop if name=="Madagascar"
drop if name=="Morocco"
drop if name=="Nicaragua"
drop if name=="Rwanda"
drop if name=="Senegal"
drop if name=="Slovak Republic"
drop if name=="Sri Lanka"
drop if name=="Thailand"
drop if name=="Tunisia"
drop if name=="Ukraine"
drop if name=="Yugoslavia, FR (Serbia/Montenegro)"
drop if name=="Zambia"
drop if name=="Zimbabwe"
xi: xtreg lnrobberyrate incratioalltopto lngdp lngdpsq   femlab politypositive humanrights, fe
outreg using c:\table2, append 3aster se
restore

xi: xtabond2 lnrobberyrate llnrobberyrate incratioalltopto lngdp lngdpsq econgrowth emtotunem  urban femlab male1564  politypositive humanrights , gmm(llnrobberyrate incratioalltopto lngdp lngdpsq econgrowth emtotunem   urban femlab male1564  politypositive humanrights)
*outreg using c:\table2, append 3aster se
xi: xtabond2 lnrobberyrate llnrobberyrate incratioalltopto econgrowth emtotunem  male1564  , gmm(llnrobberyrate incratioalltopto  econgrowth emtotunem male1564   )
*outreg using c:\table2, append 3aster se

* Deleting countries with only one observation
preserve
drop if name=="Belarus"
drop if name=="Colombia"
drop if name=="Czech Republic"
drop if name=="Ecuador"
drop if name=="Honduras"
drop if name=="Japan"
drop if name=="Latvia"
drop if name=="Luxembourg"
drop if name=="Morocco"
drop if name=="Nicaragua"
drop if name=="Slovak Republic"
drop if name=="Sri Lanka"
drop if name=="Thailand"
drop if name=="Tunisia"
xi: xtreg lnrobberyrate incratioalltopto lngdp lngdpsq econgrowth emtotunem   urban femlab male1564    politypositive humanrights  , re
outreg using c:\table2, append 3aster se
xthaus
restore
