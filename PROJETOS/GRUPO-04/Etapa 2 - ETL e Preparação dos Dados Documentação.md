# Relatório Técnico: Coleta, Limpeza e Preparação de Dados (ETL)

**Projeto:** Transformar Base de Dados Públicas em Banco de Dados Acessível à Sociedade  
**Disciplina:** Laboratório de Desenvolvimento de Banco de Dados V  
**Autores:** Davi Ballielo Galvani, Augusto Bueno de Almeida, João Carlos Scheffer Junior
**Etapa:** 2 - Processo de ETL e Staging Area  

---

## 1. Introdução e Objetivo Arquitetural
Este documento detalha o desenvolvimento do pipeline de dados (ETL - Extração, Transformação e Carga) responsável por ingerir, higienizar e estruturar as informações de gastos públicos de representantes eleitos. O escopo desta etapa foca na construção de uma arquitetura escalável e resiliente, operando inicialmente com os dados da Cota para o Exercício da Atividade Parlamentar (CEAP) via Portal de Dados Abertos da Câmara dos Deputados.

O objetivo técnico principal foi garantir que os dados consumidos, que originalmente apresentam formato heterogêneo (JSON), fossem consolidados em um modelo relacional tabular dentro de uma *Staging Area* (área de transição), garantindo confiabilidade e ausência de anomalias para as futuras consultas do sistema.

## 2. Arquitetura de Arquivos e Scripts
Para garantir o desacoplamento e facilitar a manutenção, o projeto foi estruturado em diferentes componentes físicos, cada um com uma responsabilidade única no ecossistema de dados:

* **`tratar_dados.py` (O Extrator ETL):** É o motor principal da aplicação. Este script em Python executa a extração automatizada conectando-se à API da Câmara dos Deputados. Ele gerencia a paginação das requisições, aplica o tratamento de erros e *retry* automático (para contornar instabilidades governamentais, como erros `504 Gateway Timeout`), realiza a limpeza em memória usando *DataFrames* e executa a carga no banco de dados temporário.
* **`staging_transparencia.db` (Banco Temporário):** Arquivo de banco de dados relacional (SQLite3) que atua fisicamente como a *Staging Area*. Ele recebe a carga bruta estruturada (tabela `stg_despesas_federais`), permitindo consultas SQL imediatas, validações de consistência e atestando que os dados foram armazenados de forma transacional e segura.
* **`exportar_dados.py` (Conversor de Exportação):** Script utilitário e isolado do motor de extração. Sua função é conectar-se exclusivamente à *Staging Area* e converter as tabelas relacionais em arquivos planos. A separação deste script é uma boa prática de mercado, pois permite gerar exportações sob demanda sem precisar rodar toda a carga massiva da API novamente.
* **`despesas_tratadas_extracao.csv` (Arquivo de Saída):** É o artefato final gerado pelo conversor. Trata-se de um arquivo plano estruturado com separadores padronizados (`;`) e formatação de casas decimais (`,`) compatíveis com o mercado nacional. Possui codificação `utf-8-sig` para manter a integridade de caracteres especiais. Este arquivo permite o consumo rápido dos dados tratados por ferramentas de BI (PowerBI, Metabase) ou auditores cidadãos comuns através de planilhas.

## 3. Tecnologias Utilizadas
A *stack* tecnológica foi selecionada com base em padrões consolidados no mercado de análise de dados e automação de rotinas:

| Tecnologia / Biblioteca | Função no Pipeline ETL | Justificativa Técnica |
| :--- | :--- | :--- |
| **Python 3.x** | Orquestração e Lógica | Linguagem padrão para engenharia de dados, oferecendo alta manutenibilidade. |
| **Requests** | Extração (Extract) | Consumo e eficiente de APIs REST governamentais. |
| **Pandas** | Transformação (Transform) | Processamento em memória via *DataFrames*, permitindo vetorização na limpeza de dados e exportação em múltiplos formatos. |
| **SQLite3** | Carga (Load) | Banco de dados relacional leve e transacional, ideal para a *Staging Area* local. |

## 4. Fase 1: Extração (Extract)
A extração foi realizada via requisições HTTP (`GET`) direcionadas aos *endpoints* da API REST da Câmara dos Deputados. 

**Estratégias de Mitigação de Riscos Aplicadas:**
* **Paginação de Dados (Pagination):** Para evitar bloqueios por *Rate Limit* (limite de requisições do servidor) e garantir a captura total das despesas, o script foi projetado com um laço de repetição condicional que avança dinamicamente as páginas da API (de 100 em 100 registros) até identificar o fim do lote do parlamentar.
* **Tolerância a Falhas e Resiliência:** O pipeline foi encapsulado em blocos de tratamento de exceção (`try/except`) somados a um sistema de *Retry*. Caso o portal do governo apresente lentidão momentânea, o script aguarda alguns segundos e tenta novamente, impedindo falhas críticas no processamento em lote.

## 5. Fase 2: Análise Inicial, Limpeza e Transformação (Transform)
Os dados brutos retornados pela API passaram por um rigoroso processo de padronização estrutural e saneamento de anomalias:

1. **Tratamento de Dados Faltantes (Nulls):** Registros sem valor financeiro (`valorDocumento`) ou data (`dataDocumento`) foram descartados (`dropna()`), visto que não possuem utilidade para a auditoria cívica.
2. **Desduplicação Estrita:** Utilizou-se o campo `codDocumento` (identificador único da nota fiscal no sistema da Câmara) para identificar e remover duplicatas oriundas da fonte (`drop_duplicates()`).
3. **Tipagem e Conversão:** As datas foram convertidas para o padrão **ISO 8601** (YYYY-MM-DD) visando indexação no banco de dados. Os valores monetários foram convertidos rigorosamente para o tipo numérico de ponto flutuante (`float`).
4. **Padronização de Strings:** Campos descritivos (`nomeFornecedor` e `tipoDespesa`) foram convertidos para caixa alta e higienizados contra espaços vazios excedentes, evitando falsas entidades na modelagem futura.
5. **Tratamento de Valores Negativos:** Valores referentes a estornos e cancelamentos foram mantidos negativamente de forma proposital. Esta decisão contábil é mandatória para que o balanço final (soma agregada) reflita com exatidão o saldo real debitado da cota parlamentar.

## 6. Fase 3: Carga (Load)
Os dados transformados foram carregados na tabela `stg_despesas_federais` dentro do banco `staging_transparencia.db`. O método de inserção adotado substitui os dados da área de transição a cada execução completa (`if_exists='replace'`), garantindo o princípio de idempotência no pipeline.

## 7. Resultados e Validação de Qualidade
A execução da arquitetura demonstrou alta coesão técnica. Os scripts cumpriram suas funções estabelecidas, resultando na criação de uma base íntegra.

**Validação Qualitativa e Quantitativa:**
As consultas agregadas diretamente no banco SQLite testificaram o sucesso do projeto, consolidando e formatando valores absolutos acima de R$ 208 milhões em gastos públicos rastreados, livres de duplicatas e devidamente estruturados para exportação e análise relacional subsequente.