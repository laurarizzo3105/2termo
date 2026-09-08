create table clientes (
    id_clientes int auto_increment primary key,
    nome_cliente varchar(60) not null
);

create table pedidos (
    id_pedidos int AUTO_INCREMENT Primary KEY,
    data_pedido datetime not null,
    id_clientes int not null,
    id_cliente int not null,
    FOREIGN key (id_cliente) references clientes (id_clientes)
);

create table fornecedor_produto (
    id_fornecedor int not NULL,
    id_produto int not NULL,
    primary key (id_fornecedor, id_produto),
    FOREIGN key (id_fornecedor) references fornecedores (id_fornecedores),
    FOREIGN key (id_produtos) references produtos(id_produto)
);

select * from produtos;

insert into produtos (nome_produto) values ('camiseta');

-- desafio de cardinalidades

-- CATEGORIA ---- PERTENCE ---- PRODUTO
-- 1,N                              1,1

-- FUNCIONARIO ---- REGISTRA ---- PRODUTOS
-- 1,N                                 1,N

-- FORNECEDOR ---- COMERCIALIZA ---- PRODUTOS
-- 1,N                                    1,N

-- PEDIDO ---- POSSUI ---- ITENS
-- 1,N                       1,1

-- MESA ---- VINCULADA ---- RESERVA
-- 0,N                          1,1
