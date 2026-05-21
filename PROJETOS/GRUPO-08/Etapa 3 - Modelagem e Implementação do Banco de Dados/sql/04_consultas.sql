-- 1. Maiores períodos de pressão alimentar
SELECT 
    ano,
    trimestre,
    data_inicio,
    data_fim,
    ipca_alimentos_acumulado_trimestre_pct,
    rendimento_real_variacao_trimestral_pct,
    indicador_pressao_alimentar,
    classificacao_pressao
FROM vw_pressao_alimentar_trimestral
ORDER BY indicador_pressao_alimentar DESC
LIMIT 10;


-- 2. Quantidade de períodos por classificação
SELECT 
    classificacao_pressao,
    COUNT(*) AS quantidade_periodos
FROM vw_pressao_alimentar_trimestral
GROUP BY classificacao_pressao
ORDER BY quantidade_periodos DESC;


-- 3. Evolução histórica do indicador
SELECT 
    ano,
    trimestre,
    indicador_pressao_alimentar,
    classificacao_pressao
FROM vw_pressao_alimentar_trimestral
ORDER BY ano, trimestre;


-- 4. Períodos classificados como alta pressão
SELECT 
    ano,
    trimestre,
    data_inicio,
    data_fim,
    ipca_alimentos_acumulado_trimestre_pct,
    rendimento_real_variacao_trimestral_pct,
    indicador_pressao_alimentar
FROM vw_pressao_alimentar_trimestral
WHERE classificacao_pressao = 'alta_pressao'
ORDER BY ano, trimestre;


-- 5. Média anual do indicador de pressão alimentar
SELECT
    ano,
    ROUND(AVG(indicador_pressao_alimentar), 4) AS media_anual_indicador
FROM vw_pressao_alimentar_trimestral
WHERE indicador_pressao_alimentar IS NOT NULL
GROUP BY ano
ORDER BY ano;


-- 6. Períodos em que a renda variou mais que o IPCA de alimentos acumulado
SELECT
    ano,
    trimestre,
    ipca_alimentos_acumulado_trimestre_pct,
    rendimento_real_variacao_trimestral_pct,
    indicador_pressao_alimentar,
    classificacao_pressao
FROM vw_pressao_alimentar_trimestral
WHERE indicador_pressao_alimentar <= 0
ORDER BY ano, trimestre;