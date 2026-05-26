# Documentação Técnica: Painel e Dashboards de Transparência Cívica (CEAP)

Este diretório contém os registros visuais (prints da aplicação) e este documento técnico que detalha a arquitetura, o design e a engenharia de software utilizada para construir o **Painel Web Interativo de Transparência de Gastos Parlamentares**.

O objetivo desta etapa do projeto foi traduzir o banco de dados relacional complexo em uma interface visual de altíssima estética, acessível, compreensível e útil para qualquer cidadão (pilar social da extensão acadêmica).

---

## 1. Prints da Aplicação em Funcionamento

Nesta pasta, estão incluídos os seguintes registros visuais da aplicação rodando com dados reais:
*   **`dashboard1.png`:** Visão geral do cabeçalho premium, cards de métricas em destaque (KPIs) e os gráficos analíticos principais de distribuição de verbas e ranking de gastos.
*   **`dashboard2.png`:** Gráficos complementares de consolidado por legenda partidária e as tabelas dinâmicas de maiores fornecedores contratados.
*   **`dashboard3.png`:** Detalhe da tabela interativa contendo as notas fiscais de maior valor e seus respectivos links e botões para visualização direta dos comprovantes digitais (PDFs oficiais).

---

## 2. Arquitetura Técnica: Como o Painel é Feito

Para garantir a **gratuidade total de infraestrutura**, **desempenho instantâneo** e a **portabilidade cívica** (facilidade de distribuição e download), adotamos a arquitetura **Serverless Estática Híbrida**:

```
+----------------------------------------------------------------------------+
|                        API da Câmara dos Deputados                         |
+----------------------------------------------------------------------------+
                                      |
                               (HTTP Requests)
                                      v
+----------------------------------------------------------------------------+
|         Pipeline de ETL (Python + Pandas) - atualizar_pipeline.py           |
+----------------------------------------------------------------------------+
                                      |
                       (Limpeza, Normalização, Validação)
                                      |
      +-------------------------------+-------------------------------+
      | (Carga Relacional)                                            | (Exportação Analítica)
      v                                                               v
+----------------------------+                          +----------------------------+
|  Banco de Dados SQLite3    |                          |   Arquivo Javascript       |
| transparencia_parlamentar  |                          |   dados_painel.js          |
+----------------------------+                          +----------------------------+
                                                                      |
                                                               (Injeção Direta)
                                                                      v
                                                        +----------------------------+
                                                        |     Painel Web Cívico      |
                                                        |  HTML5 / CSS3 / Chart.js   |
                                                        +----------------------------+
```

### A. Camada de Dados (Engenharia de Dados)
O script Python `atualizar_pipeline.py` atua como o agregador analítico. Ao final da carga no banco relacional SQLite3 (`transparencia_parlamentar.db`), o script executa queries SQL analíticas de consolidação de alto desempenho e exporta os resultados formatados para dois arquivos:
1.  **`dados_painel.json`:** Formato padrão de mercado para integrações assíncronas em servidores (API REST).
2.  **`dados_painel.js`:** Arquivo Javascript que injeta os mesmos dados formatados em uma constante global (`const dadosPainel = {...}`). 

### B. Camada de Gráficos (Visualização Dinâmica com Chart.js)
A renderização gráfica é feita do lado do cliente (Client-side) através da biblioteca **Chart.js** carregada de forma otimizada via CDN:
*   **Gráfico A - Destinação dos Recursos (Doughnut):** Um gráfico de rosca que exibe os gastos agrupados por categoria. Possui legenda responsiva posicionada à direita e paleta de cores harmoniosa em tons de violeta, azul, rosa, esmeralda e ciano. Exibe o valor em formato de moeda ao passar o mouse.
*   **Gráfico B - Ranking de Parlamentares (Horizontal Bar Chart):** Um gráfico de barras horizontais com cantos arredondados (`borderRadius: 6`) que exibe de forma comparativa os 10 deputados que mais utilizaram a cota parlamentar.
*   **Gráfico C - Consolidado por Partido (Vertical Bar Chart):** Gráfico de colunas que agrupa e soma os gastos por partido político, facilitando a identificação visual rápida de legendas com maiores volumes de gastos acumulados.

---

## 3. Dicionário de Componentes do Painel

O painel é estruturado em 4 seções principais de fiscalização:

### 3.1. Seção de KPIs (Key Performance Indicators)
*   **Total Acumulado Rastreável:** Exibe a soma matemática de todas as notas fiscais reembolsadas pela cota (R$ 4.229.456,30).
*   **Notas Fiscais Auditadas:** Exibe a contagem absoluta de comprovantes fiscais analisados e limpos de duplicatas (4.283 registros).
*   **Ticket Médio das Notas:** Exibe a divisão automática do total gasto pelo total de notas, mostrando o valor médio de reembolso (R$ 987,50).
*   **Maior Nota Fiscal:** Exibe o maior valor único lançado e reembolsado.

### 3.2. Seção Analítica de Gráficos
*   **Gráfico de Rosca:** Agrupa os gastos nas principais categorias (ex: *DIVULGAÇÃO DA ATIVIDADE PARLAMENTAR*, *LOCAÇÃO OU FRETAMENTO DE VEÍCULOS AUTOMOTORES*, *COMBUSTÍVEIS E LUBRIFICANTES*). Categorias menores são agrupadas automaticamente no pipeline sob a legenda "OUTROS GASTOS" para evitar poluição visual.
*   **Gráfico de Barras Horizontais:** Ordena os deputados em ordem decrescente de gastos.
*   **Gráfico de Colunas:** Ordena os partidos políticos em ordem decrescente de gastos.

### 3.3. Tabela de Maiores Fornecedores
Exibe as 5 empresas que mais faturaram e receberam verba pública da CEAP na amostra analisada. Mostra a razão social da empresa em destaque, o CNPJ devidamente mascarado (ex: `14.995.581/0001-53`) e o valor financeiro total recebido.

### 3.4. Tabela de Lançamentos Fiscais de Maior Valor
Lista os 5 maiores gastos individuais efetuados por qualquer deputado na amostra. Exibe o nome do deputado responsável, a data de emissão formatada no padrão brasileiro (`DD/MM/YYYY`), o valor da nota e o botão de ação **"Ver PDF"** que direciona o usuário para o documento digitalizado no servidor da Câmara, servindo como uma ferramenta de auditoria social imediata.

---

## 4. Instruções de Funcionamento e Atualização

### Como Atualizar os Gráficos com Novos Dados:
Sempre que você rodar o pipeline no terminal:
```powershell
python "arquivos python/atualizar_pipeline.py"
```
O script se conectará à API governamental, processará as novas notas fiscais, reconstruirá a base `transparencia_parlamentar.db` e reescreverá automaticamente os arquivos `dados_painel.js` e `dados_painel.json`. Ao atualizar a página no navegador, todos os gráficos e tabelas serão redesenhados com os dados novos instantaneamente!
