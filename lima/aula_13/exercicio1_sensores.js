const fs = require('fs');

console.log("=== SISTEMA DE MONITORAMENTO INDUSTRIAL ===");

const sensores = [
    {codigo: 1001, tipo: "Temperatura", leituraAtual: 45.5, statuss: "Operando"},
    {codigo: 1002, tipo: "Pressão", leituraAtual: 4, statuss: "Operando"},
    {codigo: 1003, tipo: "Temperatura", leituraAtual: 145.5, statuss: "Alerta!"}
];

const valoresGravados = JSON.stringify(sensores, null, 2);

fs.writeFileSync('sensores.json', valoresGravados);
 
console.log(`\n valores gravados com sucesso.`);