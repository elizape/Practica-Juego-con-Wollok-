import armas.*
import enemigos.*
import nivel0.nivel0
import nivel1.*
import imagenIndicaciones.*

class Jugador {
  var vida
  var arma
  var idBala = 0
  var puedeDisparar =  true
  var property position = game.at(2,2)
  var numeroNivel = null
  method esBala() = false
  method esEnemigo() = false
  
  method puedeDisparar() = puedeDisparar

  method posicionActual() = position

  method cambiarPosicion(posX,posY) {
    position =  game.at(posX,posY)
  }

  method mostrarArma() = arma
  
  method cambiarArma(nuevaArma) {
    arma = nuevaArma
  }
  method dañoArma() = arma.mostrarDaño()

  method disparar() {
    if (self.puedeDisparar() && nivel.estaPausado()) {
        const posX = self.posicionActual().x() + 1
        const posY = self.posicionActual().y() + 0
        const bala = new BalaRifle(position = game.at(posX, posY), id = idBala, arma=self.mostrarArma())
        listaBalas.añadirBala(bala)
        game.addVisual(bala)
        game.sound(self.mostrarArma().sonidoAleatorioArma()).play()
        bala.desplazamientoBalaX()
        idBala += 1

        // Activar cooldown
        puedeDisparar = false
        game.onTick(self.mostrarArma().cadenciaDisparo()*1000, 'cooldownDisparo', {
          puedeDisparar = true
          game.removeTickEvent('cooldownDisparo')
        })}
  }
  
  method recibirDaño(dañoRecibido) {
    vida -= dañoRecibido
    if (self.estaMuerto()){
      puedeDisparar = false
      if (barraVida.mostrarLista().size() > 0){
        game.removeVisual(self)
        barraVida.actualizarVida(self.mostrarVida())
        nivel.nivelPerdido()
      }
      position = game.at(0,30)
    } else barraVida.actualizarVida(vida)
  } 

  method estaMuerto() = self.mostrarVida() <= 0

  method mostrarVida() = vida

  method reiniciarVida() {
    puedeDisparar = true
    vida = 100
  }
  
  method obtenerNivel(nivel){
      numeroNivel = nivel
  }

  method numeroNivel() = numeroNivel

  method image() = "jugador.png"

  // Metodos para controlar el jugador

  method subir() {
    if (self.posicionActual().y() < 3 && nivel.estaPausado()) {position = position.up(1)}
  }

  method atras() {
    if (self.posicionActual().x() > 0 && nivel.estaPausado())position = position.left(1)
  }

  method abajo() {
    if (self.posicionActual().y() > 0 && nivel.estaPausado())position = position.down(1)
  }

  method adelante() {
    if (self.posicionActual().x() < 30 && nivel.estaPausado())position = position.right(1)
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
    // (r) reinicia el nivel
    keyboard.r().onPressDo ({
      if (jugador.estaMuerto() || !nivel.estaPausado()) {
        nivel.reiniciarNivel()
      }
    })
    // (m) accede al menu de pausa o reanuda el juego
    keyboard.m().onPressDo {
      if (nivel.estaPausado()) {
        game.addVisual(menuPausa)
        nivel.detenerJuego()
      } else if (!nivel.estaPausado() && !jugador.estaMuerto()) {
        nivel.reanudarJuego()
        game.removeVisual(menuPausa)
      }
    }
  }
}

object nivel {
  var cancion = null
  var pausado = true
  method estaPausado() = pausado

  method detenerJuego() {
    pausado = false
    creadorHordas.verListaEnemigos().forEach({p => p.pausar()})
    listaBalas.mostrarLista().forEach({b => b.pausar()})
  }
  method reanudarJuego() {
    pausado = true
    creadorHordas.verListaEnemigos().forEach({p => p.despausar()})
    listaBalas.mostrarLista().forEach({b => b.despausar()})
  }
  method nivelSuperado() {
    self.detenerJuego()
    imagen341.visualizar()
    game.schedule(2000, {
          imagen343.visualizar()
        })  //agregar siguiente nivel
  }

  method nivelPerdido () {
    game.onTick(1, 'espera1',{
      self.detenerJuego()
      imagen342.visualizar()
      game.sound('gameOver(3).mp3').play()
      game.onTick(2000, 'esperaSonido2', {
        game.schedule(2000, {
          imagen343.visualizar()
        })
        game.sound('gameOver(2).mp3').play()
        game.removeTickEvent('esperaSonido2')
      })
      game.removeTickEvent('espera1')
    })
    
  }

  method reiniciarNivel() {
    jugador.numeroNivel().nivelCancion().stop()
    game.schedule(40, {
      jugador.numeroNivel().reiniciarNivel()
      jugador.reiniciarVida()
      barraVida.reiniciarBarraVida()
      jugador.numeroNivel().iniciar()
      self.reanudarJuego()
    })
    
  }

  method cancionNivel(cancionNivel) {
    cancion = cancionNivel
  }
}

object menuPausa {
  var property position = game.at(3,2)

  method image() = 'Menu Definitivo.png'
}

const jugador = new Jugador(vida = 100, arma = rifle)

object listaBalas {
  const balas = []

  method mostrarLista() = balas

  method añadirBala(bala) {
    balas.add(bala)
  }

  method removerBala(bala) {
    balas.remove(bala)
  }

  method reiniciarLista() {
    balas.clear()
  }
}

object barraVida{
  var vida = null
  var id = 0
  const listaCorazones = []

  method actualizarVida(vidaActual) {
    vida = vidaActual.div(10) // Me devuelve la parte entera de la division
    game.onTick(1, 'actualizarVida', {
      if (id < vida) {
        self.crearCorazon(id)
        id += 1
      } else if (id == 10){
        game.removeTickEvent('actualizarVida')
        id -= 1
      } else {
        const ultimoLista = self.mostrarLista().last()
        self.quitarCorazon(ultimoLista)
        self.crearCorazonGris(id)
        id -= 1
        game.removeTickEvent('actualizarVida')
      }
    })
  }

  method comparacionLista() = self.mostrarLista().size() <= vida

  method crearCorazon(posicion) {
    const corazon = new Corazon(id = 'Corazon'+posicion.toString(), position = game.at(posicion, 17))
    game.addVisual(corazon)
    self.mostrarLista().add(corazon)
  }

  method quitarCorazon(corazon) {
    game.removeVisual(corazon)
    self.mostrarLista().remove(corazon)
  }

  method crearCorazonGris(posicion) {
    const corazon = new CorazonGris(id = 'CorazonGris'+posicion.toString(), position = game.at(posicion, 17))
    game.addVisual(corazon)
  }

  method mostrarLista() = listaCorazones

  method reiniciarBarraVida() {
    id = 0
    listaCorazones.clear()
  }
}

class Corazon{
  var property position
  const id

  override method toString() = id
  method image() = 'vidaCorazon(1).png'
}

class CorazonGris{
  var property position
  const id

  override method toString() = id
  method image() = 'vidaCorazonGris(6).png'
}