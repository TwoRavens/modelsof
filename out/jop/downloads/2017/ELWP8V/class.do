
* Conversion of ISCO-08 occupations (in ESS6 and ESS7) into ISCO-88 occupations (in previous ESS rounds)
* using the correspondence table from Ganzeboom: http://www.harryganzeboom.nl/isco08/index.htm

replace iscoco=110 if isco08==110
replace iscoco=110 if isco08==210
replace iscoco=110 if isco08==310
replace iscoco=110 if isco08==100
replace iscoco=110 if isco08==200
replace iscoco=110 if isco08==300
replace iscoco=1000 if isco08==1000
replace iscoco=1100 if isco08==1100
replace iscoco=1100 if isco08==1110
replace iscoco=1110 if isco08==1111
replace iscoco=1120 if isco08==1112
replace iscoco=1130 if isco08==1113
replace iscoco=1140 if isco08==1114
replace iscoco=1210 if isco08==1120
replace iscoco=1200 if isco08==1200
replace iscoco=1230 if isco08==1210
replace iscoco=1231 if isco08==1211
replace iscoco=1232 if isco08==1212
replace iscoco=1239 if isco08==1213
replace iscoco=1229 if isco08==1219
replace iscoco=1230 if isco08==1220
replace iscoco=1233 if isco08==1221
replace iscoco=1234 if isco08==1222
replace iscoco=1237 if isco08==1223
replace iscoco=1220 if isco08==1300
replace iscoco=1221 if isco08==1310
replace iscoco=1221 if isco08==1311
replace iscoco=1221 if isco08==1312
replace iscoco=1220 if isco08==1320
replace iscoco=1222 if isco08==1321
replace iscoco=1222 if isco08==1322
replace iscoco=1223 if isco08==1323
replace iscoco=1235 if isco08==1324
replace iscoco=1236 if isco08==1330
replace iscoco=1229 if isco08==1340
replace iscoco=1229 if isco08==1341
replace iscoco=1229 if isco08==1342
replace iscoco=1229 if isco08==1343
replace iscoco=1229 if isco08==1344
replace iscoco=1229 if isco08==1345
replace iscoco=1227 if isco08==1346
replace iscoco=1229 if isco08==1349
replace iscoco=1310 if isco08==1400
replace iscoco=1315 if isco08==1410
replace iscoco=1315 if isco08==1411
replace iscoco=1315 if isco08==1412
replace iscoco=1314 if isco08==1420
replace iscoco=1319 if isco08==1430
replace iscoco=1319 if isco08==1431
replace iscoco=1319 if isco08==1439
replace iscoco=2000 if isco08==2000
replace iscoco=2100 if isco08==2100
replace iscoco=2110 if isco08==2110
replace iscoco=2111 if isco08==2111
replace iscoco=2112 if isco08==2112
replace iscoco=2113 if isco08==2113
replace iscoco=2114 if isco08==2114
replace iscoco=2120 if isco08==2120
replace iscoco=2210 if isco08==2130
replace iscoco=2211 if isco08==2131
replace iscoco=2213 if isco08==2132
replace iscoco=2200 if isco08==2133
replace iscoco=2140 if isco08==2140
replace iscoco=2149 if isco08==2141
replace iscoco=2142 if isco08==2142
replace iscoco=2149 if isco08==2143
replace iscoco=2145 if isco08==2144
replace iscoco=2146 if isco08==2145
replace iscoco=2147 if isco08==2146
replace iscoco=2149 if isco08==2149
replace iscoco=2140 if isco08==2150
replace iscoco=2143 if isco08==2151
replace iscoco=2144 if isco08==2152
replace iscoco=2144 if isco08==2153
replace iscoco=2140 if isco08==2160
replace iscoco=2141 if isco08==2161
replace iscoco=2141 if isco08==2162
replace iscoco=3471 if isco08==2163
replace iscoco=2141 if isco08==2164
replace iscoco=2148 if isco08==2165
replace iscoco=3471 if isco08==2166
replace iscoco=2200 if isco08==2200
replace iscoco=2220 if isco08==2210
replace iscoco=2221 if isco08==2211
replace iscoco=2221 if isco08==2212
replace iscoco=2230 if isco08==2220
replace iscoco=2230 if isco08==2221
replace iscoco=2230 if isco08==2222
replace iscoco=3229 if isco08==2230
replace iscoco=3221 if isco08==2240
replace iscoco=2223 if isco08==2250
replace iscoco=3210 if isco08==2260
replace iscoco=2222 if isco08==2261
replace iscoco=2224 if isco08==2262
replace iscoco=2229 if isco08==2263
replace iscoco=3226 if isco08==2264
replace iscoco=3223 if isco08==2265
replace iscoco=3229 if isco08==2266
replace iscoco=3224 if isco08==2267
replace iscoco=2229 if isco08==2269
replace iscoco=2310 if isco08==2310
replace iscoco=2320 if isco08==2320
replace iscoco=2320 if isco08==2330
replace iscoco=2300 if isco08==2300
replace iscoco=2330 if isco08==2340
replace iscoco=2331 if isco08==2341
replace iscoco=2332 if isco08==2342
replace iscoco=2350 if isco08==2350
replace iscoco=2351 if isco08==2351
replace iscoco=2352 if isco08==2351
replace iscoco=2340 if isco08==2352
replace iscoco=2359 if isco08==2353
replace iscoco=2359 if isco08==2354
replace iscoco=2359 if isco08==2355
replace iscoco=2359 if isco08==2356
replace iscoco=2359 if isco08==2359
replace iscoco=2400 if isco08==2400
replace iscoco=2410 if isco08==2410
replace iscoco=2411 if isco08==2411
replace iscoco=2419 if isco08==2412
replace iscoco=2419 if isco08==2413
replace iscoco=2419 if isco08==2420
replace iscoco=2419 if isco08==2421
replace iscoco=2419 if isco08==2422
replace iscoco=2412 if isco08==2423
replace iscoco=2412 if isco08==2424
replace iscoco=2410 if isco08==2430
replace iscoco=2419 if isco08==2431
replace iscoco=2419 if isco08==2432
replace iscoco=3415 if isco08==2433
replace iscoco=3415 if isco08==2434
replace iscoco=2100 if isco08==2500
replace iscoco=2130 if isco08==2510
replace iscoco=2131 if isco08==2511
replace iscoco=2131 if isco08==2512
replace iscoco=2131 if isco08==2513
replace iscoco=2139 if isco08==2513
replace iscoco=2132 if isco08==2514
replace iscoco=2131 if isco08==2519
replace iscoco=2131 if isco08==2520
replace iscoco=2131 if isco08==2521
replace iscoco=2131 if isco08==2522
replace iscoco=2131 if isco08==2523
replace iscoco=2139 if isco08==2529
replace iscoco=2400 if isco08==2600
replace iscoco=2420 if isco08==2610
replace iscoco=2421 if isco08==2611
replace iscoco=2422 if isco08==2612
replace iscoco=2429 if isco08==2619
replace iscoco=2430 if isco08==2620
replace iscoco=2431 if isco08==2621
replace iscoco=2432 if isco08==2622
replace iscoco=2440 if isco08==2630
replace iscoco=2441 if isco08==2631
replace iscoco=2442 if isco08==2632
replace iscoco=2443 if isco08==2633
replace iscoco=2445 if isco08==2634
replace iscoco=2446 if isco08==2635
replace iscoco=2460 if isco08==2636
replace iscoco=2450 if isco08==2640
replace iscoco=2451 if isco08==2641
replace iscoco=2451 if isco08==2642
replace iscoco=2444 if isco08==2643
replace iscoco=2450 if isco08==2650
replace iscoco=2452 if isco08==2651
replace iscoco=2453 if isco08==2652
replace iscoco=2454 if isco08==2653
replace iscoco=2455 if isco08==2654
replace iscoco=2455 if isco08==2655
replace iscoco=3472 if isco08==2656
replace iscoco=3474 if isco08==2659
replace iscoco=3000 if isco08==3000
replace iscoco=3100 if isco08==3100
replace iscoco=3110 if isco08==3110
replace iscoco=3111 if isco08==3111
replace iscoco=3112 if isco08==3112
replace iscoco=3113 if isco08==3113
replace iscoco=3114 if isco08==3114
replace iscoco=3115 if isco08==3115
replace iscoco=3116 if isco08==3116
replace iscoco=3117 if isco08==3117
replace iscoco=3118 if isco08==3118
replace iscoco=3119 if isco08==3119
replace iscoco=1220 if isco08==3120
replace iscoco=1229 if isco08==3121
replace iscoco=1222 if isco08==3122
replace iscoco=1223 if isco08==3123
replace iscoco=8160 if isco08==3130
replace iscoco=8161 if isco08==3131
replace iscoco=8163 if isco08==3132
replace iscoco=8150 if isco08==3133
replace iscoco=8155 if isco08==3134
replace iscoco=8120 if isco08==3135
replace iscoco=8290 if isco08==3139
replace iscoco=3210 if isco08==3140
replace iscoco=3211 if isco08==3141
replace iscoco=3212 if isco08==3142
replace iscoco=3212 if isco08==3143
replace iscoco=3140 if isco08==3150
replace iscoco=3141 if isco08==3151
replace iscoco=3142 if isco08==3152
replace iscoco=3143 if isco08==3153
replace iscoco=3144 if isco08==3154
replace iscoco=3145 if isco08==3155
replace iscoco=3100 if isco08==3200
replace iscoco=3130 if isco08==3210
replace iscoco=3133 if isco08==3211
replace iscoco=3211 if isco08==3212
replace iscoco=3228 if isco08==3213
replace iscoco=7311 if isco08==3214
replace iscoco=3230 if isco08==3220
replace iscoco=3231 if isco08==3221
replace iscoco=3232 if isco08==3222
replace iscoco=3241 if isco08==3230
replace iscoco=3227 if isco08==3240
replace iscoco=3220 if isco08==3250
replace iscoco=3225 if isco08==3251
replace iscoco=3229 if isco08==3252
replace iscoco=3229 if isco08==3253
replace iscoco=3224 if isco08==3254
replace iscoco=3226 if isco08==3255
replace iscoco=3221 if isco08==3256
replace iscoco=3152 if isco08==3257
replace iscoco=3152 if isco08==3258
replace iscoco=3229 if isco08==3259
replace iscoco=3300 if isco08==3300
replace iscoco=3410 if isco08==3310
replace iscoco=3411 if isco08==3311
replace iscoco=3419 if isco08==3312
replace iscoco=3433 if isco08==3313
replace iscoco=3434 if isco08==3314
replace iscoco=3417 if isco08==3315
replace iscoco=3410 if isco08==3320
replace iscoco=3412 if isco08==3321
replace iscoco=3415 if isco08==3322
replace iscoco=3416 if isco08==3323
replace iscoco=3421 if isco08==3324
replace iscoco=3420 if isco08==3330
replace iscoco=3422 if isco08==3331
replace iscoco=3414 if isco08==3332
replace iscoco=3439 if isco08==3332
replace iscoco=3423 if isco08==3333
replace iscoco=3413 if isco08==3334
replace iscoco=3429 if isco08==3339
replace iscoco=3430 if isco08==3340
replace iscoco=3431 if isco08==3341
replace iscoco=3431 if isco08==3342
replace iscoco=3431 if isco08==3343
replace iscoco=3431 if isco08==3344
replace iscoco=3440 if isco08==3350
replace iscoco=3441 if isco08==3351
replace iscoco=3442 if isco08==3352
replace iscoco=3443 if isco08==3353
replace iscoco=3444 if isco08==3354
replace iscoco=3450 if isco08==3355
replace iscoco=3449 if isco08==3359
replace iscoco=3400 if isco08==3400
replace iscoco=3430 if isco08==3410
replace iscoco=3432 if isco08==3411
replace iscoco=3460 if isco08==3412
replace iscoco=3480 if isco08==3413
replace iscoco=3470 if isco08==3420
replace iscoco=3475 if isco08==3421
replace iscoco=3475 if isco08==3422
replace iscoco=3340 if isco08==3423
replace iscoco=3475 if isco08==3423
replace iscoco=3470 if isco08==3430
replace iscoco=3131 if isco08==3431
replace iscoco=3471 if isco08==3432
replace iscoco=3470 if isco08==3433
replace iscoco=5122 if isco08==3434
replace iscoco=3470 if isco08==3435
replace iscoco=3100 if isco08==3500
replace iscoco=3120 if isco08==3510
replace iscoco=3122 if isco08==3511
replace iscoco=3121 if isco08==3512
replace iscoco=2139 if isco08==3513
replace iscoco=3121 if isco08==3514
replace iscoco=3130 if isco08==3520
replace iscoco=3130 if isco08==3521
replace iscoco=3114 if isco08==3522
replace iscoco=3132 if isco08==3522
replace iscoco=4000 if isco08==4000
replace iscoco=4100 if isco08==4110
replace iscoco=4115 if isco08==4120
replace iscoco=4100 if isco08==4100
replace iscoco=4110 if isco08==4130
replace iscoco=4112 if isco08==4131
replace iscoco=4113 if isco08==4132
replace iscoco=4200 if isco08==4200
replace iscoco=4210 if isco08==4210
replace iscoco=4211 if isco08==4211
replace iscoco=4213 if isco08==4212
replace iscoco=4214 if isco08==4213
replace iscoco=4215 if isco08==4214
replace iscoco=4220 if isco08==4220
replace iscoco=3414 if isco08==4221
replace iscoco=4222 if isco08==4222
replace iscoco=4223 if isco08==4223
replace iscoco=4222 if isco08==4224
replace iscoco=4222 if isco08==4225
replace iscoco=4222 if isco08==4226
replace iscoco=4190 if isco08==4227
replace iscoco=4222 if isco08==4229
replace iscoco=4100 if isco08==4300
replace iscoco=4120 if isco08==4310
replace iscoco=4121 if isco08==4311
replace iscoco=4122 if isco08==4312
replace iscoco=4121 if isco08==4313
replace iscoco=4130 if isco08==4320
replace iscoco=4131 if isco08==4321
replace iscoco=4132 if isco08==4322
replace iscoco=4133 if isco08==4323
replace iscoco=4400 if isco08==4400
replace iscoco=4140 if isco08==4410
replace iscoco=4141 if isco08==4411
replace iscoco=4142 if isco08==4412
replace iscoco=4143 if isco08==4413
replace iscoco=4144 if isco08==4414
replace iscoco=4141 if isco08==4415
replace iscoco=4190 if isco08==4416
replace iscoco=4190 if isco08==4419
replace iscoco=5000 if isco08==5000
replace iscoco=5100 if isco08==5100
replace iscoco=5110 if isco08==5110
replace iscoco=5111 if isco08==5111
replace iscoco=5112 if isco08==5112
replace iscoco=5113 if isco08==5113
replace iscoco=5122 if isco08==5120
replace iscoco=5120 if isco08==5130
replace iscoco=5123 if isco08==5131
replace iscoco=5123 if isco08==5132
replace iscoco=5140 if isco08==5140
replace iscoco=5141 if isco08==5141
replace iscoco=5141 if isco08==5142
replace iscoco=5120 if isco08==5150
replace iscoco=5121 if isco08==5151
replace iscoco=5121 if isco08==5152
replace iscoco=9141 if isco08==5153
replace iscoco=5140 if isco08==5160
replace iscoco=5152 if isco08==5161
replace iscoco=5142 if isco08==5162
replace iscoco=5143 if isco08==5163
replace iscoco=5149 if isco08==5164
replace iscoco=3340 if isco08==5165
replace iscoco=5149 if isco08==5169
replace iscoco=5200 if isco08==5200
replace iscoco=5230 if isco08==5210
replace iscoco=5230 if isco08==5211
replace iscoco=9111 if isco08==5212
replace iscoco=1314 if isco08==5220
replace iscoco=1314 if isco08==5221
replace iscoco=1314 if isco08==5222
replace iscoco=5220 if isco08==5223
replace iscoco=4211 if isco08==5230
replace iscoco=5220 if isco08==5240
replace iscoco=5210 if isco08==5241
replace iscoco=5220 if isco08==5242
replace iscoco=9113 if isco08==5243
replace iscoco=9113 if isco08==5244
replace iscoco=5220 if isco08==5245
replace iscoco=5123 if isco08==5246
replace iscoco=5220 if isco08==5249
replace iscoco=5100 if isco08==5300
replace iscoco=5130 if isco08==5310
replace iscoco=5131 if isco08==5311
replace iscoco=5131 if isco08==5312
replace iscoco=5130 if isco08==5320
replace iscoco=5132 if isco08==5321
replace iscoco=5133 if isco08==5322
replace iscoco=5139 if isco08==5329
replace iscoco=5100 if isco08==5400
replace iscoco=5160 if isco08==5410
replace iscoco=5161 if isco08==5411
replace iscoco=5162 if isco08==5412
replace iscoco=5163 if isco08==5413
replace iscoco=5169 if isco08==5414
replace iscoco=5169 if isco08==5419
replace iscoco=6000 if isco08==6000
replace iscoco=6100 if isco08==6100
replace iscoco=6110 if isco08==6110
replace iscoco=6111 if isco08==6111
replace iscoco=6112 if isco08==6112
replace iscoco=6113 if isco08==6113
replace iscoco=6114 if isco08==6114
replace iscoco=6120 if isco08==6120
replace iscoco=6124 if isco08==6121
replace iscoco=6122 if isco08==6122
replace iscoco=6123 if isco08==6123
replace iscoco=6129 if isco08==6129
replace iscoco=6130 if isco08==6130
replace iscoco=6141 if isco08==6210
replace iscoco=6150 if isco08==6200
replace iscoco=6150 if isco08==6220
replace iscoco=6151 if isco08==6221
replace iscoco=6152 if isco08==6222
replace iscoco=6153 if isco08==6223
replace iscoco=6154 if isco08==6224
replace iscoco=6200 if isco08==6300
replace iscoco=6210 if isco08==6310
replace iscoco=6210 if isco08==6320
replace iscoco=6210 if isco08==6330
replace iscoco=6210 if isco08==6340
replace iscoco=7000 if isco08==7000
replace iscoco=7100 if isco08==7100
replace iscoco=7120 if isco08==7110
replace iscoco=7129 if isco08==7111
replace iscoco=7122 if isco08==7112
replace iscoco=7113 if isco08==7113
replace iscoco=7123 if isco08==7114
replace iscoco=7124 if isco08==7115
replace iscoco=7129 if isco08==7119
replace iscoco=7130 if isco08==7120
replace iscoco=7131 if isco08==7121
replace iscoco=7132 if isco08==7122
replace iscoco=7133 if isco08==7123
replace iscoco=7134 if isco08==7124
replace iscoco=7135 if isco08==7125
replace iscoco=7136 if isco08==7126
replace iscoco=7240 if isco08==7127
replace iscoco=7140 if isco08==7130
replace iscoco=7141 if isco08==7131
replace iscoco=7142 if isco08==7132
replace iscoco=7143 if isco08==7133
replace iscoco=7200 if isco08==7200
replace iscoco=7210 if isco08==7210
replace iscoco=7211 if isco08==7211
replace iscoco=7212 if isco08==7212
replace iscoco=7213 if isco08==7213
replace iscoco=7214 if isco08==7214
replace iscoco=7215 if isco08==7215
replace iscoco=7220 if isco08==7220
replace iscoco=7221 if isco08==7221
replace iscoco=7222 if isco08==7222
replace iscoco=7223 if isco08==7223
replace iscoco=7224 if isco08==7224
replace iscoco=7230 if isco08==7230
replace iscoco=7231 if isco08==7231
replace iscoco=7232 if isco08==7232
replace iscoco=7233 if isco08==7233
replace iscoco=7231 if isco08==7234
replace iscoco=7300 if isco08==7300
replace iscoco=7310 if isco08==7310
replace iscoco=7311 if isco08==7311
replace iscoco=7312 if isco08==7312
replace iscoco=7313 if isco08==7313
replace iscoco=7321 if isco08==7314
replace iscoco=7322 if isco08==7315
replace iscoco=3471 if isco08==7316
replace iscoco=7331 if isco08==7317
replace iscoco=7332 if isco08==7318
replace iscoco=7330 if isco08==7319
replace iscoco=7340 if isco08==7320
replace iscoco=7340 if isco08==7321
replace iscoco=7340 if isco08==7322
replace iscoco=7345 if isco08==7323
replace iscoco=7200 if isco08==7400
replace iscoco=7240 if isco08==7410
replace iscoco=7137 if isco08==7411
replace iscoco=7241 if isco08==7412
replace iscoco=7245 if isco08==7413
replace iscoco=7240 if isco08==7420
replace iscoco=7242 if isco08==7421
replace iscoco=7243 if isco08==7421
replace iscoco=7243 if isco08==7422
replace iscoco=7400 if isco08==7500
replace iscoco=7410 if isco08==7510
replace iscoco=7411 if isco08==7511
replace iscoco=7412 if isco08==7512
replace iscoco=7413 if isco08==7513
replace iscoco=7414 if isco08==7514
replace iscoco=7415 if isco08==7515
replace iscoco=7416 if isco08==7516
replace iscoco=7420 if isco08==7520
replace iscoco=7421 if isco08==7521
replace iscoco=7422 if isco08==7522
replace iscoco=7423 if isco08==7523
replace iscoco=7430 if isco08==7530
replace iscoco=7434 if isco08==7531
replace iscoco=7435 if isco08==7532
replace iscoco=7436 if isco08==7533
replace iscoco=7437 if isco08==7534
replace iscoco=7441 if isco08==7535
replace iscoco=7442 if isco08==7536
replace iscoco=7200 if isco08==7540
replace iscoco=7216 if isco08==7541
replace iscoco=7112 if isco08==7542
replace iscoco=3152 if isco08==7543
replace iscoco=7143 if isco08==7544
replace iscoco=7000 if isco08==7549
replace iscoco=8000 if isco08==8000
replace iscoco=8100 if isco08==8100
replace iscoco=8110 if isco08==8110
replace iscoco=7111 if isco08==8111
replace iscoco=8112 if isco08==8112
replace iscoco=8113 if isco08==8113
replace iscoco=8212 if isco08==8114
replace iscoco=8120 if isco08==8120
replace iscoco=8120 if isco08==8121
replace iscoco=8223 if isco08==8122
replace iscoco=8220 if isco08==8130
replace iscoco=8220 if isco08==8131
replace iscoco=8224 if isco08==8132
replace iscoco=8230 if isco08==8140
replace iscoco=8231 if isco08==8141
replace iscoco=8232 if isco08==8142
replace iscoco=8253 if isco08==8143
replace iscoco=8260 if isco08==8150
replace iscoco=8261 if isco08==8151
replace iscoco=8262 if isco08==8152
replace iscoco=8263 if isco08==8153
replace iscoco=8264 if isco08==8154
replace iscoco=8265 if isco08==8155
replace iscoco=8266 if isco08==8156
replace iscoco=8264 if isco08==8157
replace iscoco=8269 if isco08==8159
replace iscoco=8270 if isco08==8160
replace iscoco=8140 if isco08==8170
replace iscoco=8140 if isco08==8171
replace iscoco=8141 if isco08==8172
replace iscoco=8290 if isco08==8180
replace iscoco=8131 if isco08==8181
replace iscoco=8162 if isco08==8182
replace iscoco=8290 if isco08==8183
replace iscoco=8290 if isco08==8189
replace iscoco=8200 if isco08==8200
replace iscoco=8280 if isco08==8210
replace iscoco=8281 if isco08==8211
replace iscoco=8283 if isco08==8212
replace iscoco=8290 if isco08==8219
replace iscoco=8300 if isco08==8300
replace iscoco=8310 if isco08==8310
replace iscoco=8311 if isco08==8311
replace iscoco=8312 if isco08==8312
replace iscoco=8320 if isco08==8320
replace iscoco=8321 if isco08==8321
replace iscoco=8322 if isco08==8322
replace iscoco=8320 if isco08==8330
replace iscoco=8323 if isco08==8331
replace iscoco=8324 if isco08==8332
replace iscoco=8330 if isco08==8340
replace iscoco=8331 if isco08==8341
replace iscoco=8332 if isco08==8342
replace iscoco=8333 if isco08==8343
replace iscoco=8334 if isco08==8344
replace iscoco=8340 if isco08==8350
replace iscoco=9000 if isco08==9000
replace iscoco=9100 if isco08==9100
replace iscoco=9130 if isco08==9110
replace iscoco=9131 if isco08==9111
replace iscoco=9132 if isco08==9112
replace iscoco=9140 if isco08==9120
replace iscoco=9133 if isco08==9121
replace iscoco=9142 if isco08==9122
replace iscoco=9142 if isco08==9123
replace iscoco=9140 if isco08==9129
replace iscoco=9200 if isco08==9200
replace iscoco=9210 if isco08==9210
replace iscoco=9211 if isco08==9211
replace iscoco=9211 if isco08==9212
replace iscoco=9211 if isco08==9213
replace iscoco=9211 if isco08==9214
replace iscoco=9212 if isco08==9215
replace iscoco=9213 if isco08==9216
replace iscoco=9300 if isco08==9300
replace iscoco=9310 if isco08==9310
replace iscoco=9311 if isco08==9311
replace iscoco=9312 if isco08==9312
replace iscoco=9313 if isco08==9313
replace iscoco=9320 if isco08==9320
replace iscoco=9322 if isco08==9321
replace iscoco=9320 if isco08==9329
replace iscoco=9330 if isco08==9330
replace iscoco=9331 if isco08==9331
replace iscoco=9332 if isco08==9332
replace iscoco=9333 if isco08==9333
replace iscoco=9333 if isco08==9334
replace iscoco=9100 if isco08==9400
replace iscoco=9130 if isco08==9410
replace iscoco=5122 if isco08==9411
replace iscoco=9132 if isco08==9412
replace iscoco=9100 if isco08==9500
replace iscoco=9120 if isco08==9510
replace iscoco=9112 if isco08==9520
replace iscoco=9100 if isco08==9600
replace iscoco=9160 if isco08==9610
replace iscoco=9161 if isco08==9611
replace iscoco=9161 if isco08==9612
replace iscoco=9162 if isco08==9613
replace iscoco=9140 if isco08==9620
replace iscoco=9151 if isco08==9621
replace iscoco=9160 if isco08==9622
replace iscoco=9153 if isco08==9623
replace iscoco=9160 if isco08==9624
replace iscoco=9100 if isco08==9629


*/For below coding 1000: armed forces, should all be 100
replace iscoco=100 if inlist(isco08,0,100,110,200,210,300,310)

*/Missings etc.
replace iscoco = isco08 if iscoco==. & isco08>10000 & essround==6

* Creating class variable 
* Using the stata code by Felix Weiss & Gerrit Bauer 
* Mannheimer Zentrum fuer Europäische Sozialforschung 
* http://www.mzes.uni-mannheim.de/download/ESeC_full_version_for_ESS.do
* Based on http://www.iser.essex.ac.uk/esec/guide/docs/Appendix6.sps ***
* (SPSS-Job-File of Harrison/Rose)

*Generating 3-digit isco

gen isco4=iscoco
gen isco8803= int(isco4/10)
replace isco8803=iscoco if iscoco>10000

**Stage 1 - derive employment status categories***
***need to know whether employed (1) or self-employed (2). Family workers (3) here treated as employees. Variable name in ESS is emplrel**
***Self-employed are split three ways. First take the continuous variable for how many employees people have (in ESS 'emplno') 
***and collapse into categorical variable as below***

gen empnum=.
replace empnum=0 if emplno==0
replace empnum=1 if emplno>=1&emplno<10
replace empnum=2 if emplno>=10&emplno<=6000
replace empnum=9 if emplno>=77777&emplno<=99999

**now combine basic employment situation (*emplrel*) with supervision variable also to give five statuses**
**In ESS this question is called jbspv (yes=1, no=2)**

gen empstat=.
replace empstat=1 if emplrel==2 & empnum==2
replace empstat=2 if emplrel==2 & empnum==1
replace empstat=3 if emplrel==2 & (empnum==0 | empnum==9)
replace empstat=4 if (jbspv==1 & emplrel==1) | (jbspv==1 & emplrel==3)
replace empstat=5 if (jbspv>=2 & emplrel==1) | (jbspv>=2 & emplrel==3)

lab var empstat "ESeC employment status variable"

lab def empstat ///
1 "Self-employed 10+ employees" ///
2 "Self-employed <10 employees" ///
3 " Self-employed no employees" ///
4 "Supervisors" ///
5 "Employees" 

lab val empstat empstat

**Stage 2 - creation of 'euroesec' (international comparative version of ESeC based on ISCO minor groups)**

**self-employed 10+ employees. Defaults to 1 unless otherwise in matrix**
gen euroesec=isco8803

recode euroesec 344 345=2 011 516=3 621=5 if empstat==1
replace euroesec=1 if euroesec==isco8803 & empstat==1


**Small employers <10. Defaults to 4 unless otherwise in matrix**

recode euroesec ///
010 110 111 114 200 210 211 212 213 214 220 221 222 231 235 240 241 242=1 ///
223 230 232 233 234 243 244 245 246 247 310 311 312 314 320 321 322 323 334 342 344 345 348=2 ///
011 516=3 ///
600 610 611 612 613 614 615 621 920 921=5 if empstat==2
replace euroesec=4 if euroesec==isco8803 & empstat==2

**Self-employed with no employees. Defaults to 4 unless otherwise in matrix**

recode euroesec ///
010 110 111 114 200 210 211 212 213 214 220 221 222 231 235 240 241 242=1 ///
223 230 232 233 234 243 244 245 246 247 310 311 312 314 320 321 322 323 334 342 344 345 348=2 ///
011 516=3 ///
600 610 611 612 613 614 615 621 920 921=5  if empstat==3
replace euroesec=4 if euroesec==isco8803 & empstat==3

***'Supervisors'***

recode euroesec /// 
010 100 110 111 114 120 121 123 200 210 211 212 213 214 220 221 222 231 235 240 241 242=1 ///
011 122 130 131 223 230 232 233 234 243 244 245 246 247 300 310 311 312 313 314 320 321 322 323 330 331 332 333 334 340 ///
341 342 343 344 345 346 347 348 400 410 411 412 419 420 521=2 ///
621=5 66666=66666 77777=77777 88888=88888 99999=99999 else=6 ///
if empstat==4

**Employees**

recode euroesec ///
010 100 110 111 114 120 121 123 200 210 211 212 213 214 220 221 222 231 235 240 241 242=1 ///
122 130 131 223 230 232 233 234 243 244 245 246 247 310 311 312 314 320 321 322 323 334 ///
342 344 345 348 521=2 ///
011 300 330 331 332 333 340 341 343 346 347 400 410 411 412 419 420=3 ///
621=5 ///
313 315 730 731=6 ///
413 421 422 500 510 511 513 514 516 520 522 911=7 ///
600 610 611 612 613 614 615 700 710 711 712 713 714 720 721 722 723 724 732 733 734 740 741 742 743 744 ///
825 831 834=8 ///
414 512 800 810 811  812 813 814 815 816 817 820 821 822 823 824 826 827 828 829 830 832 833 ///
900 910 912 913 914 915 916 920 921 930 931 932 933=9 if empstat==5


**Final block to sweep up missing employment statuses. **
**Allocations here on the basis of modal ESS employment status (so-called 'simplified class')**

recode euroesec ///
010 100 110 111 114 120 121 123 200 210 211 212 213 214 220 221 222 231 235 240 241 242=1 ///
122 223 230 232 233 234 243 244 245 246 247 310 311 312 314 320 321 322 323 334 342 344 345 348 521=2 ///
011 300 330 331 332 333 340 341 343 346 347 400 410 411 412 419 420=3 ///
130 131 911=4 ///
600 610 611 612 613 621=5 ///
313 315 730 731=6 ///
413 421 422 500 510 511 513 514 516 520 522=7 ///
614 615 700 710 711 712 713 714 720 721 722 723 724 732 733 734 740 741 742 743 744 825 831 834=8 ///
414 512 800 810 811 811 812 813 814 815 816 817 820 821 822 823 824 826 827 828 829 830 832 833 ///
900 910 912 913 914 915 916 920 921 930 931 932 933=9 if empstat==.

lab var euroesec "European ESeC"

lab def euroesec ///
1 "Large employers, higher mgrs/professionals" ///
2 "Lower mgrs/professionals, higher supervisory/technicians" ///
3 "Intermediate occupations" ///
4 "Small employers and self-employed (non-agriculture)" ///
5 "Small employers and self-employed (agriculture)" ///
6 "Lower supervisors and technicians" ///
7 "Lower sales and service"  ///
8 "Lower technical" ///
9 "Routine" ///
66666 "Not applicable" ///
77777 "Refusal" ///
88888 "DK" ///
99999 "No answer"

lab value euroesec euroesec

* Drop 32 observations without eurosec categorization

drop if euroesec==112 | euroesec==324 | euroesec==429 | euroesec==440 | euroesec==523
