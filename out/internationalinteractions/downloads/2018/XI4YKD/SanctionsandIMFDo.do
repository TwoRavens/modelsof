* Replication Do file for Peksen and Woo, "Economic Sanctions and the Politics of IMF Lending"

*Authors' Note: Models are estimated in Stata 13 using the CMP package. Install the CMP package ( run "ssc install cmp" and then "ssc install ghk2") first in stata to be able to run the models.  

*Table 1
*Sanctions only
cmp setup
cmp (imfprogram = sanction limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
*sanctions and econ variables
cmp (imfprogram = sanction growth gdppc reserves currencycrisis limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
*sanctions and political variables
cmp (imfprogram = sanction polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
*Full model
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly


*Table 2
*Major Cost vs. Minor Costs Sanctions
cmp (imfprogram = majsanct minsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
*Human Rights vs. Non-Human Rights Sanctions
cmp (imfprogram = humansanctions nonhumansanctions growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
* IO Sanctions
cmp (imfprogram = sanction intlorgsend growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
* US Sanctions
cmp (imfprogram = sanction USunilateral growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
*outreg2 using mod4400, excel  dec(3)
*Sanctions by Western country senders
cmp (imfprogram = sanction westernsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un  limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
*outreg2 using mod4500, excel  dec(3)

*Figure 1 Marginal/Substantive Effects
*All sanctions
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
margins, at((mean) _all sanction=0 civilwar=0 laglegiselect=0 lagexecelect=0 currencycrisis=0) predict(equation(imfprogram) pr) force
margins, at((mean) _all sanction=1 civilwar=0 laglegiselect=0 lagexecelect=0 currencycrisis=0) predict(equation(imfprogram) pr) force

*Major vs minor cost sanctions
cmp (imfprogram = majsanct minsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1) if minsanct==0, nolr ind($cmp_probit $cmp_probit) quietly
margins, at((mean) _all majsanct=1 civilwar=0 laglegiselect=0 lagexecelect=0 currencycrisis=0) predict(equation(imfprogram) pr) force

cmp (imfprogram = majsanct minsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1) if majsanct==0, nolr ind($cmp_probit $cmp_probit) quietly
margins, at((mean) _all minsanct=1 civilwar=0 laglegiselect=0 lagexecelect=0 currencycrisis=0) predict(equation(imfprogram) pr) force

*Human rights vs non-human rights sanctions
cmp (imfprogram = humansanctions nonhumansanctions growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1) if nonhumansanctions==0, nolr ind($cmp_probit $cmp_probit) quietly
margins, at((mean) _all humansanctions=1 civilwar=0 laglegiselect=0 lagexecelect=0 currencycrisis=0) predict(equation(imfprogram) pr) force

cmp (imfprogram = humansanctions nonhumansanctions growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1) if humansanctions==0, nolr ind($cmp_probit $cmp_probit) quietly
margins, at((mean) _all nonhumansanctions=1 civilwar=0 laglegiselect=0 lagexecelect=0 currencycrisis=0) predict(equation(imfprogram) pr) force

*US sender [US involved sanctions]
cmp (imfprogram = USsanctions growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1) if nonUSsanct==0, nolr ind($cmp_probit $cmp_probit) quietly
margins, at((mean) _all USsanctions=1 civilwar=0 laglegiselect=0 lagexecelect=0 currencycrisis=0) predict(equation(imfprogram) pr) force

*IO Sender
cmp (imfprogram = intlorgsend growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1) if nonUSsanct==0 | USunilateral==0, nolr ind($cmp_probit $cmp_probit) quietly
margins, at((mean) _all intlorgsend=1 civilwar=0 laglegiselect=0 lagexecelect=0 currencycrisis=0) predict(equation(imfprogram) pr) force

*Western Sender
cmp (imfprogram = westernsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un  limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1) if nonUSsanct==0, nolr ind($cmp_probit $cmp_probit) quietly
margins, at((mean) _all westernsanct=1 civilwar=0 laglegiselect=0 lagexecelect=0 currencycrisis=0) predict(equation(imfprogram) pr) force


*Table A1 Summary Statistics
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly

sum imfprogram sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un fdilog tradelog

cmp (imfprogram = majsanct minsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
sum majsanct minsanct if e(sample)

cmp (imfprogram = humansanctions nonhumansanctions growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
sum humansanctions nonhumansanctions if e(sample)

cmp (imfprogram = sanction intlorgsend growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
sum intlorgsend if e(sample)

cmp (imfprogram = sanction USunilateral growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
sum USunilateral if e(sample)

cmp (imfprogram = sanction westernsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un  limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
sum westernsanct if e(sample)

*Table A2 List of Countries
cmp (imfprogram = sanction limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
tab vt_countryname2 if e(sample)

*Table A3 Single Stage Random Effects Models
xtlogit imfprogram sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year, nolog
xtlogit imfprogram majsanct minsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year, nolog
xtlogit imfprogram humansanctions nonhumansanctions growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year, nolog
xtlogit imfprogram sanction intlorgsend growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year, nolog
xtlogit imfprogram sanction USunilateral growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year, nolog
xtlogit imfprogram sanction westernsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year, nolog



*ONLINE APPENDIX
*Online Appendix Table - Post-Sanctions Effects
cmp (imfprogram = oneyearaftersanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg  vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = twoyearaftersanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = threeyearaftersanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = fouryearaftersanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = fiveyearaftersanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly

*Online Appendix Table - Country fixed-effects
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year i.cowcode) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = majsanct minsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year i.cowcode) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = humansanctions nonhumansanctions growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year i.cowcode) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = sanction intlorgsend growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year i.cowcode) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = sanction USunilateral growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un limft limft2 limft3 i.year i.cowcode) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = sanction westernsanct growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un  limft limft2 limft3 i.year i.cowcode) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly


*Online Appendix Table with Additional Controls (Economic Globalization, Social Globalization, and Debt)
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un wdi_tds limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un dr_eg limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un dr_sg limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly


*Online Appendix Table Checks with alternative "external ties" variables(1) Colonial Ties (2) US Alliance
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un colbrit colfra limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un usalliance limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
cmp (imfprogram = sanction growth gdppc reserves currencycrisis polity2 repress civilwar laglegiselect lagexecelect dr_pg vt_s2un colbrit colfra usalliance limft limft2 limft3 i.year) (sanction = gdppc1 polity21 repress1 fdilog tradelog civilwar1 vt_s2un1), nolr ind($cmp_probit $cmp_probit) quietly
