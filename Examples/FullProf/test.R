library(tidyverse)
flist <- list.files(path=".", pattern = ".sum")

read_cellname <- function(filename, file_lines, line) {
    read_fwf(filename, 
            skip = grep("Phase No.",file_lines)[line]-1, 
            n_max = 1, trim_ws = TRUE,
            fwf_widths(c(17, NA)) )[[2]]
}
read_cell <- function(filename, file_lines, line) {
    read_table2(filename, 
               skip=grep("Cell parameters",file_lines)[line], 
               n_max = 6,
               col_names=c("value", "error")) %>% 
    mutate(param=factor(c("a","b","c","alpha","beta","gamma"), 
        levels = c("a","b","c","alpha","beta","gamma")))
}
read_cellname <- function(filename, file_lines, line) {
    read_fwf(filename, 
            skip = grep("Phase No.",file_lines)[line]-1, 
            n_max = 1,
            fwf_widths(c(17, NA)) )[[2]]
}
overall_scale_factor <- function(filename, file_lines, line) {
    read_fwf(filename,
            skip=grep("overall scale factor", file_lines)[line]-1,
            n_max = 1,
            fwf_widths(c(26, NA)) )[[2]] %>% 
        str_squish() %>% 
        str_split(" ") %>% unlist() %>% as.numeric()
}
Etap_v_or_mp_vii <- function(filename, file_lines, line) {
    read_fwf(filename,
            skip=grep("Eta", file_lines)[line]-1,
            n_max = 1,
            fwf_widths(c(26, NA)) )[[2]] %>% 
        str_squish() %>% 
        str_split(" ") %>% unlist() %>% as.numeric()
}
Overall_tem._factor <- function(filename, file_lines, line) {
    read_fwf(filename,
            skip=grep("Overall tem. factor  ", file_lines)[line]-1,
            n_max = 1,
            fwf_widths(c(26, NA)) )[[2]] %>% 
        str_squish() %>% 
        str_split(" ") %>% unlist() %>% as.numeric()
}
Halfwidth_parameters <- function(filename, file_lines, line) {
    d <- read_fwf(filename,
            skip=grep("Halfwidth parameters ", file_lines)[line]-1,
            n_max = 3,
            fwf_widths(c(26, NA)) )[[2]] %>% 
        str_squish() %>% str_split(" ") %>%
        unlist() %>% as.numeric() %>%
        matrix(ncol = 2, byrow = TRUE) %>% as.tibble()
    names(d) <- c("value", "error")
    d
}
Preferred_orientation <- function(filename, file_lines, line) {
    d <- read_fwf(filename,
            skip=grep("Preferred orientation", file_lines)[line]-1,
            n_max = 2,
            fwf_widths(c(26, NA)) )[[2]] %>% 
        str_squish() %>% str_split(" ") %>%
        unlist() %>% as.numeric() %>%
        matrix(ncol = 2, byrow = TRUE) %>% as.tibble()
    names(d) <- c("value", "error")
    d
}
Asymmetry_parameters <- function(filename, file_lines, line) {
    d <- read_fwf(filename,
            skip=grep("Asymmetry parameters ", file_lines)[line]-1,
            n_max = 4,
            fwf_widths(c(26, NA)) )[[2]] %>% 
        str_squish() %>% str_split(" ") %>%
        unlist() %>% as.numeric() %>%
        matrix(ncol = 2, byrow = TRUE) %>% as.tibble()
    names(d) <- c("value", "error")
    d
}
X_and_y_parameters <- function(filename, file_lines, line) {
    d <- read_fwf(filename,
            skip=grep("X and y parameters   ", file_lines)[line]-1,
            n_max = 2,
            fwf_widths(c(26, NA)) )[[2]] %>% 
        str_squish() %>% str_split(" ") %>%
        unlist() %>% as.numeric() %>%
        matrix(ncol = 2, byrow = TRUE) %>% as.tibble()
    names(d) <- c("value", "error")
    d
}
Strain_parameters <- function(filename, file_lines, line) {
    d <- read_fwf(filename,
            skip=grep("Strain parameters    ", file_lines)[line]-1,
            n_max = 3,
            fwf_widths(c(26, NA)) )[[2]] %>% 
        str_squish() %>% str_split(" ") %>%
        unlist() %>% as.numeric() %>%
        matrix(ncol = 2, byrow = TRUE) %>% as.tibble()
    names(d) <- c("value", "error")
    d
}
Size_parameters_GL <- function(filename, file_lines, line) {
    d <- read_fwf(filename,
            skip=grep("Size parameters", file_lines)[line]-1,
            n_max = 2,
            fwf_widths(c(26, NA)) )[[2]] %>% 
        str_squish() %>% str_split(" ") %>%
        unlist() %>% as.numeric() %>%
        matrix(ncol = 2, byrow = TRUE) %>% as.tibble()
    names(d) <- c("value", "error")
    d
}
Add_shape_parameters <- function(filename, file_lines, line) {
    read_table2(filename,
            skip=grep("Add. shape parameters", file_lines)[line],
            n_max = 2, col_names = c("value", "error"))
}
parse_FullProf <- function(filename) {
    file_lines <- readLines(filename)
    N_phases <- length(grep("Phase No",file_lines))
    title <- read_fwf(filename, 
                    skip = grep("Title",file_lines)-1, 
                    n_max = 1, 
                    fwf_widths(c(11, NA)))[[2]]
    PCR_file_code <- read_fwf(filename, 
                        skip = grep("PCR file code",file_lines)-1, 
                        n_max = 1, 
                        fwf_widths(c(19, NA)))[[2]]
    DAT_file_code <- read_fwf(filename, 
                        skip = grep("DAT file code",file_lines)-1, 
                        n_max = 1, 
                        fwf_widths(c(19, NA)))[[2]]
    Wavelengths   <- read_fwf(filename, 
                        skip = grep("Wavelengths",file_lines)-1, 
                        n_max = 1, 
                        fwf_widths(c(18, NA)) )[[2]] %>% 
                            strsplit(" ") %>% unlist() %>% as.numeric()
    tibble(title=title,
           wavelength=mean(Wavelengths),
           PCR_file_code=PCR_file_code,
           DAT_file_code=DAT_file_code,
           phase=1:N_phases) %>% 
        mutate(phase_name=map_chr(phase, ~read_cellname(filename,file_lines,.)),
               lattice_parameters=map(phase, ~read_cell(filename,file_lines,.)),
               overall_scale_factor = map(phase, ~overall_scale_factor(filename, file_lines, .)),
               etap_v_or_mp_vii=map(phase,~Etap_v_or_mp_vii(filename, file_lines, .)),
               overall_tem._factor=map(phase,~Overall_tem._factor(filename, file_lines, .)),
               halfwidth_parameters=map(phase,~Halfwidth_parameters(filename, file_lines, .)),
               preferred_orientation=map(phase,~Preferred_orientation(filename, file_lines, .)),
               asymmetry_parameters=map(phase,~Asymmetry_parameters(filename, file_lines, .)),
               x_and_y_parameters=map(phase,~X_and_y_parameters(filename, file_lines, .)),
               strain_parameters=map(phase,~Strain_parameters(filename, file_lines, .)),
               size_parameters_gl=map(phase,~Size_parameters_GL(filename, file_lines, .)),
               add_shape_parameters=map(phase,~Add_shape_parameters(filename, file_lines, .))
              )

}

read_all <- tibble(file=flist) %>% 
    mutate(parameters=map(file, ~parse_FullProf(.))) %>% 
    unnest(parameters)

read_all %>% 
    unnest(lattice_parameters) %>% 
        ggplot(aes(x=title, y=value, color=phase_name))+
            geom_point()+
            geom_errorbar(aes(ymin=value-error, ymax=value+error))+
            facet_wrap(~param, scales = "free_y")

