

***** Replication material
***** Regional Voices in the EU -- Michaël TATHAM (ISQ, 2014)



******************************************************************************
***** Model testing

**** Capacity and size = BLOCK 1
xtmixed influenceeu eqi_euqogindex _autonomie pop_million ||country_Regio1: ||region_Regio1: ,mle
estat ic

**** Policy allies = BLOCK 2
xtmixed influenceeu centgvthelp comhelp corhelp  ||country_Regio1: ||region_Regio1: ,mle
estat ic

**** Domestic and supranational embeddedbess = BLOCK 3
xtmixed influenceeu freq_contact_NAT_institutions  freq_contact_EU_institutions  _bruessel ||country_Regio1: ||region_Regio1: ,mle
estat ic

**** Full model = BLOCK 4
xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
||country_Regio1: ||region_Regio1: ,mle
estat ic

**** Full model with controls = BLOCK 5
xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
EU_role_in_own_pol_area _regionalsprache regionasnation _regpartei _oppositionzunat ///
||country_Regio1: ||region_Regio1: ,mle
estat ic


******************************************************************************
****** Predicted values graph for comparative statics analysis

* Full model with controls = BLOCK 5
xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
EU_role_in_own_pol_area _regionalsprache regionasnation _regpartei _oppositionzunat ///
||country_Regio1: ||region_Regio1: ,mle
estat ic


margins, at(pop_million==0.21 ) /// Small population #1 /// 3.28 ,CI = 2.696602    3.872553
at(pop_million==18.06 ) /// Large population #2 ///	6.07, CI = 4.615317      7.5282
at(freq_contact_EU_institutions==0) /// low EU embed #3 /// 3.30, CI = 2.750181    3.866618
at(freq_contact_EU_institutions==4) /// high EU embed #4 /// 4.69, CI = 4.054961    5.336272
level (90)	
marginsplot, recast(scatter) yline(2.696602    3.872553 2.750181    3.866618, lstyle(dot))



**************************************************************************
********* interaction effects

generate rai_centhelp = _autonomie*centgvthelp
sum (rai_centhelp)

generate rai_comhelp = _autonomie*comhelp
sum (rai_comhelp)

generate rai_corhelp = _autonomie*corhelp
sum (rai_corhelp)

generate rai_freqnat = _autonomie*freq_contact_NAT_institutions
sum (rai_freqnat)

generate rai_freqeu = _autonomie*freq_contact_EU_institutions
sum (rai_freqeu)

generate raipop_million = _autonomie*pop_million
sum (raipop_million)


** pop_million
* without controls
xtmixed influenceeu eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions  _bruessel ///
raipop_million ||country_Regio1: ||region_Regio1: ,mle
estat ic
* with controls
xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
EU_role_in_own_pol_area _regionalsprache regionasnation _regpartei _oppositionzunat raipop_million ///
||country_Regio1: ||region_Regio1: ,mle

grinter pop_million, inter(raipop_million) const02(_autonomie) equation(influenceeu) clevel(90) kdensity yline(0) name(inter_pop, replace)

** centgvthelp
* without controls
xtmixed influenceeu eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions  _bruessel ///
rai_centhelp ||country_Regio1: ||region_Regio1: ,mle
estat ic
* with controls
xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
EU_role_in_own_pol_area _regionalsprache regionasnation _regpartei _oppositionzunat rai_centhelp ///
||country_Regio1: ||region_Regio1: ,mle

grinter centgvthelp, inter(rai_centhelp) const02(_autonomie) equation(influenceeu) clevel(90) kdensity yline(0) name(inter_centgvt, replace)

** comhelp
*without controls
xtmixed influenceeu eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions  _bruessel ///
rai_comhelp ||country_Regio1: ||region_Regio1: ,mle
estat ic
*with controls
xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
EU_role_in_own_pol_area _regionalsprache regionasnation _regpartei _oppositionzunat rai_comhelp ///
||country_Regio1: ||region_Regio1: ,mle

grinter comhelp, inter(rai_comhelp) const02(_autonomie) equation(influenceeu) clevel(90) kdensity yline(0)  name(inter_comhelp, replace)

** corhelp
* without controls
xtmixed influenceeu eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions  _bruessel ///
rai_corhelp ||country_Regio1: ||region_Regio1: ,mle
estat ic
* with controls
xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
EU_role_in_own_pol_area _regionalsprache regionasnation _regpartei _oppositionzunat rai_corhelp ///
||country_Regio1: ||region_Regio1: ,mle

grinter corhelp, inter(rai_corhelp) const02(_autonomie) equation(influenceeu) clevel(90) kdensity yline(0) name(inter_corhelp, replace)

** freq_contact_NAT_institutions
* without controls
xtmixed influenceeu eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions  _bruessel ///
rai_freqnat ||country_Regio1: ||region_Regio1: ,mle
estat ic
* with controls
xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
EU_role_in_own_pol_area _regionalsprache regionasnation _regpartei _oppositionzunat rai_freqnat ///
||country_Regio1: ||region_Regio1: ,mle

grinter freq_contact_NAT_institutions, inter(rai_freqnat) const02(_autonomie) equation(influenceeu) clevel(90) kdensity yline(0)  name(inter_freqnat, replace)

** freq_contact_EU_institutions
* without controls
xtmixed influenceeu eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions  _bruessel ///
rai_freqeu ||country_Regio1: ||region_Regio1: ,mle
estat ic
* with controls
xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
EU_role_in_own_pol_area _regionalsprache regionasnation _regpartei _oppositionzunat rai_freqeu ///
||country_Regio1: ||region_Regio1: ,mle

grinter freq_contact_EU_institutions, inter(rai_freqeu) const02(_autonomie) equation(influenceeu) clevel(90) kdensity yline(0)  name(inter_freqeu, replace)



***************************************************************************************
*********** Re-sampling

bootstrap _b _se, reps(3000):  xtmixed influenceeu eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  ///
freq_contact_EU_institutions  _bruessel  ||country_Regio1: ||region_Regio1: ,mle

bootstrap _b _se, reps(3000): xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million centgvthelp comhelp corhelp  freq_contact_NAT_institutions  freq_contact_EU_institutions _bruessel ///
EU_role_in_own_pol_area _regionalsprache regionasnation _regpartei _oppositionzunat ///
||country_Regio1: ||region_Regio1: ,mle



******************************************************************************
************ Imputation

gen freq_NAT = freq_contact_NAT_institutions
gen freq_EU = freq_contact_EU_institutions

sum freq_NAT freq_EU

mi impute chained (ologit, aug) freq_EU freq_NAT (pmm) centgvthelp comhelp corhelp ///
= influenceeu eqi_euqogindex _autonomie pop_million i._bruessel ///
, add(50) rseed(4409)


*** Block 1 = capacity and size
mi estimate: xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million  ///
||country_Regio1: ||region_Regio1: ,mle
* population as expected

*** Block 2 = POlicy allies
mi estimate: xtmixed influenceeu ///
centgvthelp comhelp corhelp  ///
||country_Regio1: ||region_Regio1: ,mle
* comhelp AND corhelp (in missing not sig in block)

*** Block 3 = domestic and supranational embeddedness
mi estimate: xtmixed influenceeu ///
freq_NAT  freq_EU _bruessel ///
||country_Regio1: ||region_Regio1: ,mle
* freq EU as expected

**** Full model
mi estimate: xtmixed influenceeu ///
eqi_euqogindex _autonomie pop_million  ///
centgvthelp comhelp corhelp  ///
freq_NAT  freq_EU _bruessel ///
||country_Regio1: ||region_Regio1: ,mle



****************************************************************************
** Figure 1 was executed in R

pairs.panels(Influence, scale=TRUE, lm=TRUE, jiggle=TRUE, factor=5,pch=".", density=TRUE,
main = "Figure 1: correlation and scatter plot matrix",
sub = "Notes: Top half represents Pearson's correlation coefficient, 
lower half represents bivariate linear relation")
)







