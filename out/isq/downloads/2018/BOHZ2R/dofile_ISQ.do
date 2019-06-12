
###### Do file to replicate "Before Ratification: Understanding the Timing of International Treaty Effects on Domestic Policies" (by Baccini and Urpelainen)

##### Use the file dataset_ISQ.dta

####### To run this dofile you need STATA 11 or STATA 12 and to download the following packages in STATA:
####### 1) clarify from 'http://gking.harvard.edu/clarify'
####### 2) cem (findit cem)
####### 3) rc_spline (findit rc_spline)
####### 4) parmest (findit rc_spline) 
 

###### Table 2

  ##### Baseline models

xi: probit dv_dummy3 regime btw_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r

xi: probit dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r

xi: probit dv_dummy3 regime btw_max inforce_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r

   

   ###### Dropping first years and last years of the time span

xi: probit dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year if year>1993, cluster(id) r

xi: probit dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year if year<2007, cluster(id) r



   ### Adding political variables

xi: probit dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag envaid envirosecretariatlocation i.regio i.year, cluster(id) r

xi: probit dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag envaid envirosecretariatlocation govfrac partisa i.regio i.year, cluster(id) r




######## Table 3 


   ##### Estimating the effects of the main variables using clarify

rename _Iregion_la_2 east_asia

rename _Iregion_la_3 central_aisa

rename _Iregion_la_4 la

rename _Iregion_la_5 mena

rename _Iregion_la_6 south_asia

estsimp probit dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag  east_asia central_aisa la mena south_asia  _Iyear_1994-_Iyear_2007, cluster(id) r

setx mean

simqi, fd(pr) changex(btw_max 0 1)

simqi, fd(pr) changex(regime 0 1)

simqi, fd(pr) changex(spatial 0 1.05)

simqi, fd(pr) changex(gdp 0.8 4)

simqi, fd(pr) changex(wto 0 1)


drop b1-b15



###### Table 4

   ##### Re-estimating models in Table 2 using matching

cem gdppc(2.8 7.4) gdp(2.4 4) wto regime, treatment(btw_max)

xi: probit dv_dummy3 regime btw_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year [iweight= cem_weights] 

xi: probit dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year [iweight= cem_weights] 

xi: probit dv_dummy3 regime btw_max inforce_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year [iweight= cem_weights] 

# xi: probit dv_dummy3 regime btw_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year [iweight= cem_weights] 

# xi: probit dv_dummy3 regime btw_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year [iweight= cem_weights] 

# xi: probit dv_dummy3 regime btw_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year [iweight= cem_weights] 

# xi: probit dv_dummy3 regime btw_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag envaid envirosecretariatlocation i.regio i.year [iweight= cem_weights] 

xi: probit dv_dummy3 regime btw_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag envaid envirosecretariatlocation govfrac partisa i.regio i.year [iweight= cem_weights] 



####### Table 5

   ####### Replacing regime dummy with polity2

xi: probit dv_dummy3 polity2 btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r

xi: probit dv_dummy3 polity2 btw_sum pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r

xi: probit dv_dummy3 polity2 btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year [iweight= cem_weights] 



     ##### Adding polynomials a la Carter and Signorino (2010)

gen polynomial2=polynomial^2

gen polynomial3=polynomial^3

xi: probit dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag polynomial polynomial2 polynomial3 i.regio i.year, cluster(id) r



   ###### Adding splines a la Beck, Katz, and Tucker (1998)

rc_spline polynomial

xi: probit dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag  _Spolynomial1 _Spolynomial2 _Spolynomial3 _Spolynomial4 i.regio i.year, cluster(id) r

xtset id year

xi: xtgee dv_dummy3 regime btw_max pta_neg_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, family(binomial) link(probit) corr(ar1) r



################# APPENDIX ############

###### Table A1


    ##### Placebo tests with th WTO

xi: probit dv_dummy3 regime btw_max wto_pre gdp gdppc spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r

xi: probit dv_dummy3 regime btw_max wto_post gdp gdppc spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r



    ###### Placebo tests with BIT

xi: probit dv_dummy3 regime btw_max bit_btw_max bit_sign_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r

xi: probit dv_dummy3 regime btw_max bit_btw_max bit_inforce_max gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r



########## Table A2


  ##### Testing the the low-hanging fruit argument 

xi: probit dv_dummy3 c.btw_max##c.executiveaccountability gdp gdppc wto spatial_lag_variable air_pollution urban_pop auto_emissions_reg_lag i.regio i.year, cluster(id) r


   #### Plotting the effect of the interaction term graphically

margins, dydx(btw_max) at( executiveaccountability=(-2.3(.1)1.9)) atmeans vsquish post level(90)

matrix at=e(at)

matrix at=at[1...,"executiveaccountability"]

matrix list at

parmest, norestore level(90)

svmat at

twoway (line estimate at1)(line min90 at1)(line max90 at1), legend(off) yline(0) xtitle(continuous variable polity2) ytitle(marginal effect of spatial term)
