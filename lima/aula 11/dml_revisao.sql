-- Active: 1788268103520@@127.0.0.1@3306@smartcoffee_dml_laura


-- revisao de INSERT

INSERT INTO cliente (nome, email, telefone, cidade, ativo) VALUES
('Laura Rizzo', 'laura@gmail.com', '19999999901', 'Limeira', TRUE),
('Laura C', 'lauraC@gmail.com', '19999999902' 'Limeira', TRUE),
('Leonardo B', 'leonardob@gmail.com', '19999999903', 'Limeira', TRUE),
('Leonardo Bt', 'leonardobt@gmail.com', '19999999904', 'Americana', TRUE),
('Lidia', 'lidia@gmail.com', '19999999905', 'Belem', TRUE),
('Livia', 'livia@gmail.com', NULL, 'Limeira', TRUE),
('Marcos', 'marcos@gmail.com', '19999999907', 'Campo Mourão', TRUE),
('Nicolas N', 'Nicolasn@gmail.com', '19999999908', 'Japao', FALSE),
('Nicolas F', 'Nicolasf@gmail.com', '19999999909', 'Campinas', TRUE),
('Pablo', 'pablo@gmail.com', '19999999910', 'Indaituba', TRUE),
('sophie', 'sophie@gmail.com', '19999999911', 'Campinas', TRUE),
('Vinicius', 'vinicius@gmail.com', NULL, 'Limeira', TRUE),
('vitoria', 'vitoria@gmail.com', '19999999912', 'Limeira', TRUE),
('virginia', 'virginia@gmail.com', '19999999913', 'Boston', TRUE);


INSERT INTO categoria (nome) VALUES 
('Combos Especiais'), ('Nutella');

INSERT INTO pedido (data_pedido,status,valor_total,id_cliente) VALUES
(NOW(), 'ABERTO',0.00,23)


INSERT INTO pedido (data_pedido,status,valor_total,id_cliente) VALUES
(NOW(), 'ABERTO',0.00,24)



SELECT * FROM categoria

SELECT * FROM cliente
where id_cliente = 23;

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, observacao) VALUES
(@pedido, 4, 2, 13.00, 'Nutella');

-------------------------------------------------------------------------------------------------------

-- atualizando dados no bd

UPDATE cliente
SET  telefone = '19999999901'
WHERE id_cliente = 18;


UPDATE cliente
SET  telefone = '19999777701'
    cidade = 'priracicaba'
    ativo = FALSE
WHERE id_cliente = 18;

-------------TOMAR CUIDADO PARA NAO ESQUECER DE COLOCAR O WHERE--------------

UPDATE cliente
SET ativo = FALSE;  

UPDATE pedido
set valor_total = 1.00;

-------------------------------------------------------------------------------

------DICA------
-- EXECUTAR O SELECT SEMPRE ANTES DE ATUALIZAR
-- SELECT * FROM TABELA_QUE_DESEJO

-------------------------------------------------------------------------------

UPDATE produto
SET preco = 
CASE 
    WHEN preco < 30 THEN preco * 1.50 
    ELSE preco * 1.25 
END
WHERE ativo = TRUE;




UPDATE cliente
SET telefone = NULL
WHERE id_cliente = 23;




delete FROM cliente
WHERE id_cliente = 16;

-- PASSO 1: CRIANDO 
INSERT INTO cliente (nome, email, telefone, cidade, ativo) VALUES
('Bruno M', 'bruno@email.com', '1999999913', 'Piracicaba', TRUE);

SET @cliente = LAST_INSERT_ID();

-- PASSO 2: ADICIONANDO UM NOVO PEDIDO
INSERT INTO pedido (data_pedido, status, valor_total, id_cliente) VALUES
(NOW(), 'ABERTO', 0.00, @cliente);

-- PASSO 3: ADICIONANDO ITENS AO PEDIDO
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, observacao) VALUES
(@pedido, 4, 2, 13.00, 'Mel'),
(@pedido, 5, 1, 15.50);

-- PASSO 4: ATUALIZANDO O VALOR TOTAL DO PEDIDO
UPDATE pedido
SET valor_total = 22.00,
    status = 'Preparando'
WHERE id_pedido = @pedido;

-- PASSO 5: REGISTRANDO PAGAMENTO
INSERT into pagamento (id_pedido, id_forma_pagamento, valor, data_pagamento) VALUES
(@pedido, 2, 22.00, NOW());

--CONSULTA DE FORMA COMPLETA

SELECT p.id_pedido,
       c.nome AS cliente,
       p.status,
       p.valor_total
FROM pedido p
JOIN cliente c ON c.id_cliente = p.id_cliente
WHERE p.id_pedido = @pedido; 

SELECT * FROM cliente;

select * FROM cliente
WHERE id_cliente = 23;