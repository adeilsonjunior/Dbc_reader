##-- Pacotes ----
library(dplyr)
library(stringr)
library(spdep)

source("R/utils.R")

download_dsinfo(level='procedimento', dir_out ="G:/Meu Drive/SUSano/Testes/TabSus", log_file = "G:/Meu Drive/SUSano/Testes/TabSus/log.txt")