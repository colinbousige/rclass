#!/bin/bash

cp -r Data/* _book/Data/
cp -r Plots/* _book/Plots/
cp -r Exo _book
dataremove=`ls -1d _book/Exo/*/Data`
for folder in ${dataremove[@]}; do 
    rm -rf ${folder}
done
rmdremove=`ls _book/Exo/*/*.html`
for file in ${rmdremove[@]}; do 
    rm -f ${file//.html/}.Rmd
done
solremove=`ls _book/Exo/*/solution.*`
for file in ${solremove[@]}; do 
    rm -f ${file}
done
cp -r Exo/plot0/solution.html _book/Exo/plot0/
cp -r Exo/spectro/solution.html _book/Exo/spectro/
cp -r Exo/tga/solution.html _book/Exo/tga/
cp -r Exo/religion_babies/solution.html _book/Exo/religion_babies/
cp -r Exo/covid/solution.html _book/Exo/covid/
cp -r Exo/SEM_particles/solution.html _book/Exo/SEM_particles/
cp -r Exo/co2/solution.html _book/Exo/co2/
cp -r Exo/FTIR/solution.html _book/Exo/FTIR/
cp -r Exo/Grt/solution.html _book/Exo/Grt/



rm -rf ~/Travail/SiteLMI/SiteLMI/static/r/*
cp -r _book/* ~/Travail/SiteLMI/SiteLMI/static/r/

lftp -e "set sftp:auto-confirm yes ; mirror -eRv _book/ lmi.cnrs.fr/www/r/; quit;" -u lab0958,"p|3lYCs8+" sftp://195.220.198.90:50028
echo ""
echo "Done."
echo ""

