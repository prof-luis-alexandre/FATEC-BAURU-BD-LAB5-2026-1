SET GLOBAL local_infile = 1;
SET NAMES utf8mb4;

USE covid;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE caso;
TRUNCATE TABLE municipio;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- 1) TABELA DIMENSÃO: municipio
-- ---------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'municipios.csv'
INTO TABLE municipio
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(codigo_ibge, nome_municipio);
-- ---------------------------------------------------------------------
-- 2) TABELA FATO: caso
-- ---------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'amostra-covid-casos-tratados.csv'
INTO TABLE caso
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
( @codigo_ibge, @idade, @cs_sexo, @data_inicio_sintomas, @obito,
  @asma, @cardiopatia, @diabetes, @doenca_hematologica, @doenca_hepatica,
  @doenca_neurologica, @doenca_renal, @imunodepressao, @obesidade,
  @outros_fatores_de_risco, @pneumopatia, @puerpera, @sindrome_de_down,
  @ano_sintomas, @mes_sintomas )
SET
  codigo_ibge             = NULLIF(@codigo_ibge, ''),
  idade                   = NULLIF(@idade, '') + 0,
  cs_sexo                 = NULLIF(@cs_sexo, ''),
  data_inicio_sintomas    = NULLIF(@data_inicio_sintomas, ''),
  obito                   = NULLIF(@obito, ''),
  asma                    = NULLIF(@asma, ''),
  cardiopatia             = NULLIF(@cardiopatia, ''),
  diabetes                = NULLIF(@diabetes, ''),
  doenca_hematologica     = NULLIF(@doenca_hematologica, ''),
  doenca_hepatica         = NULLIF(@doenca_hepatica, ''),
  doenca_neurologica      = NULLIF(@doenca_neurologica, ''),
  doenca_renal            = NULLIF(@doenca_renal, ''),
  imunodepressao          = NULLIF(@imunodepressao, ''),
  obesidade               = NULLIF(@obesidade, ''),
  outros_fatores_de_risco = NULLIF(@outros_fatores_de_risco, ''),
  pneumopatia             = NULLIF(@pneumopatia, ''),
  puerpera                = NULLIF(@puerpera, ''),
  sindrome_de_down        = NULLIF(@sindrome_de_down, ''),
  ano_sintomas            = NULLIF(@ano_sintomas, '') + 0,
  mes_sintomas            = NULLIF(@mes_sintomas, '') + 0;