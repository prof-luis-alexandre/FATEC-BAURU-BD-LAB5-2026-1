-- ============================================================================
-- PROJETO: Transparência Parlamentar Cívica (CEAP)
-- ETAPA: Banco de Dados Relacional Estruturado e Normalizado
-- AUTORES: Davi Ballielo Galvani, Augusto Bueno de Almeida, João Carlos Scheffer Junior
-- SGBD: SQLite3
-- ============================================================================

-- Habilita o suporte a chaves estrangeiras no SQLite
-- Nota: Deve ser executado em toda nova conexão pelo driver da aplicação
PRAGMA foreign_keys = ON;

-- ----------------------------------------------------------------------------
-- 1. TABELAS DE DIMENSÕES 
-- ----------------------------------------------------------------------------

-- Tabela: partido
CREATE TABLE IF NOT EXISTS partido (
    sigla VARCHAR(10) PRIMARY KEY,
    uri TEXT
);

-- Tabela: estado (UF)
CREATE TABLE IF NOT EXISTS estado (
    sigla CHAR(2) PRIMARY KEY
);

-- Tabela: deputado
CREATE TABLE IF NOT EXISTS deputado (
    id INTEGER PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    url_foto VARCHAR(255),
    sigla_partido VARCHAR(10),
    sigla_uf CHAR(2),
    id_legislatura INTEGER,
    uri TEXT,
    FOREIGN KEY (sigla_partido) REFERENCES partido(sigla) ON DELETE SET NULL,
    FOREIGN KEY (sigla_uf) REFERENCES estado(sigla) ON DELETE SET NULL
);

-- Tabela: fornecedor
CREATE TABLE IF NOT EXISTS fornecedor (
    cnpj_cpf VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Tabela: tipo_despesa (Categorias de Gastos)
CREATE TABLE IF NOT EXISTS tipo_despesa (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    descricao VARCHAR(255) UNIQUE NOT NULL
);

-- ----------------------------------------------------------------------------
-- 2. TABELA DE FATOS (Lançamentos Contábeis / Notas Fiscais)
-- ----------------------------------------------------------------------------

-- Tabela: despesa
CREATE TABLE IF NOT EXISTS despesa (
    cod_documento VARCHAR(50) PRIMARY KEY,
    deputado_id INTEGER NOT NULL,
    fornecedor_cnpj_cpf VARCHAR(20),
    tipo_despesa_id INTEGER NOT NULL,
    ano INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    tipo_documento VARCHAR(100),
    cod_tipo_documento INTEGER,
    data_documento DATE, -- Armazenado como string ISO8601 (YYYY-MM-DD)
    num_documento VARCHAR(100),
    valor_documento REAL NOT NULL, -- FLOAT 8-bytes para precisão em despesas locais
    valor_liquido REAL NOT NULL,
    valor_glosa REAL DEFAULT 0.0,
    num_ressarcimento VARCHAR(50),
    cod_lote INTEGER,
    parcela INTEGER DEFAULT 0,
    url_documento VARCHAR(500),
    FOREIGN KEY (deputado_id) REFERENCES deputado(id) ON DELETE CASCADE,
    FOREIGN KEY (fornecedor_cnpj_cpf) REFERENCES fornecedor(cnpj_cpf) ON DELETE SET NULL,
    FOREIGN KEY (tipo_despesa_id) REFERENCES tipo_despesa(id) ON DELETE RESTRICT
);

-- ----------------------------------------------------------------------------
-- 3. ÍNDICES DE PERFORMANCE (Otimização de Consultas / BI)
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_deputado_partido ON deputado(sigla_partido);
CREATE INDEX IF NOT EXISTS idx_deputado_uf ON deputado(sigla_uf);
CREATE INDEX IF NOT EXISTS idx_despesa_deputado ON despesa(deputado_id);
CREATE INDEX IF NOT EXISTS idx_despesa_fornecedor ON despesa(fornecedor_cnpj_cpf);
CREATE INDEX IF NOT EXISTS idx_despesa_tipo ON despesa(tipo_despesa_id);
CREATE INDEX IF NOT EXISTS idx_despesa_data ON despesa(data_documento);
CREATE INDEX IF NOT EXISTS idx_despesa_valor ON despesa(valor_liquido);

-- ----------------------------------------------------------------------------
-- 4. VIEW DE TRANSPARÊNCIA CÍVICA (Camada Acessível para a Sociedade)
-- ----------------------------------------------------------------------------
-- Esta view simplifica o acesso ao banco por terceiros, reunindo todos os relacionamentos
-- em um formato tabular idêntico ao original, porém otimizado e saneado.
CREATE VIEW IF NOT EXISTS vw_despesas_completas AS
SELECT 
    d.cod_documento,
    dep.id AS id_deputado,
    dep.nome AS nome_deputado,
    dep.email AS email_deputado,
    dep.url_foto AS foto_deputado,
    dep.sigla_partido,
    dep.sigla_uf,
    dep.id_legislatura,
    f.cnpj_cpf AS fornecedor_cnpj_cpf,
    f.nome AS nome_fornecedor,
    t.descricao AS tipo_despesa,
    d.ano,
    d.mes,
    d.tipo_documento,
    d.cod_tipo_documento,
    d.data_documento,
    d.num_documento,
    d.valor_documento,
    d.valor_liquido,
    d.valor_glosa,
    d.num_ressarcimento,
    d.cod_lote,
    d.parcela,
    d.url_documento
FROM despesa d
LEFT JOIN deputado dep ON d.deputado_id = dep.id
LEFT JOIN fornecedor f ON d.fornecedor_cnpj_cpf = f.cnpj_cpf
LEFT JOIN tipo_despesa t ON d.tipo_despesa_id = t.id;
