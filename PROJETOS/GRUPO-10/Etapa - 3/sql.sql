CREATE DATABASE IF NOT EXISTS covid;

USE covid;

DROP TABLE IF EXISTS caso;
DROP TABLE IF EXISTS municipio;

CREATE TABLE municipio (
  codigo_ibge    INT          NOT NULL,
  nome_municipio VARCHAR(120) NOT NULL,
  CONSTRAINT pk_municipio PRIMARY KEY (codigo_ibge)
);

CREATE TABLE caso (
  id                   BIGINT            NOT NULL AUTO_INCREMENT,
  codigo_ibge          INT               NULL,
  idade                TINYINT UNSIGNED  NULL,
  cs_sexo              VARCHAR(12)       NULL,
  data_inicio_sintomas DATE              NULL,
  obito                ENUM('Não','Sim') NULL,

  asma                    ENUM('Sim','Não','Desconhecido') NULL,
  cardiopatia             ENUM('Sim','Não','Desconhecido') NULL,
  diabetes                ENUM('Sim','Não','Desconhecido') NULL,
  doenca_hematologica     ENUM('Sim','Não','Desconhecido') NULL,
  doenca_hepatica         ENUM('Sim','Não','Desconhecido') NULL,
  doenca_neurologica      ENUM('Sim','Não','Desconhecido') NULL,
  doenca_renal            ENUM('Sim','Não','Desconhecido') NULL,
  imunodepressao          ENUM('Sim','Não','Desconhecido') NULL,
  obesidade               ENUM('Sim','Não','Desconhecido') NULL,
  outros_fatores_de_risco ENUM('Sim','Não','Desconhecido') NULL,
  pneumopatia             ENUM('Sim','Não','Desconhecido') NULL,
  puerpera                ENUM('Sim','Não','Desconhecido') NULL,
  sindrome_de_down        ENUM('Sim','Não','Desconhecido') NULL,

  ano_sintomas         SMALLINT UNSIGNED NULL,
  mes_sintomas         TINYINT  UNSIGNED NULL,

  CONSTRAINT pk_caso PRIMARY KEY (id),
  CONSTRAINT fk_caso_municipio
      FOREIGN KEY (codigo_ibge) REFERENCES municipio (codigo_ibge)
      ON UPDATE CASCADE
      ON DELETE SET NULL
);

CREATE INDEX idx_caso_municipio ON caso (codigo_ibge);
CREATE INDEX idx_caso_data      ON caso (data_inicio_sintomas);
CREATE INDEX idx_caso_ano_mes   ON caso (ano_sintomas, mes_sintomas);