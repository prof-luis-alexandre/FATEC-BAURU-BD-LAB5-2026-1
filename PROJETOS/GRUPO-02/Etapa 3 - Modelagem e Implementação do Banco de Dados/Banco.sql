/* Lógico_1: */

CREATE TABLE Dim_tempo (
    id_tempo INTEGER PRIMARY KEY UNIQUE,
    data_inicio_semana DATE,
    semana_epidemiologica INTEGER
);

CREATE TABLE Dim_localidade (
    id_localidade INTEGER PRIMARY KEY UNIQUE,
    codigo_ibge VARCHAR,
    municipio VARCHAR
);

CREATE TABLE Dim_Saneamento (
    id_saneamento INTEGER PRIMARY KEY UNIQUE,
    total_domicilios INTEGER,
    rede_adequada_total INTEGER,
    rede_geral_esgoto INTEGER,
    fossa_ligada_rede INTEGER,
    fossa_nao_ligada INTEGER,
    fossa_rudimentar INTEGER,
    esgoto_vala INTEGER,
    esgoto_rio_lago INTEGER,
    esgoto_outros INTEGER,
    sem_banheiro INTEGER
);

CREATE TABLE Fato_notificacao (
    id_registro INTEGER PRIMARY KEY UNIQUE,
    id_localidade INTEGER,
    id_tempo INTEGER,
    id_saneamento INTEGER,
    casos_notificados INTEGER,
    casos_estimados FLOAT,
    temperatura_media FLOAT,
    umidade_media FLOAT,
    nivel_incidencia INTEGER
);

ALTER TABLE Fato_notificacao ADD CONSTRAINT FK_Fato_notificacao_3
    FOREIGN KEY (id_localidade???, id_tempo???, id_saneamento???)
    REFERENCES ??? (???);


--INSERÇÃO DE DADOS
-- 1. Populando a Dimissão Tempo (Agora com aspas duplas em "data_iniSE" e "SE")
INSERT INTO Dim_tempo (data_inicio_semana, semana_epidemiologica)
SELECT DISTINCT 
    CAST("data_iniSE" AS DATE), 
    CAST("SE" AS INTEGER)
FROM stg_dengue;

-- 2. Populando a Dimissão Localidade
INSERT INTO Dim_localidade (codigo_ibge, municipio)
SELECT DISTINCT 
    '3506003', 
    'Bauru'
FROM stg_dengue;

-- 3. Populando a Dimissão Saneamento (Aqui os nomes vieram todos minúsculos do nosso ETL, então não dá problema)
INSERT INTO Dim_Saneamento (
    total_domicilios, rede_adequada_total, rede_geral_esgoto, 
    fossa_ligada_rede, fossa_nao_ligada, fossa_rudimentar, 
    esgoto_vala, esgoto_rio_lago, esgoto_outros, sem_banheiro
)
SELECT 
    CAST(total_domicilios AS INTEGER), CAST(rede_adequada_total AS INTEGER), 
    CAST(rede_geral_esgoto AS INTEGER), CAST(fossa_ligada_rede AS INTEGER), 
    CAST(fossa_nao_ligada AS INTEGER), CAST(fossa_rudimentar AS INTEGER), 
    CAST(esgoto_vala AS INTEGER), CAST(esgoto_rio_lago AS INTEGER), 
    CAST(esgoto_outros AS INTEGER), CAST(sem_banheiro AS INTEGER)
FROM stg_saneamento;


INSERT INTO Fato_notificacao (
    id_localidade, 
    id_tempo, 
    id_saneamento, 
    casos_notificados, 
    casos_estimados, 
    temperatura_media, 
    umidade_media, 
    nivel_incidencia
)
SELECT 
    l.id_localidade,
    t.id_tempo,
    s.id_saneamento,
    CAST(d."casos" AS INTEGER),
    CAST(d."casos_est" AS FLOAT),
    CAST(d."tempmed" AS FLOAT),
    CAST(d."umidmed" AS FLOAT),
    CAST(d."nivel_inc" AS INTEGER)
FROM stg_dengue d
JOIN Dim_tempo t ON t.data_inicio_semana = CAST(d."data_iniSE" AS DATE)
JOIN Dim_localidade l ON l.municipio = 'Bauru'
JOIN Dim_Saneamento s ON s.id_saneamento = l.id_localidade;