-- ============================================================
-- AULA 08 - ATIVIDADE PRÁTICA DE DML
-- Nome: Laura Rizzo de Araújo guilherme
-- Turma: DEV's Castello 2 TERMO Data:29/09/2026
-- Base: smartcoffee_dml
-- ============================================================
-- USE smartcoffee_dml;

-- IMPORTANTE:
-- Para toda questão de UPDATE ou DELETE, escreva primeiro um SELECT
-- com o mesmo WHERE para validar os registros afetados.

-- PARTE A - INSERT

-- 1. Cadastre dois novos clientes com dados diferentes.

INSERT INTO clientes (nome, telefone, cidade)
VALUES
('Laura', '(11) 98888-1111', 'São Paulo'),
('Matheus', '(21) 97777-2222', 'Rio de Janeiro');


-- 2. Cadastre a categoria 'Especiais da Casa'.
INSERT INTO categorias (nome)
VALUES ('Especiais da Casa');

-- 3. Localize o id da categoria criada e cadastre três produtos nela.

SET @id_categoria = (
    SELECT id
    FROM categorias
    WHERE nome = 'Especiais da Casa'
);

-- 4. Cadastre um terceiro cliente sem telefone.


INSERT INTO clientes (nome, telefone, cidade)
VALUES ('Maria', NULL, 'Campinas');


-- 5. Crie um novo pedido para um dos clientes cadastrados.

SET @id_cliente_pedido = (
    SELECT id
    FROM clientes
    WHERE nome = 'Laura'
);
-- 6. Use LAST_INSERT_ID() para guardar o id do pedido em @pedido_atividade
--    e insira pelo menos dois itens nesse pedido.

INSERT INTO itens_pedido
    (id_pedido, id_produto, quantidade, preco_unitario)
VALUES
(
    @pedido_atividade,
    (SELECT id FROM produtos
     WHERE nome = 'pão'),
    2,
    (SELECT preco FROM produtos
     WHERE nome = 'Café')
),
(
    @pedido_atividade,
    (SELECT id FROM produtos
     WHERE nome = 'Cappuccino'),
    1,
    (SELECT preco FROM produtos
     WHERE nome = 'Cappuccino g')
);

-- PARTE B - UPDATE

-- 7. Corrija o telefone de um dos clientes criados.

-- SELECT de validação:
SELECT *
FROM clientes
WHERE nome = 'Laura';

-- UPDATE:
UPDATE clientes
SET telefone = '(11) 99999-1111'
WHERE nome = 'Laura';

-- SELECT final:
SELECT *
FROM clientes
WHERE nome = 'Laura';

-- 8. Altere cidade e telefone de outro cliente em um único UPDATE.


-- SELECT de validação:
SELECT *
FROM clientes
WHERE nome = 'Matheus';

-- UPDATE:
UPDATE clientes
SET cidade = 'araras',
    telefone = '(31) 96666-3333'
WHERE nome = 'Matheus';

-- SELECT final:
SELECT *
FROM clientes
WHERE nome = 'Matheus';

-- 9. Aumente em 8% o preço dos produtos da categoria 'Especiais da Casa'.

-- SELECT de validação:
SELECT p.*
FROM produtos p
INNER JOIN categorias c
    ON p.id_categoria = c.id
WHERE c.nome = 'Especiais da Casa';

-- UPDATE:
UPDATE produtos p
INNER JOIN categorias c
    ON p.id_categoria = c.id
SET p.preco = p.preco * 1.08
WHERE c.nome = 'Especiais da Casa';

-- SELECT final:
SELECT p.*
FROM produtos p
INNER JOIN categorias c
    ON p.id_categoria = c.id
WHERE c.nome = 'Especiais da Casa';


-- 10. Altere o status do pedido criado para 'PREPARANDO'.

-- SELECT de validação:
SELECT *
FROM pedidos
WHERE id = @pedido_atividade;

-- UPDATE:
UPDATE pedidos
SET status = 'PREPARANDO'
WHERE id = @pedido_atividade;

-- SELECT final:
SELECT *
FROM pedidos
WHERE id = @pedido_atividade;

-- 11. Atualize valor_total do pedido de acordo com os itens cadastrados.
--     Você pode calcular previamente com SELECT SUM(quantidade * preco_unitario).

SELECT
    id_pedido,
    SUM(quantidade * preco_unitario) AS total_calculado
FROM itens_pedido
WHERE id_pedido = @pedido_atividade
GROUP BY id_pedido;

-- SELECT de validação do pedido:
SELECT *
FROM pedidos
WHERE id = @pedido_atividade;

-- UPDATE:
UPDATE pedidos p
SET p.valor_total = (
    SELECT SUM(ip.quantidade * ip.preco_unitario)
    FROM itens_pedido ip
    WHERE ip.id_pedido = p.id
)
WHERE p.id = @pedido_atividade;

-- SELECT final:
SELECT *
FROM pedidos
WHERE id = @pedido_atividade;

-- 12. Escolha um dos produtos criados e faça uma exclusão lógica (ativo = FALSE).

-- SELECT de validação:
SELECT *
FROM produtos
WHERE nome = 'pão';

-- UPDATE:
UPDATE produtos
SET ativo = FALSE
WHERE nome = 'pão';

-- SELECT final:
SELECT *
FROM produtos
WHERE nome = 'pão';


-- PARTE C - DELETE

-- 13. Crie um cliente de teste sem pedidos.
--     Depois localize e exclua apenas esse cliente.

INSERT INTO clientes (nome, telefone, cidade)
VALUES ('Cliente Teste Exclusão', '(41) 95555-4444', 'Curitiba');

SELECT *
FROM clientes
WHERE nome = 'Cliente Teste Exclusão';

SELECT *
FROM clientes
WHERE nome = 'Cliente Teste Exclusão';

DELETE FROM clientes
WHERE nome = 'Cliente Teste Exclusão';

SELECT *
FROM clientes
WHERE nome = 'Cliente Teste Exclusão';


-- 14. Tente excluir um cliente da base original que possua pedidos.
--     Deixe o DELETE comentado após o teste e descreva o erro abaixo.
-- Resultado observado:


-- 15. Explique em comentário por que a FK bloqueou a exclusão.
-- Resposta:


-- 16. Crie uma categoria temporária chamada 'Excluir Depois' e remova-a.

