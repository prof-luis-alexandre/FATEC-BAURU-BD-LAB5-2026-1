import logging
import pandas as pd

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s | %(levelname)s | %(message)s",
                    datefmt="%H:%M:%S")
log = logging.getLogger("etl")

# As 13 colunas de comorbidade (SIM / NÃO / IGNORADO)
COMORBIDADES = [
    "asma", "cardiopatia", "diabetes", "doenca_hematologica",
    "doenca_hepatica", "doenca_neurologica", "doenca_renal",
    "imunodepressao", "obesidade", "outros_fatores_de_risco",
    "pneumopatia", "puerpera", "sindrome_de_down",
]

# --------------------------------------------------------------------------- #
# 1. Extração
# --------------------------------------------------------------------------- #
log.info("Lendo %s", "casos-covid.csv")
df = pd.read_csv("casos-covid.csv", sep=";", na_values=["NA"])
log.info("Registros lidos: %d | Colunas: %d", len(df), df.shape[1])

# --------------------------------------------------------------------------- #
# 2. Análise rápida de qualidade (apenas para registro no log)
# --------------------------------------------------------------------------- #
log.info("Nulos por coluna: %s", df.isna().sum()[df.isna().sum() > 0].to_dict())
log.info("Linhas idênticas: %d (mantidas; base sem identificador de paciente)",
         int(df.duplicated().sum()))

# --------------------------------------------------------------------------- #
# 3. Transformação e padronização
# --------------------------------------------------------------------------- #
log.info("Transformando e padronizando")

# Data: remove o componente de hora (T00:00:00Z) e deriva ano e mês
df["data_inicio_sintomas"] = pd.to_datetime(
    df["data_inicio_sintomas"], errors="coerce", utc=True).dt.date
datas = pd.to_datetime(df["data_inicio_sintomas"], errors="coerce")
df["ano_sintomas"] = datas.dt.year.astype("Int64")
df["mes_sintomas"] = datas.dt.month.astype("Int64")

# Idade: número inteiro com suporte a nulo
df["idade"] = pd.to_numeric(df["idade"], errors="coerce").astype("Int64")

# Sexo: texto padronizado
df["cs_sexo"] = df["cs_sexo"].str.strip().str.upper()

# Óbito: 0/1 -> Não/Sim
df["obito"] = df["obito"].map({0: "Não", 1: "Sim"})

# Comorbidades: três estados (SIM / NÃO / IGNORADO) padronizados
mapa = {"SIM": "Sim", "NÃO": "Não", "NAO": "Não", "IGNORADO": "Desconhecido"}
for col in COMORBIDADES:
    df[col] = df[col].str.strip().str.upper().map(mapa)

# Coluna constante (sempre CONFIRMADO): removida
if "diagnostico_covid19" in df.columns:
    df = df.drop(columns=["diagnostico_covid19"])
    log.info("Coluna 'diagnostico_covid19' removida (valor constante)")

# --------------------------------------------------------------------------- #
# 4. Normalização: separa a dimensão de municípios
# --------------------------------------------------------------------------- #
log.info("Separando a dimensão de municípios")
municipios = (
    df[["codigo_ibge", "nome_munic"]]
    .dropna(subset=["codigo_ibge"])
    .drop_duplicates(subset=["codigo_ibge"])
    .rename(columns={"nome_munic": "nome_municipio"})
    .sort_values("codigo_ibge")
)
# A tabela de casos passa a referenciar apenas o código do município
casos = df.drop(columns=["nome_munic"])

# --------------------------------------------------------------------------- #
# 5. Exportação para CSV
# --------------------------------------------------------------------------- #
casos.to_csv(f"./casos-covid-tratados.csv", sep=";", index=False, encoding="utf-8")
municipios.to_csv(f"./municipios.csv", sep=";", index=False, encoding="utf-8")
log.info("Gerados casos-covid-tratados.csv (%d linhas) e municipios.csv (%d linhas)",
         len(casos), len(municipios))
log.info("ETL concluído.")