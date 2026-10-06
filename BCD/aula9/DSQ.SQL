INSERT INTO cliente (nome,email,telefone,cidade,ativo) VALUES
('Laura R', 'laura@email.com', '19995376784', 'Limeira', TRUE);

SELECT coluna
FROM tabela;

SELECT * FROM cliente;

SELECT nome, email FROM cliente;

select nome AS cliente,
telefone AS contato
FROM cliente;

SELECT nome AS cliente,
        ativo AS STATUS
FROM cliente;

select nome, preco, preco * 0.80 AS preco_promocao
FROM produto; 

SELECT DISTINCT cidade
FROM cliente;

SELECT cidade FROM cliente

-- SEM DISTINCT - aparece varias vezes
-- COM DISTINCT - aparece uma vez


SELECT nome, preco
FROM pedido
whereativo = TRUE

select  id_pedido, id_dataSELECT id_pedido, data_pedido, valor_total
FROM pedido
WHERE valor_total >= 25.00;

-- OUTROS OPERADORES DE COMPARAÇÃO
-- = IGUAL
-- <> != DIFERENTE
-- > MAIOR
-- >= MAIOR IGUAL
-- < MENOR
-- <= MENOR IGUAL

-- EX 6: AND, OR E NOT
-- EXEMPLO COM AND
SELECT nome, preco
FROM produto
WHERE preco >= 8 AND preco <= 20;

-- EXEMPLO COM OR
SELECT nome, cidade
FROM cliente
WHERE cidade = 'Limeira' OR cidade = 'Piracicaba';

select nome, cidade
FROM cliente
where not cidade = 'Limeira';

SELECT nome, cidade, ativo
FROM cliente
WHERE ativo = TRUE
AND (cidade = 'Limeira' or 'cidade' = 'Americana');

SELECT bone, preco
FROM produto
where oreco between 8.00 and 15.00;


SELECT id_produto,  bValor_total
FROM pedido
where data_pedido BETWEEN '2026-09-01 00:00:00' and '2026-09-30 23:59:59';

SELECT nome, cidade
FROM cliente
WHERE cidade IN ('Limeira', 'Americana', 'Piracicaba');

SELECT nome, cidade
FROM cliente
WHERE cidade NOT IN ('Limeira', 'Americana');

select nome 
FROM produto
WHERE cidade NOT IN ('Limeira', 'Americana');

SELECT nome
FROM produto
WHERE nome LIKE 'Café%';

SELECT nome
FROM produto
WHERE nome LIKE '%chocolate%';

SELECT nome
FROM produto
WHERE nome LIKE '_ilva';

SELECT nome
FROM produto
WHERE nome LIKE '%Silva';

SELECT nome
FROM produto
WHERE nome LIKE 'br_';

SELECT nome, telefone
FROM cliente
WHERE telefone IS NULL;

SELECT nome, telefone
FROM cliente
WHERE telefone IS NOT NULL;

SELECT nome, preco
FROM produto
ORDER BY preco ASC;

SELECT nome, preco
FROM produto
ORDER BY preco DESC;

SELECT nome, preco
FROM produto
ORDER BY preco DESC
LIMIT 8; 

SELECT nome, preco
FROM produto
ORDER BY nome
LIMIT 8 OFFSET 8;

SELECT nome, preco, preco * 1.10 AS preco_com_reajuste
FROM produto;

-- CALCULO COM SUBTOTAL
SELECT id_item, quantidade, preco_unitario, quantidade * preco_unitario AS Subtotal
FROM item_pedido;

SELECT CONCAT(nome, ' - ', cidade) AS clientes_cidade
FROM produto;

SELECT nome, preco,  ROUND(preco * 0.90, 2) AS preço_desconto
FROM produto;

SELECT id_pedido, data_pedido, DATE(data_pedido) AS data_pedido, YEAR(data_pedido) AS ano_pedido, MONTH(data_pedido) AS mes_pedido
FROM pedido;

SELECT nome,
COALESCE(telefone, 'nao informado') AS telefone
FROM cliente;

SELECT id_pedido, data_pedido, DATE(data_pedido) AS Data_Pedido, YEAR(data_pedido) AS Ano_Pedido, MONTH(data_pedido) AS Mês_Pedido
FROM pedido;

SELECT nome,
COALESCE(telefone, 'Não Informado') AS telefone
FROM cliente;

SELECT COUNT(*) AS TOTAL_CLIENTES
FROM cliente;

SELECT AVG(preco) AS PREÇO_MÉDIO
FROM produto;

SELECT MIN(preco) AS menores_precos,
MAX(preco) AS maiores_preços,
AVG(preco) AS media_precos
FROM produto;

SELECT SUM(valor_total) AS FATURAMENTO
FROM pedido
WHERE status = 'FINALIZADO';

SELECT cidade,
       COUNT(*) AS quantidade_clientes
FROM cliente
GROUP BY cidade;

SELECT id_categoria,
       COUNT(*) AS Quantidade_Produtos
FROM produto
GROUP BY id_categoria;

SELECT cidade,
COUNT(*) AS quantidade_clientes
FROM cliente
GROUP BY cidade(*)>= 2;

SELECT colunas
FROM tabela
WHERE condicao
GROUP BY colunas_agrupar
HAVING condicao_agrupar
ORDER BY colunas
LIMIT quantidade;

SELECT nome, cidade, COUNT(*) AS Quantidade_clientes
FROM cliente
WHERE cidade = 'Limeira'
GROUP BY cidade 
HAVING COUNT(*) >=3
LIMIT 5;