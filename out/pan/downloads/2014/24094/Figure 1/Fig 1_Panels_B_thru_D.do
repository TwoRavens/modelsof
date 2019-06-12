
/*use 2010YGP.dta for analyses below*/

/************************************************* 

auth = authoritarianism
black = R is african american = 1, R is white = 0
amid = american identity
culture = cultural threat
party = partisanship, trending republican
ideol = ideology, trendign conservative
lat = latino immigrant feeling thermometer rating
asi = asian immigrant feeling thermometer rating
afr = african immigrant feeling thermometer rating
whi = white immigrant feeling thermometer rating
citizen = delay citizenship for legal immigrants
legal = decrease legal immigration
stopill = more efforts to stop illegal immigration
illcit = no citizenship for illegal immigrants
income = income

***************************************************/

/*Figure 1, Panel B, correlations between dispositions and authoritarianism by race*/

/*Table C, supporting information, raw correlations by race*/

pwcorr amid auth, sig
pwcorr amid auth if black==1, sig
pwcorr amid auth if black==0, sig

pwcorr culture auth, sig
pwcorr culture auth if black==1, sig
pwcorr culture auth if black==0, sig

pwcorr party auth, sig
pwcorr party auth if black==1, sig
pwcorr party auth if black==0, sig

pwcorr ideol auth, sig
pwcorr ideol auth if black==1, sig
pwcorr ideol auth if black==0, sig

pwcorr lat auth, sig
pwcorr lat auth if black==1, sig
pwcorr lat auth if black==0, sig

pwcorr asi auth, sig
pwcorr asi auth if black==1, sig
pwcorr asi auth if black==0, sig

pwcorr afr auth, sig
pwcorr afr auth if black==1, sig
pwcorr afr auth if black==0, sig

pwcorr whi auth, sig
pwcorr whi auth if black==1, sig
pwcorr whi auth if black==0, sig

pwcorr citizen auth, sig
pwcorr citizen auth if black==1, sig
pwcorr citizen auth if black==0, sig

pwcorr legal auth, sig
pwcorr legal auth if black==1, sig
pwcorr legal auth if black==0, sig

pwcorr stopill auth, sig
pwcorr stopill auth if black==1, sig
pwcorr stopill auth if black==0, sig

pwcorr illcit auth, sig
pwcorr illcit auth if black==1, sig
pwcorr illcit auth if black==0, sig


/*Panels C and D, correlations between dispositions and authoritarianism by race and income*/

/*Table C, supporting information, raw correlations by race and income*/

pwcorr amid auth if black==1 & income<=4, sig
pwcorr amid auth if black==0 & income<=4 , sig
pwcorr amid auth if black==1 & income>=5, sig
pwcorr amid auth if black==0 & income>=5 , sig

pwcorr culture auth if black==1 & income<=4, sig
pwcorr culture auth if black==0 & income<=4 , sig
pwcorr culture auth if black==1 & income>=5, sig
pwcorr culture auth if black==0 & income>=5 , sig

pwcorr party auth if black==1 & income<=4, sig
pwcorr party auth if black==0 & income<=4 , sig
pwcorr party auth if black==1 & income>=5, sig
pwcorr party auth if black==0 & income>=5 , sig

pwcorr ideol auth if black==1 & income<=4, sig
pwcorr ideol auth if black==0 & income<=4 , sig
pwcorr ideol auth if black==1 & income>=5, sig
pwcorr ideol auth if black==0 & income>=5 , sig

pwcorr lat auth if black==1 & income<=4, sig
pwcorr lat auth if black==0 & income<=4 , sig
pwcorr lat auth if black==1 & income>=5, sig
pwcorr lat auth if black==0 & income>=5 , sig

pwcorr asi auth if black==1 & income<=4, sig
pwcorr asi auth if black==0 & income<=4 , sig
pwcorr asi auth if black==1 & income>=5, sig
pwcorr asi auth if black==0 & income>=5 , sig

pwcorr afr auth if black==1 & income<=4, sig
pwcorr afr auth if black==0 & income<=4 , sig
pwcorr afr auth if black==1 & income>=5, sig
pwcorr afr auth if black==0 & income>=5 , sig

pwcorr whi auth if black==1 & income<=4, sig
pwcorr whi auth if black==0 & income<=4 , sig
pwcorr whi auth if black==1 & income>=5, sig
pwcorr whi auth if black==0 & income>=5 , sig

pwcorr citizen auth if black==1 & income<=4, sig
pwcorr citizen auth if black==0 & income<=4 , sig
pwcorr citizen auth if black==1 & income>=5, sig
pwcorr citizen auth if black==0 & income>=5 , sig

pwcorr legal auth if black==1 & income<=4, sig
pwcorr legal auth if black==0 & income<=4 , sig
pwcorr legal auth if black==1 & income>=5, sig
pwcorr legal auth if black==0 & income>=5 , sig

pwcorr stopill auth if black==1 & income<=4, sig
pwcorr stopill auth if black==0 & income<=4 , sig
pwcorr stopill auth if black==1 & income>=5, sig
pwcorr stopill auth if black==0 & income>=5 , sig

pwcorr illcit auth if black==1 & income<=4, sig
pwcorr illcit auth if black==0 & income<=4 , sig
pwcorr illcit auth if black==1 & income>=5, sig
pwcorr illcit auth if black==0 & income>=5 , sig


/*Table E, supporting information, effect of authoritarianism among blacks and whites*/

reg amid auth black authblack, robust
reg culture auth black authblack, robust
reg party auth black authblack, robust
reg ideol auth black authblack, robust
reg lat auth black authblack, robust
reg asi auth black authblack, robust
reg afr auth black authblack, robust
reg whi auth black authblack, robust
reg citizen auth black authblack, robust
reg legal auth black authblack, robust
reg stopill auth black authblack, robust
reg illcit auth black authblack, robust
