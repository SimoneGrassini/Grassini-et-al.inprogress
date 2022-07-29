%%calculation to export

baseline = erpdata{1}


nature = erpdata{2}
nature = nature-baseline
nature = mean(nature(166:192,:),1)
natureavg = mean (nature)


urban = erpdata{3}
urban = mean(urban,2)
urban = urban-baseline
urban =  mean(urban(166:192,:),1)
urbanavg = mean (urban)

neutral = erpdata{4}
neutral = mean(neutral,2)
neutral = neutral-baseline
neutral = mean(neutral(166:192,:),1)
neutralavg = mean (neutral)


SD_nature = std(nature)
SD_urban = std(urban)
SD_neutral = std(neutral)
