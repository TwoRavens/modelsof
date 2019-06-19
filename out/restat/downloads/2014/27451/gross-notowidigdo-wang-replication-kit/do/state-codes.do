set more off
#delim cr
*version 8
pause on

capture log close
set logtype text
log using ../log/state-codes.log, replace

/* --------------------------------------

Creates a data set with every
state code possible.

--------------------------------------- */

clear
set mem 1m

************************************************************
** Create State Codes, FIPS & Names                       **
************************************************************

input state_fips str2 state_abbrev str20 state_name 
01   AL		"Alabama"
02   AK		"Alaska"
04   AZ		"Arizona"
05   AR		"Arkansas"
06   CA		"California"
08   CO		"Colorado"
09   CT		"Connecticut"
10   DE		"Delaware"
11   DC		"District of Columbia"
12   FL		"Florida"
13   GA		"Georgia"
15   HI		"Hawaii"
16   ID		"Idaho"
17   IL		"Illinois"
18   IN		"Indiana"
19   IA		"Iowa"
20   KS		"Kansas"
21   KY		"Kentucky"
22   LA		"Louisiana"
23   ME		"Maine"
24   MD		"Maryland"
25   MA		"Massachusetts"
26   MI		"Michigan"
27   MN		"Minnesota"
28   MS		"Mississippi"
29   MO		"Missouri"
30   MT		"Montana"
31   NE		"Nebraska"
32   NV		"Nevada"
33   NH		"New Hampshire"
34   NJ		"New Jersey"
35   NM		"New Mexico"
36   NY		"New York"
37   NC		"North Carolina"
38   ND		"North Dakota"
39   OH		"Ohio"
40   OK		"Oklahoma"
41   OR		"Oregon"
42   PA		"Pennsylvania"
44   RI		"Rhode Island"
45   SC		"South Carolina"
46   SD		"South Dakota"
47   TN		"Tennessee"
48   TX		"Texas"
49   UT		"Utah"
50   VT		"Vermont"
51   VA		"Virginia"
53   WA		"Washington"
54   WV		"West Virginia"
55   WI		"Wisconsin"
56   WY		"Wyoming"
60   AS		"American Samoa"
64   FM		"Federated States of Micronesia"
66   GU		"Guam"
end

************************************************************
** Add Census State Codes                                 **
************************************************************

** This code comes from the 1960 census, as cataloged
** in CPS NBER codebooks.

preserve
clear
input state_census str20 state_name 
11 "Maine"
12 "New Hampshire"
13 "Vermont"
14 "Massachusetts"
15 "Rhode Island"
16 "Connecticut"
21 "New York"
22 "New Jersey"
23 "Pennsylvania"
31 "Ohio"
32 "Indiana"
33 "Illinois"
34 "Michigan"
35 "Wisconsin"
41 "Minnesota"
42 "Iowa"
43 "Missouri"
44 "North Dakota"
45 "South Dakota"
46 "Nebraska"
47 "Kansas"
51 "Delaware"
52 "Maryland"
53 "District of Columbia"
54 "Virginia"
55 "West Virginia"
56 "North Carolina"
57 "South Carolina"
58 "Georgia"
59 "Florida"
61 "Kentucky"
62 "Tennessee"
63 "Alabama"
64 "Mississippi"
71 "Arkansas"
72 "Louisiana"
73 "Oklahoma"
74 "Texas"
81 "Montana"
82 "Idaho"
83 "Wyoming"
84 "Colorado"
85 "New Mexico"
86 "Arizona"
87 "Utah"
88 "Nevada"
91 "Washington"
92 "Oregon"
93 "California"
94 "Alaska"
95 "Hawaii"
end

sort state_name
tempfile census
save "`census'"
restore

sort state_name
merge state_name using "`census'" , uniqusing uniqmaster
tab _merge
list if _merge!=3
*keep if _merge==3
drop _merge

************************************************************
** ICP State Code                                         **
************************************************************

preserve
clear
input str20 state_name state_icp
"Connecticut" 01
"Maine" 02
"Massachusetts" 03
"New Hampshire" 04
"Rhode Island" 05
"Vermont" 06
"Delaware" 11
"New Jersey" 12
"New York" 13
"Pennsylvania" 14
"Illinois" 21
"Indiana" 22
"Michigan" 23
"Ohio" 24
"Wisconsin" 25
"Iowa" 31
"Kansas" 32
"Minnesota" 33
"Missouri" 34
"Nebraska" 35
"North Dakota" 36
"South Dakota" 37
"Virginia" 40
"Alabama" 41
"Arkansas" 42
"Florida" 43
"Georgia" 44
"Louisiana" 45
"Mississippi" 46
"North Carolina" 47
"South Carolina" 48
"Texas" 49
"Kentucky" 51
"Maryland" 52
"Oklahoma" 53
"Tennessee" 54
"West Virginia" 56
"Arizona" 61
"Colorado" 62
"Idaho" 63
"Montana" 64
"Nevada" 65
"New Mexico" 66
"Utah" 67
"Wyoming" 68
"California" 71
"Oregon" 72
"Washington" 73
"Alaska" 81
"Hawaii" 82
"Puerto Rico" 83
"District of Columbia" 98
end
tempfile icp
sort state_name
save "`icp'"
restore

sort state_name
merge state_name using "`icp'" , uniqusing uniqmaster
tab _merge
list if _merge!=3
*keep if _merge==3
drop _merge

************************************************************
** Alphabetical State Codes                               **
************************************************************

** These are the state codes that Cullen & Gruber use
preserve
clear
input state_alph str2 state_abbrev
     1         AL
     2         AZ
     3         AR
     4         CA
     5         CO
     6         CT
     7         DE
     8         DC
     9         FL
    10         GA
    11         ID
    12         IL
    13         IN
    14         IA
    15         KS
    16         KY
    17         LA
    18         ME
    19         MD
    20         MA
    21         MI
    22         MN
    23         MS
    24         MO
    25         MT
    26         NE
    27         NV
    28         NH
    29         NJ
    30         NM
    31         NY
    32         NC
    33         ND
    34         OH
    35         OK
    36         OR
    37         PA
    38         RI
    39         SC
    40         SD
    41         TN
    42         TX
    43         UT
    44         VT
    45         VA
    46         WA
    47         WV
    48         WI
    49         WY
    50         AK
    51         HI
end

sort state_abbrev
tempfile cullgrub
save "`cullgrub'"
restore

sort state_abbrev
merge state_abbrev using "`cullgrub'" , uniqusing uniqmaster
tab _merge
list if _merge!=3
*keep if _merge==3
drop _merge

************************************************************
** Save & Close                                           **
************************************************************

sort state_abbrev

compress
label data "Every Possible State Code"
save ../dta/state_codes.dta, replace

log close
exit

