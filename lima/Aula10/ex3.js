const aluno = ["Ana", "Bruno", "Carlos", "Enzo", "Sophie", "Ruan"];

console.log("Lista de Alunos:  ")
console.log(aluno);


console.log(`terceiro aluno: ${aluno[2]}`);
console.log(`Ultimo aluno: ${aluno[5]}`);
console.log(`Quantidade de alunos: ${aluno.length}`);

aluno.push("Cecilia");
aluno.push("Leona");
aluno.splice(4, 1)

console.log(aluno);
console.log(`Segundo aluno: ${aluno[2]}`);
console.log(`Ultimo aluno: ${aluno[aluno.length - 1]}`);
console.log(`Quantidade de alunos: ${aluno.length}`);




//acrescentar mais dois nomes no array
//mostrar o terceiro aluno
//mostrar o ultimo aluno    