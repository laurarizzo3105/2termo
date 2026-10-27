-- PARTE A
-- 1. 


INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) VALUES
('MARIA FERNANDA', 'MARIA@EMAIL', '19999999999', 'PIRACICABA', TRUE),
('JOAO PEDRO', 'JOAO@EMAIL', '19988888888', 'RIO CLARO', TRUE);



-- 2.
INSERT INTO CATEGORIA (NOME_CATEGORIA) VALUES
('ESPECIAIS DA CASA');
SET @CATEGORIA = LAST_INSERT_ID();



-- 3. 
INSERT INTO PRODUTO (NOME_PRODUTO, PRECO, ATIVO, ID_CATEGORIA) VALUES
('PIZZA', 20.00, TRUE, @CATEGORIA),
('FETUCCINI', 25.00, TRUE, @CATEGORIA),
('LASANHA', 30.00, TRUE, @CATEGORIA);


-- 4.
INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) VALUES
('LUCAS SILVA', 'LUCAS@EMAIL', NULL, 'PIRACICABA', TRUE);
SET @CLIENTE = LAST_INSERT_ID();



-- 5. 
INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) VALUES
(NOW(), 'PENDENTE', 0.00, @CLIENTE);
SET @PEDIDO = LAST_INSERT_ID();



-- 6.
INSERT INTO ITEM_PEDIDO (ID_PEDIDO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES
(@PEDIDO, 1, 2, 20.00),
(@PEDIDO, 2, 1, 25.00);



-- PARTE B - UPDATE
-- 7. 
UPDATE CLIENTE
SET TELEFONE = '19999945999'
WHERE ID_CLIENTE = 15;


-- 8.
UPDATE CLIENTE
SET TELEFONE = '19999945989',
    CIDADE = 'RIO CLARO'
WHERE ID_CLIENTE = 16;



-- 9. 
UPDATE PRODUTO
SET PRECO = PRECO * 1.08
WHERE ID_CATEGORIA = @CATEGORIA;



-- 10. 
UPDATE PEDIDO
SET STATUS_PEDIDO = 'PREPARANDO'
WHERE ID_PEDIDO = @PEDIDO;




-- 11.
UPDATE PEDIDO
SET VALOR_TOTAL = (
    SELECT SUM(QUANTIDADE * PRECO_UNITARIO)
    FROM ITEM_PEDIDO
    WHERE ID_PEDIDO = @PEDIDO
)
WHERE ID_PEDIDO = @PEDIDO;



-- 12. 
UPDATE PRODUTO
SET ATIVO = FALSE
WHERE NOME_PRODUTO = 'PIZZA' AND ID_CATEGORIA = @CATEGORIA;



-- PARTE C - DELETE
-- 13. 
INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) VALUES
('CLIENTE TESTE', 'TESTE@EMAIL.COM', '19900000000', 'LIMEIRA', TRUE);
SET @CLIENTE_TESTE = LAST_INSERT_ID();
DELETE FROM CLIENTE 
WHERE ID_CLIENTE = @CLIENTE_TESTE;



-- 14. 
DELETE FROM CLIENTE 
WHERE ID_CLIENTE = @CLIENTE;



-- 15) Foreign Key garante a integridade referencial do banco de dados. 
-- Ela impede a formação de dados "órfãos" — neste caso, um registro na tabela 
-- PEDIDO que apontaria para um ID_CLIENTE inexistente. Para deletar o cliente, 
-- seria necessário antes tratar os registros filhos.



-- 16. Crie uma categoria de teste sem produtos e depois remova-a.
INSERT INTO CATEGORIA (NOME_CATEGORIA) VALUES
('CATEGORIA TESTE');
SET @CATEGORIA_TESTE = LAST_INSERT_ID();
DELETE FROM CATEGORIA 
WHERE ID_CATEGORIA = @CATEGORIA_TESTE;



-- PARTE D - INTEGRIDADE E ERROS CONTROLADOS
-- 17. 

-- INSERT INTO PRODUTO (NOME_PRODUTO, PRECO, ATIVO, ID_CATEGORIA) 
-- VALUES ('MOCHA ESPECIAL', 12.00, TRUE, 9999);
-- Restrição que impediu: FOREIGN KEY (Chave Estrangeira).
-- Explicação: A coluna ID_CATEGORIA na tabela PRODUTO é uma FK que exige que o ID exista previamente na tabela pai (CATEGORIA). O ID 9999 não existe.




-- 18. Tente cadastrar um cliente usando 'ana@email.com'.
-- INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) 
-- VALUES ('ANA PAULA', 'ana@email.com', '19977776666', 'LIMEIRA', TRUE);
-- Restrição que impediu: UNIQUE (Restrição de Unicidade).
-- Explicação: A coluna EMAIL foi configurada com a restrição UNIQUE, impedindo a inserção de valores duplicados para clientes distintos.




-- 19. Tente criar um pedido com id_cliente = 9999.
-- INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) 
-- VALUES (NOW(), 'PENDENTE', 0.00, 9999);
-- Restrição que impediu: FOREIGN KEY (Chave Estrangeira).
-- Explicação: A coluna ID_CLIENTE na tabela PEDIDO é uma FK apontando para CLIENTE. A operação falha pois o ID 9999 não corresponde a nenhum cliente cadastrado.




-- 20. Diferença entre os três erros anteriores:
/*
Questões 17 e 19 (FOREIGN KEY): Erros de Integridade Referencial. Impedem o vínculo 
  de um registro em uma tabela "filha" (PRODUTO/PEDIDO) a um registro inexistente em uma tabela "pai" (CATEGORIA/CLIENTE).
  
Questão 18 (UNIQUE): Erro de Integridade de Unicidade/Entidade. Impede a repetição de um valor 
  em uma coluna específica, garantindo que cada registro possua uma identificação exclusiva para aquele atributo.
*/




-- PARTE E - DESAFIO COMPLETO COM TRANSAÇÃO
-- 21. Inicie uma transação.
START TRANSACTION;




-- 22. Dentro dela, cadastre um cliente, um pedido e dois itens relacionados.
INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) VALUES
('CARLOS EDUARDO', 'CARLOS.ED@EMAIL.COM', '19981112233', 'LIMEIRA', TRUE);
SET @ID_CLIENTE_TRANS = LAST_INSERT_ID();
INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) VALUES
(NOW(), 'PENDENTE', 45.00, @ID_CLIENTE_TRANS);
SET @ID_PEDIDO_TRANS = LAST_INSERT_ID();
INSERT INTO ITEM_PEDIDO (ID_PEDIDO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES
(@ID_PEDIDO_TRANS, 1, 1, 20.00),
(@ID_PEDIDO_TRANS, 2, 1, 25.00);




-- 23. Faça uma consulta com JOIN comprovando que os registros existem enquanto a transação está aberta.
SELECT 
    C.NOME AS CLIENTE,
    P.ID_PEDIDO,
    P.STATUS_PEDIDO,
    PR.NOME_PRODUTO,
    I.QUANTIDADE,
    I.PRECO_UNITARIO,
    (I.QUANTIDADE * I.PRECO_UNITARIO) AS SUBTOTAL
FROM CLIENTE C
JOIN PEDIDO P ON C.ID_CLIENTE = P.ID_CLIENTE
JOIN ITEM_PEDIDO I ON P.ID_PEDIDO = I.ID_PEDIDO
JOIN PRODUTO PR ON I.ID_PRODUTO = PR.ID_PRODUTO
WHERE C.ID_CLIENTE = @ID_CLIENTE_TRANS;




-- 24. Execute ROLLBACK e depois use SELECT para provar que o cadastro foi desfeito.
ROLLBACK;
-- Consultas de verificação pós-ROLLBACK (devem retornar conjunto vazio)
SELECT * FROM CLIENTE WHERE EMAIL = 'CARLOS.ED@EMAIL.COM';
SELECT * FROM PEDIDO WHERE ID_PEDIDO = @ID_PEDIDO_TRANS;





-- 25. Repita o processo com novos dados e finalize usando COMMIT. Depois consulte os registros persistidos.
START TRANSACTION;
INSERT INTO CLIENTE (NOME, EMAIL, TELEFONE, CIDADE, ATIVO) VALUES
('FERNANDA LIMA', 'FERNANDA.LIMA@EMAIL.COM', '19984445566', 'PIRACICABA', TRUE);
SET @ID_CLIENTE_COMMIT = LAST_INSERT_ID();
INSERT INTO PEDIDO (DATA_PEDIDO, STATUS_PEDIDO, VALOR_TOTAL, ID_CLIENTE) VALUES
(NOW(), 'PENDENTE', 55.00, @ID_CLIENTE_COMMIT);
SET @ID_PEDIDO_COMMIT = LAST_INSERT_ID();
INSERT INTO ITEM_PEDIDO (ID_PEDIDO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO) VALUES
(@ID_PEDIDO_COMMIT, 1, 2, 20.00),
(@ID_PEDIDO_COMMIT, 2, 1, 15.00);
COMMIT;
SELECT 
    C.NOME AS CLIENTE,
    P.ID_PEDIDO,
    P.STATUS_PEDIDO,
    P.VALOR_TOTAL,
    PR.NOME_PRODUTO,
    I.QUANTIDADE
FROM CLIENTE C
JOIN PEDIDO P ON C.ID_CLIENTE = P.ID_CLIENTE
JOIN ITEM_PEDIDO I ON P.ID_PEDIDO = I.ID_PEDIDO
JOIN PRODUTO PR ON I.ID_PRODUTO = PR.ID_PRODUTO
WHERE C.ID_CLIENTE = @ID_CLIENTE_COMMIT;




-- DESAFIO EXTRA
-- 26. Regra de Negócio SmartCoffee:
-- Cenário: Indisponibilidade temporária de insumo de um produto do cardápio.
-- Regra: Quando um ingrediente esgota ou apresenta problema de lote, o sistema registra uma 
-- notificação de ocorrência no histórico do estabelecimento (INSERT) e executa a exclusão lógica 
-- do produto (UPDATE no campo ATIVO = FALSE), impedindo novos pedidos do item sem apagar seu histórico de vendas.
-- Implementação da Regra de Negócio (INSERT + UPDATE):
-- Passo 1: Registro do log/ocorrência de alteração no cardápio
INSERT INTO OCORRENCIA_ESTOQUE (DESCRICAO, DATA_OCORRENCIA, ID_PRODUTO) VALUES
('Lote de grãos de Café Espresso esgotado temporariamente', NOW(), 1);
-- Passo 2: Exclusão lógica do produto no sistema SmartCoffee
UPDATE PRODUTO
SET ATIVO = FALSE
WHERE ID_PRODUTO = 1;