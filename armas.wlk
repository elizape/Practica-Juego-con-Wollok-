// Para mi la clase de Arma y Bala deben ir en la misma clase pero eso lo vemos despues

class Arma {
    var daño
    var cadencia
    const listaSonidos

    method dañoArma() = daño
    method cadenciaDisparo() = cadencia
    method disparar(objetivo) {}
    method sonidoAleatorioArma() {
        return listaSonidos.anyOne().toString()
    }
}

class Rifle inherits Arma {
    
}

class Bala{
    var property position
    var id

    const listaSonidoBala = ['sonidoBala(1).mp3','sonidoBala(2).mp3','sonidoBala(3).mp3']

    override method toString() = id
    method balaID() = 'movimientoBala_' + id

    method sonidoBala() = listaSonidoBala.anyOne().toString()

    method eliminarBala() {
        game.removeTickEvent(self.balaID())
        game.removeVisual(self)
    }

    method desplazamientoBala() {
        game.onTick(2, self.balaID(), {self.movimientoEnX(self.posicionActual())})
    }
    method movimientoEnX(posicion) {
        // Habria que añadir la condicion de que se eliminen si impacta con un enemigo
        if (posicion.x()>32) {
            self.eliminarBala()
        } else if (!self.colision()) {
            game.sound(self.sonidoBala()).play()
            self.listaColisiones().get(0).recibirDaño(rifle.dañoArma())
            self.eliminarBala()
        } else position = posicion.right(1)
      
    }

    method colision() {
        return self.listaColisiones().isEmpty()
    }

    method listaColisiones() {
        return game.colliders(self)
    }

    method posicionActual() = position

    method image() = 'bala(5).png'
}
class BalaRifle {
    
}

const rifle = new Arma(daño=10,cadencia=0.8, listaSonidos=['sonidoRifle(1).mp3','sonidoRifle(4).mp3','sonidoRifle(5).mp3'])
//const pistolaPlasma = new Arma(daño=7,cadencia=0.4)
//const cañonSonico = new Arma(daño=20,cadencia=1)