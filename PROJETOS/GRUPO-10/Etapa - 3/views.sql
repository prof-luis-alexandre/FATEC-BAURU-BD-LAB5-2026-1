-- =====================================================================
--  VIEWS - DASHBOARD COVID-19
-- =====================================================================

-- =====================================================================
--  BLOCO A — INDICADORES GERAIS (KPIs)
-- =====================================================================

-- A1. Números-chave do topo do dashboard.
CREATE OR REPLACE VIEW vw_kpis AS
SELECT
    COUNT(*)                                      AS total_casos,
    SUM(obito = 'Sim')                            AS total_obitos,
    ROUND(100 * SUM(obito = 'Sim') / COUNT(*), 2) AS letalidade_pct,
    COUNT(DISTINCT codigo_ibge)                   AS municipios_com_casos,
    MIN(data_inicio_sintomas)                     AS primeiro_sintoma,
    MAX(data_inicio_sintomas)                     AS ultimo_sintoma
FROM caso;


-- =====================================================================
--  BLOCO B — SÉRIE TEMPORAL
-- =====================================================================

-- B1. Casos e óbitos por ANO.
CREATE OR REPLACE VIEW vw_casos_por_ano AS
SELECT
    ano_sintomas                                  AS ano,
    COUNT(*)                                      AS casos,
    SUM(obito = 'Sim')                            AS obitos,
    ROUND(100 * SUM(obito = 'Sim') / COUNT(*), 2) AS letalidade_pct
FROM caso
WHERE ano_sintomas IS NOT NULL
GROUP BY ano_sintomas;

-- B2. Série MENSAL (ano + mês) — ideal para gráfico de linha.
CREATE OR REPLACE VIEW vw_serie_mensal AS
SELECT
    ano_sintomas AS ano,
    mes_sintomas AS mes,
    LPAD(mes_sintomas, 2, '0')                          AS mes_2dig,
    CONCAT(ano_sintomas, '-', LPAD(mes_sintomas,2,'0')) AS ano_mes,
    COUNT(*)           AS casos,
    SUM(obito = 'Sim') AS obitos
FROM caso
WHERE ano_sintomas IS NOT NULL AND mes_sintomas IS NOT NULL
GROUP BY ano_sintomas, mes_sintomas;

-- B3. Meses de pico (Top 10 meses com mais casos).
CREATE OR REPLACE VIEW vw_meses_pico AS
SELECT
    CONCAT(ano_sintomas, '-', LPAD(mes_sintomas,2,'0')) AS ano_mes,
    COUNT(*) AS casos
FROM caso
WHERE ano_sintomas IS NOT NULL AND mes_sintomas IS NOT NULL
GROUP BY ano_sintomas, mes_sintomas
ORDER BY casos DESC
LIMIT 10;


-- =====================================================================
--  BLOCO C — ANÁLISE GEOGRÁFICA (mapa / ranking de municípios)
-- =====================================================================

-- vw_por_municipio: BASE com TODOS os municípios (casos, óbitos,
-- letalidade). Use esta no mapa e deixe o Power BI ordenar/filtrar.
CREATE OR REPLACE VIEW vw_por_municipio AS
SELECT
    m.codigo_ibge,
    m.nome_municipio,
    COUNT(*)                                  AS casos,
    SUM(c.obito='Sim')                        AS obitos,
    ROUND(100*SUM(c.obito='Sim')/COUNT(*), 2) AS letalidade_pct
FROM caso c
JOIN municipio m ON m.codigo_ibge = c.codigo_ibge
GROUP BY m.codigo_ibge, m.nome_municipio;

-- C1. Top 15 municípios por número de CASOS.
CREATE OR REPLACE VIEW vw_top15_municipios_casos AS
SELECT
    m.nome_municipio,
    COUNT(*)           AS casos,
    SUM(c.obito='Sim') AS obitos
FROM caso c
JOIN municipio m ON m.codigo_ibge = c.codigo_ibge
GROUP BY m.codigo_ibge, m.nome_municipio
ORDER BY casos DESC
LIMIT 15;

-- C2. Top 15 municípios por número de ÓBITOS.
CREATE OR REPLACE VIEW vw_top15_municipios_obitos AS
SELECT
    m.nome_municipio,
    SUM(c.obito='Sim')                        AS obitos,
    COUNT(*)                                  AS casos,
    ROUND(100*SUM(c.obito='Sim')/COUNT(*), 2) AS letalidade_pct
FROM caso c
JOIN municipio m ON m.codigo_ibge = c.codigo_ibge
GROUP BY m.codigo_ibge, m.nome_municipio
ORDER BY obitos DESC
LIMIT 15;

-- C3. Municípios com MAIOR LETALIDADE (mínimo de 30 casos).
CREATE OR REPLACE VIEW vw_municipios_letalidade AS
SELECT
    m.nome_municipio,
    COUNT(*)                                  AS casos,
    SUM(c.obito='Sim')                        AS obitos,
    ROUND(100*SUM(c.obito='Sim')/COUNT(*), 2) AS letalidade_pct
FROM caso c
JOIN municipio m ON m.codigo_ibge = c.codigo_ibge
GROUP BY m.codigo_ibge, m.nome_municipio
HAVING casos >= 30
ORDER BY letalidade_pct DESC
LIMIT 15;

-- C4. Ranking completo de municípios por casos (função de janela).
CREATE OR REPLACE VIEW vw_ranking_municipios AS
SELECT
    RANK() OVER (ORDER BY COUNT(*) DESC) AS posicao,
    m.nome_municipio,
    COUNT(*)                             AS casos
FROM caso c
JOIN municipio m ON m.codigo_ibge = c.codigo_ibge
GROUP BY m.codigo_ibge, m.nome_municipio;


-- =====================================================================
--  BLOCO D — PERFIL DEMOGRÁFICO
-- =====================================================================

-- D1. Casos, óbitos e letalidade por SEXO.
CREATE OR REPLACE VIEW vw_por_sexo AS
SELECT
    cs_sexo,
    COUNT(*)                                AS casos,
    SUM(obito='Sim')                        AS obitos,
    ROUND(100*SUM(obito='Sim')/COUNT(*), 2) AS letalidade_pct
FROM caso
GROUP BY cs_sexo;

-- D2. Casos, óbitos e letalidade por FAIXA ETÁRIA (decadal).
--     A coluna ordem_faixa serve para ordenar corretamente no Power BI.
CREATE OR REPLACE VIEW vw_por_faixa_etaria AS
SELECT
    CASE
        WHEN idade IS NULL THEN 'Não informado'
        WHEN idade < 10  THEN '0-9'
        WHEN idade < 20  THEN '10-19'
        WHEN idade < 30  THEN '20-29'
        WHEN idade < 40  THEN '30-39'
        WHEN idade < 50  THEN '40-49'
        WHEN idade < 60  THEN '50-59'
        WHEN idade < 70  THEN '60-69'
        WHEN idade < 80  THEN '70-79'
        ELSE '80+'
    END                                     AS faixa_etaria,
    COALESCE(LEAST(FLOOR(idade/10), 8), 99)  AS ordem_faixa,
    COUNT(*)                                AS casos,
    SUM(obito='Sim')                        AS obitos,
    ROUND(100*SUM(obito='Sim')/COUNT(*), 2) AS letalidade_pct
FROM caso
GROUP BY faixa_etaria, ordem_faixa;

-- D3. Idade média: geral x óbitos x sobreviventes.
CREATE OR REPLACE VIEW vw_idade_media AS
SELECT
    ROUND(AVG(idade), 1)                                AS idade_media_geral,
    ROUND(AVG(CASE WHEN obito='Sim' THEN idade END), 1) AS idade_media_obitos,
    ROUND(AVG(CASE WHEN obito='Não' THEN idade END), 1) AS idade_media_sobreviventes
FROM caso;


-- =====================================================================
--  BLOCO E — FATORES DE RISCO / COMORBIDADES
-- =====================================================================

-- E1. Uma linha por fator de risco: casos com o fator, óbitos e letalidade.
CREATE OR REPLACE VIEW vw_fatores_risco AS
SELECT 'Asma'                AS fator_risco, COUNT(*) AS casos_com_fator, SUM(obito='Sim') AS obitos, ROUND(100*SUM(obito='Sim')/COUNT(*),2) AS letalidade_pct FROM caso WHERE asma='Sim'
UNION ALL SELECT 'Cardiopatia',            COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE cardiopatia='Sim'
UNION ALL SELECT 'Diabetes',               COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE diabetes='Sim'
UNION ALL SELECT 'Doença hematológica',    COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE doenca_hematologica='Sim'
UNION ALL SELECT 'Doença hepática',        COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE doenca_hepatica='Sim'
UNION ALL SELECT 'Doença neurológica',     COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE doenca_neurologica='Sim'
UNION ALL SELECT 'Doença renal',           COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE doenca_renal='Sim'
UNION ALL SELECT 'Imunodepressão',         COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE imunodepressao='Sim'
UNION ALL SELECT 'Obesidade',              COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE obesidade='Sim'
UNION ALL SELECT 'Outros fatores',         COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE outros_fatores_de_risco='Sim'
UNION ALL SELECT 'Pneumopatia',            COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE pneumopatia='Sim'
UNION ALL SELECT 'Puérpera',               COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE puerpera='Sim'
UNION ALL SELECT 'Síndrome de Down',       COUNT(*), SUM(obito='Sim'), ROUND(100*SUM(obito='Sim')/COUNT(*),2) FROM caso WHERE sindrome_de_down='Sim';

-- E2. Letalidade COM x SEM pelo menos um fator de risco conhecido.
CREATE OR REPLACE VIEW vw_com_sem_fator_risco AS
SELECT
    CASE WHEN (asma='Sim' OR cardiopatia='Sim' OR diabetes='Sim'
            OR doenca_hematologica='Sim' OR doenca_hepatica='Sim'
            OR doenca_neurologica='Sim' OR doenca_renal='Sim'
            OR imunodepressao='Sim' OR obesidade='Sim'
            OR outros_fatores_de_risco='Sim' OR pneumopatia='Sim'
            OR puerpera='Sim' OR sindrome_de_down='Sim')
         THEN 'Com fator de risco'
         ELSE 'Sem fator de risco conhecido'
    END                                     AS grupo,
    COUNT(*)                                AS casos,
    SUM(obito='Sim')                        AS obitos,
    ROUND(100*SUM(obito='Sim')/COUNT(*), 2) AS letalidade_pct
FROM caso
GROUP BY grupo;


-- =====================================================================
--  BLOCO F — CRUZAMENTOS
-- =====================================================================

-- F1. Letalidade por FAIXA ETÁRIA x SEXO (heatmap / matriz).
CREATE OR REPLACE VIEW vw_faixa_x_sexo AS
SELECT
    CASE
        WHEN idade IS NULL THEN 'Não informado'
        WHEN idade < 20 THEN '0-19'
        WHEN idade < 40 THEN '20-39'
        WHEN idade < 60 THEN '40-59'
        WHEN idade < 80 THEN '60-79'
        ELSE '80+'
    END                                     AS faixa_etaria,
    cs_sexo,
    COUNT(*)                                AS casos,
    SUM(obito='Sim')                        AS obitos,
    ROUND(100*SUM(obito='Sim')/COUNT(*), 2) AS letalidade_pct
FROM caso
GROUP BY faixa_etaria, cs_sexo;