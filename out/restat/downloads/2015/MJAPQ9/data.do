clear
set more off
set matsize 11000
set maxvar 32000
cd "C:\_Research\John\Replication data" // change the directory before running the program

**** Read 1990/2000 Census data ****
clear
quietly infix              ///
  int     year      1-4    ///
  int     conspuma  5-7    ///
  float   perwt     8-13   ///
  int     age       14-16  ///
  byte    sex       17-17  ///
  byte    marst     18-18  ///
  byte    race      19-19  ///
  byte    speakeng  20-20  ///
  byte    educ      21-22  ///
  int     educd     23-25  ///
  byte    empstat   26-26  ///
  int     occ1990   27-29  ///
  int     ind1990   30-32  ///
  byte    wkswork1  33-34  ///
  long    incwage   35-40  ///
  using `"usa_00017.dat"'

replace perwt    = perwt    / 100

format perwt    %6.2f

label var year     `"Census year"'
label var conspuma `"Consistent Public Use Microdata Area"'
label var perwt    `"Person weight"'
label var age      `"Age"'
label var sex      `"Sex"'
label var marst    `"Marital status"'
label var race     `"Race [general version]"'
label var speakeng `"Speaks English"'
label var educ     `"Educational attainment [general version]"'
label var educd    `"Educational attainment [detailed version]"'
label var empstat  `"Employment status [general version]"'
label var occ1990  `"Occupation, 1990 basis"'
label var ind1990  `"Industry, 1990 basis"'
label var wkswork1 `"Weeks worked last year"'
label var incwage  `"Wage and salary income"'

label define year_lbl 1850 `"1850"'
label define year_lbl 1860 `"1860"', add
label define year_lbl 1870 `"1870"', add
label define year_lbl 1880 `"1880"', add
label define year_lbl 1900 `"1900"', add
label define year_lbl 1910 `"1910"', add
label define year_lbl 1920 `"1920"', add
label define year_lbl 1930 `"1930"', add
label define year_lbl 1940 `"1940"', add
label define year_lbl 1950 `"1950"', add
label define year_lbl 1960 `"1960"', add
label define year_lbl 1970 `"1970"', add
label define year_lbl 1980 `"1980"', add
label define year_lbl 1990 `"1990"', add
label define year_lbl 2000 `"2000"', add
label define year_lbl 2001 `"2001"', add
label define year_lbl 2002 `"2002"', add
label define year_lbl 2003 `"2003"', add
label define year_lbl 2004 `"2004"', add
label define year_lbl 2005 `"2005"', add
label define year_lbl 2006 `"2006"', add
label define year_lbl 2007 `"2007"', add
label define year_lbl 2008 `"2008"', add
label values year year_lbl

label define conspuma_lbl 001 `"001"'
label define conspuma_lbl 002 `"002"', add
label define conspuma_lbl 003 `"003"', add
label define conspuma_lbl 004 `"004"', add
label define conspuma_lbl 005 `"005"', add
label define conspuma_lbl 006 `"006"', add
label define conspuma_lbl 007 `"007"', add
label define conspuma_lbl 008 `"008"', add
label define conspuma_lbl 009 `"009"', add
label define conspuma_lbl 010 `"010"', add
label define conspuma_lbl 011 `"011"', add
label define conspuma_lbl 012 `"012"', add
label define conspuma_lbl 013 `"013"', add
label define conspuma_lbl 014 `"014"', add
label define conspuma_lbl 015 `"015"', add
label define conspuma_lbl 016 `"016"', add
label define conspuma_lbl 017 `"017"', add
label define conspuma_lbl 018 `"018"', add
label define conspuma_lbl 019 `"019"', add
label define conspuma_lbl 020 `"020"', add
label define conspuma_lbl 021 `"021"', add
label define conspuma_lbl 022 `"022"', add
label define conspuma_lbl 023 `"023"', add
label define conspuma_lbl 024 `"024"', add
label define conspuma_lbl 025 `"025"', add
label define conspuma_lbl 026 `"026"', add
label define conspuma_lbl 027 `"027"', add
label define conspuma_lbl 028 `"028"', add
label define conspuma_lbl 029 `"029"', add
label define conspuma_lbl 030 `"030"', add
label define conspuma_lbl 031 `"031"', add
label define conspuma_lbl 032 `"032"', add
label define conspuma_lbl 033 `"033"', add
label define conspuma_lbl 034 `"034"', add
label define conspuma_lbl 035 `"035"', add
label define conspuma_lbl 036 `"036"', add
label define conspuma_lbl 037 `"037"', add
label define conspuma_lbl 038 `"038"', add
label define conspuma_lbl 039 `"039"', add
label define conspuma_lbl 040 `"040"', add
label define conspuma_lbl 041 `"041"', add
label define conspuma_lbl 042 `"042"', add
label define conspuma_lbl 043 `"043"', add
label define conspuma_lbl 044 `"044"', add
label define conspuma_lbl 045 `"045"', add
label define conspuma_lbl 046 `"046"', add
label define conspuma_lbl 047 `"047"', add
label define conspuma_lbl 048 `"048"', add
label define conspuma_lbl 049 `"049"', add
label define conspuma_lbl 050 `"050"', add
label define conspuma_lbl 051 `"051"', add
label define conspuma_lbl 052 `"052"', add
label define conspuma_lbl 053 `"053"', add
label define conspuma_lbl 054 `"054"', add
label define conspuma_lbl 055 `"055"', add
label define conspuma_lbl 056 `"056"', add
label define conspuma_lbl 057 `"057"', add
label define conspuma_lbl 058 `"058"', add
label define conspuma_lbl 059 `"059"', add
label define conspuma_lbl 060 `"060"', add
label define conspuma_lbl 061 `"061"', add
label define conspuma_lbl 062 `"062"', add
label define conspuma_lbl 063 `"063"', add
label define conspuma_lbl 064 `"064"', add
label define conspuma_lbl 065 `"065"', add
label define conspuma_lbl 066 `"066"', add
label define conspuma_lbl 067 `"067"', add
label define conspuma_lbl 068 `"068"', add
label define conspuma_lbl 069 `"069"', add
label define conspuma_lbl 070 `"070"', add
label define conspuma_lbl 071 `"071"', add
label define conspuma_lbl 072 `"072"', add
label define conspuma_lbl 073 `"073"', add
label define conspuma_lbl 074 `"074"', add
label define conspuma_lbl 075 `"075"', add
label define conspuma_lbl 076 `"076"', add
label define conspuma_lbl 077 `"077"', add
label define conspuma_lbl 078 `"078"', add
label define conspuma_lbl 079 `"079"', add
label define conspuma_lbl 080 `"080"', add
label define conspuma_lbl 081 `"081"', add
label define conspuma_lbl 082 `"082"', add
label define conspuma_lbl 083 `"083"', add
label define conspuma_lbl 084 `"084"', add
label define conspuma_lbl 085 `"085"', add
label define conspuma_lbl 086 `"086"', add
label define conspuma_lbl 087 `"087"', add
label define conspuma_lbl 088 `"088"', add
label define conspuma_lbl 089 `"089"', add
label define conspuma_lbl 090 `"090"', add
label define conspuma_lbl 091 `"091"', add
label define conspuma_lbl 092 `"092"', add
label define conspuma_lbl 093 `"093"', add
label define conspuma_lbl 094 `"094"', add
label define conspuma_lbl 095 `"095"', add
label define conspuma_lbl 096 `"096"', add
label define conspuma_lbl 097 `"097"', add
label define conspuma_lbl 098 `"098"', add
label define conspuma_lbl 099 `"099"', add
label define conspuma_lbl 100 `"100"', add
label define conspuma_lbl 101 `"101"', add
label define conspuma_lbl 102 `"102"', add
label define conspuma_lbl 103 `"103"', add
label define conspuma_lbl 104 `"104"', add
label define conspuma_lbl 105 `"105"', add
label define conspuma_lbl 106 `"106"', add
label define conspuma_lbl 107 `"107"', add
label define conspuma_lbl 108 `"108"', add
label define conspuma_lbl 109 `"109"', add
label define conspuma_lbl 110 `"110"', add
label define conspuma_lbl 111 `"111"', add
label define conspuma_lbl 112 `"112"', add
label define conspuma_lbl 113 `"113"', add
label define conspuma_lbl 114 `"114"', add
label define conspuma_lbl 115 `"115"', add
label define conspuma_lbl 116 `"116"', add
label define conspuma_lbl 117 `"117"', add
label define conspuma_lbl 118 `"118"', add
label define conspuma_lbl 119 `"119"', add
label define conspuma_lbl 120 `"120"', add
label define conspuma_lbl 121 `"121"', add
label define conspuma_lbl 122 `"122"', add
label define conspuma_lbl 123 `"123"', add
label define conspuma_lbl 124 `"124"', add
label define conspuma_lbl 125 `"125"', add
label define conspuma_lbl 126 `"126"', add
label define conspuma_lbl 127 `"127"', add
label define conspuma_lbl 128 `"128"', add
label define conspuma_lbl 129 `"129"', add
label define conspuma_lbl 130 `"130"', add
label define conspuma_lbl 131 `"131"', add
label define conspuma_lbl 132 `"132"', add
label define conspuma_lbl 133 `"133"', add
label define conspuma_lbl 134 `"134"', add
label define conspuma_lbl 135 `"135"', add
label define conspuma_lbl 136 `"136"', add
label define conspuma_lbl 137 `"137"', add
label define conspuma_lbl 138 `"138"', add
label define conspuma_lbl 139 `"139"', add
label define conspuma_lbl 140 `"140"', add
label define conspuma_lbl 141 `"141"', add
label define conspuma_lbl 142 `"142"', add
label define conspuma_lbl 143 `"143"', add
label define conspuma_lbl 144 `"144"', add
label define conspuma_lbl 145 `"145"', add
label define conspuma_lbl 146 `"146"', add
label define conspuma_lbl 147 `"147"', add
label define conspuma_lbl 148 `"148"', add
label define conspuma_lbl 149 `"149"', add
label define conspuma_lbl 150 `"150"', add
label define conspuma_lbl 151 `"151"', add
label define conspuma_lbl 152 `"152"', add
label define conspuma_lbl 153 `"153"', add
label define conspuma_lbl 154 `"154"', add
label define conspuma_lbl 155 `"155"', add
label define conspuma_lbl 156 `"156"', add
label define conspuma_lbl 157 `"157"', add
label define conspuma_lbl 158 `"158"', add
label define conspuma_lbl 159 `"159"', add
label define conspuma_lbl 160 `"160"', add
label define conspuma_lbl 161 `"161"', add
label define conspuma_lbl 162 `"162"', add
label define conspuma_lbl 163 `"163"', add
label define conspuma_lbl 164 `"164"', add
label define conspuma_lbl 165 `"165"', add
label define conspuma_lbl 166 `"166"', add
label define conspuma_lbl 167 `"167"', add
label define conspuma_lbl 168 `"168"', add
label define conspuma_lbl 169 `"169"', add
label define conspuma_lbl 170 `"170"', add
label define conspuma_lbl 171 `"171"', add
label define conspuma_lbl 172 `"172"', add
label define conspuma_lbl 173 `"173"', add
label define conspuma_lbl 174 `"174"', add
label define conspuma_lbl 175 `"175"', add
label define conspuma_lbl 176 `"176"', add
label define conspuma_lbl 177 `"177"', add
label define conspuma_lbl 178 `"178"', add
label define conspuma_lbl 179 `"179"', add
label define conspuma_lbl 180 `"180"', add
label define conspuma_lbl 181 `"181"', add
label define conspuma_lbl 182 `"182"', add
label define conspuma_lbl 183 `"183"', add
label define conspuma_lbl 184 `"184"', add
label define conspuma_lbl 185 `"185"', add
label define conspuma_lbl 186 `"186"', add
label define conspuma_lbl 187 `"187"', add
label define conspuma_lbl 188 `"188"', add
label define conspuma_lbl 189 `"189"', add
label define conspuma_lbl 190 `"190"', add
label define conspuma_lbl 191 `"191"', add
label define conspuma_lbl 192 `"192"', add
label define conspuma_lbl 193 `"193"', add
label define conspuma_lbl 194 `"194"', add
label define conspuma_lbl 195 `"195"', add
label define conspuma_lbl 196 `"196"', add
label define conspuma_lbl 197 `"197"', add
label define conspuma_lbl 198 `"198"', add
label define conspuma_lbl 199 `"199"', add
label define conspuma_lbl 200 `"200"', add
label define conspuma_lbl 201 `"201"', add
label define conspuma_lbl 202 `"202"', add
label define conspuma_lbl 203 `"203"', add
label define conspuma_lbl 204 `"204"', add
label define conspuma_lbl 205 `"205"', add
label define conspuma_lbl 206 `"206"', add
label define conspuma_lbl 207 `"207"', add
label define conspuma_lbl 208 `"208"', add
label define conspuma_lbl 209 `"209"', add
label define conspuma_lbl 210 `"210"', add
label define conspuma_lbl 211 `"211"', add
label define conspuma_lbl 212 `"212"', add
label define conspuma_lbl 213 `"213"', add
label define conspuma_lbl 214 `"214"', add
label define conspuma_lbl 215 `"215"', add
label define conspuma_lbl 216 `"216"', add
label define conspuma_lbl 217 `"217"', add
label define conspuma_lbl 218 `"218"', add
label define conspuma_lbl 219 `"219"', add
label define conspuma_lbl 220 `"220"', add
label define conspuma_lbl 221 `"221"', add
label define conspuma_lbl 222 `"222"', add
label define conspuma_lbl 223 `"223"', add
label define conspuma_lbl 224 `"224"', add
label define conspuma_lbl 225 `"225"', add
label define conspuma_lbl 226 `"226"', add
label define conspuma_lbl 227 `"227"', add
label define conspuma_lbl 228 `"228"', add
label define conspuma_lbl 229 `"229"', add
label define conspuma_lbl 230 `"230"', add
label define conspuma_lbl 231 `"231"', add
label define conspuma_lbl 232 `"232"', add
label define conspuma_lbl 233 `"233"', add
label define conspuma_lbl 234 `"234"', add
label define conspuma_lbl 235 `"235"', add
label define conspuma_lbl 236 `"236"', add
label define conspuma_lbl 237 `"237"', add
label define conspuma_lbl 238 `"238"', add
label define conspuma_lbl 239 `"239"', add
label define conspuma_lbl 240 `"240"', add
label define conspuma_lbl 241 `"241"', add
label define conspuma_lbl 242 `"242"', add
label define conspuma_lbl 243 `"243"', add
label define conspuma_lbl 244 `"244"', add
label define conspuma_lbl 245 `"245"', add
label define conspuma_lbl 246 `"246"', add
label define conspuma_lbl 247 `"247"', add
label define conspuma_lbl 248 `"248"', add
label define conspuma_lbl 249 `"249"', add
label define conspuma_lbl 250 `"250"', add
label define conspuma_lbl 251 `"251"', add
label define conspuma_lbl 252 `"252"', add
label define conspuma_lbl 253 `"253"', add
label define conspuma_lbl 254 `"254"', add
label define conspuma_lbl 255 `"255"', add
label define conspuma_lbl 256 `"256"', add
label define conspuma_lbl 257 `"257"', add
label define conspuma_lbl 258 `"258"', add
label define conspuma_lbl 259 `"259"', add
label define conspuma_lbl 260 `"260"', add
label define conspuma_lbl 261 `"261"', add
label define conspuma_lbl 262 `"262"', add
label define conspuma_lbl 263 `"263"', add
label define conspuma_lbl 264 `"264"', add
label define conspuma_lbl 265 `"265"', add
label define conspuma_lbl 266 `"266"', add
label define conspuma_lbl 267 `"267"', add
label define conspuma_lbl 268 `"268"', add
label define conspuma_lbl 269 `"269"', add
label define conspuma_lbl 270 `"270"', add
label define conspuma_lbl 271 `"271"', add
label define conspuma_lbl 272 `"272"', add
label define conspuma_lbl 273 `"273"', add
label define conspuma_lbl 274 `"274"', add
label define conspuma_lbl 275 `"275"', add
label define conspuma_lbl 276 `"276"', add
label define conspuma_lbl 277 `"277"', add
label define conspuma_lbl 278 `"278"', add
label define conspuma_lbl 279 `"279"', add
label define conspuma_lbl 280 `"280"', add
label define conspuma_lbl 281 `"281"', add
label define conspuma_lbl 282 `"282"', add
label define conspuma_lbl 283 `"283"', add
label define conspuma_lbl 284 `"284"', add
label define conspuma_lbl 285 `"285"', add
label define conspuma_lbl 286 `"286"', add
label define conspuma_lbl 287 `"287"', add
label define conspuma_lbl 288 `"288"', add
label define conspuma_lbl 289 `"289"', add
label define conspuma_lbl 290 `"290"', add
label define conspuma_lbl 291 `"291"', add
label define conspuma_lbl 292 `"292"', add
label define conspuma_lbl 293 `"293"', add
label define conspuma_lbl 294 `"294"', add
label define conspuma_lbl 295 `"295"', add
label define conspuma_lbl 296 `"296"', add
label define conspuma_lbl 297 `"297"', add
label define conspuma_lbl 298 `"298"', add
label define conspuma_lbl 299 `"299"', add
label define conspuma_lbl 300 `"300"', add
label define conspuma_lbl 301 `"301"', add
label define conspuma_lbl 302 `"302"', add
label define conspuma_lbl 303 `"303"', add
label define conspuma_lbl 304 `"304"', add
label define conspuma_lbl 305 `"305"', add
label define conspuma_lbl 306 `"306"', add
label define conspuma_lbl 307 `"307"', add
label define conspuma_lbl 308 `"308"', add
label define conspuma_lbl 309 `"309"', add
label define conspuma_lbl 310 `"310"', add
label define conspuma_lbl 311 `"311"', add
label define conspuma_lbl 312 `"312"', add
label define conspuma_lbl 313 `"313"', add
label define conspuma_lbl 314 `"314"', add
label define conspuma_lbl 315 `"315"', add
label define conspuma_lbl 316 `"316"', add
label define conspuma_lbl 317 `"317"', add
label define conspuma_lbl 318 `"318"', add
label define conspuma_lbl 319 `"319"', add
label define conspuma_lbl 320 `"320"', add
label define conspuma_lbl 321 `"321"', add
label define conspuma_lbl 322 `"322"', add
label define conspuma_lbl 323 `"323"', add
label define conspuma_lbl 324 `"324"', add
label define conspuma_lbl 325 `"325"', add
label define conspuma_lbl 326 `"326"', add
label define conspuma_lbl 327 `"327"', add
label define conspuma_lbl 328 `"328"', add
label define conspuma_lbl 329 `"329"', add
label define conspuma_lbl 330 `"330"', add
label define conspuma_lbl 331 `"331"', add
label define conspuma_lbl 332 `"332"', add
label define conspuma_lbl 333 `"333"', add
label define conspuma_lbl 334 `"334"', add
label define conspuma_lbl 335 `"335"', add
label define conspuma_lbl 336 `"336"', add
label define conspuma_lbl 337 `"337"', add
label define conspuma_lbl 338 `"338"', add
label define conspuma_lbl 339 `"339"', add
label define conspuma_lbl 340 `"340"', add
label define conspuma_lbl 341 `"341"', add
label define conspuma_lbl 342 `"342"', add
label define conspuma_lbl 343 `"343"', add
label define conspuma_lbl 344 `"344"', add
label define conspuma_lbl 345 `"345"', add
label define conspuma_lbl 346 `"346"', add
label define conspuma_lbl 347 `"347"', add
label define conspuma_lbl 348 `"348"', add
label define conspuma_lbl 349 `"349"', add
label define conspuma_lbl 350 `"350"', add
label define conspuma_lbl 351 `"351"', add
label define conspuma_lbl 352 `"352"', add
label define conspuma_lbl 353 `"353"', add
label define conspuma_lbl 354 `"354"', add
label define conspuma_lbl 355 `"355"', add
label define conspuma_lbl 356 `"356"', add
label define conspuma_lbl 357 `"357"', add
label define conspuma_lbl 358 `"358"', add
label define conspuma_lbl 359 `"359"', add
label define conspuma_lbl 360 `"360"', add
label define conspuma_lbl 361 `"361"', add
label define conspuma_lbl 362 `"362"', add
label define conspuma_lbl 363 `"363"', add
label define conspuma_lbl 364 `"364"', add
label define conspuma_lbl 365 `"365"', add
label define conspuma_lbl 366 `"366"', add
label define conspuma_lbl 367 `"367"', add
label define conspuma_lbl 368 `"368"', add
label define conspuma_lbl 369 `"369"', add
label define conspuma_lbl 370 `"370"', add
label define conspuma_lbl 371 `"371"', add
label define conspuma_lbl 372 `"372"', add
label define conspuma_lbl 373 `"373"', add
label define conspuma_lbl 374 `"374"', add
label define conspuma_lbl 375 `"375"', add
label define conspuma_lbl 376 `"376"', add
label define conspuma_lbl 377 `"377"', add
label define conspuma_lbl 378 `"378"', add
label define conspuma_lbl 379 `"379"', add
label define conspuma_lbl 380 `"380"', add
label define conspuma_lbl 381 `"381"', add
label define conspuma_lbl 382 `"382"', add
label define conspuma_lbl 383 `"383"', add
label define conspuma_lbl 384 `"384"', add
label define conspuma_lbl 385 `"385"', add
label define conspuma_lbl 386 `"386"', add
label define conspuma_lbl 387 `"387"', add
label define conspuma_lbl 388 `"388"', add
label define conspuma_lbl 389 `"389"', add
label define conspuma_lbl 390 `"390"', add
label define conspuma_lbl 391 `"391"', add
label define conspuma_lbl 392 `"392"', add
label define conspuma_lbl 393 `"393"', add
label define conspuma_lbl 394 `"394"', add
label define conspuma_lbl 395 `"395"', add
label define conspuma_lbl 396 `"396"', add
label define conspuma_lbl 397 `"397"', add
label define conspuma_lbl 398 `"398"', add
label define conspuma_lbl 399 `"399"', add
label define conspuma_lbl 400 `"400"', add
label define conspuma_lbl 401 `"401"', add
label define conspuma_lbl 402 `"402"', add
label define conspuma_lbl 403 `"403"', add
label define conspuma_lbl 404 `"404"', add
label define conspuma_lbl 405 `"405"', add
label define conspuma_lbl 406 `"406"', add
label define conspuma_lbl 407 `"407"', add
label define conspuma_lbl 408 `"408"', add
label define conspuma_lbl 409 `"409"', add
label define conspuma_lbl 410 `"410"', add
label define conspuma_lbl 411 `"411"', add
label define conspuma_lbl 412 `"412"', add
label define conspuma_lbl 413 `"413"', add
label define conspuma_lbl 414 `"414"', add
label define conspuma_lbl 415 `"415"', add
label define conspuma_lbl 416 `"416"', add
label define conspuma_lbl 417 `"417"', add
label define conspuma_lbl 418 `"418"', add
label define conspuma_lbl 419 `"419"', add
label define conspuma_lbl 420 `"420"', add
label define conspuma_lbl 421 `"421"', add
label define conspuma_lbl 422 `"422"', add
label define conspuma_lbl 423 `"423"', add
label define conspuma_lbl 424 `"424"', add
label define conspuma_lbl 425 `"425"', add
label define conspuma_lbl 426 `"426"', add
label define conspuma_lbl 427 `"427"', add
label define conspuma_lbl 428 `"428"', add
label define conspuma_lbl 429 `"429"', add
label define conspuma_lbl 430 `"430"', add
label define conspuma_lbl 431 `"431"', add
label define conspuma_lbl 432 `"432"', add
label define conspuma_lbl 433 `"433"', add
label define conspuma_lbl 434 `"434"', add
label define conspuma_lbl 435 `"435"', add
label define conspuma_lbl 436 `"436"', add
label define conspuma_lbl 437 `"437"', add
label define conspuma_lbl 438 `"438"', add
label define conspuma_lbl 439 `"439"', add
label define conspuma_lbl 440 `"440"', add
label define conspuma_lbl 441 `"441"', add
label define conspuma_lbl 442 `"442"', add
label define conspuma_lbl 443 `"443"', add
label define conspuma_lbl 444 `"444"', add
label define conspuma_lbl 445 `"445"', add
label define conspuma_lbl 446 `"446"', add
label define conspuma_lbl 447 `"447"', add
label define conspuma_lbl 448 `"448"', add
label define conspuma_lbl 449 `"449"', add
label define conspuma_lbl 450 `"450"', add
label define conspuma_lbl 451 `"451"', add
label define conspuma_lbl 452 `"452"', add
label define conspuma_lbl 453 `"453"', add
label define conspuma_lbl 454 `"454"', add
label define conspuma_lbl 455 `"455"', add
label define conspuma_lbl 456 `"456"', add
label define conspuma_lbl 457 `"457"', add
label define conspuma_lbl 458 `"458"', add
label define conspuma_lbl 459 `"459"', add
label define conspuma_lbl 460 `"460"', add
label define conspuma_lbl 461 `"461"', add
label define conspuma_lbl 462 `"462"', add
label define conspuma_lbl 463 `"463"', add
label define conspuma_lbl 464 `"464"', add
label define conspuma_lbl 465 `"465"', add
label define conspuma_lbl 466 `"466"', add
label define conspuma_lbl 467 `"467"', add
label define conspuma_lbl 468 `"468"', add
label define conspuma_lbl 469 `"469"', add
label define conspuma_lbl 470 `"470"', add
label define conspuma_lbl 471 `"471"', add
label define conspuma_lbl 472 `"472"', add
label define conspuma_lbl 473 `"473"', add
label define conspuma_lbl 474 `"474"', add
label define conspuma_lbl 475 `"475"', add
label define conspuma_lbl 476 `"476"', add
label define conspuma_lbl 477 `"477"', add
label define conspuma_lbl 478 `"478"', add
label define conspuma_lbl 479 `"479"', add
label define conspuma_lbl 480 `"480"', add
label define conspuma_lbl 481 `"481"', add
label define conspuma_lbl 482 `"482"', add
label define conspuma_lbl 483 `"483"', add
label define conspuma_lbl 484 `"484"', add
label define conspuma_lbl 485 `"485"', add
label define conspuma_lbl 486 `"486"', add
label define conspuma_lbl 487 `"487"', add
label define conspuma_lbl 488 `"488"', add
label define conspuma_lbl 489 `"489"', add
label define conspuma_lbl 490 `"490"', add
label define conspuma_lbl 491 `"491"', add
label define conspuma_lbl 492 `"492"', add
label define conspuma_lbl 493 `"493"', add
label define conspuma_lbl 494 `"494"', add
label define conspuma_lbl 495 `"495"', add
label define conspuma_lbl 496 `"496"', add
label define conspuma_lbl 497 `"497"', add
label define conspuma_lbl 498 `"498"', add
label define conspuma_lbl 499 `"499"', add
label define conspuma_lbl 500 `"500"', add
label define conspuma_lbl 501 `"501"', add
label define conspuma_lbl 502 `"502"', add
label define conspuma_lbl 503 `"503"', add
label define conspuma_lbl 504 `"504"', add
label define conspuma_lbl 505 `"505"', add
label define conspuma_lbl 506 `"506"', add
label define conspuma_lbl 507 `"507"', add
label define conspuma_lbl 508 `"508"', add
label define conspuma_lbl 509 `"509"', add
label define conspuma_lbl 510 `"510"', add
label define conspuma_lbl 511 `"511"', add
label define conspuma_lbl 512 `"512"', add
label define conspuma_lbl 513 `"513"', add
label define conspuma_lbl 514 `"514"', add
label define conspuma_lbl 515 `"515"', add
label define conspuma_lbl 516 `"516"', add
label define conspuma_lbl 517 `"517"', add
label define conspuma_lbl 518 `"518"', add
label define conspuma_lbl 519 `"519"', add
label define conspuma_lbl 520 `"520"', add
label define conspuma_lbl 521 `"521"', add
label define conspuma_lbl 522 `"522"', add
label define conspuma_lbl 523 `"523"', add
label define conspuma_lbl 524 `"524"', add
label define conspuma_lbl 525 `"525"', add
label define conspuma_lbl 526 `"526"', add
label define conspuma_lbl 527 `"527"', add
label define conspuma_lbl 528 `"528"', add
label define conspuma_lbl 529 `"529"', add
label define conspuma_lbl 530 `"530"', add
label define conspuma_lbl 531 `"531"', add
label define conspuma_lbl 532 `"532"', add
label define conspuma_lbl 533 `"533"', add
label define conspuma_lbl 534 `"534"', add
label define conspuma_lbl 535 `"535"', add
label define conspuma_lbl 536 `"536"', add
label define conspuma_lbl 537 `"537"', add
label define conspuma_lbl 538 `"538"', add
label define conspuma_lbl 539 `"539"', add
label define conspuma_lbl 540 `"540"', add
label define conspuma_lbl 541 `"541"', add
label define conspuma_lbl 542 `"542"', add
label define conspuma_lbl 543 `"543"', add
label values conspuma conspuma_lbl

label define age_lbl 000 `"Less than 1 year old"'
label define age_lbl 001 `"1"', add
label define age_lbl 002 `"2"', add
label define age_lbl 003 `"3"', add
label define age_lbl 004 `"4"', add
label define age_lbl 005 `"5"', add
label define age_lbl 006 `"6"', add
label define age_lbl 007 `"7"', add
label define age_lbl 008 `"8"', add
label define age_lbl 009 `"9"', add
label define age_lbl 010 `"10"', add
label define age_lbl 011 `"11"', add
label define age_lbl 012 `"12"', add
label define age_lbl 013 `"13"', add
label define age_lbl 014 `"14"', add
label define age_lbl 015 `"15"', add
label define age_lbl 016 `"16"', add
label define age_lbl 017 `"17"', add
label define age_lbl 018 `"18"', add
label define age_lbl 019 `"19"', add
label define age_lbl 020 `"20"', add
label define age_lbl 021 `"21"', add
label define age_lbl 022 `"22"', add
label define age_lbl 023 `"23"', add
label define age_lbl 024 `"24"', add
label define age_lbl 025 `"25"', add
label define age_lbl 026 `"26"', add
label define age_lbl 027 `"27"', add
label define age_lbl 028 `"28"', add
label define age_lbl 029 `"29"', add
label define age_lbl 030 `"30"', add
label define age_lbl 031 `"31"', add
label define age_lbl 032 `"32"', add
label define age_lbl 033 `"33"', add
label define age_lbl 034 `"34"', add
label define age_lbl 035 `"35"', add
label define age_lbl 036 `"36"', add
label define age_lbl 037 `"37"', add
label define age_lbl 038 `"38"', add
label define age_lbl 039 `"39"', add
label define age_lbl 040 `"40"', add
label define age_lbl 041 `"41"', add
label define age_lbl 042 `"42"', add
label define age_lbl 043 `"43"', add
label define age_lbl 044 `"44"', add
label define age_lbl 045 `"45"', add
label define age_lbl 046 `"46"', add
label define age_lbl 047 `"47"', add
label define age_lbl 048 `"48"', add
label define age_lbl 049 `"49"', add
label define age_lbl 050 `"50"', add
label define age_lbl 051 `"51"', add
label define age_lbl 052 `"52"', add
label define age_lbl 053 `"53"', add
label define age_lbl 054 `"54"', add
label define age_lbl 055 `"55"', add
label define age_lbl 056 `"56"', add
label define age_lbl 057 `"57"', add
label define age_lbl 058 `"58"', add
label define age_lbl 059 `"59"', add
label define age_lbl 060 `"60"', add
label define age_lbl 061 `"61"', add
label define age_lbl 062 `"62"', add
label define age_lbl 063 `"63"', add
label define age_lbl 064 `"64"', add
label define age_lbl 065 `"65"', add
label define age_lbl 066 `"66"', add
label define age_lbl 067 `"67"', add
label define age_lbl 068 `"68"', add
label define age_lbl 069 `"69"', add
label define age_lbl 070 `"70"', add
label define age_lbl 071 `"71"', add
label define age_lbl 072 `"72"', add
label define age_lbl 073 `"73"', add
label define age_lbl 074 `"74"', add
label define age_lbl 075 `"75"', add
label define age_lbl 076 `"76"', add
label define age_lbl 077 `"77"', add
label define age_lbl 078 `"78"', add
label define age_lbl 079 `"79"', add
label define age_lbl 080 `"80"', add
label define age_lbl 081 `"81"', add
label define age_lbl 082 `"82"', add
label define age_lbl 083 `"83"', add
label define age_lbl 084 `"84"', add
label define age_lbl 085 `"85"', add
label define age_lbl 086 `"86"', add
label define age_lbl 087 `"87"', add
label define age_lbl 088 `"88"', add
label define age_lbl 089 `"89"', add
label define age_lbl 090 `"90 (90+ in 1980 and 1990)"', add
label define age_lbl 091 `"91"', add
label define age_lbl 092 `"92"', add
label define age_lbl 093 `"93"', add
label define age_lbl 094 `"94"', add
label define age_lbl 095 `"95"', add
label define age_lbl 096 `"96"', add
label define age_lbl 097 `"97"', add
label define age_lbl 098 `"98"', add
label define age_lbl 099 `"99"', add
label define age_lbl 100 `"100 (100+ in 1970)"', add
label define age_lbl 101 `"101"', add
label define age_lbl 102 `"102"', add
label define age_lbl 103 `"103"', add
label define age_lbl 104 `"104"', add
label define age_lbl 105 `"105"', add
label define age_lbl 106 `"106"', add
label define age_lbl 107 `"107"', add
label define age_lbl 108 `"108"', add
label define age_lbl 109 `"109"', add
label define age_lbl 110 `"110"', add
label define age_lbl 111 `"111"', add
label define age_lbl 112 `"112 (112+ in the 1980 internal data)"', add
label define age_lbl 113 `"113"', add
label define age_lbl 114 `"114"', add
label define age_lbl 115 `"115 (115+ in the 1990 internal data)"', add
label define age_lbl 116 `"116"', add
label define age_lbl 117 `"117"', add
label define age_lbl 118 `"118"', add
label define age_lbl 119 `"119"', add
label define age_lbl 120 `"120"', add
label define age_lbl 121 `"121"', add
label define age_lbl 122 `"122"', add
label define age_lbl 123 `"123"', add
label define age_lbl 124 `"124"', add
label define age_lbl 125 `"125"', add
label define age_lbl 126 `"126"', add
label define age_lbl 129 `"129"', add
label define age_lbl 130 `"130"', add
label define age_lbl 135 `"135"', add
label values age age_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label values sex sex_lbl

label define marst_lbl 1 `"Married, spouse present"'
label define marst_lbl 2 `"Married, spouse absent"', add
label define marst_lbl 3 `"Separated"', add
label define marst_lbl 4 `"Divorced"', add
label define marst_lbl 5 `"Widowed"', add
label define marst_lbl 6 `"Never married/single"', add
label values marst marst_lbl

label define race_lbl 1 `"White"'
label define race_lbl 2 `"Black/Negro"', add
label define race_lbl 3 `"American Indian or Alaska Native"', add
label define race_lbl 4 `"Chinese"', add
label define race_lbl 5 `"Japanese"', add
label define race_lbl 6 `"Other Asian or Pacific Islander"', add
label define race_lbl 7 `"Other race, nec"', add
label define race_lbl 8 `"Two major races"', add
label define race_lbl 9 `"Three or more major races"', add
label values race race_lbl

label define speakeng_lbl 0 `"N/A (Blank)"'
label define speakeng_lbl 1 `"Does not speak English"', add
label define speakeng_lbl 2 `"Yes, speaks English..."', add
label define speakeng_lbl 3 `"Yes, speaks only English"', add
label define speakeng_lbl 4 `"Yes, speaks very well"', add
label define speakeng_lbl 5 `"Yes, speaks well"', add
label define speakeng_lbl 6 `"Yes, but not well"', add
label define speakeng_lbl 7 `"Unknown"', add
label define speakeng_lbl 8 `"Illegible"', add
label values speakeng speakeng_lbl

label define educ_lbl 00 `"N/A or no schooling"'
label define educ_lbl 01 `"Nursery school to grade 4"', add
label define educ_lbl 02 `"Grade 5, 6, 7, or 8"', add
label define educ_lbl 03 `"Grade 9"', add
label define educ_lbl 04 `"Grade 10"', add
label define educ_lbl 05 `"Grade 11"', add
label define educ_lbl 06 `"Grade 12"', add
label define educ_lbl 07 `"1 year of college"', add
label define educ_lbl 08 `"2 years of college"', add
label define educ_lbl 09 `"3 years of college"', add
label define educ_lbl 10 `"4 years of college"', add
label define educ_lbl 11 `"5+ years of college"', add
label values educ educ_lbl

label define educd_lbl 000 `"N/A or no schooling"'
label define educd_lbl 001 `"N/A"', add
label define educd_lbl 002 `"No schooling completed"', add
label define educd_lbl 010 `"Nursery school to grade 4"', add
label define educd_lbl 011 `"Nursery school, preschool"', add
label define educd_lbl 012 `"Kindergarten"', add
label define educd_lbl 013 `"Grade 1, 2, 3, or 4"', add
label define educd_lbl 014 `"Grade 1"', add
label define educd_lbl 015 `"Grade 2"', add
label define educd_lbl 016 `"Grade 3"', add
label define educd_lbl 017 `"Grade 4"', add
label define educd_lbl 020 `"Grade 5, 6, 7, or 8"', add
label define educd_lbl 021 `"Grade 5 or 6"', add
label define educd_lbl 022 `"Grade 5"', add
label define educd_lbl 023 `"Grade 6"', add
label define educd_lbl 024 `"Grade 7 or 8"', add
label define educd_lbl 025 `"Grade 7"', add
label define educd_lbl 026 `"Grade 8"', add
label define educd_lbl 030 `"Grade 9"', add
label define educd_lbl 040 `"Grade 10"', add
label define educd_lbl 050 `"Grade 11"', add
label define educd_lbl 060 `"Grade 12"', add
label define educd_lbl 061 `"12th grade, no diploma"', add
label define educd_lbl 062 `"High school graduate or GED"', add
label define educd_lbl 063 `"Regular high school diploma"', add
label define educd_lbl 064 `"GED or alternative credential"', add
label define educd_lbl 065 `"Some college, but less than 1 year"', add
label define educd_lbl 070 `"1 year of college"', add
label define educd_lbl 071 `"1 or more years of college credit, no degree"', add
label define educd_lbl 080 `"2 years of college"', add
label define educd_lbl 081 `"Associate's degree, type not specified"', add
label define educd_lbl 082 `"Associate's degree, occupational program"', add
label define educd_lbl 083 `"Associate's degree, academic program"', add
label define educd_lbl 090 `"3 years of college"', add
label define educd_lbl 100 `"4 years of college"', add
label define educd_lbl 101 `"Bachelor's degree"', add
label define educd_lbl 110 `"5+ years of college"', add
label define educd_lbl 111 `"6 years of college (6+ in 1960-1970)"', add
label define educd_lbl 112 `"7 years of college"', add
label define educd_lbl 113 `"8+ years of college"', add
label define educd_lbl 114 `"Master's degree"', add
label define educd_lbl 115 `"Professional degree beyond a bachelor's degree"', add
label define educd_lbl 116 `"Doctoral degree"', add
label values educd educd_lbl

label define empstat_lbl 0 `"N/A"'
label define empstat_lbl 1 `"Employed"', add
label define empstat_lbl 2 `"Unemployed"', add
label define empstat_lbl 3 `"Not in labor force"', add
label values empstat empstat_lbl

label define occ1990_lbl 003 `"Legislators"'
label define occ1990_lbl 004 `"Chief executives and public administrators"', add
label define occ1990_lbl 007 `"Financial managers"', add
label define occ1990_lbl 008 `"Human resources and labor relations managers"', add
label define occ1990_lbl 013 `"Managers and specialists in marketing, advertising, and public relations"', add
label define occ1990_lbl 014 `"Managers in education and related fields"', add
label define occ1990_lbl 015 `"Managers of medicine and health occupations"', add
label define occ1990_lbl 016 `"Postmasters and mail superintendents"', add
label define occ1990_lbl 017 `"Managers of food-serving and lodging establishments"', add
label define occ1990_lbl 018 `"Managers of properties and real estate"', add
label define occ1990_lbl 019 `"Funeral directors"', add
label define occ1990_lbl 021 `"Managers of service organizations, n.e.c."', add
label define occ1990_lbl 022 `"Managers and administrators, n.e.c."', add
label define occ1990_lbl 023 `"Accountants and auditors"', add
label define occ1990_lbl 024 `"Insurance underwriters"', add
label define occ1990_lbl 025 `"Other financial specialists"', add
label define occ1990_lbl 026 `"Management analysts"', add
label define occ1990_lbl 027 `"Personnel, HR, training, and labor relations specialists"', add
label define occ1990_lbl 028 `"Purchasing agents and buyers, of farm products"', add
label define occ1990_lbl 029 `"Buyers, wholesale and retail trade"', add
label define occ1990_lbl 033 `"Purchasing managers, agents and buyers, n.e.c."', add
label define occ1990_lbl 034 `"Business and promotion agents"', add
label define occ1990_lbl 035 `"Construction inspectors"', add
label define occ1990_lbl 036 `"Inspectors and compliance officers, outside construction"', add
label define occ1990_lbl 037 `"Management support occupations"', add
label define occ1990_lbl 043 `"Architects"', add
label define occ1990_lbl 044 `"Aerospace engineer"', add
label define occ1990_lbl 045 `"Metallurgical and materials engineers, variously phrased"', add
label define occ1990_lbl 047 `"Petroleum, mining, and geological engineers"', add
label define occ1990_lbl 048 `"Chemical engineers"', add
label define occ1990_lbl 053 `"Civil engineers"', add
label define occ1990_lbl 055 `"Electrical engineer"', add
label define occ1990_lbl 056 `"Industrial engineers"', add
label define occ1990_lbl 057 `"Mechanical engineers"', add
label define occ1990_lbl 059 `"Not-elsewhere-classified engineers"', add
label define occ1990_lbl 064 `"Computer systems analysts and computer scientists"', add
label define occ1990_lbl 065 `"Operations and systems researchers and analysts"', add
label define occ1990_lbl 066 `"Actuaries"', add
label define occ1990_lbl 067 `"Statisticians"', add
label define occ1990_lbl 068 `"Mathematicians and mathematical scientists"', add
label define occ1990_lbl 069 `"Physicists and astronomers"', add
label define occ1990_lbl 073 `"Chemists"', add
label define occ1990_lbl 074 `"Atmospheric and space scientists"', add
label define occ1990_lbl 075 `"Geologists"', add
label define occ1990_lbl 076 `"Physical scientists, n.e.c."', add
label define occ1990_lbl 077 `"Agricultural and food scientists"', add
label define occ1990_lbl 078 `"Biological scientists"', add
label define occ1990_lbl 079 `"Foresters and conservation scientists"', add
label define occ1990_lbl 083 `"Medical scientists"', add
label define occ1990_lbl 084 `"Physicians"', add
label define occ1990_lbl 085 `"Dentists"', add
label define occ1990_lbl 086 `"Veterinarians"', add
label define occ1990_lbl 087 `"Optometrists"', add
label define occ1990_lbl 088 `"Podiatrists"', add
label define occ1990_lbl 089 `"Other health and therapy"', add
label define occ1990_lbl 095 `"Registered nurses"', add
label define occ1990_lbl 096 `"Pharmacists"', add
label define occ1990_lbl 097 `"Dietitians and nutritionists"', add
label define occ1990_lbl 098 `"Respiratory therapists"', add
label define occ1990_lbl 099 `"Occupational therapists"', add
label define occ1990_lbl 103 `"Physical therapists"', add
label define occ1990_lbl 104 `"Speech therapists"', add
label define occ1990_lbl 105 `"Therapists, n.e.c."', add
label define occ1990_lbl 106 `"Physicians' assistants"', add
label define occ1990_lbl 113 `"Earth, environmental, and marine science instructors"', add
label define occ1990_lbl 114 `"Biological science instructors"', add
label define occ1990_lbl 115 `"Chemistry instructors"', add
label define occ1990_lbl 116 `"Physics instructors"', add
label define occ1990_lbl 118 `"Psychology instructors"', add
label define occ1990_lbl 119 `"Economics instructors"', add
label define occ1990_lbl 123 `"History instructors"', add
label define occ1990_lbl 125 `"Sociology instructors"', add
label define occ1990_lbl 127 `"Engineering instructors"', add
label define occ1990_lbl 128 `"Math instructors"', add
label define occ1990_lbl 139 `"Education instructors"', add
label define occ1990_lbl 145 `"Law instructors"', add
label define occ1990_lbl 147 `"Theology instructors"', add
label define occ1990_lbl 149 `"Home economics instructors"', add
label define occ1990_lbl 150 `"Humanities profs/instructors, college, nec"', add
label define occ1990_lbl 154 `"Subject instructors (HS/college)"', add
label define occ1990_lbl 155 `"Kindergarten and earlier school teachers"', add
label define occ1990_lbl 156 `"Primary school teachers"', add
label define occ1990_lbl 157 `"Secondary school teachers"', add
label define occ1990_lbl 158 `"Special education teachers"', add
label define occ1990_lbl 159 `"Teachers , n.e.c."', add
label define occ1990_lbl 163 `"Vocational and educational counselors"', add
label define occ1990_lbl 164 `"Librarians"', add
label define occ1990_lbl 165 `"Archivists and curators"', add
label define occ1990_lbl 166 `"Economists, market researchers, and survey researchers"', add
label define occ1990_lbl 167 `"Psychologists"', add
label define occ1990_lbl 168 `"Sociologists"', add
label define occ1990_lbl 169 `"Social scientists, n.e.c."', add
label define occ1990_lbl 173 `"Urban and regional planners"', add
label define occ1990_lbl 174 `"Social workers"', add
label define occ1990_lbl 175 `"Recreation workers"', add
label define occ1990_lbl 176 `"Clergy and religious workers"', add
label define occ1990_lbl 178 `"Lawyers "', add
label define occ1990_lbl 179 `"Judges"', add
label define occ1990_lbl 183 `"Writers and authors"', add
label define occ1990_lbl 184 `"Technical writers"', add
label define occ1990_lbl 185 `"Designers"', add
label define occ1990_lbl 186 `"Musician or composer"', add
label define occ1990_lbl 187 `"Actors, directors, producers"', add
label define occ1990_lbl 188 `"Art makers: painters, sculptors, craft-artists, and print-makers"', add
label define occ1990_lbl 189 `"Photographers"', add
label define occ1990_lbl 193 `"Dancers"', add
label define occ1990_lbl 194 `"Art/entertainment performers and related"', add
label define occ1990_lbl 195 `"Editors and reporters"', add
label define occ1990_lbl 198 `"Announcers"', add
label define occ1990_lbl 199 `"Athletes, sports instructors, and officials"', add
label define occ1990_lbl 200 `"Professionals, n.e.c."', add
label define occ1990_lbl 203 `"Clinical laboratory technologies and technicians"', add
label define occ1990_lbl 204 `"Dental hygenists"', add
label define occ1990_lbl 205 `"Health record tech specialists"', add
label define occ1990_lbl 206 `"Radiologic tech specialists"', add
label define occ1990_lbl 207 `"Licensed practical nurses"', add
label define occ1990_lbl 208 `"Health technologists and technicians, n.e.c."', add
label define occ1990_lbl 213 `"Electrical and electronic (engineering) technicians"', add
label define occ1990_lbl 214 `"Engineering technicians, n.e.c."', add
label define occ1990_lbl 215 `"Mechanical engineering technicians"', add
label define occ1990_lbl 217 `"Drafters"', add
label define occ1990_lbl 218 `"Surveyors, cartographers, mapping scientists and technicians"', add
label define occ1990_lbl 223 `"Biological technicians"', add
label define occ1990_lbl 224 `"Chemical technicians"', add
label define occ1990_lbl 225 `"Other science technicians"', add
label define occ1990_lbl 226 `"Airplane pilots and navigators"', add
label define occ1990_lbl 227 `"Air traffic controllers"', add
label define occ1990_lbl 228 `"Broadcast equipment operators"', add
label define occ1990_lbl 229 `"Computer software developers"', add
label define occ1990_lbl 233 `"Programmers of numerically controlled machine tools"', add
label define occ1990_lbl 234 `"Legal assistants, paralegals, legal support, etc"', add
label define occ1990_lbl 235 `"Technicians, n.e.c."', add
label define occ1990_lbl 243 `"Supervisors and proprietors of sales jobs"', add
label define occ1990_lbl 253 `"Insurance sales occupations"', add
label define occ1990_lbl 254 `"Real estate sales occupations"', add
label define occ1990_lbl 255 `"Financial services sales occupations"', add
label define occ1990_lbl 256 `"Advertising and related sales jobs"', add
label define occ1990_lbl 258 `"Sales engineers"', add
label define occ1990_lbl 274 `"Salespersons, n.e.c."', add
label define occ1990_lbl 275 `"Retail sales clerks"', add
label define occ1990_lbl 276 `"Cashiers"', add
label define occ1990_lbl 277 `"Door-to-door sales, street sales, and news vendors"', add
label define occ1990_lbl 283 `"Sales demonstrators / promoters / models"', add
label define occ1990_lbl 303 `"Office supervisors"', add
label define occ1990_lbl 308 `"Computer and peripheral equipment operators"', add
label define occ1990_lbl 313 `"Secretaries"', add
label define occ1990_lbl 314 `"Stenographers"', add
label define occ1990_lbl 315 `"Typists"', add
label define occ1990_lbl 316 `"Interviewers, enumerators, and surveyors"', add
label define occ1990_lbl 317 `"Hotel clerks"', add
label define occ1990_lbl 318 `"Transportation ticket and reservation agents"', add
label define occ1990_lbl 319 `"Receptionists"', add
label define occ1990_lbl 323 `"Information clerks, nec"', add
label define occ1990_lbl 326 `"Correspondence and order clerks"', add
label define occ1990_lbl 328 `"Human resources clerks, except payroll and timekeeping"', add
label define occ1990_lbl 329 `"Library assistants"', add
label define occ1990_lbl 335 `"File clerks"', add
label define occ1990_lbl 336 `"Records clerks"', add
label define occ1990_lbl 337 `"Bookkeepers and accounting and auditing clerks"', add
label define occ1990_lbl 338 `"Payroll and timekeeping clerks"', add
label define occ1990_lbl 343 `"Cost and rate clerks (financial records processing)"', add
label define occ1990_lbl 344 `"Billing clerks and related financial records processing"', add
label define occ1990_lbl 345 `"Duplication machine operators / office machine operators"', add
label define occ1990_lbl 346 `"Mail and paper handlers"', add
label define occ1990_lbl 347 `"Office machine operators, n.e.c."', add
label define occ1990_lbl 348 `"Telephone operators"', add
label define occ1990_lbl 349 `"Other telecom operators"', add
label define occ1990_lbl 354 `"Postal clerks, excluding mail carriers"', add
label define occ1990_lbl 355 `"Mail carriers for postal service"', add
label define occ1990_lbl 356 `"Mail clerks, outside of post office"', add
label define occ1990_lbl 357 `"Messengers"', add
label define occ1990_lbl 359 `"Dispatchers"', add
label define occ1990_lbl 361 `"Inspectors, n.e.c."', add
label define occ1990_lbl 364 `"Shipping and receiving clerks"', add
label define occ1990_lbl 365 `"Stock and inventory clerks"', add
label define occ1990_lbl 366 `"Meter readers"', add
label define occ1990_lbl 368 `"Weighers, measurers, and checkers"', add
label define occ1990_lbl 373 `"Material recording, scheduling, production, planning, and expediting clerks"', add
label define occ1990_lbl 375 `"Insurance adjusters, examiners, and investigators"', add
label define occ1990_lbl 376 `"Customer service reps, investigators and adjusters, except insurance"', add
label define occ1990_lbl 377 `"Eligibility clerks for government programs; social welfare"', add
label define occ1990_lbl 378 `"Bill and account collectors"', add
label define occ1990_lbl 379 `"General office clerks"', add
label define occ1990_lbl 383 `"Bank tellers"', add
label define occ1990_lbl 384 `"Proofreaders"', add
label define occ1990_lbl 385 `"Data entry keyers"', add
label define occ1990_lbl 386 `"Statistical clerks"', add
label define occ1990_lbl 387 `"Teacher's aides"', add
label define occ1990_lbl 389 `"Administrative support jobs, n.e.c."', add
label define occ1990_lbl 405 `"Housekeepers, maids, butlers, stewards, and lodging quarters cleaners"', add
label define occ1990_lbl 407 `"Private household cleaners and servants"', add
label define occ1990_lbl 415 `"Supervisors of guards"', add
label define occ1990_lbl 417 `"Fire fighting, prevention, and inspection"', add
label define occ1990_lbl 418 `"Police, detectives, and private investigators"', add
label define occ1990_lbl 423 `"Other law enforcement: sheriffs, bailiffs, correctional institution officers"', add
label define occ1990_lbl 425 `"Crossing guards and bridge tenders"', add
label define occ1990_lbl 426 `"Guards, watchmen, doorkeepers"', add
label define occ1990_lbl 427 `"Protective services, n.e.c."', add
label define occ1990_lbl 434 `"Bartenders"', add
label define occ1990_lbl 435 `"Waiter/waitress"', add
label define occ1990_lbl 436 `"Cooks, variously defined"', add
label define occ1990_lbl 438 `"Food counter and fountain workers"', add
label define occ1990_lbl 439 `"Kitchen workers"', add
label define occ1990_lbl 443 `"Waiter's assistant"', add
label define occ1990_lbl 444 `"Misc food prep workers"', add
label define occ1990_lbl 445 `"Dental assistants"', add
label define occ1990_lbl 446 `"Health aides, except nursing"', add
label define occ1990_lbl 447 `"Nursing aides, orderlies, and attendants"', add
label define occ1990_lbl 448 `"Supervisors of cleaning and building service"', add
label define occ1990_lbl 453 `"Janitors"', add
label define occ1990_lbl 454 `"Elevator operators"', add
label define occ1990_lbl 455 `"Pest control occupations"', add
label define occ1990_lbl 456 `"Supervisors of personal service jobs, n.e.c."', add
label define occ1990_lbl 457 `"Barbers"', add
label define occ1990_lbl 458 `"Hairdressers and cosmetologists"', add
label define occ1990_lbl 459 `"Recreation facility attendants"', add
label define occ1990_lbl 461 `"Guides"', add
label define occ1990_lbl 462 `"Ushers"', add
label define occ1990_lbl 463 `"Public transportation attendants and inspectors"', add
label define occ1990_lbl 464 `"Baggage porters"', add
label define occ1990_lbl 465 `"Welfare service aides"', add
label define occ1990_lbl 468 `"Child care workers"', add
label define occ1990_lbl 469 `"Personal service occupations, nec"', add
label define occ1990_lbl 473 `"Farmers (owners and tenants)"', add
label define occ1990_lbl 474 `"Horticultural specialty farmers"', add
label define occ1990_lbl 475 `"Farm managers, except for horticultural farms"', add
label define occ1990_lbl 476 `"Managers of horticultural specialty farms"', add
label define occ1990_lbl 479 `"Farm workers"', add
label define occ1990_lbl 483 `"Marine life cultivation workers"', add
label define occ1990_lbl 484 `"Nursery farming workers"', add
label define occ1990_lbl 485 `"Supervisors of agricultural occupations"', add
label define occ1990_lbl 486 `"Gardeners and groundskeepers"', add
label define occ1990_lbl 487 `"Animal caretakers except on farms"', add
label define occ1990_lbl 488 `"Graders and sorters of agricultural products"', add
label define occ1990_lbl 489 `"Inspectors of agricultural products"', add
label define occ1990_lbl 496 `"Timber, logging, and forestry workers"', add
label define occ1990_lbl 498 `"Fishers, hunters, and kindred"', add
label define occ1990_lbl 503 `"Supervisors of mechanics and repairers"', add
label define occ1990_lbl 505 `"Automobile mechanics"', add
label define occ1990_lbl 507 `"Bus, truck, and stationary engine mechanics"', add
label define occ1990_lbl 508 `"Aircraft mechanics"', add
label define occ1990_lbl 509 `"Small engine repairers"', add
label define occ1990_lbl 514 `"Auto body repairers"', add
label define occ1990_lbl 516 `"Heavy equipment and farm equipment mechanics"', add
label define occ1990_lbl 518 `"Industrial machinery repairers"', add
label define occ1990_lbl 519 `"Machinery maintenance occupations"', add
label define occ1990_lbl 523 `"Repairers of industrial electrical equipment "', add
label define occ1990_lbl 525 `"Repairers of data processing equipment"', add
label define occ1990_lbl 526 `"Repairers of household appliances and power tools"', add
label define occ1990_lbl 527 `"Telecom and line installers and repairers"', add
label define occ1990_lbl 533 `"Repairers of electrical equipment, n.e.c."', add
label define occ1990_lbl 534 `"Heating, air conditioning, and refigeration mechanics"', add
label define occ1990_lbl 535 `"Precision makers, repairers, and smiths"', add
label define occ1990_lbl 536 `"Locksmiths and safe repairers"', add
label define occ1990_lbl 538 `"Office machine repairers and mechanics"', add
label define occ1990_lbl 539 `"Repairers of mechanical controls and valves"', add
label define occ1990_lbl 543 `"Elevator installers and repairers"', add
label define occ1990_lbl 544 `"Millwrights"', add
label define occ1990_lbl 549 `"Mechanics and repairers, n.e.c."', add
label define occ1990_lbl 558 `"Supervisors of construction work"', add
label define occ1990_lbl 563 `"Masons, tilers, and carpet installers"', add
label define occ1990_lbl 567 `"Carpenters"', add
label define occ1990_lbl 573 `"Drywall installers"', add
label define occ1990_lbl 575 `"Electricians"', add
label define occ1990_lbl 577 `"Electric power installers and repairers"', add
label define occ1990_lbl 579 `"Painters, construction and maintenance"', add
label define occ1990_lbl 583 `"Paperhangers"', add
label define occ1990_lbl 584 `"Plasterers"', add
label define occ1990_lbl 585 `"Plumbers, pipe fitters, and steamfitters"', add
label define occ1990_lbl 588 `"Concrete and cement workers"', add
label define occ1990_lbl 589 `"Glaziers"', add
label define occ1990_lbl 593 `"Insulation workers"', add
label define occ1990_lbl 594 `"Paving, surfacing, and tamping equipment operators"', add
label define occ1990_lbl 595 `"Roofers and slaters"', add
label define occ1990_lbl 596 `"Sheet metal duct installers"', add
label define occ1990_lbl 597 `"Structural metal workers"', add
label define occ1990_lbl 598 `"Drillers of earth"', add
label define occ1990_lbl 599 `"Construction trades, n.e.c."', add
label define occ1990_lbl 614 `"Drillers of oil wells"', add
label define occ1990_lbl 615 `"Explosives workers"', add
label define occ1990_lbl 616 `"Miners"', add
label define occ1990_lbl 617 `"Other mining occupations"', add
label define occ1990_lbl 628 `"Production supervisors or foremen"', add
label define occ1990_lbl 634 `"Tool and die makers and die setters"', add
label define occ1990_lbl 637 `"Machinists"', add
label define occ1990_lbl 643 `"Boilermakers"', add
label define occ1990_lbl 644 `"Precision grinders and filers"', add
label define occ1990_lbl 645 `"Patternmakers and model makers"', add
label define occ1990_lbl 646 `"Lay-out workers"', add
label define occ1990_lbl 649 `"Engravers"', add
label define occ1990_lbl 653 `"Tinsmiths, coppersmiths, and sheet metal workers"', add
label define occ1990_lbl 657 `"Cabinetmakers and bench carpenters"', add
label define occ1990_lbl 658 `"Furniture and wood finishers"', add
label define occ1990_lbl 659 `"Other precision woodworkers"', add
label define occ1990_lbl 666 `"Dressmakers and seamstresses"', add
label define occ1990_lbl 667 `"Tailors"', add
label define occ1990_lbl 668 `"Upholsterers"', add
label define occ1990_lbl 669 `"Shoe repairers"', add
label define occ1990_lbl 674 `"Other precision apparel and fabric workers"', add
label define occ1990_lbl 675 `"Hand molders and shapers, except jewelers "', add
label define occ1990_lbl 677 `"Optical goods workers"', add
label define occ1990_lbl 678 `"Dental laboratory and medical appliance technicians"', add
label define occ1990_lbl 679 `"Bookbinders"', add
label define occ1990_lbl 684 `"Other precision and craft workers"', add
label define occ1990_lbl 686 `"Butchers and meat cutters"', add
label define occ1990_lbl 687 `"Bakers"', add
label define occ1990_lbl 688 `"Batch food makers"', add
label define occ1990_lbl 693 `"Adjusters and calibrators"', add
label define occ1990_lbl 694 `"Water and sewage treatment plant operators"', add
label define occ1990_lbl 695 `"Power plant operators"', add
label define occ1990_lbl 696 `"Plant and system operators, stationary engineers "', add
label define occ1990_lbl 699 `"Other plant and system operators"', add
label define occ1990_lbl 703 `"Lathe, milling, and turning machine operatives"', add
label define occ1990_lbl 706 `"Punching and stamping press operatives"', add
label define occ1990_lbl 707 `"Rollers, roll hands, and finishers of metal"', add
label define occ1990_lbl 708 `"Drilling and boring machine operators"', add
label define occ1990_lbl 709 `"Grinding, abrading, buffing, and polishing workers"', add
label define occ1990_lbl 713 `"Forge and hammer operators"', add
label define occ1990_lbl 717 `"Fabricating machine operators, n.e.c."', add
label define occ1990_lbl 719 `"Molders, and casting machine operators"', add
label define occ1990_lbl 723 `"Metal platers"', add
label define occ1990_lbl 724 `"Heat treating equipment operators"', add
label define occ1990_lbl 726 `"Wood lathe, routing, and planing machine operators"', add
label define occ1990_lbl 727 `"Sawing machine operators and sawyers"', add
label define occ1990_lbl 728 `"Shaping and joining machine operator (woodworking)"', add
label define occ1990_lbl 729 `"Nail and tacking machine operators  (woodworking)"', add
label define occ1990_lbl 733 `"Other woodworking machine operators"', add
label define occ1990_lbl 734 `"Printing machine operators, n.e.c."', add
label define occ1990_lbl 735 `"Photoengravers and lithographers"', add
label define occ1990_lbl 736 `"Typesetters and compositors"', add
label define occ1990_lbl 738 `"Winding and twisting textile/apparel operatives"', add
label define occ1990_lbl 739 `"Knitters, loopers, and toppers textile operatives"', add
label define occ1990_lbl 743 `"Textile cutting machine operators"', add
label define occ1990_lbl 744 `"Textile sewing machine operators"', add
label define occ1990_lbl 745 `"Shoemaking machine operators"', add
label define occ1990_lbl 747 `"Pressing machine operators (clothing)"', add
label define occ1990_lbl 748 `"Laundry workers"', add
label define occ1990_lbl 749 `"Misc textile machine operators"', add
label define occ1990_lbl 753 `"Cementing and gluing maching operators"', add
label define occ1990_lbl 754 `"Packers, fillers, and wrappers"', add
label define occ1990_lbl 755 `"Extruding and forming machine operators"', add
label define occ1990_lbl 756 `"Mixing and blending machine operatives"', add
label define occ1990_lbl 757 `"Separating, filtering, and clarifying machine operators"', add
label define occ1990_lbl 759 `"Painting machine operators"', add
label define occ1990_lbl 763 `"Roasting and baking machine operators (food)"', add
label define occ1990_lbl 764 `"Washing, cleaning, and pickling machine operators"', add
label define occ1990_lbl 765 `"Paper folding machine operators"', add
label define occ1990_lbl 766 `"Furnace, kiln, and oven operators, apart from food"', add
label define occ1990_lbl 768 `"Crushing and grinding machine operators"', add
label define occ1990_lbl 769 `"Slicing and cutting machine operators"', add
label define occ1990_lbl 773 `"Motion picture projectionists"', add
label define occ1990_lbl 774 `"Photographic process workers"', add
label define occ1990_lbl 779 `"Machine operators, n.e.c."', add
label define occ1990_lbl 783 `"Welders and metal cutters"', add
label define occ1990_lbl 784 `"Solderers"', add
label define occ1990_lbl 785 `"Assemblers of electrical equipment"', add
label define occ1990_lbl 789 `"Hand painting, coating, and decorating occupations"', add
label define occ1990_lbl 796 `"Production checkers and inspectors"', add
label define occ1990_lbl 799 `"Graders and sorters in manufacturing"', add
label define occ1990_lbl 803 `"Supervisors of motor vehicle transportation"', add
label define occ1990_lbl 804 `"Truck, delivery, and tractor drivers"', add
label define occ1990_lbl 808 `"Bus drivers"', add
label define occ1990_lbl 809 `"Taxi cab drivers and chauffeurs"', add
label define occ1990_lbl 813 `"Parking lot attendants"', add
label define occ1990_lbl 823 `"Railroad conductors and yardmasters"', add
label define occ1990_lbl 824 `"Locomotive operators (engineers and firemen)"', add
label define occ1990_lbl 825 `"Railroad brake, coupler, and switch operators"', add
label define occ1990_lbl 829 `"Ship crews and marine engineers"', add
label define occ1990_lbl 834 `"Water transport infrastructure tenders and crossing guards"', add
label define occ1990_lbl 844 `"Operating engineers of construction equipment"', add
label define occ1990_lbl 848 `"Crane, derrick, winch, and hoist operators"', add
label define occ1990_lbl 853 `"Excavating and loading machine operators"', add
label define occ1990_lbl 859 `"Misc material moving occupations"', add
label define occ1990_lbl 865 `"Helpers, constructions"', add
label define occ1990_lbl 866 `"Helpers, surveyors"', add
label define occ1990_lbl 869 `"Construction laborers"', add
label define occ1990_lbl 874 `"Production helpers"', add
label define occ1990_lbl 875 `"Garbage and recyclable material collectors"', add
label define occ1990_lbl 876 `"Materials movers: stevedores and longshore workers"', add
label define occ1990_lbl 877 `"Stock handlers"', add
label define occ1990_lbl 878 `"Machine feeders and offbearers"', add
label define occ1990_lbl 883 `"Freight, stock, and materials handlers"', add
label define occ1990_lbl 885 `"Garage and service station related occupations"', add
label define occ1990_lbl 887 `"Vehicle washers and equipment cleaners"', add
label define occ1990_lbl 888 `"Packers and packagers by hand"', add
label define occ1990_lbl 889 `"Laborers outside construction"', add
label define occ1990_lbl 905 `"Military"', add
label define occ1990_lbl 991 `"Unemployed"', add
label define occ1990_lbl 999 `"Unknown"', add
label values occ1990 occ1990_lbl

label define ind1990_lbl 000 `"N/A (not applicable) "'
label define ind1990_lbl 010 `"Agricultural production, crops"', add
label define ind1990_lbl 011 `"Agricultural production, livestock"', add
label define ind1990_lbl 012 `"Veterinary services"', add
label define ind1990_lbl 020 `"Landscape and horticultural services"', add
label define ind1990_lbl 030 `"Agricultural services, n.e.c."', add
label define ind1990_lbl 031 `"Forestry"', add
label define ind1990_lbl 032 `"Fishing, hunting, and trapping "', add
label define ind1990_lbl 040 `"Metal mining"', add
label define ind1990_lbl 041 `"Coal mining"', add
label define ind1990_lbl 042 `"Oil and gas extraction"', add
label define ind1990_lbl 050 `"Nonmetallic mining and quarrying, except fuels "', add
label define ind1990_lbl 060 `"All construction "', add
label define ind1990_lbl 100 `"Meat products"', add
label define ind1990_lbl 101 `"Dairy products"', add
label define ind1990_lbl 102 `"Canned, frozen, and preserved fruits and vegetables"', add
label define ind1990_lbl 110 `"Grain mill products"', add
label define ind1990_lbl 111 `"Bakery products"', add
label define ind1990_lbl 112 `"Sugar and confectionery products"', add
label define ind1990_lbl 120 `"Beverage industries"', add
label define ind1990_lbl 121 `"Misc. food preparations and kindred products"', add
label define ind1990_lbl 122 `"Food industries, n.s."', add
label define ind1990_lbl 130 `"Tobacco manufactures"', add
label define ind1990_lbl 132 `"Knitting mills"', add
label define ind1990_lbl 140 `"Dyeing and finishing textiles, except wool and knit goods"', add
label define ind1990_lbl 141 `"Carpets and rugs"', add
label define ind1990_lbl 142 `"Yarn, thread, and fabric mills"', add
label define ind1990_lbl 150 `"Miscellaneous textile mill products"', add
label define ind1990_lbl 151 `"Apparel and accessories, except knit"', add
label define ind1990_lbl 152 `"Miscellaneous fabricated textile products"', add
label define ind1990_lbl 160 `"Pulp, paper, and paperboard mills"', add
label define ind1990_lbl 161 `"Miscellaneous paper and pulp products"', add
label define ind1990_lbl 162 `"Paperboard containers and boxes"', add
label define ind1990_lbl 171 `"Newspaper publishing and printing"', add
label define ind1990_lbl 172 `"Printing, publishing, and allied industries, except newspapers"', add
label define ind1990_lbl 180 `"Plastics, synthetics, and resins"', add
label define ind1990_lbl 181 `"Drugs"', add
label define ind1990_lbl 182 `"Soaps and cosmetics"', add
label define ind1990_lbl 190 `"Paints, varnishes, and related products"', add
label define ind1990_lbl 191 `"Agricultural chemicals"', add
label define ind1990_lbl 192 `"Industrial and miscellaneous chemicals"', add
label define ind1990_lbl 200 `"Petroleum refining"', add
label define ind1990_lbl 201 `"Miscellaneous petroleum and coal products"', add
label define ind1990_lbl 210 `"Tires and inner tubes"', add
label define ind1990_lbl 211 `"Other rubber products, and plastics footwear and belting"', add
label define ind1990_lbl 212 `"Miscellaneous plastics products"', add
label define ind1990_lbl 220 `"Leather tanning and finishing"', add
label define ind1990_lbl 221 `"Footwear, except rubber and plastic"', add
label define ind1990_lbl 222 `"Leather products, except footwear"', add
label define ind1990_lbl 230 `"Logging"', add
label define ind1990_lbl 231 `"Sawmills, planing mills, and millwork"', add
label define ind1990_lbl 232 `"Wood buildings and mobile homes"', add
label define ind1990_lbl 241 `"Miscellaneous wood products"', add
label define ind1990_lbl 242 `"Furniture and fixtures"', add
label define ind1990_lbl 250 `"Glass and glass products"', add
label define ind1990_lbl 251 `"Cement, concrete, gypsum, and plaster products"', add
label define ind1990_lbl 252 `"Structural clay products"', add
label define ind1990_lbl 261 `"Pottery and related products"', add
label define ind1990_lbl 262 `"Misc. nonmetallic mineral and stone products"', add
label define ind1990_lbl 270 `"Blast furnaces, steelworks, rolling and finishing mills"', add
label define ind1990_lbl 271 `"Iron and steel foundries"', add
label define ind1990_lbl 272 `"Primary aluminum industries"', add
label define ind1990_lbl 280 `"Other primary metal industries"', add
label define ind1990_lbl 281 `"Cutlery, handtools, and general hardware"', add
label define ind1990_lbl 282 `"Fabricated structural metal products"', add
label define ind1990_lbl 290 `"Screw machine products"', add
label define ind1990_lbl 291 `"Metal forgings and stampings"', add
label define ind1990_lbl 292 `"Ordnance"', add
label define ind1990_lbl 300 `"Miscellaneous fabricated metal products"', add
label define ind1990_lbl 301 `"Metal industries, n.s."', add
label define ind1990_lbl 310 `"Engines and turbines"', add
label define ind1990_lbl 311 `"Farm machinery and equipment"', add
label define ind1990_lbl 312 `"Construction and material handling machines"', add
label define ind1990_lbl 320 `"Metalworking machinery"', add
label define ind1990_lbl 321 `"Office and accounting machines"', add
label define ind1990_lbl 322 `"Computers and related equipment"', add
label define ind1990_lbl 331 `"Machinery, except electrical, n.e.c."', add
label define ind1990_lbl 332 `"Machinery, n.s."', add
label define ind1990_lbl 340 `"Household appliances"', add
label define ind1990_lbl 341 `"Radio, TV, and communication equipment"', add
label define ind1990_lbl 342 `"Electrical machinery, equipment, and supplies, n.e.c."', add
label define ind1990_lbl 350 `"Electrical machinery, equipment, and supplies, n.s."', add
label define ind1990_lbl 351 `"Motor vehicles and motor vehicle equipment"', add
label define ind1990_lbl 352 `"Aircraft and parts"', add
label define ind1990_lbl 360 `"Ship and boat building and repairing"', add
label define ind1990_lbl 361 `"Railroad locomotives and equipment"', add
label define ind1990_lbl 362 `"Guided missiles, space vehicles, and parts"', add
label define ind1990_lbl 370 `"Cycles and miscellaneous transportation equipment"', add
label define ind1990_lbl 371 `"Scientific and controlling instruments"', add
label define ind1990_lbl 372 `"Medical, dental, and optical instruments and supplies"', add
label define ind1990_lbl 380 `"Photographic equipment and supplies"', add
label define ind1990_lbl 381 `"Watches, clocks, and clockwork operated devices"', add
label define ind1990_lbl 390 `"Toys, amusement, and sporting goods"', add
label define ind1990_lbl 391 `"Miscellaneous manufacturing industries"', add
label define ind1990_lbl 392 `"Manufacturing industries, n.s. "', add
label define ind1990_lbl 400 `"Railroads"', add
label define ind1990_lbl 401 `"Bus service and urban transit"', add
label define ind1990_lbl 402 `"Taxicab service"', add
label define ind1990_lbl 410 `"Trucking service"', add
label define ind1990_lbl 411 `"Warehousing and storage"', add
label define ind1990_lbl 412 `"U.S. Postal Service"', add
label define ind1990_lbl 420 `"Water transportation"', add
label define ind1990_lbl 421 `"Air transportation"', add
label define ind1990_lbl 422 `"Pipe lines, except natural gas"', add
label define ind1990_lbl 432 `"Services incidental to transportation"', add
label define ind1990_lbl 440 `"Radio and television broadcasting and cable"', add
label define ind1990_lbl 441 `"Telephone communications"', add
label define ind1990_lbl 442 `"Telegraph and miscellaneous communications services"', add
label define ind1990_lbl 450 `"Electric light and power"', add
label define ind1990_lbl 451 `"Gas and steam supply systems"', add
label define ind1990_lbl 452 `"Electric and gas, and other combinations"', add
label define ind1990_lbl 470 `"Water supply and irrigation"', add
label define ind1990_lbl 471 `"Sanitary services"', add
label define ind1990_lbl 472 `"Utilities, n.s. "', add
label define ind1990_lbl 500 `"Motor vehicles and equipment"', add
label define ind1990_lbl 501 `"Furniture and home furnishings"', add
label define ind1990_lbl 502 `"Lumber and construction materials"', add
label define ind1990_lbl 510 `"Professional and commercial equipment and supplies"', add
label define ind1990_lbl 511 `"Metals and minerals, except petroleum"', add
label define ind1990_lbl 512 `"Electrical goods"', add
label define ind1990_lbl 521 `"Hardware, plumbing and heating supplies"', add
label define ind1990_lbl 530 `"Machinery, equipment, and supplies"', add
label define ind1990_lbl 531 `"Scrap and waste materials"', add
label define ind1990_lbl 532 `"Miscellaneous wholesale, durable goods"', add
label define ind1990_lbl 540 `"Paper and paper products"', add
label define ind1990_lbl 541 `"Drugs, chemicals, and allied products"', add
label define ind1990_lbl 542 `"Apparel, fabrics, and notions"', add
label define ind1990_lbl 550 `"Groceries and related products"', add
label define ind1990_lbl 551 `"Farm-product raw materials"', add
label define ind1990_lbl 552 `"Petroleum products"', add
label define ind1990_lbl 560 `"Alcoholic beverages"', add
label define ind1990_lbl 561 `"Farm supplies"', add
label define ind1990_lbl 562 `"Miscellaneous wholesale, nondurable goods"', add
label define ind1990_lbl 571 `"Wholesale trade, n.s. "', add
label define ind1990_lbl 580 `"Lumber and building material retailing"', add
label define ind1990_lbl 581 `"Hardware stores"', add
label define ind1990_lbl 582 `"Retail nurseries and garden stores"', add
label define ind1990_lbl 590 `"Mobile home dealers"', add
label define ind1990_lbl 591 `"Department stores"', add
label define ind1990_lbl 592 `"Variety stores"', add
label define ind1990_lbl 600 `"Miscellaneous general merchandise stores"', add
label define ind1990_lbl 601 `"Grocery stores"', add
label define ind1990_lbl 602 `"Dairy products stores"', add
label define ind1990_lbl 610 `"Retail bakeries"', add
label define ind1990_lbl 611 `"Food stores, n.e.c."', add
label define ind1990_lbl 612 `"Motor vehicle dealers"', add
label define ind1990_lbl 620 `"Auto and home supply stores"', add
label define ind1990_lbl 621 `"Gasoline service stations"', add
label define ind1990_lbl 622 `"Miscellaneous vehicle dealers"', add
label define ind1990_lbl 623 `"Apparel and accessory stores, except shoe"', add
label define ind1990_lbl 630 `"Shoe stores"', add
label define ind1990_lbl 631 `"Furniture and home furnishings stores"', add
label define ind1990_lbl 632 `"Household appliance stores"', add
label define ind1990_lbl 633 `"Radio, TV, and computer stores"', add
label define ind1990_lbl 640 `"Music stores"', add
label define ind1990_lbl 641 `"Eating and drinking places"', add
label define ind1990_lbl 642 `"Drug stores"', add
label define ind1990_lbl 650 `"Liquor stores"', add
label define ind1990_lbl 651 `"Sporting goods, bicycles, and hobby stores"', add
label define ind1990_lbl 652 `"Book and stationery stores"', add
label define ind1990_lbl 660 `"Jewelry stores"', add
label define ind1990_lbl 661 `"Gift, novelty, and souvenir shops"', add
label define ind1990_lbl 662 `"Sewing, needlework, and piece goods stores"', add
label define ind1990_lbl 663 `"Catalog and mail order houses"', add
label define ind1990_lbl 670 `"Vending machine operators"', add
label define ind1990_lbl 671 `"Direct selling establishments"', add
label define ind1990_lbl 672 `"Fuel dealers"', add
label define ind1990_lbl 681 `"Retail florists"', add
label define ind1990_lbl 682 `"Miscellaneous retail stores"', add
label define ind1990_lbl 691 `"Retail trade, n.s. "', add
label define ind1990_lbl 700 `"Banking"', add
label define ind1990_lbl 701 `"Savings institutions, including credit unions"', add
label define ind1990_lbl 702 `"Credit agencies, n.e.c."', add
label define ind1990_lbl 710 `"Security, commodity brokerage, and investment companies"', add
label define ind1990_lbl 711 `"Insurance"', add
label define ind1990_lbl 712 `"Real estate, including real estate-insurance offices "', add
label define ind1990_lbl 721 `"Advertising"', add
label define ind1990_lbl 722 `"Services to dwellings and other buildings"', add
label define ind1990_lbl 731 `"Personnel supply services"', add
label define ind1990_lbl 732 `"Computer and data processing services"', add
label define ind1990_lbl 740 `"Detective and protective services"', add
label define ind1990_lbl 741 `"Business services, n.e.c."', add
label define ind1990_lbl 742 `"Automotive rental and leasing, without drivers"', add
label define ind1990_lbl 750 `"Automobile parking and carwashes"', add
label define ind1990_lbl 751 `"Automotive repair and related services"', add
label define ind1990_lbl 752 `"Electrical repair shops"', add
label define ind1990_lbl 760 `"Miscellaneous repair services "', add
label define ind1990_lbl 761 `"Private households"', add
label define ind1990_lbl 762 `"Hotels and motels"', add
label define ind1990_lbl 770 `"Lodging places, except hotels and motels"', add
label define ind1990_lbl 771 `"Laundry, cleaning, and garment services"', add
label define ind1990_lbl 772 `"Beauty shops"', add
label define ind1990_lbl 780 `"Barber shops"', add
label define ind1990_lbl 781 `"Funeral service and crematories"', add
label define ind1990_lbl 782 `"Shoe repair shops"', add
label define ind1990_lbl 790 `"Dressmaking shops"', add
label define ind1990_lbl 791 `"Miscellaneous personal services "', add
label define ind1990_lbl 800 `"Theaters and motion pictures"', add
label define ind1990_lbl 801 `"Video tape rental"', add
label define ind1990_lbl 802 `"Bowling centers"', add
label define ind1990_lbl 810 `"Miscellaneous entertainment and recreation services "', add
label define ind1990_lbl 812 `"Offices and clinics of physicians"', add
label define ind1990_lbl 820 `"Offices and clinics of dentists"', add
label define ind1990_lbl 821 `"Offices and clinics of chiropractors"', add
label define ind1990_lbl 822 `"Offices and clinics of optometrists"', add
label define ind1990_lbl 830 `"Offices and clinics of health practitioners, n.e.c."', add
label define ind1990_lbl 831 `"Hospitals"', add
label define ind1990_lbl 832 `"Nursing and personal care facilities"', add
label define ind1990_lbl 840 `"Health services, n.e.c."', add
label define ind1990_lbl 841 `"Legal services"', add
label define ind1990_lbl 842 `"Elementary and secondary schools"', add
label define ind1990_lbl 850 `"Colleges and universities"', add
label define ind1990_lbl 851 `"Vocational schools"', add
label define ind1990_lbl 852 `"Libraries"', add
label define ind1990_lbl 860 `"Educational services, n.e.c."', add
label define ind1990_lbl 861 `"Job training and vocational rehabilitation services"', add
label define ind1990_lbl 862 `"Child day care services"', add
label define ind1990_lbl 863 `"Family child care homes"', add
label define ind1990_lbl 870 `"Residential care facilities, without nursing"', add
label define ind1990_lbl 871 `"Social services, n.e.c."', add
label define ind1990_lbl 872 `"Museums, art galleries, and zoos"', add
label define ind1990_lbl 873 `"Labor unions"', add
label define ind1990_lbl 880 `"Religious organizations"', add
label define ind1990_lbl 881 `"Membership organizations, n.e.c."', add
label define ind1990_lbl 882 `"Engineering, architectural, and surveying services"', add
label define ind1990_lbl 890 `"Accounting, auditing, and bookkeeping services"', add
label define ind1990_lbl 891 `"Research, development, and testing services"', add
label define ind1990_lbl 892 `"Management and public relations services"', add
label define ind1990_lbl 893 `"Miscellaneous professional and related services "', add
label define ind1990_lbl 900 `"Executive and legislative offices"', add
label define ind1990_lbl 901 `"General government, n.e.c."', add
label define ind1990_lbl 910 `"Justice, public order, and safety"', add
label define ind1990_lbl 921 `"Public finance, taxation, and monetary policy"', add
label define ind1990_lbl 922 `"Administration of human resources programs"', add
label define ind1990_lbl 930 `"Administration of environmental quality and housing programs"', add
label define ind1990_lbl 931 `"Administration of economic programs"', add
label define ind1990_lbl 932 `"National security and international affairs "', add
label define ind1990_lbl 940 `"Army"', add
label define ind1990_lbl 941 `"Air Force"', add
label define ind1990_lbl 942 `"Navy"', add
label define ind1990_lbl 950 `"Marines"', add
label define ind1990_lbl 951 `"Coast Guard"', add
label define ind1990_lbl 952 `"Armed Forces, branch not specified"', add
label define ind1990_lbl 960 `"Military Reserves or National Guard "', add
label define ind1990_lbl 992 `"Last worked 1984 or earlier"', add
label define ind1990_lbl 999 `"DID NOT RESPOND"', add
label values ind1990 ind1990_lbl

label define wkswork1_lbl 00 `"00"'
label values wkswork1 wkswork1_lbl

label define incwage_lbl 999999 `"N/A"'
label values incwage incwage_lbl

drop occ1990

gen age2 = age^2

replace sex = 0 if sex == 2
rename sex male

rename marst married
replace married = 1 if married == 2
replace married = 0 if married != 1

gen white = 1 if race == 1
replace white = 0 if race != 1

replace speakeng = speakeng - 1
replace speakeng = 1 if speakeng != 0

gen yr = 1 if year == 2000
replace yr = 0 if year == 1990

gen lhs = 1 if educd < 60
replace lhs = 0 if lhs == .
gen hs = 1 if educd == 61 | educd == 62
replace hs = 0 if hs == .
gen scol = 1 if educd >= 65 & educd < 100
replace scol = 0 if scol == .
gen col = 1 if educd > 100
replace col = 0 if col == .

replace ind1990 = 151 if ind1990 == 152
replace ind1990 = 300 if ind1990 == 301
replace ind1990 = 331 if ind1990 == 332
replace ind1990 = 342 if ind1990 == 350
replace ind1990 = 391 if ind1990 == 392

gen wage_w = incwage/wkswork1

drop race educ educd year wkswork1 wage_w

save main.dta, replace

run "vulnerability.do"

**** Create main dataset ****
use "main.dta", clear

drop if incwage == 0
gen logwage = log(incwage)
gen logwage_w = log(wage_w)
drop incwage wage_w
compress
drop if ind1990 == 0

joinby conspuma using "locvul_mexrca_fixed.dta", unmatched(master)
drop _m
joinby ind1990 using "trade_ind1990_fixed.dta", unmatched(master)
drop _m mex_t00
replace mex_t90 = 0 if mex_t90 == .
replace mex_dt = 0 if mex_dt == .
replace mex_t90_noag = 0 if mex_t90_noag == .
replace mex_dt_noag = 0 if mex_dt_noag == .
compress
joinby ind1990 using "mex_rca.dta", unmatched(master)
drop _m
replace mex_rca = 0 if mex_rca == .
replace mex_t90 = mex_rca * mex_t90
replace mex_t90_noag = mex_rca * mex_t90_noag
replace mex_dt = mex_rca * mex_dt
replace mex_dt_noag = mex_rca * mex_dt_noag

joinby ind1990 using "chnmshare.dta", unmatched(master)
drop _m
replace dchnmshare = 0 if dchnmshare == .
compress

gen border = 1 if conspuma == 7 | conspuma == 8 | conspuma == 11 | conspuma == 25 | conspuma == 43 | conspuma == 312 | conspuma == 457 | conspuma == 458 | conspuma == 462 | conspuma == 469 | conspuma == 470 | conspuma == 471
replace border = 0 if border ==.

label drop _all
egen ind = group(ind1990)
compress

save main_regress.dta, replace

**** Read 1980/1990 Census data ****
clear
quietly infix              ///
  int     year      1-4    ///
  byte    datanum   5-6    ///
  double  serial    7-14   ///
  float   hhwt      15-24  ///
  int     conspuma  25-27  ///
  byte    gq        28-28  ///
  int     pernum    29-32  ///
  float   perwt     33-42  ///
  int     age       43-45  ///
  byte    sex       46-46  ///
  byte    marst     47-47  ///
  byte    race      48-48  ///
  byte    speakeng  49-49  ///
  byte    educ      50-51  ///
  int     educd     52-54  ///
  byte    empstat   55-55  ///
  int     occ1990   56-58  ///
  int     ind1990   59-61  ///
  byte    wkswork1  62-63  ///
  long    incwage   64-69  ///
  using `"usa_00022.dat"'

replace hhwt     = hhwt     / 100
replace perwt    = perwt    / 100

format serial   %8.0f
format hhwt     %10.2f
format perwt    %10.2f

label var year     `"Census year"'
label var datanum  `"Data set number"'
label var serial   `"Household serial number"'
label var hhwt     `"Household weight"'
label var conspuma `"Consistent Public Use Microdata Area"'
label var gq       `"Group quarters status"'
label var pernum   `"Person number in sample unit"'
label var perwt    `"Person weight"'
label var age      `"Age"'
label var sex      `"Sex"'
label var marst    `"Marital status"'
label var race     `"Race [general version]"'
label var speakeng `"Speaks English"'
label var educ     `"Educational attainment [general version]"'
label var educd    `"Educational attainment [detailed version]"'
label var empstat  `"Employment status [general version]"'
label var occ1990  `"Occupation, 1990 basis"'
label var ind1990  `"Industry, 1990 basis"'
label var wkswork1 `"Weeks worked last year"'
label var incwage  `"Wage and salary income"'

label define year_lbl 1850 `"1850"'
label define year_lbl 1860 `"1860"', add
label define year_lbl 1870 `"1870"', add
label define year_lbl 1880 `"1880"', add
label define year_lbl 1900 `"1900"', add
label define year_lbl 1910 `"1910"', add
label define year_lbl 1920 `"1920"', add
label define year_lbl 1930 `"1930"', add
label define year_lbl 1940 `"1940"', add
label define year_lbl 1950 `"1950"', add
label define year_lbl 1960 `"1960"', add
label define year_lbl 1970 `"1970"', add
label define year_lbl 1980 `"1980"', add
label define year_lbl 1990 `"1990"', add
label define year_lbl 2000 `"2000"', add
label define year_lbl 2001 `"2001"', add
label define year_lbl 2002 `"2002"', add
label define year_lbl 2003 `"2003"', add
label define year_lbl 2004 `"2004"', add
label define year_lbl 2005 `"2005"', add
label define year_lbl 2006 `"2006"', add
label define year_lbl 2007 `"2007"', add
label define year_lbl 2008 `"2008"', add
label define year_lbl 2009 `"2009"', add
label define year_lbl 2010 `"2010"', add
label values year year_lbl

label define conspuma_lbl 001 `"001"'
label define conspuma_lbl 002 `"002"', add
label define conspuma_lbl 003 `"003"', add
label define conspuma_lbl 004 `"004"', add
label define conspuma_lbl 005 `"005"', add
label define conspuma_lbl 006 `"006"', add
label define conspuma_lbl 007 `"007"', add
label define conspuma_lbl 008 `"008"', add
label define conspuma_lbl 009 `"009"', add
label define conspuma_lbl 010 `"010"', add
label define conspuma_lbl 011 `"011"', add
label define conspuma_lbl 012 `"012"', add
label define conspuma_lbl 013 `"013"', add
label define conspuma_lbl 014 `"014"', add
label define conspuma_lbl 015 `"015"', add
label define conspuma_lbl 016 `"016"', add
label define conspuma_lbl 017 `"017"', add
label define conspuma_lbl 018 `"018"', add
label define conspuma_lbl 019 `"019"', add
label define conspuma_lbl 020 `"020"', add
label define conspuma_lbl 021 `"021"', add
label define conspuma_lbl 022 `"022"', add
label define conspuma_lbl 023 `"023"', add
label define conspuma_lbl 024 `"024"', add
label define conspuma_lbl 025 `"025"', add
label define conspuma_lbl 026 `"026"', add
label define conspuma_lbl 027 `"027"', add
label define conspuma_lbl 028 `"028"', add
label define conspuma_lbl 029 `"029"', add
label define conspuma_lbl 030 `"030"', add
label define conspuma_lbl 031 `"031"', add
label define conspuma_lbl 032 `"032"', add
label define conspuma_lbl 033 `"033"', add
label define conspuma_lbl 034 `"034"', add
label define conspuma_lbl 035 `"035"', add
label define conspuma_lbl 036 `"036"', add
label define conspuma_lbl 037 `"037"', add
label define conspuma_lbl 038 `"038"', add
label define conspuma_lbl 039 `"039"', add
label define conspuma_lbl 040 `"040"', add
label define conspuma_lbl 041 `"041"', add
label define conspuma_lbl 042 `"042"', add
label define conspuma_lbl 043 `"043"', add
label define conspuma_lbl 044 `"044"', add
label define conspuma_lbl 045 `"045"', add
label define conspuma_lbl 046 `"046"', add
label define conspuma_lbl 047 `"047"', add
label define conspuma_lbl 048 `"048"', add
label define conspuma_lbl 049 `"049"', add
label define conspuma_lbl 050 `"050"', add
label define conspuma_lbl 051 `"051"', add
label define conspuma_lbl 052 `"052"', add
label define conspuma_lbl 053 `"053"', add
label define conspuma_lbl 054 `"054"', add
label define conspuma_lbl 055 `"055"', add
label define conspuma_lbl 056 `"056"', add
label define conspuma_lbl 057 `"057"', add
label define conspuma_lbl 058 `"058"', add
label define conspuma_lbl 059 `"059"', add
label define conspuma_lbl 060 `"060"', add
label define conspuma_lbl 061 `"061"', add
label define conspuma_lbl 062 `"062"', add
label define conspuma_lbl 063 `"063"', add
label define conspuma_lbl 064 `"064"', add
label define conspuma_lbl 065 `"065"', add
label define conspuma_lbl 066 `"066"', add
label define conspuma_lbl 067 `"067"', add
label define conspuma_lbl 068 `"068"', add
label define conspuma_lbl 069 `"069"', add
label define conspuma_lbl 070 `"070"', add
label define conspuma_lbl 071 `"071"', add
label define conspuma_lbl 072 `"072"', add
label define conspuma_lbl 073 `"073"', add
label define conspuma_lbl 074 `"074"', add
label define conspuma_lbl 075 `"075"', add
label define conspuma_lbl 076 `"076"', add
label define conspuma_lbl 077 `"077"', add
label define conspuma_lbl 078 `"078"', add
label define conspuma_lbl 079 `"079"', add
label define conspuma_lbl 080 `"080"', add
label define conspuma_lbl 081 `"081"', add
label define conspuma_lbl 082 `"082"', add
label define conspuma_lbl 083 `"083"', add
label define conspuma_lbl 084 `"084"', add
label define conspuma_lbl 085 `"085"', add
label define conspuma_lbl 086 `"086"', add
label define conspuma_lbl 087 `"087"', add
label define conspuma_lbl 088 `"088"', add
label define conspuma_lbl 089 `"089"', add
label define conspuma_lbl 090 `"090"', add
label define conspuma_lbl 091 `"091"', add
label define conspuma_lbl 092 `"092"', add
label define conspuma_lbl 093 `"093"', add
label define conspuma_lbl 094 `"094"', add
label define conspuma_lbl 095 `"095"', add
label define conspuma_lbl 096 `"096"', add
label define conspuma_lbl 097 `"097"', add
label define conspuma_lbl 098 `"098"', add
label define conspuma_lbl 099 `"099"', add
label define conspuma_lbl 100 `"100"', add
label define conspuma_lbl 101 `"101"', add
label define conspuma_lbl 102 `"102"', add
label define conspuma_lbl 103 `"103"', add
label define conspuma_lbl 104 `"104"', add
label define conspuma_lbl 105 `"105"', add
label define conspuma_lbl 106 `"106"', add
label define conspuma_lbl 107 `"107"', add
label define conspuma_lbl 108 `"108"', add
label define conspuma_lbl 109 `"109"', add
label define conspuma_lbl 110 `"110"', add
label define conspuma_lbl 111 `"111"', add
label define conspuma_lbl 112 `"112"', add
label define conspuma_lbl 113 `"113"', add
label define conspuma_lbl 114 `"114"', add
label define conspuma_lbl 115 `"115"', add
label define conspuma_lbl 116 `"116"', add
label define conspuma_lbl 117 `"117"', add
label define conspuma_lbl 118 `"118"', add
label define conspuma_lbl 119 `"119"', add
label define conspuma_lbl 120 `"120"', add
label define conspuma_lbl 121 `"121"', add
label define conspuma_lbl 122 `"122"', add
label define conspuma_lbl 123 `"123"', add
label define conspuma_lbl 124 `"124"', add
label define conspuma_lbl 125 `"125"', add
label define conspuma_lbl 126 `"126"', add
label define conspuma_lbl 127 `"127"', add
label define conspuma_lbl 128 `"128"', add
label define conspuma_lbl 129 `"129"', add
label define conspuma_lbl 130 `"130"', add
label define conspuma_lbl 131 `"131"', add
label define conspuma_lbl 132 `"132"', add
label define conspuma_lbl 133 `"133"', add
label define conspuma_lbl 134 `"134"', add
label define conspuma_lbl 135 `"135"', add
label define conspuma_lbl 136 `"136"', add
label define conspuma_lbl 137 `"137"', add
label define conspuma_lbl 138 `"138"', add
label define conspuma_lbl 139 `"139"', add
label define conspuma_lbl 140 `"140"', add
label define conspuma_lbl 141 `"141"', add
label define conspuma_lbl 142 `"142"', add
label define conspuma_lbl 143 `"143"', add
label define conspuma_lbl 144 `"144"', add
label define conspuma_lbl 145 `"145"', add
label define conspuma_lbl 146 `"146"', add
label define conspuma_lbl 147 `"147"', add
label define conspuma_lbl 148 `"148"', add
label define conspuma_lbl 149 `"149"', add
label define conspuma_lbl 150 `"150"', add
label define conspuma_lbl 151 `"151"', add
label define conspuma_lbl 152 `"152"', add
label define conspuma_lbl 153 `"153"', add
label define conspuma_lbl 154 `"154"', add
label define conspuma_lbl 155 `"155"', add
label define conspuma_lbl 156 `"156"', add
label define conspuma_lbl 157 `"157"', add
label define conspuma_lbl 158 `"158"', add
label define conspuma_lbl 159 `"159"', add
label define conspuma_lbl 160 `"160"', add
label define conspuma_lbl 161 `"161"', add
label define conspuma_lbl 162 `"162"', add
label define conspuma_lbl 163 `"163"', add
label define conspuma_lbl 164 `"164"', add
label define conspuma_lbl 165 `"165"', add
label define conspuma_lbl 166 `"166"', add
label define conspuma_lbl 167 `"167"', add
label define conspuma_lbl 168 `"168"', add
label define conspuma_lbl 169 `"169"', add
label define conspuma_lbl 170 `"170"', add
label define conspuma_lbl 171 `"171"', add
label define conspuma_lbl 172 `"172"', add
label define conspuma_lbl 173 `"173"', add
label define conspuma_lbl 174 `"174"', add
label define conspuma_lbl 175 `"175"', add
label define conspuma_lbl 176 `"176"', add
label define conspuma_lbl 177 `"177"', add
label define conspuma_lbl 178 `"178"', add
label define conspuma_lbl 179 `"179"', add
label define conspuma_lbl 180 `"180"', add
label define conspuma_lbl 181 `"181"', add
label define conspuma_lbl 182 `"182"', add
label define conspuma_lbl 183 `"183"', add
label define conspuma_lbl 184 `"184"', add
label define conspuma_lbl 185 `"185"', add
label define conspuma_lbl 186 `"186"', add
label define conspuma_lbl 187 `"187"', add
label define conspuma_lbl 188 `"188"', add
label define conspuma_lbl 189 `"189"', add
label define conspuma_lbl 190 `"190"', add
label define conspuma_lbl 191 `"191"', add
label define conspuma_lbl 192 `"192"', add
label define conspuma_lbl 193 `"193"', add
label define conspuma_lbl 194 `"194"', add
label define conspuma_lbl 195 `"195"', add
label define conspuma_lbl 196 `"196"', add
label define conspuma_lbl 197 `"197"', add
label define conspuma_lbl 198 `"198"', add
label define conspuma_lbl 199 `"199"', add
label define conspuma_lbl 200 `"200"', add
label define conspuma_lbl 201 `"201"', add
label define conspuma_lbl 202 `"202"', add
label define conspuma_lbl 203 `"203"', add
label define conspuma_lbl 204 `"204"', add
label define conspuma_lbl 205 `"205"', add
label define conspuma_lbl 206 `"206"', add
label define conspuma_lbl 207 `"207"', add
label define conspuma_lbl 208 `"208"', add
label define conspuma_lbl 209 `"209"', add
label define conspuma_lbl 210 `"210"', add
label define conspuma_lbl 211 `"211"', add
label define conspuma_lbl 212 `"212"', add
label define conspuma_lbl 213 `"213"', add
label define conspuma_lbl 214 `"214"', add
label define conspuma_lbl 215 `"215"', add
label define conspuma_lbl 216 `"216"', add
label define conspuma_lbl 217 `"217"', add
label define conspuma_lbl 218 `"218"', add
label define conspuma_lbl 219 `"219"', add
label define conspuma_lbl 220 `"220"', add
label define conspuma_lbl 221 `"221"', add
label define conspuma_lbl 222 `"222"', add
label define conspuma_lbl 223 `"223"', add
label define conspuma_lbl 224 `"224"', add
label define conspuma_lbl 225 `"225"', add
label define conspuma_lbl 226 `"226"', add
label define conspuma_lbl 227 `"227"', add
label define conspuma_lbl 228 `"228"', add
label define conspuma_lbl 229 `"229"', add
label define conspuma_lbl 230 `"230"', add
label define conspuma_lbl 231 `"231"', add
label define conspuma_lbl 232 `"232"', add
label define conspuma_lbl 233 `"233"', add
label define conspuma_lbl 234 `"234"', add
label define conspuma_lbl 235 `"235"', add
label define conspuma_lbl 236 `"236"', add
label define conspuma_lbl 237 `"237"', add
label define conspuma_lbl 238 `"238"', add
label define conspuma_lbl 239 `"239"', add
label define conspuma_lbl 240 `"240"', add
label define conspuma_lbl 241 `"241"', add
label define conspuma_lbl 242 `"242"', add
label define conspuma_lbl 243 `"243"', add
label define conspuma_lbl 244 `"244"', add
label define conspuma_lbl 245 `"245"', add
label define conspuma_lbl 246 `"246"', add
label define conspuma_lbl 247 `"247"', add
label define conspuma_lbl 248 `"248"', add
label define conspuma_lbl 249 `"249"', add
label define conspuma_lbl 250 `"250"', add
label define conspuma_lbl 251 `"251"', add
label define conspuma_lbl 252 `"252"', add
label define conspuma_lbl 253 `"253"', add
label define conspuma_lbl 254 `"254"', add
label define conspuma_lbl 255 `"255"', add
label define conspuma_lbl 256 `"256"', add
label define conspuma_lbl 257 `"257"', add
label define conspuma_lbl 258 `"258"', add
label define conspuma_lbl 259 `"259"', add
label define conspuma_lbl 260 `"260"', add
label define conspuma_lbl 261 `"261"', add
label define conspuma_lbl 262 `"262"', add
label define conspuma_lbl 263 `"263"', add
label define conspuma_lbl 264 `"264"', add
label define conspuma_lbl 265 `"265"', add
label define conspuma_lbl 266 `"266"', add
label define conspuma_lbl 267 `"267"', add
label define conspuma_lbl 268 `"268"', add
label define conspuma_lbl 269 `"269"', add
label define conspuma_lbl 270 `"270"', add
label define conspuma_lbl 271 `"271"', add
label define conspuma_lbl 272 `"272"', add
label define conspuma_lbl 273 `"273"', add
label define conspuma_lbl 274 `"274"', add
label define conspuma_lbl 275 `"275"', add
label define conspuma_lbl 276 `"276"', add
label define conspuma_lbl 277 `"277"', add
label define conspuma_lbl 278 `"278"', add
label define conspuma_lbl 279 `"279"', add
label define conspuma_lbl 280 `"280"', add
label define conspuma_lbl 281 `"281"', add
label define conspuma_lbl 282 `"282"', add
label define conspuma_lbl 283 `"283"', add
label define conspuma_lbl 284 `"284"', add
label define conspuma_lbl 285 `"285"', add
label define conspuma_lbl 286 `"286"', add
label define conspuma_lbl 287 `"287"', add
label define conspuma_lbl 288 `"288"', add
label define conspuma_lbl 289 `"289"', add
label define conspuma_lbl 290 `"290"', add
label define conspuma_lbl 291 `"291"', add
label define conspuma_lbl 292 `"292"', add
label define conspuma_lbl 293 `"293"', add
label define conspuma_lbl 294 `"294"', add
label define conspuma_lbl 295 `"295"', add
label define conspuma_lbl 296 `"296"', add
label define conspuma_lbl 297 `"297"', add
label define conspuma_lbl 298 `"298"', add
label define conspuma_lbl 299 `"299"', add
label define conspuma_lbl 300 `"300"', add
label define conspuma_lbl 301 `"301"', add
label define conspuma_lbl 302 `"302"', add
label define conspuma_lbl 303 `"303"', add
label define conspuma_lbl 304 `"304"', add
label define conspuma_lbl 305 `"305"', add
label define conspuma_lbl 306 `"306"', add
label define conspuma_lbl 307 `"307"', add
label define conspuma_lbl 308 `"308"', add
label define conspuma_lbl 309 `"309"', add
label define conspuma_lbl 310 `"310"', add
label define conspuma_lbl 311 `"311"', add
label define conspuma_lbl 312 `"312"', add
label define conspuma_lbl 313 `"313"', add
label define conspuma_lbl 314 `"314"', add
label define conspuma_lbl 315 `"315"', add
label define conspuma_lbl 316 `"316"', add
label define conspuma_lbl 317 `"317"', add
label define conspuma_lbl 318 `"318"', add
label define conspuma_lbl 319 `"319"', add
label define conspuma_lbl 320 `"320"', add
label define conspuma_lbl 321 `"321"', add
label define conspuma_lbl 322 `"322"', add
label define conspuma_lbl 323 `"323"', add
label define conspuma_lbl 324 `"324"', add
label define conspuma_lbl 325 `"325"', add
label define conspuma_lbl 326 `"326"', add
label define conspuma_lbl 327 `"327"', add
label define conspuma_lbl 328 `"328"', add
label define conspuma_lbl 329 `"329"', add
label define conspuma_lbl 330 `"330"', add
label define conspuma_lbl 331 `"331"', add
label define conspuma_lbl 332 `"332"', add
label define conspuma_lbl 333 `"333"', add
label define conspuma_lbl 334 `"334"', add
label define conspuma_lbl 335 `"335"', add
label define conspuma_lbl 336 `"336"', add
label define conspuma_lbl 337 `"337"', add
label define conspuma_lbl 338 `"338"', add
label define conspuma_lbl 339 `"339"', add
label define conspuma_lbl 340 `"340"', add
label define conspuma_lbl 341 `"341"', add
label define conspuma_lbl 342 `"342"', add
label define conspuma_lbl 343 `"343"', add
label define conspuma_lbl 344 `"344"', add
label define conspuma_lbl 345 `"345"', add
label define conspuma_lbl 346 `"346"', add
label define conspuma_lbl 347 `"347"', add
label define conspuma_lbl 348 `"348"', add
label define conspuma_lbl 349 `"349"', add
label define conspuma_lbl 350 `"350"', add
label define conspuma_lbl 351 `"351"', add
label define conspuma_lbl 352 `"352"', add
label define conspuma_lbl 353 `"353"', add
label define conspuma_lbl 354 `"354"', add
label define conspuma_lbl 355 `"355"', add
label define conspuma_lbl 356 `"356"', add
label define conspuma_lbl 357 `"357"', add
label define conspuma_lbl 358 `"358"', add
label define conspuma_lbl 359 `"359"', add
label define conspuma_lbl 360 `"360"', add
label define conspuma_lbl 361 `"361"', add
label define conspuma_lbl 362 `"362"', add
label define conspuma_lbl 363 `"363"', add
label define conspuma_lbl 364 `"364"', add
label define conspuma_lbl 365 `"365"', add
label define conspuma_lbl 366 `"366"', add
label define conspuma_lbl 367 `"367"', add
label define conspuma_lbl 368 `"368"', add
label define conspuma_lbl 369 `"369"', add
label define conspuma_lbl 370 `"370"', add
label define conspuma_lbl 371 `"371"', add
label define conspuma_lbl 372 `"372"', add
label define conspuma_lbl 373 `"373"', add
label define conspuma_lbl 374 `"374"', add
label define conspuma_lbl 375 `"375"', add
label define conspuma_lbl 376 `"376"', add
label define conspuma_lbl 377 `"377"', add
label define conspuma_lbl 378 `"378"', add
label define conspuma_lbl 379 `"379"', add
label define conspuma_lbl 380 `"380"', add
label define conspuma_lbl 381 `"381"', add
label define conspuma_lbl 382 `"382"', add
label define conspuma_lbl 383 `"383"', add
label define conspuma_lbl 384 `"384"', add
label define conspuma_lbl 385 `"385"', add
label define conspuma_lbl 386 `"386"', add
label define conspuma_lbl 387 `"387"', add
label define conspuma_lbl 388 `"388"', add
label define conspuma_lbl 389 `"389"', add
label define conspuma_lbl 390 `"390"', add
label define conspuma_lbl 391 `"391"', add
label define conspuma_lbl 392 `"392"', add
label define conspuma_lbl 393 `"393"', add
label define conspuma_lbl 394 `"394"', add
label define conspuma_lbl 395 `"395"', add
label define conspuma_lbl 396 `"396"', add
label define conspuma_lbl 397 `"397"', add
label define conspuma_lbl 398 `"398"', add
label define conspuma_lbl 399 `"399"', add
label define conspuma_lbl 400 `"400"', add
label define conspuma_lbl 401 `"401"', add
label define conspuma_lbl 402 `"402"', add
label define conspuma_lbl 403 `"403"', add
label define conspuma_lbl 404 `"404"', add
label define conspuma_lbl 405 `"405"', add
label define conspuma_lbl 406 `"406"', add
label define conspuma_lbl 407 `"407"', add
label define conspuma_lbl 408 `"408"', add
label define conspuma_lbl 409 `"409"', add
label define conspuma_lbl 410 `"410"', add
label define conspuma_lbl 411 `"411"', add
label define conspuma_lbl 412 `"412"', add
label define conspuma_lbl 413 `"413"', add
label define conspuma_lbl 414 `"414"', add
label define conspuma_lbl 415 `"415"', add
label define conspuma_lbl 416 `"416"', add
label define conspuma_lbl 417 `"417"', add
label define conspuma_lbl 418 `"418"', add
label define conspuma_lbl 419 `"419"', add
label define conspuma_lbl 420 `"420"', add
label define conspuma_lbl 421 `"421"', add
label define conspuma_lbl 422 `"422"', add
label define conspuma_lbl 423 `"423"', add
label define conspuma_lbl 424 `"424"', add
label define conspuma_lbl 425 `"425"', add
label define conspuma_lbl 426 `"426"', add
label define conspuma_lbl 427 `"427"', add
label define conspuma_lbl 428 `"428"', add
label define conspuma_lbl 429 `"429"', add
label define conspuma_lbl 430 `"430"', add
label define conspuma_lbl 431 `"431"', add
label define conspuma_lbl 432 `"432"', add
label define conspuma_lbl 433 `"433"', add
label define conspuma_lbl 434 `"434"', add
label define conspuma_lbl 435 `"435"', add
label define conspuma_lbl 436 `"436"', add
label define conspuma_lbl 437 `"437"', add
label define conspuma_lbl 438 `"438"', add
label define conspuma_lbl 439 `"439"', add
label define conspuma_lbl 440 `"440"', add
label define conspuma_lbl 441 `"441"', add
label define conspuma_lbl 442 `"442"', add
label define conspuma_lbl 443 `"443"', add
label define conspuma_lbl 444 `"444"', add
label define conspuma_lbl 445 `"445"', add
label define conspuma_lbl 446 `"446"', add
label define conspuma_lbl 447 `"447"', add
label define conspuma_lbl 448 `"448"', add
label define conspuma_lbl 449 `"449"', add
label define conspuma_lbl 450 `"450"', add
label define conspuma_lbl 451 `"451"', add
label define conspuma_lbl 452 `"452"', add
label define conspuma_lbl 453 `"453"', add
label define conspuma_lbl 454 `"454"', add
label define conspuma_lbl 455 `"455"', add
label define conspuma_lbl 456 `"456"', add
label define conspuma_lbl 457 `"457"', add
label define conspuma_lbl 458 `"458"', add
label define conspuma_lbl 459 `"459"', add
label define conspuma_lbl 460 `"460"', add
label define conspuma_lbl 461 `"461"', add
label define conspuma_lbl 462 `"462"', add
label define conspuma_lbl 463 `"463"', add
label define conspuma_lbl 464 `"464"', add
label define conspuma_lbl 465 `"465"', add
label define conspuma_lbl 466 `"466"', add
label define conspuma_lbl 467 `"467"', add
label define conspuma_lbl 468 `"468"', add
label define conspuma_lbl 469 `"469"', add
label define conspuma_lbl 470 `"470"', add
label define conspuma_lbl 471 `"471"', add
label define conspuma_lbl 472 `"472"', add
label define conspuma_lbl 473 `"473"', add
label define conspuma_lbl 474 `"474"', add
label define conspuma_lbl 475 `"475"', add
label define conspuma_lbl 476 `"476"', add
label define conspuma_lbl 477 `"477"', add
label define conspuma_lbl 478 `"478"', add
label define conspuma_lbl 479 `"479"', add
label define conspuma_lbl 480 `"480"', add
label define conspuma_lbl 481 `"481"', add
label define conspuma_lbl 482 `"482"', add
label define conspuma_lbl 483 `"483"', add
label define conspuma_lbl 484 `"484"', add
label define conspuma_lbl 485 `"485"', add
label define conspuma_lbl 486 `"486"', add
label define conspuma_lbl 487 `"487"', add
label define conspuma_lbl 488 `"488"', add
label define conspuma_lbl 489 `"489"', add
label define conspuma_lbl 490 `"490"', add
label define conspuma_lbl 491 `"491"', add
label define conspuma_lbl 492 `"492"', add
label define conspuma_lbl 493 `"493"', add
label define conspuma_lbl 494 `"494"', add
label define conspuma_lbl 495 `"495"', add
label define conspuma_lbl 496 `"496"', add
label define conspuma_lbl 497 `"497"', add
label define conspuma_lbl 498 `"498"', add
label define conspuma_lbl 499 `"499"', add
label define conspuma_lbl 500 `"500"', add
label define conspuma_lbl 501 `"501"', add
label define conspuma_lbl 502 `"502"', add
label define conspuma_lbl 503 `"503"', add
label define conspuma_lbl 504 `"504"', add
label define conspuma_lbl 505 `"505"', add
label define conspuma_lbl 506 `"506"', add
label define conspuma_lbl 507 `"507"', add
label define conspuma_lbl 508 `"508"', add
label define conspuma_lbl 509 `"509"', add
label define conspuma_lbl 510 `"510"', add
label define conspuma_lbl 511 `"511"', add
label define conspuma_lbl 512 `"512"', add
label define conspuma_lbl 513 `"513"', add
label define conspuma_lbl 514 `"514"', add
label define conspuma_lbl 515 `"515"', add
label define conspuma_lbl 516 `"516"', add
label define conspuma_lbl 517 `"517"', add
label define conspuma_lbl 518 `"518"', add
label define conspuma_lbl 519 `"519"', add
label define conspuma_lbl 520 `"520"', add
label define conspuma_lbl 521 `"521"', add
label define conspuma_lbl 522 `"522"', add
label define conspuma_lbl 523 `"523"', add
label define conspuma_lbl 524 `"524"', add
label define conspuma_lbl 525 `"525"', add
label define conspuma_lbl 526 `"526"', add
label define conspuma_lbl 527 `"527"', add
label define conspuma_lbl 528 `"528"', add
label define conspuma_lbl 529 `"529"', add
label define conspuma_lbl 530 `"530"', add
label define conspuma_lbl 531 `"531"', add
label define conspuma_lbl 532 `"532"', add
label define conspuma_lbl 533 `"533"', add
label define conspuma_lbl 534 `"534"', add
label define conspuma_lbl 535 `"535"', add
label define conspuma_lbl 536 `"536"', add
label define conspuma_lbl 537 `"537"', add
label define conspuma_lbl 538 `"538"', add
label define conspuma_lbl 539 `"539"', add
label define conspuma_lbl 540 `"540"', add
label define conspuma_lbl 541 `"541"', add
label define conspuma_lbl 542 `"542"', add
label define conspuma_lbl 543 `"543"', add
label values conspuma conspuma_lbl

label define gq_lbl 0 `"Vacant unit"'
label define gq_lbl 1 `"Households under 1970 definition"', add
label define gq_lbl 2 `"Additional households under 1990 definition"', add
label define gq_lbl 3 `"Group quarters--Institutions"', add
label define gq_lbl 4 `"Other group quarters"', add
label define gq_lbl 5 `"Additional households under 2000 definition"', add
label define gq_lbl 6 `"Fragment"', add
label values gq gq_lbl

label define age_lbl 000 `"Less than 1 year old"'
label define age_lbl 001 `"1"', add
label define age_lbl 002 `"2"', add
label define age_lbl 003 `"3"', add
label define age_lbl 004 `"4"', add
label define age_lbl 005 `"5"', add
label define age_lbl 006 `"6"', add
label define age_lbl 007 `"7"', add
label define age_lbl 008 `"8"', add
label define age_lbl 009 `"9"', add
label define age_lbl 010 `"10"', add
label define age_lbl 011 `"11"', add
label define age_lbl 012 `"12"', add
label define age_lbl 013 `"13"', add
label define age_lbl 014 `"14"', add
label define age_lbl 015 `"15"', add
label define age_lbl 016 `"16"', add
label define age_lbl 017 `"17"', add
label define age_lbl 018 `"18"', add
label define age_lbl 019 `"19"', add
label define age_lbl 020 `"20"', add
label define age_lbl 021 `"21"', add
label define age_lbl 022 `"22"', add
label define age_lbl 023 `"23"', add
label define age_lbl 024 `"24"', add
label define age_lbl 025 `"25"', add
label define age_lbl 026 `"26"', add
label define age_lbl 027 `"27"', add
label define age_lbl 028 `"28"', add
label define age_lbl 029 `"29"', add
label define age_lbl 030 `"30"', add
label define age_lbl 031 `"31"', add
label define age_lbl 032 `"32"', add
label define age_lbl 033 `"33"', add
label define age_lbl 034 `"34"', add
label define age_lbl 035 `"35"', add
label define age_lbl 036 `"36"', add
label define age_lbl 037 `"37"', add
label define age_lbl 038 `"38"', add
label define age_lbl 039 `"39"', add
label define age_lbl 040 `"40"', add
label define age_lbl 041 `"41"', add
label define age_lbl 042 `"42"', add
label define age_lbl 043 `"43"', add
label define age_lbl 044 `"44"', add
label define age_lbl 045 `"45"', add
label define age_lbl 046 `"46"', add
label define age_lbl 047 `"47"', add
label define age_lbl 048 `"48"', add
label define age_lbl 049 `"49"', add
label define age_lbl 050 `"50"', add
label define age_lbl 051 `"51"', add
label define age_lbl 052 `"52"', add
label define age_lbl 053 `"53"', add
label define age_lbl 054 `"54"', add
label define age_lbl 055 `"55"', add
label define age_lbl 056 `"56"', add
label define age_lbl 057 `"57"', add
label define age_lbl 058 `"58"', add
label define age_lbl 059 `"59"', add
label define age_lbl 060 `"60"', add
label define age_lbl 061 `"61"', add
label define age_lbl 062 `"62"', add
label define age_lbl 063 `"63"', add
label define age_lbl 064 `"64"', add
label define age_lbl 065 `"65"', add
label define age_lbl 066 `"66"', add
label define age_lbl 067 `"67"', add
label define age_lbl 068 `"68"', add
label define age_lbl 069 `"69"', add
label define age_lbl 070 `"70"', add
label define age_lbl 071 `"71"', add
label define age_lbl 072 `"72"', add
label define age_lbl 073 `"73"', add
label define age_lbl 074 `"74"', add
label define age_lbl 075 `"75"', add
label define age_lbl 076 `"76"', add
label define age_lbl 077 `"77"', add
label define age_lbl 078 `"78"', add
label define age_lbl 079 `"79"', add
label define age_lbl 080 `"80"', add
label define age_lbl 081 `"81"', add
label define age_lbl 082 `"82"', add
label define age_lbl 083 `"83"', add
label define age_lbl 084 `"84"', add
label define age_lbl 085 `"85"', add
label define age_lbl 086 `"86"', add
label define age_lbl 087 `"87"', add
label define age_lbl 088 `"88"', add
label define age_lbl 089 `"89"', add
label define age_lbl 090 `"90 (90+ in 1980 and 1990)"', add
label define age_lbl 091 `"91"', add
label define age_lbl 092 `"92"', add
label define age_lbl 093 `"93"', add
label define age_lbl 094 `"94"', add
label define age_lbl 095 `"95"', add
label define age_lbl 096 `"96"', add
label define age_lbl 097 `"97"', add
label define age_lbl 098 `"98"', add
label define age_lbl 099 `"99"', add
label define age_lbl 100 `"100 (100+ in 1970)"', add
label define age_lbl 101 `"101"', add
label define age_lbl 102 `"102"', add
label define age_lbl 103 `"103"', add
label define age_lbl 104 `"104"', add
label define age_lbl 105 `"105"', add
label define age_lbl 106 `"106"', add
label define age_lbl 107 `"107"', add
label define age_lbl 108 `"108"', add
label define age_lbl 109 `"109"', add
label define age_lbl 110 `"110"', add
label define age_lbl 111 `"111"', add
label define age_lbl 112 `"112 (112+ in the 1980 internal data)"', add
label define age_lbl 113 `"113"', add
label define age_lbl 114 `"114"', add
label define age_lbl 115 `"115 (115+ in the 1990 internal data)"', add
label define age_lbl 116 `"116"', add
label define age_lbl 117 `"117"', add
label define age_lbl 118 `"118"', add
label define age_lbl 119 `"119"', add
label define age_lbl 120 `"120"', add
label define age_lbl 121 `"121"', add
label define age_lbl 122 `"122"', add
label define age_lbl 123 `"123"', add
label define age_lbl 124 `"124"', add
label define age_lbl 125 `"125"', add
label define age_lbl 126 `"126"', add
label define age_lbl 129 `"129"', add
label define age_lbl 130 `"130"', add
label define age_lbl 135 `"135"', add
label values age age_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label values sex sex_lbl

label define marst_lbl 1 `"Married, spouse present"'
label define marst_lbl 2 `"Married, spouse absent"', add
label define marst_lbl 3 `"Separated"', add
label define marst_lbl 4 `"Divorced"', add
label define marst_lbl 5 `"Widowed"', add
label define marst_lbl 6 `"Never married/single"', add
label values marst marst_lbl

label define race_lbl 1 `"White"'
label define race_lbl 2 `"Black/Negro"', add
label define race_lbl 3 `"American Indian or Alaska Native"', add
label define race_lbl 4 `"Chinese"', add
label define race_lbl 5 `"Japanese"', add
label define race_lbl 6 `"Other Asian or Pacific Islander"', add
label define race_lbl 7 `"Other race, nec"', add
label define race_lbl 8 `"Two major races"', add
label define race_lbl 9 `"Three or more major races"', add
label values race race_lbl

label define speakeng_lbl 0 `"N/A (Blank)"'
label define speakeng_lbl 1 `"Does not speak English"', add
label define speakeng_lbl 2 `"Yes, speaks English..."', add
label define speakeng_lbl 3 `"Yes, speaks only English"', add
label define speakeng_lbl 4 `"Yes, speaks very well"', add
label define speakeng_lbl 5 `"Yes, speaks well"', add
label define speakeng_lbl 6 `"Yes, but not well"', add
label define speakeng_lbl 7 `"Unknown"', add
label define speakeng_lbl 8 `"Illegible"', add
label values speakeng speakeng_lbl

label define educ_lbl 00 `"N/A or no schooling"'
label define educ_lbl 01 `"Nursery school to grade 4"', add
label define educ_lbl 02 `"Grade 5, 6, 7, or 8"', add
label define educ_lbl 03 `"Grade 9"', add
label define educ_lbl 04 `"Grade 10"', add
label define educ_lbl 05 `"Grade 11"', add
label define educ_lbl 06 `"Grade 12"', add
label define educ_lbl 07 `"1 year of college"', add
label define educ_lbl 08 `"2 years of college"', add
label define educ_lbl 09 `"3 years of college"', add
label define educ_lbl 10 `"4 years of college"', add
label define educ_lbl 11 `"5+ years of college"', add
label values educ educ_lbl

label define educd_lbl 000 `"N/A or no schooling"'
label define educd_lbl 001 `"N/A"', add
label define educd_lbl 002 `"No schooling completed"', add
label define educd_lbl 010 `"Nursery school to grade 4"', add
label define educd_lbl 011 `"Nursery school, preschool"', add
label define educd_lbl 012 `"Kindergarten"', add
label define educd_lbl 013 `"Grade 1, 2, 3, or 4"', add
label define educd_lbl 014 `"Grade 1"', add
label define educd_lbl 015 `"Grade 2"', add
label define educd_lbl 016 `"Grade 3"', add
label define educd_lbl 017 `"Grade 4"', add
label define educd_lbl 020 `"Grade 5, 6, 7, or 8"', add
label define educd_lbl 021 `"Grade 5 or 6"', add
label define educd_lbl 022 `"Grade 5"', add
label define educd_lbl 023 `"Grade 6"', add
label define educd_lbl 024 `"Grade 7 or 8"', add
label define educd_lbl 025 `"Grade 7"', add
label define educd_lbl 026 `"Grade 8"', add
label define educd_lbl 030 `"Grade 9"', add
label define educd_lbl 040 `"Grade 10"', add
label define educd_lbl 050 `"Grade 11"', add
label define educd_lbl 060 `"Grade 12"', add
label define educd_lbl 061 `"12th grade, no diploma"', add
label define educd_lbl 062 `"High school graduate or GED"', add
label define educd_lbl 063 `"Regular high school diploma"', add
label define educd_lbl 064 `"GED or alternative credential"', add
label define educd_lbl 065 `"Some college, but less than 1 year"', add
label define educd_lbl 070 `"1 year of college"', add
label define educd_lbl 071 `"1 or more years of college credit, no degree"', add
label define educd_lbl 080 `"2 years of college"', add
label define educd_lbl 081 `"Associate's degree, type not specified"', add
label define educd_lbl 082 `"Associate's degree, occupational program"', add
label define educd_lbl 083 `"Associate's degree, academic program"', add
label define educd_lbl 090 `"3 years of college"', add
label define educd_lbl 100 `"4 years of college"', add
label define educd_lbl 101 `"Bachelor's degree"', add
label define educd_lbl 110 `"5+ years of college"', add
label define educd_lbl 111 `"6 years of college (6+ in 1960-1970)"', add
label define educd_lbl 112 `"7 years of college"', add
label define educd_lbl 113 `"8+ years of college"', add
label define educd_lbl 114 `"Master's degree"', add
label define educd_lbl 115 `"Professional degree beyond a bachelor's degree"', add
label define educd_lbl 116 `"Doctoral degree"', add
label values educd educd_lbl

label define empstat_lbl 0 `"N/A"'
label define empstat_lbl 1 `"Employed"', add
label define empstat_lbl 2 `"Unemployed"', add
label define empstat_lbl 3 `"Not in labor force"', add
label values empstat empstat_lbl

label define ind1990_lbl 000 `"N/A (not applicable) "'
label define ind1990_lbl 010 `"Agricultural production, crops"', add
label define ind1990_lbl 011 `"Agricultural production, livestock"', add
label define ind1990_lbl 012 `"Veterinary services"', add
label define ind1990_lbl 020 `"Landscape and horticultural services"', add
label define ind1990_lbl 030 `"Agricultural services, n.e.c."', add
label define ind1990_lbl 031 `"Forestry"', add
label define ind1990_lbl 032 `"Fishing, hunting, and trapping "', add
label define ind1990_lbl 040 `"Metal mining"', add
label define ind1990_lbl 041 `"Coal mining"', add
label define ind1990_lbl 042 `"Oil and gas extraction"', add
label define ind1990_lbl 050 `"Nonmetallic mining and quarrying, except fuels "', add
label define ind1990_lbl 060 `"All construction "', add
label define ind1990_lbl 100 `"Meat products"', add
label define ind1990_lbl 101 `"Dairy products"', add
label define ind1990_lbl 102 `"Canned, frozen, and preserved fruits and vegetables"', add
label define ind1990_lbl 110 `"Grain mill products"', add
label define ind1990_lbl 111 `"Bakery products"', add
label define ind1990_lbl 112 `"Sugar and confectionery products"', add
label define ind1990_lbl 120 `"Beverage industries"', add
label define ind1990_lbl 121 `"Misc. food preparations and kindred products"', add
label define ind1990_lbl 122 `"Food industries, n.s."', add
label define ind1990_lbl 130 `"Tobacco manufactures"', add
label define ind1990_lbl 132 `"Knitting mills"', add
label define ind1990_lbl 140 `"Dyeing and finishing textiles, except wool and knit goods"', add
label define ind1990_lbl 141 `"Carpets and rugs"', add
label define ind1990_lbl 142 `"Yarn, thread, and fabric mills"', add
label define ind1990_lbl 150 `"Miscellaneous textile mill products"', add
label define ind1990_lbl 151 `"Apparel and accessories, except knit"', add
label define ind1990_lbl 152 `"Miscellaneous fabricated textile products"', add
label define ind1990_lbl 160 `"Pulp, paper, and paperboard mills"', add
label define ind1990_lbl 161 `"Miscellaneous paper and pulp products"', add
label define ind1990_lbl 162 `"Paperboard containers and boxes"', add
label define ind1990_lbl 171 `"Newspaper publishing and printing"', add
label define ind1990_lbl 172 `"Printing, publishing, and allied industries, except newspapers"', add
label define ind1990_lbl 180 `"Plastics, synthetics, and resins"', add
label define ind1990_lbl 181 `"Drugs"', add
label define ind1990_lbl 182 `"Soaps and cosmetics"', add
label define ind1990_lbl 190 `"Paints, varnishes, and related products"', add
label define ind1990_lbl 191 `"Agricultural chemicals"', add
label define ind1990_lbl 192 `"Industrial and miscellaneous chemicals"', add
label define ind1990_lbl 200 `"Petroleum refining"', add
label define ind1990_lbl 201 `"Miscellaneous petroleum and coal products"', add
label define ind1990_lbl 210 `"Tires and inner tubes"', add
label define ind1990_lbl 211 `"Other rubber products, and plastics footwear and belting"', add
label define ind1990_lbl 212 `"Miscellaneous plastics products"', add
label define ind1990_lbl 220 `"Leather tanning and finishing"', add
label define ind1990_lbl 221 `"Footwear, except rubber and plastic"', add
label define ind1990_lbl 222 `"Leather products, except footwear"', add
label define ind1990_lbl 230 `"Logging"', add
label define ind1990_lbl 231 `"Sawmills, planing mills, and millwork"', add
label define ind1990_lbl 232 `"Wood buildings and mobile homes"', add
label define ind1990_lbl 241 `"Miscellaneous wood products"', add
label define ind1990_lbl 242 `"Furniture and fixtures"', add
label define ind1990_lbl 250 `"Glass and glass products"', add
label define ind1990_lbl 251 `"Cement, concrete, gypsum, and plaster products"', add
label define ind1990_lbl 252 `"Structural clay products"', add
label define ind1990_lbl 261 `"Pottery and related products"', add
label define ind1990_lbl 262 `"Misc. nonmetallic mineral and stone products"', add
label define ind1990_lbl 270 `"Blast furnaces, steelworks, rolling and finishing mills"', add
label define ind1990_lbl 271 `"Iron and steel foundries"', add
label define ind1990_lbl 272 `"Primary aluminum industries"', add
label define ind1990_lbl 280 `"Other primary metal industries"', add
label define ind1990_lbl 281 `"Cutlery, handtools, and general hardware"', add
label define ind1990_lbl 282 `"Fabricated structural metal products"', add
label define ind1990_lbl 290 `"Screw machine products"', add
label define ind1990_lbl 291 `"Metal forgings and stampings"', add
label define ind1990_lbl 292 `"Ordnance"', add
label define ind1990_lbl 300 `"Miscellaneous fabricated metal products"', add
label define ind1990_lbl 301 `"Metal industries, n.s."', add
label define ind1990_lbl 310 `"Engines and turbines"', add
label define ind1990_lbl 311 `"Farm machinery and equipment"', add
label define ind1990_lbl 312 `"Construction and material handling machines"', add
label define ind1990_lbl 320 `"Metalworking machinery"', add
label define ind1990_lbl 321 `"Office and accounting machines"', add
label define ind1990_lbl 322 `"Computers and related equipment"', add
label define ind1990_lbl 331 `"Machinery, except electrical, n.e.c."', add
label define ind1990_lbl 332 `"Machinery, n.s."', add
label define ind1990_lbl 340 `"Household appliances"', add
label define ind1990_lbl 341 `"Radio, TV, and communication equipment"', add
label define ind1990_lbl 342 `"Electrical machinery, equipment, and supplies, n.e.c."', add
label define ind1990_lbl 350 `"Electrical machinery, equipment, and supplies, n.s."', add
label define ind1990_lbl 351 `"Motor vehicles and motor vehicle equipment"', add
label define ind1990_lbl 352 `"Aircraft and parts"', add
label define ind1990_lbl 360 `"Ship and boat building and repairing"', add
label define ind1990_lbl 361 `"Railroad locomotives and equipment"', add
label define ind1990_lbl 362 `"Guided missiles, space vehicles, and parts"', add
label define ind1990_lbl 370 `"Cycles and miscellaneous transportation equipment"', add
label define ind1990_lbl 371 `"Scientific and controlling instruments"', add
label define ind1990_lbl 372 `"Medical, dental, and optical instruments and supplies"', add
label define ind1990_lbl 380 `"Photographic equipment and supplies"', add
label define ind1990_lbl 381 `"Watches, clocks, and clockwork operated devices"', add
label define ind1990_lbl 390 `"Toys, amusement, and sporting goods"', add
label define ind1990_lbl 391 `"Miscellaneous manufacturing industries"', add
label define ind1990_lbl 392 `"Manufacturing industries, n.s. "', add
label define ind1990_lbl 400 `"Railroads"', add
label define ind1990_lbl 401 `"Bus service and urban transit"', add
label define ind1990_lbl 402 `"Taxicab service"', add
label define ind1990_lbl 410 `"Trucking service"', add
label define ind1990_lbl 411 `"Warehousing and storage"', add
label define ind1990_lbl 412 `"U.S. Postal Service"', add
label define ind1990_lbl 420 `"Water transportation"', add
label define ind1990_lbl 421 `"Air transportation"', add
label define ind1990_lbl 422 `"Pipe lines, except natural gas"', add
label define ind1990_lbl 432 `"Services incidental to transportation"', add
label define ind1990_lbl 440 `"Radio and television broadcasting and cable"', add
label define ind1990_lbl 441 `"Telephone communications"', add
label define ind1990_lbl 442 `"Telegraph and miscellaneous communications services"', add
label define ind1990_lbl 450 `"Electric light and power"', add
label define ind1990_lbl 451 `"Gas and steam supply systems"', add
label define ind1990_lbl 452 `"Electric and gas, and other combinations"', add
label define ind1990_lbl 470 `"Water supply and irrigation"', add
label define ind1990_lbl 471 `"Sanitary services"', add
label define ind1990_lbl 472 `"Utilities, n.s. "', add
label define ind1990_lbl 500 `"Motor vehicles and equipment"', add
label define ind1990_lbl 501 `"Furniture and home furnishings"', add
label define ind1990_lbl 502 `"Lumber and construction materials"', add
label define ind1990_lbl 510 `"Professional and commercial equipment and supplies"', add
label define ind1990_lbl 511 `"Metals and minerals, except petroleum"', add
label define ind1990_lbl 512 `"Electrical goods"', add
label define ind1990_lbl 521 `"Hardware, plumbing and heating supplies"', add
label define ind1990_lbl 530 `"Machinery, equipment, and supplies"', add
label define ind1990_lbl 531 `"Scrap and waste materials"', add
label define ind1990_lbl 532 `"Miscellaneous wholesale, durable goods"', add
label define ind1990_lbl 540 `"Paper and paper products"', add
label define ind1990_lbl 541 `"Drugs, chemicals, and allied products"', add
label define ind1990_lbl 542 `"Apparel, fabrics, and notions"', add
label define ind1990_lbl 550 `"Groceries and related products"', add
label define ind1990_lbl 551 `"Farm-product raw materials"', add
label define ind1990_lbl 552 `"Petroleum products"', add
label define ind1990_lbl 560 `"Alcoholic beverages"', add
label define ind1990_lbl 561 `"Farm supplies"', add
label define ind1990_lbl 562 `"Miscellaneous wholesale, nondurable goods"', add
label define ind1990_lbl 571 `"Wholesale trade, n.s. "', add
label define ind1990_lbl 580 `"Lumber and building material retailing"', add
label define ind1990_lbl 581 `"Hardware stores"', add
label define ind1990_lbl 582 `"Retail nurseries and garden stores"', add
label define ind1990_lbl 590 `"Mobile home dealers"', add
label define ind1990_lbl 591 `"Department stores"', add
label define ind1990_lbl 592 `"Variety stores"', add
label define ind1990_lbl 600 `"Miscellaneous general merchandise stores"', add
label define ind1990_lbl 601 `"Grocery stores"', add
label define ind1990_lbl 602 `"Dairy products stores"', add
label define ind1990_lbl 610 `"Retail bakeries"', add
label define ind1990_lbl 611 `"Food stores, n.e.c."', add
label define ind1990_lbl 612 `"Motor vehicle dealers"', add
label define ind1990_lbl 620 `"Auto and home supply stores"', add
label define ind1990_lbl 621 `"Gasoline service stations"', add
label define ind1990_lbl 622 `"Miscellaneous vehicle dealers"', add
label define ind1990_lbl 623 `"Apparel and accessory stores, except shoe"', add
label define ind1990_lbl 630 `"Shoe stores"', add
label define ind1990_lbl 631 `"Furniture and home furnishings stores"', add
label define ind1990_lbl 632 `"Household appliance stores"', add
label define ind1990_lbl 633 `"Radio, TV, and computer stores"', add
label define ind1990_lbl 640 `"Music stores"', add
label define ind1990_lbl 641 `"Eating and drinking places"', add
label define ind1990_lbl 642 `"Drug stores"', add
label define ind1990_lbl 650 `"Liquor stores"', add
label define ind1990_lbl 651 `"Sporting goods, bicycles, and hobby stores"', add
label define ind1990_lbl 652 `"Book and stationery stores"', add
label define ind1990_lbl 660 `"Jewelry stores"', add
label define ind1990_lbl 661 `"Gift, novelty, and souvenir shops"', add
label define ind1990_lbl 662 `"Sewing, needlework, and piece goods stores"', add
label define ind1990_lbl 663 `"Catalog and mail order houses"', add
label define ind1990_lbl 670 `"Vending machine operators"', add
label define ind1990_lbl 671 `"Direct selling establishments"', add
label define ind1990_lbl 672 `"Fuel dealers"', add
label define ind1990_lbl 681 `"Retail florists"', add
label define ind1990_lbl 682 `"Miscellaneous retail stores"', add
label define ind1990_lbl 691 `"Retail trade, n.s. "', add
label define ind1990_lbl 700 `"Banking"', add
label define ind1990_lbl 701 `"Savings institutions, including credit unions"', add
label define ind1990_lbl 702 `"Credit agencies, n.e.c."', add
label define ind1990_lbl 710 `"Security, commodity brokerage, and investment companies"', add
label define ind1990_lbl 711 `"Insurance"', add
label define ind1990_lbl 712 `"Real estate, including real estate-insurance offices "', add
label define ind1990_lbl 721 `"Advertising"', add
label define ind1990_lbl 722 `"Services to dwellings and other buildings"', add
label define ind1990_lbl 731 `"Personnel supply services"', add
label define ind1990_lbl 732 `"Computer and data processing services"', add
label define ind1990_lbl 740 `"Detective and protective services"', add
label define ind1990_lbl 741 `"Business services, n.e.c."', add
label define ind1990_lbl 742 `"Automotive rental and leasing, without drivers"', add
label define ind1990_lbl 750 `"Automobile parking and carwashes"', add
label define ind1990_lbl 751 `"Automotive repair and related services"', add
label define ind1990_lbl 752 `"Electrical repair shops"', add
label define ind1990_lbl 760 `"Miscellaneous repair services "', add
label define ind1990_lbl 761 `"Private households"', add
label define ind1990_lbl 762 `"Hotels and motels"', add
label define ind1990_lbl 770 `"Lodging places, except hotels and motels"', add
label define ind1990_lbl 771 `"Laundry, cleaning, and garment services"', add
label define ind1990_lbl 772 `"Beauty shops"', add
label define ind1990_lbl 780 `"Barber shops"', add
label define ind1990_lbl 781 `"Funeral service and crematories"', add
label define ind1990_lbl 782 `"Shoe repair shops"', add
label define ind1990_lbl 790 `"Dressmaking shops"', add
label define ind1990_lbl 791 `"Miscellaneous personal services "', add
label define ind1990_lbl 800 `"Theaters and motion pictures"', add
label define ind1990_lbl 801 `"Video tape rental"', add
label define ind1990_lbl 802 `"Bowling centers"', add
label define ind1990_lbl 810 `"Miscellaneous entertainment and recreation services "', add
label define ind1990_lbl 812 `"Offices and clinics of physicians"', add
label define ind1990_lbl 820 `"Offices and clinics of dentists"', add
label define ind1990_lbl 821 `"Offices and clinics of chiropractors"', add
label define ind1990_lbl 822 `"Offices and clinics of optometrists"', add
label define ind1990_lbl 830 `"Offices and clinics of health practitioners, n.e.c."', add
label define ind1990_lbl 831 `"Hospitals"', add
label define ind1990_lbl 832 `"Nursing and personal care facilities"', add
label define ind1990_lbl 840 `"Health services, n.e.c."', add
label define ind1990_lbl 841 `"Legal services"', add
label define ind1990_lbl 842 `"Elementary and secondary schools"', add
label define ind1990_lbl 850 `"Colleges and universities"', add
label define ind1990_lbl 851 `"Vocational schools"', add
label define ind1990_lbl 852 `"Libraries"', add
label define ind1990_lbl 860 `"Educational services, n.e.c."', add
label define ind1990_lbl 861 `"Job training and vocational rehabilitation services"', add
label define ind1990_lbl 862 `"Child day care services"', add
label define ind1990_lbl 863 `"Family child care homes"', add
label define ind1990_lbl 870 `"Residential care facilities, without nursing"', add
label define ind1990_lbl 871 `"Social services, n.e.c."', add
label define ind1990_lbl 872 `"Museums, art galleries, and zoos"', add
label define ind1990_lbl 873 `"Labor unions"', add
label define ind1990_lbl 880 `"Religious organizations"', add
label define ind1990_lbl 881 `"Membership organizations, n.e.c."', add
label define ind1990_lbl 882 `"Engineering, architectural, and surveying services"', add
label define ind1990_lbl 890 `"Accounting, auditing, and bookkeeping services"', add
label define ind1990_lbl 891 `"Research, development, and testing services"', add
label define ind1990_lbl 892 `"Management and public relations services"', add
label define ind1990_lbl 893 `"Miscellaneous professional and related services "', add
label define ind1990_lbl 900 `"Executive and legislative offices"', add
label define ind1990_lbl 901 `"General government, n.e.c."', add
label define ind1990_lbl 910 `"Justice, public order, and safety"', add
label define ind1990_lbl 921 `"Public finance, taxation, and monetary policy"', add
label define ind1990_lbl 922 `"Administration of human resources programs"', add
label define ind1990_lbl 930 `"Administration of environmental quality and housing programs"', add
label define ind1990_lbl 931 `"Administration of economic programs"', add
label define ind1990_lbl 932 `"National security and international affairs "', add
label define ind1990_lbl 940 `"Army"', add
label define ind1990_lbl 941 `"Air Force"', add
label define ind1990_lbl 942 `"Navy"', add
label define ind1990_lbl 950 `"Marines"', add
label define ind1990_lbl 951 `"Coast Guard"', add
label define ind1990_lbl 952 `"Armed Forces, branch not specified"', add
label define ind1990_lbl 960 `"Military Reserves or National Guard "', add
label define ind1990_lbl 992 `"Last worked 1984 or earlier"', add
label define ind1990_lbl 999 `"DID NOT RESPOND"', add
label values ind1990 ind1990_lbl

label define wkswork1_lbl 00 `"00"'
label values wkswork1 wkswork1_lbl

label define incwage_lbl 999999 `"N/A"'
label values incwage incwage_lbl

drop occ1990

gen age2 = age^2

replace sex = 0 if sex == 2
rename sex male

rename marst married
replace married = 1 if married == 2
replace married = 0 if married != 1

gen white = 1 if race == 1
replace white = 0 if race != 1

replace speakeng = speakeng - 1
replace speakeng = 1 if speakeng != 0

gen yr = 1 if year == 1990
replace yr = 0 if year == 1980

gen lhs = 1 if educd < 60
replace lhs = 0 if lhs == .
gen hs = 1 if educd == 60 |educd == 61 | educd == 62
replace hs = 0 if hs == .
gen scol = 1 if educd >= 65 & educd < 100
replace scol = 0 if scol == .
gen col = 1 if educd >= 100 
replace col = 0 if col == .

replace ind1990 = 151 if ind1990 == 152
replace ind1990 = 300 if ind1990 == 301
replace ind1990 = 331 if ind1990 == 332
replace ind1990 = 342 if ind1990 == 350
replace ind1990 = 391 if ind1990 == 392

drop race educ educd year wkswork1 datanum serial hhwt gq pernum 

save main1980.dta, replace
