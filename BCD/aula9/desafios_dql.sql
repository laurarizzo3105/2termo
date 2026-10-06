
-- ============================================================
-- AULA 09 - ATIVIDADE PRÁTICA DE DQL
-- Nome: Laura Rizzo de Araújo Guilherme
-- Turma: 2 TERMO DEV's Castello Data: 06/10/2026
-- Base: smartcoffee_dql
-- ============================================================

-- USE smartcoffee_dql;

-- PARTE A - AQUECIMENTO
-- 1. Liste todos os clientes cadastrados.

SELECT * FROM cliente;

-- 2. Exiba apenas nome, cidade e e-mail dos clientes.

SELECT nome, cidade, email
FROM cliente;

-- 3. Liste os nomes das cidades sem repetir valores.

SELECT DISTINCT cidade
FROM cliente;  

-- 4. Liste todos os produtos em ordem crescente de preço.

SELECT nome, preco
FROM produto
ORDER BY preco ASC;

-- 5. Mostre apenas os 5 produtos mais caros.

SELECT nome, preco
FROM produto
ORDER BY preco DESC
LIMIT 5;


-- PARTE B - FILTROS
-- 6. Liste os produtos com preço entre R$ 8,00 e R$ 15,00.

SELECT nome, preco
FROM produto
WHERE preco BETWEEN 8 AND 15;

-- 7. Liste os clientes das cidades Limeira ou Americana.

SELECT nome, cidade
FROM cliente
WHERE cidade = 'Limeira' OR cidade = 'Americana';

-- 8. Localize os produtos cujo nome contém a palavra “Café”.

SELECT nome, preco
FROM produto
WHERE nome LIKE '%Café%';

-- 9. Liste os clientes que não informaram telefone.

SELECT nome, telefone
FROM cliente
WHERE telefone IS NULL;

-- 10. Mostre os pedidos FINALIZADOS com valor acima de R$ 20,00,
--     do maior para o menor valor.

SELECT id_pedido, data_pedido, valor_total
FROM pedido
WHERE status = 'FINALIZADO' AND valor_total > 20
ORDER BY valor_total ASC;

-- PARTE C - CÁLCULOS E AGRUPAMENTOs

-- 11. Informe quantos produtos estão cadastrados.

SELECT COUNT(*) AS total_produtos
FROM produto;

-- 12. Mostre menor preço, maior preço e preço médio dos produtos.

SELECT MIN(preco) AS menor_preco, MAX(preco) AS maior_preco, AVG(preco) AS preco_medio
FROM produto;

-- 13. Informe quantos clientes existem em cada cidade.

SELECT cidade, COUNT(*) AS total_clientes
FROM cliente
GROUP BY cidade;

-- 14. Mostre somente as cidades que possuem dois ou mais clientes.

SELECT cidade, COUNT(*) AS total_clientes
FROM cliente
GROUP BY cidade
HAVING COUNT(*) >= 2;

-- 15. Calcule o faturamento total considerando apenas pedidos FINALIZADOS.

SELECT SUM(valor_total) AS faturamento_total
FROM pedido
WHERE status = 'FINALIZADO';
