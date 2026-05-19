
import os
import pandas as pd

PASTA_PROJETO = "/content/fase-2"
PASTA_BRUTOS = os.path.join(PASTA_PROJETO, "dados", "brutos")
PASTA_TRATADOS = os.path.join(PASTA_PROJETO, "dados", "tratados")

os.makedirs(PASTA_TRATADOS, exist_ok=True)

caminho_ipca_bruto = os.path.join(PASTA_BRUTOS, "ipca_alimentos_bruto.csv")
caminho_renda_bruto = os.path.join(PASTA_BRUTOS, "rendimento_real_bruto.csv")

ipca_bruto = pd.read_csv(caminho_ipca_bruto)
renda_bruto = pd.read_csv(caminho_renda_bruto)


def tratar_ipca_alimentos(df):
    df = df.copy()

    coluna_valor = [col for col in df.columns if "VALUE" in col.upper()][0]

    df_tratado = pd.DataFrame({
        "data_referencia": pd.to_datetime(df["DATE"], errors="coerce"),
        "ano": pd.to_numeric(df["YEAR"], errors="coerce").astype("Int64"),
        "mes": pd.to_numeric(df["MONTH"], errors="coerce").astype("Int64"),
        "codigo_serie": df["CODE"],
        "ipca_alimentos_variacao_mensal_pct": pd.to_numeric(df[coluna_valor], errors="coerce")
    })

    linhas_antes = len(df_tratado)

    df_tratado = df_tratado.dropna(subset=[
        "data_referencia",
        "ipca_alimentos_variacao_mensal_pct"
    ])

    df_tratado = df_tratado.drop_duplicates()
    df_tratado = df_tratado.sort_values("data_referencia").reset_index(drop=True)

    linhas_depois = len(df_tratado)

    resumo = {
        "base": "ipca_alimentos",
        "linhas_antes": linhas_antes,
        "linhas_depois": linhas_depois,
        "linhas_removidas": linhas_antes - linhas_depois,
        "criterio_limpeza": "Remoção de registros sem data ou sem valor de variação mensal; padronização de colunas e tipos."
    }

    return df_tratado, resumo


def tratar_rendimento_real(df):
    df = df.copy()

    coluna_valor = [col for col in df.columns if "VALUE" in col.upper()][0]

    df_padronizado = pd.DataFrame({
        "data_referencia": pd.to_datetime(df["DATE"], errors="coerce"),
        "ano": pd.to_numeric(df["YEAR"], errors="coerce").astype("Int64"),
        "mes": pd.to_numeric(df["MONTH"], errors="coerce").astype("Int64"),
        "codigo_serie": df["CODE"],
        "rendimento_real_reais": pd.to_numeric(df[coluna_valor], errors="coerce")
    })

    linhas_antes = len(df_padronizado)

    df_padronizado = df_padronizado.dropna(subset=[
        "data_referencia",
        "rendimento_real_reais"
    ])

    df_sem_duplicatas = df_padronizado.drop_duplicates()

    df_tratado = (
        df_sem_duplicatas
        .groupby("data_referencia", as_index=False)
        .agg(
            ano=("ano", "first"),
            mes=("mes", "first"),
            codigo_serie=("codigo_serie", "first"),
            rendimento_real_medio_reais=("rendimento_real_reais", "mean"),
            quantidade_registros_agregados=("rendimento_real_reais", "count")
        )
        .sort_values("data_referencia")
        .reset_index(drop=True)
    )

    linhas_depois = len(df_tratado)

    resumo = {
        "base": "rendimento_real",
        "linhas_antes": linhas_antes,
        "linhas_depois": linhas_depois,
        "linhas_removidas_ou_agregadas": linhas_antes - linhas_depois,
        "criterio_limpeza": "Remoção de duplicidades exatas e agregação mensal pela média, devido à existência de múltiplos registros por data sem coluna explícita de recorte."
    }

    return df_tratado, resumo


ipca_tratado, resumo_ipca = tratar_ipca_alimentos(ipca_bruto)
renda_tratado, resumo_renda = tratar_rendimento_real(renda_bruto)

resumo_limpeza = pd.DataFrame([resumo_ipca, resumo_renda])

ipca_tratado.to_csv(
    os.path.join(PASTA_TRATADOS, "ipca_alimentos_tratado.csv"),
    index=False,
    encoding="utf-8-sig"
)

renda_tratado.to_csv(
    os.path.join(PASTA_TRATADOS, "rendimento_real_tratado.csv"),
    index=False,
    encoding="utf-8-sig"
)

resumo_limpeza.to_csv(
    os.path.join(PASTA_TRATADOS, "resumo_limpeza_padronizacao.csv"),
    index=False,
    encoding="utf-8-sig"
)

print("Limpeza e padronização concluídas.")
