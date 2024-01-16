#!/bin/zsh

alpha=(1 5)

for a in "${alpha[@]}";do
    quarto render template.qmd -P alpha:$a --profile exo -o exo_${a}.pdf -M title:"Exercise for alpha=${a}"
    quarto render template.qmd -P alpha:$a --profile solution -o solution_${a}.pdf -M title:"Exercise for alpha=${a}" -M subtitle:"Solution"
done

for a in "${alpha[@]}";do
    quarto render template-reticulate.qmd -P alpha:$a --profile exo -o exo-reticulate_${a}.pdf -M title:"Exercise for alpha=${a}"
    quarto render template-reticulate.qmd -P alpha:$a --profile solution -o solution-reticulate_${a}_solution.pdf -M title:"Exercise for alpha=${a}" -M subtitle:"Solution"
done

