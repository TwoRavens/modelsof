************************
****REPLICATION CODE****
************************

**Main Text**
*Table 1, County Model
xtmixed taxmore14i  d_gini1014cnty_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 || fips:
*Table 1, Zip Code Model
xtmixed taxmore14i  d_gini1015zip_01 medhinc0711zip_01 pctunemp0711zip_01 college711zip_01 pimm711zip_01 pmccain_01 popden0711zip_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 || zip:

**Online Appendix**
*Table A1, County Model
reg taxmore14i  d_gini1014cnty_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 
*Table A1, Zip Code Model
reg taxmore14i  d_gini1015zip_01 medhinc0711zip_01 pctunemp0711zip_01 college711zip_01 pimm711zip_01 pmccain_01 popden0711zip_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 

*Table A2, County Model
xtmixed taxmore14i  d_gini1014cnty_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 [pweight=weight] || fips:
*Table A2, Zip Code Model
xtmixed taxmore14i  d_gini1015zip_01 medhinc0711zip_01 pctunemp0711zip_01 college711zip_01 pimm711zip_01 pmccain_01 popden0711zip_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 [pweight=weight] || zip:

*Table A3, County Model
xtmixed taxmore14i  d_gini1014cnty_01 medinc610cnty_01 d_unemp1014cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 || fips:
*Table A3, Zip Code Model
xtmixed taxmore14i  d_gini1015zip_01 medhinc0711zip_01 d_unempzip_01 college711zip_01 pimm711zip_01 pmccain_01 popden0711zip_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 || zip:

*Table A4
*Ban Gay Marriage
xtlogit gaymarry14  d_gini1014cnty_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 gaymarry10_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01, i(fips)
*Invasion of Iraq
xtlogit iraq14  d_gini1014cnty_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 iraq10_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01, i(fips)
*Gun Control
ologit guns14  d_gini1014cnty_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 guns10_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01, cluster(fips)
*Climate Change
ologit climchange14  d_gini1014cnty_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 climchange10_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01, cluster(fips)

*Table A5, County Model
xtmixed taxmore10i  d_gini1014cnty_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 || fips:
*Table A5, Zip Code Model
xtmixed taxmore10i  d_gini1015zip_01 medhinc0711zip_01 pctunemp0711zip_01 college711zip_01 pimm711zip_01 pmccain_01 popden0711zip_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 || zip:

*Table A6
*Party ID Interaction
xtmixed taxmore14i  c.d_gini1014cnty_01##c.partyid3_10_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 ideology10_01 pray10_01 || fips:
*Income Interaction
xtmixed taxmore14i  c.d_gini1014cnty_01##c.income10i_01 medinc610cnty_01 unemp610cnty_01 college610cnty_01 pimm610cnty_01 pmccain_01 popden610cnty_01 taxmore10i_01 educ10_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 || fips:

*Table A7
xtmixed taxmore14i  d_gini0914st_01 medinc09st_01 unemp09st_01 college09st_01 pimm09st_01 pmccain_01 popden09st_01 taxmore10i_01 educ10_01 income10i_01 age10 male black latino asian unemployed10 sociotrop10_01 ownhome10 partyid3_10_01 ideology10_01 pray10_01 || statefip:

