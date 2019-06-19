global x "~/research/outsourcing/dofiles/"
global y "~/research/outsourcing/lawrence/"
global z "~/research/outsourcing/autor/"

global path ~/research

!gunzip ${y}naics97tosic87.dta.gz
use ${y}naics97tosic87, clear
rename naics02 naics4
sort naics4
save ${y}naics4tosic87, replace

!gunzip ${y}lawrence.dta.gz
use ${y}lawrence, clear
sort naics4
merge naics4 using ${y}naics4tosic87
tab _merge
rename _merge merge
sort sic87
**************************************************************************
* Take average import prices for all naics codes within an sic category: *
**************************************************************************
collapse year1990 year1991 year1992 year1993 year1994 year1995 year1996 year1997 year1998 year1999 year2000 year2001 year2002 year2003 year2004 year2005 year2006, by(sic87)      
save ${y}lawrence_naics97tosic87.dta, replace

erase ${y}naics4tosic87.dta

!gunzip ${z}sic87_3-man7090.dta.gz
use ${y}lawrence_naics97tosic87.dta, replace
merge sic87 using ${z}sic87_3-man7090
tab _merge
*******************************************************************************************************
* For many-to-one matches between sic code and man7090, use sic code with non-missing import prices;  *
* should all sic codes matched to a single man7090 have missing import prices, take the first	    *
*******************************************************************************************************
drop if _merge==1
bysort man7090 _merge: drop if _n>1
drop if _merge==2 & man7090==8
drop if _merge==2 & man7090==17
drop if _merge==2 & man7090==21
drop if _merge==2 & man7090==27
drop if _merge==2 & man7090==29
drop if _merge==2 & man7090==30
drop if _merge==2 & man7090==39
drop if _merge==2 & man7090==43
drop if _merge==2 & man7090==46
drop if _merge==2 & man7090==51
drop if _merge==2 & man7090==60
drop if _merge==2 & man7090==65
drop if _merge==2 & man7090==66
drop if _merge==2 & man7090==67
drop _merge

reshape long year, i(man7090) j(yr)
rename year importprice
rename yr year
gen man7090_orig=man7090
do ${x}man7090_bea.do
do ${z}labels_man7090_orig.do
sort man7090_orig year
save ${y}importprices.dta, replace

!gzip ${y}naics97tosic87.dta
!gzip ${y}lawrence.dta
!gzip ${z}sic87_3-man7090.dta


/*********************************************************************
* There is a many-to-one match between the naics code and sic code 
* and, b/c there's a 1-1 match between sic and man7090, 
* there is a many-to-one match between the naics code and man7090: 
*********************************************************************
* naics4=3111: Animal Food Manufacturing
* naics4=3112: Grain and Oilseed Milling
* are both matched with sic87=204 and man7090=4. i.e. there are two import price series matched to man7090=4
* This occurs for 50 of the 69 in the series. 
*********************************************************************
* naics4=3113: Sugar and Confectionery Product Manufacturing
* naics4=3117: Seafood Product Preparation and Packaging 
* naics4=3119: Other Food Manufacturing
* are both matched with sic87=209 and man7090=8. 
*********************************************************************
* naics4=3251: Basic Chemical Manufacturing
* naics4=3252: Resin, Synthetic Rubber, and Artificial Synthetic Fibers and Filaments Manufacturing 
* naics4=3255: Paint, Coating, and Adhesive Manufacturing 
* naics4=3259: Other Chemical Product and Preparation Manufacturing
* are both matched with sic87=281, sic=289, sic=291 and man7090=27. 
*********************************************************************
* naics4=3271: Clay Product and Refractory Manufacturing
* naics4=3273: Cement and Concrete Product Manufacturing 
* naics4=3274: Lime and Gypsum Product Manufacturing 
* naics4=3279: Other Nonmetallic Mineral Product Manufacturing
* are both matched with sic87=329 and man7090=43. 
*********************************************************************
* naics4=3311: Iron and Steel Mills and Ferroalloy Manufacturing
* naics4=3312: Steel Product Manufacturing from Purchased Steel 
* naics4=3315: Foundries
* are both matched with sic87=331 and man7090=44. 
*********************************************************************
* naics4=3313: Alumina and Aluminum Production and Processing
* naics4=3314: Nonferrous Metal (except Aluminum) Production and Processing
* are both matched with sic87=335 and man7090=46. 
*********************************************************************
* naics4=3322: Cutlery and Handtool Manufacturing
* naics4=3325: Hardware Manufacturing 
* are both matched with sic87=335 and man7090=47. 
*********************************************************************
* naics4=3321: Forging and Stamping
* naics4=3323: Architectural and Structural Metals Manufacturing 
* naics4=3324: Boiler, Tank, and Shipping Container Manufacturing 
* naics4=3326: Spring and Wire Product Manufacturing 
* naics4=3328: Coating, Engraving, Heat Treating, and Allied Activities 
* naics4=3329: Other Fabricated Metal Product Manufacturing
* are both matched with sic87=341, sic87=349 and man7090=51. 
*********************************************************************
* naics4=3331: Agriculture, Construction, and Mining Machinery Manufacturing
* naics4=3365: Railroad Rolling Stock Manufacturing 
* are both matched with sic87=353 and man7090=54. 
*********************************************************************
* naics4=3327: Machine Shops; Turned Product; and Screw, Nut, and Bolt Manufacturing 
* naics4=3332: Industrial Machinery Manufacturing 
* naics4=3333: Commercial and Service Industry Machinery Manufacturing 
* naics4=3334: Ventilation, Heating, Air-Conditioning, and Commercial Refrigeration Equipment Manufacturing 
* naics4=3339: Pump and Compressor Manufacturing 
* are both matched with sic87=355, sic87=356, sic87=358, sic87=359 and man7090=57. 
*********************************************************************
* naics4=3344: Semiconductor and Other Electronic Component Manufacturing 
* naics4=3346: Manufacturing and Reproducing Magnetic and Optical Media 
* naics4=3351: Electric Lighting Equipment Manufacturing 
* naics4=3353: Electrical Equipment Manufacturing 
* naics4=3359: Other Electrical Equipment and Component Manufacturing 
* are both matched with sic87=367, sic87=369 and man7090=60. 
*********************************************************************
* naics4=3361: Motor Vehicle Manufacturing
* naics4=3362: Motor Vehicle Body and Trailer Manufacturing 
* naics4=3363: Motor Vehicle Parts Manufacturing 
* are both matched with sic87=371 and man7090=61. 
*********************************************************************
* naics4=3364: Aerospace Product and Parts Manufacturing 
* naics4=3366: Ship and Boat Building 
* naics4=3369: Other Transportation Equipment Manufacturing 
* are both matched with sic87=379 and man7090=65. 
*********************************************************************
* naics4=3342: Communications Equipment Manufacturing 
* naics4=3343: Audio and Video Equipment Manufacturing 
* naics4=3345: Navigational, Measuring, Electromedical, and Control Instruments Manufacturing 
* are both matched with sic87=366, sic87=381 and man7090=66. 
*********************************************************************

Meanwhile, there are several man7090 codes that are missing import prices (see: naics4_missingimportprices.log): 
6,9,10,11,12,13,14,15,16,18,20,22,25,29,32,33,34,35,36,37,38,40,41,42,45,48,49,50,53,62,63,64,68,69,70
--this is due to no concordance between sic87 and naics02 for sic87=206 (man7090=6)

--this is due to no concordance between sic87 and naics02 for sic87=211 (man7090=9)
--this is due to no concordance between sic87 and naics02 for sic87=212 (man7090=9)
--this is due to no concordance between sic87 and naics02 for sic87=213 (man7090=9)
--this is due to no concordance between sic87 and naics02 for sic87=214 (man7090=9)
--this is due to no concordance between sic87 and naics02 for sic87=225 (man7090=10)
--this is due to no concordance between sic87 and naics02 for sic87=226 (man7090=11)
--this is due to no concordance between sic87 and naics02 for sic87=227 (man7090=12)
--this is due to no concordance between sic87 and naics02 for sic87=221 (man7090=13)
--this is due to no concordance between sic87 and naics02 for sic87=222 (man7090=13)
--this is due to no concordance between sic87 and naics02 for sic87=223 (man7090=13)
--this is due to no concordance between sic87 and naics02 for sic87=224 (man7090=13)
--this is due to no concordance between sic87 and naics02 for sic87=228 (man7090=13)
--this is due to no concordance between sic87 and naics02 for sic87=211 (man7090=14)
--this is due to no concordance between sic87 and naics02 for sic87=231 (man7090=15)
--this is due to no concordance between sic87 and naics02 for sic87=232 (man7090=15)
--this is due to no concordance between sic87 and naics02 for sic87=233 (man7090=15)
--this is due to no concordance between sic87 and naics02 for sic87=234 (man7090=15)
--this is due to no concordance between sic87 and naics02 for sic87=235 (man7090=15)
--this is due to no concordance between sic87 and naics02 for sic87=236 (man7090=15)
--this is due to no concordance between sic87 and naics02 for sic87=237 (man7090=15)
--this is due to no concordance between sic87 and naics02 for sic87=239 (man7090=16)

--this is due to no concordance between sic87 and naics02 for sic87=267 (man7090=18)
--this is due to no concordance between sic87 and naics02 for sic87=271 (man7090=20)
--this is due to no concordance between sic87 and naics02 for sic87=282 (man7090=22)
--this is due to no concordance between sic87 and naics02 for sic87=285 (man7090=25)
--this is due to no concordance between sic87 and naics02 for sic87=299 (man7090=29)
--this is due to no concordance between sic87 and naics02 for sic87=311 (man7090=32)
--this is due to no concordance between sic87 and naics02 for sic87=313 (man7090=33)
--this is due to no concordance between sic87 and naics02 for sic87=315 (man7090=34)
--this is due to no concordance between sic87 and naics02 for sic87=241 (man7090=35)
--this is due to no concordance between sic87 and naics02 for sic87=243 (man7090=36)
--this is due to no concordance between sic87 and naics02 for sic87=249 (man7090=37)
--this is due to no concordance between sic87 and naics02 for sic87=252 (man7090=38)
--this is due to no concordance between sic87 and naics02 for sic87=327 (man7090=40)
--this is due to no concordance between sic87 and naics02 for sic87=325 (man7090=41)
--this is due to no concordance between sic87 and naics02 for sic87=326 (man7090=42)
--this is due to no concordance between sic87 and naics02 for sic87=332 (man7090=45)
--this is due to no concordance between sic87 and naics02 for sic87=344 (man7090=48)
--this is due to no concordance between sic87 and naics02 for sic87=345 (man7090=49)
--this is due to no concordance between sic87 and naics02 for sic87=346 (man7090=50)
--this is due to no concordance between sic87 and naics02 for sic87=352 (man7090=53)
--this is due to no concordance between sic87 and naics02 for sic87=373 (man7090=62)
--this is due to no concordance between sic87 and naics02 for sic87=374 (man7090=63)
--this is due to no concordance between sic87 and naics02 for sic87=348 (man7090=64)
--this is due to no concordance between sic87 and naics02 for sic87=386 (man7090=68)
--this is due to no concordance between sic87 and naics02 for sic87=387 (man7090=69)
--this is due to no concordance between sic87 and naics02 for sic87=399 (man7090=70)

*/
