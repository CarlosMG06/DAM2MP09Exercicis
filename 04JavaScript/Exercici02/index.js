const readline = require('readline').promises
const fs = require('fs').promises
const Game = require('./game')


async function main() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    })

    console.log("--- Joc Busca-tresors ---")
    console.log("") 
    var gameInstance = new Game()
    while (true) {
        gameInstance.showBoard()
        const command = await rl.question("Escriu una comanda (escriu 'help' per ajuda): \n> ")
        if (command.toLowerCase() === 'exit' || command.toLowerCase() === 'sortir') {
            console.log("Sortint del joc. Fins aviat!")
            break
        }
        await parseCommand(command, gameInstance)
        console.log("")
        if (gameInstance.score >= gameInstance.treasures) {
            console.log(`Has guanyat amb només ${gameInstance.attempts - gameInstance.remainingAttempts} tirades!`)
            break
        } else if (gameInstance.attempts <= 0) {
            console.log(`Has perdut! Encara quedaven ${gameInstance.treasures - gameInstance.score} tresors per trobar.`)
            break
        }
    }    
    rl.close() // Tancar la lectura 'readline'
}

async function parseCommand(command, gameInstance) {
    const parts = command.trim().split(' ')
    const mainCommand = parts[0].toLowerCase()
    const args = parts.slice(1)
    if (mainCommand === 'help' || mainCommand === 'ajuda') {
        await help()
    } else if (mainCommand === 'carregar' && args[0] === 'partida' && args.length > 1) {
        const fileName = args[1]
        await loadGame(fileName, gameInstance)
    } else if (mainCommand === 'guardar' && args[0] === 'partida' && args.length > 1) {
        const fileName = args[1]
        await saveGame(fileName, gameInstance)
    } else if (mainCommand === 'activar' && args[0] === 'trampa') {
        gameInstance.activateCheat()
    } else if (mainCommand === 'desactivar' && args[0] === 'trampa') {
        gameInstance.deactivateCheat()
    } else if (mainCommand === 'destapar' && RegExp('^[A-F][0-7]$').test(args[0])) {
        const position = args[0]
        let y = position.charCodeAt(0) - 'A'.charCodeAt(0)
        let x = parseInt(position.slice(1))
        gameInstance.uncover(x, y)
    } else if (mainCommand === 'puntuacio') {
        gameInstance.showScore()
    } else {
        console.log("Comanda no reconeguda. Escriu 'help' o 'ajuda' per veure les comandes disponibles.")
    }
}

async function help() {
    console.log("Comandes disponibles:")
    console.log("help / ajuda - Mostra aquesta ajuda")
    console.log("carregar partida <nom_arxiu.json> - Carrega una partida des d'un arxiu JSON")
    console.log("guardar partida <nom_guardar.json> - Guarda la partida actual en un arxiu JSON")
    console.log("activar trampa - Activa la trampa per veure totes les posicions dels tresors")
    console.log("desactivar trampa - Desactiva la trampa")
    console.log("destapar xy - Destapa la casella especificada (Ex: destapar B3)")
    console.log("puntuacio - Mostra la puntuació actual")
    console.log("exit / sortir - Surt del joc")
}

async function loadGame(fileName, gameInstance) {
    if (!fileName.endsWith('.json')) {
            console.log("El nom de l'arxiu ha de tenir l'extensió .json")
            return
    }
    try {
        await fs.access(`./partides/${fileName}`)
    } catch (error) {
        console.log(`L'arxiu ${fileName} no existeix.`)
        return
    }
    try {
        const txtData = await fs.readFile(`./partides/${fileName}`, 'utf-8')
        const data = JSON.parse(txtData)
        gameInstance.fromJSON(data)
        console.log(`Dades carregades des de /partides/${fileName}`)
    } catch (error) {
        console.error("\n Error en llegir les dades:", error)
    }
}
async function saveGame(fileName, gameInstance) {
    if (!fileName.endsWith('.json')) {
        console.log("El nom de l'arxiu ha de tenir l'extensió .json")
        return
    }
    try {
        await fs.access('./partides')
    } catch (error) {
        await fs.mkdir('./partides')
    }

    try {
        const txtData = JSON.stringify(gameInstance.toJSON(), null, 2)
        await fs.writeFile(`./partides/${fileName}`, txtData, 'utf-8')
        console.log(`Dades escrites a /partides/${fileName}`)
    } catch (error) {
        console.error("Error en escriure les dades:", error)
    }
}

main()