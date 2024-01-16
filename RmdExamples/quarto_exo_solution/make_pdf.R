library(glue)
library(quarto)

alphas <- c(1,5)

for (alpha in alphas) {
    for (profile in c('exo','solution')) {
        output_path <- file.path(glue("{profile}_{alpha}.pdf"))
        print(glue('Rendering {output_path}'))
        quarto_render(
            input = "template.qmd",
            profile = profile,
            output_format = "pdf",
            output_file = output_path,
            execute_params = list(
                alpha = alpha
            ),
            metadata = list(
                title = glue("Exercise for alpha={alpha}"),
                subtitle = ifelse(profile=='solution', 'Solution', ' ')
            )
        )
    }
}

for (alpha in alphas) {
    for (profile in c('exo','solution')) {
        output_path <- file.path(glue("{profile}-reticulate_{alpha}.pdf"))
        print(glue('Rendering {output_path}'))
        quarto_render(
            input = "template-reticulate.qmd",
            profile = profile,
            output_format = "pdf",
            output_file = output_path,
            execute_params = list(
                alpha = alpha
            ),
            metadata = list(
                title = glue("Exercise for alpha={alpha}"),
                subtitle = ifelse(profile=='solution', 'Solution', ' ')
            )
        )
    }
}