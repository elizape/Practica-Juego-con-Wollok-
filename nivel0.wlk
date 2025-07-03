import personajes.*
import enemigos.*
import armas.*
import imagenIndicaciones.*
import nivel1.*

object nivel0 {

  method reiniciarNivel() {
    id = 0
    game.clear()
    cancionNivel0.play()
  }

  method iniciar() {
    self.reiniciarNivel()
    cancionNivel0.volume(0.3)
    jugador.obtenerNivel(self)
    jugador.reiniciarVida()
    game.addVisual(fondo1)
    game.addVisual(jugador)
    controles.teclas(jugador)
    self.primeraImagen()
  }

  const tuto0 = new Indicaciones(nombre='tuto0', imagen='Presione-enter-para-cont(1).png', duracion=10, position=game.at(0,17))

  const tuto1 = new Indicaciones(nombre='tuto1', imagen='Muevete-con-WASD.png', duracion=10, position=game.at(12,14))
  const tuto2 = new Indicaciones(nombre='tuto2',imagen='disparecon.png',duracion=10,position=game.at(12,14))
  const tuto3 = new Indicaciones(nombre='tuto3', imagen='instruccionPowerUp(3).png', duracion=10, position=game.at(3,11))
  const tuto4 = new Indicaciones(nombre='tuto4', imagen='tutorialInteractivo(1).png', duracion=10, position=game.at(4,14))
  const tuto5 = new Indicaciones(nombre='tuto5', imagen='tutorialInteractivo(2).png', duracion=10, position=game.at(4,14))
  const tuto6 = new Indicaciones(nombre='tuto6', imagen='Perfecto-pasemos-al-niv.png', duracion=10, position=game.at(10,14))
  
  const tutorialImagenes = [tuto1,tuto2,tuto3]
  const tutorialInteractivo = [tuto4,tuto5]

  var id = 0
  
  method primeraImagen() {
    tutorialImagenes.get(0).visualizar()
    tuto0.visualizar()
  }

  method cambiarImagen() {
    if (id < tutorialImagenes.size() - 1) {
      tutorialImagenes.get(id).remover()
      id += 1
      tutorialImagenes.get(id).visualizar()
    } else if (id == tutorialImagenes.size() - 1) {
      tutorialImagenes.get(id).remover()
      tuto0.remover()
      id += 1
      self.imagenTutorialInteractivo()  
      }
  }

  method imagenTutorialInteractivo() {
    var id_interactivo = 0
    tutorialInteractivo.get(id_interactivo).visualizar()
    creadorHordas.generarHordaAlien(1,2,2)
    game.onTick(3000, 'muerteEnemigo', {
      var vidaEnemigo = creadorHordas.verListaEnemigos().isEmpty()
      if (vidaEnemigo && id_interactivo == 0){
        game.sound("level-up-enhancement-8-bit-retro-sound-effect-153002.mp3").play()
        tutorialInteractivo.get(id_interactivo).remover()
        id_interactivo += 1
        tutorialInteractivo.get(id_interactivo).visualizar()
        creadorHordas.generarHordaCrawler(1,2,2)
        vidaEnemigo = creadorHordas.verListaEnemigos().isEmpty()
      } else if ((vidaEnemigo && id_interactivo == 1)) {
        game.sound("level-up-enhancement-8-bit-retro-sound-effect-153002.mp3").play()
        tutorialInteractivo.get(id_interactivo).remover()
        tuto6.visualizar()
        game.removeTickEvent('muerteEnemigo')
        game.onTick(5000, 'cargarNivelSiguiente', {
          game.removeTickEvent('cargarNivelSiguiente')
          cancionNivel0.stop()
          nivel1.iniciar()
        })
      }
    })
  }

  method nivelCancion() = cancionNivel0
}

const cancionNivel0 = game.sound('nivelCeroSong(1).mp3')