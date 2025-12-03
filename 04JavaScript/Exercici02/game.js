class Game {
    constructor() {
        this.score = 0
        this.cheat = false
        this.board = [
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0]
        ]
        this.treasures = 16
        this.attempts = 32
        this.remainingAttempts = this.attempts
        this.hideTreasures()
    }

    hideTreasures() {
        for (let i = 0; i < this.treasures; i++) {
            let x, y
            do {
                y = Math.floor(Math.random() * 6)
                x = Math.floor(Math.random() * 8)
            } while (this.board[y][x] === 1)
            this.board[y][x] = 1
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
                if (this.cheat && this.board[y][x] === 1) {
                    row += 'X'
                } else if (this.board[y][x] === 3) {
                    row += 'O'
                } else if (this.board[y][x] === 2) {
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
        if (this.board[y][x] === 1) {
            console.log("Has trobat un tresor!")
            this.score += 1
            this.board[y][x] = 3 // Marcar com a tresor trobat
        } else if (this.board[y][x] > 1) {
            console.log("Aquesta casella ja està destapada.")
        } else {
            console.log("No hi ha cap tresor aquí.")
            this.remainingAttempts -= 1
            this.board[y][x] = 2 // Marcar com a destapat
            const distance = this.distanceToNearestTreasure(x, y)
            console.log(`Distància al tresor més proper: ${distance}`)
        }
    }

    distanceToNearestTreasure(x, y) {
        let minDistance = Infinity
        for (let j = 0; j < this.board.length; j++) {
            for (let i = 0; i < this.board[j].length; i++) {
                if (this.board[j][i] === 1 || this.board[j][i] === 3) {
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
        return {
            score: this.score,
            cheat: this.cheat,
            board: this.board
        }
    }

    fromJSON(data) {
        this.score = data.score
        this.cheat = data.cheat
        this.board = data.board
    }
}
module.exports = Game