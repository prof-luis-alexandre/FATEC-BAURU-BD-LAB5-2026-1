
import os
from datetime import datetime

import pandas as pd
import ipeadatapy as ipea


PASTA_PROJETO = "/content/fase-2"
PASTA_BRUTOS = os.path.join(PASTA_PROJETO, "dados", "brutos")

os.makedirs(PASTA_BRUTOS, exist_ok=True)


SERIES = {
    "ipca_alimentos": {
        "codigo": "PRECOS12_IPCAAB12",
        "descricao": "IPCA - alimentos e bebidas - taxa de variação mensal",
        "arquivo": "ipca_alimentos_bruto.csv"
    },
    "rendimento_real": {
        "codigo": "PNADCT_RRETUF",
        "descricao": "Rendimento médio real de todos os trabalhos efetivo",
        "arquivo": "rendimento_real_bruto.csv"
    }
}


def baixar_serie(nome_serie, codigo, descricao, arquivo_saida):
    print("=" * 80)
    print(f"Série: {nome_serie}")
    print(f"Código IPEAData: {codigo}")
    print(f"Descrição: {descricao}")

    dados = ipea.timeseries(codigo)

    caminho_saida = os.path.join(PASTA_BRUTOS, arquivo_saida)
    dados.to_csv(caminho_saida, index=True, encoding="utf-8-sig")

    print(f"Arquivo salvo em: {caminho_saida}")
    print(f"Quantidade de registros: {len(dados)}")
    print(f"Colunas: {list(dados.columns)}")
    print(f"Período inicial: {dados.index.min()}")
    print(f"Período final: {dados.index.max()}")

    return dados


def main():
    data_coleta = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    print("ETAPA 2 — Coleta definitiva dos dados públicos do IPEAData")
    print(f"Data da coleta: {data_coleta}")

    for nome, info in SERIES.items():
        baixar_serie(
            nome_serie=nome,
            codigo=info["codigo"],
            descricao=info["descricao"],
            arquivo_saida=info["arquivo"]
        )

    registro_coleta = pd.DataFrame([
        {
            "nome_base": "ipca_alimentos",
            "codigo_ipea": "PRECOS12_IPCAAB12",
            "descricao": "IPCA - alimentos e bebidas - taxa de variação mensal",
            "fonte": "IPEAData",
            "metodo_coleta": "API via biblioteca ipeadatapy",
            "data_coleta": data_coleta,
            "arquivo_gerado": "dados/brutos/ipca_alimentos_bruto.csv",
            "finalidade_social": "Acompanhar a variação dos preços de alimentos e bebidas como indicador de custo de vida."
        },
        {
            "nome_base": "rendimento_real",
            "codigo_ipea": "PNADCT_RRETUF",
            "descricao": "Rendimento médio real de todos os trabalhos efetivo",
            "fonte": "IPEAData",
            "metodo_coleta": "API via biblioteca ipeadatapy",
            "data_coleta": data_coleta,
            "arquivo_gerado": "dados/brutos/rendimento_real_bruto.csv",
            "finalidade_social": "Acompanhar a evolução da renda real da população ocupada para comparação com o custo dos alimentos."
        }
    ])

    caminho_registro = os.path.join(PASTA_BRUTOS, "registro_coleta.csv")
    registro_coleta.to_csv(caminho_registro, index=False, encoding="utf-8-sig")

    print("=" * 80)
    print("Registro da coleta salvo em:")
    print(caminho_registro)


if __name__ == "__main__":
    main()
