*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs the agricultural commodities shock used in Berman and Couttenier (2014), based on M3-CROPS data     *
* This version: nov. 11, 2013
*-----------------------------------------------------------------------------------------------------------------------------*
*
****************************************************************************
* PRE-REQUISITE: MERGE 170 SHP CROP FILES WITH PRIO GRIDS (see readme.doc) *
****************************************************************************

cd "$crops\TREATED"
*
********************************
* A - GET SHP FILES AND APPEND *
********************************
*
foreach x in abaca agave alfalfa almond aniseetc apple apricot areca artichoke asparagus	avocado	bambara	banana	barley	bean beetfor berrynes blueberry	brazil broadbean buckwheat cabbage cabbagefor canaryseed carob carrot carrotfor cashew cashewapple cassava castor cauliflower cerealnes cherry chestnut chickpea chicory chilleetc cinnamon citrusnes clove	clover cocoa coconut coffee	coir cotton	cowpea cranberry cucumberetc currant date eggplant fibrenes	fig	flax fonio fruitnes	garlic ginger gooseberry grape grapefruitetc grassnes greenbean greenbroadbean greencorn greenonion	greenpea groundnut gums	hazelnut hemp hempseed hop jute	jutelikefiber kapokfiber kapokseed karite kiwi kolanut legumenes lemonlime lentil lettuce linseed lupin maize maizefor mango mate melonetc melonseed millet mixedgrain mixedgrass mushroom mustard nutmeg nutnes oats oilpalm oilseedfor oilseednes okra olive onion orange papaya pea peachetc pear pepper	peppermint persimmon pigeonpea pimento pineapple pistachio plantain	plum popcorn poppy potato pulsenes pumpkinetc pyrethrum quince quinoa ramie rapeseed rasberry rice rootnes rubber rye ryefor safflower sesame sisal sorghum	sorghumfor sourcherry soybean spicenes spinach stonefruitnes strawberry stringbean sugarbeet sugarcane sugarnes sunflower swedefor sweetpotato tangetc taro tea	tobacco	tomato triticale tropicalnes tung turnipfor vanilla vegetablenes vegfor	vetch walnut watermelon wheat yam yautia{
	shp2dta using `x', database(`x') coordinates(coor_`x') replace
	di "done with `x'"
	erase coor_`x'.dta
	}
foreach x in abaca agave alfalfa almond aniseetc apple apricot areca artichoke asparagus	avocado	bambara	banana	barley	bean beetfor berrynes blueberry	brazil broadbean buckwheat cabbage cabbagefor canaryseed carob carrot carrotfor cashew cashewapple cassava castor cauliflower cerealnes cherry chestnut chickpea chicory chilleetc cinnamon citrusnes clove	clover cocoa coconut coffee	coir cotton	cowpea cranberry cucumberetc currant date eggplant fibrenes	fig	flax fonio fruitnes	garlic ginger gooseberry grape grapefruitetc grassnes greenbean greenbroadbean greencorn greenonion	greenpea groundnut gums	hazelnut hemp hempseed hop jute	jutelikefiber kapokfiber kapokseed karite kiwi kolanut legumenes lemonlime lentil lettuce linseed lupin maize maizefor mango mate melonetc melonseed millet mixedgrain mixedgrass mushroom mustard nutmeg nutnes oats oilpalm oilseedfor oilseednes okra olive onion orange papaya pea peachetc pear pepper	peppermint persimmon pigeonpea pimento pineapple pistachio plantain	plum popcorn poppy potato pulsenes pumpkinetc pyrethrum quince quinoa ramie rapeseed rasberry rice rootnes rubber rye ryefor safflower sesame sisal sorghum	sorghumfor sourcherry soybean spicenes spinach stonefruitnes strawberry stringbean sugarbeet sugarcane sugarnes sunflower swedefor sweetpotato tangetc taro tea	tobacco	tomato triticale tropicalnes tung turnipfor vanilla vegetablenes vegfor	vetch walnut watermelon wheat yam yautia{
	use `x', clear
	g crop = "`x'"
	save `x', replace
	}
*
use abaca, clear
foreach x in agave	alfalfa	almond aniseetc	apple apricot areca	artichoke asparagus	avocado	bambara	banana	barley	bean beetfor berrynes blueberry	brazil broadbean buckwheat cabbage cabbagefor canaryseed carob carrot carrotfor cashew cashewapple cassava castor cauliflower cerealnes cherry chestnut chickpea chicory chilleetc cinnamon citrusnes clove	clover cocoa coconut coffee	coir cotton	cowpea cranberry cucumberetc currant date eggplant fibrenes	fig	flax fonio fruitnes	garlic ginger gooseberry grape grapefruitetc grassnes greenbean greenbroadbean greencorn greenonion	greenpea groundnut gums	hazelnut hemp hempseed hop jute	jutelikefiber kapokfiber kapokseed karite kiwi kolanut legumenes lemonlime lentil lettuce linseed lupin maize maizefor mango mate melonetc melonseed millet mixedgrain mixedgrass mushroom mustard nutmeg nutnes oats oilpalm oilseedfor oilseednes okra olive onion orange papaya pea peachetc pear pepper	peppermint persimmon pigeonpea pimento pineapple pistachio plantain	plum popcorn poppy potato pulsenes pumpkinetc pyrethrum quince quinoa ramie rapeseed rasberry rice rootnes rubber rye ryefor safflower sesame sisal sorghum	sorghumfor sourcherry soybean spicenes spinach stonefruitnes strawberry stringbean sugarbeet sugarcane sugarnes sunflower swedefor sweetpotato tangetc taro tea	tobacco	tomato triticale tropicalnes tung turnipfor vanilla vegetablenes vegfor	vetch walnut watermelon wheat yam yautia{
append using `x'
}
sort gid crop
*
foreach x in abaca agave	alfalfa	almond aniseetc	apple apricot areca	artichoke asparagus	avocado	bambara	banana	barley	bean beetfor berrynes blueberry	brazil broadbean buckwheat cabbage cabbagefor canaryseed carob carrot carrotfor cashew cashewapple cassava castor cauliflower cerealnes cherry chestnut chickpea chicory chilleetc cinnamon citrusnes clove	clover cocoa coconut coffee	coir cotton	cowpea cranberry cucumberetc currant date eggplant fibrenes	fig	flax fonio fruitnes	garlic ginger gooseberry grape grapefruitetc grassnes greenbean greenbroadbean greencorn greenonion	greenpea groundnut gums	hazelnut hemp hempseed hop jute	jutelikefiber kapokfiber kapokseed karite kiwi kolanut legumenes lemonlime lentil lettuce linseed lupin maize maizefor mango mate melonetc melonseed millet mixedgrain mixedgrass mushroom mustard nutmeg nutnes oats oilpalm oilseedfor oilseednes okra olive onion orange papaya pea peachetc pear pepper	peppermint persimmon pigeonpea pimento pineapple pistachio plantain	plum popcorn poppy potato pulsenes pumpkinetc pyrethrum quince quinoa ramie rapeseed rasberry rice rootnes rubber rye ryefor safflower sesame sisal sorghum	sorghumfor sourcherry soybean spicenes spinach stonefruitnes strawberry stringbean sugarbeet sugarcane sugarnes sunflower swedefor sweetpotato tangetc taro tea	tobacco	tomato triticale tropicalnes tung turnipfor vanilla vegetablenes vegfor	vetch walnut watermelon wheat yam yautia{
	erase `x'.dta
}
*
cd "$crops"
save temp, replace
*
********************
* B - GET PRODUCTS *
********************
*
clear
insheet using crops_hs.csv, delimiter(";")
rename filename crop
sort crop
save crops_hs, replace
*
use temp, clear
sort crop
merge crop using crops_hs, nokeep
tab _merge
rename hscode hs
distinct crop if hs == .
distinct crop if hs != . 
*
drop if hs == .
*
drop if N_sum == 0
*
bys gid: egen sum_crop = sum(N_sum)
*
drop if sum_crop == 0
*
duplicates report gid 
*
save temp, replace
*
**************
* C - SHARES *
**************
*
g share_crop = N_sum / sum_crop
*
collapse (mean) share_crop, by(gid xcoord ycoord crop cropname hs)
*
save temp, replace
*
******************************
* D - BALANCE DATA FOR PANEL *
******************************
*
use temp, clear
*
expand 28
sort gid xcoord ycoord crop cropname hs share_crop
g year =.
bys gid xcoord ycoord crop cropname hs share_crop: gen count=_n
replace year = 1980 if count==1
replace year = 1981 if year[_n-1] == 1980
replace year = 1982 if year[_n-1] == 1981
replace year = 1983 if year[_n-1] == 1982
replace year = 1984 if year[_n-1] == 1983
replace year = 1985 if year[_n-1] == 1984
replace year = 1986 if year[_n-1] == 1985
replace year = 1987 if year[_n-1] == 1986
replace year = 1988 if year[_n-1] == 1987
replace year = 1989 if year[_n-1] == 1988
replace year = 1990 if year[_n-1] == 1989
replace year = 1991 if year[_n-1] == 1990
replace year = 1992 if year[_n-1] == 1991
replace year = 1993 if year[_n-1] == 1992
replace year = 1994 if year[_n-1] == 1993
replace year = 1995 if year[_n-1] == 1994
replace year = 1996 if year[_n-1] == 1995
replace year = 1997 if year[_n-1] == 1996
replace year = 1998 if year[_n-1] == 1997
replace year = 1999 if year[_n-1] == 1998
replace year = 2000 if year[_n-1] == 1999
replace year = 2001 if year[_n-1] == 2000
replace year = 2002 if year[_n-1] == 2001
replace year = 2003 if year[_n-1] == 2002
replace year = 2004 if year[_n-1] == 2003
replace year = 2005 if year[_n-1] == 2004
replace year = 2006 if year[_n-1] == 2005
replace year = 2007 if year[_n-1] == 2006
drop count
*
save temp, replace

*
***********************************************************
* F - MERGE WITH WORLD DEMAND FOR HS COMMODITY AND FINISH *
***********************************************************
*
use temp, clear
rename hs hs4
sort hs4 year
merge hs4 year using "$trade\comtrade_hs4_world", nokeep
drop if year<1989
tab _merge
drop _merge
g shock_crop = share_crop*trade
*
collapse (sum) shock_crop, by(gid xcoord ycoord year)
replace shock_crop = . if shock_crop == 0 
*
label var shock_crop  "World demand weighted by hs spec., M3-CROPS"
sort gid year
*
erase crops_hs.dta
erase temp.dta
*
cd "$Output_data"
save CROPS_M3_ALL_AFRICA, replace
*


