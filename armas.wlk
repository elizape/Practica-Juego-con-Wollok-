import personajes.*
import nivel0.*
import nivel1.*
// Para mi la clase de Arma y Bala deben ir en la misma clase pero eso lo vemos despues

class Arma {
    var daño
    var cadencia
    const listaSonidos

    method dañoArma() = daño
    method cadenciaDisparo() = cadencia
    method sonidoAleatorioArma() {
        return listaSonidos.anyOne().toString()
    }

    method aplicarPowerUpDaño(nuevoDaño) {
        daño = nuevoDaño
    }

    method aplicarPowerUpCadencia(nuevaCadencia) {
      cadencia = nuevaCadencia
    }
}

class Bala{
    var property position
    const id
    const arma

    method esBala() = true
    method esEnemigo() = false

    method tipoArma() = arma

    const listaSonidoBala = ['sonidoBala(1).mp3','sonidoBala(2).mp3','sonidoBala(3).mp3']

    override method toString() = id
    method balaID() = 'movimientoBala_' + id

    method sonidoBala() = listaSonidoBala.anyOne().toString()

    method movimientoEnX(posicion) 

    method eliminarBala() {
        game.removeTickEvent(self.balaID().toString())
        game.removeVisual(self)
        listaBalas.removerBala(self)
    }

    method pausar() {
      game.removeTickEvent(self.balaID().toString())
    }

    method despausar() {
      self.desplazamientoBalaX()
    }

    method desplazamientoBalaX() {
        game.onTick(2, self.balaID().toString(), {self.movimientoEnX(self.posicionActual())})
    }

    method colision() {
        return self.listaColisiones().isEmpty()
    }

    method listaColisiones() {

        return game.colliders(self)
    }

    method posicionActual() = position
}
class BalaRifle inherits Bala{
    method image() = 'bala(5).png'
    
    override method movimientoEnX(posicion) {
        // Habria que añadir la condicion de que se eliminen si impacta con un enemigo
        if (posicion.x()>32) {
            self.eliminarBala()
        } else if (!self.colision() && !self.listaColisiones().get(0).esBala()) {
            game.sound(self.sonidoBala()).play()
            self.listaColisiones().get(0).recibirDaño(self.tipoArma().dañoArma())
            self.eliminarBala()
        } else position = posicion.right(1)
    }
}

class BalaRifleAlien inherits Bala{
    
    method image() = "balaAlienRaptor(5).png"
    
    override method movimientoEnX(posicion) {
        if (posicion.x()<0) {
            self.eliminarBala()
        } else if (!self.colision() && !self.listaColisiones().get(0).esBala() && !self.listaColisiones().get(0).esEnemigo()) {
            game.sound(self.sonidoBala()).play()
            self.listaColisiones().get(0).recibirDaño(self.tipoArma().dañoArma())
            self.eliminarBala()
        } else position = posicion.left(1)
    }
}

class BalaCrawler inherits Bala{
    method image() = "balaCrawler(4).png"

    override method movimientoEnX(posicion) {
        if (posicion.x()<0) {
            self.eliminarBala()
        } else if (!self.colision() && !self.listaColisiones().get(0).esBala() && !self.listaColisiones().get(0).esEnemigo()) {
            game.sound(self.sonidoBala()).play()
            self.listaColisiones().get(0).recibirDaño(self.tipoArma().dañoArma())
            self.eliminarBala()
        } else position = posicion.left(1)
    }
}

const rifle = new Arma(daño=10,cadencia=0.8, listaSonidos=['sonidoRifle(1).mp3','sonidoRifle(4).mp3','sonidoRifle(5).mp3'])
const pistolaPlasma = new Arma(daño=7,cadencia=0.4, listaSonidos=['sonidoRifle(1).mp3','sonidoRifle(4).mp3','sonidoRifle(5).mp3'])
const bolaFuego = new Arma(daño=10,cadencia=1.2, listaSonidos=['sonidoBolaFuego(1).mp3','sonidoBolaFuego(2).mp3','sonidoBolaFuego(3).mp3'])
//const cañonSonico = new Arma(daño=20,cadencia=1)