import armas.*
class Jugador {
  var vida
  var arma
  var property position = game.origin()

  method cambiarArma(nuevaArma) {
    arma = nuevaArma
  }
  method dañoArma() = arma.mostrarDaño()

  method atacar(enemigo) {
    enemigo.recibirDaño(self.dañoArma())
  }
  method recibirDaño(dañoRecibido) {
    vida = vida - dañoRecibido
  } 
  method mostrarVida() = vida

  method image() = "ChatGPT Image Jun 10, 2025, 11_13_32 PM(1).png"

  method subir() {
    position = position.up(1)
  }
  // se mueve una determinada cantidad de posiciones en diagonal principal
  method enDiagonal(cantidadPosiciones) {
    position = position.up(cantidadPosiciones).left(cantidadPosiciones)
  }
}

class Enemigos {
  const nombre
  override method toString() = nombre
  var vida
  const daño
  method atacar(objetivo) {
    objetivo.recibirDaño(daño)
  }
  method recibirDaño(dañoRecibido) {
    vida = vida - dañoRecibido
  }
  method mostrarVida() = vida
}

class AlienRaptor inherits Enemigos{
  method image() = 'ChatGPT Image Jun 11, 2025, 12_26_02 AM.png'
}

class Crawler inherits Enemigos {
  method image() = ''
}

class FinalBoss inherits Enemigos{
  method image() = ''
}

var lista = []

var horda = (1..20).map[i => new Enemigos(nombre = "Minion " + i.toString(), vida = 30, daño = 5)
]