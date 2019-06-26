**************************************************************************************************
*** This do file reproduces the results for 
*** Causality between terrorism and economic growth
*** Journal of Peace Research Volume 50 Issue 1, January 2013
*** Daniel Meierrieks (University of Paderborn)
*** Thomas Gries (University of Paderborn)
**************************************************************************************************
*** January, 2013
**************************************************************************************************
/* Note: In order to calculate the F-statistics as reported in the main text, please always store
all the needed data from both regression analysis (N*T, RSS1, RSS2 [or RSS3]), as it is indicated 
in the main text and then calculate the F-statistic to make model comparisons.
Use a common calculator to compute the F-Statistics (e.g., http://www.uni-tuebingen.de/fileadmin/Uni_Tuebingen/Fakultaeten/MathePhysik/Institute/IAAT/AIT/Tools/taschenrechner.html)
Use a common F-table to assess the statistical significance of the findings (e.g., http://davidmlane.com/hyperstat/F_table.html)									*/
**************************************************************************************************

version 11.0
drop _all
clear matrix
set mem 800m
set mat 10000

*******************************************************************************************************************
************* PART 1: Non-Causality Test (Table I)
*******************************************************************************************************************

*** IMPORTANT NOTE: This file reproduces the findings for the 1970-1991 period!

use "C:\Users\Daniel\Desktop\Data 1970-1991.dta", clear

*** Non-Causality from Growth to TA (First Lag)

reg attacks l.attacks countrydummy*, noconstant notable

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Store the needed data from both regression analysis (N*T, RSS1, RSS2) as given in the main text and calculate the F-statistic. Then, use a table of F-statistics to assess the statistical significance of the statistic.

*** Non-Causality from Growth to TA (Second Lag, Constrained Regression)

reg attacks l.attacks l2.attacks countrydummy*, noconstant notable

constraint define 1 l.growth_country1 = l2.growth_country1
constraint define 2 l.growth_country2 = l2.growth_country2
constraint define 3 l.growth_country3 = l2.growth_country3
constraint define 4 l.growth_country4 = l2.growth_country4
constraint define 5 l.growth_country5 = l2.growth_country5
constraint define 6 l.growth_country7 = l2.growth_country7
constraint define 7 l.growth_country8 = l2.growth_country8
constraint define 8 l.growth_country12 = l2.growth_country12
constraint define 9 l.growth_country13 = l2.growth_country13
constraint define 10 l.growth_country15 = l2.growth_country15
constraint define 11 l.growth_country20 = l2.growth_country20
constraint define 12 l.growth_country22 = l2.growth_country22
constraint define 13 l.growth_country23 = l2.growth_country23
constraint define 14 l.growth_country25 = l2.growth_country25
constraint define 15 l.growth_country26 = l2.growth_country26
constraint define 16 l.growth_country28 = l2.growth_country28
constraint define 17 l.growth_country30 = l2.growth_country30
constraint define 18 l.growth_country31 = l2.growth_country31
constraint define 19 l.growth_country32 = l2.growth_country32
constraint define 20 l.growth_country33 = l2.growth_country33
constraint define 21 l.growth_country34 = l2.growth_country34
constraint define 22 l.growth_country35 = l2.growth_country35
constraint define 23 l.growth_country37 = l2.growth_country37
constraint define 24 l.growth_country38 = l2.growth_country38
constraint define 25 l.growth_country39 = l2.growth_country39
constraint define 26 l.growth_country42 = l2.growth_country42
constraint define 27 l.growth_country44 = l2.growth_country44
constraint define 28 l.growth_country45 = l2.growth_country45
constraint define 29 l.growth_country46 = l2.growth_country46
constraint define 30 l.growth_country47 = l2.growth_country47
constraint define 31 l.growth_country48 = l2.growth_country48
constraint define 32 l.growth_country49 = l2.growth_country49
constraint define 33 l.growth_country50 = l2.growth_country50
constraint define 34 l.growth_country55 = l2.growth_country55
constraint define 35 l.growth_country56 = l2.growth_country56
constraint define 36 l.growth_country57 = l2.growth_country57
constraint define 37 l.growth_country58 = l2.growth_country58
constraint define 38 l.growth_country54 = l2.growth_country54
constraint define 39 l.growth_country61 = l2.growth_country61
constraint define 40 l.growth_country63 = l2.growth_country63
constraint define 41 l.growth_country64 = l2.growth_country64
constraint define 42 l.growth_country65 = l2.growth_country65
constraint define 43 l.growth_country66 = l2.growth_country66
constraint define 44 l.growth_country67 = l2.growth_country67
constraint define 45 l.growth_country69 = l2.growth_country69
constraint define 46 l.growth_country70 = l2.growth_country70
constraint define 47 l.growth_country71 = l2.growth_country71
constraint define 48 l.growth_country73 = l2.growth_country73
constraint define 49 l.growth_country74 = l2.growth_country74
constraint define 50 l.growth_country75 = l2.growth_country75
constraint define 51 l.growth_country76 = l2.growth_country76
constraint define 52 l.growth_country77 = l2.growth_country77
constraint define 53 l.growth_country78 = l2.growth_country78
constraint define 54 l.growth_country79 = l2.growth_country79
constraint define 55 l.growth_country81 = l2.growth_country81
constraint define 56 l.growth_country82 = l2.growth_country82
constraint define 57 l.growth_country83 = l2.growth_country83
constraint define 58 l.growth_country85 = l2.growth_country85
constraint define 59 l.growth_country86 = l2.growth_country86
constraint define 60 l.growth_country88 = l2.growth_country88
constraint define 61 l.growth_country90 = l2.growth_country90
constraint define 62 l.growth_country91 = l2.growth_country91
constraint define 63 l.growth_country92 = l2.growth_country92
constraint define 64 l.growth_country93 = l2.growth_country93
constraint define 65 l.growth_country98 = l2.growth_country98
constraint define 66 l.growth_country100 = l2.growth_country100
constraint define 67 l.growth_country101 = l2.growth_country101
constraint define 68 l.growth_country102 = l2.growth_country102
constraint define 69 l.growth_country103 = l2.growth_country103
constraint define 70 l.growth_country105 = l2.growth_country105
constraint define 71 l.growth_country106 = l2.growth_country106
constraint define 72 l.growth_country108 = l2.growth_country108
constraint define 73 l.growth_country109 = l2.growth_country109
constraint define 74 l.growth_country110 = l2.growth_country110
constraint define 75 l.growth_country111 = l2.growth_country111
constraint define 76 l.growth_country112 = l2.growth_country112
constraint define 77 l.growth_country113 = l2.growth_country113
constraint define 78 l.growth_country114 = l2.growth_country114
constraint define 79 l.growth_country115 = l2.growth_country115
constraint define 80 l.growth_country116 = l2.growth_country116
constraint define 81 l.growth_country117 = l2.growth_country117
constraint define 82 l.growth_country118 = l2.growth_country118
constraint define 83 l.growth_country119 = l2.growth_country119
constraint define 84 l.growth_country120 = l2.growth_country120
constraint define 85 l.growth_country121 = l2.growth_country121
constraint define 86 l.growth_country122 = l2.growth_country122
constraint define 87 l.growth_country123 = l2.growth_country123
constraint define 88 l.growth_country124 = l2.growth_country124
constraint define 89 l.growth_country127 = l2.growth_country127
constraint define 90 l.growth_country128 = l2.growth_country128
constraint define 91 l.growth_country130 = l2.growth_country130
constraint define 92 l.growth_country133 = l2.growth_country133
constraint define 93 l.growth_country134 = l2.growth_country134
constraint define 94 l.growth_country135 = l2.growth_country135
constraint define 95 l.growth_country136 = l2.growth_country136
constraint define 96 l.growth_country137 = l2.growth_country137
constraint define 97 l.growth_country139 = l2.growth_country139
constraint define 98 l.growth_country140 = l2.growth_country140
constraint define 99 l.growth_country141 = l2.growth_country141
constraint define 100 l.growth_country142 = l2.growth_country142
constraint define 101 l.growth_country144 = l2.growth_country144
constraint define 102 l.growth_country146 = l2.growth_country146
constraint define 103 l.growth_country147 = l2.growth_country147
constraint define 104 l.growth_country148 = l2.growth_country148
constraint define 105 l.growth_country149 = l2.growth_country149
constraint define 106 l.growth_country150 = l2.growth_country150
constraint define 107 l.growth_country151 = l2.growth_country151
constraint define 108 l.growth_country152 = l2.growth_country152
constraint define 109 l.growth_country153 = l2.growth_country153
constraint define 110 l.growth_country154 = l2.growth_country154
constraint define 111 l.growth_country156 = l2.growth_country156
constraint define 112 l.growth_country157 = l2.growth_country157
constraint define 113 l.growth_country159 = l2.growth_country159
constraint define 114 l.growth_country162 = l2.growth_country162
constraint define 115 l.growth_country163 = l2.growth_country163

cnsreg attacks l.attacks l2.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 l2.growth_country1 l2.growth_country2 l2.growth_country3 l2.growth_country4 l2.growth_country5 l2.growth_country7 l2.growth_country8 l2.growth_country12 l2.growth_country13 l2.growth_country15 l2.growth_country20 l2.growth_country22 l2.growth_country23 l2.growth_country25 l2.growth_country26 l2.growth_country28 l2.growth_country30 l2.growth_country31 l2.growth_country32 l2.growth_country33 l2.growth_country34 l2.growth_country35 l2.growth_country37 l2.growth_country38 l2.growth_country39 l2.growth_country42 l2.growth_country44 l2.growth_country45 l2.growth_country46 l2.growth_country47 l2.growth_country48 l2.growth_country49 l2.growth_country50 l2.growth_country55 l2.growth_country56 l2.growth_country57 l2.growth_country58 l2.growth_country54 l2.growth_country61 l2.growth_country63 l2.growth_country64 l2.growth_country65 l2.growth_country66 l2.growth_country67 l2.growth_country69 l2.growth_country70 l2.growth_country71 l2.growth_country73 l2.growth_country74 l2.growth_country75 l2.growth_country76 l2.growth_country77 l2.growth_country78 l2.growth_country79 l2.growth_country81 l2.growth_country82 l2.growth_country83 l2.growth_country85 l2.growth_country86 l2.growth_country88 l2.growth_country90 l2.growth_country91 l2.growth_country92 l2.growth_country93 l2.growth_country98 l2.growth_country100 l2.growth_country101 l2.growth_country102 l2.growth_country103 l2.growth_country105 l2.growth_country106 l2.growth_country108 l2.growth_country109 l2.growth_country110 l2.growth_country111 l2.growth_country112 l2.growth_country113 l2.growth_country114 l2.growth_country115 l2.growth_country116 l2.growth_country117 l2.growth_country118 l2.growth_country119 l2.growth_country120 l2.growth_country121 l2.growth_country122 l2.growth_country123 l2.growth_country124 l2.growth_country127 l2.growth_country128 l2.growth_country130 l2.growth_country133 l2.growth_country134 l2.growth_country135 l2.growth_country136 l2.growth_country137 l2.growth_country139 l2.growth_country140 l2.growth_country141 l2.growth_country142 l2.growth_country144 l2.growth_country146 l2.growth_country147 l2.growth_country148 l2.growth_country149 l2.growth_country150 l2.growth_country151 l2.growth_country152 l2.growth_country153 l2.growth_country154 l2.growth_country156 l2.growth_country157 l2.growth_country159 l2.growth_country162 l2.growth_country163 countrydummy*, noconstant constraints(1-115)

di "RSS: " (`e(rmse)')^2*`e(df_r)' "."

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from Growth to TA (Third Lag, Constrained Regression)

reg attacks l.attacks l2.attacks l3.attacks countrydummy*, noconstant notable

constraint define 117 l2.growth_country1 = l3.growth_country1
constraint define 118 l2.growth_country2 = l3.growth_country2
constraint define 119 l2.growth_country3 = l3.growth_country3
constraint define 120 l2.growth_country4 = l3.growth_country4
constraint define 121 l2.growth_country5 = l3.growth_country5
constraint define 122 l2.growth_country7 = l3.growth_country7
constraint define 123 l2.growth_country8 = l3.growth_country8
constraint define 124 l2.growth_country12 = l3.growth_country12
constraint define 125 l2.growth_country13 = l3.growth_country13
constraint define 126 l2.growth_country15 = l3.growth_country15
constraint define 127 l2.growth_country20 = l3.growth_country20
constraint define 128 l2.growth_country22 = l3.growth_country22
constraint define 129 l2.growth_country23 = l3.growth_country23
constraint define 130 l2.growth_country25 = l3.growth_country25
constraint define 131 l2.growth_country26 = l3.growth_country26
constraint define 132 l2.growth_country28 = l3.growth_country28
constraint define 133 l2.growth_country30 = l3.growth_country30
constraint define 134 l2.growth_country31 = l3.growth_country31
constraint define 135 l2.growth_country32 = l3.growth_country32
constraint define 136 l2.growth_country33 = l3.growth_country33
constraint define 137 l2.growth_country34 = l3.growth_country34
constraint define 138 l2.growth_country35 = l3.growth_country35
constraint define 139 l2.growth_country37 = l3.growth_country37
constraint define 140 l2.growth_country38 = l3.growth_country38
constraint define 141 l2.growth_country39 = l3.growth_country39
constraint define 14 l2.growth_country42 = l3.growth_country42
constraint define 143 l2.growth_country44 = l3.growth_country44
constraint define 144 l2.growth_country45 = l3.growth_country45
constraint define 145 l2.growth_country46 = l3.growth_country46
constraint define 146 l2.growth_country47 = l3.growth_country47
constraint define 147 l2.growth_country48 = l3.growth_country48
constraint define 148 l2.growth_country49 = l3.growth_country49
constraint define 149 l2.growth_country50 = l3.growth_country50
constraint define 150 l2.growth_country55 = l3.growth_country55
constraint define 151 l2.growth_country56 = l3.growth_country56
constraint define 152 l2.growth_country57 = l3.growth_country57
constraint define 153 l2.growth_country58 = l3.growth_country58
constraint define 154 l2.growth_country54 = l3.growth_country54
constraint define 155 l2.growth_country61 = l3.growth_country61
constraint define 156 l2.growth_country63 = l3.growth_country63
constraint define 157 l2.growth_country64 = l3.growth_country64
constraint define 158 l2.growth_country65 = l3.growth_country65
constraint define 159 l2.growth_country66 = l3.growth_country66
constraint define 160 l2.growth_country67 = l3.growth_country67
constraint define 161 l2.growth_country69 = l3.growth_country69
constraint define 162 l2.growth_country70 = l3.growth_country70
constraint define 163 l2.growth_country71 = l3.growth_country71
constraint define 164 l2.growth_country73 = l3.growth_country73
constraint define 165 l2.growth_country74 = l3.growth_country74
constraint define 166 l2.growth_country75 = l3.growth_country75
constraint define 167 l2.growth_country76 = l3.growth_country76
constraint define 168 l2.growth_country77 = l3.growth_country77
constraint define 169 l2.growth_country78 = l3.growth_country78
constraint define 170 l2.growth_country79 = l3.growth_country79
constraint define 171 l2.growth_country81 = l3.growth_country81
constraint define 172 l2.growth_country82 = l3.growth_country82
constraint define 173 l2.growth_country83 = l3.growth_country83
constraint define 174 l2.growth_country85 = l3.growth_country85
constraint define 175 l2.growth_country86 = l3.growth_country86
constraint define 176 l2.growth_country88 = l3.growth_country88
constraint define 177 l2.growth_country90 = l3.growth_country90
constraint define 178 l2.growth_country91 = l3.growth_country91
constraint define 179 l2.growth_country92 = l3.growth_country92
constraint define 180 l2.growth_country93 = l3.growth_country93
constraint define 181 l2.growth_country98 = l3.growth_country98
constraint define 182 l2.growth_country100 = l3.growth_country100
constraint define 183 l2.growth_country101 = l3.growth_country101
constraint define 184 l2.growth_country102 = l3.growth_country102
constraint define 185 l2.growth_country103 = l3.growth_country103
constraint define 186 l2.growth_country105 = l3.growth_country105
constraint define 187 l2.growth_country106 = l3.growth_country106
constraint define 188 l2.growth_country108 = l3.growth_country108
constraint define 189 l2.growth_country109 = l3.growth_country109
constraint define 190 l2.growth_country110 = l3.growth_country110
constraint define 191 l2.growth_country111 = l3.growth_country111
constraint define 192 l2.growth_country112 = l3.growth_country112
constraint define 193 l2.growth_country113 = l3.growth_country113
constraint define 194 l2.growth_country114 = l3.growth_country114
constraint define 195 l2.growth_country115 = l3.growth_country115
constraint define 196 l2.growth_country116 = l3.growth_country116
constraint define 197 l2.growth_country117 = l3.growth_country117
constraint define 198 l2.growth_country118 = l3.growth_country118
constraint define 199 l2.growth_country119 = l3.growth_country119
constraint define 200 l2.growth_country120 = l3.growth_country120
constraint define 201 l2.growth_country121 = l3.growth_country121
constraint define 202 l2.growth_country122 = l3.growth_country122
constraint define 203 l2.growth_country123 = l3.growth_country123
constraint define 204 l2.growth_country124 = l3.growth_country124
constraint define 205 l2.growth_country127 = l3.growth_country127
constraint define 206 l2.growth_country128 = l3.growth_country128
constraint define 207 l2.growth_country130 = l3.growth_country130
constraint define 208 l2.growth_country133 = l3.growth_country133
constraint define 209 l2.growth_country134 = l3.growth_country134
constraint define 210 l2.growth_country135 = l3.growth_country135
constraint define 211 l2.growth_country136 = l3.growth_country136
constraint define 212 l2.growth_country137 = l3.growth_country137
constraint define 213 l2.growth_country139 = l3.growth_country139
constraint define 214 l2.growth_country140 = l3.growth_country140
constraint define 215 l2.growth_country141 = l3.growth_country141
constraint define 216 l2.growth_country142 = l3.growth_country142
constraint define 217 l2.growth_country144 = l3.growth_country144
constraint define 218 l2.growth_country146 = l3.growth_country146
constraint define 219 l2.growth_country147 = l3.growth_country147
constraint define 220 l2.growth_country148 = l3.growth_country148
constraint define 220 l2.growth_country149 = l3.growth_country149
constraint define 221 l2.growth_country150 = l3.growth_country150
constraint define 222 l2.growth_country151 = l3.growth_country151
constraint define 223 l2.growth_country152 = l3.growth_country152
constraint define 224 l2.growth_country153 = l3.growth_country153
constraint define 225 l2.growth_country154 = l3.growth_country154
constraint define 226 l2.growth_country156 = l3.growth_country156
constraint define 227 l2.growth_country157 = l3.growth_country157
constraint define 228 l2.growth_country159 = l3.growth_country159
constraint define 229 l2.growth_country162 = l3.growth_country162
constraint define 230 l2.growth_country163 = l3.growth_country163

cnsreg attacks l.attacks l2.attacks l3.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 l2.growth_country1 l2.growth_country2 l2.growth_country3 l2.growth_country4 l2.growth_country5 l2.growth_country7 l2.growth_country8 l2.growth_country12 l2.growth_country13 l2.growth_country15 l2.growth_country20 l2.growth_country22 l2.growth_country23 l2.growth_country25 l2.growth_country26 l2.growth_country28 l2.growth_country30 l2.growth_country31 l2.growth_country32 l2.growth_country33 l2.growth_country34 l2.growth_country35 l2.growth_country37 l2.growth_country38 l2.growth_country39 l2.growth_country42 l2.growth_country44 l2.growth_country45 l2.growth_country46 l2.growth_country47 l2.growth_country48 l2.growth_country49 l2.growth_country50 l2.growth_country55 l2.growth_country56 l2.growth_country57 l2.growth_country58 l2.growth_country54 l2.growth_country61 l2.growth_country63 l2.growth_country64 l2.growth_country65 l2.growth_country66 l2.growth_country67 l2.growth_country69 l2.growth_country70 l2.growth_country71 l2.growth_country73 l2.growth_country74 l2.growth_country75 l2.growth_country76 l2.growth_country77 l2.growth_country78 l2.growth_country79 l2.growth_country81 l2.growth_country82 l2.growth_country83 l2.growth_country85 l2.growth_country86 l2.growth_country88 l2.growth_country90 l2.growth_country91 l2.growth_country92 l2.growth_country93 l2.growth_country98 l2.growth_country100 l2.growth_country101 l2.growth_country102 l2.growth_country103 l2.growth_country105 l2.growth_country106 l2.growth_country108 l2.growth_country109 l2.growth_country110 l2.growth_country111 l2.growth_country112 l2.growth_country113 l2.growth_country114 l2.growth_country115 l2.growth_country116 l2.growth_country117 l2.growth_country118 l2.growth_country119 l2.growth_country120 l2.growth_country121 l2.growth_country122 l2.growth_country123 l2.growth_country124 l2.growth_country127 l2.growth_country128 l2.growth_country130 l2.growth_country133 l2.growth_country134 l2.growth_country135 l2.growth_country136 l2.growth_country137 l2.growth_country139 l2.growth_country140 l2.growth_country141 l2.growth_country142 l2.growth_country144 l2.growth_country146 l2.growth_country147 l2.growth_country148 l2.growth_country149 l2.growth_country150 l2.growth_country151 l2.growth_country152 l2.growth_country153 l2.growth_country154 l2.growth_country156 l2.growth_country157 l2.growth_country159 l2.growth_country162 l2.growth_country163 l3.growth_country1 l3.growth_country2 l3.growth_country3 l3.growth_country4 l3.growth_country5 l3.growth_country7 l3.growth_country8 l3.growth_country12 l3.growth_country13 l3.growth_country15 l3.growth_country20 l3.growth_country22 l3.growth_country23 l3.growth_country25 l3.growth_country26 l3.growth_country28 l3.growth_country30 l3.growth_country31 l3.growth_country32 l3.growth_country33 l3.growth_country34 l3.growth_country35 l3.growth_country37 l3.growth_country38 l3.growth_country39 l3.growth_country42 l3.growth_country44 l3.growth_country45 l3.growth_country46 l3.growth_country47 l3.growth_country48 l3.growth_country49 l3.growth_country50 l3.growth_country55 l3.growth_country56 l3.growth_country57 l3.growth_country58 l3.growth_country54 l3.growth_country61 l3.growth_country63 l3.growth_country64 l3.growth_country65 l3.growth_country66 l3.growth_country67 l3.growth_country69 l3.growth_country70 l3.growth_country71 l3.growth_country73 l3.growth_country74 l3.growth_country75 l3.growth_country76 l3.growth_country77 l3.growth_country78 l3.growth_country79 l3.growth_country81 l3.growth_country82 l3.growth_country83 l3.growth_country85 l3.growth_country86 l3.growth_country88 l3.growth_country90 l3.growth_country91 l3.growth_country92 l3.growth_country93 l3.growth_country98 l3.growth_country100 l3.growth_country101 l3.growth_country102 l3.growth_country103 l3.growth_country105 l3.growth_country106 l3.growth_country108 l3.growth_country109 l3.growth_country110 l3.growth_country111 l3.growth_country112 l3.growth_country113 l3.growth_country114 l3.growth_country115 l3.growth_country116 l3.growth_country117 l3.growth_country118 l3.growth_country119 l3.growth_country120 l3.growth_country121 l3.growth_country122 l3.growth_country123 l3.growth_country124 l3.growth_country127 l3.growth_country128 l3.growth_country130 l3.growth_country133 l3.growth_country134 l3.growth_country135 l3.growth_country136 l3.growth_country137 l3.growth_country139 l3.growth_country140 l3.growth_country141 l3.growth_country142 l3.growth_country144 l3.growth_country146 l3.growth_country147 l3.growth_country148 l3.growth_country149 l3.growth_country150 l3.growth_country151 l3.growth_country152 l3.growth_country153 l3.growth_country154 l3.growth_country156 l3.growth_country157 l3.growth_country159 l3.growth_country162 l3.growth_country163 countrydummy*, noconstant constraints(1-230)

di "RSS: " (`e(rmse)')^2*`e(df_r)' "."

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from Growth to TV (First Lag)

reg victims l.victims countrydummy*, noconstant notable

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Store the needed data from both regression analysis (N*T, RSS1, RSS2) as given in the main text and calculate the F-statistic

*** Non-Causality from Growth to TV (Second Lag, Constrained Regression)

reg victims l.victims l2.victims countrydummy*, noconstant notable

cnsreg victims l.victims l2.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 l2.growth_country1 l2.growth_country2 l2.growth_country3 l2.growth_country4 l2.growth_country5 l2.growth_country7 l2.growth_country8 l2.growth_country12 l2.growth_country13 l2.growth_country15 l2.growth_country20 l2.growth_country22 l2.growth_country23 l2.growth_country25 l2.growth_country26 l2.growth_country28 l2.growth_country30 l2.growth_country31 l2.growth_country32 l2.growth_country33 l2.growth_country34 l2.growth_country35 l2.growth_country37 l2.growth_country38 l2.growth_country39 l2.growth_country42 l2.growth_country44 l2.growth_country45 l2.growth_country46 l2.growth_country47 l2.growth_country48 l2.growth_country49 l2.growth_country50 l2.growth_country55 l2.growth_country56 l2.growth_country57 l2.growth_country58 l2.growth_country54 l2.growth_country61 l2.growth_country63 l2.growth_country64 l2.growth_country65 l2.growth_country66 l2.growth_country67 l2.growth_country69 l2.growth_country70 l2.growth_country71 l2.growth_country73 l2.growth_country74 l2.growth_country75 l2.growth_country76 l2.growth_country77 l2.growth_country78 l2.growth_country79 l2.growth_country81 l2.growth_country82 l2.growth_country83 l2.growth_country85 l2.growth_country86 l2.growth_country88 l2.growth_country90 l2.growth_country91 l2.growth_country92 l2.growth_country93 l2.growth_country98 l2.growth_country100 l2.growth_country101 l2.growth_country102 l2.growth_country103 l2.growth_country105 l2.growth_country106 l2.growth_country108 l2.growth_country109 l2.growth_country110 l2.growth_country111 l2.growth_country112 l2.growth_country113 l2.growth_country114 l2.growth_country115 l2.growth_country116 l2.growth_country117 l2.growth_country118 l2.growth_country119 l2.growth_country120 l2.growth_country121 l2.growth_country122 l2.growth_country123 l2.growth_country124 l2.growth_country127 l2.growth_country128 l2.growth_country130 l2.growth_country133 l2.growth_country134 l2.growth_country135 l2.growth_country136 l2.growth_country137 l2.growth_country139 l2.growth_country140 l2.growth_country141 l2.growth_country142 l2.growth_country144 l2.growth_country146 l2.growth_country147 l2.growth_country148 l2.growth_country149 l2.growth_country150 l2.growth_country151 l2.growth_country152 l2.growth_country153 l2.growth_country154 l2.growth_country156 l2.growth_country157 l2.growth_country159 l2.growth_country162 l2.growth_country163 countrydummy*, noconstant constraints(1-115)

di "RSS: " (`e(rmse)')^2*`e(df_r)' "."

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from Growth to TV (Third Lag, Constrained Regression)

reg victims l.victims l2.victims l3.victims countrydummy*, noconstant notable

cnsreg victims l.victims l2.victims l3.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 l2.growth_country1 l2.growth_country2 l2.growth_country3 l2.growth_country4 l2.growth_country5 l2.growth_country7 l2.growth_country8 l2.growth_country12 l2.growth_country13 l2.growth_country15 l2.growth_country20 l2.growth_country22 l2.growth_country23 l2.growth_country25 l2.growth_country26 l2.growth_country28 l2.growth_country30 l2.growth_country31 l2.growth_country32 l2.growth_country33 l2.growth_country34 l2.growth_country35 l2.growth_country37 l2.growth_country38 l2.growth_country39 l2.growth_country42 l2.growth_country44 l2.growth_country45 l2.growth_country46 l2.growth_country47 l2.growth_country48 l2.growth_country49 l2.growth_country50 l2.growth_country55 l2.growth_country56 l2.growth_country57 l2.growth_country58 l2.growth_country54 l2.growth_country61 l2.growth_country63 l2.growth_country64 l2.growth_country65 l2.growth_country66 l2.growth_country67 l2.growth_country69 l2.growth_country70 l2.growth_country71 l2.growth_country73 l2.growth_country74 l2.growth_country75 l2.growth_country76 l2.growth_country77 l2.growth_country78 l2.growth_country79 l2.growth_country81 l2.growth_country82 l2.growth_country83 l2.growth_country85 l2.growth_country86 l2.growth_country88 l2.growth_country90 l2.growth_country91 l2.growth_country92 l2.growth_country93 l2.growth_country98 l2.growth_country100 l2.growth_country101 l2.growth_country102 l2.growth_country103 l2.growth_country105 l2.growth_country106 l2.growth_country108 l2.growth_country109 l2.growth_country110 l2.growth_country111 l2.growth_country112 l2.growth_country113 l2.growth_country114 l2.growth_country115 l2.growth_country116 l2.growth_country117 l2.growth_country118 l2.growth_country119 l2.growth_country120 l2.growth_country121 l2.growth_country122 l2.growth_country123 l2.growth_country124 l2.growth_country127 l2.growth_country128 l2.growth_country130 l2.growth_country133 l2.growth_country134 l2.growth_country135 l2.growth_country136 l2.growth_country137 l2.growth_country139 l2.growth_country140 l2.growth_country141 l2.growth_country142 l2.growth_country144 l2.growth_country146 l2.growth_country147 l2.growth_country148 l2.growth_country149 l2.growth_country150 l2.growth_country151 l2.growth_country152 l2.growth_country153 l2.growth_country154 l2.growth_country156 l2.growth_country157 l2.growth_country159 l2.growth_country162 l2.growth_country163 l3.growth_country1 l3.growth_country2 l3.growth_country3 l3.growth_country4 l3.growth_country5 l3.growth_country7 l3.growth_country8 l3.growth_country12 l3.growth_country13 l3.growth_country15 l3.growth_country20 l3.growth_country22 l3.growth_country23 l3.growth_country25 l3.growth_country26 l3.growth_country28 l3.growth_country30 l3.growth_country31 l3.growth_country32 l3.growth_country33 l3.growth_country34 l3.growth_country35 l3.growth_country37 l3.growth_country38 l3.growth_country39 l3.growth_country42 l3.growth_country44 l3.growth_country45 l3.growth_country46 l3.growth_country47 l3.growth_country48 l3.growth_country49 l3.growth_country50 l3.growth_country55 l3.growth_country56 l3.growth_country57 l3.growth_country58 l3.growth_country54 l3.growth_country61 l3.growth_country63 l3.growth_country64 l3.growth_country65 l3.growth_country66 l3.growth_country67 l3.growth_country69 l3.growth_country70 l3.growth_country71 l3.growth_country73 l3.growth_country74 l3.growth_country75 l3.growth_country76 l3.growth_country77 l3.growth_country78 l3.growth_country79 l3.growth_country81 l3.growth_country82 l3.growth_country83 l3.growth_country85 l3.growth_country86 l3.growth_country88 l3.growth_country90 l3.growth_country91 l3.growth_country92 l3.growth_country93 l3.growth_country98 l3.growth_country100 l3.growth_country101 l3.growth_country102 l3.growth_country103 l3.growth_country105 l3.growth_country106 l3.growth_country108 l3.growth_country109 l3.growth_country110 l3.growth_country111 l3.growth_country112 l3.growth_country113 l3.growth_country114 l3.growth_country115 l3.growth_country116 l3.growth_country117 l3.growth_country118 l3.growth_country119 l3.growth_country120 l3.growth_country121 l3.growth_country122 l3.growth_country123 l3.growth_country124 l3.growth_country127 l3.growth_country128 l3.growth_country130 l3.growth_country133 l3.growth_country134 l3.growth_country135 l3.growth_country136 l3.growth_country137 l3.growth_country139 l3.growth_country140 l3.growth_country141 l3.growth_country142 l3.growth_country144 l3.growth_country146 l3.growth_country147 l3.growth_country148 l3.growth_country149 l3.growth_country150 l3.growth_country151 l3.growth_country152 l3.growth_country153 l3.growth_country154 l3.growth_country156 l3.growth_country157 l3.growth_country159 l3.growth_country162 l3.growth_country163 countrydummy*, noconstant constraints(1-230)

di "RSS: " (`e(rmse)')^2*`e(df_r)' "."

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from TA to Growth (First Lag)

reg growth l.growth countrydummy*, noconstant notable

reg growth l.growth l.attacks_country1 l.attacks_country2 l.attacks_country3 l.attacks_country4 l.attacks_country5 l.attacks_country7 l.attacks_country8 l.attacks_country12 l.attacks_country13 l.attacks_country15 l.attacks_country20 l.attacks_country22 l.attacks_country23 l.attacks_country25 l.attacks_country26 l.attacks_country28 l.attacks_country30 l.attacks_country31 l.attacks_country32 l.attacks_country33 l.attacks_country34 l.attacks_country35 l.attacks_country37 l.attacks_country38 l.attacks_country39 l.attacks_country42 l.attacks_country44 l.attacks_country45 l.attacks_country46 l.attacks_country47 l.attacks_country48 l.attacks_country49 l.attacks_country50 l.attacks_country55 l.attacks_country56 l.attacks_country57 l.attacks_country58 l.attacks_country54 l.attacks_country61 l.attacks_country63 l.attacks_country64 l.attacks_country65 l.attacks_country66 l.attacks_country67 l.attacks_country69 l.attacks_country70 l.attacks_country71 l.attacks_country73 l.attacks_country74 l.attacks_country75 l.attacks_country76 l.attacks_country77 l.attacks_country78 l.attacks_country79 l.attacks_country81 l.attacks_country82 l.attacks_country83 l.attacks_country85 l.attacks_country86 l.attacks_country88 l.attacks_country90 l.attacks_country91 l.attacks_country92 l.attacks_country93 l.attacks_country98 l.attacks_country100 l.attacks_country101 l.attacks_country102 l.attacks_country103 l.attacks_country105 l.attacks_country106 l.attacks_country108 l.attacks_country109 l.attacks_country110 l.attacks_country111 l.attacks_country112 l.attacks_country113 l.attacks_country114 l.attacks_country115 l.attacks_country116 l.attacks_country117 l.attacks_country118 l.attacks_country119 l.attacks_country120 l.attacks_country121 l.attacks_country122 l.attacks_country123 l.attacks_country124 l.attacks_country127 l.attacks_country128 l.attacks_country130 l.attacks_country133 l.attacks_country134 l.attacks_country135 l.attacks_country136 l.attacks_country137 l.attacks_country139 l.attacks_country140 l.attacks_country141 l.attacks_country142 l.attacks_country144 l.attacks_country146 l.attacks_country147 l.attacks_country148 l.attacks_country149 l.attacks_country150 l.attacks_country151 l.attacks_country152 l.attacks_country153 l.attacks_country154 l.attacks_country156 l.attacks_country157 l.attacks_country159 l.attacks_country162 l.attacks_country163 countrydummy*, noconstant notable

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from TA to Growth (Second Lag, Constrained Regression)

reg growth l.growth l2.growth countrydummy*, noconstant notable

constraint define 1 l.attacks_country1 = l2.attacks_country1
constraint define 2 l.attacks_country2 = l2.attacks_country2
constraint define 3 l.attacks_country3 = l2.attacks_country3
constraint define 4 l.attacks_country4 = l2.attacks_country4
constraint define 5 l.attacks_country5 = l2.attacks_country5
constraint define 6 l.attacks_country7 = l2.attacks_country7
constraint define 7 l.attacks_country8 = l2.attacks_country8
constraint define 8 l.attacks_country12 = l2.attacks_country12
constraint define 9 l.attacks_country13 = l2.attacks_country13
constraint define 10 l.attacks_country15 = l2.attacks_country15
constraint define 11 l.attacks_country20 = l2.attacks_country20
constraint define 12 l.attacks_country22 = l2.attacks_country22
constraint define 13 l.attacks_country23 = l2.attacks_country23
constraint define 14 l.attacks_country25 = l2.attacks_country25
constraint define 15 l.attacks_country26 = l2.attacks_country26
constraint define 16 l.attacks_country28 = l2.attacks_country28
constraint define 17 l.attacks_country30 = l2.attacks_country30
constraint define 18 l.attacks_country31 = l2.attacks_country31
constraint define 19 l.attacks_country32 = l2.attacks_country32
constraint define 20 l.attacks_country33 = l2.attacks_country33
constraint define 21 l.attacks_country34 = l2.attacks_country34
constraint define 22 l.attacks_country35 = l2.attacks_country35
constraint define 23 l.attacks_country37 = l2.attacks_country37
constraint define 24 l.attacks_country38 = l2.attacks_country38
constraint define 25 l.attacks_country39 = l2.attacks_country39
constraint define 26 l.attacks_country42 = l2.attacks_country42
constraint define 27 l.attacks_country44 = l2.attacks_country44
constraint define 28 l.attacks_country45 = l2.attacks_country45
constraint define 29 l.attacks_country46 = l2.attacks_country46
constraint define 30 l.attacks_country47 = l2.attacks_country47
constraint define 31 l.attacks_country48 = l2.attacks_country48
constraint define 32 l.attacks_country49 = l2.attacks_country49
constraint define 33 l.attacks_country50 = l2.attacks_country50
constraint define 34 l.attacks_country55 = l2.attacks_country55
constraint define 35 l.attacks_country56 = l2.attacks_country56
constraint define 36 l.attacks_country57 = l2.attacks_country57
constraint define 37 l.attacks_country58 = l2.attacks_country58
constraint define 38 l.attacks_country54 = l2.attacks_country54
constraint define 39 l.attacks_country61 = l2.attacks_country61
constraint define 40 l.attacks_country63 = l2.attacks_country63
constraint define 41 l.attacks_country64 = l2.attacks_country64
constraint define 42 l.attacks_country65 = l2.attacks_country65
constraint define 43 l.attacks_country66 = l2.attacks_country66
constraint define 44 l.attacks_country67 = l2.attacks_country67
constraint define 45 l.attacks_country69 = l2.attacks_country69
constraint define 46 l.attacks_country70 = l2.attacks_country70
constraint define 47 l.attacks_country71 = l2.attacks_country71
constraint define 48 l.attacks_country73 = l2.attacks_country73
constraint define 49 l.attacks_country74 = l2.attacks_country74
constraint define 50 l.attacks_country75 = l2.attacks_country75
constraint define 51 l.attacks_country76 = l2.attacks_country76
constraint define 52 l.attacks_country77 = l2.attacks_country77
constraint define 53 l.attacks_country78 = l2.attacks_country78
constraint define 54 l.attacks_country79 = l2.attacks_country79
constraint define 55 l.attacks_country81 = l2.attacks_country81
constraint define 56 l.attacks_country82 = l2.attacks_country82
constraint define 57 l.attacks_country83 = l2.attacks_country83
constraint define 58 l.attacks_country85 = l2.attacks_country85
constraint define 59 l.attacks_country86 = l2.attacks_country86
constraint define 60 l.attacks_country88 = l2.attacks_country88
constraint define 61 l.attacks_country90 = l2.attacks_country90
constraint define 62 l.attacks_country91 = l2.attacks_country91
constraint define 63 l.attacks_country92 = l2.attacks_country92
constraint define 64 l.attacks_country93 = l2.attacks_country93
constraint define 65 l.attacks_country98 = l2.attacks_country98
constraint define 66 l.attacks_country100 = l2.attacks_country100
constraint define 67 l.attacks_country101 = l2.attacks_country101
constraint define 68 l.attacks_country102 = l2.attacks_country102
constraint define 69 l.attacks_country103 = l2.attacks_country103
constraint define 70 l.attacks_country105 = l2.attacks_country105
constraint define 71 l.attacks_country106 = l2.attacks_country106
constraint define 72 l.attacks_country108 = l2.attacks_country108
constraint define 73 l.attacks_country109 = l2.attacks_country109
constraint define 74 l.attacks_country110 = l2.attacks_country110
constraint define 75 l.attacks_country111 = l2.attacks_country111
constraint define 76 l.attacks_country112 = l2.attacks_country112
constraint define 77 l.attacks_country113 = l2.attacks_country113
constraint define 78 l.attacks_country114 = l2.attacks_country114
constraint define 79 l.attacks_country115 = l2.attacks_country115
constraint define 80 l.attacks_country116 = l2.attacks_country116
constraint define 81 l.attacks_country117 = l2.attacks_country117
constraint define 82 l.attacks_country118 = l2.attacks_country118
constraint define 83 l.attacks_country119 = l2.attacks_country119
constraint define 84 l.attacks_country120 = l2.attacks_country120
constraint define 85 l.attacks_country121 = l2.attacks_country121
constraint define 86 l.attacks_country122 = l2.attacks_country122
constraint define 87 l.attacks_country123 = l2.attacks_country123
constraint define 88 l.attacks_country124 = l2.attacks_country124
constraint define 89 l.attacks_country127 = l2.attacks_country127
constraint define 90 l.attacks_country128 = l2.attacks_country128
constraint define 91 l.attacks_country130 = l2.attacks_country130
constraint define 92 l.attacks_country133 = l2.attacks_country133
constraint define 93 l.attacks_country134 = l2.attacks_country134
constraint define 94 l.attacks_country135 = l2.attacks_country135
constraint define 95 l.attacks_country136 = l2.attacks_country136
constraint define 96 l.attacks_country137 = l2.attacks_country137
constraint define 97 l.attacks_country139 = l2.attacks_country139
constraint define 98 l.attacks_country140 = l2.attacks_country140
constraint define 99 l.attacks_country141 = l2.attacks_country141
constraint define 100 l.attacks_country142 = l2.attacks_country142
constraint define 101 l.attacks_country144 = l2.attacks_country144
constraint define 102 l.attacks_country146 = l2.attacks_country146
constraint define 103 l.attacks_country147 = l2.attacks_country147
constraint define 104 l.attacks_country148 = l2.attacks_country148
constraint define 105 l.attacks_country149 = l2.attacks_country149
constraint define 106 l.attacks_country150 = l2.attacks_country150
constraint define 107 l.attacks_country151 = l2.attacks_country151
constraint define 108 l.attacks_country152 = l2.attacks_country152
constraint define 109 l.attacks_country153 = l2.attacks_country153
constraint define 110 l.attacks_country154 = l2.attacks_country154
constraint define 111 l.attacks_country156 = l2.attacks_country156
constraint define 112 l.attacks_country157 = l2.attacks_country157
constraint define 113 l.attacks_country159 = l2.attacks_country159
constraint define 114 l.attacks_country162 = l2.attacks_country162
constraint define 115 l.attacks_country163 = l2.attacks_country163

cnsreg growth l.growth l2.growth l.attacks_country1 l.attacks_country2 l.attacks_country3 l.attacks_country4 l.attacks_country5 l.attacks_country7 l.attacks_country8 l.attacks_country12 l.attacks_country13 l.attacks_country15 l.attacks_country20 l.attacks_country22 l.attacks_country23 l.attacks_country25 l.attacks_country26 l.attacks_country28 l.attacks_country30 l.attacks_country31 l.attacks_country32 l.attacks_country33 l.attacks_country34 l.attacks_country35 l.attacks_country37 l.attacks_country38 l.attacks_country39 l.attacks_country42 l.attacks_country44 l.attacks_country45 l.attacks_country46 l.attacks_country47 l.attacks_country48 l.attacks_country49 l.attacks_country50 l.attacks_country55 l.attacks_country56 l.attacks_country57 l.attacks_country58 l.attacks_country54 l.attacks_country61 l.attacks_country63 l.attacks_country64 l.attacks_country65 l.attacks_country66 l.attacks_country67 l.attacks_country69 l.attacks_country70 l.attacks_country71 l.attacks_country73 l.attacks_country74 l.attacks_country75 l.attacks_country76 l.attacks_country77 l.attacks_country78 l.attacks_country79 l.attacks_country81 l.attacks_country82 l.attacks_country83 l.attacks_country85 l.attacks_country86 l.attacks_country88 l.attacks_country90 l.attacks_country91 l.attacks_country92 l.attacks_country93 l.attacks_country98 l.attacks_country100 l.attacks_country101 l.attacks_country102 l.attacks_country103 l.attacks_country105 l.attacks_country106 l.attacks_country108 l.attacks_country109 l.attacks_country110 l.attacks_country111 l.attacks_country112 l.attacks_country113 l.attacks_country114 l.attacks_country115 l.attacks_country116 l.attacks_country117 l.attacks_country118 l.attacks_country119 l.attacks_country120 l.attacks_country121 l.attacks_country122 l.attacks_country123 l.attacks_country124 l.attacks_country127 l.attacks_country128 l.attacks_country130 l.attacks_country133 l.attacks_country134 l.attacks_country135 l.attacks_country136 l.attacks_country137 l.attacks_country139 l.attacks_country140 l.attacks_country141 l.attacks_country142 l.attacks_country144 l.attacks_country146 l.attacks_country147 l.attacks_country148 l.attacks_country149 l.attacks_country150 l.attacks_country151 l.attacks_country152 l.attacks_country153 l.attacks_country154 l.attacks_country156 l.attacks_country157 l.attacks_country159 l.attacks_country162 l.attacks_country163 l2.attacks_country1 l2.attacks_country2 l2.attacks_country3 l2.attacks_country4 l2.attacks_country5 l2.attacks_country7 l2.attacks_country8 l2.attacks_country12 l2.attacks_country13 l2.attacks_country15 l2.attacks_country20 l2.attacks_country22 l2.attacks_country23 l2.attacks_country25 l2.attacks_country26 l2.attacks_country28 l2.attacks_country30 l2.attacks_country31 l2.attacks_country32 l2.attacks_country33 l2.attacks_country34 l2.attacks_country35 l2.attacks_country37 l2.attacks_country38 l2.attacks_country39 l2.attacks_country42 l2.attacks_country44 l2.attacks_country45 l2.attacks_country46 l2.attacks_country47 l2.attacks_country48 l2.attacks_country49 l2.attacks_country50 l2.attacks_country55 l2.attacks_country56 l2.attacks_country57 l2.attacks_country58 l2.attacks_country54 l2.attacks_country61 l2.attacks_country63 l2.attacks_country64 l2.attacks_country65 l2.attacks_country66 l2.attacks_country67 l2.attacks_country69 l2.attacks_country70 l2.attacks_country71 l2.attacks_country73 l2.attacks_country74 l2.attacks_country75 l2.attacks_country76 l2.attacks_country77 l2.attacks_country78 l2.attacks_country79 l2.attacks_country81 l2.attacks_country82 l2.attacks_country83 l2.attacks_country85 l2.attacks_country86 l2.attacks_country88 l2.attacks_country90 l2.attacks_country91 l2.attacks_country92 l2.attacks_country93 l2.attacks_country98 l2.attacks_country100 l2.attacks_country101 l2.attacks_country102 l2.attacks_country103 l2.attacks_country105 l2.attacks_country106 l2.attacks_country108 l2.attacks_country109 l2.attacks_country110 l2.attacks_country111 l2.attacks_country112 l2.attacks_country113 l2.attacks_country114 l2.attacks_country115 l2.attacks_country116 l2.attacks_country117 l2.attacks_country118 l2.attacks_country119 l2.attacks_country120 l2.attacks_country121 l2.attacks_country122 l2.attacks_country123 l2.attacks_country124 l2.attacks_country127 l2.attacks_country128 l2.attacks_country130 l2.attacks_country133 l2.attacks_country134 l2.attacks_country135 l2.attacks_country136 l2.attacks_country137 l2.attacks_country139 l2.attacks_country140 l2.attacks_country141 l2.attacks_country142 l2.attacks_country144 l2.attacks_country146 l2.attacks_country147 l2.attacks_country148 l2.attacks_country149 l2.attacks_country150 l2.attacks_country151 l2.attacks_country152 l2.attacks_country153 l2.attacks_country154 l2.attacks_country156 l2.attacks_country157 l2.attacks_country159 l2.attacks_country162 l2.attacks_country163 countrydummy*, noconstant constraints(1-115)

di "RSS: " (`e(rmse)')^2*`e(df_r)' "."

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from TA to Growth (Third Lag, Constrained Regression)

reg growth l.growth l2.growth l3.growth countrydummy*, noconstant notable

constraint define 117 l2.attacks_country1 = l3.attacks_country1
constraint define 118 l2.attacks_country2 = l3.attacks_country2
constraint define 119 l2.attacks_country3 = l3.attacks_country3
constraint define 120 l2.attacks_country4 = l3.attacks_country4
constraint define 121 l2.attacks_country5 = l3.attacks_country5
constraint define 122 l2.attacks_country7 = l3.attacks_country7
constraint define 123 l2.attacks_country8 = l3.attacks_country8
constraint define 124 l2.attacks_country12 = l3.attacks_country12
constraint define 125 l2.attacks_country13 = l3.attacks_country13
constraint define 126 l2.attacks_country15 = l3.attacks_country15
constraint define 127 l2.attacks_country20 = l3.attacks_country20
constraint define 128 l2.attacks_country22 = l3.attacks_country22
constraint define 129 l2.attacks_country23 = l3.attacks_country23
constraint define 130 l2.attacks_country25 = l3.attacks_country25
constraint define 131 l2.attacks_country26 = l3.attacks_country26
constraint define 132 l2.attacks_country28 = l3.attacks_country28
constraint define 133 l2.attacks_country30 = l3.attacks_country30
constraint define 134 l2.attacks_country31 = l3.attacks_country31
constraint define 135 l2.attacks_country32 = l3.attacks_country32
constraint define 136 l2.attacks_country33 = l3.attacks_country33
constraint define 137 l2.attacks_country34 = l3.attacks_country34
constraint define 138 l2.attacks_country35 = l3.attacks_country35
constraint define 139 l2.attacks_country37 = l3.attacks_country37
constraint define 140 l2.attacks_country38 = l3.attacks_country38
constraint define 141 l2.attacks_country39 = l3.attacks_country39
constraint define 142 l2.attacks_country42 = l3.attacks_country42
constraint define 143 l2.attacks_country44 = l3.attacks_country44
constraint define 144 l2.attacks_country45 = l3.attacks_country45
constraint define 145 l2.attacks_country46 = l3.attacks_country46
constraint define 146 l2.attacks_country47 = l3.attacks_country47
constraint define 147 l2.attacks_country48 = l3.attacks_country48
constraint define 148 l2.attacks_country49 = l3.attacks_country49
constraint define 149 l2.attacks_country50 = l3.attacks_country50
constraint define 150 l2.attacks_country55 = l3.attacks_country55
constraint define 151 l2.attacks_country56 = l3.attacks_country56
constraint define 152 l2.attacks_country57 = l3.attacks_country57
constraint define 153 l2.attacks_country58 = l3.attacks_country58
constraint define 154 l2.attacks_country54 = l3.attacks_country54
constraint define 155 l2.attacks_country61 = l3.attacks_country61
constraint define 156 l2.attacks_country63 = l3.attacks_country63
constraint define 157 l2.attacks_country64 = l3.attacks_country64
constraint define 158 l2.attacks_country65 = l3.attacks_country65
constraint define 159 l2.attacks_country66 = l3.attacks_country66
constraint define 160 l2.attacks_country67 = l3.attacks_country67
constraint define 161 l2.attacks_country69 = l3.attacks_country69
constraint define 162 l2.attacks_country70 = l3.attacks_country70
constraint define 163 l2.attacks_country71 = l3.attacks_country71
constraint define 164 l2.attacks_country73 = l3.attacks_country73
constraint define 165 l2.attacks_country74 = l3.attacks_country74
constraint define 166 l2.attacks_country75 = l3.attacks_country75
constraint define 167 l2.attacks_country76 = l3.attacks_country76
constraint define 168 l2.attacks_country77 = l3.attacks_country77
constraint define 169 l2.attacks_country78 = l3.attacks_country78
constraint define 170 l2.attacks_country79 = l3.attacks_country79
constraint define 171 l2.attacks_country81 = l3.attacks_country81
constraint define 172 l2.attacks_country82 = l3.attacks_country82
constraint define 173 l2.attacks_country83 = l3.attacks_country83
constraint define 174 l2.attacks_country85 = l3.attacks_country85
constraint define 175 l2.attacks_country86 = l3.attacks_country86
constraint define 176 l2.attacks_country88 = l3.attacks_country88
constraint define 177 l2.attacks_country90 = l3.attacks_country90
constraint define 178 l2.attacks_country91 = l3.attacks_country91
constraint define 179 l2.attacks_country92 = l3.attacks_country92
constraint define 180 l2.attacks_country93 = l3.attacks_country93
constraint define 181 l2.attacks_country98 = l3.attacks_country98
constraint define 182 l2.attacks_country100 = l3.attacks_country100
constraint define 183 l2.attacks_country101 = l3.attacks_country101
constraint define 184 l2.attacks_country102 = l3.attacks_country102
constraint define 185 l2.attacks_country103 = l3.attacks_country103
constraint define 186 l2.attacks_country105 = l3.attacks_country105
constraint define 187 l2.attacks_country106 = l3.attacks_country106
constraint define 188 l2.attacks_country108 = l3.attacks_country108
constraint define 189 l2.attacks_country109 = l3.attacks_country109
constraint define 190 l2.attacks_country110 = l3.attacks_country110
constraint define 191 l2.attacks_country111 = l3.attacks_country111
constraint define 192 l2.attacks_country112 = l3.attacks_country112
constraint define 193 l2.attacks_country113 = l3.attacks_country113
constraint define 194 l2.attacks_country114 = l3.attacks_country114
constraint define 195 l2.attacks_country115 = l3.attacks_country115
constraint define 196 l2.attacks_country116 = l3.attacks_country116
constraint define 197 l2.attacks_country117 = l3.attacks_country117
constraint define 198 l2.attacks_country118 = l3.attacks_country118
constraint define 199 l2.attacks_country119 = l3.attacks_country119
constraint define 200 l2.attacks_country120 = l3.attacks_country120
constraint define 201 l2.attacks_country121 = l3.attacks_country121
constraint define 202 l2.attacks_country122 = l3.attacks_country122
constraint define 203 l2.attacks_country123 = l3.attacks_country123
constraint define 204 l2.attacks_country124 = l3.attacks_country124
constraint define 205 l2.attacks_country127 = l3.attacks_country127
constraint define 206 l2.attacks_country128 = l3.attacks_country128
constraint define 207 l2.attacks_country130 = l3.attacks_country130
constraint define 208 l2.attacks_country133 = l3.attacks_country133
constraint define 209 l2.attacks_country134 = l3.attacks_country134
constraint define 210 l2.attacks_country135 = l3.attacks_country135
constraint define 211 l2.attacks_country136 = l3.attacks_country136
constraint define 212 l2.attacks_country137 = l3.attacks_country137
constraint define 213 l2.attacks_country139 = l3.attacks_country139
constraint define 214 l2.attacks_country140 = l3.attacks_country140
constraint define 215 l2.attacks_country141 = l3.attacks_country141
constraint define 216 l2.attacks_country142 = l3.attacks_country142
constraint define 217 l2.attacks_country144 = l3.attacks_country144
constraint define 218 l2.attacks_country146 = l3.attacks_country146
constraint define 219 l2.attacks_country147 = l3.attacks_country147
constraint define 220 l2.attacks_country148 = l3.attacks_country148
constraint define 220 l2.attacks_country149 = l3.attacks_country149
constraint define 221 l2.attacks_country150 = l3.attacks_country150
constraint define 222 l2.attacks_country151 = l3.attacks_country151
constraint define 223 l2.attacks_country152 = l3.attacks_country152
constraint define 224 l2.attacks_country153 = l3.attacks_country153
constraint define 225 l2.attacks_country154 = l3.attacks_country154
constraint define 226 l2.attacks_country156 = l3.attacks_country156
constraint define 227 l2.attacks_country157 = l3.attacks_country157
constraint define 228 l2.attacks_country159 = l3.attacks_country159
constraint define 229 l2.attacks_country162 = l3.attacks_country162
constraint define 230 l2.attacks_country163 = l3.attacks_country163

cnsreg growth l.growth l2.growth l3.growth l.attacks_country1 l.attacks_country2 l.attacks_country3 l.attacks_country4 l.attacks_country5 l.attacks_country7 l.attacks_country8 l.attacks_country12 l.attacks_country13 l.attacks_country15 l.attacks_country20 l.attacks_country22 l.attacks_country23 l.attacks_country25 l.attacks_country26 l.attacks_country28 l.attacks_country30 l.attacks_country31 l.attacks_country32 l.attacks_country33 l.attacks_country34 l.attacks_country35 l.attacks_country37 l.attacks_country38 l.attacks_country39 l.attacks_country42 l.attacks_country44 l.attacks_country45 l.attacks_country46 l.attacks_country47 l.attacks_country48 l.attacks_country49 l.attacks_country50 l.attacks_country55 l.attacks_country56 l.attacks_country57 l.attacks_country58 l.attacks_country54 l.attacks_country61 l.attacks_country63 l.attacks_country64 l.attacks_country65 l.attacks_country66 l.attacks_country67 l.attacks_country69 l.attacks_country70 l.attacks_country71 l.attacks_country73 l.attacks_country74 l.attacks_country75 l.attacks_country76 l.attacks_country77 l.attacks_country78 l.attacks_country79 l.attacks_country81 l.attacks_country82 l.attacks_country83 l.attacks_country85 l.attacks_country86 l.attacks_country88 l.attacks_country90 l.attacks_country91 l.attacks_country92 l.attacks_country93 l.attacks_country98 l.attacks_country100 l.attacks_country101 l.attacks_country102 l.attacks_country103 l.attacks_country105 l.attacks_country106 l.attacks_country108 l.attacks_country109 l.attacks_country110 l.attacks_country111 l.attacks_country112 l.attacks_country113 l.attacks_country114 l.attacks_country115 l.attacks_country116 l.attacks_country117 l.attacks_country118 l.attacks_country119 l.attacks_country120 l.attacks_country121 l.attacks_country122 l.attacks_country123 l.attacks_country124 l.attacks_country127 l.attacks_country128 l.attacks_country130 l.attacks_country133 l.attacks_country134 l.attacks_country135 l.attacks_country136 l.attacks_country137 l.attacks_country139 l.attacks_country140 l.attacks_country141 l.attacks_country142 l.attacks_country144 l.attacks_country146 l.attacks_country147 l.attacks_country148 l.attacks_country149 l.attacks_country150 l.attacks_country151 l.attacks_country152 l.attacks_country153 l.attacks_country154 l.attacks_country156 l.attacks_country157 l.attacks_country159 l.attacks_country162 l.attacks_country163 l2.attacks_country1 l2.attacks_country2 l2.attacks_country3 l2.attacks_country4 l2.attacks_country5 l2.attacks_country7 l2.attacks_country8 l2.attacks_country12 l2.attacks_country13 l2.attacks_country15 l2.attacks_country20 l2.attacks_country22 l2.attacks_country23 l2.attacks_country25 l2.attacks_country26 l2.attacks_country28 l2.attacks_country30 l2.attacks_country31 l2.attacks_country32 l2.attacks_country33 l2.attacks_country34 l2.attacks_country35 l2.attacks_country37 l2.attacks_country38 l2.attacks_country39 l2.attacks_country42 l2.attacks_country44 l2.attacks_country45 l2.attacks_country46 l2.attacks_country47 l2.attacks_country48 l2.attacks_country49 l2.attacks_country50 l2.attacks_country55 l2.attacks_country56 l2.attacks_country57 l2.attacks_country58 l2.attacks_country54 l2.attacks_country61 l2.attacks_country63 l2.attacks_country64 l2.attacks_country65 l2.attacks_country66 l2.attacks_country67 l2.attacks_country69 l2.attacks_country70 l2.attacks_country71 l2.attacks_country73 l2.attacks_country74 l2.attacks_country75 l2.attacks_country76 l2.attacks_country77 l2.attacks_country78 l2.attacks_country79 l2.attacks_country81 l2.attacks_country82 l2.attacks_country83 l2.attacks_country85 l2.attacks_country86 l2.attacks_country88 l2.attacks_country90 l2.attacks_country91 l2.attacks_country92 l2.attacks_country93 l2.attacks_country98 l2.attacks_country100 l2.attacks_country101 l2.attacks_country102 l2.attacks_country103 l2.attacks_country105 l2.attacks_country106 l2.attacks_country108 l2.attacks_country109 l2.attacks_country110 l2.attacks_country111 l2.attacks_country112 l2.attacks_country113 l2.attacks_country114 l2.attacks_country115 l2.attacks_country116 l2.attacks_country117 l2.attacks_country118 l2.attacks_country119 l2.attacks_country120 l2.attacks_country121 l2.attacks_country122 l2.attacks_country123 l2.attacks_country124 l2.attacks_country127 l2.attacks_country128 l2.attacks_country130 l2.attacks_country133 l2.attacks_country134 l2.attacks_country135 l2.attacks_country136 l2.attacks_country137 l2.attacks_country139 l2.attacks_country140 l2.attacks_country141 l2.attacks_country142 l2.attacks_country144 l2.attacks_country146 l2.attacks_country147 l2.attacks_country148 l2.attacks_country149 l2.attacks_country150 l2.attacks_country151 l2.attacks_country152 l2.attacks_country153 l2.attacks_country154 l2.attacks_country156 l2.attacks_country157 l2.attacks_country159 l2.attacks_country162 l2.attacks_country163 l3.attacks_country1 l3.attacks_country2 l3.attacks_country3 l3.attacks_country4 l3.attacks_country5 l3.attacks_country7 l3.attacks_country8 l3.attacks_country12 l3.attacks_country13 l3.attacks_country15 l3.attacks_country20 l3.attacks_country22 l3.attacks_country23 l3.attacks_country25 l3.attacks_country26 l3.attacks_country28 l3.attacks_country30 l3.attacks_country31 l3.attacks_country32 l3.attacks_country33 l3.attacks_country34 l3.attacks_country35 l3.attacks_country37 l3.attacks_country38 l3.attacks_country39 l3.attacks_country42 l3.attacks_country44 l3.attacks_country45 l3.attacks_country46 l3.attacks_country47 l3.attacks_country48 l3.attacks_country49 l3.attacks_country50 l3.attacks_country55 l3.attacks_country56 l3.attacks_country57 l3.attacks_country58 l3.attacks_country54 l3.attacks_country61 l3.attacks_country63 l3.attacks_country64 l3.attacks_country65 l3.attacks_country66 l3.attacks_country67 l3.attacks_country69 l3.attacks_country70 l3.attacks_country71 l3.attacks_country73 l3.attacks_country74 l3.attacks_country75 l3.attacks_country76 l3.attacks_country77 l3.attacks_country78 l3.attacks_country79 l3.attacks_country81 l3.attacks_country82 l3.attacks_country83 l3.attacks_country85 l3.attacks_country86 l3.attacks_country88 l3.attacks_country90 l3.attacks_country91 l3.attacks_country92 l3.attacks_country93 l3.attacks_country98 l3.attacks_country100 l3.attacks_country101 l3.attacks_country102 l3.attacks_country103 l3.attacks_country105 l3.attacks_country106 l3.attacks_country108 l3.attacks_country109 l3.attacks_country110 l3.attacks_country111 l3.attacks_country112 l3.attacks_country113 l3.attacks_country114 l3.attacks_country115 l3.attacks_country116 l3.attacks_country117 l3.attacks_country118 l3.attacks_country119 l3.attacks_country120 l3.attacks_country121 l3.attacks_country122 l3.attacks_country123 l3.attacks_country124 l3.attacks_country127 l3.attacks_country128 l3.attacks_country130 l3.attacks_country133 l3.attacks_country134 l3.attacks_country135 l3.attacks_country136 l3.attacks_country137 l3.attacks_country139 l3.attacks_country140 l3.attacks_country141 l3.attacks_country142 l3.attacks_country144 l3.attacks_country146 l3.attacks_country147 l3.attacks_country148 l3.attacks_country149 l3.attacks_country150 l3.attacks_country151 l3.attacks_country152 l3.attacks_country153 l3.attacks_country154 l3.attacks_country156 l3.attacks_country157 l3.attacks_country159 l3.attacks_country162 l3.attacks_country163 countrydummy*, noconstant constraints(1-230)

di "RSS: " (`e(rmse)')^2*`e(df_r)' "."

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from TV to Growth (First Lag)

reg growth l.growth countrydummy*, noconstant notable

reg growth l.growth l.victims_country1 l.victims_country2 l.victims_country3 l.victims_country4 l.victims_country5 l.victims_country7 l.victims_country8 l.victims_country12 l.victims_country13 l.victims_country15 l.victims_country20 l.victims_country22 l.victims_country23 l.victims_country25 l.victims_country26 l.victims_country28 l.victims_country30 l.victims_country31 l.victims_country32 l.victims_country33 l.victims_country34 l.victims_country35 l.victims_country37 l.victims_country38 l.victims_country39 l.victims_country42 l.victims_country44 l.victims_country45 l.victims_country46 l.victims_country47 l.victims_country48 l.victims_country49 l.victims_country50 l.victims_country55 l.victims_country56 l.victims_country57 l.victims_country58 l.victims_country54 l.victims_country61 l.victims_country63 l.victims_country64 l.victims_country65 l.victims_country66 l.victims_country67 l.victims_country69 l.victims_country70 l.victims_country71 l.victims_country73 l.victims_country74 l.victims_country75 l.victims_country76 l.victims_country77 l.victims_country78 l.victims_country79 l.victims_country81 l.victims_country82 l.victims_country83 l.victims_country85 l.victims_country86 l.victims_country88 l.victims_country90 l.victims_country91 l.victims_country92 l.victims_country93 l.victims_country98 l.victims_country100 l.victims_country101 l.victims_country102 l.victims_country103 l.victims_country105 l.victims_country106 l.victims_country108 l.victims_country109 l.victims_country110 l.victims_country111 l.victims_country112 l.victims_country113 l.victims_country114 l.victims_country115 l.victims_country116 l.victims_country117 l.victims_country118 l.victims_country119 l.victims_country120 l.victims_country121 l.victims_country122 l.victims_country123 l.victims_country124 l.victims_country127 l.victims_country128 l.victims_country130 l.victims_country133 l.victims_country134 l.victims_country135 l.victims_country136 l.victims_country137 l.victims_country139 l.victims_country140 l.victims_country141 l.victims_country142 l.victims_country144 l.victims_country146 l.victims_country147 l.victims_country148 l.victims_country149 l.victims_country150 l.victims_country151 l.victims_country152 l.victims_country153 l.victims_country154 l.victims_country156 l.victims_country157 l.victims_country159 l.victims_country162 l.victims_country163 countrydummy*, noconstant notable

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from TV to Growth (Second Lag, Constrained Regression)

reg growth l.growth l2.growth countrydummy*, noconstant notable

constraint define 1 l.victims_country1 = l2.victims_country1
constraint define 2 l.victims_country2 = l2.victims_country2
constraint define 3 l.victims_country3 = l2.victims_country3
constraint define 4 l.victims_country4 = l2.victims_country4
constraint define 5 l.victims_country5 = l2.victims_country5
constraint define 6 l.victims_country7 = l2.victims_country7
constraint define 7 l.victims_country8 = l2.victims_country8
constraint define 8 l.victims_country12 = l2.victims_country12
constraint define 9 l.victims_country13 = l2.victims_country13
constraint define 10 l.victims_country15 = l2.victims_country15
constraint define 11 l.victims_country20 = l2.victims_country20
constraint define 12 l.victims_country22 = l2.victims_country22
constraint define 13 l.victims_country23 = l2.victims_country23
constraint define 14 l.victims_country25 = l2.victims_country25
constraint define 15 l.victims_country26 = l2.victims_country26
constraint define 16 l.victims_country28 = l2.victims_country28
constraint define 17 l.victims_country30 = l2.victims_country30
constraint define 18 l.victims_country31 = l2.victims_country31
constraint define 19 l.victims_country32 = l2.victims_country32
constraint define 20 l.victims_country33 = l2.victims_country33
constraint define 21 l.victims_country34 = l2.victims_country34
constraint define 22 l.victims_country35 = l2.victims_country35
constraint define 23 l.victims_country37 = l2.victims_country37
constraint define 24 l.victims_country38 = l2.victims_country38
constraint define 25 l.victims_country39 = l2.victims_country39
constraint define 26 l.victims_country42 = l2.victims_country42
constraint define 27 l.victims_country44 = l2.victims_country44
constraint define 28 l.victims_country45 = l2.victims_country45
constraint define 29 l.victims_country46 = l2.victims_country46
constraint define 30 l.victims_country47 = l2.victims_country47
constraint define 31 l.victims_country48 = l2.victims_country48
constraint define 32 l.victims_country49 = l2.victims_country49
constraint define 33 l.victims_country50 = l2.victims_country50
constraint define 34 l.victims_country55 = l2.victims_country55
constraint define 35 l.victims_country56 = l2.victims_country56
constraint define 36 l.victims_country57 = l2.victims_country57
constraint define 37 l.victims_country58 = l2.victims_country58
constraint define 38 l.victims_country54 = l2.victims_country54
constraint define 39 l.victims_country61 = l2.victims_country61
constraint define 40 l.victims_country63 = l2.victims_country63
constraint define 41 l.victims_country64 = l2.victims_country64
constraint define 42 l.victims_country65 = l2.victims_country65
constraint define 43 l.victims_country66 = l2.victims_country66
constraint define 44 l.victims_country67 = l2.victims_country67
constraint define 45 l.victims_country69 = l2.victims_country69
constraint define 46 l.victims_country70 = l2.victims_country70
constraint define 47 l.victims_country71 = l2.victims_country71
constraint define 48 l.victims_country73 = l2.victims_country73
constraint define 49 l.victims_country74 = l2.victims_country74
constraint define 50 l.victims_country75 = l2.victims_country75
constraint define 51 l.victims_country76 = l2.victims_country76
constraint define 52 l.victims_country77 = l2.victims_country77
constraint define 53 l.victims_country78 = l2.victims_country78
constraint define 54 l.victims_country79 = l2.victims_country79
constraint define 55 l.victims_country81 = l2.victims_country81
constraint define 56 l.victims_country82 = l2.victims_country82
constraint define 57 l.victims_country83 = l2.victims_country83
constraint define 58 l.victims_country85 = l2.victims_country85
constraint define 59 l.victims_country86 = l2.victims_country86
constraint define 60 l.victims_country88 = l2.victims_country88
constraint define 61 l.victims_country90 = l2.victims_country90
constraint define 62 l.victims_country91 = l2.victims_country91
constraint define 63 l.victims_country92 = l2.victims_country92
constraint define 64 l.victims_country93 = l2.victims_country93
constraint define 65 l.victims_country98 = l2.victims_country98
constraint define 66 l.victims_country100 = l2.victims_country100
constraint define 67 l.victims_country101 = l2.victims_country101
constraint define 68 l.victims_country102 = l2.victims_country102
constraint define 69 l.victims_country103 = l2.victims_country103
constraint define 70 l.victims_country105 = l2.victims_country105
constraint define 71 l.victims_country106 = l2.victims_country106
constraint define 72 l.victims_country108 = l2.victims_country108
constraint define 73 l.victims_country109 = l2.victims_country109
constraint define 74 l.victims_country110 = l2.victims_country110
constraint define 75 l.victims_country111 = l2.victims_country111
constraint define 76 l.victims_country112 = l2.victims_country112
constraint define 77 l.victims_country113 = l2.victims_country113
constraint define 78 l.victims_country114 = l2.victims_country114
constraint define 79 l.victims_country115 = l2.victims_country115
constraint define 80 l.victims_country116 = l2.victims_country116
constraint define 81 l.victims_country117 = l2.victims_country117
constraint define 82 l.victims_country118 = l2.victims_country118
constraint define 83 l.victims_country119 = l2.victims_country119
constraint define 84 l.victims_country120 = l2.victims_country120
constraint define 85 l.victims_country121 = l2.victims_country121
constraint define 86 l.victims_country122 = l2.victims_country122
constraint define 87 l.victims_country123 = l2.victims_country123
constraint define 88 l.victims_country124 = l2.victims_country124
constraint define 89 l.victims_country127 = l2.victims_country127
constraint define 90 l.victims_country128 = l2.victims_country128
constraint define 91 l.victims_country130 = l2.victims_country130
constraint define 92 l.victims_country133 = l2.victims_country133
constraint define 93 l.victims_country134 = l2.victims_country134
constraint define 94 l.victims_country135 = l2.victims_country135
constraint define 95 l.victims_country136 = l2.victims_country136
constraint define 96 l.victims_country137 = l2.victims_country137
constraint define 97 l.victims_country139 = l2.victims_country139
constraint define 98 l.victims_country140 = l2.victims_country140
constraint define 99 l.victims_country141 = l2.victims_country141
constraint define 100 l.victims_country142 = l2.victims_country142
constraint define 101 l.victims_country144 = l2.victims_country144
constraint define 102 l.victims_country146 = l2.victims_country146
constraint define 103 l.victims_country147 = l2.victims_country147
constraint define 104 l.victims_country148 = l2.victims_country148
constraint define 105 l.victims_country149 = l2.victims_country149
constraint define 106 l.victims_country150 = l2.victims_country150
constraint define 107 l.victims_country151 = l2.victims_country151
constraint define 108 l.victims_country152 = l2.victims_country152
constraint define 109 l.victims_country153 = l2.victims_country153
constraint define 110 l.victims_country154 = l2.victims_country154
constraint define 111 l.victims_country156 = l2.victims_country156
constraint define 112 l.victims_country157 = l2.victims_country157
constraint define 113 l.victims_country159 = l2.victims_country159
constraint define 114 l.victims_country162 = l2.victims_country162
constraint define 115 l.victims_country163 = l2.victims_country163

cnsreg growth l.growth l2.growth l.victims_country1 l.victims_country2 l.victims_country3 l.victims_country4 l.victims_country5 l.victims_country7 l.victims_country8 l.victims_country12 l.victims_country13 l.victims_country15 l.victims_country20 l.victims_country22 l.victims_country23 l.victims_country25 l.victims_country26 l.victims_country28 l.victims_country30 l.victims_country31 l.victims_country32 l.victims_country33 l.victims_country34 l.victims_country35 l.victims_country37 l.victims_country38 l.victims_country39 l.victims_country42 l.victims_country44 l.victims_country45 l.victims_country46 l.victims_country47 l.victims_country48 l.victims_country49 l.victims_country50 l.victims_country55 l.victims_country56 l.victims_country57 l.victims_country58 l.victims_country54 l.victims_country61 l.victims_country63 l.victims_country64 l.victims_country65 l.victims_country66 l.victims_country67 l.victims_country69 l.victims_country70 l.victims_country71 l.victims_country73 l.victims_country74 l.victims_country75 l.victims_country76 l.victims_country77 l.victims_country78 l.victims_country79 l.victims_country81 l.victims_country82 l.victims_country83 l.victims_country85 l.victims_country86 l.victims_country88 l.victims_country90 l.victims_country91 l.victims_country92 l.victims_country93 l.victims_country98 l.victims_country100 l.victims_country101 l.victims_country102 l.victims_country103 l.victims_country105 l.victims_country106 l.victims_country108 l.victims_country109 l.victims_country110 l.victims_country111 l.victims_country112 l.victims_country113 l.victims_country114 l.victims_country115 l.victims_country116 l.victims_country117 l.victims_country118 l.victims_country119 l.victims_country120 l.victims_country121 l.victims_country122 l.victims_country123 l.victims_country124 l.victims_country127 l.victims_country128 l.victims_country130 l.victims_country133 l.victims_country134 l.victims_country135 l.victims_country136 l.victims_country137 l.victims_country139 l.victims_country140 l.victims_country141 l.victims_country142 l.victims_country144 l.victims_country146 l.victims_country147 l.victims_country148 l.victims_country149 l.victims_country150 l.victims_country151 l.victims_country152 l.victims_country153 l.victims_country154 l.victims_country156 l.victims_country157 l.victims_country159 l.victims_country162 l.victims_country163 l2.victims_country1 l2.victims_country2 l2.victims_country3 l2.victims_country4 l2.victims_country5 l2.victims_country7 l2.victims_country8 l2.victims_country12 l2.victims_country13 l2.victims_country15 l2.victims_country20 l2.victims_country22 l2.victims_country23 l2.victims_country25 l2.victims_country26 l2.victims_country28 l2.victims_country30 l2.victims_country31 l2.victims_country32 l2.victims_country33 l2.victims_country34 l2.victims_country35 l2.victims_country37 l2.victims_country38 l2.victims_country39 l2.victims_country42 l2.victims_country44 l2.victims_country45 l2.victims_country46 l2.victims_country47 l2.victims_country48 l2.victims_country49 l2.victims_country50 l2.victims_country55 l2.victims_country56 l2.victims_country57 l2.victims_country58 l2.victims_country54 l2.victims_country61 l2.victims_country63 l2.victims_country64 l2.victims_country65 l2.victims_country66 l2.victims_country67 l2.victims_country69 l2.victims_country70 l2.victims_country71 l2.victims_country73 l2.victims_country74 l2.victims_country75 l2.victims_country76 l2.victims_country77 l2.victims_country78 l2.victims_country79 l2.victims_country81 l2.victims_country82 l2.victims_country83 l2.victims_country85 l2.victims_country86 l2.victims_country88 l2.victims_country90 l2.victims_country91 l2.victims_country92 l2.victims_country93 l2.victims_country98 l2.victims_country100 l2.victims_country101 l2.victims_country102 l2.victims_country103 l2.victims_country105 l2.victims_country106 l2.victims_country108 l2.victims_country109 l2.victims_country110 l2.victims_country111 l2.victims_country112 l2.victims_country113 l2.victims_country114 l2.victims_country115 l2.victims_country116 l2.victims_country117 l2.victims_country118 l2.victims_country119 l2.victims_country120 l2.victims_country121 l2.victims_country122 l2.victims_country123 l2.victims_country124 l2.victims_country127 l2.victims_country128 l2.victims_country130 l2.victims_country133 l2.victims_country134 l2.victims_country135 l2.victims_country136 l2.victims_country137 l2.victims_country139 l2.victims_country140 l2.victims_country141 l2.victims_country142 l2.victims_country144 l2.victims_country146 l2.victims_country147 l2.victims_country148 l2.victims_country149 l2.victims_country150 l2.victims_country151 l2.victims_country152 l2.victims_country153 l2.victims_country154 l2.victims_country156 l2.victims_country157 l2.victims_country159 l2.victims_country162 l2.victims_country163 countrydummy*, noconstant constraints(1-115)

di "RSS: " (`e(rmse)')^2*`e(df_r)' "."

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from TV to Growth (Third Lag, Constrained Regression)

reg growth l.growth l2.growth l3.growth countrydummy*, noconstant notable

constraint define 117 l2.victims_country1 = l3.victims_country1
constraint define 118 l2.victims_country2 = l3.victims_country2
constraint define 119 l2.victims_country3 = l3.victims_country3
constraint define 120 l2.victims_country4 = l3.victims_country4
constraint define 121 l2.victims_country5 = l3.victims_country5
constraint define 122 l2.victims_country7 = l3.victims_country7
constraint define 123 l2.victims_country8 = l3.victims_country8
constraint define 124 l2.victims_country12 = l3.victims_country12
constraint define 125 l2.victims_country13 = l3.victims_country13
constraint define 126 l2.victims_country15 = l3.victims_country15
constraint define 127 l2.victims_country20 = l3.victims_country20
constraint define 128 l2.victims_country22 = l3.victims_country22
constraint define 129 l2.victims_country23 = l3.victims_country23
constraint define 130 l2.victims_country25 = l3.victims_country25
constraint define 131 l2.victims_country26 = l3.victims_country26
constraint define 132 l2.victims_country28 = l3.victims_country28
constraint define 133 l2.victims_country30 = l3.victims_country30
constraint define 134 l2.victims_country31 = l3.victims_country31
constraint define 135 l2.victims_country32 = l3.victims_country32
constraint define 136 l2.victims_country33 = l3.victims_country33
constraint define 137 l2.victims_country34 = l3.victims_country34
constraint define 138 l2.victims_country35 = l3.victims_country35
constraint define 139 l2.victims_country37 = l3.victims_country37
constraint define 140 l2.victims_country38 = l3.victims_country38
constraint define 141 l2.victims_country39 = l3.victims_country39
constraint define 142 l2.victims_country42 = l3.victims_country42
constraint define 143 l2.victims_country44 = l3.victims_country44
constraint define 144 l2.victims_country45 = l3.victims_country45
constraint define 145 l2.victims_country46 = l3.victims_country46
constraint define 146 l2.victims_country47 = l3.victims_country47
constraint define 147 l2.victims_country48 = l3.victims_country48
constraint define 148 l2.victims_country49 = l3.victims_country49
constraint define 149 l2.victims_country50 = l3.victims_country50
constraint define 150 l2.victims_country55 = l3.victims_country55
constraint define 151 l2.victims_country56 = l3.victims_country56
constraint define 152 l2.victims_country57 = l3.victims_country57
constraint define 153 l2.victims_country58 = l3.victims_country58
constraint define 154 l2.victims_country54 = l3.victims_country54
constraint define 155 l2.victims_country61 = l3.victims_country61
constraint define 156 l2.victims_country63 = l3.victims_country63
constraint define 157 l2.victims_country64 = l3.victims_country64
constraint define 158 l2.victims_country65 = l3.victims_country65
constraint define 159 l2.victims_country66 = l3.victims_country66
constraint define 160 l2.victims_country67 = l3.victims_country67
constraint define 161 l2.victims_country69 = l3.victims_country69
constraint define 162 l2.victims_country70 = l3.victims_country70
constraint define 163 l2.victims_country71 = l3.victims_country71
constraint define 164 l2.victims_country73 = l3.victims_country73
constraint define 165 l2.victims_country74 = l3.victims_country74
constraint define 166 l2.victims_country75 = l3.victims_country75
constraint define 167 l2.victims_country76 = l3.victims_country76
constraint define 168 l2.victims_country77 = l3.victims_country77
constraint define 169 l2.victims_country78 = l3.victims_country78
constraint define 170 l2.victims_country79 = l3.victims_country79
constraint define 171 l2.victims_country81 = l3.victims_country81
constraint define 172 l2.victims_country82 = l3.victims_country82
constraint define 173 l2.victims_country83 = l3.victims_country83
constraint define 174 l2.victims_country85 = l3.victims_country85
constraint define 175 l2.victims_country86 = l3.victims_country86
constraint define 176 l2.victims_country88 = l3.victims_country88
constraint define 177 l2.victims_country90 = l3.victims_country90
constraint define 178 l2.victims_country91 = l3.victims_country91
constraint define 179 l2.victims_country92 = l3.victims_country92
constraint define 180 l2.victims_country93 = l3.victims_country93
constraint define 181 l2.victims_country98 = l3.victims_country98
constraint define 182 l2.victims_country100 = l3.victims_country100
constraint define 183 l2.victims_country101 = l3.victims_country101
constraint define 184 l2.victims_country102 = l3.victims_country102
constraint define 185 l2.victims_country103 = l3.victims_country103
constraint define 186 l2.victims_country105 = l3.victims_country105
constraint define 187 l2.victims_country106 = l3.victims_country106
constraint define 188 l2.victims_country108 = l3.victims_country108
constraint define 189 l2.victims_country109 = l3.victims_country109
constraint define 190 l2.victims_country110 = l3.victims_country110
constraint define 191 l2.victims_country111 = l3.victims_country111
constraint define 192 l2.victims_country112 = l3.victims_country112
constraint define 193 l2.victims_country113 = l3.victims_country113
constraint define 194 l2.victims_country114 = l3.victims_country114
constraint define 195 l2.victims_country115 = l3.victims_country115
constraint define 196 l2.victims_country116 = l3.victims_country116
constraint define 197 l2.victims_country117 = l3.victims_country117
constraint define 198 l2.victims_country118 = l3.victims_country118
constraint define 199 l2.victims_country119 = l3.victims_country119
constraint define 200 l2.victims_country120 = l3.victims_country120
constraint define 201 l2.victims_country121 = l3.victims_country121
constraint define 202 l2.victims_country122 = l3.victims_country122
constraint define 203 l2.victims_country123 = l3.victims_country123
constraint define 204 l2.victims_country124 = l3.victims_country124
constraint define 205 l2.victims_country127 = l3.victims_country127
constraint define 206 l2.victims_country128 = l3.victims_country128
constraint define 207 l2.victims_country130 = l3.victims_country130
constraint define 208 l2.victims_country133 = l3.victims_country133
constraint define 209 l2.victims_country134 = l3.victims_country134
constraint define 210 l2.victims_country135 = l3.victims_country135
constraint define 211 l2.victims_country136 = l3.victims_country136
constraint define 212 l2.victims_country137 = l3.victims_country137
constraint define 213 l2.victims_country139 = l3.victims_country139
constraint define 214 l2.victims_country140 = l3.victims_country140
constraint define 215 l2.victims_country141 = l3.victims_country141
constraint define 216 l2.victims_country142 = l3.victims_country142
constraint define 217 l2.victims_country144 = l3.victims_country144
constraint define 218 l2.victims_country146 = l3.victims_country146
constraint define 219 l2.victims_country147 = l3.victims_country147
constraint define 220 l2.victims_country148 = l3.victims_country148
constraint define 220 l2.victims_country149 = l3.victims_country149
constraint define 221 l2.victims_country150 = l3.victims_country150
constraint define 222 l2.victims_country151 = l3.victims_country151
constraint define 223 l2.victims_country152 = l3.victims_country152
constraint define 224 l2.victims_country153 = l3.victims_country153
constraint define 225 l2.victims_country154 = l3.victims_country154
constraint define 226 l2.victims_country156 = l3.victims_country156
constraint define 227 l2.victims_country157 = l3.victims_country157
constraint define 228 l2.victims_country159 = l3.victims_country159
constraint define 229 l2.victims_country162 = l3.victims_country162
constraint define 230 l2.victims_country163 = l3.victims_country163

cnsreg growth l.growth l2.growth l3.growth l.victims_country1 l.victims_country2 l.victims_country3 l.victims_country4 l.victims_country5 l.victims_country7 l.victims_country8 l.victims_country12 l.victims_country13 l.victims_country15 l.victims_country20 l.victims_country22 l.victims_country23 l.victims_country25 l.victims_country26 l.victims_country28 l.victims_country30 l.victims_country31 l.victims_country32 l.victims_country33 l.victims_country34 l.victims_country35 l.victims_country37 l.victims_country38 l.victims_country39 l.victims_country42 l.victims_country44 l.victims_country45 l.victims_country46 l.victims_country47 l.victims_country48 l.victims_country49 l.victims_country50 l.victims_country55 l.victims_country56 l.victims_country57 l.victims_country58 l.victims_country54 l.victims_country61 l.victims_country63 l.victims_country64 l.victims_country65 l.victims_country66 l.victims_country67 l.victims_country69 l.victims_country70 l.victims_country71 l.victims_country73 l.victims_country74 l.victims_country75 l.victims_country76 l.victims_country77 l.victims_country78 l.victims_country79 l.victims_country81 l.victims_country82 l.victims_country83 l.victims_country85 l.victims_country86 l.victims_country88 l.victims_country90 l.victims_country91 l.victims_country92 l.victims_country93 l.victims_country98 l.victims_country100 l.victims_country101 l.victims_country102 l.victims_country103 l.victims_country105 l.victims_country106 l.victims_country108 l.victims_country109 l.victims_country110 l.victims_country111 l.victims_country112 l.victims_country113 l.victims_country114 l.victims_country115 l.victims_country116 l.victims_country117 l.victims_country118 l.victims_country119 l.victims_country120 l.victims_country121 l.victims_country122 l.victims_country123 l.victims_country124 l.victims_country127 l.victims_country128 l.victims_country130 l.victims_country133 l.victims_country134 l.victims_country135 l.victims_country136 l.victims_country137 l.victims_country139 l.victims_country140 l.victims_country141 l.victims_country142 l.victims_country144 l.victims_country146 l.victims_country147 l.victims_country148 l.victims_country149 l.victims_country150 l.victims_country151 l.victims_country152 l.victims_country153 l.victims_country154 l.victims_country156 l.victims_country157 l.victims_country159 l.victims_country162 l.victims_country163 l2.victims_country1 l2.victims_country2 l2.victims_country3 l2.victims_country4 l2.victims_country5 l2.victims_country7 l2.victims_country8 l2.victims_country12 l2.victims_country13 l2.victims_country15 l2.victims_country20 l2.victims_country22 l2.victims_country23 l2.victims_country25 l2.victims_country26 l2.victims_country28 l2.victims_country30 l2.victims_country31 l2.victims_country32 l2.victims_country33 l2.victims_country34 l2.victims_country35 l2.victims_country37 l2.victims_country38 l2.victims_country39 l2.victims_country42 l2.victims_country44 l2.victims_country45 l2.victims_country46 l2.victims_country47 l2.victims_country48 l2.victims_country49 l2.victims_country50 l2.victims_country55 l2.victims_country56 l2.victims_country57 l2.victims_country58 l2.victims_country54 l2.victims_country61 l2.victims_country63 l2.victims_country64 l2.victims_country65 l2.victims_country66 l2.victims_country67 l2.victims_country69 l2.victims_country70 l2.victims_country71 l2.victims_country73 l2.victims_country74 l2.victims_country75 l2.victims_country76 l2.victims_country77 l2.victims_country78 l2.victims_country79 l2.victims_country81 l2.victims_country82 l2.victims_country83 l2.victims_country85 l2.victims_country86 l2.victims_country88 l2.victims_country90 l2.victims_country91 l2.victims_country92 l2.victims_country93 l2.victims_country98 l2.victims_country100 l2.victims_country101 l2.victims_country102 l2.victims_country103 l2.victims_country105 l2.victims_country106 l2.victims_country108 l2.victims_country109 l2.victims_country110 l2.victims_country111 l2.victims_country112 l2.victims_country113 l2.victims_country114 l2.victims_country115 l2.victims_country116 l2.victims_country117 l2.victims_country118 l2.victims_country119 l2.victims_country120 l2.victims_country121 l2.victims_country122 l2.victims_country123 l2.victims_country124 l2.victims_country127 l2.victims_country128 l2.victims_country130 l2.victims_country133 l2.victims_country134 l2.victims_country135 l2.victims_country136 l2.victims_country137 l2.victims_country139 l2.victims_country140 l2.victims_country141 l2.victims_country142 l2.victims_country144 l2.victims_country146 l2.victims_country147 l2.victims_country148 l2.victims_country149 l2.victims_country150 l2.victims_country151 l2.victims_country152 l2.victims_country153 l2.victims_country154 l2.victims_country156 l2.victims_country157 l2.victims_country159 l2.victims_country162 l2.victims_country163 l3.victims_country1 l3.victims_country2 l3.victims_country3 l3.victims_country4 l3.victims_country5 l3.victims_country7 l3.victims_country8 l3.victims_country12 l3.victims_country13 l3.victims_country15 l3.victims_country20 l3.victims_country22 l3.victims_country23 l3.victims_country25 l3.victims_country26 l3.victims_country28 l3.victims_country30 l3.victims_country31 l3.victims_country32 l3.victims_country33 l3.victims_country34 l3.victims_country35 l3.victims_country37 l3.victims_country38 l3.victims_country39 l3.victims_country42 l3.victims_country44 l3.victims_country45 l3.victims_country46 l3.victims_country47 l3.victims_country48 l3.victims_country49 l3.victims_country50 l3.victims_country55 l3.victims_country56 l3.victims_country57 l3.victims_country58 l3.victims_country54 l3.victims_country61 l3.victims_country63 l3.victims_country64 l3.victims_country65 l3.victims_country66 l3.victims_country67 l3.victims_country69 l3.victims_country70 l3.victims_country71 l3.victims_country73 l3.victims_country74 l3.victims_country75 l3.victims_country76 l3.victims_country77 l3.victims_country78 l3.victims_country79 l3.victims_country81 l3.victims_country82 l3.victims_country83 l3.victims_country85 l3.victims_country86 l3.victims_country88 l3.victims_country90 l3.victims_country91 l3.victims_country92 l3.victims_country93 l3.victims_country98 l3.victims_country100 l3.victims_country101 l3.victims_country102 l3.victims_country103 l3.victims_country105 l3.victims_country106 l3.victims_country108 l3.victims_country109 l3.victims_country110 l3.victims_country111 l3.victims_country112 l3.victims_country113 l3.victims_country114 l3.victims_country115 l3.victims_country116 l3.victims_country117 l3.victims_country118 l3.victims_country119 l3.victims_country120 l3.victims_country121 l3.victims_country122 l3.victims_country123 l3.victims_country124 l3.victims_country127 l3.victims_country128 l3.victims_country130 l3.victims_country133 l3.victims_country134 l3.victims_country135 l3.victims_country136 l3.victims_country137 l3.victims_country139 l3.victims_country140 l3.victims_country141 l3.victims_country142 l3.victims_country144 l3.victims_country146 l3.victims_country147 l3.victims_country148 l3.victims_country149 l3.victims_country150 l3.victims_country151 l3.victims_country152 l3.victims_country153 l3.victims_country154 l3.victims_country156 l3.victims_country157 l3.victims_country159 l3.victims_country162 l3.victims_country163 countrydummy*, noconstant constraints(1-230)

di "RSS: " (`e(rmse)')^2*`e(df_r)' "."

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*******************************************************************************************************************
************* PART 2: Homogeneous Causality Test (Table II)
*******************************************************************************************************************

*** Note: For all models, store the needed data from both regression analysis (N*T, RSS1, RSS2) as given in the main text and calculate the F-statistic. Then, use a table of F-statistics to assess the statistical significance of the statistic.

*** Non-Causality from Growth to TA (Only First Lag)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

reg attacks l.attacks l.growth countrydummy*, noconstant notable

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*** Non-Causality from Growth to TV (Only First Lag)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

reg victims l.victims l.growth countrydummy*, noconstant notable

*** Proceed as described above to calculate the F-statistics and assess the statistical significance.

*******************************************************************************************************************
************* PART 3a: Group-Specific Causality Test for Politico-Economic Development (Table III)
*******************************************************************************************************************

*** Note: For all models, store the needed data from both regression analysis (N*T, RSS1, RSS2) as given in the main text and calculate the F-statistic. Then, use a table of F-statistics to assess the statistical significance of the statistic.

*** Non-Causality from Growth to TA (Only First Lag, Baseline (Unrestricted Model))

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude High Income Democracies)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country12 l.growth_country13 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country58 l.growth_country54 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country81 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country156 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude UMI Democracies)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude LMI Democracies)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country37 l.growth_country38 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude LI Democracies)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude High Income Non-Democracies)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude UMI Non-Democracies)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude LMI Non-Democracies)

reg attacks l.attacks l.growth_country1 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country22 l.growth_country23 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country34 l.growth_country35 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country46 l.growth_country49 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country122 l.growth_country123 l.growth_country127 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country142 l.growth_country146 l.growth_country148 l.growth_country149 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude LI Non-Democracies)

reg attacks l.attacks l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country30 l.growth_country33 l.growth_country35 l.growth_country37 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country71 l.growth_country73 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country86 l.growth_country90 l.growth_country93 l.growth_country98 l.growth_country101 l.growth_country103 l.growth_country105 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country114 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country147 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Baseline (Unrestricted Model))

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude High Income Democracies)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country12 l.growth_country13 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country58 l.growth_country54 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country81 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country156 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude UMI Democracies)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude LMI Democracies)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country37 l.growth_country38 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude LI Democracies)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude High Income Non-Democracies)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude UMI Non-Democracies)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude LMI Non-Democracies)

reg victims l.victims l.growth_country1 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country22 l.growth_country23 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country34 l.growth_country35 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country46 l.growth_country49 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country122 l.growth_country123 l.growth_country127 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country142 l.growth_country146 l.growth_country148 l.growth_country149 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude LI Non-Democracies)

reg victims l.victims l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country30 l.growth_country33 l.growth_country35 l.growth_country37 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country71 l.growth_country73 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country86 l.growth_country90 l.growth_country93 l.growth_country98 l.growth_country101 l.growth_country103 l.growth_country105 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country114 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country147 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country163 countrydummy*, noconstant notable

*******************************************************************************************************************
************* PART 3b: Group-Specific Causality Test for Regional and Cultural Affiliation (Table IV)
*******************************************************************************************************************

*** Note: For all models, store the needed data from both regression analysis (N*T, RSS1, RSS2) as given in the main text and calculate the F-statistic. Then, use a table of F-statistics to assess the statistical significance of the statistic.

*** Non-Causality from Growth to TA (Only First Lag, Baseline (Unrestricted Model))

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude Western Countries)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country12 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country45 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country58 l.growth_country54 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country156 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude Islamic Countries)

reg attacks l.attacks l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country85 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country101 l.growth_country103 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country114 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country124 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude Slavic Countries)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude African Countries)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country142 l.growth_country144 l.growth_country147 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude Latin American Countries)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country22 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country34 l.growth_country37 l.growth_country38 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country49 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country67 l.growth_country69 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country117 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country157 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude Other Countries)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country70 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country136 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Baseline (Unrestricted Model))

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude Western Countries)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country12 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country45 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country58 l.growth_country54 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country156 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude Islamic Countries)

reg victims l.victims l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country85 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country101 l.growth_country103 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country114 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country124 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude Slavic Countries)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude African Countries)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country142 l.growth_country144 l.growth_country147 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude Latin American Countries)

reg victims l.victims  l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country22 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country34 l.growth_country37 l.growth_country38 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country49 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country67 l.growth_country69 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country117 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country157 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude Other Countries)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country70 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country136 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*******************************************************************************************************************
************* PART 3c: Group-Specific Causality Test for Level of Terrorism and Growth (Table IV)
*******************************************************************************************************************

*** Note: For all models, store the needed data from both regression analysis (N*T, RSS1, RSS2) as given in the main text and calculate the F-statistic. Then, use a table of F-statistics to assess the statistical significance of the statistic.

*** Non-Causality from Growth to TA (Only First Lag, Baseline (Unrestricted Model))

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to with Strong Terrorist Activity and Strong Growth)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country44 l.growth_country45 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country153 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to with Strong Terrorist Activity and Weak Growth)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to with Weak Terrorist Activity and Strong Growth)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country12 l.growth_country20 l.growth_country26 l.growth_country28 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country35 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country45 l.growth_country46 l.growth_country50 l.growth_country54 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country69 l.growth_country70 l.growth_country75 l.growth_country76 l.growth_country78 l.growth_country81 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country90 l.growth_country92 l.growth_country93 l.growth_country102 l.growth_country106 l.growth_country108 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country123 l.growth_country127 l.growth_country128 l.growth_country133 l.growth_country134 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country144 l.growth_country146 l.growth_country148 l.growth_country149 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country159 l.growth_country162 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to with Weak Terrorist Activity and Weak Growth)

reg attacks l.attacks l.growth_country4 l.growth_country7 l.growth_country8 l.growth_country13 l.growth_country15 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country67 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country82 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country109 l.growth_country111 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country122 l.growth_country124 l.growth_country130 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country147 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country154 l.growth_country157 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Baseline (Unrestricted Model))

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to with Strong Terrorist Activity and Strong Growth)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country44 l.growth_country45 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country153 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to with Strong Terrorist Activity and Weak Growth)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to with Weak Terrorist Activity and Strong Growth)

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country12 l.growth_country20 l.growth_country26 l.growth_country28 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country35 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country45 l.growth_country46 l.growth_country50 l.growth_country54 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country69 l.growth_country70 l.growth_country75 l.growth_country76 l.growth_country78 l.growth_country81 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country90 l.growth_country92 l.growth_country93 l.growth_country102 l.growth_country106 l.growth_country108 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country123 l.growth_country127 l.growth_country128 l.growth_country133 l.growth_country134 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country144 l.growth_country146 l.growth_country148 l.growth_country149 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country159 l.growth_country162 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to with Weak Terrorist Activity and Weak Growth)

reg victims l.victims l.growth_country4 l.growth_country7 l.growth_country8 l.growth_country13 l.growth_country15 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country67 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country82 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country109 l.growth_country111 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country122 l.growth_country124 l.growth_country130 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country147 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country154 l.growth_country157 l.growth_country163 countrydummy*, noconstant notable

*******************************************************************************************************************
************* PART 3d: Group-Specific Causality Test for Political Stability (Table V)
*******************************************************************************************************************

*** Note: For all models, store the needed data from both regression analysis (N*T, RSS1, RSS2) as given in the main text and calculate the F-statistic. Then, use a table of F-statistics to assess the statistical significance of the statistic.

*** Non-Causality from Growth to TA (Only First Lag, Baseline (Unrestricted Model))

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude Civil War Countries)

reg attacks l.attacks l.growth_country2 l.growth_country3 l.growth_country7 l.growth_country8 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country30 l.growth_country31 l.growth_country33 l.growth_country34 l.growth_country37 l.growth_country39 l.growth_country44 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country66 l.growth_country67 l.growth_country70 l.growth_country71 l.growth_country77 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country86 l.growth_country91 l.growth_country93 l.growth_country98 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country112 l.growth_country114 l.growth_country116 l.growth_country118 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country130 l.growth_country135 l.growth_country136 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country146 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country152 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Exclude Countries with Minor Instability)

reg attacks l.attacks l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country35 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country49 l.growth_country50 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country157 l.growth_country159 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TA (Only First Lag, Restricted to Stable Countries)

reg attacks l.attacks l.growth_country1 l.growth_country4 l.growth_country5 l.growth_country12 l.growth_country26 l.growth_country28 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country42 l.growth_country45 l.growth_country48 l.growth_country50 l.growth_country55 l.growth_country54 l.growth_country65 l.growth_country66 l.growth_country69 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country78 l.growth_country83 l.growth_country85 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country100 l.growth_country105 l.growth_country106 l.growth_country111 l.growth_country113 l.growth_country115 l.growth_country117 l.growth_country119 l.growth_country120 l.growth_country124 l.growth_country128 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country137 l.growth_country139 l.growth_country141 l.growth_country144 l.growth_country147 l.growth_country151 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Baseline (Unrestricted Model))

reg victims l.victims l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country50 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country66 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude Civil War Countries)

reg victims l.victims  l.growth_country2 l.growth_country3 l.growth_country7 l.growth_country8 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country26 l.growth_country30 l.growth_country31 l.growth_country33 l.growth_country34 l.growth_country37 l.growth_country39 l.growth_country44 l.growth_country46 l.growth_country47 l.growth_country48 l.growth_country49 l.growth_country55 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country66 l.growth_country67 l.growth_country70 l.growth_country71 l.growth_country77 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country83 l.growth_country86 l.growth_country91 l.growth_country93 l.growth_country98 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country112 l.growth_country114 l.growth_country116 l.growth_country118 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country124 l.growth_country127 l.growth_country130 l.growth_country135 l.growth_country136 l.growth_country140 l.growth_country141 l.growth_country142 l.growth_country146 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country152 l.growth_country156 l.growth_country157 l.growth_country159 l.growth_country162 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Exclude Countries with Minor Instability)

reg victims l.victims  l.growth_country1 l.growth_country2 l.growth_country3 l.growth_country4 l.growth_country5 l.growth_country7 l.growth_country8 l.growth_country12 l.growth_country13 l.growth_country15 l.growth_country20 l.growth_country22 l.growth_country23 l.growth_country25 l.growth_country28 l.growth_country30 l.growth_country31 l.growth_country32 l.growth_country35 l.growth_country38 l.growth_country39 l.growth_country42 l.growth_country44 l.growth_country45 l.growth_country46 l.growth_country47 l.growth_country49 l.growth_country50 l.growth_country56 l.growth_country57 l.growth_country58 l.growth_country54 l.growth_country61 l.growth_country63 l.growth_country64 l.growth_country65 l.growth_country67 l.growth_country69 l.growth_country70 l.growth_country71 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country77 l.growth_country78 l.growth_country79 l.growth_country81 l.growth_country82 l.growth_country85 l.growth_country86 l.growth_country88 l.growth_country90 l.growth_country92 l.growth_country93 l.growth_country98 l.growth_country100 l.growth_country101 l.growth_country102 l.growth_country103 l.growth_country105 l.growth_country106 l.growth_country108 l.growth_country109 l.growth_country110 l.growth_country111 l.growth_country112 l.growth_country113 l.growth_country114 l.growth_country115 l.growth_country116 l.growth_country117 l.growth_country118 l.growth_country119 l.growth_country120 l.growth_country121 l.growth_country122 l.growth_country123 l.growth_country127 l.growth_country128 l.growth_country130 l.growth_country133 l.growth_country134 l.growth_country136 l.growth_country137 l.growth_country139 l.growth_country140 l.growth_country142 l.growth_country144 l.growth_country146 l.growth_country147 l.growth_country148 l.growth_country149 l.growth_country150 l.growth_country151 l.growth_country152 l.growth_country153 l.growth_country154 l.growth_country157 l.growth_country159 l.growth_country163 countrydummy*, noconstant notable

*** Non-Causality from Growth to TV (Only First Lag, Restricted to Stable Countries)

reg victims l.victims  l.growth_country1 l.growth_country4 l.growth_country5 l.growth_country12 l.growth_country26 l.growth_country28 l.growth_country32 l.growth_country33 l.growth_country34 l.growth_country35 l.growth_country37 l.growth_country38 l.growth_country42 l.growth_country45 l.growth_country48 l.growth_country50 l.growth_country55 l.growth_country54 l.growth_country65 l.growth_country66 l.growth_country69 l.growth_country73 l.growth_country74 l.growth_country75 l.growth_country76 l.growth_country78 l.growth_country83 l.growth_country85 l.growth_country88 l.growth_country90 l.growth_country91 l.growth_country92 l.growth_country100 l.growth_country105 l.growth_country106 l.growth_country111 l.growth_country113 l.growth_country115 l.growth_country117 l.growth_country119 l.growth_country120 l.growth_country124 l.growth_country128 l.growth_country133 l.growth_country134 l.growth_country135 l.growth_country137 l.growth_country139 l.growth_country141 l.growth_country144 l.growth_country147 l.growth_country151 l.growth_country153 l.growth_country154 l.growth_country156 l.growth_country162 l.growth_country163 countrydummy*, noconstant notable

*******************************************************************************************************************
************* End of Do-File
*******************************************************************************************************************
