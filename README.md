# Projetos da disciplina de LABORATÓRIO DE DESENVOLVIMENTO EM BANCO DE DADOS V
## 1o. SEMESTRE DE 2026

# 🚀 GRUPO 01
## Tema: Projeto ndicadores de qualidade e desempenho acadêmico dos cursos de graduação no Brasi

### 📝 Descrição do Projeto
Para a execução deste projeto, foi selecionada a base de dados do Conceito Enade 2023,
gerida pelo Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira (INEP).
Esta base é um dos pilares da regulação do ensino superior no Brasil e oferece um retrato
detalhado do desempenho acadêmico em nível nacional.
Características da base:
- Tema: Indicadores de qualidade e desempenho acadêmico dos cursos de
graduação no Brasil.
- Origem: Dados Abertos do INEP/MEC, acessíveis via portal oficial do Governo
Federal.
- Formato: Arquivo estruturado em XLSX, contendo métricas de desempenho e
identificadores institucionais.
- Período: Ciclo avaliativo referente ao ano de 2023.
- Finalidade original: Monitorar o cumprimento das diretrizes curriculares e a
qualidade da formação oferecida pelas Instituições de Ensino Superior (IES).
A base é composta por variáveis geográficas, administrativas e acadêmicas, permitindo
uma análise profunda sobre como fatores externos influenciam a qualidade da formação
profissional em diferentes contextos.

### 👥 Integrantes do Grupo
* Antonio Ranazzi Neto
* Luis Victor Rosa de Almeida Santana Videira

### 📂 Documentação e Arquivos
- [ ] Projeto


| **GRUPO-01** | 2026.1 | [📂 Repositório ](https://github.com/prof-luis-alexandre/FATEC-BAURU-BD-LAB5-2026-1/tree/main/PROJETOS/GRUPO-01) |
---

# 🚀 GRUPO 02
## Tema: Projeto Monitoramento de Dengue e sua Correlação com a Infraestrutura de Saneamento Básico

### 📝 Descrição do Projeto
O projeto utilizará duas fontes principais de dados públicos: o DATASUS (especificamente o Sistema de Informação de Agravos de Notificação - SINAN, focado nos casos de Dengue) e o IBGE (dados do Censo e Pesquisa Nacional de Saneamento Básico).
- Formato e Volume: Os dados do DATASUS geralmente são disponibilizados em formatos específicos (como .dbc ou .csv), enquanto os do IBGE podem ser acessados via API ou arquivos .csv/.xls. O volume nacional é massivo, portanto, os dados serão filtrados espacialmente (ex: focando na região de Bauru) para otimizar o processamento.
- Frequência e Qualidade: A atualização dos casos de dengue ocorre com alta frequência (boletins epidemiológicos semanais/mensais). A qualidade dos dados brutos apresenta desafios técnicos ideais para a disciplina, exigindo tratamento rigoroso de valores nulos (missing values), padronização de chaves primárias (como os códigos de município do IBGE) e rotinas de ETL (Extração, Transformação e Carga) para unificar as duas bases em um modelo relacional eficiente.

### 👥 Integrantes do Grupo
* Diego Rafael de Oliveira
* Luiz Carlos Scalfi Theodoro

### 📂 Documentação e Arquivos
- [ ] Projeto


| **GRUPO-02** | 2026.1 | [📂 Repositório ](https://github.com/prof-luis-alexandre/FATEC-BAURU-BD-LAB5-2026-1/tree/main/PROJETOS/GRUPO-02) |
---

# 🚀 GRUPO 03
## Tema: Projeto Seleção e Diagnóstico de Base de Dados Pública

### 📝 Descrição do Projeto
Este documento apresenta o diagnóstico e planejamento da Etapa 1 do projeto de extensão da disciplina de Banco de Dados. O objetivo desta etapa é selecionar uma base de dados pública que atenda a uma demanda real da sociedade, identificar seu impacto social, definir o público beneficiado e estabelecer o escopo técnico e organizacional do projeto.

A atividade integra os pilares da Curricularização da Extensão, promovendo a conexão entre o conhecimento técnico adquirido na graduação e a sua aplicação em contextos sociais concretos, contribuindo para a formação de profissionais comprometidos com o desenvolvimento da sociedade.

### 👥 Integrantes do Grupo
* João Pedro Gomes de Souza

### 📂 Documentação e Arquivos
- [ ] Projeto


| **GRUPO-03** | 2026.1 | [📂 Repositório ](https://github.com/prof-luis-alexandre/FATEC-BAURU-BD-LAB5-2026-1/tree/main/PROJETOS/GRUPO-03) |
---

# 🚀 GRUPO 04
## Tema: Projeto Análise de Gastos Públicos de Representantes Eleitos

### 📝 Descrição do Projeto
O projeto atua como um instrumento direto de cidadania ativa e Accountability (responsabilização). Os resultados esperados incluem:
1.	Redução drástica da assimetria de informação entre o Estado (em todas as suas esferas) e o cidadão.
2.	Promoção da responsabilidade fiscal por parte dos representantes eleitos, inibindo o mau uso de verbas devido à facilidade de rastreamento pela sociedade.
3.	Geração de um produto de tecnologia cívica (Civic Tech) de alto impacto, aplicando conhecimentos acadêmicos de Banco de Dados para resolver um problema crônico de opacidade governamental.

### 👥 Integrantes do Grupo
* Davi Ballielo Galvani 
* Augusto Bueno de Almeida 
* João Carlos Scheffer Junior
* Pedro Henrique Martins Nascimento 

### 📂 Documentação e Arquivos
- [ ] Projeto


| **GRUPO-04** | 2026.1 | [📂 Repositório ](https://github.com/prof-luis-alexandre/FATEC-BAURU-BD-LAB5-2026-1/tree/main/PROJETOS/GRUPO-04) |
---

# 🚀 GRUPO 05
## Tema: Projeto transformar dados públicos do DATASUS em um banco de dados estruturado

### 📝 Descrição do Projeto
A escolha da base do DATASUS se justifica tanto sob o ponto de vista técnico 
quanto social. Tecnicamente, trata-se de uma base robusta, com grande volume de 
dados, diversidade de atributos e possibilidade de aplicação de conceitos importantes da 
área de Banco de Dados, como modelagem, normalização, ETL, integração de dados e 
consultas analíticas. Isso torna o projeto relevante para a formação acadêmica, pois 
permite colocar em prática conhecimentos essenciais do curso.
Sob a perspectiva social, a base escolhida apresenta alta relevância porque trata 
de informações diretamente relacionadas à saúde da população. A organização desses 
dados em um banco de dados acessível pode facilitar a consulta por gestores públicos, 
pesquisadores, jornalistas, organizações sociais e cidadãos interessados em compreender 
melhor a realidade da saúde em sua cidade, estado ou região. Muitas vezes, os dados 
existem, mas seu formato original dificulta o uso prático. Assim, o projeto propõe 
justamente transformar esses registros em informação acessível, organizada e 
compreensível.
Outro fator importante é que a saúde pública é uma área em que decisões 
precisam ser tomadas com base em evidências. Dados bem estruturados podem apoiar a 
identificação de regiões com maior incidência de determinados problemas, auxiliar o 
monitoramento de atendimentos e permitir análises comparativas ao longo do tempo. 
Dessa forma, o projeto não se limita ao aspecto técnico, mas também se conecta a uma 
necessidade social concreta.

### 👥 Integrantes do Grupo
* Arthur Bressan Ferreira Lima
* Eduardo Cimino Silva
* Guilherme Henrique Capucho

### 📂 Documentação e Arquivos
- [ ] Projeto


| **GRUPO-05** | 2026.1 | [📂 Repositório ](https://github.com/prof-luis-alexandre/FATEC-BAURU-BD-LAB5-2026-1/tree/main/PROJETOS/GRUPO-05) |
---

# 🚀 GRUPO 06
## Tema: Projeto transformar uma base de dados pública de saúde em um banco de dados estruturado - DATASUS

### 📝 Descrição do Projeto
O objetivo geral do projeto é transformar uma base de dados pública de saúde em um 
banco de dados estruturado e acessível, facilitando o uso da informação pública pela 
sociedade. 
Como objetivos específicos, destacam-se: 
- Analisar a estrutura e a qualidade dos dados públicos de saúde  
- Planejar e executar processos de ETL  
- Modelar um banco de dados relacional  
- Documentar a estrutura criada para uso futuro  
- Preparar o banco para consultas e análises

### 👥 Integrantes do Grupo
* João Antonio de Camargo

### 📂 Documentação e Arquivos
- [ ] Projeto


| **GRUPO-06** | 2026.1 | [📂 Repositório ](https://github.com/prof-luis-alexandre/FATEC-BAURU-BD-LAB5-2026-1/tree/main/PROJETOS/GRUPO-06) |
---

# 🚀 GRUPO 07
## Tema: PROJETO BANCO DE DADOS PARA MAPEAMENTO DE AGRICULTURA URBANA E SERVIÇOS PARA AGRICULTURA

### 📝 Descrição do Projeto
Diante do conteúdo apresentado a respeito da prática de agricultura urbana, dos principais 
benefícios dessa atividade para a população, para a economia e para o meio ambiente das cidades, 
bem como do combate à insegurança alimentar à criação de políticas públicas abrangentes, o 
presente trabalho, desenvolvido para a disciplina ‘Laboratório de desenvolvimento em Banco de 
Dados V’, tem como objetivo encontrar e analisar bases de dados abertas referentes à temática 
exposta na sessão 1. As bases de dados encontradas deverão ser detalhadas quanto: (1) Ao formato 
da estrutura dos dados utilizados (normalmente json, csv ou xml), (2) A confiabilidade e 
frequência de atualização dos dados da base e (3) Ao propósito para o qual essa base de dados foi 
criada (público-alvo, questões sociais, impacto esperado na população, etc). Os dados utilizados 
nas bases públicas encontradas deverão ser exportados e manuseados para a criação de um Banco 
de Dados capaz de contribuir para a criação de um sistema plausível e que possa contribuir de 
forma direta ou indiretamente para a população-alvo.

### 👥 Integrantes do Grupo
* João Pedro da Silva Faria

### 📂 Documentação e Arquivos
- [ ] Projeto


| **GRUPO-07** | 2026.1 | [📂 Repositório ](https://github.com/prof-luis-alexandre/FATEC-BAURU-BD-LAB5-2026-1/tree/main/PROJETOS/GRUPO-07) |
---

*FATEC Bauru - Prof. Luis Alexandre - Semestre 2026.1*
