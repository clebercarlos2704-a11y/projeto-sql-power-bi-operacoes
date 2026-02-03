-- ============================================================
-- BANCO DE DADOS FICTÍCIO DE OPERAÇÕES LOGÍSTICAS – 5.000 REGISTROS
-- MySQL 8+
-- ============================================================

USE projeto_power_bi_operacoes;

-- ------------------------------------------------------------
-- 1. TABELAS
-- ------------------------------------------------------------

CREATE TABLE centros_distribuicao (
    cd_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    capacidade_estoque INT
);

CREATE TABLE funcionarios (
    funcionario_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120),
    cargo VARCHAR(80),
    turno VARCHAR(20),
    cd_id INT,
    data_admissao DATE,
    salario DECIMAL(10,2),
    FOREIGN KEY (cd_id) REFERENCES centros_distribuicao(cd_id)
);

CREATE TABLE produtos (
    produto_id INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(150),
    categoria VARCHAR(100),
    peso_kg DECIMAL(10,3),
    valor_unitario DECIMAL(10,2)
);

CREATE TABLE operacoes (
    operacao_id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_operacao ENUM('recebimento','expedicao','inventario','armazenagem','separacao'),
    cd_id INT,
    funcionario_id INT,
    data_operacao DATETIME,
    tempo_execucao_min INT,
    status_operacao ENUM('concluida','em_andamento','pendente','cancelada'),
    FOREIGN KEY (cd_id) REFERENCES centros_distribuicao(cd_id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(funcionario_id)
);

CREATE TABLE movimentacoes_estoque (
    mov_id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT,
    cd_id INT,
    data_movimento DATETIME,
    tipo_mov ENUM('entrada','saida','ajuste_positivo','ajuste_negativo'),
    quantidade INT,
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id),
    FOREIGN KEY (cd_id) REFERENCES centros_distribuicao(cd_id)
);

CREATE TABLE qualidade_operacional (
    registro_id INT AUTO_INCREMENT PRIMARY KEY,
    cd_id INT,
    data DATE,
    avarias INT,
    erros_inventario INT,
    nivel_servico DECIMAL(5,2),
    FOREIGN KEY (cd_id) REFERENCES centros_distribuicao(cd_id)
);

-- ------------------------------------------------------------
-- 2. TABELA TEMPORÁRIA PARA GERAR 5.000 LINHAS
-- ------------------------------------------------------------

CREATE TEMPORARY TABLE temp_numbers (
    n INT
);

SET SESSION cte_max_recursion_depth = 5000;

INSERT INTO temp_numbers (n)
SELECT n
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1
        FROM seq
        WHERE n < 5000
    )
    SELECT n FROM seq
) x;


-- ------------------------------------------------------------
-- 3. CENTROS DE DISTRIBUIÇÃO
-- ------------------------------------------------------------

INSERT INTO centros_distribuicao (nome, cidade, estado, capacidade_estoque)
VALUES
('CD São Paulo', 'São Paulo', 'SP', 50000),
('CD Osasco', 'Osasco', 'SP', 30000),
('CD Campinas', 'Campinas', 'SP', 45000),
('CD Rio de Janeiro', 'Rio de Janeiro', 'RJ', 40000);

-- ------------------------------------------------------------
-- 4. FUNCIONÁRIOS – 200 REGISTROS
-- ------------------------------------------------------------

INSERT INTO funcionarios (nome, cargo, turno, cd_id, data_admissao, salario)
SELECT 
    CONCAT('Funcionario ', n),
    ELT(FLOOR(RAND()*4)+1, 'Operador', 'Conferente', 'Analista', 'Supervisão'),
    ELT(FLOOR(RAND()*3)+1, 'Manhã','Tarde','Noite'),
    FLOOR(1 + RAND()*4),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*1500) DAY),
    2000 + (RAND()*4000)
FROM temp_numbers
WHERE n <= 200;

-- ------------------------------------------------------------
-- 5. PRODUTOS – 300 REGISTROS
-- ------------------------------------------------------------

INSERT INTO produtos (nome_produto, categoria, peso_kg, valor_unitario)
SELECT
    CONCAT('Produto ', n),
    ELT(FLOOR(RAND()*4)+1, 'Eletrônicos','Moda','Casa','Brinquedos'),
    RAND()*10,
    (RAND()*200) + 10
FROM temp_numbers
WHERE n <= 300;

-- ------------------------------------------------------------
-- 6. OPERAÇÕES – 5.000 REGISTROS
-- ------------------------------------------------------------

INSERT INTO operacoes (tipo_operacao, cd_id, funcionario_id, data_operacao, tempo_execucao_min, status_operacao)
SELECT
    ELT(FLOOR(RAND()*5)+1, 'recebimento','expedicao','inventario','armazenagem','separacao'),
    FLOOR(1 + RAND()*4),
    FLOOR(1 + RAND()*200),
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*180) DAY),
    FLOOR(RAND()*60)+3,
    ELT(FLOOR(RAND()*4)+1,'concluida','em_andamento','pendente','cancelada')
FROM temp_numbers;

-- ------------------------------------------------------------
-- 7. MOVIMENTAÇÕES DE ESTOQUE – 5.000 REGISTROS
-- ------------------------------------------------------------

INSERT INTO movimentacoes_estoque (produto_id, cd_id, data_movimento, tipo_mov, quantidade)
SELECT
    FLOOR(1 + RAND()*300),
    FLOOR(1 + RAND()*4),
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*60) DAY),
    ELT(FLOOR(RAND()*4)+1,'entrada','saida','ajuste_positivo','ajuste_negativo'),
    FLOOR(RAND()*50)+1
FROM temp_numbers;

-- ------------------------------------------------------------
-- 8. QUALIDADE OPERACIONAL – 500 REGISTROS
-- ------------------------------------------------------------

INSERT INTO qualidade_operacional (cd_id, data, avarias, erros_inventario, nivel_servico)
SELECT
    FLOOR(1 + RAND()*4),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*60) DAY),
    FLOOR(RAND()*20),
    FLOOR(RAND()*15),
    90 + (RAND()*10)
FROM temp_numbers
WHERE n <= 500;

-- ------------------------------------------------------------
-- 9. VIEWS
-- ------------------------------------------------------------

CREATE VIEW vw_resumo_operacoes AS
SELECT
    DATE(data_operacao) AS dia,
    cd_id,
    tipo_operacao,
    COUNT(*) AS total_ops,
    AVG(tempo_execucao_min) AS tempo_medio
FROM operacoes
GROUP BY dia, cd_id, tipo_operacao;

CREATE VIEW vw_estoque_atual AS
SELECT 
    produto_id,
    cd_id,
    SUM(
        CASE 
            WHEN tipo_mov IN ('entrada','ajuste_positivo') THEN quantidade
            ELSE -quantidade
        END
    ) AS saldo
FROM movimentacoes_estoque
GROUP BY produto_id, cd_id;

-- ------------------------------------------------------------
-- 10. PROCEDIMENTO ETL
-- ------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE etl_qualidade()
BEGIN
    UPDATE qualidade_operacional
    SET nivel_servico = 100 - (avarias + erros_inventario)*0.3;
END //

DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
CALL etl_qualidade();

-- ============================================================
-- FIM DO ARQUIVO
-- ============================================================
