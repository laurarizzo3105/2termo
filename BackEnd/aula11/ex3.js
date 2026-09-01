const entrada = require('readline-sync')

function verificarStatus(nota) {
    return nota >= 7 ? "APROVADO" : "REPROVADO"
}

const turma =[];

for (let i = 0; i < 3; i++) {
    console.log(`\n --- cadastro do aluno ${i+1} ---`)
    let nomeAluno = entrada.question("Nome: ");
    let notaAluno = entrada.questionFloat("Nota: ");

    const novoAluno = {
        nome: nomeAluno,
        nota: notaAluno,
        status: verificarStatus(notaAluno)
    };

    turma.push(novoAluno);
}

console.log("\n====== RELATORIO FINAL ======")
for (let i = 0; i < turma.length; i++) {
    console.log(`${turma[i].nome} - Nota: ${turma[i].nota} | status: ${turma[i].status}`);
}