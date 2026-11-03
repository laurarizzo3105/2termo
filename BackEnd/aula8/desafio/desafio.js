const entrada = require("readline-sync");

console.log("-----------------------------------");
console.log(" CONTROLE DE ACESSO AO LABORATÓRIO ");
console.log("-----------------------------------");

const idade = entrada.questionint("Idade do aluno: ")
const professor = entrada.question("Está acompanhado de professor?: (S/N)").toUpperCase
const autorizacao = entrada.question("Possui autorização? (S/N)").toUpperCase

if (idade >=16 && autorizacao === "S") {
    console.log("Acesso liberado");}
    


