keep fairness_win fairness_lose responsibility_win responsibility_lose worry_win worry_lose longterm_win longterm_lose disaster_win disaster_lose harm_win harm_lose priorityt_win priorityt_lose rakewt responseid college democrat republican female white osint gridscore groupscore module1 module2 module3 module4

gen index="a"
replace index=module1 if module1!=""
replace index=module2 if module2!=""
replace index=module3 if module3!=""
replace index=module4 if module4!=""
drop if index=="mortality"
drop if index=="prioritym"
drop module1 module2 module3 module4

gen winner="a"
replace winner=priorityt_win if index=="priorityt"
replace winner=harm_win if index=="harm"
replace winner=fairness_win if index=="fairness"
replace winner=responsibility_win if index=="responsibility"
replace winner=worry_win if index=="worry"
replace winner=longterm_win if index=="longterm"
replace winner=disaster_win if index=="disaster"

gen loser="a"
replace loser=priorityt_lose if index=="priorityt"
replace loser=harm_lose if index=="harm"
replace loser=fairness_lose if index=="fairness"
replace loser=responsibility_lose if index=="responsibility"
replace loser=worry_lose if index=="worry"
replace loser=longterm_lose if index=="longterm"
replace loser=disaster_lose if index=="disaster"

drop fairness_win fairness_lose responsibility_win responsibility_lose worry_win worry_lose longterm_win longterm_lose disaster_win disaster_lose harm_win harm_lose priorityt_win priorityt_lose

gen abc1=1
gen abc0=0
gen obs=_n
reshape long abc, i(obs) j(outcome)

gen risk="a"
replace risk=winner if outcome==1
replace risk=loser if outcome==0

drop winner loser obs abc

gen rviolence=0
gen rhealth=0
gen renvironment=0
gen rnatural_disasters=0
gen rexistential=0 
replace rviolence=1 if risk=="Air warfare" | risk=="Biological terrorism" | risk=="Child abuse" | risk=="Cyberattacks"  | risk=="Firearms injuries" | risk=="Gang violence" | risk=="Homicides" | risk=="Land warfare" | risk=="Lethal force used by police" | risk=="Naval warfare" | risk=="Nuclear war" | risk=="Rioting" | risk=="Terrorism" | risk=="Warfare"
replace rhealth=1 if risk=="Alcohol use" | risk=="Alzheimer's disease" | risk=="Arthritis" | risk=="Asthma" | risk=="Bacterial infections" | risk=="Benign tumors" | risk=="Birth defects" | risk=="Blood disorders" | risk=="Bone diseases" | risk=="Cancer" | risk=="Complications from pregnancy / childbirth" | risk=="Diabetes" | risk=="Epilepsy" | risk=="Food poisoning" | risk=="Fungal infections" | risk=="Gallbladder / pancreas disorders" | risk=="HIV/AIDS" | risk=="Hepatitis" | risk=="Hernias" | risk=="Huntingon's disease" | risk=="Illicit drug overdoses" | risk=="Influenza / pneumonia" | risk=="Intestinal disorders" | risk=="Kidney diseases" | risk=="Liver diseases" | risk=="Lung diseases" | risk=="Lupus" | risk=="Medical errors / malpractice" | risk=="Malnutrition" | risk=="Metabolic disorders" | risk=="Multiple sclerosis" | risk=="Obesity" | risk=="Opioid / heroin overdoses" | risk=="Pandemics / plagues" | risk=="Parkinson's disease" | risk=="Post-traumatic stress disorder (PTSD)" | risk=="Prescription drug overdoses" | risk=="Second-hand smoke exposure" | risk=="Smoking" | risk=="Spinal diseases" | risk=="Stomach diseases" | risk=="Strokes" | risk=="Suicides" | risk=="Thyroid disorders" | risk=="Urinary disorders"
replace renvironment=1 if risk=="Air pollution" | risk=="Climate change" | risk=="Contaminated drinking water" | risk=="Drought" | risk=="Exposure to cold" | risk=="Extreme weather" | risk=="Pesticides" | risk=="Wildfires"
replace rnatural_disasters=1 if risk=="Wildfires" | risk=="Volcanic eruptions" | risk=="Tsunamis" | risk=="Tornadoes" | risk=="Landslides" | risk=="Hurricanes" | risk=="Floods" | risk=="Extreme weather" | risk=="Earthquakes"
replace rexistential=1 if risk=="Volcanic eruptions" | risk=="Solar flares" | risk=="Pandemics / plagues" | risk=="Nuclear war" | risk=="Nanotechnology" | risk=="High-energy physics experiments" | risk=="Fungal infections" | risk=="Extraterrestrials" | risk=="Climate change" | risk=="Asteroid collision" | risk=="Artificial intelligence"

encode responseid, gen(responsenum)

egen n_osint=std(osint)
gen hiosint=cond(n_osint>0,1,0)

egen n_grid=std(gridscore)
gen higrid=cond(n_grid>0,1,0)
drop n_grid

egen n_group=std(groupscore)
gen higroup=cond(n_group>0,1,0)
drop n_group

encode risk, gen(risknum)
