DROP VIEW IF EXISTS vw_pressao_alimentar_trimestral;

CREATE VIEW vw_pressao_alimentar_trimestral AS
SELECT
    p.ano,
    p.trimestre,
    p.mes,
    p.data_inicio,
    p.data_fim,
    i.ipca_alimentos_acumulado_trimestre_pct,
    i.rendimento_real_medio_reais,
    i.rendimento_real_variacao_trimestral_pct,
    i.indicador_pressao_alimentar,
    i.classificacao_pressao,
    i.interpretacao
FROM indicador_pressao_alimentar i
JOIN periodo p 
    ON p.id_periodo = i.id_periodo;


--------
SELECT *
FROM vw_pressao_alimentar_trimestral
ORDER BY ano, trimestre
LIMIT 10;