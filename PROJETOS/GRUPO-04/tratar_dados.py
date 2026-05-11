import requests
import pandas as pd
from datetime import datetime

# ==========================================
# 1. EXTRAÇÃO (Extract)
# ==========================================
def coletar_despesas_deputados(limite_deputados=5):
    print("Iniciando extração de dados da API da Câmara com PAGINAÇÃO...")
    url_deputados = "https://dadosabertos.camara.leg.br/api/v2/deputados"
    
    try:
        res = requests.get(url_deputados, params={"ordem": "ASC", "ordenarPor": "nome"})
        res.raise_for_status()
        deputados = res.json()['dados'][:limite_deputados]
    except requests.exceptions.RequestException as e:
        print(f"[ERRO] Falha na comunicação com a API: {e}")
        return None

    lista_despesas = []
    
    for dep in deputados:
        id_dep = dep['id']
        nome_dep = dep['nome']
        url_desp = f"https://dadosabertos.camara.leg.br/api/v2/deputados/{id_dep}/despesas"
        
        pagina = 1 # Começamos na página 1
        
        while True: # Loop infinito até que as notas acabem
            try:
                # Agora passamos o parâmetro 'pagina' dinamicamente
                res_desp = requests.get(url_desp, params={"ano": 2024, "itens": 100, "pagina": pagina})
                res_desp.raise_for_status()
                despesas = res_desp.json()['dados']
                
                # Regra de parada: se a API retornar uma lista vazia, acabaram as notas deste deputado
                if not despesas:
                    break
                
                for d in despesas:
                    d['nome_deputado'] = nome_dep
                    lista_despesas.append(d)
                    
                pagina += 1 # Prepara para pedir a próxima página na próxima rodada do while
                
            except requests.exceptions.RequestException as e:
                print(f"[AVISO] Pulo na extração do deputado {nome_dep} na página {pagina}: {e}")
                break # Sai do loop deste deputado em caso de erro

    print(f"Extração concluída. Total de registros brutos: {len(lista_despesas)}")
    return pd.DataFrame(lista_despesas)

# ==========================================
# 2. TRANSFORMAÇÃO E LIMPEZA (Transform)
# ==========================================f
def limpar_e_transformar_dados(df):
    if df is None or df.empty:
        return df
        
    print("\nIniciando processo de limpeza (Análise Inicial)...")
    linhas_iniciais = len(df)
    
    # A. Tratamento de Dados Faltantes e Inconsistências
    # Se a despesa não tem valor ou data, ela não serve para a fiscalização cidadã
    df = df.dropna(subset=['valorDocumento', 'dataDocumento'])
    
    # B. Padronização e Tipagem de Dados
    df['dataDocumento'] = pd.to_datetime(df['dataDocumento']).dt.date
    df['valorDocumento'] = df['valorDocumento'].astype(float)
    df['valorLiquido'] = df['valorLiquido'].astype(float)
    
    # C. Limpeza de Strings (Facilita a busca relacional depois)
    df['tipoDespesa'] = df['tipoDespesa'].str.upper().str.strip()
    df['nomeFornecedor'] = df['nomeFornecedor'].str.upper().str.strip()
    
    # D. Remoção de Duplicatas
    # Baseado no ID único do documento gerado pela câmara
    df = df.drop_duplicates(subset=['codDocumento'])
    
    linhas_finais = len(df)
    print(f"Limpeza concluída. Registros removidos: {linhas_iniciais - linhas_finais}")
    return df

# ==========================================
# 3. CARGA (Load)
# ==========================================
def salvar_dados_csv(df, nome_arquivo="amostra_despesas_deputados.csv"):
    if df is None or df.empty:
        print("Operação abortada: DataFrame vazio.")
        return
        
    print(f"\nIniciando geração do arquivo CSV: {nome_arquivo}...")
    
    try:
        # Salva o DataFrame em formato CSV
        # Como é uma amostra, salvamos os dados limpos sem necessidade de banco de dados
        df.to_csv(nome_arquivo, index=False, encoding='utf-8', sep=';')
        print(f"[SUCESSO] Dados formatados salvos no arquivo '{nome_arquivo}'.")
    except Exception as e:
        print(f"[ERRO] Falha ao gravar o arquivo CSV: {e}")

# ==========================================
# ORQUESTRAÇÃO
# ==========================================
if __name__ == "__main__":
    # Coleta de amostra (limite=5) para não demorar tanto, como solicitado
    df_bruto = coletar_despesas_deputados(limite_deputados=5)
    df_limpo = limpar_e_transformar_dados(df_bruto)
    salvar_dados_csv(df_limpo)