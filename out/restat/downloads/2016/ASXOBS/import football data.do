cd "~/Desktop/Research/College Sports/Data Archive/"

set more off
tempfile tempdata tempteams

cd "Raw Football Data"

insheet using teams.txt, tab
sort team
drop longname
save `tempteams'
clear

insheet using cleaned_results.txt, tab

* Do a million checks to make sure the data are in the expected order

local endobs = _N - 6 

assert v1!=""
assert v1=="Team" | v1=="Line" if v1[_n+1]=="Date"
assert v1=="Date" if v1[_n+1]=="Opponent"
assert v1=="Opponent" if v1[_n+1]=="Score"
assert v1=="Score" if v1[_n+1]=="Line" & v1[_n+2]=="Line"
assert v1=="Line" if v1[_n+1]=="Line" & v1[_n-1]=="Score"
assert v1=="Line" if v1[_n+1]=="Team"

assert v1[_n+1]=="Date" & v1[_n+2]=="Opponent" & v1[_n+3]=="Score" & v1[_n+4]=="Line" & v1[_n+5]=="Line" & v1[_n+6]=="Date" if v1=="Team" & v1[_n+6]=="Date" in 1/`endobs'
assert v1[_n+1]=="Date" & v1[_n+2]=="Opponent" & v1[_n+3]=="Score" & v1[_n+4]=="Line" & v1[_n+5]=="Line" & v1[_n+6]=="Team" & v1[_n+7]=="Date" if v1=="Team" & v1[_n+6]=="Team" in 1/`endobs'
assert v1[_n+6]=="Date" | v1[_n+6]=="Team" if v1=="Team" in 1/`endobs'
assert v1[_n+1]=="Opponent" & v1[_n+2]=="Score" & v1[_n+3]=="Line" & v1[_n+4]=="Line" & v1[_n+5]=="Date" if v1=="Date" & v1[_n+5]=="Date" in 1/`endobs'
assert v1[_n+1]=="Opponent" & v1[_n+2]=="Score" & v1[_n+3]=="Line" & v1[_n+4]=="Line" & v1[_n+5]=="Team" & v1[_n+6]=="Date" if v1=="Date" & v1[_n+5]=="Team" in 1/`endobs'
assert v1[_n+5]=="Date" | v1[_n+5]=="Team" if v1=="Date" in 1/`endobs'
assert v1[_n+1]=="Score" & v1[_n+2]=="Line" & v1[_n+3]=="Line" & v1[_n+4]=="Date" & v1[_n+5]=="Opponent" if v1=="Opponent" & v1[_n+4]=="Date" in 1/`endobs'
assert v1[_n+1]=="Score" & v1[_n+2]=="Line" & v1[_n+3]=="Line" & v1[_n+4]=="Team" & v1[_n+5]=="Date" & v1[_n+6]=="Opponent" if v1=="Opponent" & v1[_n+4]=="Team" in 1/`endobs'
assert v1[_n+5]=="Date" | v1[_n+5]=="Opponent" if v1=="Opponent" in 1/`endobs'
assert v1[_n+1]=="Line" & v1[_n+2]=="Line" & v1[_n+3]=="Date" & v1[_n+4]=="Opponent" & v1[_n+5]=="Score" if v1=="Score" & v1[_n+3]=="Date" in 1/`endobs'
assert v1[_n+1]=="Line" & v1[_n+2]=="Line" & v1[_n+3]=="Team" & v1[_n+4]=="Date" & v1[_n+5]=="Opponent" & v1[_n+6]=="Score" if v1=="Score" & v1[_n+3]=="Team" in 1/`endobs'
assert v1[_n+5]=="Score" | v1[_n+5]=="Opponent" if v1=="Score" in 1/`endobs'
assert v1[_n+1]=="Line" & v1[_n+2]=="Date" & v1[_n+3]=="Opponent" & v1[_n+4]=="Score" & v1[_n+5]=="Line" if v1=="Line" & v1[_n+2]=="Date" & v1[_n-1]!="Line" in 1/`endobs'
assert v1[_n+1]=="Line" & v1[_n+2]=="Team" & v1[_n+3]=="Date" & v1[_n+4]=="Opponent" & v1[_n+5]=="Score" & v1[_n+6]=="Line" if v1=="Line" & v1[_n+2]=="Team" & v1[_n-1]!="Line" in 1/`endobs'
assert v1[_n+5]=="Score" | v1[_n+5]=="Line" if v1=="Line" & v1[_n-1]!="Line" in 1/`endobs'
assert v1[_n+1]=="Date" & v1[_n+2]=="Opponent" & v1[_n+3]=="Score" & v1[_n+4]=="Line"  & v1[_n+5]=="Line" if v1=="Line" & v1[_n+1]=="Date" & v1[_n-1]=="Line" in 1/`endobs'
assert v1[_n+1]=="Team" & v1[_n+2]=="Date" & v1[_n+3]=="Opponent" & v1[_n+4]=="Score" & v1[_n+5]=="Line"  & v1[_n+6]=="Line" if v1=="Line" & v1[_n+1]=="Team" & v1[_n-1]=="Line" in 1/`endobs'
assert v1[_n+5]=="Line" if v1=="Line" & v1[_n-1]=="Line" in 1/`endobs'

assert v3==. if v1!="Score"
assert v3!=. if v1=="Score"

* Reshape the data

gen str4 team =""
gen str10 date = ""
gen str24 opponent = ""
gen str6 line = ""
gen str6 overunder = ""
gen str4 ownscore =""
gen int opponentscore = .

local new_obs_count = 1
local orig_obs_count = 2
assert v1[1]=="Team"
local teamcount = v2[1]
local endcount = _N
while `orig_obs_count' <= `endcount' {
	local obs_minus_one = `orig_obs_count' - 1
	if v1[`orig_obs_count']=="Team"  {
		local teamcount = v2[`orig_obs_count']
		local orig_obs_count = `orig_obs_count' + 1 		
	}
	else {
		if v1[`orig_obs_count']=="Date" {
			quietly replace date = v2[`orig_obs_count'] in `new_obs_count'
			quietly replace team = "`teamcount'" in `new_obs_count'
			local orig_obs_count = `orig_obs_count' + 1 		
		}	
		else {
			if v1[`orig_obs_count']=="Opponent" {
				quietly replace opponent = v2[`orig_obs_count'] in `new_obs_count'
				local orig_obs_count = `orig_obs_count' + 1 		
			}	
			else {
				if v1[`orig_obs_count']=="Score" {
					quietly replace ownscore = v2[`orig_obs_count'] in `new_obs_count'
					quietly replace opponentscore = v3[`orig_obs_count'] in `new_obs_count'
					local orig_obs_count = `orig_obs_count' + 1 		
				}	
				else {
					if v1[`orig_obs_count']=="Line" &  v1[`obs_minus_one']=="Score" {
						quietly replace line = v2[`orig_obs_count'] in `new_obs_count'
						local orig_obs_count = `orig_obs_count' + 1 		
					}	
					else {
						if v1[`orig_obs_count']=="Line" &  v1[`obs_minus_one']=="Line" {
							quietly replace overunder = v2[`orig_obs_count'] in `new_obs_count'
							local orig_obs_count = `orig_obs_count' + 1
							assert v1[`orig_obs_count']=="Date" | v1[`orig_obs_count']=="Team" if `orig_obs_count'< `endcount'
							local new_obs_count = `new_obs_count' + 1
						}
					}
				}
			}
		}
	}
}
sum
local tempcount = `new_obs_count' - 1
assert opponentscore!=. in 1/`tempcount'
drop if opponentscore==.
drop v1 v2 v3

** Clean up the variables

destring ownscore, replace
replace line = "" if line=="N"
replace overunder = "" if overunder=="N"
destring line, replace
destring overunder, replace

* Fix single typo from covers.com data
replace overunder = 52.5 if overunder==525

destring team, replace
sort team
merge team using `tempteams'
assert _merge==3
drop _merge

gen dateclean = date(date, "MDY", 2020)
format dateclean %td
drop date
rename dateclean date

gen day = day(date)
gen month = month(date)
gen year = year(date)
assert year>1984 & year<2012
assert day>0 & day<32
assert month==1 | (month>7 & month<13)
gen int season = .
forvalues i = 1985/2009 {
	replace season = `i' if year==`i' & month>1
	replace season = `i' if year==`i'+1 & month<2
}
assert season!=.

* Drop seasons in which teams are not in Div I-A (FBS)
* Source: http://www.cfbdatawarehouse.com/data/div_ia_team_index.php
* Including post season games messes up generalized propensity score because observing the post season game is a function of performance throughout the season

drop if teamname=="Akron" & season<1987
drop if teamname=="Alabama-Birmingham" & season<1996
drop if teamname=="Arkansas State" & season<1992
drop if teamname=="Boise State" & season<1996
drop if teamname=="Buffalo" & season<1999
drop if teamname=="Central Florida" & season<1996
drop if teamname=="Connecticut" & season<2000
drop if teamname=="Florida Atlantic" & season<2006
drop if teamname=="Florida International" & season<2006
drop if teamname=="Idaho" & season<1997
drop if teamname=="Louisiana Tech" & season<1989
drop if teamname=="UL Monroe" & season<1994
drop if teamname=="Marshall" & season<1997
drop if teamname=="Middle Tennessee St." & season<1999
drop if teamname=="Nevada" & season<1992
drop if teamname=="North Texas" & season<1995
drop if teamname=="South Florida" & season<2001
drop if teamname=="Troy" & season<2002
drop if teamname=="Western Kentucky" & season<2009

* Generate a postseason indicator

gen postseason = 0
replace postseason = 1 if season==1985 & (month==1 | (month==12 & day>=14))
replace postseason = 1 if season==1986 & (month==1 | (month==12 & day>=13))
replace postseason = 1 if season==1987 & (month==1 | (month==12 & day>=12))
replace postseason = 1 if season==1988 & (month==1 | (month==12 & day>=10))
replace postseason = 1 if season==1989 & (month==1 | (month==12 & day>=9))
replace postseason = 1 if season==1990 & (month==1 | (month==12 & day>=8))
replace postseason = 1 if season==1991 & (month==1 | (month==12 & day>=14))
replace postseason = 1 if season==1992 & (month==1 | (month==12 & day>=18))
replace postseason = 1 if season==1993 & (month==1 | (month==12 & day>=17))
replace postseason = 1 if season==1994 & (month==1 | (month==12 & day>=15))
replace postseason = 1 if season==1995 & (month==1 | (month==12 & day>=14))
replace postseason = 1 if season==1996 & (month==1 | (month==12 & day>=19))
replace postseason = 1 if season==1997 & (month==1 | (month==12 & day>=20))
replace postseason = 1 if season==1998 & (month==1 | (month==12 & day>=19))
replace postseason = 1 if season==1999 & (month==1 | (month==12 & day>=18))
replace postseason = 1 if season==2000 & (month==1 | (month==12 & day>=20))
replace postseason = 1 if season==2001 & (month==1 | (month==12 & day>=18))
replace postseason = 1 if season==2002 & (month==1 | (month==12 & day>=17))
replace postseason = 1 if season==2003 & (month==1 | (month==12 & day>=16))
replace postseason = 1 if season==2004 & (month==1 | (month==12 & day>=14))
replace postseason = 1 if season==2005 & (month==1 | (month==12 & day>=20))
replace postseason = 1 if season==2006 & (month==1 | (month==12 & day>=19))
replace postseason = 1 if season==2007 & (month==1 | (month==12 & day>=20))
replace postseason = 1 if season==2008 & (month==1 | (month==12 & day>=20))
replace postseason = 1 if season==2009 & (month==1 | (month==12 & day>=19))


* Championship Games (minus WAC and Big 12)
replace postseason = 1 if teamname=="Alabama" & season==1992 & month==12 & day>=5
replace postseason = 1 if teamname=="Florida" & season==1992 & month==12 & day>=5
replace postseason = 1 if teamname=="Alabama" & season==1993 & month==12 & day>=4
replace postseason = 1 if teamname=="Florida" & season==1993 & month==12 & day>=4
replace postseason = 1 if teamname=="Alabama" & season==1994 & month==12 & day>=3
replace postseason = 1 if teamname=="Florida" & season==1994 & month==12 & day>=3
replace postseason = 1 if teamname=="Arkansas" & season==1995 & month==12 & day>=2
replace postseason = 1 if teamname=="Florida" & season==1995 & month==12 & day>=2
replace postseason = 1 if teamname=="Alabama" & season==1996 & month==12 & day>=7
replace postseason = 1 if teamname=="Florida" & season==1996 & month==12 & day>=7
replace postseason = 1 if teamname=="Nebraska" & season==1996 & month==12 & day>=7
replace postseason = 1 if teamname=="Texas" & season==1996 & month==12 & day>=7
replace postseason = 1 if teamname=="Auburn" & season==1997 & month==12 & day>=6
replace postseason = 1 if teamname=="Tennessee" & season==1997 & month==12 & day>=6
replace postseason = 1 if teamname=="Marshall" & season==1997 & month==12 & day>=5
replace postseason = 1 if teamname=="Toledo" & season==1997 & month==12 & day>=5
replace postseason = 1 if teamname=="Marshall" & season==1998 & month==12 & day>=4
replace postseason = 1 if teamname=="Toledo" & season==1998 & month==12 & day>=4
replace postseason = 1 if teamname=="Tennessee" & season==1998 & month==12 & day>=5
replace postseason = 1 if teamname=="Mississippi State" & season==1998 & month==12 & day>=5
replace postseason = 1 if teamname=="Alabama" & season==1999 & month==12 & day>=4
replace postseason = 1 if teamname=="Florida" & season==1999 & month==12 & day>=4
replace postseason = 1 if teamname=="Marshall" & season==1999 & month==12 & day>=3
replace postseason = 1 if teamname=="Western Michigan" & season==1999 & month==12 & day>=3
replace postseason = 1 if teamname=="Auburn" & season==2000 & month==12 & day>=2
replace postseason = 1 if teamname=="Florida" & season==2000 & month==12 & day>=2
replace postseason = 1 if teamname=="Marshall" & season==2000 & month==12 & day>=2
replace postseason = 1 if teamname=="Western Michigan" & season==2000 & month==12 & day>=2
replace postseason = 1 if teamname=="Louisiana State" & season==2001 & month==12 & day>=8
replace postseason = 1 if teamname=="Tennessee" & season==2001 & month==12 & day>=8
replace postseason = 1 if teamname=="Marshall" & season==2001 & month==11 & day>=30
replace postseason = 1 if teamname=="Toledo" & season==2001 & month==11 & day>=30
replace postseason = 1 if teamname=="Arkansas" & season==2002 & month==12 & day>=7
replace postseason = 1 if teamname=="Georgia" & season==2002 & month==12 & day>=7
replace postseason = 1 if teamname=="Marshall" & season==2002 & month==12 & day>=7
replace postseason = 1 if teamname=="Toledo" & season==2002 & month==12 & day>=7
replace postseason = 1 if teamname=="Louisiana State" & season==2003 & month==12 & day>=6
replace postseason = 1 if teamname=="Georgia" & season==2003 & month==12 & day>=6
replace postseason = 1 if teamname=="Bowling Green" & season==2003 & month==12 & day>=4
replace postseason = 1 if teamname=="Miami (Ohio)" & season==2003 & month==12 & day>=4
replace postseason = 1 if teamname=="Auburn" & season==2004 & month==12 & day>=4
replace postseason = 1 if teamname=="Tennessee" & season==2004 & month==12 & day>=4
replace postseason = 1 if teamname=="Toledo" & season==2004 & month==12 & day>=2
replace postseason = 1 if teamname=="Miami (Ohio)" & season==2004 & month==12 & day>=2
replace postseason = 1 if teamname=="Akron" & season==2005 & month==12 & day>=1
replace postseason = 1 if teamname=="Northern Illinois" & season==2005 & month==12 & day>=1
replace postseason = 1 if teamname=="Central Florida" & season==2005 & month==12 & day>=3
replace postseason = 1 if teamname=="Tulsa" & season==2005 & month==12 & day>=3
replace postseason = 1 if teamname=="Georgia" & season==2005 & month==12 & day>=3
replace postseason = 1 if teamname=="Louisiana State" & season==2005 & month==12 & day>=3
replace postseason = 1 if teamname=="Florida State" & season==2005 & month==12 & day>=3
replace postseason = 1 if teamname=="Virginia Tech" & season==2005 & month==12 & day>=3
replace postseason = 1 if teamname=="Arkansas" & season==2006 & month==12 & day>=2
replace postseason = 1 if teamname=="Florida" & season==2006 & month==12 & day>=2
replace postseason = 1 if teamname=="Georgia Tech" & season==2006 & month==12 & day>=2
replace postseason = 1 if teamname=="Wake Forest" & season==2006 & month==12 & day>=2
replace postseason = 1 if teamname=="Houston" & season==2006 & month==12 & day>=1
replace postseason = 1 if teamname=="Southern Mississippi" & season==2006 & month==12 & day>=1
replace postseason = 1 if teamname=="Central Michigan" & season==2006 & month==11 & day>=30
replace postseason = 1 if teamname=="Ohio" & season==2006 & month==11 & day>=30
replace postseason = 1 if teamname=="Boston College" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Virginia Tech" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Central Florida" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Tulsa" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Central Michigan" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Miami (Ohio)" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Louisiana State" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Tennessee" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Alabama" & season==2008 & month==12 & day>=6
replace postseason = 1 if teamname=="Florida" & season==2008 & month==12 & day>=6
replace postseason = 1 if teamname=="Ball State" & season==2008 & month==12 & day>=5
replace postseason = 1 if teamname=="Buffalo" & season==2008 & month==12 & day>=5
replace postseason = 1 if teamname=="Boston College" & season==2008 & month==12 & day>=6
replace postseason = 1 if teamname=="Virginia Tech" & season==2008 & month==12 & day>=6
replace postseason = 1 if teamname=="East Carolina" & season==2008 & month==12 & day>=6
replace postseason = 1 if teamname=="Tulsa" & season==2008 & month==12 & day>=6
replace postseason = 1 if teamname=="Alabama" & season==2009 & month==12 & day>=5
replace postseason = 1 if teamname=="Florida" & season==2009 & month==12 & day>=5
replace postseason = 1 if teamname=="Central Michigan" & season==2009 & month==12 & day>=4
replace postseason = 1 if teamname=="Ohio" & season==2009 & month==12 & day>=4
replace postseason = 1 if teamname=="Clemson" & season==2009 & month==12 & day>=5
replace postseason = 1 if teamname=="Georgia Tech" & season==2009 & month==12 & day>=5
replace postseason = 1 if teamname=="East Carolina" & season==2009 & month==12 & day>=5
replace postseason = 1 if teamname=="Houston" & season==2009 & month==12 & day>=5

* WAC + Big 12 Championships
replace postseason = 1 if teamname=="Brigham Young" & season==1996 & month==12 & day>=7
replace postseason = 1 if teamname=="Wyoming" & season==1996 & month==12 & day>=7
replace postseason = 1 if teamname=="Colorado State" & season==1997 & month==12 & day>=6
replace postseason = 1 if teamname=="New Mexico" & season==1997 & month==12 & day>=6
replace postseason = 1 if teamname=="Brigham Young" & season==1998 & month==12 & day>=5
replace postseason = 1 if teamname=="Air Force" & season==1998 & month==12 & day>=5
replace postseason = 1 if teamname=="Texas" & season==1996 & month==12 & day>=7
replace postseason = 1 if teamname=="Nebraska" & season==1996 & month==12 & day>=7
replace postseason = 1 if teamname=="Nebraska" & season==1997 & month==12 & day>=6
replace postseason = 1 if teamname=="Texas A&M" & season==1997 & month==12 & day>=6
replace postseason = 1 if teamname=="Kansas State" & season==1998 & month==12 & day>=5
replace postseason = 1 if teamname=="Texas A&M" & season==1998 & month==12 & day>=5
replace postseason = 1 if teamname=="Kansas State" & season==1998 & month==12 & day>=5
replace postseason = 1 if teamname=="Texas A&M" & season==1998 & month==12 & day>=5
replace postseason = 1 if teamname=="Nebraska" & season==1999 & month==12 & day>=4
replace postseason = 1 if teamname=="Texas" & season==1999 & month==12 & day>=4
replace postseason = 1 if teamname=="Kansas State" & season==2000 & month==12 & day>=2
replace postseason = 1 if teamname=="Oklahoma" & season==2000 & month==12 & day>=2
replace postseason = 1 if teamname=="Colorado" & season==2001 & month==12 & day>=1
replace postseason = 1 if teamname=="Texas" & season==2001 & month==12 & day>=1
replace postseason = 1 if teamname=="Colorado" & season==2002 & month==12 & day>=7
replace postseason = 1 if teamname=="Oklahoma" & season==2002 & month==12 & day>=7
replace postseason = 1 if teamname=="Kansas State" & season==2003 & month==12 & day>=6
replace postseason = 1 if teamname=="Oklahoma" & season==2003 & month==12 & day>=6
replace postseason = 1 if teamname=="Colorado" & season==2004 & month==12 & day>=4
replace postseason = 1 if teamname=="Oklahoma" & season==2004 & month==12 & day>=4
replace postseason = 1 if teamname=="Colorado" & season==2005 & month==12 & day>=3
replace postseason = 1 if teamname=="Texas" & season==2005 & month==12 & day>=3
replace postseason = 1 if teamname=="Nebraska" & season==2006 & month==12 & day>=2
replace postseason = 1 if teamname=="Oklahoma" & season==2006 & month==12 & day>=2
replace postseason = 1 if teamname=="Missouri" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Oklahoma" & season==2007 & month==12 & day>=1
replace postseason = 1 if teamname=="Missouri" & season==2008 & month==12 & day>=6
replace postseason = 1 if teamname=="Oklahoma" & season==2008 & month==12 & day>=6
replace postseason = 1 if teamname=="Nebraska" & season==2009 & month==12 & day>=5
replace postseason = 1 if teamname=="Texas" & season==2009 & month==12 & day>=5

gen realspread_post = ownscore-opponentscore
gen realspread = ownscore-opponentscore if postseason==0
* Generate win variable - tie counts as loss
gen win_post = realspread_post>0
gen win = realspread>0 if postseason==0
gen tie = realspread==0

** Generate season-level variables

gen countpick = line==0 if line!=.
gen pickones = 1 if line!=.
gen ones_post = 1
gen ones = postseason==0
by team season, sort: egen picks = total(countpick)
by team season, sort: egen lineobs = total(pickones)
gen pickshare = picks/lineobs
drop ones countpick pickones

** Set line variable to missing for seasons with 50% or more games classified as picks

replace line = . if pickshare>.5
gen line_post = line
replace line = . if postseason==1

sort teamname season
save `tempdata'
clear

insheet using "BCS Teams.csv"
rename v1 teamname
drop v3
replace bcs = 0 if bcs==.
sort teamname

merge teamname using `tempdata'
assert _merge==2 | _merge==3
assert teamname=="Army" | teamname=="Navy" | teamname=="Air Force" if _merge==2
drop _merge

sort teamname season
drop postseason realspread_post win_post ones_post pickshare line_post lineobs picks
cd ..
save covers_data.dta, replace
