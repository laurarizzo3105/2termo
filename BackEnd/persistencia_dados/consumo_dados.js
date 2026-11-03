const fs = require('fs');

console.log("=== SISTEMA DE PERSISTENCIA: LEITURA DE MAQUINAS === ");

const nomeDoArquivo = "maquinas.json";

if (!fs.existsSync(nomeDoArquivo))  {
  console.error(`Erro: o arquivo '${nomeDoArquivo} nao foi encontrado`);};

const conteudoTexto = fs.readFileSync(nomeDoArquivo, 'utf-8');
const maquinasRecuperadas = JSON.parse(conteudoTexto);


console.log("Dados carregados com sucesso:\n");
console.table(maquinasRecuperadas);
console.log(`\nTotal de maquinas cadastradas: ${maquinasRecuperadas.length}`);
console.log(`Primeira maquina da lista: ${maquinasRecuperadas[0].nome}`);