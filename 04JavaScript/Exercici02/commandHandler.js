class CommandHandler {

    parse(command, gameInstance) {
        const parts = command.trim().split(' ')
        // Command list:
        // help / ajuda
        // carregar partida <nom_arxiu>
        // guardar partida <nom_arxiu>
        // activar/desactivar trampa
        // destapar xy (Ex: destapar B3)
        // puntuacio
        const mainCommand = parts[0].toLowerCase()
        const args = parts.slice(1)
        if (mainCommand === 'help' || mainCommand === 'ajuda') {
            help()
        } else if (mainCommand === 'carregar' && args[0] === 'partida') {
            const fileName = args[1]
            loadGame(fileName, gameInstance)
        } else if (mainCommand === 'guardar' && args[0] === 'partida') {
            const fileName = args[1]
            saveGame(fileName, gameInstance)
        } else if (mainCommand === 'activar' && args[0] === 'trampa') {
            gameInstance.activateCheat()
        } else if (mainCommand === 'desactivar' && args[0] === 'trampa') {
            gameInstance.deactivateCheat()
        } else if (mainCommand === 'destapar') {
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

    help() {
        console.log("Comandes disponibles:")
        console.log("help / ajuda - Mostra aquesta ajuda")
        console.log("carregar partida <nom_arxiu.json> - Carrega una partida des d'un arxiu JSON")
        console.log("guardar partida <nom_guardar.json> - Guarda la partida actual en un arxiu JSON")
        console.log("activar trampa - Activa la trampa per veure totes les posicions dels tresors")
        console.log("desactivar trampa - Desactiva la trampa")
        console.log("destapar xy - Destapa la casella especificada (Ex: destapar B3)")
        console.log("puntuacio - Mostra la puntuació actual")
    }

    loadGame(fileName, gameInstance) {
        console.log(`Carregant partida des de ${fileName}...`)
        // TODO: Implementar la càrrega de la partida
    }
    saveGame(fileName, gameInstance) {
        console.log(`Guardant partida a ${fileName}...`)
        // TODO: Implementar la guarda de la partida
    }

    showScore(gameInstance) {
        gameInstance.showScore()
    }
}
module.exports = CommandHandler