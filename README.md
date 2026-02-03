# Projeto: SQL + Power BI para Análise de Dados na Área Operacional

# Descrição
Este projeto foi desenvolvido para compor meu portfólio em Análise de Dados / Business Intelligence.
Utilizei MySQL para consulta e preparação dos dados e o Power BI para criar um dashboard com 3 páginas focadas na área de Operações, utilizando dados fictícios gerados aleatoriamente via SQL.
O objetivo do projeto é responder perguntas de negócio relevantes para a área operacional, apresentadas no tópico Resultados Obtidos.

# Ferramentas Utilizadas
MySQL – preparo, criação e consulta dos dados.
Power BI – modelagem, tratamento, relacionamento e visualização dos indicadores.
SQL – geração e manipulação dos dados fictícios.

# KPIs do Projeto
Os principais indicadores trabalhados foram:
- Modelagem e storytelling com dados para tomada de decisão
- Eficiência operacional e aumento da performance
- Nível de serviço
- Redução de falhas operacionais
- Controle e monitoramento do saldo de estoque

# Estrutura do Dashboard
📌 Página 1 — Performance Operacional
Indicadores apresentados:
- Total de operações realizadas
- Tempo médio de execução
- Performance das operações
- Total por tipo de operação
- Tempo médio por tipo de operação
- Total de operações por turno

📌 Página 2 — Controle de Estoque
Indicadores apresentados:
- Centros de Distribuição (CDs) com alerta de saldo médio negativo
- Saldo em estoque por categoria e código de produto
- Total de movimentações por tipo
- Média de movimentações por dia

📌 Página 3 — Qualidade Operacional
Indicadores apresentados:
- Total de falhas operacionais
- Média do nível de serviço
- Falhas Operacionais por CD
- Erros de inventário por dia

# Resultados Obtidos (Insights de Negócio)
1. Qual CD realiza mais operações por dia?
O CD de Osasco é responsável por 25,6% das operações totais.

2. Qual turno é mais produtivo em operações realizadas?
O turno da noite é o mais produtivo, com 1.967 operações, representando 39,3% do total.

3. Qual categoria de produtos apresenta maior risco de ruptura (saldo < -1000)?
As categorias com maior risco são:
- Brinquedos → saldo -1339
- Eletrônicos → saldo -1015

4. O nível de serviço médio aceitável está sendo atingido?
Não.
- Nível aceitável: 98%
- Nível atingido: 95%
Embora o nível realizado esteja próximo do ideal, ainda há oportunidades de melhoria.

5. Qual CD possui o maior número de avarias?
O CD do Rio de Janeiro apresenta 1.464 avarias, equivalente a 30,3% do total.

# Estrutura Recomendada do Repositório
📁 sql/
    scripts_mysql.sql

📁 powerbi/
    dashboard.pbix

📁 imagens/
    pagina1.png
    pagina2.png
    pagina3.png

README.md


# Como Reproduzir o Projeto

- Baixe os scripts SQL e importe no MySQL.
- Baixe o arquivo .pbix.
- Abra o dashboard no Power BI Desktop.
- Explore os KPIs e análises.

# Contato
Caso queira trocar ideias sobre oportunidades de carreira, análise de dados, BI ou sugerir melhorias:
LinkedIn: www.linkedin.com/in/cleber-carlos-dos-santos-42695516a
