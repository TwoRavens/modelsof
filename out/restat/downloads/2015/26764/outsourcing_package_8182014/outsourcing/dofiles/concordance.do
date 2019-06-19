global x "$masterpath/datafiles/"
global y "$masterpath/prices/"
global z "$masterpath/outfiles/"

clear all
set mem 1300m
set more off

infix htsnum 1-10 sic4dig 12-15 sitcrev2 17-21 str sitcrev3 23-27 str descr 54-103 using ${y}conimp89_01.asc, clear
drop sitcrev2
save ${x}impcord, replace

infix htsnum 1-10 sic4dig 12-15 sitcrev2 17-21 str sitcrev3 23-27 str descr 54-103 using ${y}conexp89_01.asc, clear
drop sitcrev2
save ${x}expcord, replace

use ${x}impcord, clear

program define digit

*sitcrev3=0. Food and live animals
gen sitc1=""
gen sitc2=""
gen sitc3=""
foreach 1digitM0 in "00111" "00151" "00152" "00119" "00131" "00139" "00121" "00122" "00141" "00149" "00190" {
	replace sitc1="0" if sitcrev3=="`1digitM0'"
}
*sitcrev3=01. Meat and meat preparations
foreach 2digitM01 in "01111" "01112" "01121" "01122" "01611" "01612" "01619" "01681" "01689" "01720" "01730" "01740" "01750" "01760" "01790" "01710" {
	replace sitc1="0" if sitcrev3=="`2digitM01'"
	replace sitc2="01" if sitcrev3=="`2digitM01'"
}
*sitcrev3=012. Meat, not of bovine animals, and edible offal, fresh/chilled/frozen
foreach 3digitM012 in "01221" "01222" "01211" "01212" "01213" "01240" "01251" "01252" "01253" "01254" "01255" "01256" "01231" "01232" "01233" "01234" "01235" "01236" "01291" "01292" "01299" "01293" {
	replace sitc1="0" if sitcrev3=="`3digitM012'"
	replace sitc2="01" if sitcrev3=="`3digitM012'"
	replace sitc3="012" if sitcrev3=="`3digitM012'"
}
*sitcrev3=03. Fish, crustaceans, aquatic invertebrates and preparations thereof
foreach 2digitM03 in "03512" "03530" "03550" "03540" "03511" "03513" "03529" "03521" "03522" "03711" "03712" "03713" "03714" "03715" "03716" "03717" "03721" "03722" {
	replace sitc1="0" if sitcrev3=="`2digitM03'"
	replace sitc2="03" if sitcrev3=="`2digitM03'"
}
*sitcrev3=034. Fish, fresh (live or dead), chilled or frozen
foreach 3digitM034 in "03440" "03455" "03411" "03412" "03413" "03414" "03415" "03416" "03417" "03418" "03419" "03421" "03422" "03423" "03424" "03425" "03426" "03427" "03428" "03429" "03451" "03440" "03455" {
	replace sitc1="0" if sitcrev3=="`3digitM034'"
	replace sitc2="03" if sitcrev3=="`3digitM034'"
	replace sitc3="034" if sitcrev3=="`3digitM034'"
}
*sitcrev3=036. Crustaceans, aquatic invert. fresh, chilled, frozen, dried, salted
foreach 3digitM036 in "03619" "03611" "03620" "03631" "03635" "03639" "03633" "03637" {
	replace sitc1="0" if sitcrev3=="`3digitM036'"
	replace sitc2="03" if sitcrev3=="`3digitM036'"
	replace sitc3="036" if sitcrev3=="`3digitM036'"
}
*sitcrev3=04. Cereal and cereal preparations
foreach 2digitM04 in "04510" "04300" "04520" "04210" "04220" "04231" "04232" "04530" "04592" "04591" "04593" "04599" "04610" "04719" "04720" "04722" "04721" "04620" "04729" "04813" "04814" "04815" "04820" "04850" "04830" "04811" "04812" "04841" "04842" "04849" "04711" {
	replace sitc1="0" if sitcrev3=="`2digitM04'"
	replace sitc2="04" if sitcrev3=="`2digitM04'"
}
*sitcrev3=041. Wheat (including spelt) and meslin, unmilled
foreach 3digitM041 in "04110" "04120"  {
	replace sitc1="0" if sitcrev3=="`3digitM041'"
	replace sitc2="04" if sitcrev3=="`3digitM041'"
	replace sitc3="041" if sitcrev3=="`3digitM041'"
}
*sitcrev3=044. Maize (not including sweet corn) unmilled
foreach 3digitM044 in "04410" "04490"  {
	replace sitc1="0" if sitcrev3=="`3digitM044'"
	replace sitc2="04" if sitcrev3=="`3digitM044'"
	replace sitc3="044" if sitcrev3=="`3digitM044'"
}
*sitcrev3=05. Vegetables, fruit and nuts, fresh or dried
foreach 2digitM05 in "05410" "05440" "05451" "05452" "05453" "05454" "05455" "05456" "05457" "05458" "05459" "05469" "05461" "05470" "05611" "05612" "05613" "05619" "05421" "05422" "05423" "05424" "05425" "05429" "05481" "05484" "05485" "05487" "05488" "05489" "05810" "05831" "05832" "05839" "05821" "05822" "05892" "05893" "05894" "05895" "05896" "05897" "05641" "05642" "05645" "05646" "05647" "05648" "05661" "05669" "05671" "05672" "05673" "05674" "05675" "05676" "05677" "05679" "05910" "05920" "05930" "05991" "05992" "05993" "05994" "05995" "05996" "05483" {
	replace sitc1="0" if sitcrev3=="`2digitM05'"
	replace sitc2="05" if sitcrev3=="`2digitM05'"
}
*sitcrev3=057. Fruit and nuts (not including oil nuts) fresh or dried
foreach 3digitM057 in "05771" "05772" "05773" "05774" "05775" "05776" "05777" "05778" "05779" "05730" "05796" "05760" "05795" "05797" "05711" "05712" "05721" "05722" "05729" "05751" "05752" "05791" "05740" "05792" "05793" "05794" "05798" "05799" {
	replace sitc1="0" if sitcrev3=="`3digitM057'"
	replace sitc2="05" if sitcrev3=="`3digitM057'"
	replace sitc3="057" if sitcrev3=="`3digitM057'"
}
*sitcrev3=07. Coffee, tea, cocoa, spices and manufactures thereof
foreach 2digitM07 in "07111" "07112" "07120" "07113" "07131" "07132" "07133" "07210" "07250" "07231" "07232" "07240" "07220" "07310" "07320" "07330" "07390" "07411" "07412" "07413" "07414" "07431" "07432" "07511" "07512" "07513" "07521" "07522" "07523" "07524" "07525" "07526" "07527" "07528" "07529" {
	replace sitc1="0" if sitcrev3=="`2digitM07'"
	replace sitc2="07" if sitcrev3=="`2digitM07'"
}
*sitcrev3=08. Feeding stuff for animals (not including unmilled cereals)
foreach 2digitM08 in "08111" "08112" "08113" "08119" "08123" "08124" "08125" "08126" "08129" "08131" "08132" "08133" "08134" "08135" "08136" "08137" "08138" "08139" "08194" "08141" "08142" "08151" "08152" "08153" "08195" "08199" {
	replace sitc1="0" if sitcrev3=="`2digitM08'"
	replace sitc2="08" if sitcrev3=="`2digitM08'"
}
*sitcrev3=09. Miscellaneous edible products and preparations
foreach 2digitM09 in "09101" "09109" "09811" "09812" "09813" "09814" "09841" "09842" "09843" "09844" "09849" "09850" "09860" "09891" "09892" "09893" "09894" "09899" {
	replace sitc1="0" if sitcrev3=="`2digitM09'"
	replace sitc2="09" if sitcrev3=="`2digitM09'"
}
*sitcrev3=0R. Other food and live animals
foreach 2digitM0R in "02211" "02212" "02213" "02221" "02222" "02223" "02224" "02231" "02232" "02233" "02241" "02249" "02300" "02491" "02410" "02420" "02430" "02499" "02510" "02521" "02522" "02422" "02530" "06111" "06112" "06121" "06129" "06160" "06191" "06192" "06193" "06194" "06195" "06196" "06199" "06151" "06159" "06210" "06221" "06229" {
	replace sitc1="0" if sitcrev3=="`2digitM0R'"
	replace sitc2="0R" if sitcrev3=="`2digitM0R'"
}
*sitcrev3=1. Beverages and tobacco
*sitcrev3=11. Beverages
foreach 2digitM11 in "11101" "11102" "11230" "11215" "11217" "11211" "11213" "11220" "11241" "11242" "11243" "11244" "11245" "11249"  {
	replace sitc1="1" if sitcrev3=="`2digitM11'"
	replace sitc2="11" if sitcrev3=="`2digitM11'"
}
*sitcrev3=12. Tobacco and tobacco manufactures
foreach 2digitM12 in "12110" "12120" "12130" "12210" "12220" "12231" "12232" "12239" {
	replace sitc1="1" if sitcrev3=="`2digitM12'"
	replace sitc2="12" if sitcrev3=="`2digitM12'"
}
*sitcrev3=2. Crude materials, inedible, except fuels
*sitcrev3=22. Oil seeds and oleaginous fruits
foreach 2digitM22 in "22220" "22211" "22212" "22310" "22340" "22261" "22240" "22320" "22230" "22350" "22250" "22262" "22270" "22370" "22390" {
	replace sitc1="2" if sitcrev3=="`2digitM22'"
	replace sitc2="22" if sitcrev3=="`2digitM22'"
}
*sitcrev3=24. Cork and wood
foreach 2digitM24 in "24501" "24502" "24611" "24615" "24620" "24730" "24740" "24751" "24752" "24811" "24819" "24820" "24830" "24840" "24850" "24403" "24404" "24402"  {
	replace sitc1="2" if sitcrev3=="`2digitM24'"
	replace sitc2="24" if sitcrev3=="`2digitM24'"
}
*sitcrev3=25. Woodpulp and recovered paper
foreach 2digitM25 in "25120" "25130" "25141" "25142" "25151" "25152" "25161" "25162" "25191" "25192" "25111" "25112" "25113" "25119"  {
	replace sitc1="2" if sitcrev3=="`2digitM25'"
	replace sitc2="25" if sitcrev3=="`2digitM25'"
}
*sitcrev3=26. Textile fibers and their waste
foreach 2digitM26 in "26851" "26320" "26141" "26130" "26142" "26149" "26811" "26819" "26821" "26829" "26830" "26859" "26863" "26869" "26862" "26871" "26873" "26877" "26310" "26331" "26332" "26339" "26340" "26511" "26512" "26513" "26521" "26529" "26410" "26490" "26541" "26549" "26571" "26579" "26551" "26559" "26581" "26589" "26661" "26662" "26663" "26669" "26712" "26651" "26652" "26653" "26659" "26711" "26721" "26722" "26671" "26672" "26673" "26679" "26713" "26901" "26902"    {
	replace sitc1="2" if sitcrev3=="`2digitM26'"
	replace sitc2="26" if sitcrev3=="`2digitM26'"
}
*sitcrev3=28. Metalliferous ores and metal scrap
foreach 2digitM28 in "28140" "28150" "28160" "28310" "28410" "28510" "28520" "28610" "28620" "28740" "28750" "28760" "28770" "28781" "28782" "28783" "28784" "28785" "28791" "28792" "28799" "28911" "28919" "28810" "28921" "28929" "28210" "28221" "28229" "28231" "28232" "28239" "28233" "28321" "28322" "28821" "28421" "28422" "28822" "28823" "28824" "28825" "28826" "28793"  {
	replace sitc1="2" if sitcrev3=="`2digitM28'"
	replace sitc2="28" if sitcrev3=="`2digitM28'"
}
*sitcrev3=29. Crude animal and vegetable materials, n.e.s.
foreach 2digitM29 in "29191" "29192" "29193" "29195" "29111" "29116" "29115" "29197" "29198" "29194" "29196" "29199" "29221" "29222" "29229" "29299" "29261" "29269" "29271" "29272" "29294" "29295" "29296" "29231" "29232" "29239" "29292" "29293" "29299" "29251" "29254" "29252" "29253" "29254" "29259" "29241" "29242" "29249" "29297" {
	replace sitc1="2" if sitcrev3=="`2digitM29'"
	replace sitc2="29" if sitcrev3=="`2digitM29'"
}
*sitcrev3=2R. Other crude materials, inedible, except fuels
foreach 2digitM2R in "27410" "27411" "27420" "27419" "27822" "27331" "27339" "27851" "27826" "27827" "27829" "27891" "27231" "27232" "27892" "27895" "27722" "27729" "27311" "27312" "27313" "27340" "27823" "27824" "27322" "27323" "27324" "27825" "27830" "27840" "27852" "27893" "27855" "27894" "27853" "27854" "27898" "27899" "27861" "27862" "27869" "27896" "27897" "27210" "27240" "23110" "23121" "23125" "23129" "23130" "23211" "23212" "23213" "23214" "23215" "23216" "23217" "23218" "23219" "23221" "23222" "21120" "21111" "21112" "21113" "21140" "21160" "21170" "21199" "21191" "21221" "21222" "21223" "21224" "21225" "21226" "21229" "21230" "27711" "27719" "27721" "27220" "21210" {
	replace sitc1="2" if sitcrev3=="`2digitM2R'"
	replace sitc2="2R" if sitcrev3=="`2digitM2R'"
}
*sitcrev3=3. Mineral fuels, lubricants and related materials
foreach 1digitM3 in "32110" "32121" "32122" "32210" "32221" "32222" "32230" "32500" "35100" {
	replace sitc1="3" if sitcrev3=="`1digitM3'"
}
*sitcrev3=33. Petroleum, petroleum products and related materials
foreach 2digitM33 in "33511" "33512" "33541" "33542" "33543" "33521" "33522" "33523" "33524" "33525" "33531" "33532" {
	replace sitc1="3" if sitcrev3=="`2digitM33'"
	replace sitc2="33" if sitcrev3=="`2digitM33'"
}
*sitcrev3=333. Petroleum oils and oils from bituminous minerals, crude
foreach 3digitM333 in "33300" {
	replace sitc1="3" if sitcrev3=="`3digitM333'"
	replace sitc2="33" if sitcrev3=="`3digitM333'"
	replace sitc3="333" if sitcrev3=="`3digitM333'"
}
*sitcrev3=334. Petroleum oils and oils from bituminous minerals (other than crude)
foreach 3digitM334 in "33430" "33450" "33429" "33440" "33419" "33429" "33440" "33411" "33412" "33421" "33429" {
	replace sitc1="3" if sitcrev3=="`3digitM334'"
	replace sitc2="33" if sitcrev3=="`3digitM334'"
	replace sitc3="334" if sitcrev3=="`3digitM334'"
}
*sitcrev3=34. Gas, natural and manufactured
foreach 2digitM34 in "34210" "34250" "34410" "34420" "34490" "34500" {
	replace sitc1="3" if sitcrev3=="`2digitM34'"
	replace sitc2="34" if sitcrev3=="`2digitM34'"
}
*sitcrev3=343. Natural gas, whether or not liquefied
foreach 3digitM343 in "34310" "34320" {
	replace sitc1="3" if sitcrev3=="`3digitM343'"
	replace sitc2="34" if sitcrev3=="`3digitM343'"
	replace sitc3="343" if sitcrev3=="`3digitM343'"
}
*sitcrev3=5. Chemicals and related products, n.e.s.
foreach 1digitM5 in "53111" "53112" "53113" "53114" "53115" "53116" "53117" "53119" "53121" "53122" "53221" "53222" "53231" "53232" "53311" "53312" "53313" "53314" "53315" "53316" "53317" "53318" "53321" "53329" "53341" "53342" "53343" "53344" "53351" "53352" "53353" "53354" "53355" {
	replace sitc1="5" if sitcrev3=="`1digitM5'"
}
*sitcrev3=51. Organic chemicals
foreach 2digitM51 in "51111" "51112" "51113" "51114" "51119" "51121" "51122" "51123" "51124" "51125" "51126" "51127" "51129" "51131" "51132" "51133" "51134" "51136" "51137" "51138" "51139" "51140" "51211" "51212" "51213" "51214" "51215" "51216" "51217" "51219" "51221" "51222" "51223" "51224" "51225" "51229" "51231" "51235" "51241" "51242" "51243" "51244" "51371" "51372" "51373" "51374" "51375" "51376" "51377" "51378" "51379" "51384" "51385" "51389" "51391" "51392" "51393" "51394" "51395" "51396" "51382" "51383" "51135" "51381"  {
	replace sitc1="5" if sitcrev3=="`2digitM51'"
	replace sitc2="51" if sitcrev3=="`2digitM51'"
}
*sitcrev3=514. Nitrogen-function compounds
foreach 3digitM514 in "51451" "51452" "51453" "51454" "51455" "51461" "51462" "51463" "51464" "51465" "51467" "51471" "51473" "51479" "51481" "51482" "51483" "51484" "51485" "51486" "51489"  {
	replace sitc1="5" if sitcrev3=="`3digitM514'"
	replace sitc2="51" if sitcrev3=="`3digitM514'"
	replace sitc3="514" if sitcrev3=="`3digitM514'"
}
*sitcrev3=515. Organo-inorganic & heterocylics, nucleic acids & their salts
foreach 3digitM515 in "51541" "51542" "51543" "51544" "51549" "51550" "51561" "51562" "51563" "51569" "51571" "51572" "51573" "51574" "51575" "51576" "51577" "51578" "51579" "51580"  {
	replace sitc1="5" if sitcrev3=="`3digitM515'"
	replace sitc2="51" if sitcrev3=="`3digitM515'"
	replace sitc3="515" if sitcrev3=="`3digitM515'"
}
*sitcrev3=516. Organic chemicals, n.e.s.
foreach 3digitM516 in "51692" "51612" "51613" "51614" "51615" "51616" "51617" "51621" "51622" "51623" "51624" "51625" "51626" "51627" "51628" "51629" "51631" "51639" "51699" "51691" {
	replace sitc1="5" if sitcrev3=="`3digitM516'"
	replace sitc2="51" if sitcrev3=="`3digitM516'"
	replace sitc3="516" if sitcrev3=="`3digitM516'"
}
*sitcrev3=52. Inorganic chemicals
foreach 2digitM52 in "52210" "52224" "52225" "52226" "52221" "52222" "52223" "52227" "52228" "52229" "52231" "52232" "52233" "52234" "52235" "52236" "52237" "52238" "52239" "52241" "52242" "52261" "52262" "52263" "52264" "52265" "52251" "52252" "52253" "52254" "52255" "52256" "52257" "52268" "52269" "52266" "52267" "52310" "52321" "52322" "52329" "52331" "52339" "52341" "52342" "52343" "52344" "52345" "52349" "52351" "52359" "52361" "52362" "52363" "52364" "52365" "52371" "52372" "52373" "52374" "52375" "52379" "52381" "52382" "52383" "52384" "52389" "52431" "52432" "52511" "52513" "52515" "52519" "52517" "52591" "52595" "52491" "52492" "52493" "52494" "52495" "52499" "52332" "52352" {
	replace sitc1="5" if sitcrev3=="`2digitM52'"
	replace sitc2="52" if sitcrev3=="`2digitM52'"
}
*sitcrev3=54. Medicinal and pharmaceutical products
*sitcrev3=541. Medicinal and pharmaceutical products, other than medicaments
foreach 3digitM541 in "54111" "54112" "54113" "54114" "54115" "54116" "54117" "54131" "54132" "54133" "54139" "54141" "54142" "54143" "54144" "54145" "54146" "54147" "54149" "54151" "54152" "54153" "54159" "54161" "54162" "54163" "54164" "54191" "54192" "54193" "54199" {
	replace sitc1="5" if sitcrev3=="`3digitM541'"
	replace sitc2="54" if sitcrev3=="`3digitM541'"
	replace sitc3="541" if sitcrev3=="`3digitM541'"
}
*sitcrev3=542. Medicaments (including veterinary medicaments)
foreach 3digitM542 in "54211" "54212" "54213" "54219" "54221" "54222" "54223" "54224" "54229" "54231" "54232" "54291" "54292" "54293" {
	replace sitc1="5" if sitcrev3=="`3digitM542'"
	replace sitc2="54" if sitcrev3=="`3digitM542'"
	replace sitc3="542" if sitcrev3=="`3digitM542'"
} 
*sitcrev3=55. Essential oils; polishing and cleansing preps
foreach 2digitM55 in "55131" "55132" "55133" "55135" "55141" "55149" "55411" "55415" "55419" "55421" "55422" "55423" "55431" "55432" "55433" "55434" "55435" {
	replace sitc1="5" if sitcrev3=="`2digitM55'"
	replace sitc2="55" if sitcrev3=="`2digitM55'"
}
*sitcrev3=553. Perfumery, cosmetics, or toilet preparations, excluding soaps
foreach 3digitM553 in "55310" "55320" "55330" "55340" "55351" "55352" "55353" "55354" "55359" {
	replace sitc1="5" if sitcrev3=="`3digitM553'"
	replace sitc2="55" if sitcrev3=="`3digitM553'"
	replace sitc3="553" if sitcrev3=="`3digitM553'"
} 
*sitcrev3=56. Fertilizers
foreach 2digitM56 in "56211" "56212" "56213" "56214" "56215" "56216" "56217" "56219" "56220" "56221" "56222" "56229" "56231" "56232" "56239" "56291" "56292" "56293" "56294" "56295" "56296" "56299" "56200" {
	replace sitc1="5" if sitcrev3=="`2digitM56'"
	replace sitc2="56" if sitcrev3=="`2digitM56'"
}
*sitcrev3=57. Plastics in primary forms
foreach 2digitM57 in "57211" "57291" "57292" "57299" "57311" "57312" "57313" "57391" "57392" "57393" "57394" "57399" "57219" {
	replace sitc1="5" if sitcrev3=="`2digitM57'"
	replace sitc2="57" if sitcrev3=="`2digitM57'"
}
*sitcrev3=571. Polymers of ethylene, in primary forms
foreach 3digitM571 in "57111" "57112" "57120" "57190" {
	replace sitc1="5" if sitcrev3=="`3digitM571'"
	replace sitc2="57" if sitcrev3=="`3digitM571'"
	replace sitc3="571" if sitcrev3=="`3digitM571'"
}
*sitcrev3=574. Polyacetals, other polyethers & epoxide resins, in primary forms
foreach 3digitM574 in "57411" "57419" "57420" "57431" "57432" "57433" "57434" "57439" {
	replace sitc1="5" if sitcrev3=="`3digitM574'"
	replace sitc2="57" if sitcrev3=="`3digitM574'"
	replace sitc3="574" if sitcrev3=="`3digitM574'"
}
*sitcrev3=575. Plastics, n.e.s., in primary forms
foreach 3digitM575 in "57511" "57512" "57513" "57519" "57521" "57529" "57531" "57539" "57541" "57542" "57543" "57544" "57545" "57551" "57552" "57553" "57554" "57559" "57591" "57592" "57593" "57594" "57595" "57596" "57597" "57910" "57920" "57930" "57990" {
	replace sitc1="5" if sitcrev3=="`3digitM575'"
	replace sitc2="57" if sitcrev3=="`3digitM575'"
	replace sitc3="575" if sitcrev3=="`3digitM575'"
}
*sitcrev3=58. Plastics in nonprimary forms
foreach 2digitM58 in "58110" "58120" "58130" "58140" "58150" "58160" "58170" "58310" "58320" "58390" {
	replace sitc1="5" if sitcrev3=="`2digitM58'"
	replace sitc2="58" if sitcrev3=="`2digitM58'"
}
*sitcrev3=582. Plates, sheets, film, foil and strips of plastic
foreach 3digitM582 in "58211" "58219" "58221" "58222" "58223" "58224" "58225" "58226" "58227" "58228" "58229" "58291" "58299" {
	replace sitc1="5" if sitcrev3=="`3digitM582'"
	replace sitc2="58" if sitcrev3=="`3digitM582'"
	replace sitc3="582" if sitcrev3=="`3digitM582'"
}
*sitcrev3=59. Chemical materials and products, n.e.s.
foreach 2digitM59 in "59211" "59212" "59213" "59214" "59215" "59216" "59217" "59721" "59725" "59729" "59771" "59772" "59773" "59774" "59221" "59222" "59223" "59224" "59225" "59226" "59227" "59229" "59311" "59312" "59320" "59331" "59333" "59731" "59733" "59110" "59120" "59130" "59141" "59149" {
	replace sitc1="5" if sitcrev3=="`2digitM59'"
	replace sitc2="59" if sitcrev3=="`2digitM59'"
}
*sitcrev3=598. Miscellaneous chemical products, n.e.s.
foreach 3digitM598 in "59861" "59864" "59865" "59881" "59883" "59885" "59889" "59891" "59896" "59811" "59812" "59813" "59814" "59818" "59841" "59845" "59850" "59869" "59897" "59898" "59899" "59831" "59835" "59839" "59863" "59893" "59894" "59895" "59867" {
	replace sitc1="5" if sitcrev3=="`3digitM598'"
	replace sitc2="59" if sitcrev3=="`3digitM598'"
	replace sitc3="598" if sitcrev3=="`3digitM598'"
}
*sitcrev3=6. Manufactured goods classified chiefly by material	
*sitcrev3=62. Rubber manufactures, n.e.s.
foreach 2digitM62 in "62111" "62112" "62119" "62121" "62129" "62131" "62132" "62133" "62141" "62142" "62143" "62144" "62911" "62919" "62145" "62920" "62921" "62922" "62929" "62999" "62992" "62991" {
	replace sitc1="6" if sitcrev3=="`2digitM62'"
	replace sitc2="62" if sitcrev3=="`2digitM62'"
}
*sitcrev3=625. Tires and inner tubes of rubber (Dec. 2004=100)
foreach 3digitM625 in "62510" "62520" "62530" "62541" "62542" "62551" "62559" "62591" "62592" "62593" "62594" {
	replace sitc1="6" if sitcrev3=="`3digitM625'"
	replace sitc2="62" if sitcrev3=="`3digitM625'"
	replace sitc3="625" if sitcrev3=="`3digitM625'"
}
*sitcrev3=63. Cork and wood manufactures other than furniture
foreach 2digitM63 in "63311" "63319" "63321" "63329"  {
	replace sitc1="6" if sitcrev3=="`2digitM63'"
	replace sitc2="63" if sitcrev3=="`2digitM63'"
}
*sitcrev3=634. Veneers, plywood, particle board, and other wood, worked, n.e.s.
foreach 3digitM634 in "63411" "63412" "63421" "63422" "63423" "63431" "63439" "63441" "63449" "63451" "63452" "63453" "63459" "63491" "63493" {
	replace sitc1="6" if sitcrev3=="`3digitM634'"
	replace sitc2="63" if sitcrev3=="`3digitM634'"
	replace sitc3="634" if sitcrev3=="`3digitM634'"
}
*sitcrev3=635. Wood manufactures, n.e.s. (Dec. 2001=100)
foreach 3digitM635 in "63511" "63512" "63520" "63541" "63591" "63520" "63591" "63532" "63539" "63533" "63542" "63549" "63599" "63531" {
	replace sitc1="6" if sitcrev3=="`3digitM635'"
	replace sitc2="63" if sitcrev3=="`3digitM635'"
	replace sitc3="635" if sitcrev3=="`3digitM635'"
}
*sitcrev3=64. Paper and paperboard, cut to size
*sitcrev3=641. Uncoated Paper/paperboard,  and newsprint
foreach 3digitM641 in "64110" "64121" "64122" "64123" "64124" "64125" "64126" "64127" "64129" "64163" "64141" "64142" "64146" "64147" "64148" "64151" "64154" "64152" "64156" "64157" "64158" "64159" "64153" "64191" "64192" "64164" "64161" "64162" "64169" "64131" "64132" "64133" "64134" "64174" "64175" "64176" "64177" "64173" "64178" "64171" "64172" "64179" "64193" "64155" "64194"  {
	replace sitc1="6" if sitcrev3=="`3digitM641'"
	replace sitc2="64" if sitcrev3=="`3digitM641'"
	replace sitc3="641" if sitcrev3=="`3digitM641'"
}
*sitcrev3=642. Paper and paperboard, cut to size, and articles thereof (Dec. 2001=100)
foreach 3digitM642 in "64241" "64242" "64221" "64222" "64223" "64243" "64294" "64295" "64211" "64212" "64213" "64214" "64215" "64216" "64231" "64232" "64233" "64234" "64235" "64239" "64291" "64244" "64245" "64299" "64248" "64293" "64292"  {
	replace sitc1="6" if sitcrev3=="`3digitM642'"
	replace sitc2="64" if sitcrev3=="`3digitM642'"
	replace sitc3="642" if sitcrev3=="`3digitM642'"
}
*sitcrev3=65. Textile yarn, fabrics, made-up articles, n.e.s., and related prod.
foreach 2digitM65 in "65911" "65192" "65193" "65194" "65411" "65413" "65419" "65112" "65117" "65113" "65118" "65114" "65116" "65119" "65115" "65421" "65431" "65433" "65422" "65432" "65434" "65492" "65121" "65122" "65133" "65134" "65131" "65132" "65221" "65231" "65232" "65233" "65234" "65222" "65241" "65242" "65244" "65243" "65245" "65223" "65251" "65252" "65253" "65254" "65224" "65261" "65262" "65264" "65263" "65264" "65265" "65225" "65291" "65292" "65293" "65294" "65226" "65295" "65296" "65297" "65298" "65196" "65197" "65199" "65441" "65442" "65450" "65493" "65141" "65142" "65162" "65151" "65152" "65159" "65163" "65164" "65169" "65173" "65172" "65174" "65175" "65176" "65188" "65177" "65161" "65171" "65311" "65312" "65313" "65314" "65315" "65316" "65317" "65318" "65319" "65351" "65352" "65359" "65143" "65144" "65182" "65184" "65186" "65187" "65181" "65183" "65185" "65321" "65325" "65329" "65331" "65332" "65333" "65334" "65343" "65342" "65341" "65360" "65383" "65382" "65381" "65389" "65191" "65631" "65921" "65929" "65930" "65951" "65952" "65959" "65941" "65942" "65943" "65949" "65961" "65969" "65435" "65214" "65215" "65391" "65393" "65495" "65212" "65213" "65496" "65497" "65211" "65494" "65641" "65642" "65643" "65611" "65612" "65613" "65614" "65621" "65629" "65632" "65491" "65651" "65659" "65912" "65511" "65512" "65519" "65521" "65522" "65523" "65529" "65195" "65460"   {
	replace sitc1="6" if sitcrev3=="`2digitM65'"
	replace sitc2="65" if sitcrev3=="`2digitM65'"
}
*sitcrev3=657. Special yarns, special textile fabrics and related products
foreach 3digitM657 in "65751" "65752" "65759" "65771" "65712" "65719" "65720" "65781" "65785" "65789" "65740" "65731" "65793" "65732" "65735" "65733" "65734" "65772" "65791" "65792" "65773" "65761" "65762" "65711"   {
	replace sitc1="6" if sitcrev3=="`3digitM657'"
	replace sitc2="65" if sitcrev3=="`3digitM657'"
	replace sitc3="657" if sitcrev3=="`3digitM657'"
}
*sitcrev3=658. Made-up articles, wholly or chiefly of textile materials, n.e.s.
foreach 3digitM658 in "65891" "65831" "65832" "65833" "65839" "65841" "65842" "65843" "65844" "65845" "65846" "65847" "65848" "65851" "65852" "65859" "65811" "65812" "65813" "65819" "65821" "65822" "65823" "65824" "65829" "65892" "65893" "65899"    {
	replace sitc1="6" if sitcrev3=="`3digitM658'"
	replace sitc2="65" if sitcrev3=="`3digitM658'"
	replace sitc3="658" if sitcrev3=="`3digitM658'"
}
*sitcrev3=66. Nonmetallic mineral manufactures, n.e.s.
foreach 2digitM66 in "66111" "66112" "66113" "66121" "66122" "66123" "66129" "66233" "66131" "66133" "66134" "66135" "66136" "66139" "66132" "66331" "66312" "66313" "66321" "66322" "66329" "66351" "66352" "66353" "66181" "66182" "66332" "66333" "66334" "66183" "66381" "66382" "66335" "66336" "66337" "66338" "66339" "66231" "66232" "66370" "66241" "66242" "66243" "66244" "66245" "66391" "66611" "66612" "66613" "66621" "66629" "66399" "66511" "66592" "66521" "66522" "66523" "66529" "66595" "66594" "66591" "66593" "66599" "66311" "66512"  {
	replace sitc1="6" if sitcrev3=="`2digitM66'"
	replace sitc2="66" if sitcrev3=="`2digitM66'"
}
*sitcrev3=664. Glass
foreach 3digitM664 in "66411" "66412" "66451" "66452" "66453" "66431" "66439" "66441" "66442" "66491" "66471" "66472" "66492" "66481" "66493" "66494" "66496" "66495" "66489"   {
	replace sitc1="6" if sitcrev3=="`3digitM664'"
	replace sitc2="66" if sitcrev3=="`3digitM664'"
	replace sitc3="664" if sitcrev3=="`3digitM664'"
}
*sitcrev3=667. Pearls, precious and semiprecious stones
foreach 3digitM667 in "66711" "66712" "66713" "66721" "66722" "66729" "66731" "66739" "66741" "66742" "66749"  {
	replace sitc1="6" if sitcrev3=="`3digitM667'"
	replace sitc2="66" if sitcrev3=="`3digitM667'"
	replace sitc3="667" if sitcrev3=="`3digitM667'"
}
*sitcrev3=67. Iron and steel
foreach 2digitM67 in "67121" "67122" "67123" "67141" "67149" "67151" "67152" "67153" "67154" "67155" "67159" "67133" "67131" "67132" "67241" "67245" "67261" "67262" "67269" "67270" "67353" "67311" "67312" "67321" "67322" "67313" "67314" "67315" "67323" "67324" "67325" "67351" "67331" "67332" "67333" "67334" "67341" "67342" "67343" "67344" "67335" "67336" "67337" "67338" "67345" "67346" "67347" "67348" "67352" "67421" "67441" "67411" "67413" "67442" "67443" "67431" "67444" "67316" "67317" "67319" "67326" "67327" "67329" "67339" "67349" "67422" "67412" "67414" "67432" "67451" "67452" "67810" "67811" "67812" "67813" "67247" "67281" "67531" "67532" "67533" "67534" "67535" "67536" "67551" "67552" "67553" "67554" "67555" "67571" "67537" "67538" "67556" "67572" "67821" "67249" "67282" "67511" "67521" "67541" "67542" "67561" "67573" "67512" "67522" "67543" "67562" "67574" "67829" "67701" "67709"  {
	replace sitc1="6" if sitcrev3=="`2digitM67'"
	replace sitc2="67" if sitcrev3=="`2digitM67'"
}
*sitcrev3=676. Iron and steel bars, rods, angles, shapes, sections, and sheet piling
foreach 3digitM676 in "67611" "67612" "67613" "67614" "67643" "67644" "67623" "67624" "67644" "67632" "67633" "67644" "67681" "67682" "67683" "67684" "67685" "67615" "67625" "67644" "67634" "67645" "67687" "67617" "67619" "67644" "67641" "67642" "67629" "67646" "67639" "67647" "67688" "67648" "67686"   {
	replace sitc1="6" if sitcrev3=="`3digitM676'"
	replace sitc2="67" if sitcrev3=="`3digitM676'"
	replace sitc3="676" if sitcrev3=="`3digitM676'"
}
*sitcrev3=679. Iron and steel tubes, pipes, & fittings for tubes and pipes
foreach 3digitM679 in "67911" "67912" "67913" "67914" "67915" "67916" "67917" "67931" "67932" "67933" "67939" "67941" "67942" "67943" "67944" "67949" "67951" "67952" "67953" "67954" "67955" "67956" "67959"    {
	replace sitc1="6" if sitcrev3=="`3digitM679'"
	replace sitc2="67" if sitcrev3=="`3digitM679'"
	replace sitc3="679" if sitcrev3=="`3digitM679'"
}
*sitcrev3=68. Nonferrous metals
foreach 2digitM68 in "68311" "68312" "68323" "68321" "68324" "68322" "68512" "68511" "68521" "68522" "68524" "68611" "68612" "68633" "68631" "68632" "68634" "68711" "68712" "68721" "68722" "68723" "68724" "68911" "68912" "68913" "68915" "68914" "68981" "68992" "68982" "68983" "68984" "68993" "68994" "68991" "68995" "68996" "68997" "68998" "68999"    {
	replace sitc1="6" if sitcrev3=="`2digitM68'"
	replace sitc2="68" if sitcrev3=="`2digitM68'"
}
*sitcrev3=681. Silver, platinum and other platinum group metals
foreach 3digitM681 in "68114" "68113" "68112" "68123" "68125" "68124" "68122"   {
	replace sitc1="6" if sitcrev3=="`3digitM681'"
	replace sitc2="68" if sitcrev3=="`3digitM681'"
	replace sitc3="681" if sitcrev3=="`3digitM681'"
}
*sitcrev3=682. Copper
foreach 3digitM682 in "68211" "68212" "68214" "68213" "68262" "68231" "68232" "68241" "68242" "68251" "68252" "68261" "68271" "68272"   {
	replace sitc1="6" if sitcrev3=="`3digitM682'"
	replace sitc2="68" if sitcrev3=="`3digitM682'"
	replace sitc3="682" if sitcrev3=="`3digitM682'"
}
*sitcrev3=684. Aluminum
foreach 3digitM684 in "68411" "68412" "68425" "68421" "68422" "68423" "68424" "68426" "68427"   {
	replace sitc1="6" if sitcrev3=="`3digitM684'"
	replace sitc2="68" if sitcrev3=="`3digitM684'"
	replace sitc3="684" if sitcrev3=="`3digitM684'"
}
*sitcrev3=69. Manufactures of metals, n.e.s.
foreach 2digitM69 in "69111" "69112" "69113" "69114" "69119" "69211" "69241" "69243" "69311" "69351" "69312" "69352" "69121" "69129" "69212" "69242" "69244" "69313" "69680" "69631" "69635" "69638" "69640" "69651" "69655" "69659" "69661" "69662" "69663" "69669" "69320"   {
	replace sitc1="6" if sitcrev3=="`2digitM69'"
	replace sitc2="69" if sitcrev3=="`2digitM69'"
}
*sitcrev3=694. Nails, screws, nuts, bolts, rivets,  of iron, steel, copper or aluminum
foreach 3digitM694 in "69410" "69421" "69422" "69431" "69432" "69433" "69440"  {
	replace sitc1="6" if sitcrev3=="`3digitM694'"
	replace sitc2="69" if sitcrev3=="`3digitM694'"
	replace sitc3="694" if sitcrev3=="`3digitM694'"
}
*sitcrev3=695. Tools for use in hand or in machines
foreach 3digitM695 in "69510" "69521" "69551" "69553" "69559" "69554" "69555" "69522" "69523" "69530" "69541" "69542" "69543" "69544" "69545" "69546" "69547" "69548" "69549" "69570" "69563" "69564" "69561" "69562" "69552"    {
	replace sitc1="6" if sitcrev3=="`3digitM695'"
	replace sitc2="69" if sitcrev3=="`3digitM695'"
	replace sitc3="695" if sitcrev3=="`3digitM695'"
}
*sitcrev3=697. Household equipment of base metal, n.e.s.
foreach 3digitM697 in "69731" "69732" "69733" "69744" "69741" "69751" "69734" "69742" "69752" "69743" "69753" "69781" "69782"   {
	replace sitc1="6" if sitcrev3=="`3digitM697'"
	replace sitc2="69" if sitcrev3=="`3digitM697'"
	replace sitc3="697" if sitcrev3=="`3digitM697'"
}
*sitcrev3=699. Manufactures of base metal, n.e.s.
foreach 3digitM699 in "69921" "69922" "69961" "69932" "69931" "69941" "69962" "69963" "69965" "69967" "69969" "69942" "69971" "69973" "69975" "69979" "69976" "69977" "69978" "69991" "69992" "69993" "69994" "69981" "69983" "69985" "69987" "69995" "69999" "69911" "69913" "69914" "69915" "69916" "69919" "69917" "69912" "69952" "69951" "69933" "69953" "69954" "69955"  {
	replace sitc1="6" if sitcrev3=="`3digitM699'"
	replace sitc2="69" if sitcrev3=="`3digitM699'"
	replace sitc3="699" if sitcrev3=="`3digitM699'"
}
*sitcrev3=6R. Other manufactured goods classified chiefly by material (Dec. 2001=100)
foreach 2digitM6R in "61120" "61130" "61141" "61142" "61151" "61152" "61161" "61162" "61171" "61172" "61179" "61181" "61183" "61210" "61220" "61290" "61311" "61312" "61313" "61319" "61320" "61330" {
	replace sitc1="6" if sitcrev3=="`2digitM6R'"
	replace sitc2="6R" if sitcrev3=="`2digitM6R'"
}
*sitcrev3=7. Machinery and transport equipment
foreach 1digitM7 in "79111" "79115" "79121" "79129" "79160" "79181" "79170" "79182" "79199" "79191" "79328" "79322" "79326" "79327" "79324" "79311" "79312" "79319" "79370" "79351" "79355" "79359" "79329" "79391" "79399"   {
	replace sitc1="7" if sitcrev3=="`1digitM7'"
}
*sitcrev3=71. Power generating machinery and equipment
foreach 2digitM71 in "71871" "71847" "71877" "71878" "71111" "71112" "71191" "71121" "71122" "71192" "71211" "71211" "71219" "71280" "71811" "71819" "71891" "71893" "71892" "71899"   {
	replace sitc1="7" if sitcrev3=="`2digitM71'"
	replace sitc2="71" if sitcrev3=="`2digitM71'"
}
*sitcrev3=713. Internal combustion piston engines and parts thereof, n.e.s. (Dec. 2004=100)
foreach 3digitM713 in "71311" "71331" "71332" "71321" "71322" "71381" "71333" "71323" "71382" "71319" "71391" "71392"   {
	replace sitc1="7" if sitcrev3=="`3digitM713'"
	replace sitc2="71" if sitcrev3=="`3digitM713'"
	replace sitc3="713" if sitcrev3=="`3digitM713'"
}
*sitcrev3=714. Gas turbine & reaction engines; parts thereof, nes
foreach 3digitM714 in "71441" "71481" "71489" "71491" "71499" "71449"    {
	replace sitc1="7" if sitcrev3=="`3digitM714'"
	replace sitc2="71" if sitcrev3=="`3digitM714'"
	replace sitc3="714" if sitcrev3=="`3digitM714'"
}
*sitcrev3=716. Rotating electric plant and parts thereof, n.e.s.
foreach 3digitM716 in "71610" "71631" "71620" "71631" "71632" "71651" "71652" "71640" "71690"    {
	replace sitc1="7" if sitcrev3=="`3digitM716'"
	replace sitc2="71" if sitcrev3=="`3digitM716'"
	replace sitc3="716" if sitcrev3=="`3digitM716'"
}
*sitcrev3=72. Machinery specialized for particular industries
foreach 2digitM72 in "72711" "72719" "72722" "72729" "72511" "72512" "72591" "72681" "72689" "72521" "72523" "72525" "72527" "72529" "72599" "72631" "72691" "72635" "72651" "72655" "72659" "72661" "72663" "72665" "72667" "72565" "72667" "72668" "72699" "72441" "72442" "72443" "72454" "72451" "72452" "72453" "72461" "72449" "72591" "72467" "72468" "72455" "72471" "72491" "72472" "72473" "72474" "72742" "72492" "72433" "72435" "72439" "72481" "72483" "72485" "72488" "72721" "72241" "72230" "72249"  {
	replace sitc1="7" if sitcrev3=="`2digitM72'"
	replace sitc2="72" if sitcrev3=="`2digitM72'"
}
*sitcrev3=721. Agricultural machinery (excluding tractors) and parts thereof
foreach 3digitM721 in "72111" "72113" "72112" "72118" "72119" "72121" "72123" "72122" "72126" "72129" "72131" "72138" "72139" "72191" "72198" "72196" "72195" "72199" "72127"    {
	replace sitc1="7" if sitcrev3=="`3digitM721'"
	replace sitc2="72" if sitcrev3=="`3digitM721'"
	replace sitc3="721" if sitcrev3=="`3digitM721'"
}
*sitcrev3=723. Civil engineering and contractors' plant, equipment and parts, n.e.s.
foreach 3digitM723 in "72311" "72312" "72331" "72333" "72321" "72322" "72329" "72341" "72342" "72335" "72343" "72337" "72344" "72339" "72345" "72346" "72347" "72391" "72392" "72393" "72399" "72348"    {
	replace sitc1="7" if sitcrev3=="`3digitM723'"
	replace sitc2="72" if sitcrev3=="`3digitM723'"
	replace sitc3="723" if sitcrev3=="`3digitM723'"
}
*sitcrev3=728. Machinery and equipment specialized for particular industries, and parts
foreach 3digitM728 in "72811" "72812" "72819" "72831" "72832" "72833" "72834" "72839" "72841" "72851" "72842" "72852" "72843" "72853" "72844" "72849" "72846" "72855" "72847"  {
	replace sitc1="7" if sitcrev3=="`3digitM728'"
	replace sitc2="72" if sitcrev3=="`3digitM728'"
	replace sitc3="728" if sitcrev3=="`3digitM728'"
}
*sitcrev3=73. Metalworking machinery
foreach 2digitM73 in "73711" "73712" "73719" "73721" "73729" "73111" "73112" "73113" "73114" "73121" "73122" "73123" "73131" "73137" "73135" "73139" "73141" "73142" "73143" "73144" "73145" "73146" "73151" "73152" "73153" "73154" "73157" "73161" "73162" "73163" "73164" "73165" "73166" "73167" "73169" "73178" "73171" "73173" "73175" "73177" "73179" "73179" "73311" "73312" "73313" "73314" "73315" "73316" "73317" "73318" "73391" "73393" "73395" "73399" "73511" "73513" "73515" "73591" "73595" "73741" "73742" "73743" "73749" "73731" "73732" "73733" "73734" "73735" "73736" "73737" "73739"     {
	replace sitc1="7" if sitcrev3=="`2digitM73'"
	replace sitc2="73" if sitcrev3=="`2digitM73'"
}
*sitcrev3=74. General industrial machinery, equipment, & machine parts, n.e.s.
foreach 2digitM74 in "74911" "74912" "74913" "74914" "74915" "74916" "74917" "74918" "74919" "74610" "74620" "74630" "74640" "74650" "74680" "74691" "74699" "74920" "74999" "74991"   {
	replace sitc1="7" if sitcrev3=="`2digitM74'"
	replace sitc2="74" if sitcrev3=="`2digitM74'"
}
*sitcrev3=741. Heating and cooling equipment and parts thereof, n.e.s.
foreach 3digitM741 in "74171" "74172" "74151" "74155" "74159" "74121" "74123" "74125" "74128" "74136" "74137" "74138" "74139" "74143" "74145" "74149" "74181" "74182" "74183" "74184" "74185" "74186" "74173" "74174" "74175" "74187" "74189" "74190" "74131" "74132" "74133" "74134" "74135"   {
	replace sitc1="7" if sitcrev3=="`3digitM741'"
	replace sitc2="74" if sitcrev3=="`3digitM741'"
	replace sitc3="741" if sitcrev3=="`3digitM741'"
}
*sitcrev3=742. Pumps for liquids; liquid elevators; and parts thereof
foreach 3digitM742 in "74211" "74219" "74271" "74220" "74230" "74240" "74250" "74260" "74271" "74275" "74291" "74295"   {
	replace sitc1="7" if sitcrev3=="`3digitM742'"
	replace sitc2="74" if sitcrev3=="`3digitM742'"
	replace sitc3="742" if sitcrev3=="`3digitM742'"
}
*sitcrev3=743. Pumps, compressors, fans, centrifuges, and filtering appar.
foreach 3digitM743 in "74311" "74313" "74315" "74317" "74341" "74343" "74345" "74319" "74380" "74351" "74355" "74359" "74361" "74362" "74363" "74367" "74364" "74369" "74391" "74395"    {
	replace sitc1="7" if sitcrev3=="`3digitM743'"
	replace sitc2="74" if sitcrev3=="`3digitM743'"
	replace sitc3="743" if sitcrev3=="`3digitM743'"
}
*sitcrev3=744. Mechanical handling equipment, and parts thereof, n.e.s.
foreach 3digitM744 in "74421" "74423" "74425" "74441" "74443" "74449" "74431" "74432" "74433" "74434" "74435" "74437" "74439" "74411" "74412" "74413" "74481" "74471" "74472" "74473" "74474" "74479" "74485" "74489" "74491" "74492" "74493" "74494" "74414" "74415" "74419"   {
	replace sitc1="7" if sitcrev3=="`3digitM744'"
	replace sitc2="74" if sitcrev3=="`3digitM744'"
	replace sitc3="744" if sitcrev3=="`3digitM744'"
}
*sitcrev3=745. Nonelectrical machinery, tools and mechanical apparatus, and parts
foreach 3digitM745 in "74591" "74593" "74521" "74523" "74527" "74529" "74532" "74531" "74539" "74561" "74562" "74563" "74564" "74565" "74568" "74511" "74512" "74519" "74595" "74597"  {
	replace sitc1="7" if sitcrev3=="`3digitM745'"
	replace sitc2="74" if sitcrev3=="`3digitM745'"
	replace sitc3="745" if sitcrev3=="`3digitM745'"
}
*sitcrev3=747. Taps, cocks, valves and similar appliances
foreach 3digitM747 in "74710" "74720" "74730" "74740" "74780" "74790"   {
	replace sitc1="7" if sitcrev3=="`3digitM747'"
	replace sitc2="74" if sitcrev3=="`3digitM747'"
	replace sitc3="747" if sitcrev3=="`3digitM747'"
}
*sitcrev3=748. Parts for mechanical power transmission
foreach 3digitM748 in "74831" "74832" "74839" "74810" "74821" "74822" "74840" "74850" "74860" "74890"    {
	replace sitc1="7" if sitcrev3=="`3digitM748'"
	replace sitc2="74" if sitcrev3=="`3digitM748'"
	replace sitc3="748" if sitcrev3=="`3digitM748'"
}
*sitcrev3=75. Computer equipment and office machines
*sitcrev3=751. Office machines
foreach 3digitM751 in "75113" "75115" "75116" "75118" "75119" "75121" "75122" "75123" "75124" "75128" "75191" "75192" "75193" "75199" "75131" "75132" "75133" "75134" "75135"   {
	replace sitc1="7" if sitcrev3=="`3digitM751'"
	replace sitc2="75" if sitcrev3=="`3digitM751'"
	replace sitc3="751" if sitcrev3=="`3digitM751'"
}
*sitcrev3=752. Computer equipment
foreach 3digitM752 in "75220" "75230" "75260" "75270" "75290" "75210"    {
	replace sitc1="7" if sitcrev3=="`3digitM752'"
	replace sitc2="75" if sitcrev3=="`3digitM752'"
	replace sitc3="752" if sitcrev3=="`3digitM752'"
}
*sitcrev3=759. Parts and accessories for computer equipment and office machines
foreach 3digitM759 in "75991" "75995" "75997" "75993" "75910"   {
	replace sitc1="7" if sitcrev3=="`3digitM759'"
	replace sitc2="75" if sitcrev3=="`3digitM759'"
	replace sitc3="759" if sitcrev3=="`3digitM759'"
}
*sitcrev3=76. Telecommunications & sound recording & reproducing apparatus & equipment
*sitcrev3=761. Television receivers, including monitors, projectors and receivers
foreach 3digitM761 in "76110" "76120"   {
	replace sitc1="7" if sitcrev3=="`3digitM761'"
	replace sitc2="76" if sitcrev3=="`3digitM761'"
	replace sitc3="761" if sitcrev3=="`3digitM761'"
}
*sitcrev3=762. Radio-broadcast receivers
foreach 3digitM762 in "76221" "76222" "76211" "76212" "76281" "76282" "76289"   {
	replace sitc1="7" if sitcrev3=="`3digitM762'"
	replace sitc2="76" if sitcrev3=="`3digitM762'"
	replace sitc3="762" if sitcrev3=="`3digitM762'"
}
*sitcrev3=763. Sound recorders or reproducers; television image and sound recorders
foreach 3digitM763 in "76331" "76333" "76335" "76382" "76383" "76384" "76381"  {
	replace sitc1="7" if sitcrev3=="`3digitM763'"
	replace sitc2="76" if sitcrev3=="`3digitM763'"
	replace sitc3="763" if sitcrev3=="`3digitM763'"
}
*sitcrev3=764. Telecommunications equipment & parts, n.e.s.
foreach 3digitM764 in "76411" "76413" "76419" "76415" "76417" "76491" "76421" "76422" "76423" "76424" "76425" "76426" "76492" "76499" "76431" "76432" "76482" "76483" "76481" "76493"   {
	replace sitc1="7" if sitcrev3=="`3digitM764'"
	replace sitc2="76" if sitcrev3=="`3digitM764'"
	replace sitc3="764" if sitcrev3=="`3digitM764'"
}
*sitcrev3=77. Electrical machinery and equipment
*sitcrev3=771. Electric power machinery (except rotating power mach) & parts thereof
foreach 3digitM771 in "77123" "77111" "77119" "77121" "77125" "77129"   {
	replace sitc1="7" if sitcrev3=="`3digitM771'"
	replace sitc2="77" if sitcrev3=="`3digitM771'"
	replace sitc3="771" if sitcrev3=="`3digitM771'"
}
*sitcrev3=772. Electrical circuitry equipment
foreach 3digitM772 in "77231" "77232" "77233" "77235" "77238" "77220" "77241" "77242" "77243" "77244" "77245" "77249" "77251" "77252" "77253" "77254" "77255" "77257" "77258" "77259" "77261" "77262" "77281" "77282"  {
	replace sitc1="7" if sitcrev3=="`3digitM772'"
	replace sitc2="77" if sitcrev3=="`3digitM772'"
	replace sitc3="772" if sitcrev3=="`3digitM772'"
}
*sitcrev3=773. Equipment for distributing electricity, n.e.s.
foreach 3digitM773 in "77311" "77312" "77313" "77314" "77315" "77317" "77318" "77322" "77323" "77324" "77326" "77328" "77329"   {
	replace sitc1="7" if sitcrev3=="`3digitM773'"
	replace sitc2="77" if sitcrev3=="`3digitM773'"
	replace sitc3="773" if sitcrev3=="`3digitM773'"
}
*sitcrev3=774. Electro-diagnostic apparatus for medical use
foreach 3digitM774 in "77411" "77412" "77413" "77421" "77422" "77423" "77429"   {
	replace sitc1="7" if sitcrev3=="`3digitM774'"
	replace sitc2="77" if sitcrev3=="`3digitM774'"
	replace sitc3="774" if sitcrev3=="`3digitM774'"
}
*sitcrev3=775. Household type electrical and nonelectrical equipment, n.e.s.
foreach 3digitM775 in "77585" "77521" "77522" "77530" "77511" "77571" "77573" "77572" "77579" "77541" "77542" "77549" "77581" "77582" "77583" "77584" "77586" "77587" "77588" "77589" "77512"    {
	replace sitc1="7" if sitcrev3=="`3digitM775'"
	replace sitc2="77" if sitcrev3=="`3digitM775'"
	replace sitc3="775" if sitcrev3=="`3digitM775'"
}
*sitcrev3=776. Electronic valves & tubes, diodes, transistors & integrated circuits
foreach 3digitM776 in "77611" "77612" "77621" "77623" "77625" "77627" "77629" "77631" "77632" "77633" "77635" "77637" "77639" "77681" "77688" "77641" "77643" "77645" "77649" "77689"   {
	replace sitc1="7" if sitcrev3=="`3digitM776'"
	replace sitc2="77" if sitcrev3=="`3digitM776'"
	replace sitc3="776" if sitcrev3=="`3digitM776'"
}
*sitcrev3=778. Electrical machinery and apparatus, nes
foreach 3digitM778 in "77881" "77811" "77817" "77812" "77819" "77841" "77843" "77845" "77848" "77831" "77833" "77834" "77835" "77882" "77883" "77884" "77885" "77861" "77862" "77863" "77864" "77865" "77866" "77867" "77868" "77869" "77823" "77821" "77822" "77824" "77829" "77871" "77878" "77879" "77886" "77889" "77812" "77889"    {
	replace sitc1="7" if sitcrev3=="`3digitM778'"
	replace sitc2="77" if sitcrev3=="`3digitM778'"
	replace sitc3="778" if sitcrev3=="`3digitM778'"
}
*sitcrev3=78. Road vehicles
foreach 2digitM78 in "78630" "78621" "78622" "78629" "78683" "78685" "78689" "78610"   {
	replace sitc1="7" if sitcrev3=="`2digitM78'"
	replace sitc2="78" if sitcrev3=="`2digitM78'"
}
*sitcrev3=781. Motor vehicles designed to transport people (exc. public trans.)
foreach 3digitM781 in "78110" "78120"    {
	replace sitc1="7" if sitcrev3=="`3digitM781'"
	replace sitc2="78" if sitcrev3=="`3digitM781'"
	replace sitc3="781" if sitcrev3=="`3digitM781'"
}
*sitcrev3=782. Motor vehicles for the transport of goods & multi-purpose motor vehicles
foreach 3digitM782 in "78211" "78219" "78221" "78223" "78225" "78227" "78229"  {
	replace sitc1="7" if sitcrev3=="`3digitM782'"
	replace sitc2="78" if sitcrev3=="`3digitM782'"
	replace sitc3="782" if sitcrev3=="`3digitM782'"
}
*sitcrev3=783. Road vehicles, n.e.s.
foreach 3digitM783 in "78320" "78311" "78319"    {
	replace sitc1="7" if sitcrev3=="`3digitM783'"
	replace sitc2="78" if sitcrev3=="`3digitM783'"
	replace sitc3="783" if sitcrev3=="`3digitM783'"
}
*sitcrev3=784. Parts and accessories for tractors, motor cars and other motor vehicles
foreach 3digitM784 in "78410" "78421" "78425" "78431" "78432" "78433" "78434" "78435" "78436" "78439"    {
	replace sitc1="7" if sitcrev3=="`3digitM784'"
	replace sitc2="78" if sitcrev3=="`3digitM784'"
	replace sitc3="784" if sitcrev3=="`3digitM784'"
}
*sitcrev3=785. Motorcycles and cycles, motorized and not motorized
foreach 3digitM785 in "78511" "78513" "78515" "78516" "78517" "78519" "78520" "78531" "78535" "78536" "78537"   {
	replace sitc1="7" if sitcrev3=="`3digitM785'"
	replace sitc2="78" if sitcrev3=="`3digitM785'"
	replace sitc3="785" if sitcrev3=="`3digitM785'"
}
*sitcrev3=792. Aircraft, spacecraft, and associated equipment and parts (Dec. 2002=100)
foreach 3digitM792 in "79281" "79282" "79211" "79215" "79220" "79230" "79240" "79250" "79291" "79293" "79295" "79297" "79283"   {
	replace sitc1="7" if sitcrev3=="`3digitM792'"
	replace sitc3="792" if sitcrev3=="`3digitM792'"
}
*sitcrev3=8. MisceIllaneous manufactured articles
*sitcrev3=81. Prefabricated buildings; plumbing, heat & lighting fixtures, n.e.s.
foreach 2digitM81 in "81221" "81229" "81211" "81215" "81217" "81219" "81110" "81100"   {
	replace sitc1="8" if sitcrev3=="`2digitM81'"
	replace sitc2="81" if sitcrev3=="`2digitM81'"
}
*sitcrev3=813. Lighting fixtures and fittings, n.e.s.
foreach 3digitM813 in "81312" "81380" "81311" "81313" "81315" "81317" "81320" "81391" "81392" "81399"   {
	replace sitc1="8" if sitcrev3=="`3digitM813'"
	replace sitc2="81" if sitcrev3=="`3digitM813'"
	replace sitc3="813" if sitcrev3=="`3digitM813'"
}
*sitcrev3=82. Furniture and parts thereof
foreach 2digitM82 in "82111" "82112" "82114" "82113" "82116" "82117" "82118" "82119" "82131" "82139" "82151" "82153" "82155" "82159" "82171" "82179" "82180" "82121" "82123" "82125" "82127" "82129" "82115"  {
	replace sitc1="8" if sitcrev3=="`2digitM82'"
	replace sitc2="82" if sitcrev3=="`2digitM82'"
}
*sitcrev3=83. Travel goods, handbags and similar containers
foreach 2digitM83 in "83111" "83112" "83119" "83121" "83122" "83129" "83191" "83199" "83130" {
	replace sitc1="8" if sitcrev3=="`2digitM83'"
	replace sitc2="83" if sitcrev3=="`2digitM83'"
}
*sitcrev3=84. Articles of apparel and clothing accessories
foreach 2digitM84 in "84621" "84622" "84629" "84691" "84692" "84693" "84694" "84699" "84611" "84612" "84613" "84614" "84619"  {
	replace sitc1="8" if sitcrev3=="`2digitM84'"
	replace sitc2="84" if sitcrev3=="`2digitM84'"
}
*sitcrev3=841. Mens/boys clothing/coats/underwear/ suits, of woven textiles
foreach 3digitM841 in "84111" "84112" "84119" "84121" "84122" "84123" "84130" "84140" "84159" "84151" "84159" "84161" "84162" "84169"   {
	replace sitc1="8" if sitcrev3=="`3digitM841'"
	replace sitc2="84" if sitcrev3=="`3digitM841'"
	replace sitc3="841" if sitcrev3=="`3digitM841'"
}
*sitcrev3=842. Women/girls woven trousers/underwear/ coats/dresses/skirts/suits
foreach 3digitM842 in "84211" "84219" "84221" "84222" "84230" "84240" "84250" "84260" "84270" "84281" "84282" "84289"  {
	replace sitc1="8" if sitcrev3=="`3digitM842'"
	replace sitc2="84" if sitcrev3=="`3digitM842'"
	replace sitc3="842" if sitcrev3=="`3digitM842'"
}
*sitcrev3=843. Men's or boys' coats, jackets, suits, trousers, shirts, etc.
foreach 3digitM843 in "84310" "84321" "84322" "84323" "84324" "84371" "84379" "84381" "84382" "84389"  {
	replace sitc1="8" if sitcrev3=="`3digitM843'"
	replace sitc2="84" if sitcrev3=="`3digitM843'"
	replace sitc3="843" if sitcrev3=="`3digitM843'"
}
*sitcrev3=844. Women's/girl's outer and undergarments, knitted or crocheted
foreach 3digitM844 in "84410" "84421" "84422" "84423" "84424" "84425" "84426" "84470" "84481" "84482" "84483" "84489"  {
	replace sitc1="8" if sitcrev3=="`3digitM844'"
	replace sitc2="84" if sitcrev3=="`3digitM844'"
	replace sitc3="844" if sitcrev3=="`3digitM844'"
}
*sitcrev3=845. Apparel, of textile fabrics, knitted or crocheted, n.e.s.
foreach 3digitM845 in "84540" "84530" "84512" "84591" "84592" "84562" "84564" "84524" "84599" "84511" "84521" "84522" "84523" "84561" "84563" "84581" "84587" "84589" "84551" "84552"   {
	replace sitc1="8" if sitcrev3=="`3digitM845'"
	replace sitc2="84" if sitcrev3=="`3digitM845'"
	replace sitc3="845" if sitcrev3=="`3digitM845'"
}
*sitcrev3=848. Headgear and non-textile apparel and clothing accessories
foreach 3digitM848 in "84811" "84812" "84813" "84819" "84821" "84822" "84829" "84831" "84841" "84842" "84843" "84844" "84845" "84849" "84848" "84832"  {
	replace sitc1="8" if sitcrev3=="`3digitM848'"
	replace sitc2="84" if sitcrev3=="`3digitM848'"
	replace sitc3="848" if sitcrev3=="`3digitM848'"
}
*sitcrev3=85. Footwear
foreach 2digitM85 in "85111" "85131" "85121" "85123" "85132" "85113" "85122" "85124" "85141" "85142" "85115" "85148" "85125" "85151" "85152" "85149" "85159" "85170" "85190"  {
	replace sitc1="8" if sitcrev3=="`2digitM85'"
	replace sitc2="85" if sitcrev3=="`2digitM85'"
}
*sitcrev3=87. Professional, scientific and controlling instruments and apparatus, n.e.s.
foreach 2digitM87 in "87111" "87115" "87119" "87141" "87143" "87145" "87149" "87131" "87139" "87191" "87192" "87193" "87199" "87311" "87313" "87315" "87319" "87321" "87325" "87329"   {
	replace sitc1="8" if sitcrev3=="`2digitM87'"
	replace sitc2="87" if sitcrev3=="`2digitM87'"
}
*sitcrev3=872. Instruments & appliances; for medical, surgical, dental, & veterinary use
foreach 3digitM872 in "87221" "87219" "87225" "87229" "87231" "87233" "87235" "87240" "87211"   {
	replace sitc1="8" if sitcrev3=="`3digitM872'"
	replace sitc2="87" if sitcrev3=="`3digitM872'"
	replace sitc3="872" if sitcrev3=="`3digitM872'"
}
*sitcrev3=874. Measuring, checking, analysing & con- trolling instruments/apparatus, nes
foreach 3digitM874 in "87411" "87412" "87413" "87414" "87451" "87422" "87423" "87424" "87452" "87453" "87454" "87455" "87456" "87431" "87435" "87437" "87439" "87441" "87442" "87443" "87444" "87445" "87446" "87449" "87471" "87473" "87475" "87477" "87478" "87479" "87425" "87426" "87461" "87463" "87465" "87469" "87490"   {
	replace sitc1="8" if sitcrev3=="`3digitM874'"
	replace sitc2="87" if sitcrev3=="`3digitM874'"
	replace sitc3="874" if sitcrev3=="`3digitM874'"
}
*sitcrev3=88. Photographic apparatus, equipment and supplies and optical goods, n.e.s.
*sitcrev3=881. Photographic apparatus and equipment, n.e.s.
foreach 3digitM881 in "88111" "88113" "88112" "88114" "88115" "88121" "88122" "88123" "88124" "88132" "88131" "88133" "88134" "88135" "88136"  {
	replace sitc1="8" if sitcrev3=="`3digitM881'"
	replace sitc2="88" if sitcrev3=="`3digitM881'"
	replace sitc3="881" if sitcrev3=="`3digitM881'"
}
*sitcrev3=882. Photographic and cinematographic supplies
foreach 3digitM882 in "88210" "88220" "88230" "88240" "88250" "88260" "88310" "88390" {
	replace sitc1="8" if sitcrev3=="`3digitM882'"
	replace sitc2="88" if sitcrev3=="`3digitM882'"
	replace sitc3="882" if sitcrev3=="`3digitM882'"
}
*sitcrev3=884. Optical goods, n.e.s.
foreach 3digitM884 in "88419" "88411" "88415" "88417" "88431" "88432" "88433" "88439" "88421" "88422" "88423"  {
	replace sitc1="8" if sitcrev3=="`3digitM884'"
	replace sitc2="88" if sitcrev3=="`3digitM884'"
	replace sitc3="884" if sitcrev3=="`3digitM884'"
}
*sitcrev3=885. Watches and clocks
foreach 3digitM885 in "88531" "88532" "88539" "88541" "88542" "88549" "88572" "88573" "88571" "88574" "88575" "88576" "88577" "88578" "88579" "88594" "88595" "88551" "88552" "88596" "88598" "88591" "88597" "88592" "88593" "88599"  {
	replace sitc1="8" if sitcrev3=="`3digitM885'"
	replace sitc2="88" if sitcrev3=="`3digitM885'"
	replace sitc3="885" if sitcrev3=="`3digitM885'"
}
*sitcrev3=89. Miscellaneous manufactured articles, n.e.s.
foreach 2digitM89 in "89591" "89511" "89512" "89111" "89112" "89114" "89131" "89139" "89191" "89193" "89195" "89199" "89121" "89122" "89123" "89124" "89129" "89113" "89521" "89522" "89523" "89524" "89611" "89612" "89620" "89630" "89640" "89650" "89660" "89592" "89593" "89594"  {
	replace sitc1="8" if sitcrev3=="`2digitM89'"
	replace sitc2="89" if sitcrev3=="`2digitM89'"
}
*sitcrev3=892. Printed matter
foreach 3digitM892 in "89281" "89215" "89216" "89219" "89221" "89229" "89212" "89285" "89214" "89213" "89282" "89283" "89241" "89242" "89284" "89286" "89287" "89289"  {
	replace sitc1="8" if sitcrev3=="`3digitM892'"
	replace sitc2="89" if sitcrev3=="`3digitM892'"
	replace sitc3="892" if sitcrev3=="`3digitM892'"
}
*sitcrev3=893. Articles, n.e.s. of plastics
foreach 3digitM893 in "89311" "89319" "89321" "89329" "89331" "89332" "89394" "89395" "89399" {
	replace sitc1="8" if sitcrev3=="`3digitM893'"
	replace sitc2="89" if sitcrev3=="`3digitM893'"
	replace sitc3="893" if sitcrev3=="`3digitM893'"
}
*sitcrev3=894. Baby carriages, toys, games and sporting goods
foreach 3digitM894 in "89477" "89410" "89441" "89421" "89422" "89423" "89424" "89425" "89426" "89427" "89429" "89431" "89433" "89435" "89437" "89439" "89445" "89449" "89473" "89474" "89475" "89479" "89476" "89479" "89472" "89478" "89479" "89471" "89460" {
	replace sitc1="8" if sitcrev3=="`3digitM894'"
	replace sitc2="89" if sitcrev3=="`3digitM894'"
	replace sitc3="894" if sitcrev3=="`3digitM894'"
}
*sitcrev3=897. Jewelry and other articles of precious materials, n.e.s.
foreach 3digitM897 in "89731" "89732" "89741" "89749" "89733" "89721" "89729" {
	replace sitc1="8" if sitcrev3=="`3digitM897'"
	replace sitc2="89" if sitcrev3=="`3digitM897'"
	replace sitc3="897" if sitcrev3=="`3digitM897'"
}
*sitcrev3=898. Musical instruments, LDs, tapes, other sound recordings
foreach 3digitM898 in "89841" "89843" "89845" "89851" "89859" "89871" "89861" "89865" "89867" "89879" "89813" "89815" "89821" "89822" "89823" "89824" "89825" "89826" "89829" "89890"   {
	replace sitc1="8" if sitcrev3=="`3digitM898'"
	replace sitc2="89" if sitcrev3=="`3digitM898'"
	replace sitc3="898" if sitcrev3=="`3digitM898'"
}
*sitcrev3=899. Miscellaneous manufactured articles, n.e.s.
foreach 3digitM899 in "89931" "89932" "89934" "89939" "89991" "89973" "89974" "89979" "89971" "89941" "89942" "89949" "89992" "89921" "89929" "89994" "89995" "89996" "89963" "89965" "89966" "89961" "89967" "89969" "89911" "89919" "89972" "89981" "89983" "89984" "89985" "89986" "89933" "89935" "89936" "89937" "89989" "89987" "89982" "89997" "89998" "89988"  {
	replace sitc1="8" if sitcrev3=="`3digitM899'"
	replace sitc2="89" if sitcrev3=="`3digitM899'"
	replace sitc3="899" if sitcrev3=="`3digitM899'"
}
*sitcrev3=8R. Other miscellaneous manufactured articles
*sitcrev3=971. Gold, nonmonetary (excluding gold ores and concentrates)
foreach 3digitM971 in "97101" "97102" "97103"   {
	replace sitc3="971" if sitcrev3=="`3digitM971'"
}
end
digit
save ${x}impcord, replace


use ${x}impcord, clear
keep sic4dig sitc3
gen xm="M"
gen sic3dig=trunc(sic4dig/10)
drop if sitc3==""
bysort sitc3 sic3dig: gen N=_n
bysort sitc3 sic3dig: egen tot=max(N)
keep if N==1
sort sic3dig sitc3
bysort sic3dig: egen maxtot=max(tot)  
keep if tot==maxtot
bysort sic3dig: keep if _n==1
sort sitc3 sic3dig
drop N maxtot
keep sic3dig sitc3 xm tot 
sort xm sitc3
save ${x}impsitc3, replace

use ${x}impcord, clear
keep sic4dig sitc2
gen xm="M"
gen sic3dig=trunc(sic4dig/10)
drop if sitc2==""
bysort sitc2 sic3dig: gen N=_n
bysort sitc2 sic3dig: egen tot=max(N)
keep if N==1
sort sic3dig sitc2
bysort sic3dig: egen maxtot=max(tot)  
keep if tot==maxtot
bysort sic3dig: keep if _n==1
sort sitc2 sic3dig
drop N maxtot
keep sic3dig sitc2 xm tot 
sort xm sitc2
save ${x}impsitc2, replace

use ${x}impcord, clear
keep sic4dig sitc1
gen xm="M"
gen sic3dig=trunc(sic4dig/10)
drop if sitc1==""
bysort sitc1 sic3dig: gen N=_n
bysort sitc1 sic3dig: egen tot=max(N)
keep if N==1
sort sic3dig sitc1
bysort sic3dig: egen maxtot=max(tot)  
keep if tot==maxtot
bysort sic3dig: keep if _n==1
sort sitc1 sic3dig
drop N maxtot
keep sic3dig sitc1 xm tot 
sort xm sitc1
save ${x}impsitc1, replace

use ${x}expcord, clear
digit
save ${x}expcord, replace

use ${x}expcord, clear
keep sic4dig sitc3
gen xm="X"
gen sic3dig=trunc(sic4dig/10)
drop if sitc3==""
bysort sitc3 sic3dig: gen N=_n
bysort sitc3 sic3dig: egen tot=max(N)
keep if N==1
sort sic3dig sitc3
bysort sic3dig: egen maxtot=max(tot)  
keep if tot==maxtot
bysort sic3dig: keep if _n==1
sort sitc3 sic3dig
drop N maxtot
keep sic3dig sitc3 xm tot 
sort xm sitc3
save ${x}expsitc3, replace

use ${x}expcord, clear
keep sic4dig sitc2
gen xm="X"
gen sic3dig=trunc(sic4dig/10)
drop if sitc2==""
bysort sitc2 sic3dig: gen N=_n
bysort sitc2 sic3dig: egen tot=max(N)
keep if N==1
sort sic3dig sitc2
bysort sic3dig: egen maxtot=max(tot)  
keep if tot==maxtot
bysort sic3dig: keep if _n==1
sort sitc2 sic3dig
drop N maxtot
keep sic3dig sitc2 xm tot 
sort xm sitc2
save ${x}expsitc2, replace

use ${x}expcord, clear
keep sic4dig sitc1
gen xm="X"
gen sic3dig=trunc(sic4dig/10)
drop if sitc1==""
bysort sitc1 sic3dig: gen N=_n
bysort sitc1 sic3dig: egen tot=max(N)
keep if N==1
sort sic3dig sitc1
bysort sic3dig: egen maxtot=max(tot)  
keep if tot==maxtot
bysort sic3dig: keep if _n==1
sort sitc1 sic3dig
drop N maxtot
keep sic3dig sitc1 xm tot 
sort xm sitc1
save ${x}expsitc1, replace


infix str series 1-4 str xm 5 str sitc 6-8 year 9-32 str period 33-39 value 40-44 using $masterpath/price_data/ei_data_3_SITC.raw, clear
drop if year==.

******************************************************************
* At 1-digit SITC level: For Exports: xm=="x" & Imports: xm=="M" *
******************************************************************
gen sitc1=""
foreach 1digM0 in "0" "01" "011" "012" "03" "034" "036" "04" "041" "044" "05" "057" "07" "08" "09" "0R" {
	replace sitc1="0" if sitc=="`1digM0'"
}
foreach 1digM1 in "1" "11" "12" {
	replace sitc1="1" if sitc=="`1digM1'"
}
foreach 1digM2 in "2" "22" "24" "25" "26" "28" "29" "2R" {
	replace sitc1="2" if sitc=="`1digM2'"
}
foreach 1digM3 in "3" "33" "333" "334" "34" "343" {
	replace sitc1="3" if sitc=="`1digM3'"
}
foreach 1digM5 in "5" "51" "514" "515" "516" "52" "54" "541" "542" "55" "553" "56" "57" "571" "574" "575" "58" "582" "59" "598" {
	replace sitc1="5" if sitc=="`1digM5'"
}
foreach 1digM6 in "6" "62" "625" "63" "634" "635" "64" "641" "642" "65" "657" "658" "66" "664" "667" "67" "676" "679" "68" "681" "682" "684" "69" "694" "695" "697" "699" "6R" {
	replace sitc1="6" if sitc=="`1digM6'"
}
foreach 1digM7 in "7" "71" "713" "714" "716" "72" "721" "723" "728" "73" "74" "741" "742" "743" "744" "745" "747" "748" "75" "751" "752" "759" "76" "761" "762" "763" "764" "77" "771" "772" "773" "774" "775" "776" "778" "78" "781" "782" "783" "784" "785" "792" {
	replace sitc1="7" if sitc=="`1digM7'"
}
foreach 1digM8 in "8" "81" "813" "82" "83" "84" "841" "842" "843" "844" "845" "848" "85" "87" "872" "874" "88" "881" "882" "884" "885" "89" "892" "893" "894" "897" "898" "899" "8R" {
	replace sitc1="8" if sitc=="`1digM8'"
}
foreach 1digM9 in "971" {
	replace sitc1="9" if sitc=="`1digM9'"
}

*************************
* At 2-digit SITC level *
*************************
gen sitc2=""
replace sitc2="01" if sitc=="01" | sitc=="011" | sitc=="012"
replace sitc2="03" if sitc=="03" | sitc=="034" | sitc=="036"
replace sitc2="04" if sitc=="04" | sitc=="041" | sitc=="044"
replace sitc2="05" if sitc=="05" | sitc=="057"
replace sitc2="07" if sitc=="07"
replace sitc2="08" if sitc=="08"
replace sitc2="09" if sitc=="09"
replace sitc2="11" if sitc=="11" 
replace sitc2="12" if sitc=="12" 
replace sitc2="22" if sitc=="22" 
replace sitc2="24" if sitc=="24" 
replace sitc2="25" if sitc=="25" 
replace sitc2="26" if sitc=="26" 
replace sitc2="28" if sitc=="28" 
replace sitc2="29" if sitc=="29"
replace sitc2="33" if sitc=="33" | sitc=="333" | sitc=="334" 
replace sitc2="34" if sitc=="34" | sitc=="343"
replace sitc2="51" if sitc=="51" | sitc=="514" | sitc=="515" | sitc=="516" 
replace sitc2="52" if sitc=="52" 
replace sitc2="54" if sitc=="54" | sitc=="541" | sitc=="542" 
replace sitc2="55" if sitc=="55" | sitc=="553" 
replace sitc2="56" if sitc=="56" 
replace sitc2="57" if sitc=="57" | sitc=="571" | sitc=="574" | sitc=="575" 
replace sitc2="58" if sitc=="58" | sitc=="582" 
replace sitc2="59" if sitc=="59" | sitc=="598" 
replace sitc2="62" if sitc=="62" | sitc=="625" 
replace sitc2="63" if sitc=="63" | sitc=="634" | sitc=="635" 
replace sitc2="64" if sitc=="64" | sitc=="641" | sitc=="642" 
replace sitc2="65" if sitc=="65" | sitc=="657" | sitc=="658" 
replace sitc2="66" if sitc=="66" | sitc=="664" | sitc=="667" 
replace sitc2="67" if sitc=="67" | sitc=="676" | sitc=="679" 
replace sitc2="68" if sitc=="68" | sitc=="681" | sitc=="682" | sitc=="684" 
replace sitc2="69" if sitc=="69" | sitc=="694" | sitc=="695" | sitc=="697" | sitc=="699" 
replace sitc2="71" if sitc=="71" | sitc=="713" | sitc=="714" | sitc=="716" 
replace sitc2="72" if sitc=="72" | sitc=="721" | sitc=="723" | sitc=="728" 
replace sitc2="73" if sitc=="73"
replace sitc2="74" if sitc=="74" | sitc=="741" | sitc=="742" | sitc=="743" | sitc=="744" | sitc=="745" | sitc=="747" | sitc=="748" 
replace sitc2="75" if sitc=="75" | sitc=="751" | sitc=="752" | sitc=="759" 
replace sitc2="76" if sitc=="76" | sitc=="761" | sitc=="762" | sitc=="763" | sitc=="764" 
replace sitc2="77" if sitc=="77" | sitc=="771" | sitc=="772" | sitc=="773" | sitc=="774" | sitc=="775" | sitc=="776" | sitc=="778" 
replace sitc2="78" if sitc=="78" | sitc=="781" | sitc=="782" | sitc=="783" | sitc=="784" | sitc=="785" 
replace sitc2="81" if sitc=="81" | sitc=="813" 
replace sitc2="82" if sitc=="82" 
replace sitc2="83" if sitc=="83" 
replace sitc2="84" if sitc=="84" | sitc=="841" | sitc=="842" | sitc=="843" | sitc=="844" | sitc=="845" | sitc=="848" 
replace sitc2="85" if sitc=="85" 
replace sitc2="87" if sitc=="87" | sitc=="872" | sitc=="874" 
replace sitc2="88" if sitc=="88" | sitc=="881" | sitc=="882" | sitc=="884" | sitc=="885" 
replace sitc2="89" if sitc=="89" | sitc=="892" | sitc=="893" | sitc=="894" | sitc=="897" | sitc=="898" | sitc=="899" 


*************************
* At 3-digit SITC level *
*************************
gen sitc3=""
foreach 3dig in "011" "012" "034" "036" "041" "044" "057" "333" "334" "343" "514" "515" "516" "541" "542" "553" "571" "574" "575" "582" "598" "625" "634" "635" "641" "642" "657" "658" "664" "667" "676" "679" "681" "682" "684" "694" "695" "697" "699" "713" "714" "716" "721" "723" "728" "741" "742" "743" "744" "745" "747" "748" "751" "752" "759" "761" "762" "763" "764" "771" "772" "773" "774" "775" "776" "778" "781" "782" "783" "784" "785" "792" "813" "841" "842" "843" "844" "845" "848" "872" "874" "881" "882" "884" "885" "892" "893" "894" "897" "898" "899" "971" {
	replace sitc3="`3dig'" if sitc=="`3dig'"
}
tempfile priceindex
save `priceindex', replace

use `priceindex', clear
collapse value, by(xm sitc1 year)
tempfile priceindex1
save `priceindex1', replace

use `priceindex', clear
collapse value, by(xm sitc2 year)
tempfile priceindex2
save `priceindex2', replace

use `priceindex', clear
collapse value, by(xm sitc3 year)
tempfile priceindex3
save `priceindex3', replace

use `priceindex1', clear
gen exp = value if xm=="X"
gen imp = value if xm=="M"
sort year sitc1
egen expfin = mean(exp), by(year sitc1)
egen impfin = mean(imp), by(year sitc1)
bysort sitc1 year: keep if _n==1
keep sitc1 year expfin impfin 
sort sitc1 
reshape wide expfin impfin, i(sitc1) j(year)
save ${x}pindex1digit, replace

use `priceindex2', clear
gen exp = value if xm=="X"
gen imp = value if xm=="M"
sort year sitc2
egen expfin = mean(exp), by(year sitc2)
egen impfin = mean(imp), by(year sitc2)
bysort sitc2 year: keep if _n==1
keep sitc2 year expfin impfin 
sort sitc2 
reshape wide expfin impfin, i(sitc2) j(year)
save ${x}pindex2digit, replace

use `priceindex3', clear
gen exp = value if xm=="X"
gen imp = value if xm=="M"
sort year sitc3
egen expfin = mean(exp), by(year sitc3)
egen impfin = mean(imp), by(year sitc3)
bysort sitc3 year: keep if _n==1
keep sitc3 year expfin impfin
sort sitc3 
reshape wide expfin impfin, i(sitc3) j(year)
save ${x}pindex3digit, replace

use ${x}impsitc3, clear
*sic3dig==361: sitc3==771 & sitc3==772	
drop if sic3dig==361 & sitc3=="771"
save ${x}impsitc3, replace

use ${x}expsitc3, clear
*************************************************
* When exports and imports have different 	*
* 3-digit SITC codes for a given SIC code,	*
* choose the 3-digit SITC code which 		*
* has more observations (max(N))			*
*************************************************
*sic3dig==11: sitc3==41 & sitc3==44 
drop if sic3dig==11 & sitc3=="044"
*sic3dig==276: sitc3==892 & sitc3==642
drop if sic3dig==276 & sitc3=="642"
*sic3dig==283: sitc3==541 & sitc3==542	
drop if sic3dig==283 & sitc3=="542"
*sic3dig==286: sitc3==514 & sitc3==516	
drop if sic3dig==286 & sitc3=="516"
*sic3dig==331: sitc3==679 & sitc3==676	
drop if sic3dig==331 & sitc3=="676"
*sic3dig==332: sitc3==699 & sitc3==679	
drop if sic3dig==332 & sitc3=="679"
*sic3dig==333: sitc3==681 & sitc3==682	
drop if sic3dig==333 & sitc3=="682"
*sic3dig==335: sitc3==682 & sitc3==684	
drop if sic3dig==335 & sitc3=="684"
*sic3dig==342: sitc3==699 & sitc3==695	
drop if sic3dig==342 & sitc3=="695"
*sic3dig==349: sitc3==699 & sitc3==747	
drop if sic3dig==349 & sitc3=="747"
*sic3dig==352: sitc3==784 & sitc3==721	
drop if sic3dig==352 & sitc3=="721"
*sic3dig==364: sitc3==778 & sitc3==772	
drop if sic3dig==364 & sitc3=="772"
*sic3dig==381: sitc3==764 & sitc3==874	
drop if sic3dig==381 & sitc3=="874"
*sic3dig==386: sitc3==881 & sitc3==882	
drop if sic3dig==386 & sitc3=="882"
*sic3dig==391: sitc3==897 & sitc3==667	
drop if sic3dig==391 & sitc3=="667"
*sic3dig==395: sitc3==641 & sitc3==642	
drop if sic3dig==395 & sitc3=="642"
*sic3dig==396: sitc3==897 & sitc3==699	
drop if sic3dig==396 & sitc3=="699"
*sic3dig==920: sitc3==625 & sitc3==723
drop if sic3dig==920 & sitc3=="723"
*sic3dig==344: sitc3==741 & sitc3==699
drop if sic3dig==344 & sitc3=="699"
append using ${x}impsitc3

sort sitc3
merge sitc3 using ${x}pindex3digit
bysort sitc3 sic3dig: keep if _n==1
drop xm _merge
drop if sitc3==""
drop if sic3dig==.
reshape long expfin impfin, i(sitc3 sic3dig) j(year)
drop if sic3dig==.
sort sic3dig year
keep year sitc3 sic3dig expfin impfin
save ${x}3digit, replace


use ${x}impsitc2, clear
*sic3dig==376: sitc2==89 & sitc3==71	
drop if sic3dig==376 & sitc2=="71"
save ${x}impsitc2, replace

use ${x}expsitc2, clear
*************************************************
* When exports and imports have different 	*
* 3-digit SITC codes for a given SIC code,	*
* choose the 3-digit SITC code which 		*
* has more observations (max(N))			*
*************************************************
*sic3dig==206: sitc2==5 & sitc2==7 
drop if sic3dig==206 & sitc2=="05"
*sic3dig==207: sitc2==8 & sitc2==9 
drop if sic3dig==207 & sitc2=="08"
*sic3dig==11: sitc2==4 & sitc2==5 
drop if sic3dig==11 & sitc2=="04"
*sic3dig==391: sitc2==66 & sitc2==89 
drop if sic3dig==391 & sitc2=="66"
*sic3dig==332: sitc2==67 & sitc2==73
drop if sic3dig==332 & sitc2=="67"
*sic3dig==346: sitc2==69 & sitc2==78
drop if sic3dig==346 & sitc2=="69"
*sic3dig==920: sitc2==72 & sitc2==62
drop if sic3dig==920 & sitc2=="72"
*sic3dig==381: sitc2==87 & sitc2==76
drop if sic3dig==381 & sitc2=="87"
*sic3dig==306: sitc2==62 & sitc2==84
drop if sic3dig==306 & sitc2=="62"
*sic3dig==276: sitc2==64 & sitc2==89
drop if sic3dig==276 & sitc2=="64"
*sic3dig==308: sitc2==89 & sitc2==58
drop if sic3dig==308 & sitc2=="89"
append using ${x}impsitc2

*Drop if all expfin==. & impfin==.
drop if sitc=="0R" | sitc=="2R" | sitc=="6R" 

sort sitc2
merge sitc2 using ${x}pindex2digit
bysort sitc2 sic3dig: keep if _n==1
drop xm _merge
drop if sitc2==""
drop if sic3dig==.
reshape long expfin impfin, i(sitc2 sic3dig) j(year)
drop if sic3dig==.
sort sic3dig year
keep year sitc2 sic3dig expfin impfin
save ${x}2digit, replace

use ${x}expsitc1, clear
*************************************************
* When exports and imports have different 	*
* 3-digit SITC codes for a given SIC code,	*
* choose the 3-digit SITC code which 		*
* has more observations (max(N))			*
*************************************************
*sic3dig==13: sitc1==2 & sitc1==1 
drop if sic3dig==13 & sitc1=="2"
*sic3dig==276: sitc1==6 & sitc1==8 
drop if sic3dig==276 & sitc1=="6"
*sic3dig==306: sitc1==6 & sitc1==8 
drop if sic3dig==306 & sitc1=="6"
*sic3dig==346: sitc1==6 & sitc1==7 
drop if sic3dig==346 & sitc1=="6"
*sic3dig==920: sitc1==7 & sitc1==6 
drop if sic3dig==920 & sitc1=="7"
*sic3dig==381: sitc1==8 & sitc1==7 
drop if sic3dig==381 & sitc1=="8"

append using ${x}impsitc1
sort sitc1
merge sitc1 using ${x}pindex1digit
bysort sitc1 sic3dig: keep if _n==1
drop xm _merge
drop if sitc1==""
drop if sic3dig==.
reshape long expfin impfin, i(sitc1 sic3dig) j(year)
drop if sic3dig==.
sort sic3dig year
keep year sitc1 sic3dig expfin impfin
save ${x}1digit, replace


exit
