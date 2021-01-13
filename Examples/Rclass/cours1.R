cities <- c("Angers", "Bordeaux", "Brest", "Dijon", "Grenoble", "Le Havre", "Le Mans", "Lille", "Lyon", "Marseille", "Montpellier", "Nantes", "Nice", "Paris", "Reims", "Rennes", "Saint-Étienne", "Strasbourg", "Toulon", "Toulouse")
pop_1962<-c(115273,278403,136104,135694,156707,187845,132181,239955,535746,778071,118864,240048,292958,2790091,134856,151948,210311,228971,161797,323724)
pop_2012<-c(149017,241287,139676,152071,158346,173142,143599,228652,496343,852516,268456,291604,343629,2240621,181893,209860,171483,274394,164899,453317)
names(pop_1962)<-cities
names(pop_2012)<-cities
names(pop_1962)[pop_1962>200e3]
pop_2012[names(pop_1962)[pop_1962>200e3]]

pop_2012[c("Montpellier","Nantes")] - pop_1962[c("Montpellier","Nantes")]
(pop_2012 - pop_1962)[c("Montpellier","Nantes")]

pop_diff <- pop_2012 - pop_1962
names(pop_diff[pop_diff<=0])



cities[pop_1962<300e3 & pop_2012>300e3]


names(sort(pop_1962, decreasing=TRUE)[1:10])
cities10<-cities[order(pop_1962, decreasing=TRUE)][1:10]
pop_diff[cities10]

mean(pop_1962)
mean(c(pop_1962["Paris"], pop_2012["Paris"]))






