*Teflon Don? Or Politics as Usual? An Examination of Foreign Policy Flip-Flops in the Age of Trump
*Croco, McDonald, Turitto 2019 Replication Code
*The Journal of Politics

*DATA SOURCES

*1. Syrian Air Strikes Data

use "syriaexp.dta", clear

*2. European Union Tariffs Data

use "tradedata.dta", clear

*FIGURES

*Figure 1. Recognition of Reversal by Experiment and Condition 

*Syria Air Strikes

tab condition3 reversalyes, row

*EU Tariffs

tab condition3 trumpreverse, row

*Figure 2a. Syria Experiment – Situational Approval of Donald Trump by Policy Preference and Condition

bysort supportstrikes: reg sitappstand attackcomb reversecomb control, nocons
bysort supportstrikes: reg sitappstand attackcomb reversecomb
bysort supportstrikes: reg sitappstand attackcomb control

*Figure 2b - EU Tariff Experiment – Situational Approval of Donald Trump by Policy Preference and Condition

bysort supporttariff: reg sitappstand tariffonly reversalcond control, nocons
bysort supporttariff: reg sitappstand tariffonly reversalcond
bysort supporttariff: reg sitappstand tariffonly control

*Figure 3a - Trump Job Approval by Condition and Policy Preference on Syrian Air Strikes

bysort supportstrikes: reg sitappstand attackcomb reversecomb control, nocons
bysort supportstrikes: reg sitappstand attackcomb reversecomb
bysort supportstrikes: reg sitappstand attackcomb control

*Figure 3b - Trump Job Approval by Condition and Policy Preference on Syrian Air Strikes

bysort supporttariff: reg jobappstand tariffonly reversalcond control, nocons
bysort supporttariff: reg jobappstand tariffonly reversalcond
bysort supporttariff: reg jobappstand tariffonly control

*APPENDIX C

*1. Variable Distributions - Syria Air Strikes

tab reversalyes
tab sitappstand
tab jobappstand

*2. Variable Distributions - EU Tariffs

tab trumpreverse
tab sitappstand
tab jobappstand

*APPENDIX D - SYRIA AIR STRIKES

*Table 1

reg reversalyes attackonly attackdemcrit attackrepubcrit reversalonly reversaldemattackcrit reversalrepubattackcrit reversaldemreversalcrit reversalrepubreversalcrit
reg sitappstand attackonly attackdemcrit attackrepubcrit reversalonly reversaldemattackcrit reversalrepubattackcrit reversaldemreversalcrit reversalrepubreversalcrit
reg jobappstand attackonly attackdemcrit attackrepubcrit reversalonly reversaldemattackcrit reversalrepubattackcrit reversaldemreversalcrit reversalrepubreversalcrit

*Table 2a

reg sitappstand attackcomb reversecomb
bysort supportstrikes: reg sitappstand attackcomb reversecomb

*Table 2b

reg jobappstand attackcomb reversecomb
bysort supportstrikes: reg jobappstand attackcomb reversecomb

*Table 3

mlogit condition3 pid7 age male white, b(1)

*Table 4

tab pidwleaners supportstrikes, row

*APPENDIX E - EU TARIFFS

*Table 5

reg trumpreverse article articledemtariffcrit articlerepubtariffcrit reversal reversaldemtariffcrit reversalrepubtariffcrit reversaldemreversecrit reversalrepubreversecrit
reg sitappstand article articledemtariffcrit articlerepubtariffcrit reversal reversaldemtariffcrit reversalrepubtariffcrit reversaldemreversecrit reversalrepubreversecrit
reg jobappstand article articledemtariffcrit articlerepubtariffcrit reversal reversaldemtariffcrit reversalrepubtariffcrit reversaldemreversecrit reversalrepubreversecrit

*Table 6a

reg sitappstand tariffonly reversalcond
bysort supporttariff: reg sitappstand tariffonly reversalcond

*Table 6b
reg jobappstand tariffonly reversalcond
bysort supporttariff: reg jobappstand tariffonly reversalcond

*Table 7

mlogit condition3 pid7 age male white, b(1)

*Table 8

tab pid3 supporttariff, row

*APPENDIX F. Sample Demographics

tab pid3
sum age
tab male
tab white

