class Cell {
    constructor() {
        this.hasTreasure = false
        this.isUncovered = false
    }
}

class Game {
    constructor() {
        this.score = 0
        this.cheat = false
        this.attempts = 32
        this.remainingAttempts = this.attempts
        this.board = []
        this.treasures = 16
        this.generateBoard()
    }

    generateBoard() {
        // Tauler amb cel·les buides
        for (let y = 0; y < 6; y++) {
            this.board[y] = []
            for (let x = 0; x < 8; x++) {
                this.board[y][x] = new Cell()
            }
        }

        // Col·locar tresors aleatòriament
        for (let i = 0; i < this.treasures; i++) {
            let x, y
            do {
                y = Math.floor(Math.random() * 6)
                x = Math.floor(Math.random() * 8)
            } while (this.board[y][x].hasTreasure)
            this.board[y][x].hasTreasure = true
        }
    }

    showBoard() {
        //  01234567
        // A········
        // B········
        // C········
        // D········
        // E········
        // F········
        let header = ' '
        for (let i = 0; i < this.board[0].length; i++) {
            header += i
        }
        console.log(header)
        for (let y = 0; y < this.board.length; y++) {
            let row = String.fromCharCode('A'.charCodeAt(0) + y)
            for (let x = 0; x < this.board[y].length; x++) {
                const cell = this.board[y][x]
                if (this.cheat && !cell.isUncovered && cell.hasTreasure) {
                    row += 'X'
                } else if (cell.isUncovered && cell.hasTreasure) {
                    row += 'O'
                } else if (cell.isUncovered) {
                    row += this.distanceToNearestTreasure(x, y)
                } else {
                    row += '·'
                }
            }
            console.log(row)
        }
        console.log("")
    }

    activateCheat() {
        this.cheat = true
        console.log("Trampa activada.")
    }
    deactivateCheat() {
        this.cheat = false
        console.log("Trampa desactivada.")
    }
    
    uncover(x, y) {
        if (y < 0 || y >= this.board.length || x < 0 || x >= this.board[0].length) {
            console.log("Posició invàlida.")
            return
        }
        const cell = this.board[y][x]
        if (cell.isUncovered) {
            console.log("Aquesta casella ja està destapada.")
        } else {
            if (cell.hasTreasure) {
                console.log("Has trobat un tresor!")
                this.score += 1
            } else {
                console.log("No hi ha cap tresor aquí.")
                this.remainingAttempts -= 1
                const distance = this.distanceToNearestTreasure(x, y)
                console.log(`Distància al tresor més proper: ${distance}`)
            }
            cell.isUncovered = true
        }
    }

    distanceToNearestTreasure(x, y) {
        let minDistance = Infinity
        for (let j = 0; j < this.board.length; j++) {
            for (let i = 0; i < this.board[j].length; i++) {
                if (this.board[j][i].hasTreasure) {
                    const distance = Math.abs(x - i) + Math.abs(y - j)
                    if (distance < minDistance) {
                        minDistance = distance
                    }
                }
            }
        }
        return minDistance
    }

    showScore() {
        console.log(`Puntuació actual: ${this.score}/${this.treasures}. Tirades restants: ${this.remainingAttempts}`)
    }

    toJSON() {
        var boardJSON = [];
        for (let y = 0; y < this.board.length; y++) {
            boardJSON[y] = [];
            for (let x = 0; x < this.board[y].length; x++) {
                boardJSON[y][x] = {
                    hasTreasure: this.board[y][x].hasTreasure,
                    isUncovered: this.board[y][x].isUncovered
                };
            }
        }
        return {
            score: this.score,
            cheat: this.cheat,
            remainingAttempts: this.remainingAttempts,
            board: boardJSON
        }
    }

    fromJSON(data) {
        this.score = data.score
        this.cheat = data.cheat
        this.remainingAttempts = data.remainingAttempts
        for (let y = 0; y < data.board.length; y++) {
            for (let x = 0; x < data.board[y].length; x++) {
                this.board[y][x].hasTreasure = data.board[y][x].hasTreasure
                this.board[y][x].isUncovered = data.board[y][x].isUncovered
            }
        }
    }
}
module.exports = Game