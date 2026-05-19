
import os
import pandas as pd

PASTA_PROJETO = "/content/fase-2"
PASTA_BRUTOS = os.path.join(PASTA_PROJETO, "dados", "brutos")
PASTA_TRATADOS = os.path.join(PASTA_PROJETO, "dados", "tratados")

os.makedirs(PASTA_TRATADOS, exist_ok=True)

caminho_ipca = os.path.join(PASTA_BRUTOS, "ipca_alimentos_bruto.csv")
caminho_renda = os.path.join(PASTA_BRUTOS, "rendimento_real_bruto.csv")

ipca = pd.read_csv(caminho_ipca)
renda = pd.read_csv(caminho_renda)


def diagnosticar_base(df, nome_base):
    diagnostico = {
        "base": nome_base,
        "quantidade_linhas": len(df),
        "quantidade_colunas": len(df.columns),
        "colunas": ", ".join(df.columns),
        "total_valores_faltantes": int(df.isna().sum().sum()),
        "linhas_duplicadas": int(df.duplicated().sum())
    }

    if "DATE" in df.columns:
        datas_convertidas = pd.to_datetime(df["DATE"], errors="coerce")

        diagnostico["data_minima"] = str(datas_convertidas.min())
        diagnostico["data_maxima"] = str(datas_convertidas.max())
        diagnostico["datas_invalidas"] = int(datas_convertidas.isna().sum())
        diagnostico["datas_duplicadas"] = int(df["DATE"].duplicated().sum())
    else:
        diagnostico["data_minima"] = None
        diagnostico["data_maxima"] = None
        diagnostico["datas_invalidas"] = None
        diagnostico["datas_duplicadas"] = None

    colunas_valor = [col for col in df.columns if "VALUE" in col.upper()]

    if colunas_valor:
        coluna_valor = colunas_valor[0]
        valores = pd.to_numeric(df[coluna_valor], errors="coerce")

        diagnostico["coluna_valor"] = coluna_valor
        diagnostico["valores_invalidos"] = int(valores.isna().sum())
        diagnostico["valor_minimo"] = float(valores.min()) if valores.notna().any() else None
        diagnostico["valor_maximo"] = float(valores.max()) if valores.notna().any() else None
        diagnostico["valores_negativos"] = int((valores < 0).sum())
    else:
        diagnostico["coluna_valor"] = None
        diagnostico["valores_invalidos"] = None
        diagnostico["valor_minimo"] = None
        diagnostico["valor_maximo"] = None
        diagnostico["valores_negativos"] = None

    return diagnostico


def analisar_datas_duplicadas(df):
    if "DATE" not in df.columns:
        return None

    return (
        df.groupby("DATE")
        .size()
        .reset_index(name="quantidade_registros_na_data")
        .sort_values("quantidade_registros_na_data", ascending=False)
    )


diagnosticos = pd.DataFrame([
    diagnosticar_base(ipca, "ipca_alimentos_bruto"),
    diagnosticar_base(renda, "rendimento_real_bruto")
])

diagnosticos.to_csv(
    os.path.join(PASTA_TRATADOS, "diagnostico_qualidade_dados.csv"),
    index=False,
    encoding="utf-8-sig"
)

duplicidade_ipca = analisar_datas_duplicadas(ipca)
duplicidade_renda = analisar_datas_duplicadas(renda)

if duplicidade_ipca is not None:
    duplicidade_ipca.to_csv(
        os.path.join(PASTA_TRATADOS, "duplicidade_datas_ipca.csv"),
        index=False,
        encoding="utf-8-sig"
    )

if duplicidade_renda is not None:
    duplicidade_renda.to_csv(
        os.path.join(PASTA_TRATADOS, "duplicidade_datas_rendimento.csv"),
        index=False,
        encoding="utf-8-sig"
    )

print("Análise inicial concluída.")
