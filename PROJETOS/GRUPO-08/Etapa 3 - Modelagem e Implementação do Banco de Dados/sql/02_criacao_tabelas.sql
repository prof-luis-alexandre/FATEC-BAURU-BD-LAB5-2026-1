DROP TABLE IF EXISTS indicador_pressao_alimentar CASCADE;
DROP TABLE IF EXISTS observacao_serie CASCADE;
DROP TABLE IF EXISTS serie_economica CASCADE;
DROP TABLE IF EXISTS fonte_dados CASCADE;
DROP TABLE IF EXISTS periodo CASCADE;
DROP TABLE IF EXISTS staging_base_pressao_alimentar CASCADE;

CREATE TABLE fonte_dados (
    id_fonte SERIAL PRIMARY KEY,
    nome_fonte VARCHAR(100) NOT NULL,
    orgao_responsavel VARCHAR(150),
    url_fonte TEXT,
    metodo_acesso VARCHAR(100),
    data_coleta DATE,
    observacao TEXT
);

CREATE TABLE serie_economica (
    id_serie SERIAL PRIMARY KEY,
    id_fonte INTEGER NOT NULL REFERENCES fonte_dados(id_fonte),
    codigo_serie VARCHAR(50),
    nome_serie VARCHAR(200) NOT NULL,
    descricao TEXT,
    unidade_medida VARCHAR(100),
    periodicidade_original VARCHAR(50),
    tema VARCHAR(100)
);

CREATE TABLE periodo (
    id_periodo SERIAL PRIMARY KEY,
    ano INTEGER NOT NULL,
    trimestre INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    CONSTRAINT uq_periodo UNIQUE (ano, trimestre),
    CONSTRAINT ck_trimestre CHECK (trimestre BETWEEN 1 AND 4)
);

CREATE TABLE observacao_serie (
    id_observacao SERIAL PRIMARY KEY,
    id_serie INTEGER NOT NULL REFERENCES serie_economica(id_serie),
    id_periodo INTEGER NOT NULL REFERENCES periodo(id_periodo),
    valor NUMERIC(12,4) NOT NULL,
    tipo_valor VARCHAR(100) NOT NULL,
    observacao TEXT,
    CONSTRAINT uq_observacao_serie UNIQUE (id_serie, id_periodo, tipo_valor)
);

CREATE TABLE indicador_pressao_alimentar (
    id_indicador SERIAL PRIMARY KEY,
    id_periodo INTEGER NOT NULL UNIQUE REFERENCES periodo(id_periodo),
    ipca_alimentos_acumulado_trimestre_pct NUMERIC(12,4) NOT NULL,
    rendimento_real_medio_reais NUMERIC(12,4),
    rendimento_real_variacao_trimestral_pct NUMERIC(12,4),
    indicador_pressao_alimentar NUMERIC(12,4),
    classificacao_pressao VARCHAR(50) NOT NULL,
    interpretacao TEXT
);

CREATE TABLE staging_base_pressao_alimentar (
    data_referencia DATE,
    ano INTEGER,
    trimestre INTEGER,
    mes INTEGER,
    ipca_alimentos_acumulado_trimestre_pct NUMERIC(12,4),
    quantidade_meses_ipca_no_trimestre INTEGER,
    rendimento_real_medio_reais NUMERIC(12,4),
    rendimento_real_variacao_trimestral_pct NUMERIC(12,4),
    indicador_pressao_alimentar NUMERIC(12,4),
    classificacao_pressao VARCHAR(50),
    quantidade_registros_agregados INTEGER
);