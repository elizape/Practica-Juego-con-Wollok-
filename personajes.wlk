import armas.*
import nivel0.nivel0

class Jugador {
  var vida
  var arma
  var idBala = 0
  var puedeDisparar =  true
  var property position = game.at(2,2)
  method esBala() = false
  
  method puedeDisparar() = puedeDisparar

  method posicionActual() = position

  method mostrarArma() = arma
  
  method cambiarArma(nuevaArma) {
    arma = nuevaArma
  }
  method dañoArma() = arma.mostrarDaño()

  method disparar() {
    if (self.puedeDisparar()) {
        const posX = self.posicionActual().x() + 1
        const posY = self.posicionActual().y() + 0
        const bala = new BalaRifle(position = game.at(posX, posY), id = idBala)
        game.addVisual(bala)
        game.sound(self.mostrarArma().sonidoAleatorioArma()).play()
        bala.desplazamientoBalaX(self.mostrarArma())
        idBala += 1

        // Activar cooldown
        puedeDisparar = false
        game.onTick(self.mostrarArma().cadenciaDisparo()*1000, 'cooldownDisparo', {
          puedeDisparar = true
          game.removeTickEvent('cooldownDisparo')
        })}
  }
  
  method recibirDaño(dañoRecibido) {
    vida = vida - dañoRecibido
    if (vida <= 0){
      puedeDisparar = false
      game.removeVisual(self)
      position = game.at(0,30)
    }
  } 
  method mostrarVida() = vida

  method image() = "jugador.png"

  // Metodos para controlar el jugador

  method subir() {
    if (self.posicionActual().y() < 3) {position = position.up(1)}
  }

  method atras() {
    if (self.posicionActual().x() > 0)position = position.left(1)
  }

  method abajo() {
    if (self.posicionActual().y() > 0)position = position.down(1)
  }

  method adelante() {
    if (self.posicionActual().x() < 30)position = position.right(1)
  }
}

object controles {
  method teclas(jugador) {
    keyboard.w().onPressDo {jugador.subir()}
    keyboard.a().onPressDo {jugador.atras()}
    keyboard.s().onPressDo {jugador.abajo()}
    keyboard.d().onPressDo {jugador.adelante()}
    keyboard.p().onPressDo {jugador.disparar()}
    keyboard.enter().onPressDo {nivel0.cambiarImagen()}
  }
}

const jugador = new Jugador(vida = 100, arma = rifle)