
use UN-crisisdur-JPRreplication, clear

cem contig pc violtrig maxrestime(7) ethniccomp cractr(2) if _t==0, treatment(uninv_crisis)

*Results for Table II
mlogit endtype negotiate_op_order negotiate_op_any_dur negotiate_op_any_dur_2 negotiate_noop_order negotiate_noop_any_dur negotiate_noop_any_dur_2 deter_op_order deter_op_any_dur deter_op_any_dur_2 deter_noop_order deter_noop_any_dur deter_noop_any_dur_2 uninv_any uninv_timing_pc uninv_timing_pc_2 contig pc violtrig maxrestime ethniccomp cractr p5 roinv _t t2 t3 [iweight=cem_weights], cluster(crisno)
outreg2 using un_crisisdur_mlogit_cem_results, 2aster alpha(.05, .1) replace 

*Results for Figure 1 (substract 1 to get the relative risks)
lincom [1]negotiate_op_order + [1]negotiate_op_any_dur*1 + [1]negotiate_op_any_dur_2*1, rrr level(90)
lincom [1]negotiate_op_order + [1]negotiate_op_any_dur*.99226262 + [1]negotiate_op_any_dur_2*.98458511, rrr level(90)
lincom [1]negotiate_op_order + [1]negotiate_op_any_dur*.96725884 + [1]negotiate_op_any_dur_2*.93558966, rrr level(90)
lincom [1]negotiate_op_order + [1]negotiate_op_any_dur*.93558967 + [1]negotiate_op_any_dur_2*.87532803, rrr level(90)
lincom [1]negotiate_op_order + [1]negotiate_op_any_dur*.90495738 + [1]negotiate_op_any_dur_2*.81894786, rrr level(90)
lincom [1]negotiate_op_order + [1]negotiate_op_any_dur*.81894786 + [1]negotiate_op_any_dur_2*.6706756, rrr level(90)
lincom [1]negotiate_op_order + [1]negotiate_op_any_dur*.66696486 + [1]negotiate_op_any_dur_2*.44484212, rrr level(90)
lincom [1]negotiate_noop_order + [1]negotiate_noop_any_dur*1 + [1]negotiate_noop_any_dur_2*1, rrr level(90)
lincom [1]negotiate_noop_order + [1]negotiate_noop_any_dur*.99226262 + [1]negotiate_noop_any_dur_2*.98458511, rrr level(90)
lincom [1]negotiate_noop_order + [1]negotiate_noop_any_dur*.96725884 + [1]negotiate_noop_any_dur_2*.93558966, rrr level(90)
lincom [1]negotiate_noop_order + [1]negotiate_noop_any_dur*.93558967 + [1]negotiate_noop_any_dur_2*.87532803, rrr level(90)
lincom [1]negotiate_noop_order + [1]negotiate_noop_any_dur*.90495738 + [1]negotiate_noop_any_dur_2*.81894786, rrr level(90)
lincom [1]negotiate_noop_order + [1]negotiate_noop_any_dur*.81894786 + [1]negotiate_noop_any_dur_2*.6706756, rrr level(90)
lincom [1]negotiate_noop_order + [1]negotiate_noop_any_dur*.66696486 + [1]negotiate_noop_any_dur_2*.44484212, rrr level(90)
lincom [1]deter_op_order + [1]deter_op_any_dur*1 + [1]deter_op_any_dur_2*1, rrr level(90)
lincom [1]deter_op_order + [1]deter_op_any_dur*.99226262 + [1]deter_op_any_dur_2*.98458511, rrr level(90)
lincom [1]deter_op_order + [1]deter_op_any_dur*.96725884 + [1]deter_op_any_dur_2*.93558966, rrr level(90)
lincom [1]deter_op_order + [1]deter_op_any_dur*.93558967 + [1]deter_op_any_dur_2*.87532803, rrr level(90)
lincom [1]deter_op_order + [1]deter_op_any_dur*.90495738 + [1]deter_op_any_dur_2*.81894786, rrr level(90)
lincom [1]deter_op_order + [1]deter_op_any_dur*.81894786 + [1]deter_op_any_dur_2*.6706756, rrr level(90)
lincom [1]deter_op_order + [1]deter_op_any_dur*.66696486 + [1]deter_op_any_dur_2*.44484212, rrr level(90)
lincom [1]deter_noop_order + [1]deter_noop_any_dur*1 + [1]deter_noop_any_dur_2*1, rrr level(90)
lincom [1]deter_noop_order + [1]deter_noop_any_dur*.99226262 + [1]deter_noop_any_dur_2*.98458511, rrr level(90)
lincom [1]deter_noop_order + [1]deter_noop_any_dur*.96725884 + [1]deter_noop_any_dur_2*.93558966, rrr level(90)
lincom [1]deter_noop_order + [1]deter_noop_any_dur*.93558967 + [1]deter_noop_any_dur_2*.87532803, rrr level(90)
lincom [1]deter_noop_order + [1]deter_noop_any_dur*.90495738 + [1]deter_noop_any_dur_2*.81894786, rrr level(90)
lincom [1]deter_noop_order + [1]deter_noop_any_dur*.81894786 + [1]deter_noop_any_dur_2*.6706756, rrr level(90)
lincom [1]deter_noop_order + [1]deter_noop_any_dur*.66696486 + [1]deter_noop_any_dur_2*.44484212, rrr level(90)
lincom [2]negotiate_op_order + [2]negotiate_op_any_dur*1 + [2]negotiate_op_any_dur_2*1, rrr level(90)
lincom [2]negotiate_op_order + [2]negotiate_op_any_dur*.99226262 + [2]negotiate_op_any_dur_2*.98458511, rrr level(90)
lincom [2]negotiate_op_order + [2]negotiate_op_any_dur*.96725884 + [2]negotiate_op_any_dur_2*.93558966, rrr level(90)
lincom [2]negotiate_op_order + [2]negotiate_op_any_dur*.93558967 + [2]negotiate_op_any_dur_2*.87532803, rrr level(90)
lincom [2]negotiate_op_order + [2]negotiate_op_any_dur*.90495738 + [2]negotiate_op_any_dur_2*.81894786, rrr level(90)
lincom [2]negotiate_op_order + [2]negotiate_op_any_dur*.81894786 + [2]negotiate_op_any_dur_2*.6706756, rrr level(90)
lincom [2]negotiate_op_order + [2]negotiate_op_any_dur*.66696486 + [2]negotiate_op_any_dur_2*.44484212, rrr level(90)
lincom [2]negotiate_noop_order + [2]negotiate_noop_any_dur*1 + [2]negotiate_noop_any_dur_2*1, rrr level(90)
lincom [2]negotiate_noop_order + [2]negotiate_noop_any_dur*.99226262 + [2]negotiate_noop_any_dur_2*.98458511, rrr level(90)
lincom [2]negotiate_noop_order + [2]negotiate_noop_any_dur*.96725884 + [2]negotiate_noop_any_dur_2*.93558966, rrr level(90)
lincom [2]negotiate_noop_order + [2]negotiate_noop_any_dur*.93558967 + [2]negotiate_noop_any_dur_2*.87532803, rrr level(90)
lincom [2]negotiate_noop_order + [2]negotiate_noop_any_dur*.90495738 + [2]negotiate_noop_any_dur_2*.81894786, rrr level(90)
lincom [2]negotiate_noop_order + [2]negotiate_noop_any_dur*.81894786 + [2]negotiate_noop_any_dur_2*.6706756, rrr level(90)
lincom [2]negotiate_noop_order + [2]negotiate_noop_any_dur*.66696486 + [2]negotiate_noop_any_dur_2*.44484212, rrr level(90)
lincom [2]deter_op_order + [2]deter_op_any_dur*1 + [2]deter_op_any_dur_2*1, rrr level(90)
lincom [2]deter_op_order + [2]deter_op_any_dur*.99226262 + [2]deter_op_any_dur_2*.98458511, rrr level(90)
lincom [2]deter_op_order + [2]deter_op_any_dur*.96725884 + [2]deter_op_any_dur_2*.93558966, rrr level(90)
lincom [2]deter_op_order + [2]deter_op_any_dur*.93558967 + [2]deter_op_any_dur_2*.87532803, rrr level(90)
lincom [2]deter_op_order + [2]deter_op_any_dur*.90495738 + [2]deter_op_any_dur_2*.81894786, rrr level(90)
lincom [2]deter_op_order + [2]deter_op_any_dur*.81894786 + [2]deter_op_any_dur_2*.6706756, rrr level(90)
lincom [2]deter_op_order + [2]deter_op_any_dur*.66696486 + [2]deter_op_any_dur_2*.44484212, rrr level(90)
lincom [2]deter_noop_order + [2]deter_noop_any_dur*1 + [2]deter_noop_any_dur_2*1, rrr level(90)
lincom [2]deter_noop_order + [2]deter_noop_any_dur*.99226262 + [2]deter_noop_any_dur_2*.98458511, rrr level(90)
lincom [2]deter_noop_order + [2]deter_noop_any_dur*.96725884 + [2]deter_noop_any_dur_2*.93558966, rrr level(90)
lincom [2]deter_noop_order + [2]deter_noop_any_dur*.93558967 + [2]deter_noop_any_dur_2*.87532803, rrr level(90)
lincom [2]deter_noop_order + [2]deter_noop_any_dur*.90495738 + [2]deter_noop_any_dur_2*.81894786, rrr level(90)
lincom [2]deter_noop_order + [2]deter_noop_any_dur*.81894786 + [2]deter_noop_any_dur_2*.6706756, rrr level(90)
lincom [2]deter_noop_order + [2]deter_noop_any_dur*.66696486 + [2]deter_noop_any_dur_2*.44484212, rrr level(90)
lincom [3]negotiate_op_order + [3]negotiate_op_any_dur*1 + [3]negotiate_op_any_dur_2*1, rrr level(90)
lincom [3]negotiate_op_order + [3]negotiate_op_any_dur*.99226262 + [3]negotiate_op_any_dur_2*.98458511, rrr level(90)
lincom [3]negotiate_op_order + [3]negotiate_op_any_dur*.96725884 + [3]negotiate_op_any_dur_2*.93558966, rrr level(90)
lincom [3]negotiate_op_order + [3]negotiate_op_any_dur*.93558967 + [3]negotiate_op_any_dur_2*.87532803, rrr level(90)
lincom [3]negotiate_op_order + [3]negotiate_op_any_dur*.90495738 + [3]negotiate_op_any_dur_2*.81894786, rrr level(90)
lincom [3]negotiate_op_order + [3]negotiate_op_any_dur*.81894786 + [3]negotiate_op_any_dur_2*.6706756, rrr level(90)
lincom [3]negotiate_op_order + [3]negotiate_op_any_dur*.66696486 + [3]negotiate_op_any_dur_2*.44484212, rrr level(90)
lincom [3]negotiate_noop_order + [3]negotiate_noop_any_dur*1 + [3]negotiate_noop_any_dur_2*1, rrr level(90)
lincom [3]negotiate_noop_order + [3]negotiate_noop_any_dur*.99226262 + [3]negotiate_noop_any_dur_2*.98458511, rrr level(90)
lincom [3]negotiate_noop_order + [3]negotiate_noop_any_dur*.96725884 + [3]negotiate_noop_any_dur_2*.93558966, rrr level(90)
lincom [3]negotiate_noop_order + [3]negotiate_noop_any_dur*.93558967 + [3]negotiate_noop_any_dur_2*.87532803, rrr level(90)
lincom [3]negotiate_noop_order + [3]negotiate_noop_any_dur*.90495738 + [3]negotiate_noop_any_dur_2*.81894786, rrr level(90)
lincom [3]negotiate_noop_order + [3]negotiate_noop_any_dur*.81894786 + [3]negotiate_noop_any_dur_2*.6706756, rrr level(90)
lincom [3]negotiate_noop_order + [3]negotiate_noop_any_dur*.66696486 + [3]negotiate_noop_any_dur_2*.44484212, rrr level(90)
lincom [3]deter_op_order + [3]deter_op_any_dur*1 + [3]deter_op_any_dur_2*1, rrr level(90)
lincom [3]deter_op_order + [3]deter_op_any_dur*.99226262 + [3]deter_op_any_dur_2*.98458511, rrr level(90)
lincom [3]deter_op_order + [3]deter_op_any_dur*.96725884 + [3]deter_op_any_dur_2*.93558966, rrr level(90)
lincom [3]deter_op_order + [3]deter_op_any_dur*.93558967 + [3]deter_op_any_dur_2*.87532803, rrr level(90)
lincom [3]deter_op_order + [3]deter_op_any_dur*.90495738 + [3]deter_op_any_dur_2*.81894786, rrr level(90)
lincom [3]deter_op_order + [3]deter_op_any_dur*.81894786 + [3]deter_op_any_dur_2*.6706756, rrr level(90)
lincom [3]deter_op_order + [3]deter_op_any_dur*.66696486 + [3]deter_op_any_dur_2*.44484212, rrr level(90)
lincom [3]deter_noop_order + [3]deter_noop_any_dur*1 + [3]deter_noop_any_dur_2*1, rrr level(90)
lincom [3]deter_noop_order + [3]deter_noop_any_dur*.99226262 + [3]deter_noop_any_dur_2*.98458511, rrr level(90)
lincom [3]deter_noop_order + [3]deter_noop_any_dur*.96725884 + [3]deter_noop_any_dur_2*.93558966, rrr level(90)
lincom [3]deter_noop_order + [3]deter_noop_any_dur*.93558967 + [3]deter_noop_any_dur_2*.87532803, rrr level(90)
lincom [3]deter_noop_order + [3]deter_noop_any_dur*.90495738 + [3]deter_noop_any_dur_2*.81894786, rrr level(90)
lincom [3]deter_noop_order + [3]deter_noop_any_dur*.81894786 + [3]deter_noop_any_dur_2*.6706756, rrr level(90)
lincom [3]deter_noop_order + [3]deter_noop_any_dur*.66696486 + [3]deter_noop_any_dur_2*.44484212, rrr level(90)

*Simulated substantive effects for the discussion
estsimp mlogit endtype negotiate_op_order negotiate_op_any_dur negotiate_op_any_dur_2 negotiate_noop_order negotiate_noop_any_dur negotiate_noop_any_dur_2 deter_op_order deter_op_any_dur deter_op_any_dur_2 deter_noop_order deter_noop_any_dur deter_noop_any_dur_2 uninv_any uninv_timing_pc uninv_timing_pc_2 contig pc violtrig maxrestime ethniccomp cractr p5 roinv _t t2 t3 [iweight=cem_weights]
setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 0 uninv_timing_pc 0 uninv_timing_pc_2 0 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 6 t2 36 t3 216
simqi, level(90)
setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 0 uninv_timing_pc 0 uninv_timing_pc_2 0 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 36 t2 1296 t3 46656
simqi, level(90)
setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 0 uninv_timing_pc 0 uninv_timing_pc_2 0 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 186 t2 34596 t3 6434856
simqi, level(90)

setx negotiate_op_order 1 negotiate_op_any_dur 1 negotiate_op_any_dur_2 1 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 6 t2 36 t3 216
simqi, level(90)
setx negotiate_op_order 1 negotiate_op_any_dur .96725884 negotiate_op_any_dur_2 .93558966 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 36 t2 1296 t3 46656
simqi, level(90)
setx negotiate_op_order 1 negotiate_op_any_dur .81894786 negotiate_op_any_dur_2 .6706756 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 186 t2 34596 t3 6434856
simqi, level(90)

setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 1 negotiate_noop_any_dur 1 negotiate_noop_any_dur_2 1 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 6 t2 36 t3 216
simqi, level(90)
setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 1 negotiate_noop_any_dur .96725884 negotiate_noop_any_dur_2 .93558966 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 36 t2 1296 t3 46656
simqi, level(90)
setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 1 negotiate_noop_any_dur .81894786 negotiate_noop_any_dur_2 .6706756 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 186 t2 34596 t3 6434856
simqi, level(90)

setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 1 deter_op_any_dur 1 deter_op_any_dur_2 1 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 6 t2 36 t3 216
simqi, level(90)
setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 1 deter_op_any_dur .96725884 deter_op_any_dur_2 .93558966 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 36 t2 1296 t3 46656
simqi, level(90)
setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 1 deter_op_any_dur .81894786 deter_op_any_dur_2 .6706756 deter_noop_order 0 deter_noop_any_dur 0 deter_noop_any_dur_2 0 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 186 t2 34596 t3 6434856
simqi, level(90)

setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur 1 deter_noop_any_dur_2 1 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 6 t2 36 t3 216
simqi, level(90)
setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur .96725884 deter_noop_any_dur_2 .93558966 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 36 t2 1296 t3 46656
simqi, level(90)
setx negotiate_op_order 0 negotiate_op_any_dur 0 negotiate_op_any_dur_2 0 negotiate_noop_order 0 negotiate_noop_any_dur 0 negotiate_noop_any_dur_2 0 deter_op_order 0 deter_op_any_dur 0 deter_op_any_dur_2 0 deter_noop_order 0 deter_noop_any_dur .81894786 deter_noop_any_dur_2 .6706756 uninv_any 1 uninv_timing_pc .99336429 uninv_timing_pc_2 .98677261 contig 1 pc 1 violtrig 1 maxrestime 35 ethniccomp 1 cractr 2 p5 0 roinv 0 _t 186 t2 34596 t3 6434856
simqi, level(90)

*Results for Table III
mlogit endtype nego_noop_deter_op_order nego_noop_deter_op_dur nego_noop_deter_op_dur_2 non_nego_noop_deter_op_order non_nego_noop_deter_op_dur non_nego_noop_deter_op_dur_2 uninv_any uninv_timing_pc uninv_timing_pc_2 contig pc violtrig maxrestime ethniccomp cractr p5 roinv _t t2 t3 [iweight=cem_weights], cluster(crisno)
outreg2 using un_crisisdur_mlogit_cem_results, 2aster alpha(.05, .1) append
lincom [1]nego_noop_deter_op_order + [1]nego_noop_deter_op_dur*1 + [1]nego_noop_deter_op_dur_2*1, rrr level(90)
lincom [1]nego_noop_deter_op_order + [1]nego_noop_deter_op_dur*.99226262 + [1]nego_noop_deter_op_dur_2*.98458511, rrr level(90)
lincom [1]nego_noop_deter_op_order + [1]nego_noop_deter_op_dur*.96725884 + [1]nego_noop_deter_op_dur_2*.93558966, rrr level(90)
lincom [1]nego_noop_deter_op_order + [1]nego_noop_deter_op_dur*.93558967 + [1]nego_noop_deter_op_dur_2*.87532803, rrr level(90)
lincom [1]nego_noop_deter_op_order + [1]nego_noop_deter_op_dur*.90495738 + [1]nego_noop_deter_op_dur_2*.81894786, rrr level(90)
lincom [1]nego_noop_deter_op_order + [1]nego_noop_deter_op_dur*.81894786 + [1]nego_noop_deter_op_dur_2*.6706756, rrr level(90)
lincom [1]nego_noop_deter_op_order + [1]nego_noop_deter_op_dur*.66696486 + [1]nego_noop_deter_op_dur_2*.44484212, rrr level(90)
lincom [2]nego_noop_deter_op_order + [2]nego_noop_deter_op_dur*1 + [2]nego_noop_deter_op_dur_2*1, rrr level(90)
lincom [2]nego_noop_deter_op_order + [2]nego_noop_deter_op_dur*.99226262 + [2]nego_noop_deter_op_dur_2*.98458511, rrr level(90)
lincom [2]nego_noop_deter_op_order + [2]nego_noop_deter_op_dur*.96725884 + [2]nego_noop_deter_op_dur_2*.93558966, rrr level(90)
lincom [2]nego_noop_deter_op_order + [2]nego_noop_deter_op_dur*.93558967 + [2]nego_noop_deter_op_dur_2*.87532803, rrr level(90)
lincom [2]nego_noop_deter_op_order + [2]nego_noop_deter_op_dur*.90495738 + [2]nego_noop_deter_op_dur_2*.81894786, rrr level(90)
lincom [2]nego_noop_deter_op_order + [2]nego_noop_deter_op_dur*.81894786 + [2]nego_noop_deter_op_dur_2*.6706756, rrr level(90)
lincom [2]nego_noop_deter_op_order + [2]nego_noop_deter_op_dur*.66696486 + [2]nego_noop_deter_op_dur_2*.44484212, rrr level(90)
lincom [3]nego_noop_deter_op_order + [3]nego_noop_deter_op_dur*1 + [3]nego_noop_deter_op_dur_2*1, rrr level(90)
lincom [3]nego_noop_deter_op_order + [3]nego_noop_deter_op_dur*.99226262 + [3]nego_noop_deter_op_dur_2*.98458511, rrr level(90)
lincom [3]nego_noop_deter_op_order + [3]nego_noop_deter_op_dur*.96725884 + [3]nego_noop_deter_op_dur_2*.93558966, rrr level(90)
lincom [3]nego_noop_deter_op_order + [3]nego_noop_deter_op_dur*.93558967 + [3]nego_noop_deter_op_dur_2*.87532803, rrr level(90)
lincom [3]nego_noop_deter_op_order + [3]nego_noop_deter_op_dur*.90495738 + [3]nego_noop_deter_op_dur_2*.81894786, rrr level(90)
lincom [3]nego_noop_deter_op_order + [3]nego_noop_deter_op_dur*.81894786 + [3]nego_noop_deter_op_dur_2*.6706756, rrr level(90)
lincom [3]nego_noop_deter_op_order + [3]nego_noop_deter_op_dur*.66696486 + [3]nego_noop_deter_op_dur_2*.44484212, rrr level(90)










