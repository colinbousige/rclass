#!/bin/bash

cp -r Data/* _book/Data/
cp -r Plots/* _book/Plots/
cp -r Exo/Data _book/Exo/
cp -r Exo/Data_Religion _book/Exo/
rmdremove=`ls _book/Exo/*.html`
for file in rmdremove; do 
    rm -f _book/Exo/${file//.html/}.Rmd
done
rm -f _book/Exo/*_solution.Rmd

rm -rf ~/Travail/SiteLMI/SiteLMI/static/r/*
cp -r _book/* ~/Travail/SiteLMI/SiteLMI/static/r/

lftp -e "set sftp:auto-confirm yes ; mirror -eRv _book/ lmi.cnrs.fr/www/r/; quit;" -u lab0958,"p|3lYCs8+" sftp://195.220.198.90:50028
echo ""
echo "Done."
echo ""

