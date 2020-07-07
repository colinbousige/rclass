#!/bin/bash

cp -r Data/* _book/Data/
cp -r Plots/* _book/Plots/
cp -r Exo/* _book/Exo/
rm -rf ~/Travail/SiteLMI/SiteLMI/static/r/*
cp -r _book/* ~/Travail/SiteLMI/SiteLMI/static/r/

lftp -e "set sftp:auto-confirm yes ; mirror -eRv _book/ lmi.cnrs.fr/www/r/; quit;" -u lab0958,"p|3lYCs8+" sftp://195.220.198.90:50028
echo ""
echo "Done."
echo ""

