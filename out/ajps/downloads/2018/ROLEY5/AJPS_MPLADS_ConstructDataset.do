*The project-level data on MPLADS were scraped from the Works Monitoring System for the MPLADS available here: 
*http://mplads.nic.in/sslapps/mpladsworks/start.htm.
* The reports were accessed in August 2015. The scraping was done by a third party vendor (CP Development).

*A semi-automated process was then used to assign each project on the Works Monitoring System to a given Assembly Constituency. 
*This assignment process was undertaken using information on the location of each project under the column headings
*"blockurban" and "Ward/Gram Panchayat"

*Using the information in these columns, a three-pronged approach was used to match each project to a given Assembly Constituency (AC). 
*I. Village Name Matching, II. Batch Geocoding and III. Overlap between Blocks and ACs.

*I. Village Name Matching
*a. For the purposes of Village Name Matching, three sets of GIS shapefiles were obtained from MLInfoMaps for the seven BIMARU+ states.. 
*(i) GIS shapefile with boundaries for villages in the 2001 Indian Census 
*(ii) GIS shapefile with boundaries of state assembly constituencies prior to delimitation
*(iii) GIS shapefile with boundaries of state assembly constituencies after delimitation

*b. A village centroid was created for each village. Then, using the "Intersect" Tool, a new file was created to match the village centroid
*to a given state assembly constituency from the "predelimitation" file and to a given state assembly constituency from
* the "postdelimitation" file.

*Then, fuzzy matching in R was used to generate initial matches between the name of the project location available
* in the column "Ward/Gram Panchayat" with the village name from MLInfoMaps (the matching took into account Hindi spelling variations) . 
* Note that although the MPLADS system describes the project locations as comprising either wards or 
* village clusters (i.e. gram panchayats), a closer look at the data revealed that, in practice, the names entered by officials
* usually corresponded to the village names rather than the village cluster names. 
* Matching was done by district name as well as block name to ensure the accuracy of matches. 
* The matches were manually checked and incorrect matches were manually identified. Step I was used to create the 
* variables "villageidgis" and "villagename_GIS" which contain the village ID (from the MLInfoMaps file) and the 
* village name (from the MLInfoMaps file) that was matched with the project location. A variable "gp_missing" was created 
*as an indicator for whether there was no information in the "wardgrampanchayat" column.
 
*II. Batch Geocoding

*The code below was used to generate an address for each project that could not be matched using "Village Name Matching".

*gen address= wardgrampanchayat+", "+nodaldistrict+", "+st_name

*replace address=blockurban+", "+nodaldistrict+", "+st_name if gp_missing==1

*The resulting address file was saved and imported into QGIS. Then, QGIS' interface with Google Maps was used to*
* batch geocode these addresses. Addresses and geocodes were checked and corrected manually. Then, using the GIS shapefiles for 
*state assembly constituency boundaries, each geocoded address was matched with a state assembly constituency.

*III. Overlap between Blocks and ACs.

*For the purposes of this task, three sets of GIS shapefiles were used from MLInfoMaps for the seven BIMARU+ states.
*(i) GIS shapefile with boundaries for administrative blocks in the 2001 Indian Census 
*(ii) GIS shapefile with boundaries of state assembly constituencies prior to delimitation
*(iii) GIS shapefile with boundaries of state assembly constituencies after delimitation

*QGIS' "Intersect" tool was used to calculate the area overlap between blocks and assembly constituencies. 
*This was done separately for pre-delimitation boundaries and post-delimitation ACs*
*A variable "max_overlap" was then generated which provides the percentage of a given block's area that overlaps with a single AC. 
*The QGIS file was saved in STATA format and merged with the master file.
*Then, for projects that could not be matched with approaches I and II, 
*an AC match was recorded if the area overlap between the block and the state assembly constituency is at least 99%

*The above three steps were used to create the variables  "ac_name_GIS", "ac_no_GIS" and "ac_no_gis_post".
*Other variables generated in the process were indicators for pieces of information that were missing in the raw data: 
*"blockurban_missing" "elecyear_missing" "gp_missing"
*Finally, a variable "matched" was created that denotes the projects whose location could be identified using Step I, Step II OR Step III.

cd "/Users/anjalibohlken/Documents/MPLADs_Data/MPLADS_AJPS_ReplicationFiles"

use BIMARU_MPLADS_withACs.dta, clear

duplicates drop st_name lsrs constituency mp nodaldistrict allsanctionedworksiliworksnotsan worknamewithlocation blockurban wardgrampanchayat dateofreceiptofproposalforworkfr costsanctionedbydistrict, force

gen LS_year=.

replace LS_year=1999 if lsrs=="LS/RS: 13th Lok Sabha"

replace LS_year=2004 if lsrs=="LS/RS: 14th Lok Sabha"

replace LS_year=2009 if lsrs=="LS/RS: 15th Lok Sabha"

label variable LS_year "Lok Sabha Year"

save BIMARU_MPLADS_withACs_2.dta, replace

*Now install packages

ssc install reclink

ssc install strdist

*NOW MERGE WITH PARLIAMENTARY DATA

*First separate file by parliament

*1999 parliament

use BIMARU_MPLADS_withACs_2.dta, clear

keep if LS_year==1999

replace state=lower(state)

*rename state st_name

gen pc_name=lower(constituency)

replace pc_name=subinstr(pc_name, " (sc)", "", .)

replace pc_name=subinstr(pc_name, " (st)", "", .)

save BIMARU_MPLADS_matched_LS1999.dta, replace

*2004 parliament

use BIMARU_MPLADS_withACs_2.dta, clear

keep if LS_year==2004

replace state=lower(state)

*rename state st_name

gen pc_name=lower(constituency)

replace pc_name=subinstr(pc_name, " (sc)", "", .)

replace pc_name=subinstr(pc_name, " (st)", "", .)

save BIMARU_MPLADS_matched_LS2004.dta, replace

*2009 parliament

use BIMARU_MPLADS_withACs_2.dta, clear

keep if LS_year==2009

replace state=lower(state)

*rename state st_name

gen pc_name=lower(constituency)

replace pc_name=subinstr(pc_name, " (sc)", "", .)

replace pc_name=subinstr(pc_name, " (st)", "", .)

save BIMARU_MPLADS_matched_LS2009.dta, replace

*Now merge with parliamentary election data

*2009 Lok Sabha

use BIMARU_MPLADS_matched_LS2009.dta, clear

sort st_name lsrs  constituency mp nodaldistrict allsanctionedworksiliworksnotsan worknamewithlocation blockurban wardgrampanchayat/*
*/ dateofreceiptofproposalforworkfr dateofsanctionofworkbydistrict executingagency costsanctionedbydistrict workstatus

gen mid=_n

replace pc_name="munger" if pc_name=="monghyr"&st_name=="bihar"

replace st_name="chhattisgarh" if st_name=="madhya pradesh"&pc_name=="korba"
replace st_name="chhattisgarh" if st_name=="madhya pradesh"&pc_name=="raigarh"
replace st_name="chhattisgarh" if st_name=="madhya pradesh"&pc_name=="raipur"

reclink st_name pc_name using LS_2009_BIMARU.dta, idm(mid) idu(obs_id) gen(matchscore)

rename _merge mergeLS2009

gen party_mp=""

replace party_mp=maxparty_pc

replace party_mp="IND" if mp=="Smt Putul Kumari"&constituency=="banka"
replace party_mp="INC" if mp=="Shri Raj Babbar"&constituency=="firozabad"

save BIMARU_MPLADS_LS2009_PCMerged.dta, replace

*2004 Lok Sabha

use BIMARU_MPLADS_matched_LS2004.dta, clear

replace pc_name=subinstr(pc_name, "(sc)", "", .)

replace pc_name=subinstr(pc_name, "(st)", "", .)

replace st_name="chhattisgarh" if constituency=="bastar"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="bilaspur"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="mahasamund"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="kanker"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="raigarh"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="raipur"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="rajnandgaon"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="surguja"&st_name=="madhya pradesh"


sort st_name lsrs  constituency mp nodaldistrict allsanctionedworksiliworksnotsan worknamewithlocation blockurban wardgrampanchayat/*
*/ dateofreceiptofproposalforworkfr dateofsanctionofworkbydistrict executingagency costsanctionedbydistrict workstatus

gen mid=_n

replace pc_name="kheri" if pc_name=="khiri/lakhimpur"

reclink st_name pc_name using LS_2004_BIMARU.dta, idm(mid) idu(obs_id) gen(matchscore)

rename _merge mergeLS2004

gen party_mp=""

replace party_mp=maxparty_pc

replace party_mp="RJD" if mp=="Rajesh Ranjan" & constituency=="madhepura"
replace party_mp="JD(U)" if mp=="Shri Ramswaroop Prasad" & constituency=="nalanda"
replace party_mp="INC" if mp=="Shri Devwrat Singh" & constituency=="rajnandgaon"
replace party_mp="JMM" if mp=="Smt Suman Mahato" & constituency=="jamshedpur"
replace party_mp="RJD" if mp=="Shri Ghuran Ram" & constituency=="palamau"
replace party_mp="BJP" if mp=="Shri Hemant  Khandelwal" & constituency=="betul"
replace party_mp="BJP" if mp=="Smt Yashodhara Raje Scindia" & constituency=="gwalior"
replace party_mp="INC" if mp=="Shri Arun Yadav" & constituency=="khargone"
replace party_mp="INC" if mp=="Shri  Manik Singh" & constituency=="sidhi"
replace party_mp="BJP" if mp=="Shri Rampal  Singh" & constituency=="vidisha"
replace party_mp="SP" if mp=="Shankh Lal Manjhi" & constituency=="akbarpur"
replace party_mp="SP" if mp=="Shri Neeraj Shekhar" & constituency=="ballia"
replace party_mp="BSP" if mp=="Shri Anil Shukla Warsi" & constituency=="bilhaur"
replace party_mp="BSP" if mp=="Shri Bhishm Shankar" & constituency=="khalilabad"
replace party_mp="SP" if mp=="Dharmendra Yadav" & constituency=="mainpuri"

replace party_mp="BSP" if mp=="Shri Ramesh Dube" & constituency=="mirzapur"
replace party_mp="BSP" if mp=="Shri Bhai Lal" & constituency=="robertsganj"
replace party_mp="BJP" if mp=="LtGen T.P.S. Rawat" & constituency=="garhwal"
replace party_mp="INC" if mp=="Shri Vijay Bahuguna" & constituency=="tehri garhwal"

save BIMARU_MPLADS_LS2004_PCMerged.dta, replace

*1999 Lok Sabha

use BIMARU_MPLADS_matched_LS1999.dta, clear

replace pc_name=subinstr(pc_name, "(sc)", "", .)

replace pc_name=subinstr(pc_name, "(st)", "", .)

replace st_name="bihar" if constituency=="dumka"&st_name=="jharkhand"
replace st_name="bihar" if constituency=="chatra"&st_name=="jharkhand"
replace st_name="bihar" if constituency=="dhanbad"&st_name=="jharkhand"
replace st_name="bihar" if constituency=="hazaribagh"&st_name=="jharkhand"
replace st_name="bihar" if constituency=="jamshedpur"&st_name=="jharkhand"
replace st_name="bihar" if constituency=="kodarma"&st_name=="jharkhand"
replace st_name="bihar" if constituency=="singhbhum"&st_name=="jharkhand"

replace st_name="chhattisgarh" if constituency=="bastar"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="bilaspur"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="mahasamund"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="kanker"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="raigarh"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="raipur"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="rajnandgaon"&st_name=="madhya pradesh"
replace st_name="chhattisgarh" if constituency=="surguja"&st_name=="madhya pradesh"


sort st_name lsrs  constituency mp nodaldistrict allsanctionedworksiliworksnotsan worknamewithlocation blockurban wardgrampanchayat/*
*/ dateofreceiptofproposalforworkfr dateofsanctionofworkbydistrict executingagency costsanctionedbydistrict workstatus

gen mid=_n

replace pc_name="kheri" if pc_name=="khiri/lakhimpur"

reclink st_name pc_name using LS_1999_BIMARU.dta, idm(mid) idu(obs_id) gen(matchscore)

rename _merge mergeLS1999

gen party_mp=""

replace party_mp=maxparty_pc

replace party_mp="JMM" if mp=="SH. SHIBU SOREN"&constituency=="dumka"
replace party_mp="INC" if mp=="SH. JYOTIRADITYA SCINDIA"&constituency=="guna"
replace party_mp="INC" if mp=="SH. RAMA DEVI"&constituency=="dausa"
replace party_mp="BJP" if mp=="SH. KAILASH MEGHWAL"&constituency=="tonk"
replace party_mp="SP" if mp=="SH. RAM RATI BIND"&constituency=="mirzapur"
replace party_mp="SP" if mp=="SH. AKHILESH YADAV"&constituency=="kannauj"
replace party_mp="SP" if mp=="SH. RAMAMURTHI SINGH VERMA"&constituency=="shahjahanpur"


save BIMARU_MPLADS_LS1999_PCMerged.dta, replace


*NOW COMBINE ALL PC MERGED FILES

use BIMARU_MPLADS_LS1999_PCMerged.dta, clear

append using BIMARU_MPLADS_LS2004_PCMerged.dta, force

append using BIMARU_MPLADS_LS2009_PCMerged.dta, force

save BIMARU_MPLADS_PCMerged.dta, replace



*NOW MERGE WITH THE STATE ELECTION DATA

use BIMARU_MPLADS_PCMerged.dta, clear

*Create the election year variable

*The following code creates a variable "receipt date" and cleans the variable.

gen receipt_date=date(dateofreceiptofproposalforworkfr, "DMY")

replace receipt_date=date(dateofreceiptofproposalforworkfr, "DM20Y")

replace receipt_date=date(dateofreceiptofproposalforworkfr, "DM19Y") if year(receipt_date)==2099

replace receipt_date=date(dateofreceiptofproposalforworkfr, "DM19Y") if year(receipt_date)==2098

replace receipt_date=date(dateofreceiptofproposalforworkfr, "DM19Y") if year(receipt_date)==2097

replace receipt_date=date(dateofreceiptofproposalforworkfr, "DM19Y") if year(receipt_date)==2096

replace receipt_date=date(dateofreceiptofproposalforworkfr, "DM19Y") if year(receipt_date)==2095

replace receipt_date=date(dateofreceiptofproposalforworkfr, "DM19Y") if year(receipt_date)==2094

replace receipt_date=date(dateofreceiptofproposalforworkfr, "DM19Y") if year(receipt_date)==2093

format receipt_date %td

*Generate project year variable for creating project year dummies

gen project_year=year(receipt_date)

*The following code specifies electoral terms based on the dates of the state elections in each state

gen electerm=.

gen term1start="3/3/2000" if st_name=="bihar"

gen term1end="6/3/2005" if st_name=="bihar"

gen term2_0_start="6/3/2005" if st_name=="bihar"

gen term2_0_end="24/11/2005" if st_name=="bihar"

gen term2start="24/11/2005" if st_name=="bihar"

gen term2end="26/11/2010" if st_name=="bihar"

gen term3start="26/11/2010" if st_name=="bihar"

gen term3end="20/05/2014" if st_name=="bihar"


replace term1start="15/11/2000" if st_name=="jharkhand"

replace term1end="2/3/2005" if st_name=="jharkhand"


replace term2start="2/3/2005" if st_name=="jharkhand"

replace term2end="30/12/2009" if st_name=="jharkhand"


replace term3start="30/12/2009" if st_name=="jharkhand"

replace term3end="28/12/2014" if st_name=="jharkhand"



replace term1start="1/12/1998" if st_name=="madhya pradesh"

replace term1end="8/12/2003" if st_name=="madhya pradesh"


replace term2start="8/12/2003" if st_name=="madhya pradesh"

replace term2end="12/12/2008" if st_name=="madhya pradesh"


replace term3start="12/12/2008" if st_name=="madhya pradesh"

replace term3end="13/12/2013" if st_name=="madhya pradesh"


replace term1start="1/12/1998" if st_name=="rajasthan"

replace term1end="8/12/2003" if st_name=="rajasthan"


replace term2start="8/12/2003" if st_name=="rajasthan"

replace term2end="11/12/2008" if st_name=="rajasthan"


replace term3start="12/12/2008" if st_name=="rajasthan"

replace term3end="13/12/2013" if st_name=="rajasthan"



replace term1start="3/5/2002" if st_name=="uttar pradesh"

replace term1end="13/5/2007" if st_name=="uttar pradesh"


replace term2start="13/5/2007" if st_name=="uttar pradesh"

replace term2end="15/3/2012" if st_name=="uttar pradesh"


replace term3start="15/3/2012" if st_name=="uttar pradesh"

replace term3end="15/3/2016" if st_name=="uttar pradesh"


replace term1start="1/12/1998" if st_name=="chhattisgarh"

replace term1end="6/12/2003" if st_name=="chhattisgarh"


replace term2start="7/12/2003" if st_name=="chhattisgarh"

replace term2end="7/12/2008" if st_name=="chhattisgarh"


replace term3start="7/12/2008" if st_name=="chhattisgarh"

replace term3end="9/12/2013" if st_name=="chhattisgarh"



replace term1start="2/3/2002" if st_name=="uttarakhand"

replace term1end="7/3/2007" if st_name=="uttarakhand"


replace term2start="8/3/2007" if st_name=="uttarakhand"

replace term2end="13/3/2012" if st_name=="uttarakhand"


replace term3start="14/3/2012" if st_name=="uttarakhand"

replace term3end="14/3/2016" if st_name=="uttarakhand"


gen term1start1=date(term1start, "DM20Y")

format term1start1 %td

gen term1end1=date(term1end, "DM20Y")

format term1end1 %td

gen term2_0_start1=date(term2_0_start, "DM20Y")

format term2_0_start1 %td

gen term2_0_end1=date(term2_0_end, "DM20Y")

format term2_0_end1 %td

gen term2start1=date(term2start, "DM20Y")

format term2start1 %td

gen term2end1=date(term2end, "DM20Y")

format term2end1 %td

gen term3start1=date(term3start, "DM20Y")

format term3start1 %td

gen term3end1=date(term3end, "DM20Y")

format term3end1 %td


replace receipt_date=mdy(5, 29, 2005) if month(receipt_date)==5&year(receipt_date)==2055&st_name=="bihar"
replace receipt_date=mdy(9, 29, 2005) if month(receipt_date)==9&year(receipt_date)==2055&st_name=="bihar"
replace receipt_date=mdy(2, 12, 1999) if month(receipt_date)==2&year(receipt_date)==2099&st_name=="bihar"


*The following code assigns an electoral term to each project based on the receipt date 
*This variable, along with the variables "ac_no_GIS" and "ac_name_GIS" were used to merge with the Bhavnani state election dataset

replace electerm=1995 if st_name=="bihar"&receipt_date<term1start1

replace electerm=2000 if st_name=="bihar"&receipt_date>=term1start1&receipt_date<term1end1

replace electerm=2005 if st_name=="bihar"&receipt_date>=term2_0_start1&receipt_date<term2_0_end1

replace electerm=2005.1 if st_name=="bihar"&receipt_date>=term2start1&receipt_date<term2end1

replace electerm=2010 if st_name=="bihar"&receipt_date>=term3start1&receipt_date<term3end1


replace electerm=1995 if st_name=="jharkhand"&receipt_date<term1start1

replace st_name="bihar" if electerm==1995&st_name=="jharkhand"

replace electerm=2000 if st_name=="jharkhand"&receipt_date>=term1start1&receipt_date<term1end1

replace electerm=2005 if st_name=="jharkhand"&receipt_date>=term2start1&receipt_date<term2end1

replace electerm=2009 if st_name=="jharkhand"&receipt_date>=term3start1&receipt_date<term3end1



replace electerm=1993 if st_name=="madhya pradesh"&receipt_date<term1start1

replace electerm=1998 if st_name=="madhya pradesh"&receipt_date>=term1start1&receipt_date<term1end1

replace electerm=2003 if st_name=="madhya pradesh"&receipt_date>=term2start1&receipt_date<term2end1

replace electerm=2008 if st_name=="madhya pradesh"&receipt_date>=term3start1&receipt_date<term3end1


replace electerm=1993 if st_name=="rajasthan"&receipt_date<term1start1

replace electerm=1998 if st_name=="rajasthan"&receipt_date>=term1start1&receipt_date<term1end1

replace electerm=2003 if st_name=="rajasthan"&receipt_date>=term2start1&receipt_date<term2end1

replace electerm=2008 if st_name=="rajasthan"&receipt_date>=term3start1&receipt_date<term3end1


replace electerm=1996 if st_name=="uttar pradesh"&receipt_date<term1start1

replace electerm=2002 if st_name=="uttar pradesh"&receipt_date>=term1start1&receipt_date<term1end1

replace electerm=2007 if st_name=="uttar pradesh"&receipt_date>=term2start1&receipt_date<term2end1

replace electerm=2012 if st_name=="uttar pradesh"&receipt_date>=term3start1&receipt_date<term3end1



replace electerm=1998 if st_name=="chhattisgarh"&receipt_date>=term1start1&receipt_date<term1end1

replace st_name="madhya pradesh" if electerm==1998&st_name=="chhattisgarh"

replace electerm=2003 if st_name=="chhattisgarh"&receipt_date>=term2start1&receipt_date<term2end1

replace electerm=2008 if st_name=="chhattisgarh"&receipt_date>=term3start1&receipt_date<term3end1

replace electerm=2013 if st_name=="chhattisgarh"&receipt_date>term3end1&receipt_date!=.



replace electerm=1996 if st_name=="uttarakhand"&receipt_date<term1start1

replace electerm=2002 if st_name=="uttarakhand"&receipt_date>=term1start1&receipt_date<term1end1

replace electerm=2007 if st_name=="uttarakhand"&receipt_date>=term2start1&receipt_date<term2end1

replace electerm=2012 if st_name=="uttarakhand"&receipt_date>=term3start1&receipt_date<term3end1

gen elecyear=string(electerm)

replace elecyear="2005_1" if elecyear=="2005.1"

*Now create a numerical election year variable

destring(elecyear), force gen(election_year)

replace election_year=2005 if elecyear=="2005_1"

*Now merge the with *predelimitation* state electoral data 

merge m:m state_ut ac_no_gis ac_name_GIS elecyear using StateElectionData_Predelim.dta, force

rename _merge merge_predelim


*fill in missing information

replace maxparty=maxparty_2002 if st_name=="uttarakhand"&elecyear=="2002"

replace maxvote=maxvote_2002 if st_name=="uttarakhand"&elecyear=="2002"

replace secparty=secparty_2002 if st_name=="uttarakhand"&elecyear=="2002"

replace secvote=secvote_2002 if st_name=="uttarakhand"&elecyear=="2002"

replace windiff=windiff_2002 if st_name=="uttarakhand"&elecyear=="2002"

replace ac_totvote=ac_totvote_2002 if st_name=="uttarakhand"&elecyear=="2002"

replace windiffsh=windiffsh_2002 if st_name=="uttarakhand"&elecyear=="2002"

replace maxvotesh=maxvotesh_2002 if st_name=="uttarakhand"&elecyear=="2002"



*Now merge with *postdelimitation* state electoral data

*merge m:m state_ut ac_no_gis_post ac_name_GIS elecyear using Bhavnani_ALLSTATES_collapsed_POSTDELIM2.dta, force update replace

merge m:m state_ut ac_no_gis_post ac_name_GIS elecyear using StateElectionData_Postdelim.dta, force update replace

rename _merge merge_postdelim

*record observations without electoral data as not matched

replace matched=0 if maxparty==""

*create variables identifying the time of project proposal relative to the time of the state election

gen project_bef_elec=.

local timevars term1start1 term2_0_start1 term2start1 term3start1 

foreach var in `timevars'{

replace project_bef_elec=1 if receipt_date>=`var'-180&receipt_date<`var'

}



gen project_bef_elec_1yr=.

local timevars term1start1 term2_0_start1 term2start1 term3start1 

foreach var in `timevars'{

replace project_bef_elec_1yr=1 if receipt_date>=`var'-365&receipt_date<`var'

}


gen project_bef_elec_2yr=.

local timevars term1start1 term2_0_start1 term2start1 term3start1 

foreach var in `timevars'{

replace project_bef_elec_2yr=1 if receipt_date>=`var'-730&receipt_date<`var'

}


gen project_bef_elec_3yr=.

local timevars term1start1 term2_0_start1 term2start1 term3start1 

foreach var in `timevars'{

replace project_bef_elec_3yr=1 if receipt_date>=`var'-1095&receipt_date<`var'

}


gen project_aft_elec=.

local timevars term1start1 term2_0_start1 term2start1 term3start1 

foreach var in `timevars'{

replace project_aft_elec=1 if receipt_date>=`var'&receipt_date<`var'+182

}

gen project_aft_elec_1yr=.

local timevars term1start1 term2_0_start1 term2start1 term3start1 

foreach var in `timevars'{

replace project_aft_elec_1yr=1 if receipt_date>=`var'&receipt_date<`var'+365

}

gen project_aft_elec_2yr=.

local timevars term1start1 term2_0_start1 term2start1 term3start1 

foreach var in `timevars'{

replace project_aft_elec_2yr=1 if receipt_date>=`var'&receipt_date<`var'+730

}

*Now create variables capturing only previously scheduled elections

gen term3start1_exog=term3start1

gen term3start_exog_jh="2/3/2010" if st_name=="jharkhand"

gen term3start1_exog_jh=date(term3start_exog_jh, "DM20Y")

format term3start1_exog_jh %td

replace term3start1_exog=term3start1_exog_jh if st_name=="jharkhand"


gen term2start1_exog=term2start1

replace term2start1_exog=term2_0_start1 if st_name=="bihar"


gen project_aft_elec_2yr_exog=.

local timevars term1start1 term2_0_start1 term2start1_exog term3start1_exog

foreach var in `timevars'{

replace project_aft_elec_2yr_exog=1 if receipt_date>=`var'&receipt_date<`var'+730

}


gen project_aft_elec_1yr_exog=.

local timevars term1start1 term2_0_start1 term2start1_exog term3start1_exog

foreach var in `timevars'{

replace project_aft_elec_1yr_exog=1 if receipt_date>=`var'&receipt_date<`var'+365

}

gen project_bef_elec_2yr_exog=.

local timevars term1start1 term2_0_start1 term2start1_exog term3start1_exog

foreach var in `timevars'{

replace project_bef_elec_2yr_exog=1 if receipt_date>=`var'-730&receipt_date<`var'

}


*create variables identifying the time of project proposal relative to the time of the national election 

gen ls_term_13=date("13/10/1999", "DMY")

gen ls_term_14=date("22/5/2004", "DMY")

gen ls_term_15=date("22/5/2009", "DMY")

gen ls_term_16=date("26/5/2014", "DMY")


format %td ls_term_13 ls_term_14 ls_term_15 ls_term_16


gen project_bef_ls_elec=.

local ls_term ls_term_13 ls_term_14 ls_term_15 ls_term_16

foreach var in `ls_term'{

replace project_bef_ls_elec=1 if receipt_date>=`var'-180&receipt_date<`var'

}


gen project_bef_ls_elec_1yr=.

local ls_term ls_term_13 ls_term_14 ls_term_15 ls_term_16

foreach var in `ls_term'{

replace project_bef_ls_elec_1yr=1 if receipt_date>=`var'-365&receipt_date<`var'

}


gen project_bef_ls_elec_2yr=.

local ls_term ls_term_13 ls_term_14 ls_term_15 ls_term_16

foreach var in `ls_term'{

replace project_bef_ls_elec_2yr=1 if receipt_date>=`var'-730&receipt_date<`var'

}


gen project_bef_ls_elec_3yr=.

local ls_term ls_term_13 ls_term_14 ls_term_15 ls_term_16

foreach var in `ls_term'{

replace project_bef_ls_elec_3yr=1 if receipt_date>=`var'-1095&receipt_date<`var'

}


replace project_bef_ls_elec_1yr=0 if project_bef_ls_elec_1yr!=1

replace project_bef_ls_elec_2yr=0 if project_bef_ls_elec_2yr!=1

replace project_bef_ls_elec_3yr=0 if project_bef_ls_elec_3yr!=1

replace project_bef_elec_1yr=0 if project_bef_elec_1yr!=1

replace project_bef_elec_2yr=0 if project_bef_elec_2yr!=1

replace project_bef_elec_3yr=0 if project_bef_elec_3yr!=1

gen project_aft_ls_elec=.

local ls_term ls_term_13 ls_term_14 ls_term_15 ls_term_16

foreach var in `ls_term'{

replace project_aft_ls_elec=1 if receipt_date>=`var'&receipt_date<`var'+180

}


gen project_aft_ls_elec_1yr=.

local ls_term ls_term_13 ls_term_14 ls_term_15 ls_term_16

foreach var in `ls_term'{

replace project_aft_ls_elec_1yr=1 if receipt_date>=`var'&receipt_date<`var'+365

}

gen project_aft_ls_elec_2yr=.

local ls_term ls_term_13 ls_term_14 ls_term_15 ls_term_16

foreach var in `ls_term'{

replace project_aft_ls_elec_2yr=1 if receipt_date>=`var'&receipt_date<`var'+730

}

replace project_aft_ls_elec_1yr=0 if project_aft_ls_elec_1yr!=1

replace project_aft_ls_elec_2yr=0 if project_aft_ls_elec_2yr!=1

replace project_aft_ls_elec=0 if project_aft_ls_elec!=1

replace project_aft_elec_1yr=0 if project_aft_elec_1yr!=1

replace project_aft_elec_2yr=0 if project_aft_elec_2yr!=1

replace project_aft_elec=0 if project_aft_elec!=1



*Now generate the variable indicating alignment between the MLA's party ("maxparty") and the MP's party ("party_mp").

gen mp_aligned=.

replace mp_aligned=1 if maxparty==party_mp&maxparty!=""&party_mp!=""&party_mp!="IND"

replace mp_aligned=0 if maxparty!=party_mp&maxparty!=""&party_mp!=""

replace mp_aligned=0 if party_mp=="IND"

replace mp_aligned=1 if party_mp=="LJNSP"&maxparty=="LJP"



*Now generate the "forcing" variable and the relevant interaction terms used in the RD analyses

gen forcing=.

replace forcing=windiffsh if maxparty==party_mp&maxparty!=""&party_mp!=""&party_mp!="IND"

replace forcing=-windiffsh if secparty==party_mp&maxparty!=""&party_mp!=""&party_mp!="IND"


gen forcing_sq=forcing^2

gen forcing_cub=forcing^3

gen forcing_qua=forcing^4

gen forcing_aligned=forcing*mp_aligned

gen forcing_sq_aligned=forcing_sq*mp_aligned

gen forcing_cub_aligned=forcing_cub*mp_aligned

gen forcing_qua_aligned=forcing_qua*mp_aligned

*Now generate the "project expenditure" variable based on the reported "cost sanctioned by district"

***the following code standardizes the variable so that all amounts are expressed in lakhs of rupees

replace costsanctionedbydistrict=costsanctionedbydistrict*100000 if costsanctionedbydistrict<=1500

replace costsanctionedbydistrict=. if costsanctionedbydistrict==0

gen costsanctionedbydistrict2=costsanctionedbydistrict/100000

rename costsanctionedbydistrict2 project_expenditure

*Generate "Allotment Increase" variable

gen fivecrorechange="4/1/2012"

gen fivecrorechange1=date(fivecrorechange, "DM20Y")

format fivecrorechange1 %td

gen allot_increase=.

replace allot_increase=1 if receipt_date>=fivecrorechange1&receipt_date!=.

replace allot_increase=0 if receipt_date<fivecrorechange1&receipt_date!=.


*Now generate the "urban" variable

gen urban=.

replace urban=1 if blockurban=="urban"

replace urban=1 if blockurban=="urban area"

replace urban=1 if blockurban=="town"

replace urban=1 if blockurban=="URBAN"

replace urban=1 if blockurban=="Urban"

replace urban=1 if regexm(wardgrampanchayat, "ward")==1

replace urban=1 if regexm(wardgrampanchayat, "city")==1

replace urban=1 if regexm(wardgrampanchayat, "town")==1


replace urban=0 if urban!=1

*Now generate the "multiple" variable

gen multiple=.

replace multiple=1 if regexm(blockurban, "different")==1

replace multiple=1 if regexm(blockurban, "many ")==1

replace multiple=1 if regexm(wardgrampanchayat, "different")==1

replace multiple=1 if regexm(wardgrampanchayat, "many ")==1

replace multiple=1 if regexm(blockurban, " and ")==1

replace multiple=1 if regexm(wardgrampanchayat, " and ")==1

replace multiple=1 if wardgrampanchayat=="all"

replace multiple=1 if blockurban=="all"

replace multiple=1 if blockurban=="all blocks"

replace multiple=1 if blockurban=="all block"

replace multiple=1 if wardgrampanchayat=="all blocks"

replace multiple=1 if wardgrampanchayat=="district"

replace multiple=1 if regexm(wardgrampanchayat, "blocks")==1

replace multiple=1 if regexm(blockurban, "blocks")==1

replace multiple=1 if wardgrampanchayat=="n.a."

replace multiple=1 if wardgrampanchayat=="rohtas dist"

replace multiple=1 if wardgrampanchayat=="all"&blockurban=="all"

replace multiple=1 if wardgrampanchayat=="many panchayats"&blockurban=="many blocks"

replace multiple=1 if wardgrampanchayat=="all blocks"

replace multiple=1 if blockurban=="rural and urban"

replace multiple=1 if blockurban=="urban and block"

replace multiple=0 if multiple!=1

*Now generate the variable indicating whether the project provides a benefit to a specified individual's home
*the coding scheme was devised inductively by examining the project descriptions and the descriptions were manually checked to ensure*
* that the coding scheme was correctly implemented.


gen house=strpos(worknamewithlocation, "house") > 0

replace house=1 if strpos(worknamewithlocation, " ghar") > 0

replace house=1 if strpos(worknamewithlocation, "home") > 0

replace house=1 if strpos(worknamewithlocation, "HOUSE") > 0

replace house=1 if strpos(worknamewithlocation, "HOME") > 0

replace house=1 if strpos(worknamewithlocation, "GHAR") > 0

replace house=1 if strpos(worknamewithlocation, "House") > 0

replace house=1 if strpos(worknamewithlocation, "Home") > 0

replace house=1 if strpos(worknamewithlocation, "Ghar") > 0

replace house=0 if worknamewithlocation=="Const. of pcc from Bashudha Apartment to House no. B 14"

replace house=0 if worknamewithlocation=="Gram ara Block mohaniya me khata no 126  plot 957 me Tyubbell per pamp house nirman."

replace house=0 if worknamewithlocation=="Vill Samhuta me Nahar main road se dalit basti tak home paip and rasta nirman"

replace house=0 if worknamewithlocation=="c/o of pcc from asha nursing home to workshop inspector office in majhaulia road"

replace house=0 if worknamewithlocation=="Boundrywall of Sughar Singh Public School Kachaora Road Jaswantnagar"

replace house=0 if regexm(worknamewithlocation, "nursing home")==1

replace house=0 if regexm(worknamewithlocation, "narsing home")==1

replace house=0 if regexm(worknamewithlocation, "guest house")==1

replace house=0 if regexm(worknamewithlocation, "Guest house")==1

replace house=0 if regexm(worknamewithlocation, "Guest House")==1

replace house=0 if regexm(worknamewithlocation, "GUEST HOUSE")==1

replace house=0 if regexm(worknamewithlocation, "school house")==1

replace house=0 if regexm(worknamewithlocation, "SCHOOL HOUSE")==1

replace house=0 if regexm(worknamewithlocation, "Rest House")==1

replace house=0 if regexm(worknamewithlocation, "rest house")==1

replace house=0 if regexm(worknamewithlocation, "Ambedkar House")==1

replace house=0 if regexm(worknamewithlocation, "water house")==1

replace house=0 if regexm(worknamewithlocation, "MATERNITY HOME")==1

replace house=0 if regexm(worknamewithlocation, "MATERNITY")==1

replace house=0 if regexm(worknamewithlocation, "Baraat ghar")==1

replace house=0 if regexm(worknamewithlocation, "baraat ghar")==1

replace house=0 if regexm(worknamewithlocation, "BARAT GHAR")==1

replace house=0 if regexm(worknamewithlocation, "barat ghar")==1

replace house=0 if regexm(worknamewithlocation, "farm house")==1

replace house=0 if regexm(worknamewithlocation, "FARM HOUSE")==1

replace house=0 if regexm(worknamewithlocation, "panchayat ghar")==1

replace house=0 if regexm(worknamewithlocation, "panchyat ghar")==1

replace house=0 if regexm(worknamewithlocation, "PANCHAYAT GHAR")==1

replace house=0 if regexm(worknamewithlocation, "GharGhoda")==1

replace house=0 if regexm(worknamewithlocation, "Gharghoda")==1

replace house=0 if regexm(worknamewithlocation, "Indira Awas Houses")==1

replace house=0 if regexm(worknamewithlocation, "Indira Awaas Houses")==1

replace house=0 if regexm(worknamewithlocation, "PWD INSPECTION HOUSE")==1

replace house=0 if regexm(worknamewithlocation, "MARRIAGE")==1

gen worknamewithlocation_l=lower(worknamewithlocation)

replace house=0 if regexm(worknamewithlocation_l, "marriage")==1

replace house=0 if regexm(worknamewithlocation_l, "nayak ghar")==1

replace house=0 if regexm(worknamewithlocation_l, "panchayat ghar")==1

replace house=0 if regexm(worknamewithlocation_l, "panchyat ghar")==1

replace house=0 if regexm(worknamewithlocation_l, "panchayatghar")==1

replace house=0 if regexm(worknamewithlocation_l, "panchyatghar")==1

replace house=0 if regexm(worknamewithlocation_l, "baratghar")==1

replace house=0 if regexm(worknamewithlocation_l, "barat ghar")==1

replace house=0 if regexm(worknamewithlocation_l, "baraat ghar")==1

replace house=0 if regexm(worknamewithlocation_l, "old-age home")==1

replace house=0 if regexm(worknamewithlocation_l, "old age home")==1

replace house=0 if regexm(worknamewithlocation_l, "katghar")==1

replace house=0 if regexm(worknamewithlocation_l, "tighara")==1

replace house=0 if regexm(worknamewithlocation_l, "rest house")==1

replace house=0 if regexm(worknamewithlocation_l, "guest house")==1

replace house=0 if regexm(worknamewithlocation_l, "nursing home")==1

replace house=0 if regexm(worknamewithlocation_l, "narsing home")==1


replace house=0 if regexm(worknamewithlocation_l, "sand ghar")==1

replace house=0 if regexm(worknamewithlocation_l, "sandghar")==1

replace house=0 if regexm(worknamewithlocation_l, "sand pada ghar")==1

replace house=0 if regexm(worknamewithlocation_l, "sandapada")==1

replace house=0 if regexm(worknamewithlocation_l, "sand pada")==1

replace house=0 if regexm(worknamewithlocation_l, "houseing")==1

replace house=0 if regexm(worknamewithlocation_l, "community house")==1

replace house=0 if regexm(worknamewithlocation_l, "house market")==1

replace house=0 if regexm(worknamewithlocation_l, "power house")==1

replace house=0 if regexm(worknamewithlocation_l, "ghari")==1

replace house=0 if regexm(worknamewithlocation_l, "panchayat house")==1

replace house=0 if regexm(worknamewithlocation_l, "panchyat house")==1

replace house=0 if regexm(worknamewithlocation_l, "gest house")==1

replace house=0 if regexm(worknamewithlocation_l, "circit house")==1

replace house=0 if regexm(worknamewithlocation_l, "circuit house")==1

replace house=0 if regexm(worknamewithlocation_l, "bharat ghar")==1

replace house=0 if regexm(worknamewithlocation_l, "pump house")==1

replace house=0 if regexm(worknamewithlocation_l, "ghargodi")==1

replace house=0 if worknamewithlocation=="Construction of building for women cultures  house in Pandarmuda"

replace house=0 if worknamewithlocation=="Constraction of Pachari Gharghodi"


replace house=0 if regexm(worknamewithlocation_l, "transformer")==1

replace house=0 if regexm(worknamewithlocation_l, "transformar")==1

replace house=0 if regexm(worknamewithlocation_l, "transform")==1

rename house indiv_benefit

*Now generate the variable indicating whether the MP belongs to the state ruling party

gen mp_state_ruling=.

replace mp_state_ruling=1 if st_name=="bihar"&election_year==1995&party_mp=="JD"

replace mp_state_ruling=1 if st_name=="bihar"&election_year==2000&party_mp=="RJD"

replace mp_state_ruling=1 if st_name=="bihar"&election_year==2005&party_mp=="JD(U)"

replace mp_state_ruling=1 if st_name=="bihar"&election_year==2010&party_mp=="JD(U)"


replace mp_state_ruling=1 if st_name=="jharkhand"&election_year==2000&party_mp=="BJP"

replace mp_state_ruling=1 if st_name=="jharkhand"&party_mp=="BJP"&election_year==2005&project_year>=2005&project_year<=2006

replace mp_state_ruling=1 if st_name=="jharkhand"&party_mp=="JMM"&election_year==2005&project_year>2006&project_year<=2009

replace mp_state_ruling=1 if st_name=="jharkhand"&election_year==2009&party_mp=="BJP"&project_year>=2010&project_year<=2014


replace mp_state_ruling=1 if st_name=="chhattisgarh"&election_year==1998&party_mp=="INC"

replace mp_state_ruling=1 if st_name=="chhattisgarh"&election_year==2003&party_mp=="BJP"

replace mp_state_ruling=1 if st_name=="chhattisgarh"&election_year==2008&party_mp=="BJP"


replace mp_state_ruling=1 if st_name=="madhya pradesh"&election_year==1993&party_mp=="INC"

replace mp_state_ruling=1 if st_name=="madhya pradesh"&election_year==1998&party_mp=="INC"

replace mp_state_ruling=1 if st_name=="madhya pradesh"&election_year==2003&party_mp=="BJP"

replace mp_state_ruling=1 if st_name=="madhya pradesh"&election_year==2008&party_mp=="BJP"


replace mp_state_ruling=1 if st_name=="rajasthan"&election_year==1993&party_mp=="BJP"

replace mp_state_ruling=1 if st_name=="rajasthan"&election_year==1998&party_mp=="INC"

replace mp_state_ruling=1 if st_name=="rajasthan"&election_year==2003&party_mp=="BJP"

replace mp_state_ruling=1 if st_name=="rajasthan"&election_year==2008&party_mp=="INC"


replace mp_state_ruling=1 if st_name=="uttar pradesh"&election_year==1996&party_mp=="BJP"

replace mp_state_ruling=1 if st_name=="uttar pradesh"&election_year==2002&party_mp=="BSP"&project_year>=2002&project_year<=2003

replace mp_state_ruling=1 if st_name=="uttar pradesh"&election_year==2002&party_mp=="SP"&project_year>2003&project_year<=2007

replace mp_state_ruling=1 if st_name=="uttar pradesh"&election_year==2007&party_mp=="BSP"

replace mp_state_ruling=1 if st_name=="uttar pradesh"&election_year==2012&party_mp=="SP"

replace mp_state_ruling=0 if mp_state_ruling!=1


*Generate variable indicating that the project is incomplete at the time of data collection*

gen completed=.

replace completed=1 if workstatus=="COMPLETED"

replace completed=0 if workstatus!="COMPLETED"&workstatus!=""

gen incomplete=0 if completed==1

replace incomplete=0 if workstatus=="Status not reported"

replace incomplete=1 if incomplete!=0&workstatus!=""

*Generate alternative "incomplete" measure dropping projects whose status is not reported

gen incomplete2=incomplete

replace incomplete2=. if workstatus=="Status not reported"

*Now generate an indicator for a project involving road construction
*the coding scheme was generated inductively by manually examining the project descriptions

gen road=.

replace road=1 if regexm(worknamewithlocation_l, "road")==1

replace road=1 if regexm(worknamewithlocation_l, " rd ")==1

replace road=1 if regexm(worknamewithlocation_l, " rode ")==1

replace road=1 if regexm(worknamewithlocation_l, " rd. ")==1

replace road=0 if road!=1&worknamewithlocation_l!=""

*Now generate the "time to sanction" variable

gen sanction_date=date(dateofsanctionofworkbydistrict, "DMY")

replace sanction_date=date(dateofsanctionofworkbydistrict, "DM20Y")

replace sanction_date=date(dateofsanctionofworkbydistrict, "DM19Y") if year(sanction_date)==2099

replace sanction_date=date(dateofsanctionofworkbydistrict, "DM19Y") if year(sanction_date)==2098

replace sanction_date=date(dateofsanctionofworkbydistrict, "DM19Y") if year(sanction_date)==2097

replace sanction_date=date(dateofsanctionofworkbydistrict, "DM19Y") if year(sanction_date)==2096

replace sanction_date=date(dateofsanctionofworkbydistrict, "DM19Y") if year(sanction_date)==2095

replace sanction_date=date(dateofsanctionofworkbydistrict, "DM19Y") if year(sanction_date)==2094

replace sanction_date=date(dateofsanctionofworkbydistrict, "DM19Y") if year(sanction_date)==2093

replace sanction_date=. if year(sanction_date)>2015

format sanction_date %td

gen timetosanction=sanction_date-receipt_date

replace timetosanction=. if timetosanction<0

*Generate variables for project date relative to the date of data collection

gen datacollectiondate="15/09/2015"

gen datacollection=date(datacollectiondate, "DM20Y")

format datacollection %td

gen complete=1 if workstatus=="COMPLETED"

replace complete=0 if workstatus!="COMPLETED"&workstatus!=""

replace complete=. if workstatus=="Status not reported"

gen timebeforedatacollection=datacollection-receipt_date

gen monthsbeforedatacollection=timebeforedatacollection/30

*Merge in Block Level Variables (Aggregated to Constituency) Calculated in MLInfoMaps

merge m:m state_ut ac_name_GIS ac_no_gis using Block_AC_Intersect_Variables_Predelim_collapsed.dta

rename _merge merge_predelimblock

merge m:m state_ut ac_name_GIS ac_no_gis_post using Block_AC_Intersect_Variables_Postdelim_collapsed.dta, update

replace lit_perc_ac=736599/(562864+455228) if ac_no_gis_post==263&state_ut=="uttar pradesh"&_merge==1
replace lit_perc_ac=736599/(562864+455228) if ac_no_gis_post==261&state_ut=="uttar pradesh"&_merge==1


replace sc_perc_ac=127459/(562864+455228) if ac_no_gis_post==261&state_ut=="uttar pradesh"&_merge==1
replace sc_perc_ac=127459/(562864+455228) if ac_no_gis_post==263&state_ut=="uttar pradesh"&_merge==1


replace scst_perc_ac=(127459+495)/(562864+455228) if ac_no_gis_post==261&state_ut=="uttar pradesh"&_merge==1
replace scst_perc_ac=(127459+495)/(562864+455228) if ac_no_gis_post==263&state_ut=="uttar pradesh"&_merge==1

rename _merge merge_postdelimblock


*Generate variable indicating whether incumbent MLA is of the same party as the previous incumbent in the constituency*

gen party_same=.

replace party_same=1 if maxparty==maxparty_prev

replace party_same=0 if maxparty!=maxparty_prev

replace party_same=0 if maxparty=="IND"

replace party_same=. if maxparty==""

replace party_same=. if maxparty_prev==""

replace party_same=1 if maxparty=="LJNSP"&maxparty_prev=="LJP"

replace party_same=1 if maxparty_prev=="LJNSP"&maxparty=="LJP"

replace party_same=1 if maxparty=="INC"&maxparty_prev=="INC(I)"

replace party_same=1 if maxparty=="INC(I)"&maxparty_prev=="INC"

gen mp_aligned_sameparty=mp_aligned*party_same

*Generate variable for party turnover in previous term (for RD pre-treatment)

gen party_turnover_previous=.

replace party_turnover_previous=0 if maxparty_prev==maxparty_prev2

replace party_turnover_previous=1 if maxparty_prev!=maxparty_prev2

replace party_turnover_previous=0 if maxparty_prev=="IND"
replace party_turnover_previous=0 if maxparty_prev2=="IND"

replace party_turnover_previous=. if maxparty_prev==""
replace party_turnover_previous=. if maxparty_prev2==""

replace party_turnover_previous=0 if maxparty_prev=="LJNSP"&maxparty_prev2=="LJP"

replace party_turnover_previous=0 if maxparty_prev2=="LJNSP"&maxparty_prev=="LJP"

replace party_turnover_previous=0 if maxparty_prev=="INC"&maxparty_prev2=="INC(I)"

replace party_turnover_previous=0 if maxparty_prev2=="INC(I)"&maxparty_prev=="INC"

*Generate variable indicating whether incumbent MLA is a different person than the previous incumbent in the constituency*

gen cand_new=.

replace cand_new=0 if candwinner==candidate_prev

replace cand_new=1 if candwinner!=candidate_prev&candidate_prev!=" "

strdist candwinner candidate_prev, generate (candname_diff)

replace cand_new=0 if candname_diff==1

replace cand_new=0 if candname_diff==2

replace cand_new=1 if candwinner=="Jai Pratap Singh"&candidate_prev=="Ram Pratap Singh"

replace cand_new=0 if candname_diff==3

replace cand_new=0 if candname_diff==4

replace cand_new=1 if candwinner=="Maan Singh"&candidate_prev=="Pratap Singh"

replace cand_new=1 if candwinner=="Shyam"&candidate_prev=="Omkar"

replace cand_new=0 if candname_diff==5

replace cand_new=1 if candwinner=="Munnaf Alam"&candidate_prev=="Mahbub Alam"

replace cand_new=1 if candwinner=="Manik Singh"&candidate_prev=="Patiraj Singh"

replace cand_new=1 if candwinner=="Dharm Pal Singh"&candidate_prev=="Jagat Pal Singh"

replace cand_new=1 if candwinner=="Promod Kumar"&candidate_prev=="Pramod Tiwari"

replace cand_new=0 if candname_diff==6

replace cand_new=1 if candwinner=="Mahabali Singh"&candidate_prev=="Dinanath Singh"

replace cand_new=1 if candwinner=="Hajarilal Dangi"&candidate_prev=="Ramprasad Dangi"

replace cand_new=1 if candwinner=="Jagannath Pahadia"&candidate_prev=="Shanti Pahadia"

replace cand_new=1 if candwinner=="Sovran Singh"&candidate_prev=="Badshah Singh"

replace cand_new=0 if candname_diff==7

replace cand_new=1 if candwinner=="Arun Mandal"&candidate_prev=="Drub Bhagat"

replace cand_new=1 if candwinner=="Mohan Sharma"&candidate_prev=="Drub Bhagat"

replace cand_new=1 if candwinner=="Arun Mandal"&candidate_prev=="Laxmikant Sharma"

replace cand_new=1 if candwinner=="Digvijay Singh"&candidate_prev=="Laxman Singh"

replace cand_new=1 if candwinner=="Jeet Mal"&candidate_prev=="Poonjalal"

replace cand_new=1 if candwinner=="Gurmeet Singh"&candidate_prev=="Jagtar Singh"

replace cand_new=1 if candwinner=="Janmejai Singh"&candidate_prev=="Rajendra Singh"

replace cand_new=1 if candwinner=="Raj Rani"&candidate_prev=="Kashi Nath"

replace cand_new=1 if candwinner=="Santram"&candidate_prev=="Amerika"

replace cand_new=0 if candwinner=="Dharam Pal S/O Ram Kishan"&candidate_prev=="Dharampal"

replace cand_new=0 if candwinner=="Km.Sandhya"&candidate_prev=="Sandhya Katheriya"

replace cand_new=0 if candwinner=="Rameshwar Dayal Balmiki"&candidate_prev=="Rameshwar Dayal"

replace cand_new=0 if candwinner=="Jagdish Narain"&candidate_prev=="Jagdish Narayan (Rai)"

replace cand_new=0 if candwinner=="Indra Dev"&candidate_prev=="Inder Dev Singh"

replace cand_new=0 if candwinner=="Raghuveer Singh Meena"&candidate_prev=="Raghuvir Singh"

replace cand_new=0 if candwinner=="Habiboor Rahaman"&candidate_prev=="Habiburehman / Haziusman"

replace cand_new=0 if candwinner=="Mangi Lal Garasiya"&candidate_prev=="Mangi Lal"

replace cand_new=0 if candwinner=="Bundela Vijay Bahadur Singh"&candidate_prev=="Kunwarvijaybahadursingh Bundela"

replace cand_new=0 if candwinner=="Ajay Singh ( Rahul Bhaiya )"&candidate_prev=="Ajay Singh Rahul"

replace cand_new=0 if candwinner=="Subhash Yadav"&candidate_prev=="Subhash Chandra Gangaram Yadav"

replace cand_new=0 if candwinner=="Ahirwar Ramdayal"&candidate_prev=="Ramdayal Ahirwar"

replace cand_new=0 if candwinner=="Harnam Bhaiya"&candidate_prev=="Harnam Singh Rathor"

replace cand_new=0 if candwinner=="Smt. Sudha Jain"&candidate_prev=="Smt. Sudha Jain Advocate"

replace cand_new=0 if candwinner=="Naresh Chandra Agarwal"&candidate_prev=="Naresh Agrawal"

replace cand_new=0 if candwinner=="Ramhet Bharti"&candidate_prev=="Ram Het"

replace cand_new=0 if candwinner=="Kuwar Ratanjit Pratap Narayan Singh"&candidate_prev=="Kr. Ratan Jeet Pratap Narayan Singh"

replace cand_new=0 if candwinner=="Dr.Dharm Singh Saini"&candidate_prev=="Dharam Singh"

replace cand_new=0 if candwinner=="Radhey Shyam Jaiswal"&candidate_prev=="Radheshyam"

replace cand_new=0 if candwinner=="Hukumsingh Karada"&candidate_prev=="Karada Hukum Singh"

replace cand_new=. if candidate_prev==""

gen mp_aligned_candnew=mp_aligned*cand_new

*Generate variable indicating regional party

gen regional_party=.

replace regional_party=1 if party_mp!="BJP"&party_mp!="INC"&party_mp!="CPM"&party_mp!="CPI"

*Generate variable indicating safe seat

gen safe=1 if windiffsh>0.12&windiffsh!=.

replace safe=0 if windiffsh<0.12

*Generate variable calculating the proportion of completed projects based on when the project was proposed relative to data collection

egen monthscat=cut(monthsbeforedatacollection), at(0, 24,36,48,60, 204)

label define monthscatlabel 0 "Less than 2 Yrs" 24 "2 to 3 Yrs" 36 "3 to 4 Yrs" 48 "4 to 5 Yrs" 60 "More than 5 Yrs" 204 "More than 5 Yrs"

label values monthscat monthscatlabel

bysort monthscat: egen complete_mean=mean(complete)

*Generate variable calculating the proportion of projects with individualized benefits in each village

bysort st_name constituency ac_name_GIS villageidgis: egen mean_indivbenefit=mean(indiv_benefit)

replace mean_indivbenefit=. if villageidgis==.

*drop variables not used in the analysis

drop Ust_name nodaldistrict allsanctionedworksiliworksnotsan worknamewithlocation wardgrampanchayat/*
*/ dateofreceiptofproposalforworkfr dateofsanctionofworkbydistrict executingagency workstatus blockurban_missing/*
*/ villageidgis villagename_GIS block_name state_ut Upc_name mid matchscore obs_id pc_no maxparty_pc secparty_pc/*
*/ candwinner_pc pc_type_pc totvotpoll_pc partyabbre_pc pc_totvote maxvote_pc secvote_pc windiff_pc maxvotesh_pc votesh_pc/*
*/ enop_den_pc enop_pc mergeLS1999 mergeLS2004 mergeLS2009 receipt_date term1start term1end term2_0_start term2_0_end/*
*/ term2start term2end term3start term3end term1start1 term1end1 term2_0_start1 term2_0_end1 term2start1 term2end1 term3start1/*
*/ term3end1 election_year year ac_no ac_name maxparty secparty candwinner ac_type electors totvotpoll partyabbre ac_totvote/*
*/ maxvote maxvotesh secvote windiff votesh enop_den enop turnout maxparty_prev candidate_prev maxparty_prev2 ac_name2 idu/*
*/ ac_no_b ac_name3 maxparty_2002/*
*/ maxvote_2002 secparty_2002 secvote_2002 ac_totvote_2002 windiff_2002 windiffsh_2002 maxvotesh_2002 merge_predelim mergepostdelim/*
*/ merge_postdelim term3start1_exog term3start_exog_jh term3start1_exog_jh term2start1_exog project_aft_elec_2yr_exog/*
*/ project_aft_elec_1yr_exog project_bef_elec_2yr_exog ls_term_13 ls_term_14 ls_term_15 ls_term_16 fivecrorechange/*
*/ fivecrorechange1 worknamewithlocation_l completed sanction_date datacollectiondate datacollection timebeforedatacollection/*
*/ tot_pop_ac tot_sc_ac m_lit_ac f_lit_ac tot_lit_ac tot_w_ac r_tot_pop_ac/*
*/ u_tot_pop_ac r_tot_sc_ac r_tot_st_ac tot_cult_ac tot_aglb_ac sc_perc_ac merge_predelimblock merge_postdelimblock candname_diff/*
*/ ac_no_gis ac_no_gis_post pc_name windiffsh predelim LS_year monthsbeforedatacollection elecyear


*Label variables

label variable mp_aligned_sameparty "Co-Partisan State Incumbent * Same Party"
label variable mp_aligned_candnew "Co-Partisan State Incumbent * New Candidate"

label variable project_expenditure "Project Expenditure (Lakhs)"

label variable indiv_benefit "Individual Benefit"

label variable urban "Urban" 

label variable multiple "Multiple"

label variable allot_increase "Allotment Increase"

label variable mp_aligned "Co-Partisan State Incumbent"

label variable constituency "Parliamentary Constituency"

label variable forcing "Forcing"

label variable forcing_sq "Forcing$^{2}$"

label variable forcing_cub "Forcing$^{3}$"

label variable forcing_qua "Forcing$^{4}$"

label variable forcing_aligned "Forcing* Co-Partisan State Incumbent"

label variable forcing_sq_aligned "Forcing$^{2}$* Co-Partisan State Incumbent"

label variable forcing_cub_aligned "Forcing$^{3}$* Co-Partisan State Incumbent"

label variable forcing_qua_aligned "Forcing$^{4}$* Co-Partisan State Incumbent"

label variable mp_state_ruling "MP in State Ruling Party"

label variable project_aft_elec_2yr "Less than 2 Yrs After State Election"

label variable project_aft_elec_1yr "Less than 1 Yr After State Election"

label variable project_aft_elec "Less than 6 Months After State Election"

label variable project_bef_elec_2yr "Less than 2 Yrs Before State Election"

label variable project_bef_elec_3yr "Less than 3 Yrs Before State Election"

label variable project_bef_elec_1yr "Less than 1 Yr Before State Election"

label variable project_bef_elec "Less than 6 Months Before State Election"

label variable project_year "Project Year"

label variable project_bef_ls_elec_2yr "Less than 2 Yrs Before National Election"

label variable project_bef_ls_elec_3yr "Less than 3 Yrs Before National Election"

label variable project_bef_ls_elec_1yr "Less than 1 Yr Before National Election"

label variable project_bef_ls_elec "Less than 6 months before National Election"

label variable project_aft_ls_elec_2yr "Less than 2 Yrs After National Election"

label variable project_aft_ls_elec_1yr "Less than 1 Yr After National Election"

label variable project_aft_ls_elec "Less than 6 months After National Election"

label variable party_mp "MP's Party"

label variable regional_party "Regional Party"

label variable windiffsh_pc "MP Vote Margin"

label variable incomplete "Incomplete Project"

label variable incomplete2 "Incomplete Project (Alternative Measure)"

label variable complete "Complete"

label variable complete_mean "Proportion of Complete Projects"

label variable road "Road Project"
label variable windiffsh_l "Vote Margin (Previous Term)"
label variable party_same "Same Party"
label variable cand_new "New Candidate"
label variable lit_perc_ac "Literacy Rate"
label variable urban_perc_ac "Urban Proportion"
label variable scst_perc_ac "SC/ST Proportion"
label variable aglb_perc_ac "Proportion Agricultural Laborers"
label variable party_turnover_previous "Party Turnover (Previous Term)"
label variable safe "Safe Seat"
label variable timetosanction "Time to Sanction (Days)"
label variable complete "Complete"
label variable project_id "Project ID"
label variable electerm "Year of Most Recent State Election"

label variable lsrs "Lok Sabha Number"

label variable blockurban "Administrative Block/Urban Area"

label variable ac_name_GIS "State Assembly Constituency"

label variable mean_indivbenefit "Proportion of Individual Benefit Projects in Village"

label variable monthscat "Years Prior to Data Collection"

label variable elecyear_missing "Project Proposal Date Unavailable"

save BIMARU_MPLADS_AJPS_all.dta, replace

exit





