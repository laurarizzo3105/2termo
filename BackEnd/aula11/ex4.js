const entrada = require('readline-sync');

function converterParaFahrenheit(celsius) {
    let fahrenheit = (celsius * 9/5) + 32;
    return fahrenheit; 
}

const tempC = entrada.questionFloat("digite a temperatura em celsius: ");

const tempF = converterParaFahrenheit(tempC);

console.log(`A temperatura convertida é: ${tempF.toFixed(1)}°F`);