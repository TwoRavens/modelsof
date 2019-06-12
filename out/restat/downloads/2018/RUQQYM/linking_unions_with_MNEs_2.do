**CREATES FIGURES 1(a),5,6,12
**CREATES TABLE 1(LEFT PANELS),2(LEFT PANELS),3,4,5(TOP 2 PANELS),6(TOP PANEL),9-12

**LINK ESTABLISHMENT ELECTIONS WITH MNE FIRMS**

**start with elections from fy1961-fy2009
set more off
clear
use "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\merged_elections_1961_2009.dta", clear
sort employer
replace employer = upper(employer)
stnd_compname employer, gen(stn_name stn_dbaname stn_fkaname entitytype attn_name)
duplicates tag stn_name, generate(same_firm_dummy)
egen employer_id=group(stn_name) 
gen union_id = _n
replace union_id = union_id*2
rename employer name
drop if employer_id==.
save "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\merged_elections_1961_2009_tags_2.dta", replace

**Create a master list of all firms in union elections db
*collapse to one employer
collapse (first) employer_id, by(stn_name)
moss stn_name, match("(")
moss stn_name, match(")") prefix(close_)
browse if _count!=close_count
replace stn_name = trim(stn_name)
compress
keep stn_name employer_id 
sort employer_id
save "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\master_unions_list_2.dta", replace

** **Create a master list of all firms in MNE survey
clear

 /* set data directory */
global filepath "DIRECTORY MASKED"

odbc load, table("master_file")
destring foreign_id, replace
keep if foreign_id==0
**prep MNE master data for merge
moss name, match("(")
moss name, match(")") prefix(close_)
edit if _count!=close_count
replace name = name + ")" if _count!=close_count
keep name us_id
sort us_id
save "$filepath\names_mne_master.dta", replace
**standardize business names
stnd_compname name, gen(stn_name stn_dbaname stn_fkaname entitytype attn_name)
collapse (first) us_id, by(stn_name) 
moss stn_name, match("(")
moss stn_name, match(")") prefix(close_)
edit if _count!=close_count
keep stn_name us_id
sort us_id
save "$filepath\names_mne_master_2.dta", replace
**now link names across elections and MNE dbs
sort us_id
reclink2 stn_name using "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\master_unions_list_2.dta", idm(us_id) idu(employer_id) gen(myscore) minbigram(.60) npairs(3)
order myscore stn_name Ustn_name us_id employer_id
gsort - myscore
compress Ustn_name
save "$filepath\linked_unions_to_MNEs_master.dta", replace
edit
gen match=1 if myscore==1
order myscore stn_name Ustn_name us_id employer_id match
gen flag = 1 if match==1 & stn_name!=Ustn_name
replace match=0 if us_id==102396 & employer_id==149803
replace match=0 if us_id==7560 & employer_id==106368
replace match=0 if us_id==109455 & employer_id==76938
replace match=0 if us_id==109455 & employer_id==76337
replace match=0 if us_id==64750 & employer_id==50015
replace match=0 if us_id==109455 & employer_id==75756
replace match=0 if us_id==103388 & employer_id==24262
replace match=0 if us_id==109455 & employer_id==76194
replace match=0 if us_id==109455 & employer_id==76337
replace match=0 if us_id==103434 & employer_id==91734
replace match=0 if us_id==109455 & employer_id==76271
replace match=0 if us_id==109455 & employer_id==76216
replace match=0 if us_id==1940 & employer_id==4602
replace match=0 if us_id==109455 & employer_id==76366
replace match=0 if us_id==90150 & employer_id==139140
replace match=0 if us_id==101352 & employer_id==38813
replace match=0 if us_id==1940 & employer_id==4589
replace match=0 if us_id==38010 & employer_id==89037
replace match=0 if us_id==90150 & employer_id==160502
replace match=0 if us_id==109455 & employer_id==76335
replace match=0 if us_id==104287 & employer_id==142211
replace match=0 if us_id==50950 & employer_id==124203
replace match=0 if us_id==40250 & employer_id==33103
replace match=0 if us_id==109455 & employer_id==76190
replace match=0 if us_id==111130 & employer_id==55928
replace match=0 if us_id==109455 & employer_id==66619
replace match=0 if us_id==67030 & employer_id==145251
replace match=0 if us_id==38010 & employer_id==89058
replace match=0 if us_id==4860 & employer_id==126271
replace match=1 if round(myscore,.0001)==.9998
replace match=0 if us_id==1940 & employer_id==4586
replace match=0 if us_id==104179 & employer_id==145081
replace match=0 if us_id==89870 & employer_id==124618
replace match=1 if round(myscore,.0001)==.9997
replace match=0 if us_id==50950 & employer_id==124204
replace match=1 if round(myscore,.0001)==.9996
replace match=0 if us_id==90150 & employer_id==97745
replace match=0 if us_id==20420 & employer_id==43642
replace match=1 if round(myscore,.0001)>=.9977 & match==.
replace match=0 if us_id==107886 & employer_id==26011
replace match=0 if us_id==20770 & employer_id==152620
replace match=0 if us_id==107886 & employer_id==26009
replace match=0 if us_id==107886 & employer_id==26011
replace match=0 if us_id==100072 & employer_id==9570
replace match=0 if us_id==31260 & employer_id==34612
replace match=0 if us_id==53240 & employer_id==129812
replace match=0 if us_id==40250 & employer_id==144281
replace match=0 if us_id==107886 & employer_id==25966
replace match=0 if us_id==101277 & employer_id==142293
replace match=0 if us_id==68140 & employer_id==33491
replace match=0 if us_id==40250 & employer_id==147396
replace match=0 if us_id==40250 & employer_id==149803
replace match=0 if us_id==40250 & employer_id==81464
replace match=0 if us_id==40250 & employer_id==50159
replace match=0 if us_id==103352 & employer_id==15946
replace match=0 if us_id==96630 & employer_id==34590
replace match=0 if us_id==67030 & employer_id==145265
replace match=0 if us_id==102690 & employer_id==57691 
replace match=0 if us_id==102690 & employer_id==57692 
replace match=0 if round(myscore,.0001)>=.9977 & us_id==96630
replace match=0 if us_id==58731 & employer_id==52145
replace match=0 if us_id==62760 & employer_id==154573
replace match=0 if us_id==74310 & employer_id==7227 
replace match=0 if us_id==11800 & employer_id==156121 
replace match=0 if us_id==3620 & employer_id==6699 
replace match=0 if us_id==3330 & employer_id==7031 
replace match=0 if us_id==100132 & employer_id==7332
replace match=0 if us_id==2880 & employer_id==7127 
replace match=0 if us_id==105328 & employer_id==119566 
replace match=0 if us_id==102642 & employer_id==157793 
replace match=0 if us_id==81600 & employer_id==126245
replace match=0 if us_id==103105 & employer_id==7722 
replace match=0 if us_id==105884 & employer_id==7467 
replace match=0 if us_id==105738 & employer_id==76905
replace match=0 if us_id==83120 & employer_id==7718
replace match=0 if us_id==20770 & employer_id==69419 
replace match=0 if us_id==104287 & employer_id==73838 
replace match=0 if us_id==104287 & employer_id==80174 
replace match=0 if us_id==3450 & employer_id==7959 
replace match=0 if us_id==3390 & employer_id==7231
replace match=0 if us_id==31260 & employer_id==72533
replace match=0 if us_id==31260 & employer_id==72540
replace match=0 if us_id==80880 & employer_id==143980
replace match=0 if us_id==31260 & employer_id==72530
replace match=0 if us_id==105743 & employer_id==13269
replace match=0 if us_id==9440 & employer_id==13278
replace match=0 if us_id==31260 & employer_id==72537
gen contained=1 if strpos(stn_name, Ustn_name) | strpos(Ustn_name, stn_name)
**FIRM NAMES/IDS MASKED TO PROTECT CONFIDENTIALITY**
replace match = 1 in 2298
replace match = 1 in 2302
replace match = 1 in 2303
replace match = 1 in 2304
replace match = 1 in 2305
replace match = 1 in 2306
replace match = 1 in 2307
replace match = 1 in 2309
replace match = 1 in 2311
replace match = 1 in 2312
replace match = 1 in 2313
replace match = 1 in 2316
replace match = 1 in 2319
replace match = 1 in 2321
replace match = 1 in 2324
replace match = 1 in 2325
replace match = 1 in 2327
replace match = 1 in 2328
replace match = 1 in 2331
replace match = 1 in 2332
replace match = 1 in 2334
replace match = 1 in 2335
replace match = in 2336
replace match = 1 in 2337
replace match = 1 in 2338
replace match = 1 in 2339
replace match = 1 in 2340
replace match = 1 in 2342
replace match = 1 in 2343
replace match = 1 in 2344
replace match = 1 in 2351
replace match = 1 in 2355
replace match = 1 in 2356
replace match = 1 in 2360
replace match = 1 in 2361
replace match = 1 in 2362
replace match = 1 in 2363
replace match = 1 in 2364
replace match = 1 in 2366
replace match = 1 in 2367
replace match = 1 in 2370
replace match = 1 in 2372
replace match = 1 in 2373
replace match = 1 in 2374
replace match = 1 in 2376
replace match = 1 in 2377
replace match = 1 in 2378
replace match = 1 in 2379
replace match = 1 in 2381
replace match = 1 in 2382
replace match = 1 in 2386
replace match = 1 in 2387
replace match = 1 in 2388
replace match = 1 in 2391
replace match = 1 in 2393
replace match = 1 in 2395
replace match = 1 in 2396
replace match = 1 in 2397
replace match = 1 in 2399
replace match = 1 in 2400
replace match = 1 in 2401
replace match = 1 in 2402
replace match = 1 in 2403
replace match = 1 in 2404
replace match = 1 in 2405
replace match = 1 in 2406
replace match = 1 in 2407
replace match = 1 in 2408
replace match = 1 in 2409
replace match = 1 in 2410
replace match = 1 in 2411
replace match = 1 in 2412
replace match = 1 in 2413
replace match = 1 in 2415
replace match = 1 in 2416
replace match = 1 in 2417
replace match = 1 in 2418
replace match = 1 in 2421
replace match = 1 in 2429
replace match = 1 in 2430
replace match = 1 in 2433
replace match = 1 in 2436
replace match = 1 in 2437
replace match = 1 in 2439
replace match = 1 in 2440
replace match = 1 in 2442
replace match = 1 in 2444
replace match = 1 in 2445
replace match = 1 in 2449
replace match = 1 in 2450
replace match = 1 in 2452
replace match = 1 in 2453
replace match = 1 in 2454
replace match = 1 in 2455
replace match = 1 in 2457
replace match = 1 in 2458
replace match = 1 in 2459
replace match = 1 in 2460
replace match = 1 in 2461
replace match = 1 in 2462
replace match = 1 in 2466
replace match = 1 in 2467
replace match = 1 in 2469
replace match = 1 in 2474
replace match = 1 in 2476
replace match = 1 in 2487
replace match = 1 in 2488
replace match = 1 in 2489
replace match = 1 in 2490
replace match = 1 in 2495
replace match = 1 in 2496
replace match = 1 in 2498
replace match = 1 in 2499
replace match = 1 in 2500
replace match = 1 in 2502
replace match = 1 in 2503
replace match = 1 in 2506
replace match = 1 in 2509
replace match = 1 in 2511
replace match = 1 in 2515
replace match = 1 in 2524
replace match = 1 in 2526
replace match = 1 in 2528
replace match = 1 in 2530
replace match = 1 in 2531
replace match = 1 in 2532
replace match = 1 in 2533
replace match = 1 in 2534
replace match = 1 in 2535
replace match = 1 in 2536
replace match = 1 in 2537
replace match = 1 in 2538
replace match = 1 in 2543
replace match = 1 in 2545
replace match = 1 in 2546
replace match = 1 in 2549
replace match = 1 in 2551
replace match = 1 in 2553
replace match = 1 in 2554
replace match = 1 in 2555
replace match = 1 in 2556
replace match = 1 in 2557
replace match = 1 in 2558
replace match = 1 in 2559
replace match = 1 in 2560
replace match = 1 in 2561
replace match = 1 in 2569
replace match = 1 in 2571
replace match = 1 in 2572
replace match = 1 in 2574
replace match = 1 in 2575
replace match = 1 in 2580
replace match = 1 in 2581
replace match = 1 in 2583
replace match = 1 in 2585
replace match = 1 in 2587
replace match = 1 in 2588
replace match = 1 in 2589
replace match = 1 in 2590
replace match = 1 in 2591
replace match = 1 in 2593
replace match = 1 in 2594
replace match = 1 in 2595
replace match = 1 in 2598
replace match = 1 in 2600
replace match = 1 in 2601
replace match = 1 in 2604
replace match = 1 in 2605
replace match = 1 in 2610
replace match = 1 in 2612
replace match = 1 in 2613
replace match = 1 in 2617
replace match = 1 in 2627
replace match = 1 in 2631
replace match = 1 in 2632
replace match = 1 in 2634
replace match = 1 in 2640
replace match = 1 in 2642
replace match = 1 in 2644
replace match = 1 in 2646
replace match = 1 in 2651
replace match = 1 in 2652
replace match = 1 in 2653
replace match = 1 in 2654
replace match = 1 in 2655
replace match = 1 in 2656
replace match = 1 in 2661
replace match = in 2663
replace match = 1 in 2664
replace match = 1 in 2665
replace match = 1 in 2666
replace match = 1 in 2667
replace match = 1 in 2669
replace match = 1 in 2672
replace match = 1 in 2673
replace match = 1 in 2674
replace match = 1 in 2676
replace match = 1 in 2679
replace match = 1 in 2681
replace match = 1 in 2682
replace match = 1 in 2686
replace match = 1 in 2690
replace match = 1 in 2692
replace match = 1 in 2695
replace match = 1 in 2698
replace match = 1 in 2699
replace match = 1 in 2706
replace match = in 2706
replace match = 1 in 2707
replace match = 1 in 2708
replace match = 1 in 2709
replace match = 1 in 2712
replace match = 1 in 2713
replace match = 1 in 2719
replace match = 1 in 2722
replace match = 1 in 2723
replace match = 1 in 2726
replace match = 1 in 2731
replace match = 1 in 2733
replace match = 1 in 2738
replace match = 1 in 2745
replace match = 1 in 2746
replace match = 1 in 2747
replace match = 1 in 2751
replace match = 1 in 2753
replace match = 1 in 2754
replace match = 1 in 2770
replace match = 1 in 2775
replace match = 1 in 2780
replace match = 1 in 2793
replace match = 1 in 2799
replace match = 1 in 2801
replace match = 1 in 2809
replace match = 1 in 2810
replace match = 1 in 2811
replace match = 1 in 2812
replace match = 1 in 2819
replace match = 1 in 2820
replace match = 1 in 2823
replace match = 1 in 2826
replace match = 1 in 2833
replace match = 1 in 2845
replace match = 1 in 2849
replace match = in 2852
replace match = 1 in 2853
replace match = 1 in 2858
replace match = in 2865
replace match = 1 in 2866
replace match = 1 in 2867
replace match = 1 in 2876
replace match = in 2876
replace match = 1 in 2877
replace match = 1 in 2878
replace match = 1 in 2879
replace match = 1 in 2883
replace match = 1 in 2890
replace match = 1 in 2891
replace match = 1 in 2892
replace match = 1 in 2893
replace match = 1 in 2894
replace match = 1 in 2895
replace match = 1 in 2896
replace match = 1 in 2898
replace match = 1 in 2900
replace match = 1 in 2902
replace match = 1 in 2906
replace match = 1 in 2907
replace match = 1 in 2908
replace match = 1 in 2914
replace match = 1 in 2920
replace match = 1 in 2921
replace match = 1 in 2923
replace match = 1 in 2930
replace match = 1 in 2932
replace match = 1 in 2935
replace match = 1 in 2941
replace match = 1 in 2945
replace match = 1 in 2946
replace match = 1 in 2947
replace match = 1 in 2948
replace match = 1 in 2953
replace match = 1 in 2954
replace match = 1 in 2955
replace match = 1 in 2958
replace match = 1 in 2959
replace match = 1 in 2960
replace match = 1 in 2961
replace match = 1 in 2971
replace match = 1 in 2975
replace match = 1 in 2981
replace match = 1 in 2982
replace match = in 2984
replace match = 1 in 2988
replace match = 1 in 2994
replace match = 1 in 2995
replace match = 1 in 2998
replace match = 1 in 3004
replace match = 1 in 3007
replace match = 1 in 3011
replace match = 1 in 3012
replace match = 1 in 3015
replace match = 1 in 3016
replace match = 1 in 3027
replace match = 1 in 3034
replace match = 1 in 3062
replace match = 1 in 3077
replace match = 1 in 3081
replace match = 1 in 3082
replace match = in 3082
replace match = 1 in 3085
replace match = 1 in 3093
replace match = in 3094
replace match = 1 in 3095
replace match = 1 in 3096
replace match = 1 in 3098
replace match = 1 in 3101
replace match = 1 in 3106
replace match = 1 in 3107
replace match = 1 in 3108
replace match = 1 in 3109
replace match = 1 in 3111
replace match = 1 in 3120
replace match = 1 in 3123
replace match = 1 in 3124
replace match = 1 in 3125
replace match = 1 in 3130
replace match = 1 in 3132
replace match = 1 in 3133
replace match = 1 in 3134
replace match = 1 in 3140
replace match = 1 in 3143
replace match = 1 in 3144
replace match = 1 in 3149
replace match = 1 in 3151
replace match = 1 in 3154
replace match = 1 in 3159
replace match = 1 in 3160
replace match = 1 in 3161
replace match = 1 in 3170
replace match = 1 in 3173
replace match = 1 in 3184
replace match = 1 in 3186
replace match = in 3194
replace match = 1 in 3195
replace match = 1 in 3198
replace match = 1 in 3201
replace match = 1 in 3203
replace match = 1 in 3205
replace match = 1 in 3206
replace match = 1 in 3207
replace match = 1 in 3210
replace match = 1 in 3212
replace match = 1 in 3213
replace match = 1 in 3214
replace match = 1 in 3216
replace match = 1 in 3217
replace match = 1 in 3221
replace match = 1 in 3223
replace match = 1 in 3224
replace match = 1 in 3226
replace match = in 3228
replace match = 1 in 3229
replace match = 1 in 3230
replace match = 1 in 3231
replace match = 1 in 3234
replace match = 1 in 3235
replace match = 1 in 3241
replace match = 1 in 3244
replace match = 1 in 3245
replace match = 1 in 3252
replace match = 1 in 3253
replace match = 1 in 3255
replace match = 1 in 3258
replace match = 1 in 3261
replace match = 1 in 3265
replace match = 1 in 3266
replace match = 1 in 3271
replace match = 1 in 3276
replace match = 1 in 3279
replace match = 1 in 3281
replace match = 1 in 3283
replace match = 1 in 3288
replace match = 1 in 3289
replace match = in 3289
replace match = 1 in 3295
replace match = 1 in 3301
replace match = 1 in 3302
replace match = 1 in 3310
replace match = 1 in 3317
replace match = 1 in 3320
replace match = 1 in 3324
replace match = 1 in 3335
replace match = 1 in 3342
replace match = in 3342
replace match = 1 in 3344
replace match = in 3345
replace match = 1 in 3356
replace match = 1 in 3359
replace match = 1 in 3364
replace match = 1 in 3371
replace match = 1 in 3378
replace match = 1 in 3419
replace match = 1 in 3446
replace match = 1 in 3447
replace match = 1 in 3457
replace match = 1 in 3472
replace match = in 3473
replace match = 1 in 3481
replace match = 1 in 3483
replace match = 1 in 3485
replace match = 1 in 3489
replace match = 1 in 3499
replace match = 1 in 3508
replace match = 1 in 3509
replace match = 1 in 3510
replace match = 1 in 3518
replace match = 1 in 3519
replace match = 1 in 3520
replace match = 1 in 3523
replace match = 1 in 3531
replace match = 1 in 3545
replace match = 1 in 3561
replace match = 1 in 3576
replace match = 1 in 3577
replace match = 1 in 3588
replace match = 1 in 3589
replace match = 1 in 3592
replace match = 1 in 3596
replace match = 1 in 3597
replace match = 1 in 3599
replace match = 1 in 3619
replace match = 1 in 3623
replace match = 1 in 3624
replace match = 1 in 3625
replace match = 1 in 3636
replace match = 1 in 3639
replace match = 1 in 3647
replace match = 1 in 3658
replace match = 1 in 3662
replace match = 1 in 3663
replace match = 1 in 3668
replace match = 1 in 3673
replace match = 1 in 3686
replace match = 1 in 3702
replace match = 1 in 3703
replace match = 0 in 3703
replace match = 1 in 3736
replace match = 1 in 3750
replace match = 1 in 3751
replace match = 1 in 3765
replace match = 1 in 3773
replace match = 1 in 3778
replace match = in 3781
replace match = 1 in 3784
replace match = 1 in 3786
replace match = 1 in 3789
replace match = 1 in 3794
replace match = 1 in 3829
replace match = 1 in 3830
replace match = 1 in 3837
replace match = 1 in 3850
replace match = 1 in 3859
replace match = 1 in 3864
replace match = 1 in 3887
replace match = 1 in 3916
replace match = 1 in 3918
replace match = 1 in 3925
replace match = 1 in 3928
replace match = 1 in 3929
replace match = 1 in 3940
replace match = 1 in 3958
replace match = 1 in 3961
replace match = 1 in 3962
replace match = 1 in 3966
replace match = 1 in 3967
replace match = 1 in 3968
replace match = 1 in 3971
replace match = 1 in 3972
replace match = 1 in 3998
replace match = 1 in 4001
replace match = 1 in 4002
replace match = 1 in 4020
replace match = 1 in 4026
replace match = 1 in 4032
replace match = 1 in 4034
replace match = 1 in 4036
replace match = 1 in 4039
replace match = 1 in 4043
replace match = 1 in 4044
replace match = 1 in 4049
replace match = in 4050
replace match = 1 in 4055
replace match = 1 in 4057
replace match = 1 in 4062
replace match = 1 in 4063
replace match = 1 in 4065
replace match = 1 in 4073
replace match = 1 in 4075
replace match = 1 in 4077
replace match = 1 in 4082
replace match = 1 in 4095
replace match = 1 in 4099
replace match = 1 in 4103
replace match = 1 in 4114
replace match = 1 in 4115
replace match = 1 in 4116
replace match = 1 in 4135
replace match = 1 in 4152
replace match = 1 in 4159
replace match = 1 in 4160
replace match = 1 in 4168
replace match = 1 in 4183
replace match = 1 in 4208
replace match = 1 in 4215
replace match = 1 in 4218
replace match = 1 in 4225
replace match = 1 in 4230
replace match = 1 in 4236
replace match = 1 in 4256
replace match = 1 in 4258
save "$filepath\linked_unions_to_MNEs_master_4000matches.dta", replace
clear 
use "$filepath\linked_unions_to_MNEs_master_4000matches.dta"
edit if contained==1
replace match = 1 in 4377
replace match = 1 in 4386
replace match = 1 in 4402
replace match = 1 in 4433
replace match = 1 in 4523
replace match = 1 in 4562
replace match = 1 in 4638
replace match = 1 in 4640
replace match = 1 in 4650
replace match = 1 in 4705
replace match = 1 in 4727
replace match = 1 in 5049
replace match = 1 in 5052
replace match = 1 in 5063
replace match = 1 in 5066
replace match = 1 in 5069
replace match = 1 in 5075
replace match = 1 in 5077
replace match = 1 in 5078
replace match = 1 in 5135
replace match = 1 in 5139
replace match = 1 in 5145
replace match = 1 in 5147
replace match = 1 in 5151
replace match = 1 in 5155
replace match = 1 in 5164
replace match = 1 in 5199
replace match = 1 in 5305
replace match = 1 in 5307
replace match = 1 in 5426
replace match = 1 in 5451
replace match = 1 in 5467
replace match = 1 in 5521
replace match = 1 in 5524
replace match = 1 in 5616
replace match = 1 in 5621
replace match = 1 in 5638
replace match = 1 in 5651
replace match = 1 in 5683
replace match = 1 in 5735
replace match = 1 in 5746
replace match = 1 in 5770
replace match = 1 in 5785
replace match = 1 in 5825
replace match = 1 in 5841
replace match = 1 in 5852
replace match = 1 in 5874
replace match = 1 in 5877
replace match = 1 in 5904
replace match = 1 in 5941
replace match = 1 in 5944
replace match = 1 in 5997
replace match = 1 in 6015
replace match = 1 in 6245
replace match = 1 in 6243
replace match = 1 in 6303
replace match = 1 in 6313
replace match = 1 in 6351
replace match = 1 in 6359
replace match = 1 in 6460
replace match = 1 in 6574
replace match = 1 in 6629
replace match = 1 in 6804
replace match = 1 in 6850
replace match = 1 in 6853
replace match = 1 in 6854
replace match = 1 in 6855
replace match = 1 in 6875
replace match = 1 in 6877
replace match = 1 in 6883
replace match = 1 in 6917
replace match = 1 in 6915
replace match = 1 in 6980
replace match = 1 in 6987
replace match = 1 in 7000
replace match = 1 in 7011
replace match = 1 in 7023
replace match = 1 in 7264
replace match = 1 in 7250
replace match = 1 in 7288
replace match = 1 in 7456
replace match = 1 in 7493
replace match = 1 in 7544
replace match = 1 in 7547
replace match = 1 in 7597
replace match = 1 in 7616
replace match = 1 in 7671
replace match = 1 in 7688
replace match = 1 in 7696
replace match = 1 in 7768
replace match = . if myscore==.
save "$filepath\linked_unions_to_MNEs_master_4000matches.dta"
clear
set more off 
use "$filepath\linked_unions_to_MNEs_master_4000matches.dta"
gen length_1 = length(stn_name)
gen length_2 = length(Ustn_name)
gen length_max = max(length_1, length_2)
gen diff_pct = abs(length_1-length_2)/length_max
gsort -length_max diff_pct
edit if contained==1&match==.&myscore!=.
replace match = 1 in 2
replace match = 1 in 9
replace match = 1 in 371
replace match = 1 in 469
replace match = 1 in 694
replace match = 1 in 848
replace match = 1 in 968
replace match = 1 in 1188
replace match = 1 in 1191
replace match = 1 in 1193
replace match = 1 in 1204
replace match = 1 in 1329
replace match = 1 in 1348
replace match = 1 in 1454
replace match = 1 in 1496
replace match = 1 in 1506
replace match = 1 in 1520
replace match = 1 in 1675
replace match = 1 in 1781
replace match = 1 in 1790
replace match = 1 in 1811
replace match = 1 in 1832
replace match = 1 in 2188
replace match = 1 in 2198
replace match = 1 in 2227
replace match = 1 in 2582
replace match = 1 in 2606
replace match = 1 in 2655
replace match = 1 in 2661
replace match = 1 in 2662
replace match = 1 in 2663
replace match = 1 in 3192
replace match = 1 in 3273
replace match = 1 in 3291
replace match = 1 in 3331
replace match = 1 in 3333
replace match = 1 in 3830
replace match = 1 in 3920
replace match = 1 in 3959
replace match = 1 in 3976
replace match = 1 in 4521
replace match = 1 in 4570
replace match = 1 in 4654
replace match = 1 in 4661
replace match = 1 in 4782
replace match = 1 in 5701
replace match = 1 in 5707
replace match = 1 in 5726
replace match = 1 in 5732
replace match = 1 in 5750
replace match = 1 in 5760
replace match = 1 in 5784
replace match = 1 in 5790
replace match = 1 in 5821
replace match = 1 in 5822
replace match = 1 in 6899
replace match = 1 in 6901
replace match = 1 in 7660
replace match = 1 in 8006
replace match = 1 in 8029
replace match = 1 in 8153
replace match = 1 in 8161
replace match = 1 in 8257
replace match = 1 in 8262
replace match = 1 in 8270
replace match = 1 in 8279
replace match = 1 in 9611
replace match = 1 in 9637
replace match = 1 in 9641
replace match = 1 in 9690
replace match = 1 in 9736
replace match = 1 in 9745
replace match = 1 in 11329
replace match = 1 in 11336
replace match = 1 in 11372
replace match = 1 in 11378
replace match = 1 in 11379
replace match = 1 in 11380
replace match = 1 in 11411
replace match = 1 in 11442
replace match = 1 in 11459
replace match = 1 in 11473
replace match = 1 in 11480
replace match = 1 in 12482
replace match = 1 in 12888
replace match = 1 in 13141
replace match = 1 in 13152
replace match = 1 in 13160
replace match = 1 in 13161
replace match = 1 in 13165
replace match = 1 in 13192
replace match = 1 in 13211
replace match = 1 in 13224
replace match = 1 in 13294
replace match = 1 in 15222
replace match = 1 in 15280
replace match = 1 in 17527
replace match = 1 in 17557
replace match = 1 in 18148
replace match = 1 in 18424
replace match = 1 in 18629
replace match = 1 in 18658
replace match = 1 in 18670
replace match = 1 in 18673
replace match = 1 in 19006
replace match = 1 in 20507
replace match = 1 in 21322
replace match = 1 in 21510
replace match = 1 in 21620
replace match = 1 in 21670
replace match = 1 in 23941
replace match = 1 in 23962
replace match = 1 in 24061
replace match = 1 in 24101
replace match = 1 in 24129
replace match = 1 in 24165
replace match = 1 in 24166
replace match = 1 in 24171
replace match = 1 in 24179
replace match = 1 in 24228
replace match = 1 in 26710
replace match = 1 in 26843
replace match = 1 in 26960
replace match = 1 in 29415
replace match = 1 in 29565
replace match = 1 in 29607
replace match = 1 in 29826
replace match = 1 in 32222
gsort -myscore diff_pct
edit if contained==1 & match==.
replace match = 1 in 4364
edit if match==.
replace match = 1 in 2936
replace match = 1 in 4338
replace match = 1 in 4417
replace match = in 4418
replace match = 1 in 4419
replace match = 1 in 4421
replace match = 1 in 4426
replace match = 1 in 4441
replace match = 1 in 4464
replace match = 1 in 4554
replace match = 1 in 4603
replace match = 1 in 4660
replace match = 1 in 4662
replace match = 1 in 4663
replace match = 1 in 4701
replace match = 1 in 4704
replace match = 1 in 5036
replace match = 1 in 5037
replace match = in 46958
save "$filepath\linked_unions_to_MNEs_master_3000matches.dta"
keep if match==1
sort employer_id
clear
drop _merge
sort employer_id
save "$filepath\linked_unions_to_MNEs_master_3000matched.dta", replace

**CREATE LINKED ELECTIONS_MNEs DB
** START WITH UNIONS DB
clear
set more off
use "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\merged_elections_1961_2009_tags_2.dta"
sort employer_id
*MERGE WITH MATCHED UNIONS-MNES
merge m:m employer_id using "$filepath\linked_unions_to_MNEs_master_3000matched.dta"
keep if _merge==3
drop _merge
rename year_election year
sort us_id year
gen vote_share = votes_for/(votes_for + votes_against)
drop if vote_share==.
replace name=trim(name)
compress name
sort us_id year 
save "$filepath\unions_with_us_ids.dta", replace

************************************
************************************
**MERGE 1983-2013 PARENT CO. DATA ACROSS MNE SURVEYS

**LOADS 1995-2013, except 1999, 2004, and 2009
clear
set more off
odbc load if ((version=="r" & period_year>=1983)|(version=="p" & period_year>=2013)), table("be11_reporter") dsn("sqlprodb_2008") dialog(required)
keep us_id foreign_id period_year naics_id sic_ind emp emp_compen net_income
save "$filepath\base_1995_2013.dta", replace
**RESHAPE LONG and create period_year
*1983 db
clear
odbc load, table("11A83RF") dsn("be11_1983")
rename PAR_ID_6 us_id
reshape long Sales_ Industry_ Employee_Compensation_ Employment_ Net_income_, i(us_id) j(period_year)
rename Industry_ sic_ind
rename Employment_ emp
rename Employee_Compensation_ emp_compen
rename Net_income_ net_income
rename Sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_83.dta", replace
*1984 db
clear
odbc load, table("11A84RF") dsn("be11_1984")
rename PAR_ID_6 us_id
reshape long Sales_ Industry_ Employee_Compensation_ Employment_ Net_income_, i(us_id) j(period_year)
rename Industry_ sic_ind
rename Employment_ emp
rename Employee_Compensation_ emp_compen
rename Net_income_ net_income
rename Sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_84.dta", replace
*1985 db
clear
odbc load, table("11A85RF") dsn("be11_1985")
rename PAR_ID_6 us_id
reshape long Sales_ Industry_ Employee_Compensation_ Employment_ Net_income_, i(us_id) j(period_year)
rename Industry_ sic_ind
rename Employment_ emp
rename Employee_Compensation_ emp_compen
rename Net_income_ net_income
rename Sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_85.dta", replace
*1986 db
clear
odbc load, table("11A86RF") dsn("be11_1986")
rename PAR_ID_6 us_id
reshape long Sales_ Industry_ Employee_Compensation_ Employment_ Net_income_, i(us_id) j(period_year)
rename Industry_ sic_ind
rename Employment_ emp
rename Employee_Compensation_ emp_compen
rename Net_income_ net_income
rename Sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_86.dta", replace
*1987 db
clear
odbc load, table("11A87RF") dsn("be11_1987")
rename PAR_ID_6 us_id
reshape long Sales_ Industry_ Employee_Compensation_ Employment_ Net_income_, i(us_id) j(period_year)
rename Industry_ sic_ind
rename Employment_ emp
rename Employee_Compensation_ emp_compen
rename Net_income_ net_income
rename Sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_87.dta", replace
*1988 db
clear
odbc load, table("11A88RF") dsn("be11_1988")
rename PAR_ID_6 us_id
reshape long Sales_ Industry_ Employee_Compensation_ Employment_ Net_income_, i(us_id) j(period_year)
rename Industry_ sic_ind
rename Employment_ emp
rename Employee_Compensation_ emp_compen
rename Net_income_ net_income
rename Sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_88.dta", replace
*1989 db
clear
odbc load, table("11A89RF") dsn("be11_1989")
rename ind_sic sic_ind
gen period_year=1989
keep us_id period_year sic_ind sales emp emp_compen net_income
sort us_id
save "$filepath\par_89.dta", replace
clear
use "$filepath\89_par_for_impute.dta"
gen period_year =1989
drop ind
sort us_id
save "$filepath\89_par_for_impute_merge.dta", replace
clear
use "$filepath\par_89.dta"
merge 1:1 us_id period_year using "$filepath\89_par_for_impute_merge.dta"
keep if _merge==3
drop _merge
sort us_id
save "$filepath\par_89_plus_gp.dta", replace
*1990 db
clear
odbc load, table("11A90RF") dsn("be11_1990")
rename PAR_ID_6 us_id
reshape long Sales_ Industry_ Employee_Compensation_ Employment_ Net_income_, i(us_id) j(period_year)
rename Industry_ sic_ind
rename Employment_ emp
rename Employee_Compensation_ emp_compen
rename Net_income_ net_income
rename Sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_90.dta", replace
*1991 db
clear
odbc load, table("11A91RF") dsn("be11_1991")
rename PAR_ID_6 us_id
reshape long Sales_ Industry_ Employee_Compensation_ Employment_ Net_income_, i(us_id) j(period_year)
rename Industry_ sic_ind
rename Employment_ emp
rename Employee_Compensation_ emp_compen
rename Net_income_ net_income
rename Sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_91.dta", replace
*1992 db
clear
odbc load, table("11A92RF") dsn("be11_1992")
rename PAR_ID_6 us_id
reshape long Sales_ Industry_ Employee_Compensation_ Employment_ Net_income_, i(us_id) j(period_year)
rename Industry_ sic_ind
rename Employment_ emp
rename Employee_Compensation_ emp_compen
rename Net_income_ net_income
rename Sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_92.dta", replace
*1993 db
clear
odbc load, table("11A93RF") dsn("be11_1993")
rename PAR_ID_6 us_id
reshape long sales_ ind_ emp_ emp_compen_ net_income_, i(us_id) j(period_year)
rename ind_ sic_ind
rename emp_ emp
rename emp_compen_ emp_compen 
rename net_income_ net_income
rename sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
save "$filepath\par_93.dta", replace
*1994 db
clear
odbc load, table("11A94RF") dsn("be11_1994")
rename PAR_ID_6 us_id
reshape long sales_ ind_ emp_ emp_compen_ net_income_, i(us_id) j(period_year)
rename ind_ sic_ind
rename emp_ emp
rename emp_compen_ emp_compen
rename net_income_ net_income
rename sales_ sales
keep us_id period_year sic_ind sales emp emp_compen net_income
replace period_year = period_year+1900
sort us_id
save "$filepath\par_94.dta", replace
clear
odbc load, table("11A94RF5") dsn("be11_1994")
rename ind_94 ind_sic
gen period_year=1994
rename *_94 *_PAR
drop ind_sic
sort us_id
save "$filepath\89_par_for_impute_merge.dta", replace
clear
use "$filepath\par_94.dta"
merge 1:1 us_id period_year using "$filepath\89_par_for_impute_merge.dta"
drop _merge
sort us_id
save "$filepath\par_94_plus_gp.dta", replace

**LOADS 1999, 2004, AND 2009
clear
odbc load if (version=="r" & [period_year==1999|period_year==2004|period_year==2009]), table("be10_rep_misc") dsn("sqlprodb_2008") dialog(required)
destring emp, replace
keep if version=="r"
keep us_id foreign_id period_year emp emp_compen
sort us_id period_year
save "$filepath\par_99_04_09.dta", replace

**LOAD IN NET_INCOME FOR 1999, 2004, and 2009
*1999
clear
odbc load, table("11A99RF5") dsn("be11_1999")
gen period_year=1999
replace us_id = trim(us_id)
keep us_id period_year net_income
sort us_id period_year
save "$filepath\par_99_net_income.dta", replace

*2004
clear
odbc load, table("11a04rf5") dsn("be11_2004")
gen period_year=2004
keep us_id period_year net_income
sort us_id period_year
save "$filepath\par_04_net_income.dta", replace

*2009
clear
odbc load if (version=="r" & period_year==2009), table("be10_rep_inc_bal") dsn("sqlprodb_2008") dialog(required)
keep us_id period_year net_income
destring net_income, replace
replace us_id = trim(us_id)
sort us_id period_year
save "$filepath\par_09_net_income.dta", replace

**MERGE 99,04,and 09 with net_income
clear
use "$filepath\par_99_04_09.dta", replace
replace us_id = trim(us_id)
merge 1:1 us_id period_year using "$filepath\par_99_net_income.dta", update 
drop _merge
sort us_id period_year
merge 1:1 us_id period_year using "$filepath\par_04_net_income.dta", update 
drop _merge
sort us_id period_year
merge 1:1 us_id period_year using "$filepath\par_09_net_income.dta", update 
drop _merge
sort us_id period_year
save "$filepath\par_99_04_09_inc.dta", replace

**NOW MERGE ACROSS ALL YEARS
clear
use "$filepath\base_1995_2013.dta"
sort us_id period_year
append using "$filepath\par_83.dta"
append using "$filepath\par_84.dta"
append using "$filepath\par_85.dta"
append using "$filepath\par_86.dta"
append using "$filepath\par_87.dta"
append using "$filepath\par_88.dta"
append using "$filepath\par_89_plus_gp.dta"
append using "$filepath\par_90.dta"
append using "$filepath\par_91.dta"
append using "$filepath\par_92.dta"
append using "$filepath\par_93.dta"
append using "$filepath\par_94_plus_gp.dta"
append using "$filepath\par_99_04_09_inc.dta"
sort us_id period_year
rename period_year year
save "$filepath\par_1983_2013.dta", replace

**NAICS->SIC CROSSWALK
clear
insheet using "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\naics_sic.csv"
rename naics_ind naics_id
sort naics_id
save "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\naics_sic.dta", replace

*****************************
***START HERE FOR MAIN SAMPLE
*****************************
*****************************
**NOW MERGE PARENT DATA WITH UNIONS
*****************************

*BEGIN WITH MNE SURVEY
clear
set more off
use "$filepath\par_1983_2013.dta"
destring us_id, replace
duplicates drop us_id year, force
sort us_id year
drop if year>2009
xtset us_id year
by us_id, sort: gen count=_N
sort us_id year
summ count if us_id!=us_id[_n+1], detail 
***
*MERGE WITH LINKED MNE-ELECTION DB
merge 1:m us_id year using "$filepath\unions_with_us_ids.dta"

sort us_id year
*tab year if _merge==3
*browse us_id year type votes_for vote_share outcome numberelig emp emp_compen naics_id sic_ind net_income
replace outcome = "WON" if votes_for>votes_against & year>=2009
replace outcome = "LOST" if votes_for<=votes_against & year>=2009 & votes_for!=.
gen win=1 if outcome=="WON" & type=="RC"
replace win=0 if outcome=="LOST" & type=="RC"
replace win=0 if outcome=="WON" & type=="RD"
replace win=1 if outcome=="LOST" & type=="RD"
keep if year>=1983
keep if type==""|type=="RC"|type=="RD"
sort us_id year

sort naics_id
drop _merge
merge m:1 naics_id using "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\naics_sic.dta"

sort us_id year
replace sic_ind =sic_code if naics_id!=.&naics_id!=0&[sic_ind==0|sic_ind==.]
*replace win = win[_n-1] if win[_n-1]!=.&us_id==us_id[_n-1]
browse us_id year type votes_for vote_share outcome numberelig emp emp_compen win sic_ind

keep if year<=2009
gen num_votes = votes_for+votes_against
tab type if num_votes>=20 & num_votes!=. &emp_compen!=. & emp_compen[_n+1]!=. & emp_compen[_n-1]!=. & us_id==us_id[_n+1]&us_id==us_id[_n-1] & year[_n+1]-year==1& year[_n-1]-year==-1 

by us_id, sort: gen Femp = emp[_n+1]
by us_id, sort: gen Lemp = emp[_n-1]
gen diff_emp = Femp-Lemp
summ diff_emp if win==0
summ win
gen ln_Femp = ln(Femp)
gen ln_Lemp = ln(Lemp)
gen ln_diff = ln_Femp-ln_Lemp
gen ln_emp = ln(emp)
by us_id, sort: gen ln_diff_emp = (ln_emp[_n+1]-ln_emp[_n-1])
summ ln_diff_emp if win==1 & year[_n+1]-year==1& year[_n-1]-year==-1
summ ln_diff_emp if win==0 & year[_n+1]-year==1& year[_n-1]-year==-1
by us_id, sort: gen avg_fut_emp = (emp[_n+1]+emp[_n+2])/2
by us_id, sort: gen avg_pre_emp = (emp[_n-1]+emp[_n-2])/2
by us_id, sort: gen ln_avg_diff_emp = ln(avg_fut_emp)-ln(avg_pre_emp)

summ ln_avg_diff_emp if win==1 & abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1
summ ln_avg_diff_emp if win==0 & abs(vote_share-.5)<=.2  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1

summ ln_avg_diff_emp if win==1 & abs(vote_share-.5)<=.25 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1
summ ln_avg_diff_emp if win==0 & abs(vote_share-.5)<=.25  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1

summ ln_diff_emp if win==. &year[_n+1]-year==1& year[_n-1]-year==-1

encode unit, gen(unitcd)
gen election=1 if win!=.

**GENERATE RTW VARIABLE**
gen rtw=.
global non_right "AK CA CO CT DE DC HI IL IN MI KY MD MA ME MN MO NH NJ NM NY OH OR PA RI VT WA WV WI"
global right "AL AZ AR FL GA ID IA KS LA MS MT NE NC ND NV OK SC SD TN TX UT VA WY"
foreach st in $right {
	replace rtw=1 if employerstate=="`st'"
}
foreach st in $non_right {
	replace rtw=0 if employerstate=="`st'"
}
replace rtw=0 if employerstate=="OK" & year<=2001
replace rtw=1 if employerstate=="IN" & year>=2012
replace rtw=1 if employerstate=="MI" & year>=2012
tab rtw

*ADJUST FOR INFLATION (base year= 2016)
gen cpi = 37.875 if year==1981
replace cpi = 40.208 if year==1982
replace cpi = 41.5 if year==1983
replace cpi = 43.29 if year==1984
replace cpi = 44.83 if year==1985
replace cpi = 45.67 if year==1986
replace cpi = 47.33 if year==1987
replace cpi = 49.29 if year==1988
replace cpi = 51.67 if year==1989
replace cpi = 54.46 if year==1990
replace cpi = 56.75 if year==1991
replace cpi = 58.46 if year==1992
replace cpi = 60.21 if year==1993
replace cpi = 61.75 if year==1994
replace cpi = 63.5 if year==1995
replace cpi = 65.375 if year==1996
replace cpi = 66.875 if year==1997
replace cpi = 67.92 if year==1998
replace cpi = 69.42 if year==1999
replace cpi = 71.75 if year==2000
replace cpi = 73.792 if year==2001
replace cpi = 74.96 if year==2002
replace cpi = 76.67 if year==2003
replace cpi = 78.71 if year==2004
replace cpi = 81.375 if year==2005
replace cpi = 84 if year==2006
replace cpi = 86.375 if year==2007
replace cpi = 89.71 if year==2008
replace cpi = 89.375 if year==2009
replace cpi = 90.875 if year==2010
replace cpi = 93.71 if year==2011
replace cpi = 95.67 if year==2012
replace cpi = 97.08 if year==2013
replace cpi = 98.625 if year==2014
replace cpi = 98.75 if year==2015
replace cpi = 100 if year==2016
*GENERATE DEFLATED COMPENSATION MEASURES*
gen wage = emp_compen/emp
gen ln_wage = ln(emp_compen/emp)
gen p = cpi/100
gen wage_def = wage/p
gen ln_wage_def = ln(wage_def)
sort us_id year
*GENERATE DELTA COMPENSATION
by us_id, sort: gen ln_diff_wage = (ln_wage[_n+1]-ln_wage[_n-1])
by us_id, sort: gen ln_diff_wage_def = (ln_wage_def[_n+1]-ln_wage_def[_n-1])
gen fraction_employees = numbereligible/emp
by us_id, sort: gen ln_diff_wage_pre = (ln_wage[_n-1]-ln_wage[_n-2])
by us_id, sort: gen ln_diff_wage_pre_def = (ln_wage_def[_n-1]-ln_wage_def[_n-2])
by us_id, sort: gen Fln_wage =ln_wage[_n+1]
by us_id, sort: gen F2ln_wage =ln_wage[_n+2]
by us_id, sort: gen F3ln_wage =ln_wage[_n+3]
by us_id, sort: gen F4ln_wage =ln_wage[_n+4]
by us_id, sort: gen F5ln_wage =ln_wage[_n+5]
by us_id, sort: gen Lln_wage =ln_wage[_n-1]
by us_id, sort: gen L2ln_wage =ln_wage[_n-2]
by us_id, sort: gen L3ln_wage =ln_wage[_n-3]
by us_id, sort: gen L4ln_wage =ln_wage[_n-4]
by us_id, sort: gen L5ln_wage =ln_wage[_n-5]
by us_id, sort: gen Fln_wage_def =ln_wage_def[_n+1]
by us_id, sort: gen F2ln_wage_def =ln_wage_def[_n+2]
by us_id, sort: gen F3ln_wage_def =ln_wage_def[_n+3]
by us_id, sort: gen F4ln_wage_def =ln_wage_def[_n+4]
by us_id, sort: gen F5ln_wage_def =ln_wage_def[_n+5]
by us_id, sort: gen Lln_wage_def =ln_wage_def[_n-1]
by us_id, sort: gen L2ln_wage_def =ln_wage_def[_n-2]
by us_id, sort: gen L3ln_wage_def =ln_wage_def[_n-3]
by us_id, sort: gen L4ln_wage_def =ln_wage_def[_n-4]
by us_id, sort: gen L5ln_wage_def =ln_wage_def[_n-5]
sort us_id year
by us_id, sort: gen Lwage_def = wage_def[_n-1]
by us_id, sort: gen Fwage_def = wage_def[_n+1]


***********************************************
*SUMM STAT TABLES
*TABLE 1: NLRB ELECTION SUMMARY STATS (Add extra columns for CPUstat)
*win%, number of elections, number of votes
*win %
summ win if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_def!=.
gen share_margin = vote_share if type=="RC"
*replace share_margin = 1-vote_share if type=="RD"
*number of voters
summ share_margin if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_def!=.
summ share_margin if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &win==1 &ln_diff_wage_def!=.
summ share_margin if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &win==0 &ln_diff_wage_def!=.

summ num_votes if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_def!=.
summ num_votes if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &win==1 &ln_diff_wage_def!=.
summ num_votes if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &win==0 &ln_diff_wage_def!=.

summ num_votes if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1, detail 
summ num_votes if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &win==1, detail
summ num_votes if num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &win==0, detail

summ num_votes if _merge==3 &win!=.
summ num_votes if _merge==3 &win==1
summ num_votes if _merge==3 &win==0
**Include footnote about matching procedure and match rate.

*TABLE 2: AVG PRE and POST-ELECTION FIRM CHARACTERISTICS (Add extra
*column for compustat)
*number of employees and average worker compensation
summ Lwage_def if win!=. & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5
summ Fwage_def if win!=. & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5

summ Lwage_def if win==0 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5
summ Fwage_def if win==0 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5

summ Lwage_def if win==1  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.5
summ Fwage_def if win==1  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.5

summ Lemp if year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5
summ Femp if year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5

summ Lemp if win==0 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5
summ Femp if win==0 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5

summ Lemp if win==1 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5
summ Femp if win==1 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5

*****************************************************************
***LINE GRAPHS: AVG COMPENSATION FOR WINNERS AND LOSERS***
**FIGURE 2(a) (VICTORY MARGIN <=20%)
*ELECTION LOSERS
summ L5ln_wage if win==0 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 
summ L4ln_wage if win==0 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 
summ L3ln_wage if win==0 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 
summ L2ln_wage if win==0 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 
summ Lln_wage if win==0 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  
summ ln_wage if win==0 & abs(vote_share-.5)<=.2 &num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1
summ Fln_wage if win==0 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  
summ F2ln_wage if win==0  &abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
summ F3ln_wage if win==0  &abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
summ F4ln_wage if win==0  &abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
summ F5ln_wage if win==0  &abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
*ELECTION WINNERS
summ L5ln_wage if win==1 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 
summ L4ln_wage if win==1 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 
summ L3ln_wage if win==1 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 
summ L2ln_wage if win==1 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 
summ Lln_wage if win==1 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  
summ ln_wage if win==1 & abs(vote_share-.5)<=.2 &num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1
summ Fln_wage if win==1 &abs(vote_share-.5)<=.2 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  
summ F2ln_wage if win==1  &abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
summ F3ln_wage if win==1  &abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
summ F4ln_wage if win==1  &abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
summ F5ln_wage if win==1  &abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 

**FIGURE 2(b) (VICTORY MARGIN <=15%)
*ELECTION LOSERS
summ L5ln_wage if win==0 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L4ln_wage if win==0 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L3ln_wage if win==0 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L2ln_wage if win==0 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ Lln_wage if win==0 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ ln_wage if win==0 & abs(vote_share-.5)<=.15 &num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage_pre_def<3 
summ Fln_wage if win==0 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F2ln_wage if win==0  &abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ F3ln_wage if win==0  &abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ F4ln_wage if win==0  &abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ F5ln_wage if win==0  &abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
*ELECTION WINNERS
summ L5ln_wage if win==1 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L4ln_wage if win==1 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L3ln_wage if win==1 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L2ln_wage if win==1 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ Lln_wage if win==1 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ ln_wage if win==1 & abs(vote_share-.5)<=.15 &num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage_pre_def<3 
summ Fln_wage if win==1 &abs(vote_share-.5)<=.15 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F2ln_wage if win==1  &abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ F3ln_wage if win==1  &abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ F4ln_wage if win==1  &abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ F5ln_wage if win==1  &abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 

*DEFLATED
**FIGURE 2(a)
*ELECTION WINNERS
summ L5ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L4ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L3ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L2ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ Lln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage_pre_def<3 
summ ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ Fln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F2ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==1  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F3ln_wage_def if F5ln_wage_def!=. & abs(vote_share-.5)<=.2 &win==1  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F4ln_wage_def if F5ln_wage_def!=. & abs(vote_share-.5)<=.2&win==1  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F5ln_wage_def if abs(vote_share-.5)<=.2 &win==1  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
*ELECTIO  LOSERS
summ L5ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L4ln_wage_def if L5ln_wage_def!=. &F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L3ln_wage_def if L5ln_wage_def!=. &F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L2ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ Lln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage_pre_def<3 
summ ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ Fln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F2ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F3ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F4ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F5ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.2 &win==0  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 

*FIGURE 2(b)
*ELECTION WINNERS
summ L5ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L4ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L3ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L2ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ Lln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage_pre_def<3 
summ ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ Fln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==1 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F2ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==1  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F3ln_wage_def if F5ln_wage_def!=. & abs(vote_share-.5)<=.15 &win==1  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F4ln_wage_def if F5ln_wage_def!=. & abs(vote_share-.5)<=.15&win==1  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F5ln_wage_def if abs(vote_share-.5)<=.15 &win==1  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
*ELECTION LOSERS
summ L5ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L4ln_wage_def if L5ln_wage_def!=. &F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L3ln_wage_def if L5ln_wage_def!=. &F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ L2ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage_pre_def<3 
summ Lln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage_pre_def<3 
summ ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ Fln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0 & num_votes>=20  & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F2ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F3ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F4ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 
summ F5ln_wage_def if F5ln_wage_def!=. &abs(vote_share-.5)<=.15 &win==0  & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1  &ln_diff_wage_pre_def<3 


*AVERAGE COMPENSATION CHANGE (2-YEAR AVERAGES)
by us_id, sort: gen avg_fut_wage = (wage[_n+1]+wage[_n+2])/2
by us_id, sort: gen avg_pre_wage = (wage[_n-1]+wage[_n-2])/2
by us_id, sort: gen ln_avg_diff_wage = ln(avg_fut_wage)-ln(avg_pre_wage)
*DEFLATED
by us_id, sort: gen avg_fut_wage_def = (wage_def[_n+1]+wage_def[_n+2])/2
by us_id, sort: gen avg_pre_wage_def = (wage_def[_n-1]+wage_def[_n-2])/2
by us_id, sort: gen ln_avg_diff_wage_def = ln(avg_fut_wage_def)-ln(avg_pre_wage_def)

summ ln_avg_diff_wage_def if win==0&abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1
summ ln_avg_diff_wage_def if win==1&abs(vote_share-.5)<=.2 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1
summ ln_avg_diff_wage_def if win==0&abs(vote_share-.5)<=.25 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_avg_diff_wage_def if win==1&abs(vote_share-.5)<=.25 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1
summ ln_avg_diff_wage_def if win==0&abs(vote_share-.5)<=.3 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_avg_diff_wage_def if win==1&abs(vote_share-.5)<=.3 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1
summ ln_avg_diff_wage_def if win==0&abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_avg_diff_wage_def if win==1&abs(vote_share-.5)<=.15 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1

*DEFLATED, .05 bins
*Figure 3(a)
summ ln_diff_wage_def if share_margin>=0&share_margin<=.05&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.05&share_margin<=.1&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.1&share_margin<=.15&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.15&share_margin<=.2&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.2&share_margin<=.25&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.25&share_margin<=.3&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.3&share_margin<=.35&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.35&share_margin<=.4&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.4&share_margin<=.45&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.45&share_margin<=.5&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.5&share_margin<=.55&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.55&share_margin<=.6&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.6&share_margin<=.65&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.65&share_margin<=.7&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.7&share_margin<=.75&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.75&share_margin<=.8&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.8&share_margin<=.85&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.85&share_margin<=.9&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.9&share_margin<=.95&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_def if share_margin>.95&share_margin<=1&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
*Figure 3(b)
summ ln_diff_wage_pre_def if share_margin>=0&share_margin<=.05&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.05&share_margin<=.1&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.1&share_margin<=.15&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.15&share_margin<=.2&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.2&share_margin<=.25&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.25&share_margin<=.3&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.3&share_margin<=.35&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.35&share_margin<=.4&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.4&share_margin<=.45&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.45&share_margin<=.5&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.5&share_margin<=.55&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage_pre_def<3 
summ ln_diff_wage_pre_def if share_margin>.55&share_margin<=.6&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.6&share_margin<=.65&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.65&share_margin<=.7&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.7&share_margin<=.75&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.75&share_margin<=.8&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.8&share_margin<=.85&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.85&share_margin<=.9&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.9&share_margin<=.95&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage_pre_def if share_margin>.95&share_margin<=1&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 


*Create bins FOR VOTESHARE RD GRAPH
*1/20
sort us_id year
gen bin=1 if share_margin>=0&share_margin<=.05&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage!=.
replace bin=2 if share_margin>.05&share_margin<=.1&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage!=.
replace bin=3 if share_margin>.1&share_margin<=.15&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=4 if share_margin>.15&share_margin<=.2&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage!=.
replace bin=5 if share_margin>.2&share_margin<=.25&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=6 if share_margin>.25&share_margin<=.3&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=7 if share_margin>.3&share_margin<=.35&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=8 if share_margin>.35&share_margin<=.4&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=9 if share_margin>.4&share_margin<=.45&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=10 if share_margin>.45&share_margin<=.5&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=11 if share_margin>.5&share_margin<=.55&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage!=.
replace bin=12 if share_margin>.55&share_margin<=.6&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=13 if share_margin>.6&share_margin<=.65&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 &ln_diff_wage!=.
replace bin=14 if share_margin>.65&share_margin<=.7&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=15 if share_margin>.7&share_margin<=.75&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=16 if share_margin>.75&share_margin<=.8&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=17 if share_margin>.8&share_margin<=.85&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=18 if share_margin>.85&share_margin<=.9&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=19 if share_margin>.9&share_margin<=.95&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.
replace bin=20 if share_margin>.95&share_margin<=1&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&ln_diff_wage!=.

sort bin
by bin, sort: egen tot_diff_wage = sum(ln_diff_wage) if number_of_votes>=20
by bin, sort: gen avg_diff_wage = tot_diff_wage/_N if number_of_votes>=20
by bin, sort: gen N = _N if number_of_votes>=20
scatter avg_diff_wage bin if bin!=10, xline(10)
sort bin
by bin, sort: egen tot_diff_wage_def = sum(ln_diff_wage_def) if number_of_votes>=20
by bin, sort: gen avg_diff_wage_def = tot_diff_wage_def/_N if number_of_votes>=20
tab bin avg_diff_wage_def
summ ln_diff_wage_def if bin==20

*pre-plot
sort bin
by bin, sort: egen tot_diff_wage_pre = sum(ln_diff_wage_pre) if number_of_votes>=20
by bin, sort: gen avg_diff_wage_pre = tot_diff_wage_pre/_N if number_of_votes>=20
by bin, sort: gen N_pre = _N if number_of_votes>=20
scatter avg_diff_wage_pre bin if bin!=10, xline(10)

*BY VOTE MARGIN
*FIGURE 4(a)
*margin of victory (in votes)
gen margin_of_victory = votes_for - votes_against if type=="RC"
*replace margin_of_victory = votes_against - votes_for if type=="RD"
sort us_id year
summ ln_diff_wage if margin_of_victory==-30&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-29&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-28&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-27&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-26&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-25&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-24&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-23&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-22&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-21&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-20&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-19&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-18&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-17&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-16&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-15&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-14&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-13&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-12&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-11&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-10&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-9&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-8&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-7&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-6&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-5&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-4&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-3&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-2&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==-1&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==0&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==1&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==2&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==3&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==4&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==5&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==6&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==7&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==8&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==9&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==10&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==11&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==12&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==13&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==14&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==15&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==16&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==17&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==18&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==19&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==20&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==21&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==22&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==23&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==24&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==25&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==26&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==27&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==28&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==29&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 
summ ln_diff_wage if margin_of_victory==30&number_of_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1 

summ ln_diff_wage_pre if margin_of_victory==-30&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-29&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-28&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-27&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-26&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-25&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-24&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-23&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-22&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-21&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-20&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-19&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-18&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-17&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-16&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-15&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-14&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-13&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-12&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-11&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-10&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-9&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-8&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-7&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-6&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-5&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-4&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-3&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==-2&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==-1&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==0&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==1&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==2&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==3&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==4&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==5&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==6&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==7&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==8&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==9&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==10&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==11&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==12&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==13&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==14&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==15&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==16&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==17&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==18&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==19&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==20&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==21&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==22&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==23&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==24&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==25&number_of_votes>=20
summ ln_diff_wage_pre if margin_of_victory==26&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==27&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==28&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==29&number_of_votes>=20 
summ ln_diff_wage_pre if margin_of_victory==30&number_of_votes>=20

*DEFLATED
sort us_id year
summ ln_diff_wage if margin_of_victory==-30&number_of_votes>=20 
summ ln_diff_wage if margin_of_victory==-29&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-28&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-27&number_of_votes>=20 
summ ln_diff_wage if margin_of_victory==-26&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-25&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-24&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-23&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-22&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-21&number_of_votes>=20 
summ ln_diff_wage if margin_of_victory==-20&number_of_votes>=20 
summ ln_diff_wage if margin_of_victory==-19&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-18&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-17&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==-16&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-15&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-14&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-13&number_of_votes>=20 
summ ln_diff_wage_def if margin_of_victory==-12&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-11&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-10&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-9&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-8&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-7&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-6&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-5&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-4&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-3&number_of_votes>=20 
summ ln_diff_wage_def if margin_of_victory==-2&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==-1&number_of_votes>=20 
summ ln_diff_wage_def if margin_of_victory==0&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==1&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==2&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==3&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==4&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==5&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==6&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==7&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==8&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==9&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==10&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==11&number_of_votes>=20 
summ ln_diff_wage_def if margin_of_victory==12&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==13&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==14&number_of_votes>=20
summ ln_diff_wage_def if margin_of_victory==15&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==16&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==17&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==18&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==19&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==20&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==21&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==22&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==23&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==24&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==25&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==26&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==27&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==28&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==29&number_of_votes>=20
summ ln_diff_wage if margin_of_victory==30&number_of_votes>=20


**LEFT OFF HERE FOR CLEANING
*RD REGRESSION SETUP
gen z = share_margin-.50001
gen zp = .5-share_margin
rd ln_diff_wage_def z if  num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1, gr 

rdcv ln_diff_wage_def z if  num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1, threshold(0) ikbwidth

rdcv ln_diff_wage_def z if  num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1, threshold(0) ikbwidth degree(2)

rdbwselect ln_avg_diff_wage_def zp if  num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1, all

scatter ln_avg_diff_wage_def z if  num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_avg_diff_wage_def)<2& ln_diff_wage_pre<3

**HISTOGRAMS**
**Figure 1(a)
hist vote_share if num_votes>=20, width(.050000001) addplot(pci 0 .5 2.1 .5) legend(off) title("Union Vote Share Density") subtitle("Multinational Enterprise Sample") xtitle("union vote share")
**Figure 5 (Appendix D)
hist vote_share if num_votes>=20, width(.020000001) addplot(pci 0 .5 2.1 .5) legend(off) title("Union Vote Share Density") subtitle("Multinational Enterprise Sample") xtitle("union vote share")
**Figure 6 (Appendix D)
hist margin if num_votes>=20 &abs(margin)<=30, width(1.00001) xlabel(-30(10)30) addplot(pci 0 0 .032 0) legend(off) title("Union Votes Margin Density") subtitle("Multinational Enterprise Sample") xtitle("votes margin")
**Figure 12 (Appendix D)
hist vote_share if tot_elec<=1 & num_votes>=20, width(.050000001) addplot(pci 0 .5 2.1 .5) legend(off) title("Union Vote Share Density (First Elections Only)") subtitle("Multinational Enterprise Sample") xtitle("union vote share")

drop Z
gen Z = vote_share-.5
DCdensity vote_share if num_votes>=20& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", breakpoint(.5) generate(Xj Yj r0 fhat se_fhat) graphname(DCdensity_example.eps) 
DCdensity margin if num_votes>=20&abs(margin)<=30, breakpoint(0) generate(Xj Yj r0 fhat se_fhat) graphname(DCdensity_example.eps) 

**Frandsen RD test for discrete running variable
rddisttestk vote_share if ln_diff_wage_def!=. & win!=. &  num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", threshold(0.5) k(0.02)
rddisttestk vote_share if ln_diff_wage_def!=. & win!=. &  num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", threshold(0.5) k(0.05)

**NON_PARAMETRIC REGRESSIONS

lpoly ln_diff_wage share_margin if abs(vote_share-.5)<=.2&num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1, kernel(triangle) bwidth(.2) degree(1) generate(x s) se(se) nograph
lpoly ln_diff_wage share_margin if abs(vote_share-.5)<=.15&num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1, kernel(triangle) bwidth(.15) degree(2) generate(x_15 s_15) se(se_15) nograph

*.2 bins, degree 2, ln_diff_wage
lpoly ln_diff_wage_def share_margin if abs(vote_share-.5)<=.2&num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1, kernel(triangle) bwidth(.2) degree(2) generate(x_ s_) se(se_) nograph
*.15 bins, degree 1, ln_diff_wage
lpoly ln_diff_wage_def share_margin if abs(vote_share-.5)<=.15&num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1, kernel(triangle) bwidth(.15) degree(1) generate(x15 s15) se(se15) nograph

*VOTE_MARGIN
gen x_c = share_margin - 0.5
gen x2_c = x_c^2
gen x3_c = x_c^3

*bin the vote shares
gen x_ac = -.2 if x_c>=-.2 &x_c<-.15
replace x_ac = -.15 if x_c>=-.15 &x_c<-.10
replace x_ac = -.1 if x_c>=-.1 &x_c<-.05
replace x_ac = -.05 if x_c>=-.05 &x_c<=0
replace x_ac = .05 if x_c>0 &x_c<.05
replace x_ac = .1 if x_c>=.05 &x_c<.1
replace x_ac = .15 if x_c>=.1 &x_c<.15
replace x_ac = .2 if x_c>=.15 &x_c<=.2

gen x2_ac = x_ac^2
gen x3_ac = x_ac^3

gen y_c = margin
gen y2_c = y_c^2
gen y3_c = y_c^3

sort us_id year

replace election= 0 if election!=1
by us_id, sort: gen tot_elec = sum(election)
gen win_x_elec = 1==win==1 &type=="RC"
by us_id, sort: gen tot_wins = sum(win_x_elec)
by us_id, sort: gen total_wins = tot_win[_N]

summ rtw if ln_diff_wage_def!=. & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1

**TABLE 3 (ROW 1)**
reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.2] if  num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.2] if num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.15] if  num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.15] if num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

**TABLE 4 (ROW 1)**
reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.32] if num_votes>=20 & abs(vote_share-.5)<=.32& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.32] if num_votes>=20 & abs(vote_share-.5)<=.32& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.1] if  num_votes>=20 & abs(vote_share-.5)<=.1& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.1] if num_votes>=20 & abs(vote_share-.5)<=.1& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

**ROBUSTNESS: CONTROL FOR # OF UNITS PREVIOUSLY UNIONIZED
**TABLE 3 (ROW 2)**
reg ln_diff_wage_def i.win##(c.x_c c.x2_c) tot_wins [iw=share_margin/.2] if  num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) tot_wins [iw=share_margin/.2] if num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

reg ln_diff_wage_def i.win##(c.x_c c.x2_c) tot_wins [iw=share_margin/.15] if  num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) tot_wins [iw=share_margin/.15] if num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

**TABLE 4 (ROW 2)**
reg ln_diff_wage_def i.win##(c.x_c c.x2_c) tot_wins [iw=share_margin/.32] if num_votes>=20 & abs(vote_share-.5)<=.32& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) tot_wins [iw=share_margin/.32] if num_votes>=20 & abs(vote_share-.5)<=.32& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

reg ln_diff_wage_def i.win##(c.x_c c.x2_c) tot_wins [iw=share_margin/.1] if  num_votes>=20 & abs(vote_share-.5)<=.1& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) tot_wins [iw=share_margin/.1] if num_votes>=20 & abs(vote_share-.5)<=.1& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

**ROBUSTNESS: LIMIT TO INSTANCES OF FIRST UNIONIZATION
**TABLE 3 (ROW 3)**
reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.2] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.2] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.15] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.15] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

**TABLE 4 (ROW 3)**
reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.32] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.32& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.32] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.32& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.1] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.1& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.1] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.1& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)


****THREATS TO ID: LARGE FIRMS ARE MORE POWERFUL
**SOLUTION RESTRICT SAMPLE TO ONLY BELOW-MEDIAN SIZED FIRMS
**TABLE 11 (APPENDIX B.2)
reg ln_avg_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.2] if emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_avg_diff_wage_def i.win##(c.x_c) [iw=share_margin/.2] if emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

reg ln_avg_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.15] if emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_avg_diff_wage_def i.win##(c.x_c) [iw=share_margin/.15] if emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

reg ln_avg_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.4] if emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.4& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_avg_diff_wage_def i.win##(c.x_c) [iw=share_margin/.4] if emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.4& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

reg ln_avg_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.1] if emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.1& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_avg_diff_wage_def i.win##(c.x_c) [iw=share_margin/.1] if emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.1& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

gen rep = num_votes/emp
summ rep if emp<9270 & ln_diff_wage_def!=. & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1, detail
summ rep if ln_diff_wage_def!=. & emp>9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1

****Small versus Large Firms Summ Stats
**TABLE 9 (APPENDIX B)

summ rep if ln_diff_wage_def!=. & emp>9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1, detail

summ win if ln_diff_wage_def!=. & emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1
summ win if ln_diff_wage_def!=. & emp>9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1

summ share_margin if ln_diff_wage_def!=. & emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1
summ share_margin if ln_diff_wage_def!=. & emp>9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1

summ num_votes if ln_diff_wage_def!=. & emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1
summ num_votes if ln_diff_wage_def!=. & emp>9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1

summ emp if ln_diff_wage_def!=. & emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1
summ emp if ln_diff_wage_def!=. & emp>9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1

replace rep = 1 if rep>=73.5 & rep!=.
summ rep if ln_diff_wage_def!=. & emp<9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1
summ rep if ln_diff_wage_def!=. & emp>9270 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1

summ rep if ln_diff_wage_def!=. & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1, detail

***REVISION: # OF CHALLENGED BALLOTS BY FIRM SIZE
**TABLE 9 (APPENDIX B)
gen ballot_challenge=1==challenged>=1&challenged!=.&vote_share!=.

hist margin_of if win!=. & emp>9270 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1 & abs(margin_of)<=40, fraction
hist margin_of if win!=. & emp<9270 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1 & abs(margin_of)<=40, fraction
boxplot margin_of if win!=. & emp<9270 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1 & abs(margin_of)<=40, fraction
summ margin_of if win!=. & emp<9270 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1, detail
summ margin_of if win!=. & emp>9270 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1, detail
tab margin if abs(margin)<=5 & emp<9270 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1
gen margin_2 = 1 == abs(margin_of)<=2 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1
gen margin_3 = 1 == abs(margin_of)<=3 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1
gen margin_5 = 1 == abs(margin_of)<=5 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1
gen margin_10 = 1 == abs(margin_of)<=10 & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1
gen big_firm=1==emp>=9270
ttest margin_2 if win!=. & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1, by(big)
ttest margin_3 if win!=. & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1, by(big)
ttest margin_5 if win!=. & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1, by(big)
ttest margin_10 if win!=. & num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1, by(big)
**TABLE 10 (APPENDIX B)
sort us_id year
reg ballot_challenge ln_emp if abs(vote_share-.5)<.5 & win!=. &  num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1, cluster(us_id)
reg ballot_challenge ln_emp rep if abs(vote_share-.5)<.5 & win!=. &  num_votes>=20 &  year[_n+1]-year==1& year[_n-1]-year==-1, cluster(us_id)

*VOTE_MARGIN
**TABLE 12 (APPENDIX D)
*15 vote bins, degree 2, ln_diff_wage
reg ln_diff_wage_def i.win##(c.y_c c.y2_c) [iw=margin_of_victory/15] if num_votes>=20 & abs(margin)<=15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.y_c) [iw=margin_of_victory/15] if num_votes>=20 & abs(margin)<=15& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
*10 vote bins, degree 1, ln_diff_wage
reg ln_diff_wage_def i.win##(c.y_c c.y2_c) [iw=margin_of_victory/10] if num_votes>=20 & abs(margin)<=10& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
reg ln_diff_wage_def i.win##(c.y_c) [iw=margin_of_victory/10] if num_votes>=20 & abs(margin)<=10& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

*REGRESSION COEFFS FOR NON_PARAMETRIC DIFF_WAGE REGS
gen Lln_wage2 = Lln_wage*Lln_wage
gen L2ln_wage2 = L2ln_wage*L2ln_wage
gen L3ln_wage2 = L3ln_wage*L3ln_wage
gen L4ln_wage2 = L4ln_wage*L4ln_wage

gen Lln_wage2_def = Lln_wage_def*Lln_wage_def
gen L2ln_wage2_def = L2ln_wage_def*L2ln_wage_def
gen L3ln_wage2_def = L3ln_wage_def*L3ln_wage_def
gen L4ln_wage2_def = L4ln_wage_def*L4ln_wage_def

*VOTE_SHARE
reg Fln_wage_def i.win##(c.x_c c.x2_c) Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def [iw=share_margin/.2]  if num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1, cluster(us_id)
reg Fln_wage_def i.win##(c.x_c) Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def [iw=share_margin/.15]  if num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1, cluster(us_id)
*VOTE_MARGIN
reg Fln_wage_def i.win##(c.y_c c.y2_c) Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def [iw=share_margin/.2] if num_votes>=20 & abs(vote_share-.5)<=.2& year[_n+1]-year==1& year[_n-1]-year==-1, cluster(us_id)
reg Fln_wage_def i.win##(c.y_c) Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def [iw=share_margin/.15] if num_votes>=20 & abs(vote_share-.5)<=.15& year[_n+1]-year==1& year[_n-1]-year==-1, cluster(us_id)

**FULL SAMPLE FOR COMPARISON W/ CPUSTAT
**TABLE 5

**ROW 1, COLUMNS 1 + 2
*degree 2, ln_diff_wage
reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.5] if num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
*degree 1, ln_diff_wage
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.5] if num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

**ROW 1, COLUMNS 3 + 4
*degree 2, ln_diff_wage
reg Fln_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.5] Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def  if num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
*degree 1, ln_diff_wage
reg Fln_wage_def i.win##(c.x_c) [iw=share_margin/.5] Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def  if num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

**RESTRICT TO INAUGURAL ELECTIONS

**ROW 2, COLUMNS 1 + 2
*degree 2, ln_diff_wage
reg ln_diff_wage_def i.win##(c.x_c c.x2_c) [iw=share_margin/.5] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
*degree 1, ln_diff_wage
reg ln_diff_wage_def i.win##(c.x_c) [iw=share_margin/.5] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

**ROW 2, COLUMNS 3 + 4
*degree 2, ln_diff_wage
reg Fln_wage_def i.win##(c.x_c c.x2_c) Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def [iw=share_margin/.5] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
*degree 1, ln_diff_wage
reg Fln_wage_def i.win##(c.x_c) Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def [iw=share_margin/.5] if tot_elec<=1 & num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)


*WITH CONTROLS
**FULL SAMPLE FOR COMPARISON W/ CPUSTAT 
gen rtwxwin = rtw*win
gen winxtot_wins =win*tot_wins
gen nonrtw = 1-rtw
*TABLE 6 

*ROW 1, COLUMNS 1 + 2
*degree 2, ln_diff_wage
reg ln_diff_wage_def i.win##(c.x_c c.x2_c) rtwxwin tot_wins i.year [iw=share_margin/.5] if num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
*degree 1, ln_diff_wage
reg ln_diff_wage_def i.win##(c.x_c) rtwxwin tot_wins i.year [iw=share_margin/.5] if num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)

*ROW 1, COLUMNS 3 + 4
*degree 2, ln_diff_wage
reg Fln_wage_def i.win##(c.x_c c.x2_c) rtwxwin tot_wins i.year Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def [iw=share_margin/.5] if num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
*degree 1, ln_diff_wage
reg Fln_wage_def i.win##(c.x_c) rtwxwin tot_wins i.year Lln_wage_def L2ln_wage_def Lln_wage2_def L2ln_wage2_def [iw=share_margin/.5] if num_votes>=20 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&abs(ln_diff_wage_def)<1&type=="RC", cluster(us_id)
