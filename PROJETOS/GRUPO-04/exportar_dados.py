import sqlite3
import pandas as pd

# 1. Estabelecer a conexão com o banco de dados temporário
banco_de_dados = 'staging_transparencia.db'
print(f"Conectando ao banco {banco_de_dados}...")
conn = sqlite3.connect(banco_de_dados)

try:
    # 2. Ler a tabela inteira e carregar em um DataFrame do Pandas
    query = "SELECT * FROM stg_despesas_federais"
    df_exportacao = pd.read_sql_query(query, conn)
    
    # 3. Definir o nome do arquivo de saída
    nome_arquivo_csv = 'despesas_tratadas_extracao.csv'
    
    # 4. Exportar para CSV
    # sep=';' e decimal=',' garantem que o arquivo abra perfeitamente formatado no Excel em português
    # encoding='utf-8-sig' garante que acentos (como em "MANUTENÇÃO") não fiquem desconfigurados
    df_exportacao.to_csv(nome_arquivo_csv, sep=';', decimal=',', encoding='utf-8-sig', index=False)
    
    print(f"[SUCESSO] Exportação concluída! O arquivo '{nome_arquivo_csv}' foi gerado na sua pasta.")
    print(f"Total de linhas exportadas: {len(df_exportacao)}")

except Exception as e:
    print(f"[ERRO] Falha durante a exportação: {e}")

finally:
    # 5. Fechar a conexão
    conn.close()