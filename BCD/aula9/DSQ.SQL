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

SELECT cidade, COUNT(*) AS Quantidade_clientes
FROM cliente
WHERE cidade = 'Limeira'
GROUP BY cidade 
HAVING COUNT(*) >=3
LIMIT 5;


-- PARTE 2 : RELACIONAMENTO DE TABELAS 
-- USO DE JOINS
-- INNER JOIN
-- EX 19 - PEDIDOS COM O NOME DO CLIENTE
SELECT P.ID_PEDIDO, P.DATA_PEDIDO, C.NOME AS CLIENTE, P.VALOR_TOTAL
FROM pedido AS P
INNER JOIN cliente AS C
ON C.id_cliente = P.id_cliente

select p.id_pedido, p.data_pedido, c.nome as cliente, p.valor_total
from pedido as P
inner join cliente as c
on c.id_cliente = p.id_cliente

-- obs: relacione o cliente cujo id_cliente é igual id_cliente gravado no pedido
-- aliases sao atribuição e pedidos para consukltas de varias tabelas mais curtas e legiveis

-- left join mantem trodos os registros da tabela da esquerda mesmo quando nao possui correspondencia
-- ex20 - todos os clientes incliusive quem nunca comprou

select c.nome, p.id_pedido, p.data_pedido
from cliente as c
left join pedido as p 
on p.id_cliente = c.id_cliente
order by c.nome;

-- ex21 clientes sem pedido

SELECT C.ID_CLIENTE, C.NOME
FROM CLIENTE AS C
LEFT JOIN PEDIDO AS P
ON P.ID_CLIENTE = C.ID_CLIENTE
WHERE P.ID_PEDIDO IS NULL;

-- ex22 itens de pedido com nome do produto

SELECT P.ID_PEDIDO, PR.NOME AS PRODUTO, IP.QUANTIDADE, IP.PRECO_UNITARIO, IP.QUANTIDADE * IP.PRECO_UNITARIO AS SUBTOTAL
FROM PEDIDO AS P
inner join item_pedido as IP
on ip.id_pedido = p.id_pedido
inner join produto as pr
on pr.id_produto = ip.id_produto
order by p.id_pedido; 

-- EX23 - JOINS COM CATEGORIA - PRODUTO E NOME DE SUA CATEGORIA

SELECT PR.NOME AS PRODUTO, CA.NOME AS CATEGORIA, PR.PRECO
FROM PRODUTO AS PR
INNER JOIN CATEGORIA AS CA
ON CA.ID_CATEGORIA = PR.ID_CATEGORIA
ORDER BY CA.NOME, PR.NOME;

-- 24 - QUANTIDADE DE PRODUTOS POR CATEGORIA

SELECT CA.NOME AS CATEGORIA, COUNT(PR.ID_PRODUTO) AS QTDE_PRODUTOS
FROM CATEGORIA AS CA
LEFT JOIN PRODUTO AS PR
ON PR.ID_CATEGORIA = C.ID_CATEGORIA
GROUP BY CA.ID_CATEGORIA, CA.NOME
ORDER BY QTDE_PRODUTOS DESC;

-- EX25 - TOTAL COMPRADO POR CLIENTE
SELECT C.NOME AS CLIENTE, COUNT(P.ID_PEDIDO) AS QTDE_PEDIDOS, SUM(P.VALOR_TOTAL) AS TOTAL_COMPRADO
FROM CLIENTE AS C
INNER JOIN PEDIDO AS P
ON P.ID_CLIENTE = C.ID_CLIENTE
WHERE P.STATUS = 'ABERTO'
GROUP BY C.ID_CLIENTE, C.NOME 
ORDER BY TOTAL_COMPRADO DESC;

-- RELATÓRIO COMPLETO DO PEDIDO
-- EX 26: COMBINAÇÃO DE VÁRIAS TABELAS PARA UMA CONSULTA COMPLETA

SELECT
P.ID_PEDIDO, DATE_FORMAT(P.DATA_PEDIDO, '%d/%m/%Y') AS DATA, C.NOME AS CLIENTE, PR.NOME AS PRODUTO, IP.QUANTIDADE, IP.PRECO_UNITARIO, IP.QUANTIDADE * IP.PRECO_UNITARIO AS SUBTOTAL
FROM PEDIDO AS P
INNER JOIN CLIENTE AS C
ON C.ID_CLIENTE = P.ID_CLIENTE
INNER JOIN ITEM_PEDIDO AS IP
ON IP.ID_PEDIDO = P.ID_PEDIDO
INNER JOIN PRODUTO AS PR
ON PR.ID_PRODUTO = IP.ID_PRODUTO;
ORDER BY P.ID_PEDIDO, PR.NOME;


SELECT NOME, PRECO,
CASE 
WHEN PRECO < 8.00 THEN 'ECONOMICO' 
WHEN PRECO <= 15.00 THEN 'INTERMEDIARIO'
ELSE 'PREMIUM'
END AS CLASSIFICAÇÃO_PRECOS
FROM PRODUTO 
ORDER BY PRECO; 

-- EX28 PRODUTOS ACIMA DO PRECO MEDIO
SELECT NOME, PRECO 
FROM PRODUTO 
WHERE PRECO > (SELECT AVG(PRECO)FROM PRODUTO)
ORDER BY PRECO DESC;