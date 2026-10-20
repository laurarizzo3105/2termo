
-- -- ============================================================
-- -- AULA 09 - ATIVIDADE PRÁTICA DE DQL
-- -- Nome: Laura Rizzo de Araújo Guilherme
-- -- Turma: 2 TERMO DEV's Castello Data: 06/10/2026
-- -- Base: smartcoffee_dql
-- -- ============================================================

-- -- USE smartcoffee_dql;

-- -- PARTE A - AQUECIMENTO
-- -- 1. Liste todos os clientes cadastrados.

-- SELECT * FROM cliente;

-- -- 2. Exiba apenas nome, cidade e e-mail dos clientes.

-- SELECT nome, cidade, email
-- FROM cliente;

-- -- 3. Liste os nomes das cidades sem repetir valores.

-- SELECT DISTINCT cidade
-- FROM cliente;  

-- -- 4. Liste todos os produtos em ordem crescente de preço.

-- SELECT nome, preco
-- FROM produto
-- ORDER BY preco ASC;

-- -- 5. Mostre apenas os 5 produtos mais caros.

-- SELECT nome, preco
-- FROM produto
-- ORDER BY preco DESC
-- LIMIT 5;


-- -- PARTE B - FILTROS
-- -- 6. Liste os produtos com preço entre R$ 8,00 e R$ 15,00.

-- SELECT nome, preco
-- FROM produto
-- WHERE preco BETWEEN 8 AND 15;

-- -- 7. Liste os clientes das cidades Limeira ou Americana.

-- SELECT nome, cidade
-- FROM cliente
-- WHERE cidade = 'Limeira' OR cidade = 'Americana';

-- -- 8. Localize os produtos cujo nome contém a palavra “Café”.

-- SELECT nome, preco
-- FROM produto
-- WHERE nome LIKE '%Café%';

-- -- 9. Liste os clientes que não informaram telefone.

-- SELECT nome, telefone
-- FROM cliente
-- WHERE telefone IS NULL;

-- -- 10. Mostre os pedidos FINALIZADOS com valor acima de R$ 20,00,
-- --     do maior para o menor valor.

-- SELECT id_pedido, data_pedido, valor_total
-- FROM pedido
-- WHERE status = 'FINALIZADO' AND valor_total > 20
-- ORDER BY valor_total ASC;

-- -- PARTE C - CÁLCULOS E AGRUPAMENTOs

-- -- 11. Informe quantos produtos estão cadastrados.

-- SELECT COUNT(*) AS total_produtos
-- FROM produto;

-- -- 12. Mostre menor preço, maior preço e preço médio dos produtos.

-- SELECT MIN(preco) AS menor_preco, MAX(preco) AS maior_preco, AVG(preco) AS preco_medio
-- FROM produto;

-- -- 13. Informe quantos clientes existem em cada cidade.

-- SELECT cidade, COUNT(*) AS total_clientes
-- FROM cliente
-- GROUP BY cidade;

-- -- 14. Mostre somente as cidades que possuem dois ou mais clientes.

-- SELECT cidade, COUNT(*) AS total_clientes
-- FROM cliente
-- GROUP BY cidade
-- HAVING COUNT(*) >= 2;

-- -- 15. Calcule o faturamento total considerando apenas pedidos FINALIZADOS.

-- SELECT SUM(valor_total) AS faturamento_total
-- FROM pedido
-- WHERE status = 'FINALIZADO';


-- -- PARTE D - INTEGRIDADE E ERROS CONTROLADOS
-- -- Execute uma tentativa por vez. Depois deixe o comando problemático comentado.

-- -- 17. Tente inserir um produto com id_categoria = 9999.
-- -- Qual restrição impediu a operação?

-- INSERT INTO PRODUTO (NOME_PRODUTO, PRECO, ATIVO, ID_CATEGORIA) 
-- VALUES ('MOCHA ESPECIAL', 12.00, TRUE, 9999);
-- -- Restrição que impediu: FOREIGN KEY (Chave Estrangeira).
-- -- Explicação: A coluna ID_CATEGORIA na tabela PRODUTO é uma FK que exige que o ID exista previamente na tabela pai (CATEGORIA). O ID 9999 não existe.

-- -- 18. Tente cadastrar um cliente usando 'ana@email.com'.
-- -- Qual restrição impediu a operação?

-- INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) 
-- VALUES ('ANA PAULA', 'ana@email.com', '19977776666', 'LIMEIRA', TRUE);

-- -- 19. Tente criar um pedido com id_cliente = 9999.
-- -- Qual restrição impediu a operação?

-- INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) 
-- VALUES (NOW(), 'PENDENTE', 0.00, 9999);

-- -- 20. Escreva em comentários a diferença entre os três erros anteriores.

-- -- Questões 17 e 19 (FOREIGN KEY): Erros de Integridade Referencial. Impedem o vínculo 
-- --   de um registro em uma tabela "filha" (PRODUTO/PEDIDO) a um registro inexistente em uma tabela "pai" (CATEGORIA/CLIENTE).
  
-- -- Questão 18 (UNIQUE): Erro de Integridade de Unicidade/Entidade. Impede a repetição de um valor 
-- --   em uma coluna específica, garantindo que cada registro possua uma identificação exclusiva para aquele atributo.

-- -- PARTE E - DESAFIO COMPLETO COM TRANSAÇÃO

-- -- 21. Inicie uma transação.

-- START TRANSACTION;

-- -- 22. Dentro dela, cadastre um cliente, um pedido e dois itens relacionados.

-- INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) VALUES
-- ('CARLOS EDUARDO', 'CARLOS.ED@EMAIL.COM', '19981112233', 'LIMEIRA', TRUE);
-- SET @ID_CLIENTE_TRANS = LAST_INSERT_ID();
-- INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) VALUES
-- (NOW(), 'PENDENTE', 45.00, @ID_CLIENTE_TRANS);
-- SET @ID_PEDIDO_TRANS = LAST_INSERT_ID();
-- INSERT INTO ITEM_PEDIDO (ID_PEDIDO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES
-- (@ID_PEDIDO_TRANS, 1, 1, 20.00),
-- (@ID_PEDIDO_TRANS, 2, 1, 25.00);

-- -- 23. Faça uma consulta com JOIN comprovando que os registros existem
-- --     enquanto a transação está aberta.

-- SELECT 
-- C.NOME AS CLIENTE,
-- P.ID_PEDIDO,
-- P.STATUS_PEDIDO,
-- PR.NOME_PRODUTO,
-- I.QUANTIDADE,
-- I.PRECO_UNITARIO,
-- (I.QUANTIDADE * I.PRECO_UNITARIO) AS SUBTOTAL
-- FROM CLIENTE C
-- JOIN PEDIDO P ON C.ID_CLIENTE = P.ID_CLIENTE
-- JOIN ITEM_PEDIDO I ON P.ID_PEDIDO = I.ID_PEDIDO
-- JOIN PRODUTO PR ON I.ID_PRODUTO = PR.ID_PRODUTO
-- WHERE C.ID_CLIENTE = @ID_CLIENTE_TRANS;

-- -- 24. Execute ROLLBACK e depois use SELECT para provar que o cadastro foi desfeito.

-- ROLLBACK;
-- SELECT * FROM CLIENTE WHERE EMAIL = 'CARLOS.ED@EMAIL.COM';
-- SELECT * FROM PEDIDO WHERE ID_PEDIDO = @ID_PEDIDO_TRANS;

-- -- 25. Repita o processo com novos dados e finalize usando COMMIT.
-- --     Depois consulte os registros persistidos.

-- START TRANSACTION;
-- INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) VALUES
-- ('FERNANDA LIMA', 'FERNANDA.LIMA@EMAIL.COM', '19984445566', 'PIRACICABA', TRUE);
-- SET @ID_CLIENTE_COMMIT = LAST_INSERT_ID();
-- INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) VALUES
-- (NOW(), 'PENDENTE', 55.00, @ID_CLIENTE_COMMIT);
-- SET @ID_PEDIDO_COMMIT = LAST_INSERT_ID();
-- INSERT INTO ITEM_PEDIDO (ID_PEDIDO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES
-- (@ID_PEDIDO_COMMIT, 1, 2, 20.00),
-- (@ID_PEDIDO_COMMIT, 2, 1, 15.00);
-- COMMIT;
-- SELECT 
-- C.NOME AS CLIENTE,
-- P.ID_PEDIDO,
-- P.STATUS_PEDIDO,
-- P.VALOR_TOTAL,
-- PR.NOME_PRODUTO,
-- I.QUANTIDADE
-- FROM CLIENTE C
-- JOIN PEDIDO P ON C.ID_CLIENTE = P.ID_CLIENTE
-- JOIN ITEM_PEDIDO I ON P.ID_PEDIDO = I.ID_PEDIDO
-- JOIN PRODUTO PR ON I.ID_PRODUTO = PR.ID_PRODUTO
-- WHERE C.ID_CLIENTE = @ID_CLIENTE_COMMIT;

-- -- DESAFIO EXTRA
-- -- 26. Escolha uma situação realista do SmartCoffee que exija INSERT + UPDATE
-- --     ou UPDATE + DELETE lógico. Descreva a regra de negócio e implemente.

-- INSERT INTO CATEGORIA (NOME_CATEGORIA) VALUES
-- ('CATEGORIA TESTE');
-- SET @CATEGORIA_TESTE = LAST_INSERT_ID();
-- DELETE FROM CATEGORIA 
-- WHERE ID_CATEGORIA = @CATEGORIA_TESTE;
-- -- PARTE D - INTEGRIDADE E ERROS CONTROLADOS
-- -- 17. Tente inserir um produto com id_categoria = 9999.
-- -- INSERT INTO PRODUTO (NOME_PRODUTO, PRECO, ATIVO, ID_CATEGORIA) 
-- -- VALUES ('MOCHA ESPECIAL', 12.00, TRUE, 9999);
-- -- Restrição que impediu: FOREIGN KEY (Chave Estrangeira).
-- -- Explicação: A coluna ID_CATEGORIA na tabela PRODUTO é uma FK que exige que o ID exista previamente na tabela pai (CATEGORIA). O ID 9999 não existe.
-- -- 18. Tente cadastrar um cliente usando 'ana@email.com'.
-- -- INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) 
-- -- VALUES ('ANA PAULA', 'ana@email.com', '19977776666', 'LIMEIRA', TRUE);
-- -- Restrição que impediu: UNIQUE (Restrição de Unicidade).
-- -- Explicação: A coluna EMAIL foi configurada com a restrição UNIQUE, impedindo a inserção de valores duplicados para clientes distintos.
-- -- 19. Tente criar um pedido com id_cliente = 9999.
-- -- INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) 
-- -- VALUES (NOW(), 'PENDENTE', 0.00, 9999);
-- -- Restrição que impediu: FOREIGN KEY (Chave Estrangeira).
-- -- Explicação: A coluna ID_CLIENTE na tabela PEDIDO é uma FK apontando para CLIENTE. A operação falha pois o ID 9999 não corresponde a nenhum cliente cadastrado.
-- -- 20. Diferença entre os três erros anteriores:
-- /*
-- Questões 17 e 19 (FOREIGN KEY): Erros de Integridade Referencial. Impedem o vínculo 
--   de um registro em uma tabela "filha" (PRODUTO/PEDIDO) a um registro inexistente em uma tabela "pai" (CATEGORIA/CLIENTE).
  
-- Questão 18 (UNIQUE): Erro de Integridade de Unicidade/Entidade. Impede a repetição de um valor 
--   em uma coluna específica, garantindo que cada registro possua uma identificação exclusiva para aquele atributo.
-- */
-- -- PARTE E - DESAFIO COMPLETO COM TRANSAÇÃO
-- -- 21. Inicie uma transação.
-- START TRANSACTION;
-- -- 22. Dentro dela, cadastre um cliente, um pedido e dois itens relacionados.
-- INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) VALUES
-- ('CARLOS EDUARDO', 'CARLOS.ED@EMAIL.COM', '19981112233', 'LIMEIRA', TRUE);
-- SET @ID_CLIENTE_TRANS = LAST_INSERT_ID();
-- INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) VALUES
-- (NOW(), 'PENDENTE', 45.00, @ID_CLIENTE_TRANS);
-- SET @ID_PEDIDO_TRANS = LAST_INSERT_ID();
-- INSERT INTO ITEM_PEDIDO (ID_PEDIDO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES
-- (@ID_PEDIDO_TRANS, 1, 1, 20.00),
-- (@ID_PEDIDO_TRANS, 2, 1, 25.00);
-- -- 23. Faça uma consulta com JOIN comprovando que os registros existem enquanto a transação está aberta.
-- SELECT 
--     C.NOME AS CLIENTE,
--     P.ID_PEDIDO,
--     P.STATUS_PEDIDO,
--     PR.NOME_PRODUTO,
--     I.QUANTIDADE,
--     I.PRECO_UNITARIO,
--     (I.QUANTIDADE * I.PRECO_UNITARIO) AS SUBTOTAL
-- FROM CLIENTE C
-- JOIN PEDIDO P ON C.ID_CLIENTE = P.ID_CLIENTE
-- JOIN ITEM_PEDIDO I ON P.ID_PEDIDO = I.ID_PEDIDO
-- JOIN PRODUTO PR ON I.ID_PRODUTO = PR.ID_PRODUTO
-- WHERE C.ID_CLIENTE = @ID_CLIENTE_TRANS;
-- -- 24. Execute ROLLBACK e depois use SELECT para provar que o cadastro foi desfeito.
-- ROLLBACK;
-- -- Consultas de verificação pós-ROLLBACK (devem retornar conjunto vazio)
-- SELECT * FROM CLIENTE WHERE EMAIL = 'CARLOS.ED@EMAIL.COM';
-- SELECT * FROM PEDIDO WHERE ID_PEDIDO = @ID_PEDIDO_TRANS;
-- -- 25. Repita o processo com novos dados e finalize usando COMMIT. Depois consulte os registros persistidos.
-- START TRANSACTION;
-- INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) VALUES
-- ('FERNANDA LIMA', 'FERNANDA.LIMA@EMAIL.COM', '19984445566', 'PIRACICABA', TRUE);
-- SET @ID_CLIENTE_COMMIT = LAST_INSERT_ID();
-- INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) VALUES
-- (NOW(), 'PENDENTE', 55.00, @ID_CLIENTE_COMMIT);
-- SET @ID_PEDIDO_COMMIT = LAST_INSERT_ID();
-- INSERT INTO ITEM_PEDIDO (ID_PEDIDO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES
-- (@ID_PEDIDO_COMMIT, 1, 2, 20.00),
-- (@ID_PEDIDO_COMMIT, 2, 1, 15.00);
-- COMMIT;
-- SELECT 
--     C.NOME AS CLIENTE,
--     P.ID_PEDIDO,
--     P.STATUS_PEDIDO,
--     P.VALOR_TOTAL,
--     PR.NOME_PRODUTO,
--     I.QUANTIDADE
-- FROM CLIENTE C
-- JOIN PEDIDO P ON C.ID_CLIENTE = P.ID_CLIENTE
-- JOIN ITEM_PEDIDO I ON P.ID_PEDIDO = I.ID_PEDIDO
-- JOIN PRODUTO PR ON I.ID_PRODUTO = PR.ID_PRODUTO
-- WHERE C.ID_CLIENTE = @ID_CLIENTE_COMMIT;
-- -- DESAFIO EXTRA
-- -- 26. Regra de Negócio SmartCoffee:
-- -- Cenário: Indisponibilidade temporária de insumo de um produto do cardápio.
-- -- Regra: Quando um ingrediente esgota ou apresenta problema de lote, o sistema registra uma 
-- -- notificação de ocorrência no histórico do estabelecimento (INSERT) e executa a exclusão lógica 
-- -- do produto (UPDATE no campo ATIVO = FALSE), impedindo novos pedidos do item sem apagar seu histórico de vendas.
-- -- Implementação da Regra de Negócio (INSERT + UPDATE):
-- -- Passo 1: Registro do log/ocorrência de alteração no cardápio
-- INSERT INTO OCORRENCIA_ESTOQUE (DESCRICAO, DATA_OCORRENCIA, ID_PRODUTO) VALUES
-- ('Lote de grãos de Café Espresso esgotado temporariamente', NOW(), 1);
-- -- Passo 2: Exclusão lógica do produto no sistema SmartCoffee
-- UPDATE PRODUTO
-- SET ATIVO = FALSE
-- WHERE ID_PRODUTO = 1;