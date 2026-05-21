INSERT INTO fonte_dados (
    nome_fonte,
    orgao_responsavel,
    url_fonte,
    metodo_acesso,
    data_coleta,
    observacao
)
VALUES (
    'IPEAData',
    'Instituto de Pesquisa Econômica Aplicada',
    'https://www.ipeadata.gov.br/',
    'API via Python/ipeadatapy',
    CURRENT_DATE,
    'Fonte pública usada para obtenção das séries de IPCA alimentos e rendimento real.'
);

INSERT INTO serie_economica (
    id_fonte,
    codigo_serie,
    nome_serie,
    descricao,
    unidade_medida,
    periodicidade_original,
    tema
)
VALUES
(
    1,
    'PRECOS12_IPCAAB12',
    'IPCA - alimentos e bebidas',
    'Taxa de variação do grupo alimentos e bebidas do IPCA, convertida para acumulado trimestral na base consolidada.',
    'Percentual',
    'Mensal',
    'Inflação'
),
(
    1,
    'PNADCT_RRETUF',
    'Rendimento médio real',
    'Rendimento médio real de todos os trabalhos efetivo, tratado e utilizado em variação trimestral.',
    'Reais / percentual',
    'Trimestral',
    'Renda'
);

INSERT INTO periodo (
    ano,
    trimestre,
    mes,
    data_inicio,
    data_fim
)
SELECT DISTINCT
    ano,
    trimestre,
    mes,
    data_referencia AS data_inicio,
    CASE
        WHEN trimestre = 1 THEN MAKE_DATE(ano, 3, 31)
        WHEN trimestre = 2 THEN MAKE_DATE(ano, 6, 30)
        WHEN trimestre = 3 THEN MAKE_DATE(ano, 9, 30)
        WHEN trimestre = 4 THEN MAKE_DATE(ano, 12, 31)
    END AS data_fim
FROM staging_base_pressao_alimentar
ORDER BY ano, trimestre;

INSERT INTO observacao_serie (
    id_serie,
    id_periodo,
    valor,
    tipo_valor,
    observacao
)
SELECT
    1 AS id_serie,
    p.id_periodo,
    s.ipca_alimentos_acumulado_trimestre_pct,
    'acumulado_trimestral_pct',
    'IPCA de alimentos acumulado no trimestre por composição das taxas mensais.'
FROM staging_base_pressao_alimentar s
JOIN periodo p
    ON p.ano = s.ano
   AND p.trimestre = s.trimestre;

INSERT INTO observacao_serie (
    id_serie,
    id_periodo,
    valor,
    tipo_valor,
    observacao
)
SELECT
    2 AS id_serie,
    p.id_periodo,
    s.rendimento_real_variacao_trimestral_pct,
    'variacao_trimestral_pct',
    'Variação percentual do rendimento real em relação ao trimestre anterior.'
FROM staging_base_pressao_alimentar s
JOIN periodo p
    ON p.ano = s.ano
   AND p.trimestre = s.trimestre
WHERE s.rendimento_real_variacao_trimestral_pct IS NOT NULL;

INSERT INTO indicador_pressao_alimentar (
    id_periodo,
    ipca_alimentos_acumulado_trimestre_pct,
    rendimento_real_medio_reais,
    rendimento_real_variacao_trimestral_pct,
    indicador_pressao_alimentar,
    classificacao_pressao,
    interpretacao
)
SELECT
    p.id_periodo,
    s.ipca_alimentos_acumulado_trimestre_pct,
    s.rendimento_real_medio_reais,
    s.rendimento_real_variacao_trimestral_pct,
    s.indicador_pressao_alimentar,
    s.classificacao_pressao,
    CASE
        WHEN s.classificacao_pressao = 'alta_pressao'
            THEN 'Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.'
        WHEN s.classificacao_pressao = 'pressao_moderada'
            THEN 'Período em que a variação acumulada dos alimentos ficou acima da variação do rendimento real, mas com diferença menor.'
        WHEN s.classificacao_pressao = 'sem_pressao'
            THEN 'Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.'
        ELSE 'Primeiro período da série, sem classificação por ausência de período anterior para cálculo da variação do rendimento.'
    END AS interpretacao
FROM staging_base_pressao_alimentar s
JOIN periodo p
    ON p.ano = s.ano
   AND p.trimestre = s.trimestre;

   