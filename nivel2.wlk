// nivel2.wlk
// nivel2.wlk
// nivel2.wlk
import personajes.*
import enemigos.*
import armas.*
import imagenIndicaciones.*
import nivel3.*
object nivel2 {

  method nivelSiguiente() = nivel3

  method reiniciarNivel() {
    game.removeTickEvent('Segunda Generacion')
    game.removeTickEvent('VerificoSiHayEnemigo')
    game.clear()
    jugador.reiniciarVida()
    jugador.obtenerNivel(self)
    creadorHordas.reiniciarLista()
    listaBalas.reiniciarLista()
    cancionNivel2.play()
  }

  method iniciar() {
    self.reiniciarNivel()
    cancionNivel2.volume(1)
    nivel.cancionNivel(cancionNivel2)
    game.addVisual(fondo2)
    jugador.cambiarPosicion(2,2)
    barraVida.actualizarVida(jugador.mostrarVida())
    game.addVisual(jugador)
    controles.teclas(jugador)

    game.schedule(500, {
      game.addVisual(imagenNivel2)
      game.schedule(4000, {
        game.removeVisual(imagenNivel2)
        creadorHordas.generarHordaCrawler(7, 4, 5)
        game.onTick(3000, 'Segunda Generacion', {
            if (creadorHordas.obtenerPuedeGenerar()) {
              game.addVisual(imagenMasEnemigos)
              game.schedule(4000, {
                game.removeVisual(imagenMasEnemigos)
              })
              creadorHordas.generarHordaCrawler(7, 3, 3)
              game.onTick(3000, 'VerificoSiHayEnemigo', {
                  if (creadorHordas.verificarSiHayEnemigo()){
                      game.removeTickEvent('VerificoSiHayEnemigo')
                      nivel.nivelSuperado()
                  }
                })
                game.removeTickEvent('Segunda Generacion')
            }
        })
      })
    })
  }
  
  method nivelCancion() = cancionNivel2
}

const cancionNivel2 = game.sound('nivelTresSong(1).mp3')