const entrada = require("readline-sync");

console.log("-----------------------------------");
console.log(" SISTEMA DE CLASSIFICAÇÃO: NATAÇÃO ");
console.log("-----------------------------------");

const nome = entrada.question("Nome do atleta: ")
const nome = entrada.questionInt("Idade do atleta: ")

console.log(`\nAtleta: ${nome}`);

if (idade < 5) {
    console.log("SITUAÇÃO: Muito jovem para competição");
}
else if (idade >=5 && idade <=10) {
    console.log("CATEGORIA: INFANTIL");
}
else if (idade >= 11 && idade <=17) {
    console.log("CATEGORIA: JUVENIL");
}
else if (idade >=18 && idade <=60) {
    console.log("CATEGORIA: ADULTO");
}
else {
    console.log("CATEGORIA:SENIOR");
}
console.log("-----------------------------------");
