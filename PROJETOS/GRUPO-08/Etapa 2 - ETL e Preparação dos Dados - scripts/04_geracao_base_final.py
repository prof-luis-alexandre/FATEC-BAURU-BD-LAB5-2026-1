
import os
import pandas as pd
import numpy as np

PASTA_PROJETO = "/content/fase-2"
PASTA_TRATADOS = os.path.join(PASTA_PROJETO, "dados", "tratados")
PASTA_DICIONARIO = os.path.join(PASTA_PROJETO, "dados", "dicionario_dados")

os.makedirs(PASTA_DICIONARIO, exist_ok=True)

caminho_ipca = os.path.join(PASTA_TRATADOS, "ipca_alimentos_tratado.csv")
caminho_renda = os.path.join(PASTA_TRATADOS, "rendimento_real_tratado.csv")

ipca = pd.read_csv(caminho_ipca)
renda = pd.read_csv(caminho_renda)

ipca["data_referencia"] = pd.to_datetime(ipca["data_referencia"])
renda["data_referencia"] = pd.to_datetime(renda["data_referencia"])

# Identificação do trimestre em cada base
ipca["ano"] = ipca["data_referencia"].dt.year
ipca["trimestre"] = ipca["data_referencia"].dt.quarter

renda["ano"] = renda["data_referencia"].dt.year
renda["trimestre"] = renda["data_referencia"].dt.quarter

# Conversão do IPCA mensal para IPCA acumulado trimestral.
# Fórmula:
# ((1 + taxa_mes_1/100) * (1 + taxa_mes_2/100) * (1 + taxa_mes_3/100) - 1) * 100
ipca_trimestral = (
    ipca
    .groupby(["ano", "trimestre"], as_index=False)
    .agg(
        ipca_alimentos_acumulado_trimestre_pct=(
            "ipca_alimentos_variacao_mensal_pct",
            lambda x: (np.prod(1 + x / 100) - 1) * 100
        ),
        quantidade_meses_ipca_no_trimestre=(
            "ipca_alimentos_variacao_mensal_pct",
            "count"
        )
    )
)

# A série de rendimento está referenciada nos meses iniciais dos trimestres:
# 1º tri = janeiro, 2º tri = abril, 3º tri = julho, 4º tri = outubro
mes_inicio_trimestre = {
    1: 1,
    2: 4,
    3: 7,
    4: 10
}

ipca_trimestral["mes"] = ipca_trimestral["trimestre"].map(mes_inicio_trimestre)

ipca_trimestral["data_referencia"] = pd.to_datetime(
    ipca_trimestral["ano"].astype(str)
    + "-"
    + ipca_trimestral["mes"].astype(str).str.zfill(2)
    + "-01"
)

# Consolidação entre IPCA acumulado trimestral e rendimento real trimestral
base_final = pd.merge(
    ipca_trimestral,
    renda,
    on=["data_referencia", "ano", "mes", "trimestre"],
    how="inner"
)

base_final = base_final.sort_values("data_referencia").reset_index(drop=True)

# Variação trimestral do rendimento real
base_final["rendimento_real_variacao_trimestral_pct"] = (
    base_final["rendimento_real_medio_reais"]
    .pct_change()
    .mul(100)
)

# Indicador corrigido
base_final["indicador_pressao_alimentar"] = (
    base_final["ipca_alimentos_acumulado_trimestre_pct"]
    - base_final["rendimento_real_variacao_trimestral_pct"]
)

def classificar_pressao(valor):
    if pd.isna(valor):
        return "sem_classificacao"
    if valor >= 1:
        return "alta_pressao"
    if valor > 0:
        return "pressao_moderada"
    return "sem_pressao"

base_final["classificacao_pressao"] = base_final["indicador_pressao_alimentar"].apply(classificar_pressao)

base_final = base_final[
    [
        "data_referencia",
        "ano",
        "trimestre",
        "mes",
        "ipca_alimentos_acumulado_trimestre_pct",
        "quantidade_meses_ipca_no_trimestre",
        "rendimento_real_medio_reais",
        "rendimento_real_variacao_trimestral_pct",
        "indicador_pressao_alimentar",
        "classificacao_pressao",
        "quantidade_registros_agregados"
    ]
]

base_final.to_csv(
    os.path.join(PASTA_TRATADOS, "base_consolidada_pressao_alimentar.csv"),
    index=False,
    encoding="utf-8-sig"
)

dicionario = pd.DataFrame([
    {
        "coluna": "data_referencia",
        "tipo": "data",
        "descricao": "Data de referência do período trimestral."
    },
    {
        "coluna": "ano",
        "tipo": "inteiro",
        "descricao": "Ano da observação."
    },
    {
        "coluna": "trimestre",
        "tipo": "inteiro",
        "descricao": "Trimestre da observação, variando de 1 a 4."
    },
    {
        "coluna": "mes",
        "tipo": "inteiro",
        "descricao": "Mês inicial do trimestre usado como referência: janeiro, abril, julho ou outubro."
    },
    {
        "coluna": "ipca_alimentos_acumulado_trimestre_pct",
        "tipo": "decimal",
        "descricao": "Variação acumulada do IPCA de alimentos e bebidas no trimestre, em percentual."
    },
    {
        "coluna": "quantidade_meses_ipca_no_trimestre",
        "tipo": "inteiro",
        "descricao": "Quantidade de meses usados no cálculo do IPCA acumulado trimestral."
    },
    {
        "coluna": "rendimento_real_medio_reais",
        "tipo": "decimal",
        "descricao": "Valor médio do rendimento real no período de referência, em reais."
    },
    {
        "coluna": "rendimento_real_variacao_trimestral_pct",
        "tipo": "decimal",
        "descricao": "Variação percentual do rendimento real em relação ao período trimestral anterior."
    },
    {
        "coluna": "indicador_pressao_alimentar",
        "tipo": "decimal",
        "descricao": "Diferença entre o IPCA de alimentos acumulado no trimestre e a variação trimestral do rendimento real."
    },
    {
        "coluna": "classificacao_pressao",
        "tipo": "texto",
        "descricao": "Classificação interpretativa do indicador: sem_classificacao, sem_pressao, pressao_moderada ou alta_pressao."
    },
    {
        "coluna": "quantidade_registros_agregados",
        "tipo": "inteiro",
        "descricao": "Quantidade de registros usados na média do rendimento real."
    }
])

dicionario.to_csv(
    os.path.join(PASTA_DICIONARIO, "dicionario_base_consolidada.csv"),
    index=False,
    encoding="utf-8-sig"
)

contagens = base_final["classificacao_pressao"].value_counts().to_dict()

texto_base_final = f"""
RESUMO DA BASE CONSOLIDADA — PRESSÃO ALIMENTAR

A base final consolidada possui {len(base_final)} registros trimestrais, cobrindo o período comum entre as séries de IPCA alimentos e rendimento real.

Período da base:
- Data mínima: {base_final["data_referencia"].min().date()}
- Data máxima: {base_final["data_referencia"].max().date()}

Periodicidade:

A série de IPCA alimentos possui periodicidade mensal. Porém, a série de rendimento real utilizada possui periodicidade trimestral. Para manter coerência temporal na comparação, o IPCA mensal foi convertido para variação acumulada trimestral antes da consolidação final.

Classificação do indicador de pressão alimentar:
- sem_pressao: {contagens.get("sem_pressao", 0)} períodos
- alta_pressao: {contagens.get("alta_pressao", 0)} períodos
- pressao_moderada: {contagens.get("pressao_moderada", 0)} períodos
- sem_classificacao: {contagens.get("sem_classificacao", 0)} período

Interpretação:

O indicador compara a variação acumulada do IPCA de alimentos no trimestre com a variação trimestral do rendimento real.

Quando o indicador é positivo, os alimentos ficaram relativamente mais pressionados em relação à renda naquele período. Quando é negativo ou igual a zero, a variação da renda acompanhou ou superou a variação acumulada dos alimentos.

A primeira linha ficou sem classificação porque o cálculo da variação do rendimento depende do período anterior.

Observação metodológica:

O indicador de pressão alimentar foi calculado como a diferença entre o IPCA de alimentos acumulado no trimestre e a variação trimestral do rendimento real. Trata-se de um indicador simplificado, criado para fins acadêmicos e extensionistas, com o objetivo de tornar a relação entre custo dos alimentos e renda mais compreensível para a sociedade.
"""

with open(
    os.path.join(PASTA_TRATADOS, "resumo_base_consolidada.txt"),
    "w",
    encoding="utf-8"
) as arquivo:
    arquivo.write(texto_base_final)

print("Base consolidada, dicionário e resumo atualizados.")
print("Linhas:", len(base_final))
print("Data mínima:", base_final["data_referencia"].min())
print("Data máxima:", base_final["data_referencia"].max())
print(base_final["classificacao_pressao"].value_counts())
