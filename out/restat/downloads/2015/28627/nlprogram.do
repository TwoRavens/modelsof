#delimit;

program nlw;
            version 10;
            syntax varlist(min=328 max=328) /*[aw fw iw]*/ if, at(name);
            
		local ln_trade: word 1 of `varlist';
		local zhatbarstar: word 2 of `varlist'; /*this is referred to as zhatbarstar in HMR*/
		local invmillman: word 3 of `varlist'; /*inverse mills ratio*/
		local ln_distance: word 4 of `varlist';
		local border: word 5 of `varlist';
		local island2: word 6 of `varlist';
		local land2: word 7 of `varlist';
		local legalsystem_same: word 8 of `varlist';
		local common_lang: word 9 of `varlist';
		local colonial: word 10 of `varlist';
		local cu: word 11 of `varlist';
		local fta: word 12 of `varlist';
		
		local	exdum1:	word	13		of	`varlist'	;
		local	exdum2:	word	14		of	`varlist'	;
		local	exdum3:	word	15		of	`varlist'	;
		local	exdum4:	word	16		of	`varlist'	;
		local	exdum5:	word	17		of	`varlist'	;
		local	exdum6:	word	18		of	`varlist'	;
		local	exdum7:	word	19		of	`varlist'	;
		local	exdum8:	word	20		of	`varlist'	;
		local	exdum9:	word	21		of	`varlist'	;
		local	exdum10:	word	22		of	`varlist'	;
		local	exdum11:	word	23		of	`varlist'	;
		local	exdum12:	word	24		of	`varlist'	;
		local	exdum13:	word	25		of	`varlist'	;
		local	exdum14:	word	26		of	`varlist'	;
		local	exdum15:	word	27		of	`varlist'	;
		local	exdum16:	word	28		of	`varlist'	;
		local	exdum17:	word	29		of	`varlist'	;
		local	exdum18:	word	30		of	`varlist'	;
		local	exdum19:	word	31		of	`varlist'	;
		local	exdum20:	word	32		of	`varlist'	;
		local	exdum21:	word	33		of	`varlist'	;
		local	exdum22:	word	34		of	`varlist'	;
		local	exdum23:	word	35		of	`varlist'	;
		local	exdum24:	word	36		of	`varlist'	;
		local	exdum25:	word	37		of	`varlist'	;
		local	exdum26:	word	38		of	`varlist'	;
		local	exdum27:	word	39		of	`varlist'	;
		local	exdum28:	word	40		of	`varlist'	;
		local	exdum29:	word	41		of	`varlist'	;
		local	exdum30:	word	42		of	`varlist'	;
		local	exdum31:	word	43		of	`varlist'	;
		local	exdum32:	word	44		of	`varlist'	;
		local	exdum33:	word	45		of	`varlist'	;
		local	exdum34:	word	46		of	`varlist'	;
		local	exdum35:	word	47		of	`varlist'	;
		local	exdum36:	word	48		of	`varlist'	;
		local	exdum37:	word	49		of	`varlist'	;
		local	exdum38:	word	50		of	`varlist'	;
		local	exdum39:	word	51		of	`varlist'	;
		local	exdum40:	word	52		of	`varlist'	;
		local	exdum41:	word	53		of	`varlist'	;
		local	exdum42:	word	54		of	`varlist'	;
		local	exdum43:	word	55		of	`varlist'	;
		local	exdum44:	word	56		of	`varlist'	;
		local	exdum45:	word	57		of	`varlist'	;
		local	exdum46:	word	58		of	`varlist'	;
		local	exdum47:	word	59		of	`varlist'	;
		local	exdum48:	word	60		of	`varlist'	;
		local	exdum49:	word	61		of	`varlist'	;
		local	exdum50:	word	62		of	`varlist'	;
		local	exdum51:	word	63		of	`varlist'	;
		local	exdum52:	word	64		of	`varlist'	;
		local	exdum53:	word	65		of	`varlist'	;
		local	exdum54:	word	66		of	`varlist'	;
		local	exdum55:	word	67		of	`varlist'	;
		local	exdum56:	word	68		of	`varlist'	;
		local	exdum57:	word	69		of	`varlist'	;
		local	exdum58:	word	70		of	`varlist'	;
		local	exdum59:	word	71		of	`varlist'	;
		local	exdum60:	word	72		of	`varlist'	;
		local	exdum61:	word	73		of	`varlist'	;
		local	exdum62:	word	74		of	`varlist'	;
		local	exdum63:	word	75		of	`varlist'	;
		local	exdum64:	word	76		of	`varlist'	;
		local	exdum65:	word	77		of	`varlist'	;
		local	exdum66:	word	78		of	`varlist'	;
		local	exdum67:	word	79		of	`varlist'	;
		local	exdum68:	word	80		of	`varlist'	;
		local	exdum69:	word	81		of	`varlist'	;
		local	exdum70:	word	82		of	`varlist'	;
		local	exdum71:	word	83		of	`varlist'	;
		local	exdum72:	word	84		of	`varlist'	;
		local	exdum73:	word	85		of	`varlist'	;
		local	exdum74:	word	86		of	`varlist'	;
		local	exdum75:	word	87		of	`varlist'	;
		local	exdum76:	word	88		of	`varlist'	;
		local	exdum77:	word	89		of	`varlist'	;
		local	exdum78:	word	90		of	`varlist'	;
		local	exdum79:	word	91		of	`varlist'	;
		local	exdum80:	word	92		of	`varlist'	;
		local	exdum81:	word	93		of	`varlist'	;
		local	exdum82:	word	94		of	`varlist'	;
		local	exdum83:	word	95		of	`varlist'	;
		local	exdum84:	word	96		of	`varlist'	;
		local	exdum85:	word	97		of	`varlist'	;
		local	exdum86:	word	98		of	`varlist'	;
		local	exdum87:	word	99		of	`varlist'	;
		local	exdum88:	word	100		of	`varlist'	;
		local	exdum89:	word	101		of	`varlist'	;
		local	exdum90:	word	102		of	`varlist'	;
		local	exdum91:	word	103		of	`varlist'	;
		local	exdum92:	word	104		of	`varlist'	;
		local	exdum93:	word	105		of	`varlist'	;
		local	exdum94:	word	106		of	`varlist'	;
		local	exdum95:	word	107		of	`varlist'	;
		local	exdum96:	word	108		of	`varlist'	;
		local	exdum97:	word	109		of	`varlist'	;
		local	exdum98:	word	110		of	`varlist'	;
		local	exdum99:	word	111		of	`varlist'	;
		local	exdum100:	word	112		of	`varlist'	;
		local	exdum101:	word	113		of	`varlist'	;
		local	exdum102:	word	114		of	`varlist'	;
		local	exdum103:	word	115		of	`varlist'	;
		local	exdum104:	word	116		of	`varlist'	;
		local	exdum105:	word	117		of	`varlist'	;
		local	exdum106:	word	118		of	`varlist'	;
		local	exdum107:	word	119		of	`varlist'	;
		local	exdum108:	word	120		of	`varlist'	;
		local	exdum109:	word	121		of	`varlist'	;
		local	exdum110:	word	122		of	`varlist'	;
		local	exdum111:	word	123		of	`varlist'	;
		local	exdum112:	word	124		of	`varlist'	;
		local	exdum113:	word	125		of	`varlist'	;
		local	exdum114:	word	126		of	`varlist'	;
		local	exdum115:	word	127		of	`varlist'	;
		local	exdum116:	word	128		of	`varlist'	;
		local	exdum117:	word	129		of	`varlist'	;
		local	exdum118:	word	130		of	`varlist'	;
		local	exdum119:	word	131		of	`varlist'	;
		local	exdum120:	word	132		of	`varlist'	;
		local	exdum121:	word	133		of	`varlist'	;
		local	exdum122:	word	134		of	`varlist'	;
		local	exdum123:	word	135		of	`varlist'	;
		local	exdum124:	word	136		of	`varlist'	;
		local	exdum125:	word	137		of	`varlist'	;
		local	exdum126:	word	138		of	`varlist'	;
		local	exdum127:	word	139		of	`varlist'	;
		local	exdum128:	word	140		of	`varlist'	;
		local	exdum129:	word	141		of	`varlist'	;
		local	exdum130:	word	142		of	`varlist'	;
		local	exdum131:	word	143		of	`varlist'	;
		local	exdum132:	word	144		of	`varlist'	;
		local	exdum133:	word	145		of	`varlist'	;
		local	exdum134:	word	146		of	`varlist'	;
		local	exdum135:	word	147		of	`varlist'	;
		local	exdum136:	word	148		of	`varlist'	;
		local	exdum137:	word	149		of	`varlist'	;
		local	exdum138:	word	150		of	`varlist'	;
		local	exdum139:	word	151		of	`varlist'	;
		local	exdum140:	word	152		of	`varlist'	;
		local	exdum141:	word	153		of	`varlist'	;
		local	exdum142:	word	154		of	`varlist'	;
		local	exdum143:	word	155		of	`varlist'	;
		local	exdum144:	word	156		of	`varlist'	;
		local	exdum145:	word	157		of	`varlist'	;
		local	exdum146:	word	158		of	`varlist'	;
		local	exdum147:	word	159		of	`varlist'	;
		local	exdum148:	word	160		of	`varlist'	;
		local	exdum149:	word	161		of	`varlist'	;
		local	exdum150:	word	162		of	`varlist'	;
		local	exdum151:	word	163		of	`varlist'	;
		local	exdum152:	word	164		of	`varlist'	;
		local	exdum153:	word	165		of	`varlist'	;
		local	exdum154:	word	166		of	`varlist'	;
		local	exdum155:	word	167		of	`varlist'	;
		local	exdum156:	word	168		of	`varlist'	;
		local	exdum157:	word	169		of	`varlist'	;
		local	exdum158:	word	170		of	`varlist'	;
		
		local	imdum1:	word	171		of	`varlist'	;
		local	imdum2:	word	172		of	`varlist'	;
		local		imdum3:	word	173		of	`varlist'	;
		local		imdum4:	word	174		of	`varlist'	;
		local		imdum5:	word	175		of	`varlist'	;
		local		imdum6:	word	176		of	`varlist'	;
		local		imdum7:	word	177		of	`varlist'	;
		local		imdum8:	word	178		of	`varlist'	;
		local		imdum9:	word	179		of	`varlist'	;
		local		imdum10:	word	180		of	`varlist'	;
		local		imdum11:	word	181		of	`varlist'	;
		local		imdum12:	word	182		of	`varlist'	;
		local		imdum13:	word	183		of	`varlist'	;
		local		imdum14:	word	184		of	`varlist'	;
		local		imdum15:	word	185		of	`varlist'	;
		local		imdum16:	word	186		of	`varlist'	;
		local		imdum17:	word	187		of	`varlist'	;
		local		imdum18:	word	188		of	`varlist'	;
		local		imdum19:	word	189		of	`varlist'	;
		local		imdum20:	word	190		of	`varlist'	;
		local		imdum21:	word	191		of	`varlist'	;
		local		imdum22:	word	192		of	`varlist'	;
		local		imdum23:	word	193		of	`varlist'	;
		local		imdum24:	word	194		of	`varlist'	;
		local		imdum25:	word	195		of	`varlist'	;
		local		imdum26:	word	196		of	`varlist'	;
		local		imdum27:	word	197		of	`varlist'	;
		local		imdum28:	word	198		of	`varlist'	;
		local		imdum29:	word	199		of	`varlist'	;
		local		imdum30:	word	200		of	`varlist'	;
		local		imdum31:	word	201		of	`varlist'	;
		local		imdum32:	word	202		of	`varlist'	;
		local		imdum33:	word	203		of	`varlist'	;
		local		imdum34:	word	204		of	`varlist'	;
		local		imdum35:	word	205		of	`varlist'	;
		local		imdum36:	word	206		of	`varlist'	;
		local		imdum37:	word	207		of	`varlist'	;
		local		imdum38:	word	208		of	`varlist'	;
		local		imdum39:	word	209		of	`varlist'	;
		local		imdum40:	word	210		of	`varlist'	;
		local		imdum41:	word	211		of	`varlist'	;
		local		imdum42:	word	212		of	`varlist'	;
		local		imdum43:	word	213		of	`varlist'	;
		local		imdum44:	word	214		of	`varlist'	;
		local		imdum45:	word	215		of	`varlist'	;
		local		imdum46:	word	216		of	`varlist'	;
		local		imdum47:	word	217		of	`varlist'	;
		local		imdum48:	word	218		of	`varlist'	;
		local		imdum49:	word	219		of	`varlist'	;
		local		imdum50:	word	220		of	`varlist'	;
		local		imdum51:	word	221		of	`varlist'	;
		local		imdum52:	word	222		of	`varlist'	;
		local		imdum53:	word	223		of	`varlist'	;
		local		imdum54:	word	224		of	`varlist'	;
		local		imdum55:	word	225		of	`varlist'	;
		local		imdum56:	word	226		of	`varlist'	;
		local		imdum57:	word	227		of	`varlist'	;
		local		imdum58:	word	228		of	`varlist'	;
		local		imdum59:	word	229		of	`varlist'	;
		local		imdum60:	word	230		of	`varlist'	;
		local		imdum61:	word	231		of	`varlist'	;
		local		imdum62:	word	232		of	`varlist'	;
		local		imdum63:	word	233		of	`varlist'	;
		local		imdum64:	word	234		of	`varlist'	;
		local		imdum65:	word	235		of	`varlist'	;
		local		imdum66:	word	236		of	`varlist'	;
		local		imdum67:	word	237		of	`varlist'	;
		local		imdum68:	word	238		of	`varlist'	;
		local		imdum69:	word	239		of	`varlist'	;
		local		imdum70:	word	240		of	`varlist'	;
		local		imdum71:	word	241		of	`varlist'	;
		local		imdum72:	word	242		of	`varlist'	;
		local		imdum73:	word	243		of	`varlist'	;
		local		imdum74:	word	244		of	`varlist'	;
		local		imdum75:	word	245		of	`varlist'	;
		local		imdum76:	word	246		of	`varlist'	;
		local		imdum77:	word	247		of	`varlist'	;
		local		imdum78:	word	248		of	`varlist'	;
		local		imdum79:	word	249		of	`varlist'	;
		local		imdum80:	word	250		of	`varlist'	;
		local		imdum81:	word	251		of	`varlist'	;
		local		imdum82:	word	252		of	`varlist'	;
		local		imdum83:	word	253		of	`varlist'	;
		local		imdum84:	word	254		of	`varlist'	;
		local		imdum85:	word	255		of	`varlist'	;
		local		imdum86:	word	256		of	`varlist'	;
		local		imdum87:	word	257		of	`varlist'	;
		local		imdum88:	word	258		of	`varlist'	;
		local		imdum89:	word	259		of	`varlist'	;
		local		imdum90:	word	260		of	`varlist'	;
		local		imdum91:	word	261		of	`varlist'	;
		local		imdum92:	word	262		of	`varlist'	;
		local		imdum93:	word	263		of	`varlist'	;
		local		imdum94:	word	264		of	`varlist'	;
		local		imdum95:	word	265		of	`varlist'	;
		local		imdum96:	word	266		of	`varlist'	;
		local		imdum97:	word	267		of	`varlist'	;
		local		imdum98:	word	268		of	`varlist'	;
		local		imdum99:	word	269		of	`varlist'	;
		local		imdum100:	word	270		of	`varlist'	; 
		local		imdum101:	word	271		of	`varlist'	;
		local		imdum102:	word	272		of	`varlist'	;
		local		imdum103:	word	273		of	`varlist'	;
		local		imdum104:	word	274		of	`varlist'	;
		local		imdum105:	word	275		of	`varlist'	;
		local		imdum106:	word	276		of	`varlist'	;
		local		imdum107:	word	277		of	`varlist'	;
		local		imdum108:	word	278		of	`varlist'	;
		local		imdum109:	word	279		of	`varlist'	;
		local		imdum110:	word	280		of	`varlist'	;
		local		imdum111:	word	281		of	`varlist'	;
		local		imdum112:	word	282		of	`varlist'	;
		local		imdum113:	word	283		of	`varlist'	;
		local		imdum114:	word	284		of	`varlist'	;
		local		imdum115:	word	285		of	`varlist'	;
		local		imdum116:	word	286		of	`varlist'	;
		local		imdum117:	word	287		of	`varlist'	;
		local		imdum118:	word	288		of	`varlist'	;
		local		imdum119:	word	289		of	`varlist'	;
		local		imdum120:	word	290		of	`varlist'	;
		local		imdum121:	word	291		of	`varlist'	;
		local		imdum122:	word	292		of	`varlist'	;
		local		imdum123:	word	293		of	`varlist'	;
		local		imdum124:	word	294		of	`varlist'	;
		local		imdum125:	word	295		of	`varlist'	;
		local		imdum126:	word	296		of	`varlist'	;
		local		imdum127:	word	297		of	`varlist'	;
		local		imdum128:	word	298		of	`varlist'	;
		local		imdum129:	word	299		of	`varlist'	;
		local		imdum130:	word	300		of	`varlist'	;
		local		imdum131:	word	301		of	`varlist'	;
		local		imdum132:	word	302		of	`varlist'	;
		local		imdum133:	word	303		of	`varlist'	;
		local		imdum134:	word	304		of	`varlist'	;
		local		imdum135:	word	305		of	`varlist'	;
		local		imdum136:	word	306		of	`varlist'	;
		local		imdum137:	word	307		of	`varlist'	;
		local		imdum138:	word	308		of	`varlist'	;
		local		imdum139:	word	309		of	`varlist'	;
		local		imdum140:	word	310		of	`varlist'	;
		local		imdum141:	word	311		of	`varlist'	;
		local		imdum142:	word	312		of	`varlist'	;
		local		imdum143:	word	313		of	`varlist'	;
		local		imdum144:	word	314		of	`varlist'	;
		local		imdum145:	word	315		of	`varlist'	;
		local		imdum146:	word	316		of	`varlist'	;
		local		imdum147:	word	317		of	`varlist'	;
		local		imdum148:	word	318		of	`varlist'	;
		local		imdum149:	word	319		of	`varlist'	;
		local		imdum150:	word	320		of	`varlist'	;
		local		imdum151:	word	321		of	`varlist'	;
		local		imdum152:	word	322		of	`varlist'	;
		local		imdum153:	word	323		of	`varlist'	;
		local		imdum154:	word	324		of	`varlist'	;
		local		imdum155:	word	325		of	`varlist'	;
		local		imdum156:	word	326		of	`varlist'	;
		local		imdum157:	word	327		of	`varlist'	;
		local		imdum158:	word	328		of	`varlist'	;
		tempname constant delta xb_invmillman xb_ln_distance xb_border xb_island2 xb_land2 xb_legalsystem_same xb_common_lang xb_colonial xb_cu xb_fta 
dexdum1
dexdum2
dexdum3
dexdum4
dexdum5
dexdum6
dexdum7
dexdum8
dexdum9
dexdum10
dexdum11
dexdum12
dexdum13
dexdum14
dexdum15
dexdum16
dexdum17
dexdum18
dexdum19
dexdum20
dexdum21
dexdum22
dexdum23
dexdum24
dexdum25
dexdum26
dexdum27
dexdum28
dexdum29
dexdum30
dexdum31
dexdum32
dexdum33
dexdum34
dexdum35
dexdum36
dexdum37
dexdum38
dexdum39
dexdum40
dexdum41
dexdum42
dexdum43
dexdum44
dexdum45
dexdum46
dexdum47
dexdum48
dexdum49
dexdum50
dexdum51
dexdum52
dexdum53
dexdum54
dexdum55
dexdum56
dexdum57
dexdum58
dexdum59
dexdum60
dexdum61
dexdum62
dexdum63
dexdum64
dexdum65
dexdum66
dexdum67
dexdum68
dexdum69
dexdum70
dexdum71
dexdum72
dexdum73
dexdum74
dexdum75
dexdum76
dexdum77
dexdum78
dexdum79
dexdum80
dexdum81
dexdum82
dexdum83
dexdum84
dexdum85
dexdum86
dexdum87
dexdum88
dexdum89
dexdum90
dexdum91
dexdum92
dexdum93
dexdum94
dexdum95
dexdum96
dexdum97
dexdum98
dexdum99
dexdum100
dexdum101
dexdum102
dexdum103
dexdum104
dexdum105
dexdum106
dexdum107
dexdum108
dexdum109
dexdum110
dexdum111
dexdum112
dexdum113
dexdum114
dexdum115
dexdum116
dexdum117
dexdum118
dexdum119
dexdum120
dexdum121
dexdum122
dexdum123
dexdum124
dexdum125
dexdum126
dexdum127
dexdum128
dexdum129
dexdum130
dexdum131
dexdum132
dexdum133
dexdum134
dexdum135
dexdum136
dexdum137
dexdum138
dexdum139
dexdum140
dexdum141
dexdum142
dexdum143
dexdum144
dexdum145
dexdum146
dexdum147
dexdum148
dexdum149
dexdum150
dexdum151
dexdum152
dexdum153
dexdum154
dexdum155
dexdum156
dexdum157
dexdum158

dimdum1
dimdum2
dimdum3
dimdum4
dimdum5
dimdum6
dimdum7
dimdum8
dimdum9
dimdum10
dimdum11
dimdum12
dimdum13
dimdum14
dimdum15
dimdum16
dimdum17
dimdum18
dimdum19
dimdum20
dimdum21
dimdum22
dimdum23
dimdum24
dimdum25
dimdum26
dimdum27
dimdum28
dimdum29
dimdum30
dimdum31
dimdum32
dimdum33
dimdum34
dimdum35
dimdum36
dimdum37
dimdum38
dimdum39
dimdum40
dimdum41
dimdum42
dimdum43
dimdum44
dimdum45
dimdum46
dimdum47
dimdum48
dimdum49
dimdum50
dimdum51
dimdum52
dimdum53
dimdum54
dimdum55
dimdum56
dimdum57
dimdum58
dimdum59
dimdum60
dimdum61
dimdum62
dimdum63
dimdum64
dimdum65
dimdum66
dimdum67
dimdum68
dimdum69
dimdum70
dimdum71
dimdum72
dimdum73
dimdum74
dimdum75
dimdum76
dimdum77
dimdum78
dimdum79
dimdum80
dimdum81
dimdum82
dimdum83
dimdum84
dimdum85
dimdum86
dimdum87
dimdum88
dimdum89
dimdum90
dimdum91
dimdum92
dimdum93
dimdum94
dimdum95
dimdum96
dimdum97
dimdum98
dimdum99
dimdum100 
dimdum101
dimdum102
dimdum103
dimdum104
dimdum105
dimdum106
dimdum107
dimdum108
dimdum109
dimdum110
dimdum111
dimdum112
dimdum113
dimdum114
dimdum115
dimdum116
dimdum117
dimdum118
dimdum119
dimdum120
dimdum121
dimdum122
dimdum123
dimdum124
dimdum125
dimdum126
dimdum127
dimdum128
dimdum129
dimdum130
dimdum131
dimdum132
dimdum133
dimdum134
dimdum135
dimdum136
dimdum137
dimdum138
dimdum139
dimdum140
dimdum141
dimdum142
dimdum143
dimdum144
dimdum145
dimdum146
dimdum147
dimdum148
dimdum149
dimdum150
dimdum151
dimdum152
dimdum153
dimdum154
dimdum155
dimdum156
dimdum157
dimdum158
;
		scalar `constant' = `at'[1,1];
		scalar `delta' = `at'[1,2] ;
		scalar `xb_invmillman' = `at'[1,3];
		scalar `xb_ln_distance' = `at'[1,4];
		scalar `xb_border' = `at'[1,5];
		scalar `xb_island2' = `at'[1,6];
		scalar `xb_land2' = `at'[1,7];
		scalar `xb_legalsystem_same' = `at'[1,8];
		scalar `xb_common_lang' = `at'[1,9];
		scalar `xb_colonial' = `at'[1,10];
		scalar `xb_cu' = `at'[1,11];
		scalar `xb_fta' = `at'[1,12];

		scalar `dexdum1'	=	`at'[1,13]	;
		scalar `dexdum2'	=	`at'[1,14]	;
		scalar `dexdum3'	=	`at'[1,15]	;
		scalar `dexdum4'	=	`at'[1,16]	;
		scalar `dexdum5'	=	`at'[1,17]	;
		scalar `dexdum6'		=	`at'[1,18]	;
		scalar `dexdum7'		=	`at'[1,19]	;
		scalar `dexdum8'		=	`at'[1,20]	;
		scalar `dexdum9'		=	`at'[1,21]	;
		scalar `dexdum10'		=	`at'[1,22]	;
		scalar `dexdum11'		=	`at'[1,23]	;
		scalar `dexdum12'		=	`at'[1,24]	;
		scalar `dexdum13'		=	`at'[1,25]	;
		scalar `dexdum14'		=	`at'[1,26]	;
		scalar `dexdum15'		=	`at'[1,27]	;
		scalar `dexdum16'		=	`at'[1,28]	;
		scalar `dexdum17'		=	`at'[1,29]	;
		scalar `dexdum18'		=	`at'[1,30]	;
		scalar `dexdum19'		=	`at'[1,31]	;
		scalar `dexdum20'		=	`at'[1,32]	;
		scalar `dexdum21'		=	`at'[1,33]	;
		scalar `dexdum22'		=	`at'[1,34]	;
		scalar `dexdum23'		=	`at'[1,35]	;
		scalar `dexdum24'		=	`at'[1,36]	;
		scalar `dexdum25'		=	`at'[1,37]	;
		scalar `dexdum26'		=	`at'[1,38]	;
		scalar `dexdum27'		=	`at'[1,39]	;
		scalar `dexdum28'		=	`at'[1,40]	;
		scalar `dexdum29'		=	`at'[1,41]	;
		scalar `dexdum30'		=	`at'[1,42]	;
		scalar `dexdum31'		=	`at'[1,43]	;
		scalar `dexdum32'		=	`at'[1,44]	;
		scalar `dexdum33'		=	`at'[1,45]	;
		scalar `dexdum34'		=	`at'[1,46]	;
		scalar `dexdum35'		=	`at'[1,47]	;
		scalar `dexdum36'		=	`at'[1,48]	;
		scalar `dexdum37'		=	`at'[1,49]	;
		scalar `dexdum38'		=	`at'[1,50]	;
		scalar `dexdum39'		=	`at'[1,51]	;
		scalar `dexdum40'		=	`at'[1,52]	;
		scalar `dexdum41'		=	`at'[1,53]	;
		scalar `dexdum42'		=	`at'[1,54]	;
		scalar `dexdum43'		=	`at'[1,55]	;
		scalar `dexdum44'		=	`at'[1,56]	;
		scalar `dexdum45'		=	`at'[1,57]	;
		scalar `dexdum46'		=	`at'[1,58]	;
		scalar `dexdum47'		=	`at'[1,59]	;
		scalar `dexdum48'		=	`at'[1,60]	;
		scalar `dexdum49'		=	`at'[1,61]	;
		scalar `dexdum50'		=	`at'[1,62]	;
		scalar `dexdum51'		=	`at'[1,63]	;
		scalar `dexdum52'		=	`at'[1,64]	;
		scalar `dexdum53'		=	`at'[1,65]	;
		scalar `dexdum54'		=	`at'[1,66]	;
		scalar `dexdum55'		=	`at'[1,67]	;
		scalar `dexdum56'		=	`at'[1,68]	;
		scalar `dexdum57'		=	`at'[1,69]	;
		scalar `dexdum58'		=	`at'[1,70]	;
		scalar `dexdum59'		=	`at'[1,71]	;
		scalar `dexdum60'		=	`at'[1,72]	;
		scalar `dexdum61'		=	`at'[1,73]	;
		scalar `dexdum62'		=	`at'[1,74]	;
		scalar `dexdum63'		=	`at'[1,75]	;
		scalar `dexdum64'		=	`at'[1,76]	;
		scalar `dexdum65'		=	`at'[1,77]	;
		scalar `dexdum66'		=	`at'[1,78]	;
		scalar `dexdum67'		=	`at'[1,79]	;
		scalar `dexdum68'		=	`at'[1,80]	;
		scalar `dexdum69'		=	`at'[1,81]	;
		scalar `dexdum70'		=	`at'[1,82]	;
		scalar `dexdum71'		=	`at'[1,83]	;
		scalar `dexdum72'		=	`at'[1,84]	;
		scalar `dexdum73'		=	`at'[1,85]	;
		scalar `dexdum74'		=	`at'[1,86]	;
		scalar `dexdum75'		=	`at'[1,87]	;
		scalar `dexdum76'		=	`at'[1,88]	;
		scalar `dexdum77'		=	`at'[1,89]	;
		scalar `dexdum78'		=	`at'[1,90]	;
		scalar `dexdum79'		=	`at'[1,91]	;
		scalar `dexdum80'		=	`at'[1,92]	;
		scalar `dexdum81'		=	`at'[1,93]	;
		scalar `dexdum82'		=	`at'[1,94]	;
		scalar `dexdum83'		=	`at'[1,95]	;
		scalar `dexdum84'		=	`at'[1,96]	;
		scalar `dexdum85'		=	`at'[1,97]	;
		scalar `dexdum86'		=	`at'[1,98]	;
		scalar `dexdum87'		=	`at'[1,99]	;
		scalar `dexdum88'		=	`at'[1,100]	;
		scalar `dexdum89'		=	`at'[1,101]	;
		scalar `dexdum90'		=	`at'[1,102]	;
		scalar `dexdum91'		=	`at'[1,103]	;
		scalar `dexdum92'		=	`at'[1,104]	;
		scalar `dexdum93'		=	`at'[1,105]	;
		scalar `dexdum94'		=	`at'[1,106]	;
		scalar `dexdum95'		=	`at'[1,107]	;
		scalar `dexdum96'		=	`at'[1,108]	;
		scalar `dexdum97'		=	`at'[1,109]	;
		scalar `dexdum98'		=	`at'[1,110]	;
		scalar `dexdum99'		=	`at'[1,111]	;
		scalar `dexdum100'		=	`at'[1,112]	;
		scalar `dexdum101'		=	`at'[1,113]	;
		scalar `dexdum102'		=	`at'[1,114]	;
		scalar `dexdum103'		=	`at'[1,115]	;
		scalar `dexdum104'		=	`at'[1,116]	;
		scalar `dexdum105'		=	`at'[1,117]	;
		scalar `dexdum106'		=	`at'[1,118]	;
		scalar `dexdum107'		=	`at'[1,119]	;
		scalar `dexdum108'		=	`at'[1,120]	;
		scalar `dexdum109'		=	`at'[1,121]	;
		scalar `dexdum110'		=	`at'[1,122]	;
		scalar `dexdum111'		=	`at'[1,123]	;
		scalar `dexdum112'		=	`at'[1,124]	;
		scalar `dexdum113'		=	`at'[1,125]	;
		scalar `dexdum114'		=	`at'[1,126]	;
		scalar `dexdum115'		=	`at'[1,127]	;
		scalar `dexdum116'		=	`at'[1,128]	;
		scalar `dexdum117'		=	`at'[1,129]	;
		scalar `dexdum118'		=	`at'[1,130]	;
		scalar `dexdum119'		=	`at'[1,131]	;
		scalar `dexdum120'		=	`at'[1,132]	;
		scalar `dexdum121'		=	`at'[1,133]	;
		scalar `dexdum122'		=	`at'[1,134]	;
		scalar `dexdum123'		=	`at'[1,135]	;
		scalar `dexdum124'		=	`at'[1,136]	;
		scalar `dexdum125'		=	`at'[1,137]	;
		scalar `dexdum126'		=	`at'[1,138]	;
		scalar `dexdum127'		=	`at'[1,139]	;
		scalar `dexdum128'		=	`at'[1,140]	;
		scalar `dexdum129'		=	`at'[1,141]	;
		scalar `dexdum130'		=	`at'[1,142]	;
		scalar `dexdum131'		=	`at'[1,143]	;
		scalar `dexdum132'		=	`at'[1,144]	;
		scalar `dexdum133'		=	`at'[1,145]	;
		scalar `dexdum134'		=	`at'[1,146]	;
		scalar `dexdum135'		=	`at'[1,147]	;
		scalar `dexdum136'		=	`at'[1,148]	;
		scalar `dexdum137'		=	`at'[1,149]	;
		scalar `dexdum138'		=	`at'[1,150]	;
		scalar `dexdum139'		=	`at'[1,151]	;
		scalar `dexdum140'		=	`at'[1,152]	;
		scalar `dexdum141'		=	`at'[1,153]	;
		scalar `dexdum142'		=	`at'[1,154]	;
		scalar `dexdum143'		=	`at'[1,155]	;
		scalar `dexdum144'		=	`at'[1,156]	;
		scalar `dexdum145'		=	`at'[1,157]	;
		scalar `dexdum146'		=	`at'[1,158]	;
		scalar `dexdum147'		=	`at'[1,159]	;
		scalar `dexdum148'		=	`at'[1,160]	;
		scalar `dexdum149'		=	`at'[1,161]	;
		scalar `dexdum150'		=	`at'[1,162]	;
		scalar `dexdum151'		=	`at'[1,163]	;
		scalar `dexdum152'		=	`at'[1,164]	;
		scalar `dexdum153'		=	`at'[1,165]	;
		scalar `dexdum154'		=	`at'[1,166]	;
		scalar `dexdum155'		=	`at'[1,167]	;
		scalar `dexdum156'		=	`at'[1,168]	;
		scalar `dexdum157'		=	`at'[1,169]	;
		scalar `dexdum158'		=	`at'[1,170]	;
		
		scalar	`dimdum1'		=	`at'[1,171]	;
		scalar	`dimdum2'		=	`at'[1,172]	;
		scalar	`dimdum3'		=	`at'[1,173]	;
		scalar	`dimdum4'		=	`at'[1,174]	;
		scalar	`dimdum5'		=	`at'[1,175]	;
		scalar	`dimdum6'		=	`at'[1,176]	;
		scalar	`dimdum7'		=	`at'[1,177]	;
		scalar	`dimdum8'		=	`at'[1,178]	;
		scalar	`dimdum9'		=	`at'[1,179]	;
		scalar	`dimdum10'		=	`at'[1,180]	;
		scalar	`dimdum11'		=	`at'[1,181]	;
		scalar	`dimdum12'		=	`at'[1,182]	;
		scalar	`dimdum13'		=	`at'[1,183]	;
		scalar	`dimdum14'		=	`at'[1,184]	;
		scalar	`dimdum15'		=	`at'[1,185]	;
		scalar	`dimdum16'		=	`at'[1,186]	;
		scalar	`dimdum17'		=	`at'[1,187]	;
		scalar	`dimdum18'		=	`at'[1,188]	;
		scalar	`dimdum19'		=	`at'[1,189]	;
		scalar	`dimdum20'		=	`at'[1,190]	;
		scalar	`dimdum21'		=	`at'[1,191]	;
		scalar	`dimdum22'		=	`at'[1,192]	;
		scalar	`dimdum23'		=	`at'[1,193]	;
		scalar	`dimdum24'		=	`at'[1,194]	;
		scalar	`dimdum25'		=	`at'[1,195]	;
		scalar	`dimdum26'		=	`at'[1,196]	;
		scalar	`dimdum27'		=	`at'[1,197]	;
		scalar	`dimdum28'		=	`at'[1,198]	;
		scalar	`dimdum29'		=	`at'[1,199]	;
		scalar	`dimdum30'		=	`at'[1,200]	;
		scalar	`dimdum31'		=	`at'[1,201]	;
		scalar	`dimdum32'		=	`at'[1,202]	;
		scalar	`dimdum33'		=	`at'[1,203]	;
		scalar	`dimdum34'		=	`at'[1,204]	;
		scalar	`dimdum35'		=	`at'[1,205]	;
		scalar	`dimdum36'		=	`at'[1,206]	;
		scalar	`dimdum37'		=	`at'[1,207]	;
		scalar	`dimdum38'		=	`at'[1,208]	;
		scalar	`dimdum39'		=	`at'[1,209]	;
		scalar	`dimdum40'		=	`at'[1,210]	;
		scalar	`dimdum41'		=	`at'[1,211]	;
		scalar	`dimdum42'		=	`at'[1,212]	;
		scalar	`dimdum43'		=	`at'[1,213]	;
		scalar	`dimdum44'		=	`at'[1,214]	;
		scalar	`dimdum45'		=	`at'[1,215]	;
		scalar	`dimdum46'		=	`at'[1,216]	;
		scalar	`dimdum47'		=	`at'[1,217]	;
		scalar	`dimdum48'		=	`at'[1,218]	;
		scalar	`dimdum49'		=	`at'[1,219]	;
		scalar	`dimdum50'		=	`at'[1,220]	;
		scalar	`dimdum51'		=	`at'[1,221]	;
		scalar	`dimdum52'		=	`at'[1,222]	;
		scalar	`dimdum53'		=	`at'[1,223]	;
		scalar	`dimdum54'		=	`at'[1,224]	;
		scalar	`dimdum55'		=	`at'[1,225]	;
		scalar	`dimdum56'		=	`at'[1,226]	;
		scalar	`dimdum57'		=	`at'[1,227]	;
		scalar	`dimdum58'		=	`at'[1,228]	;
		scalar	`dimdum59'		=	`at'[1,229]	;
		scalar	`dimdum60'		=	`at'[1,230]	;
		scalar	`dimdum61'		=	`at'[1,231]	;
		scalar	`dimdum62'		=	`at'[1,232]	;
		scalar	`dimdum63'		=	`at'[1,233]	;
		scalar	`dimdum64'		=	`at'[1,234]	;
		scalar	`dimdum65'		=	`at'[1,235]	;
		scalar	`dimdum66'		=	`at'[1,236]	;
		scalar	`dimdum67'		=	`at'[1,237]	;
		scalar	`dimdum68'		=	`at'[1,238]	;
		scalar	`dimdum69'		=	`at'[1,239]	;
		scalar	`dimdum70'		=	`at'[1,240]	;
		scalar	`dimdum71'		=	`at'[1,241]	;
		scalar	`dimdum72'		=	`at'[1,242]	;
		scalar	`dimdum73'		=	`at'[1,243]	;
		scalar	`dimdum74'		=	`at'[1,244]	;
		scalar	`dimdum75'		=	`at'[1,245]	;
		scalar	`dimdum76'		=	`at'[1,246]	;
		scalar	`dimdum77'		=	`at'[1,247]	;
		scalar	`dimdum78'		=	`at'[1,248]	;
		scalar	`dimdum79'		=	`at'[1,249]	;
		scalar	`dimdum80'		=	`at'[1,250]	;
		scalar	`dimdum81'		=	`at'[1,251]	;
		scalar	`dimdum82'		=	`at'[1,252]	;
		scalar	`dimdum83'		=	`at'[1,253]	;
		scalar	`dimdum84'		=	`at'[1,254]	;
		scalar	`dimdum85'		=	`at'[1,255]	;
		scalar	`dimdum86'		=	`at'[1,256]	;
		scalar	`dimdum87'		=	`at'[1,257]	;
		scalar	`dimdum88'		=	`at'[1,258]	;
		scalar	`dimdum89'		=	`at'[1,259]	;
		scalar	`dimdum90'		=	`at'[1,260]	;
		scalar	`dimdum91'		=	`at'[1,261]	;
		scalar	`dimdum92'		=	`at'[1,262]	;
		scalar	`dimdum93'		=	`at'[1,263]	;
		scalar	`dimdum94'		=	`at'[1,264]	;
		scalar	`dimdum95'		=	`at'[1,265]	;
		scalar	`dimdum96'		=	`at'[1,266]	;
		scalar	`dimdum97'		=	`at'[1,267]	;
		scalar	`dimdum98'		=	`at'[1,268]	;
		scalar	`dimdum99'		=	`at'[1,269]	;
		scalar	`dimdum100'		=	`at'[1,270]	; 
		scalar	`dimdum101'		=	`at'[1,271]	;
		scalar	`dimdum102'		=	`at'[1,272]	;
		scalar	`dimdum103'		=	`at'[1,273]	;
		scalar	`dimdum104'		=	`at'[1,274]	;
		scalar	`dimdum105'		=	`at'[1,275]	;
		scalar	`dimdum106'		=	`at'[1,276]	;
		scalar	`dimdum107'		=	`at'[1,277]	;
		scalar	`dimdum108'		=	`at'[1,278]	;
		scalar	`dimdum109'		=	`at'[1,279]	;
		scalar	`dimdum110'		=	`at'[1,280]	;
		scalar	`dimdum111'		=	`at'[1,281]	;
		scalar	`dimdum112'		=	`at'[1,282]	;
		scalar	`dimdum113'		=	`at'[1,283]	;
		scalar	`dimdum114'		=	`at'[1,284]	;
		scalar	`dimdum115'		=	`at'[1,285]	;
		scalar	`dimdum116'		=	`at'[1,286]	;
		scalar	`dimdum117'		=	`at'[1,287]	;
		scalar	`dimdum118'		=	`at'[1,288]	;
		scalar	`dimdum119'		=	`at'[1,289]	;
		scalar	`dimdum120'		=	`at'[1,290]	;
		scalar	`dimdum121'		=	`at'[1,291]	;
		scalar	`dimdum122'		=	`at'[1,292]	;
		scalar	`dimdum123'		=	`at'[1,293]	;
		scalar	`dimdum124'		=	`at'[1,294]	;
		scalar	`dimdum125'		=	`at'[1,295]	;
		scalar	`dimdum126'		=	`at'[1,296]	;
		scalar	`dimdum127'		=	`at'[1,297]	;
		scalar	`dimdum128'		=	`at'[1,298]	;
		scalar	`dimdum129'		=	`at'[1,299]	;
		scalar	`dimdum130'		=	`at'[1,300]	;
		scalar	`dimdum131'		=	`at'[1,301]	;
		scalar	`dimdum132'		=	`at'[1,302]	;
		scalar	`dimdum133'		=	`at'[1,303]	;
		scalar	`dimdum134'		=	`at'[1,304]	;
		scalar	`dimdum135'		=	`at'[1,305]	;
		scalar	`dimdum136'		=	`at'[1,306]	;
		scalar	`dimdum137'		=	`at'[1,307]	;
		scalar	`dimdum138'		=	`at'[1,308]	;
		scalar	`dimdum139'		=	`at'[1,309]	;
		scalar	`dimdum140'		=	`at'[1,310]	;
		scalar	`dimdum141'		=	`at'[1,311]	;
		scalar	`dimdum142'		=	`at'[1,312]	;
		scalar	`dimdum143'		=	`at'[1,313]	;
		scalar	`dimdum144'		=	`at'[1,314]	;
		scalar	`dimdum145'		=	`at'[1,315]	;
		scalar	`dimdum146'		=	`at'[1,316]	;
		scalar	`dimdum147'		=	`at'[1,317]	;
		scalar	`dimdum148'		=	`at'[1,318]	;
		scalar	`dimdum149'		=	`at'[1,319]	;
		scalar	`dimdum150'		=	`at'[1,320]	;
		scalar	`dimdum151'		=	`at'[1,321]	;
		scalar	`dimdum152'		=	`at'[1,322]	;
		scalar	`dimdum153'		=	`at'[1,323]	;
		scalar	`dimdum154'		=	`at'[1,324]	;
		scalar	`dimdum155'		=	`at'[1,325]	;
		scalar	`dimdum156'		=	`at'[1,326]	;
		scalar	`dimdum157'		=	`at'[1,327]	;
		scalar	`dimdum158'		=	`at'[1,328]	;
		tempvar omega exdums;
		generate double `omega' = ln(exp(`delta'*`zhatbarstar')-1) `if';
		generate double `exdums' = `dexdum1'*`exdum1'
+	`dexdum2'*`exdum2'
+	`dexdum3'*`exdum3'
+	`dexdum4'*`exdum4'
+	`dexdum5'*`exdum5'
+	`dexdum6'*`exdum6'
+	`dexdum7'*`exdum7'
+	`dexdum8'*`exdum8'
+	`dexdum9'*`exdum9'
+	`dexdum10'*`exdum10'
+	`dexdum11'*`exdum11'
+	`dexdum12'*`exdum12'
+	`dexdum13'*`exdum13'
+	`dexdum14'*`exdum14'
+	`dexdum15'*`exdum15'
+	`dexdum16'*`exdum16'
+	`dexdum17'*`exdum17'
+	`dexdum18'*`exdum18'
+	`dexdum19'*`exdum19'
+	`dexdum20'*`exdum20'
+	`dexdum21'*`exdum21'
+	`dexdum22'*`exdum22'
+	`dexdum23'*`exdum23'
+	`dexdum24'*`exdum24'
+	`dexdum25'*`exdum25'
+	`dexdum26'*`exdum26'
+	`dexdum27'*`exdum27'
+	`dexdum28'*`exdum28'
+	`dexdum29'*`exdum29'
+	`dexdum30'*`exdum30'
+	`dexdum31'*`exdum31'
+	`dexdum32'*`exdum32'
+	`dexdum33'*`exdum33'
+	`dexdum34'*`exdum34'
+	`dexdum35'*`exdum35'
+	`dexdum36'*`exdum36'
+	`dexdum37'*`exdum37'
+	`dexdum38'*`exdum38'
+	`dexdum39'*`exdum39'
+	`dexdum40'*`exdum40'
+	`dexdum41'*`exdum41'
+	`dexdum42'*`exdum42'
+	`dexdum43'*`exdum43'
+	`dexdum44'*`exdum44'
+	`dexdum45'*`exdum45'
+	`dexdum46'*`exdum46'
+	`dexdum47'*`exdum47'
+	`dexdum48'*`exdum48'
+	`dexdum49'*`exdum49'
+	`dexdum50'*`exdum50'
+	`dexdum51'*`exdum51'
+	`dexdum52'*`exdum52'
+	`dexdum53'*`exdum53'
+	`dexdum54'*`exdum54'
+	`dexdum55'*`exdum55'
+	`dexdum56'*`exdum56'
+	`dexdum57'*`exdum57'
+	`dexdum58'*`exdum58'
+	`dexdum59'*`exdum59'
+	`dexdum60'*`exdum60'
+	`dexdum61'*`exdum61'
+	`dexdum62'*`exdum62'
+	`dexdum63'*`exdum63'
+	`dexdum64'*`exdum64'
+	`dexdum65'*`exdum65'
+	`dexdum66'*`exdum66'
+	`dexdum67'*`exdum67'
+	`dexdum68'*`exdum68'
+	`dexdum69'*`exdum69'
+	`dexdum70'*`exdum70'
+	`dexdum71'*`exdum71'
+	`dexdum72'*`exdum72'
+	`dexdum73'*`exdum73'
+	`dexdum74'*`exdum74'
+	`dexdum75'*`exdum75'
+	`dexdum76'*`exdum76'
+	`dexdum77'*`exdum77'
+	`dexdum78'*`exdum78'
+	`dexdum79'*`exdum79'
+	`dexdum80'*`exdum80'
+	`dexdum81'*`exdum81'
+	`dexdum82'*`exdum82'
+	`dexdum83'*`exdum83'
+	`dexdum84'*`exdum84'
+	`dexdum85'*`exdum85'
+	`dexdum86'*`exdum86'
+	`dexdum87'*`exdum87'
+	`dexdum88'*`exdum88'
+	`dexdum89'*`exdum89'
+	`dexdum90'*`exdum90'
+	`dexdum91'*`exdum91'
+	`dexdum92'*`exdum92'
+	`dexdum93'*`exdum93'
+	`dexdum94'*`exdum94'
+	`dexdum95'*`exdum95'
+	`dexdum96'*`exdum96'
+	`dexdum97'*`exdum97'
+	`dexdum98'*`exdum98'
+	`dexdum99'*`exdum99'
+	`dexdum100'*`exdum100'
+	`dexdum101'*`exdum101'
+	`dexdum102'*`exdum102'
+	`dexdum103'*`exdum103'
+	`dexdum104'*`exdum104'
+	`dexdum105'*`exdum105'
+	`dexdum106'*`exdum106'
+	`dexdum107'*`exdum107'
+	`dexdum108'*`exdum108'
+	`dexdum109'*`exdum109'
+	`dexdum110'*`exdum110'
+	`dexdum111'*`exdum111'
+	`dexdum112'*`exdum112'
+	`dexdum113'*`exdum113'
+	`dexdum114'*`exdum114'
+	`dexdum115'*`exdum115'
+	`dexdum116'*`exdum116'
+	`dexdum117'*`exdum117'
+	`dexdum118'*`exdum118'
+	`dexdum119'*`exdum119'
+	`dexdum120'*`exdum120'
+	`dexdum121'*`exdum121'
+	`dexdum122'*`exdum122'
+	`dexdum123'*`exdum123'
+	`dexdum124'*`exdum124'
+	`dexdum125'*`exdum125'
+	`dexdum126'*`exdum126'
+	`dexdum127'*`exdum127'
+	`dexdum128'*`exdum128'
+	`dexdum129'*`exdum129'
+	`dexdum130'*`exdum130'
+	`dexdum131'*`exdum131'
+	`dexdum132'*`exdum132'
+	`dexdum133'*`exdum133'
+	`dexdum134'*`exdum134'
+	`dexdum135'*`exdum135'
+	`dexdum136'*`exdum136'
+	`dexdum137'*`exdum137'
+	`dexdum138'*`exdum138'
+	`dexdum139'*`exdum139'
+	`dexdum140'*`exdum140'
+	`dexdum141'*`exdum141'
+	`dexdum142'*`exdum142'
+	`dexdum143'*`exdum143'
+	`dexdum144'*`exdum144'
+	`dexdum145'*`exdum145'
+	`dexdum146'*`exdum146'
+	`dexdum147'*`exdum147'
+	`dexdum148'*`exdum148'
+	`dexdum149'*`exdum149'
+	`dexdum150'*`exdum150'
+	`dexdum151'*`exdum151'
+	`dexdum152'*`exdum152'
+	`dexdum153'*`exdum153'
+	`dexdum154'*`exdum154'
+	`dexdum155'*`exdum155'
+	`dexdum156'*`exdum156'
+	`dexdum157'*`exdum157'
+	`dexdum158'*`exdum158' `if';
replace `ln_trade' = `constant' + `omega' + `xb_invmillman'*`invmillman' + `xb_ln_distance'*`ln_distance' + `xb_border'*`border'
 + `xb_island2'*`island2' + `xb_land2'*`land2' + `xb_legalsystem_same'*`legalsystem_same' + `xb_common_lang'*`common_lang' +  `xb_colonial'*`colonial'
 +`xb_cu'*`cu' + `xb_fta'*`fta' + `exdums'

+	`dimdum1'*`imdum1'
+	`dimdum2'*`imdum2'
+	`dimdum3'*`imdum3'
+	`dimdum4'*`imdum4'
+	`dimdum5'*`imdum5'
+	`dimdum6'*`imdum6'
+	`dimdum7'*`imdum7'
+	`dimdum8'*`imdum8'
+	`dimdum9'*`imdum9'
+	`dimdum10'*`imdum10'
+	`dimdum11'*`imdum11'
+	`dimdum12'*`imdum12'
+	`dimdum13'*`imdum13'
+	`dimdum14'*`imdum14'
+	`dimdum15'*`imdum15'
+	`dimdum16'*`imdum16'
+	`dimdum17'*`imdum17'
+	`dimdum18'*`imdum18'
+	`dimdum19'*`imdum19'
+	`dimdum20'*`imdum20'
+	`dimdum21'*`imdum21'
+	`dimdum22'*`imdum22'
+	`dimdum23'*`imdum23'
+	`dimdum24'*`imdum24'
+	`dimdum25'*`imdum25'
+	`dimdum26'*`imdum26'
+	`dimdum27'*`imdum27'
+	`dimdum28'*`imdum28'
+	`dimdum29'*`imdum29'
+	`dimdum30'*`imdum30'
+	`dimdum31'*`imdum31'
+	`dimdum32'*`imdum32'
+	`dimdum33'*`imdum33'
+	`dimdum34'*`imdum34'
+	`dimdum35'*`imdum35'
+	`dimdum36'*`imdum36'
+	`dimdum37'*`imdum37'
+	`dimdum38'*`imdum38'
+	`dimdum39'*`imdum39'
+	`dimdum40'*`imdum40'
+	`dimdum41'*`imdum41'
+	`dimdum42'*`imdum42'
+	`dimdum43'*`imdum43'
+	`dimdum44'*`imdum44'
+	`dimdum45'*`imdum45'
+	`dimdum46'*`imdum46'
+	`dimdum47'*`imdum47'
+	`dimdum48'*`imdum48'
+	`dimdum49'*`imdum49'
+	`dimdum50'*`imdum50'
+	`dimdum51'*`imdum51'
+	`dimdum52'*`imdum52'
+	`dimdum53'*`imdum53'
+	`dimdum54'*`imdum54'
+	`dimdum55'*`imdum55'
+	`dimdum56'*`imdum56'
+	`dimdum57'*`imdum57'
+	`dimdum58'*`imdum58'
+	`dimdum59'*`imdum59'
+	`dimdum60'*`imdum60'
+	`dimdum61'*`imdum61'
+	`dimdum62'*`imdum62'
+	`dimdum63'*`imdum63'
+	`dimdum64'*`imdum64'
+	`dimdum65'*`imdum65'
+	`dimdum66'*`imdum66'
+	`dimdum67'*`imdum67'
+	`dimdum68'*`imdum68'
+	`dimdum69'*`imdum69'
+	`dimdum70'*`imdum70'
+	`dimdum71'*`imdum71'
+	`dimdum72'*`imdum72'
+	`dimdum73'*`imdum73'
+	`dimdum74'*`imdum74'
+	`dimdum75'*`imdum75'
+	`dimdum76'*`imdum76'
+	`dimdum77'*`imdum77'
+	`dimdum78'*`imdum78'
+	`dimdum79'*`imdum79'
+	`dimdum80'*`imdum80'
+	`dimdum81'*`imdum81'
+	`dimdum82'*`imdum82'
+	`dimdum83'*`imdum83'
+	`dimdum84'*`imdum84'
+	`dimdum85'*`imdum85'
+	`dimdum86'*`imdum86'
+	`dimdum87'*`imdum87'
+	`dimdum88'*`imdum88'
+	`dimdum89'*`imdum89'
+	`dimdum90'*`imdum90'
+	`dimdum91'*`imdum91'
+	`dimdum92'*`imdum92'
+	`dimdum93'*`imdum93'
+	`dimdum94'*`imdum94'
+	`dimdum95'*`imdum95'
+	`dimdum96'*`imdum96'
+	`dimdum97'*`imdum97'
+	`dimdum98'*`imdum98'
+	`dimdum99'*`imdum99'
+	`dimdum100'*`imdum100' 
+	`dimdum101'*`imdum101'
+	`dimdum102'*`imdum102'
+	`dimdum103'*`imdum103'
+	`dimdum104'*`imdum104'
+	`dimdum105'*`imdum105'
+	`dimdum106'*`imdum106'
+	`dimdum107'*`imdum107'
+	`dimdum108'*`imdum108'
+	`dimdum109'*`imdum109'
+	`dimdum110'*`imdum110'
+	`dimdum111'*`imdum111'
+	`dimdum112'*`imdum112'
+	`dimdum113'*`imdum113'
+	`dimdum114'*`imdum114'
+	`dimdum115'*`imdum115'
+	`dimdum116'*`imdum116'
+	`dimdum117'*`imdum117'
+	`dimdum118'*`imdum118'
+	`dimdum119'*`imdum119'
+	`dimdum120'*`imdum120'
+	`dimdum121'*`imdum121'
+	`dimdum122'*`imdum122'
+	`dimdum123'*`imdum123'
+	`dimdum124'*`imdum124'
+	`dimdum125'*`imdum125'
+	`dimdum126'*`imdum126'
+	`dimdum127'*`imdum127'
+	`dimdum128'*`imdum128'
+	`dimdum129'*`imdum129'
+	`dimdum130'*`imdum130'
+	`dimdum131'*`imdum131'
+	`dimdum132'*`imdum132'
+	`dimdum133'*`imdum133'
+	`dimdum134'*`imdum134'
+	`dimdum135'*`imdum135'
+	`dimdum136'*`imdum136'
+	`dimdum137'*`imdum137'
+	`dimdum138'*`imdum138'
+	`dimdum139'*`imdum139'
+	`dimdum140'*`imdum140'
+	`dimdum141'*`imdum141'
+	`dimdum142'*`imdum142'
+	`dimdum143'*`imdum143'
+	`dimdum144'*`imdum144'
+	`dimdum145'*`imdum145'
+	`dimdum146'*`imdum146'
+	`dimdum147'*`imdum147'
+	`dimdum148'*`imdum148'
+	`dimdum149'*`imdum149'
+	`dimdum150'*`imdum150'
+	`dimdum151'*`imdum151'
+	`dimdum152'*`imdum152'
+	`dimdum153'*`imdum153'
+	`dimdum154'*`imdum154'
+	`dimdum155'*`imdum155'
+	`dimdum156'*`imdum156'
+	`dimdum157'*`imdum157'
+	`dimdum158'*`imdum158'
`if' ;
end;

#delimit;
nl w @ ln_trade zhatbarstar invmillman ln_distance border island2 land2 legalsystem_same common_lang colonial cu fta
exdum1
exdum2
exdum3
exdum4
exdum5
exdum6
exdum7
exdum8
exdum9
exdum10
exdum11
exdum12
exdum13
exdum14
exdum15
exdum16
exdum17
exdum18
exdum19
exdum20
exdum21
exdum22
exdum23
exdum24
exdum25
exdum26
exdum27
exdum28
exdum29
exdum30
exdum31
exdum32
exdum33
exdum34
exdum35
exdum36
exdum37
exdum38
exdum39
exdum40
exdum41
exdum42
exdum43
exdum44
exdum45
exdum46
exdum47
exdum48
exdum49
exdum50
exdum51
exdum52
exdum53
exdum54
exdum55
exdum56
exdum57
exdum58
exdum59
exdum60
exdum61
exdum62
exdum63
exdum64
exdum65
exdum66
exdum67
exdum68
exdum69
exdum70
exdum71
exdum72
exdum73
exdum74
exdum75
exdum76
exdum77
exdum78
exdum79
exdum80
exdum81
exdum82
exdum83
exdum84
exdum85
exdum86
exdum87
exdum88
exdum89
exdum90
exdum91
exdum92
exdum93
exdum94
exdum95
exdum96
exdum97
exdum98
exdum99
exdum100
exdum101
exdum102
exdum103
exdum104
exdum105
exdum106
exdum107
exdum108
exdum109
exdum110
exdum111
exdum112
exdum113
exdum114
exdum115
exdum116
exdum117
exdum118
exdum119
exdum120
exdum121
exdum122
exdum123
exdum124
exdum125
exdum126
exdum127
exdum128
exdum129
exdum130
exdum131
exdum132
exdum133
exdum134
exdum135
exdum136
exdum137
exdum138
exdum139
exdum140
exdum141
exdum142
exdum143
exdum144
exdum145
exdum146
exdum147
exdum148
exdum149
exdum150
exdum151
exdum152
exdum153
exdum154
exdum155
exdum156
exdum157
exdum158

imdum1
imdum2
imdum3
imdum4
imdum5
imdum6
imdum7
imdum8
imdum9
imdum10
imdum11
imdum12
imdum13
imdum14
imdum15
imdum16
imdum17
imdum18
imdum19
imdum20
imdum21
imdum22
imdum23
imdum24
imdum25
imdum26
imdum27
imdum28
imdum29
imdum30
imdum31
imdum32
imdum33
imdum34
imdum35
imdum36
imdum37
imdum38
imdum39
imdum40
imdum41
imdum42
imdum43
imdum44
imdum45
imdum46
imdum47
imdum48
imdum49
imdum50
imdum51
imdum52
imdum53
imdum54
imdum55
imdum56
imdum57
imdum58
imdum59
imdum60
imdum61
imdum62
imdum63
imdum64
imdum65
imdum66
imdum67
imdum68
imdum69
imdum70
imdum71
imdum72
imdum73
imdum74
imdum75
imdum76
imdum77
imdum78
imdum79
imdum80
imdum81
imdum82
imdum83
imdum84
imdum85
imdum86
imdum87
imdum88
imdum89
imdum90
imdum91
imdum92
imdum93
imdum94
imdum95
imdum96
imdum97
imdum98
imdum99
imdum100 
imdum101
imdum102
imdum103
imdum104
imdum105
imdum106
imdum107
imdum108
imdum109
imdum110
imdum111
imdum112
imdum113
imdum114
imdum115
imdum116
imdum117
imdum118
imdum119
imdum120
imdum121
imdum122
imdum123
imdum124
imdum125
imdum126
imdum127
imdum128
imdum129
imdum130
imdum131
imdum132
imdum133
imdum134
imdum135
imdum136
imdum137
imdum138
imdum139
imdum140
imdum141
imdum142
imdum143
imdum144
imdum145
imdum146
imdum147
imdum148
imdum149
imdum150
imdum151
imdum152
imdum153
imdum154
imdum155
imdum156
imdum157
imdum158
,
parameters(constant delta xb_invmillman xb_ln_distance xb_border xb_island2 xb_land2 xb_legalsystem_same xb_common_lang xb_colonial xb_cu xb_fta 
dexdum1
dexdum2
dexdum3
dexdum4
dexdum5
dexdum6
dexdum7
dexdum8
dexdum9
dexdum10
dexdum11
dexdum12
dexdum13
dexdum14
dexdum15
dexdum16
dexdum17
dexdum18
dexdum19
dexdum20
dexdum21
dexdum22
dexdum23
dexdum24
dexdum25
dexdum26
dexdum27
dexdum28
dexdum29
dexdum30
dexdum31
dexdum32
dexdum33
dexdum34
dexdum35
dexdum36
dexdum37
dexdum38
dexdum39
dexdum40
dexdum41
dexdum42
dexdum43
dexdum44
dexdum45
dexdum46
dexdum47
dexdum48
dexdum49
dexdum50
dexdum51
dexdum52
dexdum53
dexdum54
dexdum55
dexdum56
dexdum57
dexdum58
dexdum59
dexdum60
dexdum61
dexdum62
dexdum63
dexdum64
dexdum65
dexdum66
dexdum67
dexdum68
dexdum69
dexdum70
dexdum71
dexdum72
dexdum73
dexdum74
dexdum75
dexdum76
dexdum77
dexdum78
dexdum79
dexdum80
dexdum81
dexdum82
dexdum83
dexdum84
dexdum85
dexdum86
dexdum87
dexdum88
dexdum89
dexdum90
dexdum91
dexdum92
dexdum93
dexdum94
dexdum95
dexdum96
dexdum97
dexdum98
dexdum99
dexdum100
dexdum101
dexdum102
dexdum103
dexdum104
dexdum105
dexdum106
dexdum107
dexdum108
dexdum109
dexdum110
dexdum111
dexdum112
dexdum113
dexdum114
dexdum115
dexdum116
dexdum117
dexdum118
dexdum119
dexdum120
dexdum121
dexdum122
dexdum123
dexdum124
dexdum125
dexdum126
dexdum127
dexdum128
dexdum129
dexdum130
dexdum131
dexdum132
dexdum133
dexdum134
dexdum135
dexdum136
dexdum137
dexdum138
dexdum139
dexdum140
dexdum141
dexdum142
dexdum143
dexdum144
dexdum145
dexdum146
dexdum147
dexdum148
dexdum149
dexdum150
dexdum151
dexdum152
dexdum153
dexdum154
dexdum155
dexdum156
dexdum157
dexdum158

dimdum1
dimdum2
dimdum3
dimdum4
dimdum5
dimdum6
dimdum7
dimdum8
dimdum9
dimdum10
dimdum11
dimdum12
dimdum13
dimdum14
dimdum15
dimdum16
dimdum17
dimdum18
dimdum19
dimdum20
dimdum21
dimdum22
dimdum23
dimdum24
dimdum25
dimdum26
dimdum27
dimdum28
dimdum29
dimdum30
dimdum31
dimdum32
dimdum33
dimdum34
dimdum35
dimdum36
dimdum37
dimdum38
dimdum39
dimdum40
dimdum41
dimdum42
dimdum43
dimdum44
dimdum45
dimdum46
dimdum47
dimdum48
dimdum49
dimdum50
dimdum51
dimdum52
dimdum53
dimdum54
dimdum55
dimdum56
dimdum57
dimdum58
dimdum59
dimdum60
dimdum61
dimdum62
dimdum63
dimdum64
dimdum65
dimdum66
dimdum67
dimdum68
dimdum69
dimdum70
dimdum71
dimdum72
dimdum73
dimdum74
dimdum75
dimdum76
dimdum77
dimdum78
dimdum79
dimdum80
dimdum81
dimdum82
dimdum83
dimdum84
dimdum85
dimdum86
dimdum87
dimdum88
dimdum89
dimdum90
dimdum91
dimdum92
dimdum93
dimdum94
dimdum95
dimdum96
dimdum97
dimdum98
dimdum99
dimdum100 
dimdum101
dimdum102
dimdum103
dimdum104
dimdum105
dimdum106
dimdum107
dimdum108
dimdum109
dimdum110
dimdum111
dimdum112
dimdum113
dimdum114
dimdum115
dimdum116
dimdum117
dimdum118
dimdum119
dimdum120
dimdum121
dimdum122
dimdum123
dimdum124
dimdum125
dimdum126
dimdum127
dimdum128
dimdum129
dimdum130
dimdum131
dimdum132
dimdum133
dimdum134
dimdum135
dimdum136
dimdum137
dimdum138
dimdum139
dimdum140
dimdum141
dimdum142
dimdum143
dimdum144
dimdum145
dimdum146
dimdum147
dimdum148
dimdum149
dimdum150
dimdum151
dimdum152
dimdum153
dimdum154
dimdum155
dimdum156
dimdum157
dimdum158
) initial(delta 1) hascons(constant) /*vce(boot)*/;
est store nl;
