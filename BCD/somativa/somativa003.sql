CREATE DATABASE biblioteca_som2;
USE biblioteca_som2;


CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE, 
    telefone VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE 
);

CREATE TABLE LIVRO (
    id_livro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(120) NOT NULL, 
    isbn CHAR(13) NOT NULL UNIQUE, 
    ano_publicacao INT,
    quantidade_disponivel INT DEFAULT 0, 
    CHECK (quantidade_disponivel >= 0) 
);

CREATE TABLE EMPRESTIMO (
    id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    data_emprestimo DATETIME DEFAULT CURRENT_TIMESTAMP, 
    data_prevista DATE NOT NULL, 
    data_devolucao DATE,
    status_emprestimo VARCHAR(20) DEFAULT 'ABERTO',
    id_usuario INT NOT NULL, 
    id_livro INT NOT NULL, 
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE, 
    FOREIGN KEY (id_livro) REFERENCES LIVRO(id_livro)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (status_emprestimo IN ('ABERTO', 'DEVOLVIDO', 'ATRASADO')) 
);

CREATE table responsavel (
    id_responsavel INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100),
    cpf VARCHAR(11) UNIQUE,
    matricula VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE multas (
    id_multa INT AUTO_INCREMENT PRIMARY KEY,
    id_emprestimo INT NOT NULL,
    valor_multa DECIMAL(10,2) NOT NULL,
    motivo VARCHAR(255) DEFAULT 'Atraso na devolução',
    status_pagamento VARCHAR(20) DEFAULT 'Pendente',
    data_geracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_pagamento TIMESTAMP NULL,
    FOREIGN KEY (id_emprestimo) REFERENCES emprestimos(id_emprestimo)
);


ALTER TABLE LIVRO
ADD COLUMN editora VARCHAR(100);

INSERT INTO USUARIO (nome, email, telefone)
VALUES
('Ana Silva', 'ana@email.com', '19987654321'),
('Bruno Souza', 'bruno@email.com', NULL),
('Carla Oliveira', 'carla@email.com', '19991234567'),
('Daniel Santos', 'daniel@email.com', '19998887766');

INSERT INTO LIVRO
(titulo, autor, isbn, ano_publicacao, quantidade_disponivel, editora)
VALUES
('O Sol é para Todos', 'Harper Lee', '9788501075758', 1960, 5),
('O Pequeno Principe', 'Antoine de Saint-Exupery', '9788522031382', 1943, 2),
('Fahrenheit 451 ', 'Ray Bradbury', '9788525052247',  1953, 0),
('O Hobbit', 'J.R.R. Tolkien', '9788595084741', 1937, 4),
('Admirável Mundo Novo', 'Aldous Huxley', '9788501111661', 1932, 1),
('Biblioteca da Meia-Noite', 'Matt Haig', '9786555650590', 2020, 3);

INSERT INTO EMPRESTIMO
(data_prevista, status_emprestimo, id_usuario, id_livro)
VALUES
('2026-11-10', 'ABERTO', 1, 1),
('2026-11-12', 'ABERTO', 2, 2),
('2026-11-15', 'ABERTO', 3, 4);

SELECT * FROM USUARIO WHERE id_usuario = 1;

UPDATE USUARIO
SET telefone = '19990001122'
WHERE id_usuario = 1;

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 2
WHERE ano_publicacao >= 2020;

INSERT INTO USUARIO (nome, email, telefone)
VALUES ('Usuario Temporario', 'temporario@email.com', NULL);

DELETE FROM USUARIO WHERE email = 'temporario@email.com';

SELECT titulo, autor, quantidade_disponivel
FROM LIVRO;

SELECT titulo, quantidade_disponivel
FROM LIVRO
WHERE quantidade_disponivel > 2
ORDER BY quantidade_disponivel DESC;

SELECT *
FROM LIVRO
WHERE titulo LIKE '%O%';

SELECT titulo, autor, ano_publicacao
FROM LIVRO
WHERE ano_publicacao BETWEEN 2015 AND 2025;

SELECT
    COUNT(*) AS total_livros,
    SUM(quantidade_disponivel) AS soma_estoque,
    AVG(quantidade_disponivel) AS media_estoque,
    MIN(quantidade_disponivel) AS menor_estoque,
    MAX(quantidade_disponivel) AS maior_estoque
FROM LIVRO;

SELECT
    E.id_emprestimo,
    U.nome AS usuario,
    L.titulo AS livro,
    E.data_emprestimo,
    E.status_emprestimo
FROM EMPRESTIMO E
INNER JOIN USUARIO U ON E.id_usuario = U.id_usuario
INNER JOIN LIVRO L ON E.id_livro = L.id_livro;

SELECT
    U.nome AS usuario,
    L.titulo AS livro,
    E.status_emprestimo
FROM EMPRESTIMO E
INNER JOIN USUARIO U ON E.id_usuario = U.id_usuario
INNER JOIN LIVRO L ON E.id_livro = L.id_livro
WHERE E.status_emprestimo = 'ABERTO';

SELECT
    U.nome AS usuario,
    COUNT(E.id_emprestimo) AS quantidade_emprestimos
FROM USUARIO U
INNER JOIN EMPRESTIMO E ON U.id_usuario = E.id_usuario
GROUP BY U.id_usuario, U.nome
ORDER BY quantidade_emprestimos DESC;

SELECT
    U.nome AS usuario,
    COUNT(E.id_emprestimo) AS quantidade_emprestimos
FROM USUARIO U
LEFT JOIN EMPRESTIMO E ON U.id_usuario = E.id_usuario
GROUP BY U.id_usuario, U.nome
ORDER BY quantidade_emprestimos DESC;


START TRANSACTION;

INSERT INTO EMPRESTIMO
(data_prevista, status_emprestimo, id_usuario, id_livro)
VALUES
('2026-11-20', 'ABERTO', 4, 1);

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel - 1 
WHERE id_livro = 1
AND quantidade_disponivel > 0; 

SELECT * FROM EMPRESTIMO ORDER BY id_emprestimo DESC LIMIT 1;
SELECT * FROM LIVRO WHERE id_livro = 1;

COMMIT;

SELECT * FROM LIVRO WHERE id_livro = 2;

START TRANSACTION;

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 10
WHERE id_livro = 2;

SELECT * FROM LIVRO WHERE id_livro = 2;

ROLLBACK;

SELECT * FROM LIVRO WHERE id_livro = 2;

START TRANSACTION;

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 1
WHERE id_livro = 3;

SAVEPOINT primeira_alteracao;

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 1
WHERE id_livro = 4;

ROLLBACK TO SAVEPOINT primeira_alteracao;

SELECT * FROM LIVRO WHERE id_livro IN (3, 4);

COMMIT;

SELECT *
FROM EMPRESTIMO
WHERE status_emprestimo = 'ABERTO'
AND id_emprestimo = 1;

START TRANSACTION;

UPDATE EMPRESTIMO
SET
    status_emprestimo = 'DEVOLVIDO', 
    data_devolucao = CURRENT_DATE()
WHERE id_emprestimo = 1
AND status_emprestimo = 'ABERTO';

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 1 
WHERE id_livro = 1;

SELECT * FROM EMPRESTIMO WHERE id_emprestimo = 1;
SELECT * FROM LIVRO WHERE id_livro = 1;

COMMIT;
