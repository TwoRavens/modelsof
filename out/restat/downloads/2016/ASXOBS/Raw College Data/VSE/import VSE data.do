*** See "VSE Variable Labels.pdf" for further details
*** VSE timing: "Fiscal Year 2007" = July 2006 - Jun 2007
*** corporations_total_giving vs corporations_total is Public vs Private versions of variable (same for foundations)

version 10
tempfile public private

*** PUBLIC RESEARCH ***

set more off
cd "Electronic/Public"

forvalues yearnum = 1999(1)2009 {
	insheet using FY`yearnum'.txt, tab

	assert v1[6] == "Arizona State University Foundation (Tempe, AZ) "
	assert v1[7] == "Auburn University (Auburn, AL) "
	assert v1[8] == "Ball State University (Muncie, IN) "
	assert v1[9] == "Bowling Green State University (Bowling Green, OH) "
	assert v1[10] == "California State Univ., San Diego (San Diego, CA) "
	assert v1[11] == "Central Michigan University (Mt. Pleasant, MI) "
	assert v1[12] == "Clemson University (Clemson, SC) "
	assert v1[13] == "Cleveland State University (Cleveland, OH) "
	assert v1[14] == "College of William and Mary (Williamsburg, VA) "
	assert v1[15] == "Colorado School of Mines (Golden, CO) "
	assert v1[16] == "Colorado State University (Fort Collins, CO) "
	assert v1[17] == "CUNY-Graduate School & Univ. Center (New York, NY) "
	assert v1[18] == "East Carolina University (Greenville, NC) "
	assert v1[19] == "East Tennessee State University (Johnson City, TN) "
	assert v1[20] == "Florida Agricultural and Mechanical (Tallahassee, FL) "
	assert v1[21] == "Florida Atlantic University (Boca Raton, FL) "
	assert v1[22] == "Florida International University (Miami, FL) "
	assert v1[23] == "Florida State University (Tallahassee, FL) "
	assert v1[24] == "George Mason University (Fairfax, VA) "
	assert v1[25] == "Georgia Institute of Technology (Atlanta, GA) "
	assert v1[26] == "Georgia Southern University (Statesboro, GA) "
	assert v1[27] == "Georgia State University (Atlanta, GA) "
	assert v1[28] == "Idaho State University (Pocatello, ID) "
	assert v1[29] == "Illinois State University (Normal, IL) "
	assert v1[30] == "Indiana State University (Terre Haute, IN) "
	assert v1[31] == "Indiana Univ. of Pennsylvania (Indiana, PA) "
	assert v1[32] == "Indiana University (Bloomington, IN) "
	assert v1[33] == "Iowa State University (Ames, IA) "
	assert v1[34] == "Jackson State University (Jackson, MS) "
	assert v1[35] == "Kansas State University (Manhattan, KS) "
	assert v1[36] == "Kent State University (Kent, OH) "
	assert v1[37] == "Louisiana State University - Baton Rouge (Baton Rouge, LA) "
	assert v1[38] == "Louisiana Tech University (Ruston, LA) "
	assert v1[39] == "Miami University (Oxford, OH) "
	assert v1[40] == "Michigan State University (East Lansing, MI) "
	assert v1[41] == "Michigan Technological University (Houghton, MI) "
	assert v1[42] == "Mississippi State University (Mississippi State, MS) "
	assert v1[43] == "Missouri University of Science & Technology (Rolla, MO) "
	assert v1[44] == "Morgan State University (Baltimore, MD) "
	assert v1[45] == "New Jersey Institute of Technology (Newark, NJ) "
	assert v1[46] == "New Mexico State University (Las Cruces, NM) "
	assert v1[47] == "North Carolina A & T State University (Greensboro, NC) "
	assert v1[48] == "North Carolina State Univ. at Raleigh (Raleigh, NC) "
	assert v1[49] == "North Dakota State University (ND)"
	assert v1[50] == "Northern Arizona University (Flagstaff, AZ) "
	assert v1[51] == "Northern Illinois University (DeKalb, IL) "
	assert v1[52] == "Oakland University (Rochester, MI) "
	assert v1[53] == "Ohio State University (Columbus, OH) "
	assert v1[54] == "Ohio University (Athens, OH) "
	assert v1[55] == "Oklahoma State University (Stillwater, OK) "
	assert v1[56] == "Old Dominion University (Norfolk, VA) "
	assert v1[57] == "Oregon State University (Corvallis, OR) "
	assert v1[58] == "Pennsylvania State University (University Park, PA) "
	assert v1[59] == "Portland State University (Portland, OR) "
	assert v1[60] == "Purdue University (West Lafayette, IN) "
	assert v1[61] == "Rutgers, The State University (New Brunswick, NJ) "
	assert v1[62] == "South Carolina State University (Orangeburg, SC) "
	assert v1[63] == "South Dakota State University (Brookings, SD) "
	assert v1[64] == "Southern Illinois Univ at Carbondale (Carbondale, IL) "
	assert v1[65] == "SUNY-Albany (Albany, NY) "
	assert v1[66] == "SUNY-Binghamton (Binghamton, NY) "
	assert v1[67] == "SUNY-Buffalo (Buffalo, NY) "
	assert v1[68] == "SUNY-College of Env. Sci.-Forestry (Syracuse, NY) "
	assert v1[69] == "SUNY-Stony Brook (Stony Brook, NY) "
	assert v1[70] == "Temple University (Philadelphia, PA) "
	assert v1[71] == "Tennessee State University (Nashville, TN) "
	assert v1[72] == "Texas A&M Univ.-Commerce (Commerce, TX) "
	assert v1[73] == "Texas A&M Univ.-Kingsville (Kingsville, TX) "
	assert v1[74] == "Texas A&M University (College Station, TX) "
	assert v1[75] == "Texas Tech University (Lubbock, TX) "
	assert v1[76] == "Texas Woman's University (Denton, TX) "
	assert v1[77] == "Univ of California, Berkeley (Berkeley, CA) "
	assert v1[78] == "Univ of California, Davis (Davis, CA) "
	assert v1[79] == "Univ of California, Irvine (Irvine, CA) "
	assert v1[80] == "Univ of California, Los Angeles (Los Angeles, CA) "
	assert v1[81] == "Univ of California, Riverside (Riverside, CA) "
	assert v1[82] == "Univ of California, San Diego (La Jolla, CA) "
	assert v1[83] == "Univ of California, Santa Barbara (Santa Barbara, CA) "
	assert v1[84] == "Univ of California, Santa Cruz (Santa Cruz, CA) "
	assert v1[85] == "Univ of Illinois - Chicago (IL)"
	assert v1[86] == "Univ of Illinois - Urbana-Champaign (Urbana, IL) "
	assert v1[87] == "Univ of North Carolina at Chapel Hill (Chapel Hill, NC) "
	assert v1[88] == "Univ of North Carolina at Charlotte (Charlotte, NC) "
	assert v1[89] == "Univ of North Carolina at Greensboro (Greensboro, NC) "
	assert v1[90] == "Univ. of South Carolina, Columbia (Columbia, SC) "
	assert v1[91] == "Univ. of Texas at Arlington (Arlington, TX) "
	assert v1[92] == "Univ. of Texas at Austin (Austin, TX) "
	assert v1[93] == "Univ. of Texas at Dallas (Richardson, TX) "
	assert v1[94] == "Univ. of Texas at El Paso (El Paso, TX) "
	assert v1[95] == "University of Akron (Akron, OH) "
	assert v1[96] == "University of Alabama (Tuscaloosa, AL) "
	assert v1[97] == "University of Alabama at Birmingham (Birmingham, AL) "
	assert v1[98] == "University of Alabama in Huntsville (Huntsville, AL) "
	assert v1[99] == "University of Alaska, Fairbanks (Fairbanks, AK) "
	assert v1[100] == "University of Arizona (Tucson, AZ) "
	assert v1[101] == "University of Arkansas (Fayetteville, AR) "
	assert v1[102] == "University of Arkansas at Little Rock (Little Rock, AR) "
	assert v1[103] == "University of Central Florida (Orlando, FL) "
	assert v1[104] == "University of Cincinnati (Cincinnati, OH) "
	assert v1[105] == "University of Colorado Foundation (Boulder, CO) "
	assert v1[106] == "University of Connecticut Foundation (Storrs, CT) "
	assert v1[107] == "University of Delaware (Newark, DE) "
	assert v1[108] == "University of Florida (Gainesville, FL) "
	assert v1[109] == "University of Georgia (Athens, GA) "
	assert v1[110] == "University of Hawaii Foundation (Honolulu, HI) "
	assert v1[111] == "University of Houston (Houston, TX) "
	assert v1[112] == "University of Idaho (Moscow, ID) "
	assert v1[113] == "University of Iowa (Iowa City, IA) "
	assert v1[114] == "University of Kansas (Lawrence, KS) "
	assert v1[115] == "University of Kentucky (Lexington, KY) "
	assert v1[116] == "University of Louisiana, Lafayette (Lafayette, LA) "
	assert v1[117] == "University of Louisville (Louisville, KY) "
	assert v1[118] == "University of Maine at Orono (Orono, ME) "
	assert v1[119] == "University of Maryland College Park (College Park, MD) "
	assert v1[120] == "University of Maryland-Balt. County (Adelphi, MD) "
	assert v1[121] == "University of Massachusetts, Amherst (Amherst, MA) "
	assert v1[122] == "University of Massachusetts, Boston (Boston, MA) "
	assert v1[123] == "University of Massachusetts, Lowell (Lowell, MA) "
	assert v1[124] == "University of Memphis (Memphis, TN) "
	assert v1[125] == "University of Michigan (Ann Arbor, MI) "
	assert v1[126] == "University of Minnesota (Minneapolis, MN) "
	assert v1[127] == "University of Mississippi (University, MS) "
	assert v1[128] == "University of Missouri-Columbia (Columbia, MO) "
	assert v1[129] == "University of Missouri-Kansas City (Kansas City, MO) "
	assert v1[130] == "University of Missouri-St. Louis (St. Louis, MO) "
	assert v1[131] == "University of Montana (Missoula, MT) "
	assert v1[132] == "University of Nebraska (Lincoln, NE) "
	assert v1[133] == "University of Nevada, Las Vegas (Las Vegas, NV) "
	assert v1[134] == "University of Nevada, Reno (Reno, NV) "
	assert v1[135] == "University of New Hampshire (Durham, NH) "
	assert v1[136] == "University of New Mexico (Albuquerque, NM) "
	assert v1[137] == "University of New Orleans (New Orleans, LA) "
	assert v1[138] == "University of North Dakota (Grand Forks, ND) "
	assert v1[139] == "University of North Texas (Denton, TX) "
	assert v1[140] == "University of Northern Colorado (Greeley, CO) "
	assert v1[141] == "University of Oklahoma (Norman, OK) "
	assert v1[142] == "University of Oregon (Eugene, OR) "
	assert v1[143] == "University of Pittsburgh (Pittsburgh, PA) "
	assert v1[144] == "University of Rhode Island (Kingston, RI) "
	assert v1[145] == "University of South Dakota (Vermillion, SD) "
	assert v1[146] == "University of South Florida (Tampa, FL) "
	assert v1[147] == "University of Southern Mississippi (Hattiesburg, MS) "
	assert v1[148] == "University of Tennessee (Knoxville, TN) "
	assert v1[149] == "University of Toledo (Toledo, OH) "
	assert v1[150] == "University of Utah (Salt Lake City, UT) "
	assert v1[151] == "University of Vermont (Burlington, VT) "
	assert v1[152] == "University of Virginia (Charlottesville, VA) "
	assert v1[153] == "University of Washington (Seattle, WA) "
	assert v1[154] == "University of West Florida (Pensacola, FL) "
	assert v1[155] == "University of Wisconsin-Madison (Madison, WI) "
	assert v1[156] == "University of Wisconsin-Milwaukee (Milwaukee, WI) "
	assert v1[157] == "University of Wyoming Foundation (Laramie, WY) "
	assert v1[158] == "Utah State University (Logan, UT) "
	assert v1[159] == "Virginia Commonwealth University (Richmond, VA) "
	assert v1[160] == "Virginia Polytechnic Inst & St Univ (Blacksburg, VA) "
	assert v1[161] == "Washington State University (Pullman, WA) "
	assert v1[162] == "Wayne State University (Detroit, MI) "
	assert v1[163] == "West Virginia University Foundation, Inc. (Morgantown, WV) "
	assert v1[164] == "Western Michigan University (Kalamazoo, MI) "
	assert v1[165] == "Wichita State University (Wichita, KS) "
	assert v1[166] == "Wright State University (Dayton, OH) "

	assert v2[3] == "Ops/Academic"
	assert v3[3] == "Ops/Fac-Staff"
	assert v4[3] == "Ops/Research"
	assert v5[3] == "Ops/Pub Serv"
	assert v6[3] == "Ops/Libraries"
	assert v7[3] == "Ops/Physical"
	assert v8[3] == "Ops/Student"
	assert v9[3] == "Ops/Athletics"
	assert v10[3] == "Ops/Other Purposes"
	assert v11[3] == "Operations"
	assert v12[3] == ""
	assert v13[3] == "Alumni Participation"
	assert v14[3] == "for Current"
	assert v15[3] == "of Alumni Solicited"
	assert v16[3] == "as a Percentage"
	assert v17[3] == "Record"
	assert v18[3] == ""
	assert v19[3] == "Giving ($,"
	assert v20[3] == "Ops: Donors"
	assert v21[3] == "Ops: Total"
	assert v22[3] == "Purp: Donors"
	assert v23[3] == "Purp (PV):"
	assert v24[3] == "Donors (#)"
	assert v25[3] == "(PV): Total"
	assert v26[3] == "Total"
	assert v27[3] == "Per Student"
	assert v28[3] == "Total"
	assert v29[3] == "Curr Ops/Athletics"
	assert v30[3] == "Current Operations"
	assert v31[3] == "Curr Ops/Athletics"
	assert v32[3] == "Current Operations"
	assert v33[3] == "Ops/Athletics"
	assert v34[3] == "Operations"
	assert v35[3] == "(2004 and after)"
	assert v36[3] == "(2003 and earlier)"
	assert v37[3] == "Grandp) - Curr"
	assert v38[3] == "Grandp) - Curr"
	assert v39[3] == "Grandp) - Curr"

	drop v37-v39
	local totalobs = _N
	drop in 167/`totalobs'
	drop in 1/5
	gen int fiscalyear = `yearnum'

	forvalues varnum = 2(1)36 {
		replace v`varnum' = "" if v`varnum' == "--"
		destring v`varnum', replace ignore("$ ,") percent
	}
	foreach varnum of numlist 2/11 19 21 23 25/36 {
		label var v`varnum' "Dollars, FY"
	}
	foreach varnum of numlist 12/16 {
		label var v`varnum' "Share, FY"
	}
	foreach varnum of numlist 17/18 20 22 24 {
		label var v`varnum' "Number, FY"
	}

	rename v1 school
	rename v2 alumni_ops_academic
	rename v3 alumni_ops_faculty
	rename v4 alumni_ops_research
	rename v5 alumni_ops_pub_serv
	rename v6 alumni_ops_libraries
	rename v7 alumni_ops_physical_plant
	rename v8 alumni_ops_student_aid
	rename v9 alumni_ops_athletics
	rename v10 alumni_ops_other
	rename v11 alumni_ops_total
	rename v12 alumni_donation_rate
	rename v13 alumni_ugrad_donation_rate
	rename v14 alumni_ops_donation_rate
	rename v15 alumni_solicit_rate
	rename v16 alumni_giving_as_share_of_total
	rename v17 alumni_of_record
	rename v18 alumni_donors
	rename v19 alumni_total_giving
	rename v20 ops_athletics_donors
	rename v21 ops_athletics_total_ath
	rename v22 capital_athletics_donors
	rename v23 capital_athletics_total
	rename v24 athletics_donors
	rename v25 athletics_total
	rename v26 corporations_total_giving
	rename v27 expenditures_per_student
	rename v28 foundations_total_giving
	rename v29 foundations_ops_athletics
	rename v30 foundations_ops_total
	rename v31 corporations_ops_athletics
	rename v32 corporations_ops_total
	rename v33 ops_athletics_total_grand
	rename v34 ops_total
	rename v35 total_giving_2004_onwards
	rename v36 total_giving_pre_2004
	label var ops_athletics_total_ath "Dollars, FY, from Athletics Giving Details"
	label var ops_athletics_total_grand "Dollars, FY, from Grand Totals by Purpose Details"
	
	save fy`yearnum', replace
	clear
}

use fy1999
!rm fy1999.dta
forvalues yearnum = 2000(1)2009 {
	append using fy`yearnum'
	!rm fy`yearnum'.dta
}

save `public'
clear
cd ../..

*** PRIVATE ***

cd "Electronic/Private"

forvalues yearnum = 1999(1)2009 {
	insheet using FY`yearnum'.txt, tab

	assert v1[6] == "Adelphi University (Garden City, NY) "
	assert v1[7] == "American University (Washington, DC) "
	assert v1[8] == "Andrews University (Berrien Springs, MI) "
	assert v1[9] == "Azusa Pacific University (Azusa, CA) "
	assert v1[10] == "Barry University (Miami Shores, FL) "
	assert v1[11] == "Baylor University (Waco, TX) "
	assert v1[12] == "Biola University (La Mirada, CA) "
	assert v1[13] == "Boston College (Chestnut Hill, MA) "
	assert v1[14] == "Boston University (Boston, MA) "
	assert v1[15] == "Brandeis University (Waltham, MA) "
	assert v1[16] == "Brown University (Providence, RI) "
	assert v1[17] == "California Inst. of Integral Studies (San Francisco, CA) "
	assert v1[18] == "California Institute of Technology (Pasadena, CA) "
	assert v1[19] == "Carnegie-Mellon University (Pittsburgh, PA) "
	assert v1[20] == "Case Western Reserve University (Cleveland, OH) "
	assert v1[21] == "Catholic University of America (Washington, DC) "
	assert v1[22] == "Claremont Graduate University (Claremont, CA) "
	assert v1[23] == "Clark Atlanta University (Atlanta, GA) "
	assert v1[24] == "Clark University (Worcester, MA) "
	assert v1[25] == "Clarkson University (Potsdam, NY) "
	assert v1[26] == "Columbia University (New York, NY) "
	assert v1[27] == "Cornell University (Ithaca, NY) "
	assert v1[28] == "Dartmouth College (Hanover, NH) "
	assert v1[29] == "De Paul University (Chicago, IL) "
	assert v1[30] == "Drexel University (Philadelphia, PA) "
	assert v1[31] == "Duke Univ-Divinity School (Durham, NC) "
	assert v1[32] == "Duke University (Durham, NC) "
	assert v1[33] == "Duquesne University (Pittsburgh, PA) "
	assert v1[34] == "Emory University (Atlanta, GA) "
	assert v1[35] == "Florida Institute of Technology (Melbourne, FL) "
	assert v1[36] == "Fordham University (Bronx, NY) "
	assert v1[37] == "George Fox University (Newberg, OR) "
	assert v1[38] == "Georgetown University (Washington, DC) "
	assert v1[39] == "Golden Gate University (San Francisco, CA) "
	assert v1[40] == "Harvard University (Cambridge, MA) "
	assert v1[41] == "Hofstra University (Hempstead, NY) "
	assert v1[42] == "Howard University (Washington, DC) "
	assert v1[43] == "Illinois Institute of Technology (Chicago, IL) "
	assert v1[44] == "Immaculata University (Immaculata, PA) "
	assert v1[45] == "Inter American Univ of Puerto Rico (San Juan, PR) "
	assert v1[46] == "Johns Hopkins University (Baltimore, MD) "
	assert v1[47] == "Lehigh University (Bethlehem, PA) "
	assert v1[48] == "Loyola University of Chicago (Chicago, IL) "
	assert v1[49] == "Marquette University (Milwaukee, WI) "
	assert v1[50] == "Massachusetts Institute of Technology (Cambridge, MA) "
	assert v1[51] == "New School University (New York, NY) "
	assert v1[52] == "New York University (New York, NY) "
	assert v1[53] == "Northeastern University (Boston, MA) "
	assert v1[54] == "Northwestern University (Evanston, IL) "
	assert v1[55] == "Nova Southeastern University (Fort Lauderdale, FL) "
	assert v1[56] == "Oral Roberts University Sch of Theol (Tulsa, OK) "
	assert v1[57] == "Pace University (New York, NY) "
	assert v1[58] == "Pacific University (Forest Grove, OR) "
	assert v1[59] == "Pepperdine University (Malibu, CA) "
	assert v1[60] == "Polytechnic Institute of New York University (Brooklyn, NY) "
	assert v1[61] == "Princeton University (Princeton, NJ) "
	assert v1[62] == "Regent University (Virginia Beach, VA) "
	assert v1[63] == "Rensselaer Polytechnic Institute (Troy, NY) "
	assert v1[64] == "Saint John's University (Jamaica, NY) "
	assert v1[65] == "Saint Louis University (St. Louis, MO) "
	assert v1[66] == "Saint Mary's University of Minnesota (Winona, MN) "
	assert v1[67] == "Samford University (Birmingham, AL) "
	assert v1[68] == "Seton Hall School of Religion (South Orange)"
	assert v1[69] == "Seton Hall University (South Orange, NJ) "
	assert v1[70] == "Southern Methodist University (Dallas, TX) "
	assert v1[71] == "Spalding University (Louisville, KY) "
	assert v1[72] == "Stanford University (Stanford, CA) "
	assert v1[73] == "Stevens Institute of Technology (Hoboken, NJ) "
	assert v1[74] == "Syracuse University (Syracuse, NY) "
	assert v1[75] == "Teachers College, Columbia University (New York, NY) "
	assert v1[76] == "Texas Christian University (Fort Worth, TX) "
	assert v1[77] == "The George Washington University (Washington, DC) "
	assert v1[78] == "Trevecca Nazarene University (Nashville, TN) "
	assert v1[79] == "Trinity International University (Deerfield, IL) "
	assert v1[80] == "Tufts University (Medford, MA) "
	assert v1[81] == "Tulane University (New Orleans, LA) "
	assert v1[82] == "Union Institute & University (Cincinnati, OH) "
	assert v1[83] == "University of Bridgeport (Bridgeport, CT) "
	assert v1[84] == "University of Chicago (Chicago, IL) "
	assert v1[85] == "University of Dayton (Dayton, OH) "
	assert v1[86] == "University of Denver (Denver, CO) "
	assert v1[87] == "University of Hartford (West Hartford, CT) "
	assert v1[88] == "University of La Verne (La Verne, CA) "
	assert v1[89] == "University of Miami (Coral Gables, FL) "
	assert v1[90] == "University of Notre Dame (Notre Dame, IN) "
	assert v1[91] == "University of Pennsylvania (Philadelphia, PA) "
	assert v1[92] == "University of Rochester (Rochester, NY) "
	assert v1[93] == "University of Saint Thomas (Saint Paul, MN) "
	assert v1[94] == "University of San Diego (San Diego, CA) "
	assert v1[95] == "University of San Francisco (San Francisco, CA) "
	assert v1[96] == "University of Southern California (Los Angeles, CA) "
	assert v1[97] == "University of the Pacific (Stockton, CA) "
	assert v1[98] == "University of Tulsa (Tulsa, OK) "
	assert v1[99] == "Vanderbilt University (Nashville, TN) "
	assert v1[100] == "Wake Forest University (Winston-Salem, NC) "
	assert v1[101] == "Washington University (St. Louis, MO) "
	assert v1[102] == "Widener University (Chester, PA) "
	assert v1[103] == "William Marsh Rice University (Houston, TX) "
	assert v1[104] == "Wilmington College (New Castle, DE) "
	assert v1[105] == "Yale University (New Haven, CT) "
	assert v1[106] == "Yeshiva University (New York, NY) "

	assert v2[3] == "Ops/Academic"
	assert v3[3] == "Ops/Fac-Staff"
	assert v4[3] == "Ops/Research"
	assert v5[3] == "Ops/Pub Serv"
	assert v6[3] == "Ops/Libraries"
	assert v7[3] == "Ops/Physical"
	assert v8[3] == "Ops/Student"
	assert v9[3] == "Ops/Athletics"
	assert v10[3] == "Ops/Other Purposes"
	assert v11[3] == "Operations"
	assert v12[3] == ""
	assert v13[3] == "Alumni Participation"
	assert v14[3] == "for Current"
	assert v15[3] == "of Alumni Solicited"
	assert v16[3] == "as a Percentage"
	assert v17[3] == "Record"
	assert v18[3] == ""
	assert v19[3] == "Giving ($,"
	assert v20[3] == "Ops: Donors"
	assert v21[3] == "Ops: Total"
	assert v22[3] == "Purp: Donors"
	assert v23[3] == "Purp (PV):"
	assert v24[3] == "Donors (#)"
	assert v25[3] == "(PV): Total"
	assert v26[3] == "Total"
	assert v27[3] == "Per Student"
	assert v28[3] == "Total"
	assert v29[3] == "Curr Ops/Athletics"
	assert v30[3] == "Current Operations"
	assert v31[3] == "Curr Ops/Athletics"
	assert v32[3] == "Current Operations"
	assert v33[3] == "Ops/Athletics"
	assert v34[3] == "Operations"
	assert v35[3] == "(2004 and after)"
	assert v36[3] == "(2003 and earlier)"
	assert v37[3] == "Grandp) - Curr"
	assert v38[3] == "Grandp) - Curr"
	assert v39[3] == "Grandp) - Curr"

	drop v37-v39
	local totalobs = _N
	drop in 107/`totalobs'
	drop in 1/5
	gen int fiscalyear = `yearnum'

	forvalues varnum = 2(1)36 {
		replace v`varnum' = "" if v`varnum' == "--"
		destring v`varnum', replace ignore("$ ,") percent
	}
	foreach varnum of numlist 2/11 19 21 23 25/36 {
		label var v`varnum' "Dollars, FY"
	}
	foreach varnum of numlist 12/16 {
		label var v`varnum' "Share, FY"
	}
	foreach varnum of numlist 17/18 20 22 24 {
		label var v`varnum' "Number, FY"
	}

	rename v1 school
	rename v2 alumni_ops_academic
	rename v3 alumni_ops_faculty
	rename v4 alumni_ops_research
	rename v5 alumni_ops_pub_serv
	rename v6 alumni_ops_libraries
	rename v7 alumni_ops_physical_plant
	rename v8 alumni_ops_student_aid
	rename v9 alumni_ops_athletics
	rename v10 alumni_ops_other
	rename v11 alumni_ops_total
	rename v12 alumni_donation_rate
	rename v13 alumni_ugrad_donation_rate
	rename v14 alumni_ops_donation_rate
	rename v15 alumni_solicit_rate
	rename v16 alumni_giving_as_share_of_total
	rename v17 alumni_of_record
	rename v18 alumni_donors
	rename v19 alumni_total_giving
	rename v20 ops_athletics_donors
	rename v21 ops_athletics_total_ath
	rename v22 capital_athletics_donors
	rename v23 capital_athletics_total
	rename v24 athletics_donors
	rename v25 athletics_total
	rename v26 corporations_total
	rename v27 expenditures_per_student
	rename v28 foundations_total
	rename v29 foundations_ops_athletics
	rename v30 foundations_ops_total
	rename v31 corporations_ops_athletics
	rename v32 corporations_ops_total
	rename v33 ops_athletics_total_grand
	rename v34 ops_total
	rename v35 total_giving_2004_onwards
	rename v36 total_giving_pre_2004
	label var ops_athletics_total_ath "Dollars, FY, from Athletics Giving Details"
	label var ops_athletics_total_grand "Dollars, FY, from Grand Totals by Purpose Details"

	save fy`yearnum', replace
	clear
}

use fy1999
!rm fy1999.dta
forvalues yearnum = 2000(1)2009 {
	append using fy`yearnum'
	!rm fy`yearnum'.dta
}

save `private'
clear
cd ../..

*** PUBLIC MASTERS ***

cd "Electronic/Public Masters"

forvalues yearnum = 1999(1)2009 {
	insheet using FY`yearnum'.txt, tab

	assert v1[6] == "Adams State College (Alamosa, CO) "
	assert v1[7] == "Alabama Agricultural and Mechanical University (Normal, AL) "
	assert v1[8] == "Alabama State University (Montgomery, AL) "
	assert v1[9] == "Albany State University (Albany, GA) "
	assert v1[10] == "Alcorn State University (Lorman, MS) "
	assert v1[11] == "Angelo State University (San Angelo, TX) "
	assert v1[12] == "Appalachian State University (Boone, NC) "
	assert v1[13] == "Arkansas State University (State University, AR) "
	assert v1[14] == "Arkansas Tech University (Russellville, AR) "
	assert v1[15] == "Armstrong Atlantic State University (Savannah, GA) "
	assert v1[16] == "Auburn University at Montgomery (Montgomery, AL) "
	assert v1[17] == "Augusta State University (Augusta, GA) "
	assert v1[18] == "Bloomsburg Univ. of Pennsylvania (Bloomsburg, PA) "
	assert v1[19] == "Boise State University (Boise, ID) "
	assert v1[20] == "Bowie State University (Bowie, MD) "
	assert v1[21] == "Bridgewater State College (Bridgewater, MA) "
	assert v1[22] == "California Polytechnic State University (San Luis Obispo, CA) "
	assert v1[23] == "California State Univ., Bakersfield (Bakersfield, CA) "
	assert v1[24] == "California State Univ., Chico (Chico, CA) "
	assert v1[25] == "California State Univ., Dominguez Hills (Carson, CA) "
	assert v1[26] == "California State Univ., East Bay (Hayward, CA) "
	assert v1[27] == "California State Univ., Fresno (Fresno, CA) "
	assert v1[28] == "California State Univ., Fullerton (Fullerton, CA) "
	assert v1[29] == "California State Univ., Humboldt (Arcata, CA) "
	assert v1[30] == "California State Univ., Long Beach (Long Beach, CA) "
	assert v1[31] == "California State Univ., Los Angeles (Los Angeles, CA) "
	assert v1[32] == "California State Univ., Northridge (Northridge, CA) "
	assert v1[33] == "California State Univ., Pomona (Pomona, CA) "
	assert v1[34] == "California State Univ., Sacramento (Sacramento, CA) "
	assert v1[35] == "California State Univ., San Bernardino (San Bernardino, CA) "
	assert v1[36] == "California State Univ., San Marcos (San Marcos, CA) "
	assert v1[37] == "California State Univ., Sonoma (Rohnert Park, CA) "
	assert v1[38] == "California State Univ., Stanislaus (Turlock, CA) "
	assert v1[39] == "California Univ. of Pennsylvania (California, PA) "
	assert v1[40] == "Cameron University (Lawton, OK) "
	assert v1[41] == "Castleton State College (Castleton, VT) "
	assert v1[42] == "Central Connecticut State University (New Britain, CT) "
	assert v1[43] == "Central Washington University (Ellensburg, WA) "
	assert v1[44] == "Cheyney Univ. of Pennsylvania (Cheyney, PA) "
	assert v1[45] == "Chicago State University (Chicago, IL) "
	assert v1[46] == "Citadel Military College of South Carolina (Charleston, SC) "
	assert v1[47] == "Clarion Univ. of Pennsylvania (Clarion, PA) "
	assert v1[48] == "College of Charleston (Charleston, SC) "
	assert v1[49] == "College of New Jersey (Ewing, NJ) "
	assert v1[50] == "Columbus State University (Columbus, GA) "
	assert v1[51] == "Coppin State University (Baltimore)"
	assert v1[52] == "Cornerstone University (Grand Rapids, MI) "
	assert v1[53] == "CUNY-Bernard M. Baruch College (New York, NY) "
	assert v1[54] == "CUNY-Brooklyn College (Brooklyn, NY) "
	assert v1[55] == "CUNY-City College of NY (New York, NY) "
	assert v1[56] == "CUNY-College of Staten Island (Staten Island, NY) "
	assert v1[57] == "CUNY-Herbert H. Lehman College (Bronx, NY) "
	assert v1[58] == "CUNY-Hunter College (New York, NY) "
	assert v1[59] == "CUNY-John Jay College (New York, NY) "
	assert v1[60] == "CUNY-Queens College (Flushing, NY) "
	assert v1[61] == "Delaware State University (Dover, DE) "
	assert v1[62] == "Delta State University (Cleveland, MS) "
	assert v1[63] == "East Central University (Ada, OK) "
	assert v1[64] == "East Stroudsburg Univ. of Pennsylvania (East Stroudsburg, PA) "
	assert v1[65] == "Eastern Connecticut State University (Willimantic, CT) "
	assert v1[66] == "Eastern Illinois University (Charleston, IL) "
	assert v1[67] == "Eastern Kentucky University (Richmond, KY) "
	assert v1[68] == "Eastern Michigan University (Ypsilanti, MI) "
	assert v1[69] == "Eastern New Mexico University (Portales, NM) "
	assert v1[70] == "Eastern Oregon State College (La Grande, OR) "
	assert v1[71] == "Eastern Washington University (Cheney, WA) "
	assert v1[72] == "Edinboro Univ. of Pennsylvania (Edinboro, PA) "
	assert v1[73] == "Emporia State University (Emporia, KS) "
	assert v1[74] == "Evergreen State College (Olympia, WA) "
	assert v1[75] == "Fayetteville State University (Fayetteville, NC) "
	assert v1[76] == "Ferris State University (Big Rapids, MI) "
	assert v1[77] == "Fitchburg State College (Fitchburg, MA) "
	assert v1[78] == "Florida Gulf Coast University (Ft. Myers, FL) "
	assert v1[79] == "Fort Hays State University (Hays, KS) "
	assert v1[80] == "Fort Valley State University (Fort Valley, GA) "
	assert v1[81] == "Framingham State College (Framingham, MA) "
	assert v1[82] == "Francis Marion College (Florence, SC) "
	assert v1[83] == "Frostburg State University (Frostburg, MD) "
	assert v1[84] == "Georgia College & State University (Milledgeville, GA) "
	assert v1[85] == "Georgia Southwestern State University (Americus, GA) "
	assert v1[86] == "Governors State University (Park Forest South, IL) "
	assert v1[87] == "Grambling State University (Grambling, LA) "
	assert v1[88] == "Grand Valley State University (Allendale, MI) "
	assert v1[89] == "Henderson State University (Arkadelphia, AR) "
	assert v1[90] == "Jacksonville State University (Jacksonville, AL) "
	assert v1[91] == "James Madison University (Harrisonburg, VA) "
	assert v1[92] == "Jersey City State College (Jersey City, NJ) "
	assert v1[93] == "Johnson State College (Johnson, VT) "
	assert v1[94] == "Kean University (Union, NJ) "
	assert v1[95] == "Keene State College (Keene, NH) "
	assert v1[96] == "Kennesaw State University (Marietta, GA) "
	assert v1[97] == "Kutztown Univ. of Pennsylvania (Kutztown, PA) "
	assert v1[98] == "La St Univ, Shreveport (LA) "
	assert v1[99] == "Lamar University (Beaumont, TX) "
	assert v1[100] == "Lincoln University (Lincoln University, PA) "
	assert v1[101] == "Lincoln University (Jefferson City, MO) "
	assert v1[102] == "Lock Haven Univ. of Pennsylvania (Lock Haven, PA) "
	assert v1[103] == "Longwood University (Farmville, VA) "
	assert v1[104] == "Mansfield Univ. of Pennsylvania (Mansfield, PA) "
	assert v1[105] == "Marshall University (Huntington, WV) "
	assert v1[106] == "McNeese State University (Lake Charles, LA) "
	assert v1[107] == "Middle Tennessee State University (Murfreesboro, TN) "
	assert v1[108] == "Midwestern State University (Wichita Falls, TX) "
	assert v1[109] == "Millersville Univ. of Pennsylvania (Millersville, PA) "
	assert v1[110] == "Minot State University (Minot, ND) "
	assert v1[111] == "Mississippi University for Women (Columbus, MS) "
	assert v1[112] == "Mississippi Valley State University (Itta Bena, MS) "
	assert v1[113] == "Missouri State University (Springfield, MO) "
	assert v1[114] == "MNSCU - Bemidji State University (Bemidji, MN) "
	assert v1[115] == "MNSCU - Metropolitan State University (St. Paul, MN) "
	assert v1[116] == "MNSCU - Minnesota State University, Mankato (Mankato, MN) "
	assert v1[117] == "MNSCU - Minnesota State University, Moorhead (Moorhead, MN) "
	assert v1[118] == "MNSCU - Southwest Minnesota State University (Marshall, MN) "
	assert v1[119] == "MNSCU - St. Cloud State University (Saint Cloud, MN) "
	assert v1[120] == "MNSCU - Winona State University (Winona, MN) "
	assert v1[121] == "Montana State Univ.-Billings (Billings, MT) "
	assert v1[122] == "Montclair State University (Upper Montclair, NJ) "
	assert v1[123] == "Morehead State University (Morehead, KY) "
	assert v1[124] == "Murray State University (Murray, KY) "
	assert v1[125] == "New Mexico Highlands University (Las Vegas, NM) "
	assert v1[126] == "New Mexico Inst. of Mining and Tech (Socorro, NM) "
	assert v1[127] == "Nicholls State University (Thibodaux, LA) "
	assert v1[128] == "Norfolk State University (Norfolk, VA) "
	assert v1[129] == "North Carolina Central University (Durham, NC) "
	assert v1[130] == "North Georgia College & State Univ. (Dahlonega, GA) "
	assert v1[131] == "Northeastern Illinois University (Chicago, IL) "
	assert v1[132] == "Northeastern State University (Tahlequah, OK) "
	assert v1[133] == "Northern Kentucky University (Highland Heights, KY) "
	assert v1[134] == "Northern Michigan University (Marquette, MI) "
	assert v1[135] == "Northwest Missouri State University (Maryville, MO) "
	assert v1[136] == "Northwestern State University (Natchitoches, LA) "
	assert v1[137] == "Pittsburg State University (Pittsburg, KS) "
	assert v1[138] == "Plymouth State University (Plymouth, NH) "
	assert v1[139] == "Prairie View A&M University (Prairie View, TX) "
	assert v1[140] == "Purdue University-Calumet (IN)"
	assert v1[141] == "Radford University (Radford, VA) "
	assert v1[142] == "Ramapo College of New Jersey (Mahwah, NJ) "
	assert v1[143] == "Rhode Island College (Providence, RI) "
	assert v1[144] == "Richard Stockton College of New Jersey (Pomona, NJ) "
	assert v1[145] == "Rowan University (Glassboro, NJ) "
	assert v1[146] == "Saginaw Valley State University (University Center, MI) "
	assert v1[147] == "Salem State College (Salem, MA) "
	assert v1[148] == "Salisbury University (Salisbury, MD) "
	assert v1[149] == "Sam Houston State University (Huntsville, TX) "
	assert v1[150] == "San Francisco State University (San Francisco, CA) "
	assert v1[151] == "San Jose State University (San Jose, CA) "
	assert v1[152] == "Savannah State University (Savannah, GA) "
	assert v1[153] == "Shippensburg Univ. of Pennsylvania (Shippensburg, PA) "
	assert v1[154] == "Slippery Rock Unv. of Pennsylvania (Slippery Rock, PA) "
	assert v1[155] == "Southeast Missouri State University (Cape Girardeau, MO) "
	assert v1[156] == "Southeastern Louisiana University (Hammond, LA) "
	assert v1[157] == "Southeastern Oklahoma State University (Durant, OK) "
	assert v1[158] == "Southern Connecticut State University (New Haven, CT) "
	assert v1[159] == "Southern Illinois Univ, Edwardsville (Edwardsville, IL) "
	assert v1[160] == "Southern New Hampshire University (Manchester, NH) "
	assert v1[161] == "Southern Oregon University (Ashland, OR) "
	assert v1[162] == "Southern Polytechnic State University (Marietta, GA) "
	assert v1[163] == "Southern University A. & M. Col. Fnd. (Baton Rouge, LA) "
	assert v1[164] == "Southern University and A&M College (Baton Rouge, LA) "
	assert v1[165] == "Southern University at New Orleans (New Orleans, LA) "
	assert v1[166] == "Southern Utah University (Cedar City, UT) "
	assert v1[167] == "Southwestern Oklahoma State University (Weatherford, OK) "
	assert v1[168] == "Stephen F. Austin State University (Nacogdoches, TX) "
	assert v1[169] == "Sul Ross State University (Alpine, TX) "
	assert v1[170] == "SUNY-College at Brockport (Brockport, NY) "
	assert v1[171] == "SUNY-College at Buffalo (Buffalo, NY) "
	assert v1[172] == "SUNY-Cortland (Cortland, NY) "
	assert v1[173] == "SUNY-Empire State College (Saratoga Springs, NY) "
	assert v1[174] == "SUNY-Fredonia (Fredonia, NY) "
	assert v1[175] == "SUNY-Geneseo (Geneseo, NY) "
	assert v1[176] == "SUNY-Inst of Tech at Utica/Rome (Utica, NY) "
	assert v1[177] == "SUNY-Maritime College (Bronx, NY) "
	assert v1[178] == "SUNY-Oneonta (Oneonta, NY) "
	assert v1[179] == "SUNY-Oswego (Oswego, NY) "
	assert v1[180] == "SUNY-Plattsburgh University College (Plattsburgh, NY) "
	assert v1[181] == "SUNY-Potsdam College (Potsdam, NY) "
	assert v1[182] == "SUNY-The College at New Paltz (New Paltz, NY) "
	assert v1[183] == "Tarleton State University (Stephenvile, TX) "
	assert v1[184] == "Tennessee Technological University (Cookeville, TN) "
	assert v1[185] == "Texas A&M International University (Laredo, TX) "
	assert v1[186] == "Texas A&M Univ.-Corpus Christi (Corpus Christi, TX) "
	assert v1[187] == "Texas A&M Univ.-Texarkana (Texarkana, TX) "
	assert v1[188] == "Texas Southern University (Houston, TX) "
	assert v1[189] == "Texas State University-San Marcos (San Marcos, TX) "
	assert v1[190] == "Towson University (Towson, MD) "
	assert v1[191] == "Troy State University System (Troy, AL) "
	assert v1[192] == "Truman State University (Kirksville, MO) "
	assert v1[193] == "Univ of North Carolina at Pembroke (Pembroke, NC) "
	assert v1[194] == "Univ of North Carolina at Wilmington (Wilmington, NC) "
	assert v1[195] == "Univ. of Tennessee-Chattanooga (Chattanooga, TN) "
	assert v1[196] == "Univ. of Tennessee-Martin (Martin, TN) "
	assert v1[197] == "Univ. of Texas - Permian Basin (Odessa, TX) "
	assert v1[198] == "Univ. of Texas at Brownsville (Brownsville, TX) "
	assert v1[199] == "Univ. of Texas at San Antonio (San Antonio, TX) "
	assert v1[200] == "Univ. of Texas at Tyler (Tyler, TX) "
	assert v1[201] == "Univ. of Texas-Pan American (Edinburg, TX) "
	assert v1[202] == "University of Arkansas at Monticello (Monticello, AR) "
	assert v1[203] == "University of Baltimore (Baltimore, MD) "
	assert v1[204] == "University of Central (Edmond, OK) "
	assert v1[205] == "University of Central Arkansas (Conway, AR) "
	assert v1[206] == "University of Central Missouri (Warrensburg, MO) "
	assert v1[207] == "University of Guam (GU)"
	assert v1[208] == "University of Louisiana, Monroe (Monroe, LA) "
	assert v1[209] == "University of Mary Washington (Fredericksburg, VA) "
	assert v1[210] == "University of Maryland-Eastern Shore (Adephi, MD) "
	assert v1[211] == "University of Maryland-Univ. College (Adelphi, MD) "
	assert v1[212] == "University of Massachusetts, Dartmouth (North Dartmouth, MA) "
	assert v1[213] == "University of Montevallo (Montevallo, AL) "
	assert v1[214] == "University of Nebraska (Omaha, NE) "
	assert v1[215] == "University of Nebraska at Kearney (Kearney, NE) "
	assert v1[216] == "University of North Alabama (Florence, AL) "
	assert v1[217] == "University of North Florida (Jacksonville, FL) "
	assert v1[218] == "University of Northern Iowa (Cedar Falls, IA) "
	assert v1[219] == "University of South Alabama (Mobile, AL) "
	assert v1[220] == "University of Southern Indiana (Evansville, IN) "
	assert v1[221] == "University of Southern Maine (Portland, ME) "
	assert v1[222] == "University of the District of Columbia (Washington, DC) "
	assert v1[223] == "University of West Alabama (Livingston, AL) "
	assert v1[224] == "University of West Georgia Foundation, Inc. (Carrollton, GA) "
	assert v1[225] == "University of Wisconsin Oshkosh (Oshkosh, WI) "
	assert v1[226] == "University of Wisconsin-Eau Claire (Eau Claire, WI) "
	assert v1[227] == "University of Wisconsin-La Crosse (La Crosse, WI) "
	assert v1[228] == "University of Wisconsin-Platteville (Platteville, WI) "
	assert v1[229] == "University of Wisconsin-River Falls (River Falls, WI) "
	assert v1[230] == "University of Wisconsin-Stevens Point (Stevens Point, WI) "
	assert v1[231] == "University of Wisconsin-Stout (Menomonie, WI) "
	assert v1[232] == "University of Wisconsin-Superior (Superior, WI) "
	assert v1[233] == "University of Wisconsin-Whitewater (Whitewater, WI) "
	assert v1[234] == "Valdosta State University (Valdosta, GA) "
	assert v1[235] == "Virginia State University (Petersburg, VA) "
	assert v1[236] == "Washburn University of Topeka (Topeka, KS) "
	assert v1[237] == "Wayne State College (Wayne, NE) "
	assert v1[238] == "Weber State University (Ogden, UT) "
	assert v1[239] == "West Chester Univ. of Pennsylvania (West Chester, PA) "
	assert v1[240] == "West Texas A&M University (Canyon, TX) "
	assert v1[241] == "Western Carolina University (Cullowhee, NC) "
	assert v1[242] == "Western Connecticut State University (Danbury, CT) "
	assert v1[243] == "Western Illinois University (Macomb, IL) "
	assert v1[244] == "Western Kentucky University (Bowling Green, KY) "
	assert v1[245] == "Western New Mexico University (Silver City, NM) "
	assert v1[246] == "Western Oregon University (Monmouth, OR) "
	assert v1[247] == "Western Washington University (Bellingham, WA) "
	assert v1[248] == "Westfield State College (Westfield, MA) "
	assert v1[249] == "William Paterson University (Wayne, NJ) "
	assert v1[250] == "Winthrop University (Rock Hill, SC) "
	assert v1[251] == "Worcester State College (Worcester, MA) "
	assert v1[252] == "Youngstown State University (Youngstown, OH) "
	
	assert v2[3] == "Ops/Academic"
	assert v3[3] == "Ops/Fac-Staff"
	assert v4[3] == "Ops/Research"
	assert v5[3] == "Ops/Libraries"
	assert v6[3] == "Ops/Physical"
	assert v7[3] == "Ops/Student"
	assert v8[3] == "Ops/Athletics"
	assert v9[3] == "Ops/Other Purposes"
	assert v10[3] == "Operations"
	assert v11[3] == ""
	assert v12[3] == "Alumni Participation"
	assert v13[3] == "for Current"
	assert v14[3] == "of Alumni Solicited"
	assert v15[3] == "as a Percentage"
	assert v16[3] == "Record"
	assert v17[3] == ""
	assert v18[3] == "Giving ($,"
	assert v19[3] == "Ops: Donors"
	assert v20[3] == "Ops: Total"
	assert v21[3] == "Purp: Donors"
	assert v22[3] == "Purp (PV):"
	assert v23[3] == "Donors (#)"
	assert v24[3] == "(PV): Total"
	assert v25[3] == "Total"
	assert v26[3] == "Per Student"
	assert v27[3] == "Total"
	assert v28[3] == "Curr Ops/Athletics"
	assert v29[3] == "Current Operations"
	assert v30[3] == "Curr Ops/Athletics"
	assert v31[3] == "Current Operations"
	assert v32[3] == "Ops/Athletics"
	assert v33[3] == "Operations"
	assert v34[3] == "(2004 and after)"
	assert v35[3] == "(2003 and earlier)"
	assert v36[3] == "Grandp) - Curr"
	assert v37[3] == "Grandp) - Curr"
	assert v38[3] == "Grandp) - Curr"

	drop v36-v38
	local totalobs = _N
	drop in 253/`totalobs'
	drop in 1/5
	gen int fiscalyear = `yearnum'

	forvalues varnum = 2(1)35 {
		replace v`varnum' = "" if v`varnum' == "--"
		destring v`varnum', replace ignore("$ ,") percent
	}
	foreach varnum of numlist 2/10 18 20 22 24/35 {
		label var v`varnum' "Dollars, FY"
	}
	foreach varnum of numlist 11/15 {
		label var v`varnum' "Share, FY"
	}
	foreach varnum of numlist 16/17 19 21 23 {
		label var v`varnum' "Number, FY"
	}

	rename v1 school
	rename v2 alumni_ops_academic
	rename v3 alumni_ops_faculty
	rename v4 alumni_ops_research
	rename v5 alumni_ops_libraries
	rename v6 alumni_ops_physical_plant
	rename v7 alumni_ops_student_aid
	rename v8 alumni_ops_athletics
	rename v9 alumni_ops_other
	rename v10 alumni_ops_total
	rename v11 alumni_donation_rate
	rename v12 alumni_ugrad_donation_rate
	rename v13 alumni_ops_donation_rate
	rename v14 alumni_solicit_rate
	rename v15 alumni_giving_as_share_of_total
	rename v16 alumni_of_record
	rename v17 alumni_donors
	rename v18 alumni_total_giving
	rename v19 ops_athletics_donors
	rename v20 ops_athletics_total_ath
	rename v21 capital_athletics_donors
	rename v22 capital_athletics_total
	rename v23 athletics_donors
	rename v24 athletics_total
	rename v25 corporations_total_giving
	rename v26 expenditures_per_student
	rename v27 foundations_total_giving
	rename v28 foundations_ops_athletics
	rename v29 foundations_ops_total
	rename v30 corporations_ops_athletics
	rename v31 corporations_ops_total
	rename v32 ops_athletics_total_grand
	rename v33 ops_total
	rename v34 total_giving_2004_onwards
	rename v35 total_giving_pre_2004
	label var ops_athletics_total_ath "Dollars, FY, from Athletics Giving Details"
	label var ops_athletics_total_grand "Dollars, FY, from Grand Totals by Purpose Details"
	
	save fy`yearnum', replace
	clear
}

use fy1999
!rm fy1999.dta
forvalues yearnum = 2000(1)2009 {
	append using fy`yearnum'
	!rm fy`yearnum'.dta
}

cd ../..

*** Merge public, private, and private masters ***

cd "Electronic/Public"
append using `public'
cd ..
cd "Private"
append using `private'
cd ..
sort school fiscalyear

label var alumni_of_record "Number, FY, Print Var: Alumni Giving - Alumni of Record"
label var alumni_donors "Number, FY, Print Var: Alumni Giving - Alumni Donors"
label var alumni_total_giving "Dollars, FY, Print Var: Sources of Support - Individuals - Alumni"
label var corporations_total_giving "Dollars, FY, Print Var: Sources of Support - Organizations - Corporations"
label var foundations_total_giving "Dollars, FY, Print Var: Sources of Support - Organizations - Foundations"
label var total_giving_pre_2004 "Dollars, FY, Print Var: Total Support"
label var alumni_solicit_rate "Share, FY, Print Var Equivalent: Alumni Giving - Alumni Solicited"

rename school vseteamname
sort vseteamname fiscalyear

save vse_data_electronic, replace
cd ..

*** Merge hand entered data ***

clear
insheet using "Hand Entered/Merged.csv"
rename school vseteamname
rename year fiscalyear

* Make dollar units consistent across years
assert fiscalyear!=.
sort vseteamname fiscalyear
foreach var of varlist totalsupport-corporationsandbusinesses {
	replace `var' = `var'*1000 if fiscalyear>1994
}

merge vseteamname fiscalyear using "Electronic/vse_data_electronic.dta"
!rm "Electronic/vse_data_electronic.dta"
assert _merge==1 | _merge==2
sort vseteamname fiscalyear
by vseteamname: egen totalobs = count(fiscalyear)
assert totalobs==11 | totalobs==19
assert totalobs==19 if _merge==1
assert _merge==1 if fiscalyear<1999
assert _merge==2 if fiscalyear>1998
drop _merge totalobs

* replace pre-1999 missing values with hand entered values
replace total_giving_pre_2004 = totalsupport if fiscalyear<1999
replace alumni_of_record = totalnoofalumniofrecord if fiscalyear<1999
replace alumni_donors = noofalumnidonors if fiscalyear<1999
replace alumni_solicit_rate = noofalumnisolicited/totalnoofalumniofrecord if fiscalyear<1999
replace alumni_total_giving = alumni if fiscalyear<1999
replace corporations_total = corporationsandbusinesses if fiscalyear<1999
replace corporations_total_giving = corporationsandbusinesses if fiscalyear<1999
replace foundations_total = foundations if fiscalyear<1999
replace foundations_total_giving = foundations if fiscalyear<1999

* set zeros to missing values

foreach var of varlist totalsupport-foundations_total {
	dis "`var'"
	replace `var' = . if `var'==0 & vseteamname!="Auburn University (Auburn, AL) " & vseteamname!="Ball State University (Muncie, IN) " & vseteamname!="Syracuse University (Syracuse, NY) " & vseteamname!="University of Memphis (Memphis, TN) " & vseteamname!="University of Minnesota (Minneapolis, MN) " & vseteamname!="University of Virginia (Charlottesville, VA) "	
}

drop totalsupport-noofalumnidonors
save vse_data, replace
