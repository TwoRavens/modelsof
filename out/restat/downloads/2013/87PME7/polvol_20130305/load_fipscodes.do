	


clear
input int shortfips str30 state str2 postal str2 fips str30 crap int bpl int censusregion
1 Alabama 	AL 	01 	"State; counties" 001                                                                    6
. Alaska 	AK 	02 	"State; boroughs" 002                                                                     9
*******"American Samoa" 	AS 	60 	"Outlying area under U.S. sovereignty" .                                 10
2 Arizona 	AZ 	04 	"State; counties" 004                                                                    8
3 Arkansas 	AR 	05 	"State; counties" 005                                                                   7
*******"Baker Island" ""		81 	"Minor outlying island territory" .                                         10
4 California 	CA 	06 	"State; counties" 006                                                                 9
5 Colorado 	CO 	08 	"State; counties" 008                                                                   8
6 Connecticut 	CT 	09 	"State; counties" 009                                                                1
7 Delaware 	DE 	10 	"State; counties" 010                                                                   5
. "District of Columbia" 	DC 	11 	"Federal district" 011                                                    5
8 Florida 	FL 	12 	"State; counties" 012                                                                    5
*******"Federated States of Micronesia" 	FM 	64 	"Freely associated state" .                              10
9 Georgia 	GA 	13 	"State; counties" 013                                                                    5
*******Guam 	GU 	66 	"Outlying area under U.S. sovereignty" .                                             10
. Hawaii 	HI 	15 	"State; counties" 015                                                                     9
*******"Howland Island" "" 		84 	"Minor outlying island territory" .                                      10
10 Idaho 	ID 	16 	"State; counties" 016                                                                      8
11 Illinois 	IL 	17 	"State; counties" 017                                                                   3
12 Indiana 	IN 	18 	"State; counties" 018                                                                    3
13 Iowa 	IA 	19 	"State; counties" 019                                                                       4
*******"Jarvis Island" ""		86 	"Minor outlying island territory" .                                        10
*******"Johnston Atoll" ""		67 	"Minor outlying island territory" .                                       10
14 Kansas 	KS 	20 	"State; counties" 020                                                                     4
15 Kentucky 	KY 	21 	"State; counties" 021                                                                   6
*******"Kingman Reef" ""		89 	"Minor outlying island territory" .                                         10
16 Louisiana 	LA 	22 	"State; parishes" 022                                                                  7
17 Maine 	ME 	23 	"State; counties" 023                                                                      1
*******"Marshall Islands"	MH 	68 	"Freely associated state" .                                             10
18 Maryland 	MD 	24 	"State; counties" 024                                                                   5
19 Massachusetts 	MA 	25 	"State; counties" 025                                                              1
20 Michigan 	MI 	26 	"State; counties" 026                                                                   3
*******"Midway Islands" 	""	71 	"Minor outlying island territory" .                                       10
21 Minnesota 	MN 	27 	"State; counties" 027                                                                  4
22 Mississippi 	MS 	28 	"State; counties" 028                                                                6
23 Missouri 	MO 	29 	"State; counties" 029                                                                   4
24 Montana 	MT 	30 	"State; counties" 030                                                                    8
*******"Navassa Island" "" 		76 	"Minor outlying island territory" .                                      10
25 Nebraska 	NE 	31 	"State; counties" 031                                                                   4
26 Nevada 	NV 	32 	"State; counties" 032                                                                     8
27 "New Hampshire" 	NH 	33 	"State; counties" 033                                                            1
28 "New Jersey" 	NJ 	34 	"State; counties" 034                                                               2
29 "New Mexico" 	NM 	35 	"State; counties" 035                                                               8
30 "New York" 	NY 	36 	"State; counties" 036                                                                 2
31 "North Carolina" 	NC 	37 	"State; counties" 037                                                           5
32 "North Dakota" 	ND 	38 	"State; counties" 038                                                             4
*******"Northern Mariana Islands" 	MP 	69 	"Outlying area under U.S. sovereignty" .                       10
33 Ohio 	OH 	39 	"State; counties" 039                                                                       3
34 Oklahoma 	OK 	40 	"State; counties" 040                                                                   7
35 Oregon 	OR 	41 	"State; counties" 041                                                                     9
********"Palau" 	PW 	70 	"Trust Territory"  .                                                             10
********"Palmyra Atoll" 	""	95 	"Minor outlying island territory" .                                       10
36 Pennsylvania 	PA 	42 	"State; counties" 042                                                               2
*******"Puerto Rico" 	PR 	72 	"Outlying area under U.S. sovereignty" .                                    10
37 "Rhode Island" 	RI 	44 	"State; counties" 044                                                             1
38 "South Carolina" 	SC 	45 	"State; counties" 045                                                           5
39 "South Dakota" 	SD 	46 	"State; counties" 046                                                             4
40 Tennessee 	TN 	47 	"State; counties" 047                                                                  6
41 Texas 	TX 	48 	"State; counties" 048                                                                      7
********"U.S. Minor Outlying Islands" 	UM 	74 	"Minor outlying island territories (aggregated)" .         10
42 Utah 	UT 	49 	"State; counties" 049                                                                       8
43 Vermont 	VT 	50 	"State; counties" 050                                                                    1
44 Virginia 	VA 	51 	"State; counties" 051                                                                   5
********"Virgin Islands of the U.S." 	VI 	78 	"Outlying area under U.S. sovereignty" .                    10
*******"Wake Island" "" 		79 	"Minor outlying island territory" .                                         10
45 Washington 	WA 	53 	"State; counties" 053                                                                 9
46 "West Virginia" 	WV 	54 	"State; counties" 054                                                            5
47 Wisconsin 	WI 	55 	"State; counties" 055                                                                  3
48 Wyoming 	WY 	56 	"State; counties" 056                                                                    8
end
sort bpl state
drop crap


save "$startdir/$outputdata\fipscodes.dta", replace

