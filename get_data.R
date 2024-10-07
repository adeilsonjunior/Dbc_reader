##-- Pacotes ----
## Working Directories
## Casa
setwd('C:\\desenvolvimento\\projetos\\Dbc_reader')

library(RCurl)
library(rvest)
library(dplyr)
library(stringr)
library(read.dbc)
library(readxl)

source("R/utils.R")

ano <- "2024"
dir_out <- "outputs"
log_file <- sprintf("documentos/log_%s.txt", ano)
unlink(log_file)

##-- SIH ----
download_sih(ano = ano, dir_out = dir_out, log_file = log_file)

##-- SIA ----
download_sia(ano = ano, dir_out = dir_out, log_file = log_file)

##-- Informações dos procedimentos ----
# download_dsinfo(level = "forma_organizacao", dir_out = dir_out, log_file = log_file)
download_dsinfo(level = "procedimento", dir_out = dir_out, log_file = log_file)
  
##-- Informações do CNES ----
download_cnes(ano = ano, dir_out = dir_out, log_file = log_file)

##-- IBGE ---- FEITO ARTESANALMENTE, usando downloadDatasus.ipynb
# download_ibge(ano = ano, dir_out = dir_out, log_file = log_file)

##-- ANS ---- FEITO ARTESANALMENTE usando downloadDatasus.ipynb
# download_ans(ano = ano, mes = "01", dir_out = dir_out, log_file = log_file)



##--- Baixar a última tabela unificada do ftp do Datasus ---


url_ftp <- "ftp://ftp2.datasus.gov.br/public/sistemas/tup/downloads/"
arquivos <- listar_arquivos_ftp(url_ftp)
print(arquivos)


data_atual <- format(Sys.Date(), "%Y%m")

url_completa <- paste0(url_ftp, "TabelaUnificada_", data_atual, ".zip")

# Nome do arquivo local onde será salvo
nome_arquivo_local <- paste0("TabelaUnificada_", data_atual, ".zip")

# Fazer o download do arquivo
download.file(url_completa, nome_arquivo_local)

print("Download concluído.")












library(RCurl)

# Função para listar os arquivos no diretório FTP
listar_arquivos_ftp <- function(url) {
  files <- getURL(url, ftp.use.epsv = FALSE, dirlistonly = TRUE)
  files <- strsplit(files, "\r\n")[[1]]
  files <- data.frame(
    nome = files,
    tipo = sub("^.*\\.", "", files),
    tamanho = NA
  )
  files
}

# Função para baixar os arquivos para uma pasta
baixar_arquivos_ftp <- function(url_ftp, pasta_destino) {
  arquivos <- listar_arquivos_ftp(url_ftp)
  for (i in seq_len(nrow(arquivos))) {
    arquivo <- arquivos[i, "nome"]
    url_arquivo <- paste0(url_ftp, URLencode(arquivo))
    destino <- file.path(pasta_destino, arquivo)
    download.file(url_arquivo, destino, mode = "wb") # Especificando modo binário para arquivos binários
  }
}

# Definindo a URL do diretório FTP e a pasta de destino
url_ftp <- "ftp://ftp2.datasus.gov.br/public/sistemas/tup/downloads/"
pasta_destino <- "~/downloads_tabela_unificada"  # Pasta onde os arquivos serão salvos

# Criando a pasta de destino, se não existir
if (!file.exists(pasta_destino)) {
  dir.create(pasta_destino, recursive = TRUE)
}

# Baixando os arquivos para a pasta de destino
baixar_arquivos_ftp(url_ftp, pasta_destino)












