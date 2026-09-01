const produto ={
    nome: "Teclado mecanico",
    preço: 150.00,
    estoque: 25,
    EmOferta: true
};

console.log('Produto: ${produto.nome}');
console.log('Preço: R$ ${produto.preco.toFixed(2)}');
console.log('Produto: ${produto.nome} | ${produto.preco} | ${produto.estoque} | ${produto.EmOferta}');