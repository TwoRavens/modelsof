* ============================================================================================================
* Replication Do-File for AJPS-Article "Voting against your constituents? How lobbying affects representation"
* by Nathalie Giger and Heike Klüver, 03.02.2015
*
* SUPPLEMENTARY MATERIAL
* ============================================================================================================



*Final Dataset 

use Giger_Kluever_Replication.dta, clear

*===========================================
*TABLE 1
*===========================================

sum defect econ_no ngo_no party_econ_no  party_ngo_no mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak

*==========================================
* TABLE 3 
*==========================================

*Model 1: Sectional group ties
xtmelogit  defect econ_no party_econ_no mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace nolog
estat ic

*Model 2: Cause group ties
xtmelogit  defect  ngo_no party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace nolog
estat ic

*Model 3: Fixed effects for legislative terms
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak period2 period3 period4 || _all: mp_canton || party: , var laplace  nolog
estat ic

*==========================================
* TABLE 4 
*==========================================

*Model 4: Party fixed effects
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak party_dummy5 party_dummy8 party_dummy9 party_dummy11 ///
party_dummy19 party_dummy20 || _all: mp_canton || party: , var laplace  nolog
estat ic

*Model 5: Party family fixed effects
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak parfam_dummy1 parfam_dummy2 parfam_dummy3 parfam_dummy4 parfam_dummy6 parfam_dummy7 parfam_dummy8 ///
 || _all: mp_canton || party: , var laplace  nolog
estat ic

*Model 6: Policy area fixed effects
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak polarea1- polarea17 || _all: mp_canton || party: , var laplace  nolog
estat ic


*==========================================
* TABLE 5 
*==========================================

*Model 7: Protest events as additional control
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak protest_igs || _all: mp_canton || party: , var laplace nolog
estat ic

*Model 8: Controlling for whether district voted as CH
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak CantonCHMatch50 || _all: mp_canton || party: , var laplace nolog
estat ic

*==========================================
* TABLE 6 
*==========================================

*Model 9: Only IGs in which MPs hold executive function
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: if memberonly!=1, var laplace nolog
estat ic

*Model 10: Combined effect of cause and sectional group ties
xtmelogit  defect ig_number  party_ig_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party:  , var laplace nolog
estat ic

*==========================================
* TABLE 7 
*==========================================

*Model 11: Interaction between district magnitude and interest groups (sectional groups MP level)
xtmelogit defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak dm_econ || _all: mp_canton || party: , var laplace nolog
estat ic

*Model 12: Interaction between district magnitude and interest groups (sectional groups Party level)
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak dm_econ_party || _all: mp_canton || party: , var laplace nolog
estat ic

*Model 13: Interaction between district magnitude and interest groups (cause groups MP level)
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak dm_ngo  || _all: mp_canton || party: , var laplace nolog
estat ic 

*Model 14: Interaction between district magnitude and interest groups (cause groups Party level)
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak dm_ngo_party  || _all: mp_canton || party: , var laplace nolog
estat ic

*==========================================
* TABLE 8 
*==========================================

*Model 15: Dependent variable voted with constituents but against party
xtmelogit  constvote econ_no ngo_no party_econ_no  party_ngo_no  mp_number  closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace nolog

*==========================================
* TABLE 9 
*==========================================

*Model 16: Substracting sectional/cause groups (MP level)
xtmelogit  defect substraction_no mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace nolog
estat ic

*Model 17: Substracting sectional/cause groups (Party level)
xtmelogit  defect substraction_noparty  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace  nolog 
estat ic

*Model 18: Substracting sectional/cause groups (full model)
xtmelogit  defect substraction_no substraction_noparty  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace  nolog 
estat ic

*==========================================
* TABLE 10
*==========================================

*Model 19: Party Positions as additional control (MP level)
xtmelogit  defect econ_no ngo_no mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak party_pos || _all: mp_canton || party: , var laplace nolog
estat ic

* Model 20: Party Positions as additional control (Party level)
xtmelogit  defect  party_econ_no party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  party_pos  || _all: mp_canton || party: , var laplace nolog
estat ic

* Model 21: Party Positions as additional control (Full model)
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak party_pos  || _all: mp_canton || party: , var laplace nolog
estat ic

*==========================================
* TABLE 11
*==========================================

* Model 22: Trade Unions coded as sectional group (Indiviudal level)
xtmelogit  defect econ_no2 ngo_no mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace nolog
estat ic

* Model 23: Trade Unions coded as sectional group (Party level)
xtmelogit  defect party_econ_no2 party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace nolog
estat ic

* Model 24: Trade Unions coded as sectional group (Full model)
xtmelogit  defect econ_no2 ngo_no party_econ_no2  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace nolog
estat ic




