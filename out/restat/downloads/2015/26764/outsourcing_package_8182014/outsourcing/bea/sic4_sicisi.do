*for this to work, the data you're trying to convert needs to be 4-digit actual sic codes with varname = sic
*this program was written for use in h:\databases\nonbea_data\stats.do (with the nber industry data) but can be modified
gen x = sic/10
gen sic3 = int(x)
drop x
gen x = sic/100
gen sic2 = int(x)
drop x
gen sicisi = sic3
replace sicisi = 210 if sic2 == 21
replace sicisi = 220 if sic2 == 22
replace sicisi = 230 if sic2 == 23
replace sicisi = 240 if sic2 == 24
replace sicisi = 250 if sic2 == 25
replace sicisi = 270 if sic2 == 27
replace sicisi = 310 if sic2 == 31
replace sicisi = 390 if sic2 == 39
replace sicisi = 291 if sic3 == 131
replace sicisi = 209 if sic3 == 206
replace sicisi = 209 if sic3 == 207
replace sicisi = 262 if sic3 == 261
replace sicisi = 262 if sic3 == 263
replace sicisi = 262 if sic3 == 266 & year==1977
replace sicisi = 265 if sic3 == 267
replace sicisi = 272 if sic3 == 273
replace sicisi = 272 if sic3 == 274
replace sicisi = 275 if sic3 == 276
replace sicisi = 272 if sic3 == 277
replace sicisi = 275 if sic3 == 278
replace sicisi = 275 if sic3 == 279
replace sicisi = 281 if sic3 == 282
replace sicisi = 285 if sic3 == 285 & year==1977
replace sicisi = 289 if sic3 == 285 & year!=1977
replace sicisi = 281 if sic3 == 286
replace sicisi = 292 if sic3 == 291
replace sicisi = 299 if sic3 == 295
replace sicisi = 305 if sic3 == 301
replace sicisi = 305 if sic3 == 302
replace sicisi = 305 if sic3 == 303 & year==1977
replace sicisi = 305 if sic3 == 304 & year==1977
replace sicisi = 305 if sic3 == 306
replace sicisi = 321 if sic3 == 322
replace sicisi = 321 if sic3 == 323
replace sicisi = 329 if sic3 == 324
replace sicisi = 329 if sic3 == 325
replace sicisi = 329 if sic3 == 326
replace sicisi = 329 if sic3 == 327
replace sicisi = 329 if sic3 == 328
replace sicisi = 331 if sic3 == 332
replace sicisi = 335 if sic3 == 333
replace sicisi = 335 if sic3 == 334
replace sicisi = 335 if sic3 == 336
replace sicisi = 331 if sic3 == 339
replace sicisi = 343 if sic3 == 344 & year!=1977
replace sicisi = 344 if sic3 == 344 & year==1977
replace sicisi = 342 if sic3 == 345
replace sicisi = 345 if sic3 == 345 & year==1977
replace sicisi = 341 if sic3 == 346
replace sicisi = 346 if sic3 == 346 & year==1977
replace sicisi = 349 if sic3 == 347
replace sicisi = 349 if sic3 == 348
replace sicisi = 369 if sic3 == 361
replace sicisi = 369 if sic3 == 362
replace sicisi = 364 if sic3 == 364 & year==1977
replace sicisi = 369 if sic3 == 364 & year!=1977
replace sicisi = 366 if sic3 == 365
replace sicisi = 379 if sic3 == 372
replace sicisi = 379 if sic3 == 373
replace sicisi = 379 if sic3 == 374
replace sicisi = 379 if sic3 == 375
replace sicisi = 379 if sic3 == 376
replace sicisi = 381 if sic3 == 382
replace sicisi = 383 if sic3 == 385 & year==1977
replace sicisi = 384 if sic3 == 385 & year!=1977
replace sicisi = 381 if sic3 == 387
