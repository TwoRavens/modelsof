

**** A description of variable names: 

* terroristattacks - this variable includes the number of both domestic and international terror attacks
* muslimdec - this is the percentage of the population that is muslim for each country
* lngdp - logged gdp/capita
* lnpop - logged country population 
* polity2 - Polity score 
* totalcivil - dummy variable for the presence of civil war in a country (ACD)
* intcivboth1k - dummy variable for the presence of civil war in a country (ACD) that eventually reached 1000 BD 
* NumberConflicts - count variable for the number of civil conflicts in a country (ACD) [lower BD threshold] 
* post_gwot - dummy variable for pre-and post-2001 observations
* intwest - dummy variable for military intervnetion by either U.S., U.K. or FR. 

* (conflictbinary - dummy variable for the presence of any of the four categores of war in the ACD--**not used in paper) 

* domesticattacks - number of domestic terror observations 
* intlattacks - number of international terror observations 
* unknown - number of terror attacks whose domestic or international attribution is not given
* reviseddom - adds all of the ÕunknownÕ terror observations to the variable domesticattacks
* revisedint - adds all of the ÕunknownÕ terror observations to the variable intlattacks
* reviseddom - counts all domestic attacks when all ÔunknownÕ attacks are apportioned by country using historical county averages. If country averages are not known the global average is used to apportion the unknown attacks
* revisedint - counts all international attacks when all ÔunknownÕ attacks are apportioned by country using historical county averages. If country averages are not known the global average is used to apportion the unknown attacks
* oneyearlag - counts the number of ÔterroristattacksÕ from the previous year in each country



** Table 2 
** Model 1 (Model 2: repeat but drop Afg, Iraq)
nbreg terroristattacks muslimdec lngdp lnpop polity2 totalcivil intwest post_gwot, cluster(ccode) nolog irr

**** Model 3
*** for Domestic: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg reviseddom muslimdec lngdp lnpop polity2 totalcivil intwest post_gwot, cluster(ccode) nolog irr

*** Model 4 BD > 1000
* for Domestic: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg reviseddom muslimdec lngdp lnpop polity2 intcivboth1k intwest post_gwot, cluster(ccode) nolog irr


*** Model 5 
*** for International: apportioning unknowns by observed percentages by country, when all unknown use global avg 
nbreg revisedint muslimdec lngdp lnpop polity2 totalcivil intwest post_gwot, cluster(ccode) nolog irr

*** Model 6 BD > 1000
*** for International: apportioning unknowns by observed percentages by country, when all unknown use global avg 
nbreg revisedint muslimdec lngdp lnpop polity2 intcivboth1k intwest post_gwot, cluster(ccode) nolog irr




*** Table 3
***  Model 7 
*** for Domestic: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg reviseddom muslimdec lngdp lnpop polity2 totalcivil intwest 1.post_gwot post_muslim, cluster(ccode) nolog irr

***  Model 8 BD > 1000
*** for Domestic: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg reviseddom muslimdec lngdp lnpop polity2 intcivboth1k intwest 1.post_gwot post_muslim, cluster(ccode) nolog irr


*** Model 9 
*** for International: apportioning unknowns by observed percentages by country, when all unknown use global avg 
nbreg revisedint muslimdec lngdp lnpop polity2 totalcivil intwest 1.post_gwot post_muslim, cluster(ccode) nolog irr

*** Model 10 BD>1000
*** for International: apportioning unknowns by observed percentages by country, when all unknown use global avg 
nbreg revisedint muslimdec lngdp lnpop polity2 intcivboth1k intwest 1.post_gwot post_muslim, cluster(ccode) nolog irr


*** Begin Table 4 Split-sample Models
** Model 11 
*** for Domestic: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg reviseddom muslimdec lngdp lnpop polity2 intcivboth1k intwest if Year<=2001, cluster(ccode) nolog irr

*** Model 12
*** for Domestic: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg reviseddom muslimdec lngdp lnpop polity2 intcivboth1k intwest if Year>2001, cluster(ccode) nolog irr


** Model 14 
*** for International: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg revisedint muslimdec lngdp lnpop polity2 intcivboth1k intwest if Year<=2001, cluster(ccode) nolog irr

*** Model 15
*** for International: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg revisedint muslimdec lngdp lnpop polity2 intcivboth1k intwest if Year>2001, cluster(ccode) nolog irr


************** for graphics. Margin and Confidence intervals for figures 3 and 4

**  Figure 3a
nbreg reviseddom muslimdec lngdp lnpop polity2 totalcivil if Year<=2001, cluster(ccode) nolog irr
margins, at(muslimdec=(0(.1)1)) atmeans vsquish post
*   Figure 3b
nbreg reviseddom muslimdec lngdp lnpop polity2 totalcivil if Year>2001, cluster(ccode) nolog irr
margins, at(muslimdec=(0(.1)1)) atmeans vsquish post

** Figure 4a
nbreg revisedint muslimdec lngdp lnpop polity2 totalcivil if Year<=2001, cluster(ccode) nolog irr
margins, at(muslimdec=(0(.1)1)) atmeans vsquish post
* Figure 4b
nbreg revisedint muslimdec lngdp lnpop polity2 totalcivil if Year>2001, cluster(ccode) nolog irr
margins, at(muslimdec=(0(.1)1)) atmeans vsquish post

********************* Models for online appendix / supp file begin here


**** Table 2.A 
***********

** Models 1a and 1b
*** Change cut year to 2002
nbreg terroristattacks muslimdec lngdp lnpop polity2 totalcivil intwest if Year<=2002, cluster(ccode) nolog irr
nbreg terroristattacks muslimdec lngdp lnpop polity2 totalcivil intwest if Year>2002, cluster(ccode) nolog irr

*** Models 2a and 2b
*** Change cut year to 2003
nbreg terroristattacks muslimdec lngdp lnpop polity2 totalcivil intwest if Year<=2003, cluster(ccode) nolog irr
nbreg terroristattacks muslimdec lngdp lnpop polity2 totalcivil intwest if Year>2003, cluster(ccode) nolog irr



*** Table 3.A

zinb reviseddom muslimdec lngdp lnpop polity2 totalcivil 1.post_gwot post_muslim,inflate(muslimdec totalcivil 1.post_gwot post_muslim) cluster(ccode) nolog irr

zinb revisedint muslimdec lngdp lnpop polity2 totalcivil  1.post_gwot post_muslim,inflate(muslimdec totalcivil 1.post_gwot post_muslim) cluster(ccode) nolog irr


 
** ************************ Table 4.A  
** Model 1 
** only regress on domestic attacks (all missing / unknown are omitted)
nbreg domesticattacks muslimdec lngdp lnpop polity2 totalcivil post_gwot, cluster(ccode) nolog irr

** Model 2 
** ** only regress on interntional attacks (all missing / unknown are omitted)
nbreg intlattacks muslimdec lngdp lnpop polity2 totalcivil post_gwot, cluster(ccode) nolog irr

**** Model 3 
*** regress only on unknown  
nbreg unknown muslimdec lngdp lnpop polity2 totalcivil post_gwot, cluster(ccode) nolog irr

** Model 4 
*** treat all unknown as domestic attacks
nbreg domunknown muslimdec lngdp lnpop polity2 totalcivil post_gwot, cluster(ccode) nolog irr

*** Model 5
***** treat all unknown as international attacks
nbreg intunknown muslimdec lngdp lnpop polity2 totalcivil post_gwot, cluster(ccode) nolog irr

*** Model 6
*** for Domestic: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg reviseddom muslimdec lngdp lnpop polity2 totalcivil post_gwot, cluster(ccode) nolog irr

** Model 7 
*** for International: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg revisedint muslimdec lngdp lnpop polity2 totalcivil post_gwot, cluster(ccode) nolog irr

 
************* Table 5.A ************************* 
** 1-year lags *** 

*** Model 1 (repeat this model noAFRAQ data--Model 3)
nbreg terroristattacks muslimdec lngdp lnpop polity2 totalcivil post_gwot oneyearlag, cluster(ccode) nolog irr

*** Model 2 (repeat this model noAFRAQ data--Model 4)
nbreg terroristattacks muslimdec lngdp lnpop polity2 NumberConflicts post_gwot oneyearlag, cluster(ccode) nolog irr

**Model 3 and Model 4 repeat respectively Models 1 and 2 above but with the noAFRAQ dataset.  

*********** Table 6.A *************
** Model 5 
** only regress on domestic attacks (all missing / unknown are omitted)
nbreg domesticattacks muslimdec lngdp lnpop polity2 totalcivil post_gwot oneyearlag, cluster(ccode) nolog irr

*** Model 6
*** only regress on international attacks (all missing / unknown are omitted)
nbreg intlattacks muslimdec lngdp lnpop polity2 totalcivil post_gwot oneyearlag, cluster(ccode) nolog irr

*** Model 7
**** regress only on unknown 
nbreg unknown muslimdec lngdp lnpop polity2 totalcivil post_gwot oneyearlag, cluster(ccode) nolog irr

*** Model 8
*** treat all unknown as domestic attacks
nbreg domunknown muslimdec lngdp lnpop polity2 totalcivil post_gwot oneyearlag, cluster(ccode) nolog irr

*** Model 9
***** treat all unknown as interanational attacks
nbreg intunknown muslimdec lngdp lnpop polity2 totalcivil post_gwot oneyearlag, cluster(ccode) nolog irr

**** Model 10
*** for Domestic: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg reviseddom muslimdec lngdp lnpop polity2 totalcivil post_gwot oneyearlag, cluster(ccode) nolog irr

*** model 11
*** for International: apportioning the unknowns by observed percentages by country, when all unknown use global avg 
nbreg revisedint muslimdec lngdp lnpop polity2 totalcivil post_gwot oneyearlag, cluster(ccode) nolog irr


**** *************** Table 7.A  interactions  **********

*** Model 12  (repeat this model no AFRAQ--Model 13 )
nbreg terroristattacks muslimdec lngdp lnpop polity2 oneyearlag post_gwot totalcivil post_muslim, cluster(ccode) nolog irr

*** Model 13 repeat Model 12 with noAFRAQ data

*** Model 14 only regress on domestic (unknowns are omitted)
nbreg domesticattack muslimdec lngdp lnpop polity2 totalcivil 1.post_gwot post_muslim oneyearlag, cluster(ccode) nolog irr

*** Model 15 only regress on international (unknowns are omitted)
nbreg intlattacks muslimdec lngdp lnpop polity2 totalcivil 1.post_gwot post_muslim oneyearlag, cluster(ccode) nolog irr

*** Model 16 
****** for Domestic: apportioning the unknowns by observed percentages by country, when all unknown use global avg
nbreg reviseddom muslimdec lngdp lnpop polity2 totalcivil 1.post_gwot post_muslim oneyearlag, cluster(ccode) nolog irr

*** Model 17 (repeat this model no AFRAQ -- Model 18)
nbreg revisedint muslimdec lngdp lnpop polity2 totalcivil 1.post_gwot post_muslim oneyearlag, cluster(ccode) nolog irr

*** Model 18 repeat Model 17 with noAFRAQ data


*************** TAble 8.A ******************

** Model 1
nbreg reviseddom muslimdec lngdp lnpop polity2 totalcivil if Year<=2001, cluster(ccode) nolog irr

*  Model 2 
nbreg reviseddom muslimdec lngdp lnpop polity2 totalcivil if Year>2001, cluster(ccode) nolog irr

** Model 3 
nbreg revisedint muslimdec lngdp lnpop polity2 totalcivil if Year<=2001, cluster(ccode) nolog irr

* Model 4
nbreg revisedint muslimdec lngdp lnpop polity2 totalcivil if Year>2001, cluster(ccode) nolog irr




