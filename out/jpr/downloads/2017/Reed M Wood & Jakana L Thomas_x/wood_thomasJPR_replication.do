****Histogram

histogram cat4_prevalence , discrete percent xtitle (Female Combatant Prevalence in Group) xlabel(0(1)3)

graph pie, over(cat4_prevalence) plabel(_all percent)

*graph pie, over(category) plabel(_all percent)


***Full sample results
logit female_c leftist islamist nationalist mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced, cl(ccode)

ologit cat4_prevalence leftist islamist nationalist mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced, cl(ccode)

*Model 3/4

logit female_combat nationalist nonnationalist noid mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced, cl(ccode)

ologit cat4_prevalence nationalist nonnationalist noid mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced, cl(ccode)

*Model 5/6

logit female_combat leftist secular_nonleft religious_nonislamist islamist noideol  mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced, cl(ccode)

ologit cat4_prevalence leftist secular_nonleft religious_nonislamist islamist noideol  mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced, cl(ccode)



*Robustness 

*(high estimates)

ologit cat4_prevalence_high leftist islamist nationalist mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced, cl(ccode)

ologit cat4_prevalence_high nationalist nonnationalist noid mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced, cl(ccode)

ologit cat4_prevalence_high leftist secular_nonleft religious_nonislamist islamist noideol  mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced, cl(ccode)


***coefplot, drop(_cons) xline(0) xtitle(Log Odds) title(All Conflicts)

coefplot, drop(_cons) xline(0) xtitle(Log Odds) title(Model 3a)


**Marginal effects


ologit cat4_prevalence leftist secular_nonleft religious_nonislamist islamist noideol  mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced if cumulativeintensity==1, cl(ccode)



***None
margins, at(leftist=1 secular_nonleft=0 religious_nonislamist=0 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(0)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=1 religious_nonislamist=0 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(0)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=0 religious_nonislamist=1 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(0)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=0 religious_nonislamist=0 islamist=1 very=0 final==0 suicide=0 forced=1) predict(outcome(0)) atmeans noatlegend



***Low
margins, at(leftist=1 secular_nonleft=0 religious_nonislamist=0 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(1)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=1 religious_nonislamist=0 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(1)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=0 religious_nonislamist=1 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(1)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=0 religious_nonislamist=0 islamist=1 very=0 final==0 suicide=0 forced=1) predict(outcome(1)) atmeans noatlegend


***Moderate
margins, at(leftist=1 secular_nonleft=0 religious_nonislamist=0 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(2)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=1 religious_nonislamist=0 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(2)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=0 religious_nonislamist=1 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(2)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=0 religious_nonislamist=0 islamist=1 very=0 final==0 suicide=0 forced=1) predict(outcome(2)) atmeans noatlegend


***High
margins, at(leftist=1 secular_nonleft=0 religious_nonislamist=0 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(3)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=1 religious_nonislamist=0 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(3)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=0 religious_nonislamist=1 islamist=0 very=0 final==0 suicide=0 forced=1) predict(outcome(3)) atmeans noatlegend

margins, at(leftist=0 secular_nonleft=0 religious_nonislamist=0 islamist=1 very=0 final==0 suicide=0 forced=1) predict(outcome(3)) atmeans noatlegend



***"Large-scale" conflicts only

*Model 1/2
logit female_c leftist islamist nationalist mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced if cumulativeintensity==1, cl(ccode)

ologit cat4_prevalence leftist islamist nationalist mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced if cumulativeintensity==1, cl(ccode)

*Model 3/4

logit female_combat nationalist nonnationalist noid mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced if cumulativeintensity==1, cl(ccode)

ologit cat4_prevalence nationalist nonnationalist noid mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced if cumulativeintensity==1, cl(ccode)

*Model 5/6

logit female_combat leftist secular_nonleft religious_nonislamist islamist noideol  mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced if cumulativeintensity==1, cl(ccode)

ologit cat4_prevalence leftist secular_nonleft religious_nonislamist islamist noideol  mean_femseced_ratio lngdppc final2000 duration islmgen very suicide forced if cumulativeintensity==1, cl(ccode)



