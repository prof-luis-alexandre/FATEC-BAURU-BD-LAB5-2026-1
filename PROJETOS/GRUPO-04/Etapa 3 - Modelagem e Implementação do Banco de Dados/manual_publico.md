# Guia do Cidadão: Manual de Auditoria Cívica dos Gastos Parlamentares

Bem-vindo ao **Manual Público e Simplificado do Banco de Dados de Transparência Parlamentar**! 

Este guia foi desenvolvido para você, cidadão brasileiro (estudante, jornalista, pesquisador ou apenas um eleitor curioso), que deseja entender como os deputados federais utilizam a **Cota para o Exercício da Atividade Parlamentar (CEAP)** — dinheiro público destinado a ressarcir despesas como passagens aéreas, combustíveis, aluguel de escritórios e publicidade.

Nosso objetivo é transformar dados técnicos brutos em ferramentas de fiscalização democrática ao alcance de qualquer pessoa.

---

## 1. Entendendo o Banco de Dados (Sem Complicação!)

Imagine que a Câmara dos Deputados nos entrega uma planilha gigante contendo milhares de linhas bagunçadas, onde o nome de um mesmo deputado é escrito de três formas diferentes e as categorias de gastos se repetem infinitamente, consumindo espaço e gerando erros.

Para resolver isso, nós criamos um **Banco de Dados Relacional Organizado**. Pense nele como uma cômoda com várias gavetas separadas e identificadas:

1. **Partidos (`partido`):** Gaveta que guarda a sigla do partido (ex: *PT*, *PL*, *MDB*).
2. **Estados (`estado`):** Gaveta com a sigla dos estados (ex: *SP*, *RJ*, *AP*).
3. **Deputados (`deputado`):** Gaveta com a foto, e-mail oficial, partido e estado de cada parlamentar.
4. **Fornecedores (`fornecedor`):** Gaveta contendo a Razão Social (nome da empresa) e o CNPJ/CPF de quem vendeu o produto ou serviço.
5. **Categorias de Gasto (`tipo_despesa`):** Gaveta contendo o tipo de gasto (ex: *COMBUSTÍVEIS E LUBRIFICANTES*, *PASSAGENS AÉREAS*).
6. **Despesas (`despesa`):** A gaveta principal! Ela guarda os comprovantes físicos (notas fiscais) contendo data, número da nota, valor cobrado e conexões com as outras gavetas (quem gastou, onde gastou e em qual fornecedor).

Essa organização garante que a base de dados seja leve, rápida e **100% livre de informações falsas ou duplicadas**.

---

## 2. A Camada Cívica: Facilitando sua Consulta (A `VIEW`)

Sabemos que fazer cruzamento de dados (*JOIN*s) entre 6 gavetas diferentes pode parecer difícil se você está começando no SQL. 

Por isso, criamos um atalho mágico chamado **`vw_despesas_completas`** (uma View Pública). Ela funciona como uma planilha gigante virtual que já junta todas as gavetas automaticamente para você. Ao invés de escrever códigos complexos, você pode interagir com ela como se fosse uma tabela única e simples.

---

## 3. Receitas de SQL: 5 Consultas Prontas para Auditar

Você pode baixar e abrir o arquivo `transparencia_parlamentar.db` em programas gratuitos e fáceis de usar, como o **DB Browser for SQLite** (disponível para Windows, Mac e Linux). 

Após abrir o banco no programa, clique na aba **"Executar SQL"**, copie um dos códigos abaixo e clique no botão de "Play" para auditar:

### Receita 1: Quais os 5 parlamentares que mais gastaram na amostra?
*Ideal para entender quem consome mais verba pública de forma consolidada.*
```sql
SELECT nome_deputado, sigla_partido, sigla_uf, SUM(valor_liquido) AS total_gasto
FROM vw_despesas_completas
GROUP BY id_deputado
ORDER BY total_gasto DESC
LIMIT 5;
```

### Receita 2: Quais são as 5 maiores notas fiscais individuais reembolsadas?
*Perfeito para identificar compras de valores altos e atípicos.*
```sql
SELECT nome_deputado, tipo_despesa, nome_fornecedor, valor_liquido, data_documento, url_documento
FROM vw_despesas_completas
ORDER BY valor_liquido DESC
LIMIT 5;
```
> **Dica do Auditor:** Copie o link na coluna `url_documento` e cole no seu navegador para ver o PDF da nota fiscal original emitida pelo deputado!

### Receita 3: Quais empresas (Fornecedores) mais receberam dinheiro público?
*Ajuda a detectar se há concentração de contratos em determinadas empresas.*
```sql
SELECT nome_fornecedor, fornecedor_cnpj_cpf, SUM(valor_liquido) AS total_recebido, COUNT(*) AS notas_emitidas
FROM vw_despesas_completas
WHERE fornecedor_cnpj_cpf IS NOT NULL
GROUP BY fornecedor_cnpj_cpf
ORDER BY total_recebido DESC
LIMIT 5;
```

### Receita 4: Quais são os gastos médios por categoria?
*Mostra quais serviços (ex: passagens, combustíveis, consultoria) custam mais caro em média por nota fiscal.*
```sql
SELECT tipo_despesa, SUM(valor_liquido) AS total_gasto, AVG(valor_liquido) AS custo_medio_por_nota
FROM vw_despesas_completas
GROUP BY tipo_despesa
ORDER BY total_gasto DESC;
```

### Receita 5: Gastos detalhados de um deputado específico
*Quer fiscalizar especificamente um deputado? Basta digitar o nome dele entre aspas:*
```sql
SELECT data_documento, tipo_despesa, nome_fornecedor, valor_liquido, url_documento
FROM vw_despesas_completas
WHERE nome_deputado = 'ACÁCIO FAVACHO'
ORDER BY data_documento DESC;
```

---

## 4. O Painel Web Cívico (Dashboard)

Se você prefere ver as informações de forma visual e interativa em vez de digitar códigos, desenvolvemos o **Painel Cívico**.

Para abri-lo:
1. Vá até a pasta `painel/` do projeto.
2. Dê um duplo clique no arquivo `index.html`.
3. Pronto! Uma interface em **Dark Mode** de alta estética se abrirá no seu navegador de internet padrão.

### Recursos do Painel:
* **Métricas em Destaque (KPIs):** Veja instantaneamente o total geral gasto pela amostra de deputados federais, o total de notas fiscais limpas de duplicatas, o ticket médio de cada nota e o maior gasto unitário detectado.
* **Gráficos Dinâmicos:**
  - **Distribuição de Verbas (Pizza):** Passe o mouse sobre as fatias para ver o valor exato gasto em cada setor.
  - **Ranking de Parlamentares (Barras):** Veja quais deputados gastaram mais.
  - **Consolidado por Partido (Colunas):** Compare os gastos entre as diferentes legendas políticas.
* **Maiores Fornecedores & Lançamentos:** Uma tabela interativa exibindo os maiores destinatários do dinheiro público e os links diretos para você ler os PDFs das notas fiscais oficiais com um clique.

---

## 5. Licença e Distribuição
Este é um projeto **100% público e gratuito**, feito por e para cidadãos. Os dados contidos nesta base são extraídos diretamente do Portal de Dados Abertos da Câmara dos Deputados e estão sob a licença de dados públicos governamentais. 

*Audite, fiscalize e compartilhe! A democracia se fortalece com a participação de todos.*
