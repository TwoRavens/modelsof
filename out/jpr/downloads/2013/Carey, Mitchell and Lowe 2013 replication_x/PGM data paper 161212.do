btscs civilviolence year gwno, g(peaceyrs) nspline(3)


* JPR PGM Data Paper
* Final Analyses
logit civilviolence lmtnest lnexclpop lnoil_prod32_09 xpolityb ln_rgdp ln_pop peaceyrs _spline1 _spline2 _spline3, cluster(gwno)
logit civilviolence presence_all lmtnest lnexclpop lnoil_prod32_09 xpolityb ln_rgdp ln_pop peaceyrs _spline1 _spline2 _spline3, cluster(gwno)
logit civilviolence presence_informal presence_semiofficial lmtnest lnexclpop lnoil_prod32_09 xpolityb ln_rgdp ln_pop peaceyrs _spline1 _spline2 _spline3, cluster(gwno)



