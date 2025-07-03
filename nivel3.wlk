// nivel3.wlk
// nivel3.wlk
// nivel3.wlk
import personajes.*
import enemigos.*
import armas.*
import imagenIndicaciones.*
import nivel1.*
import nivel2.*
object nivel3 {

  method nivelSiguiente() = nivel1

  method reiniciarNivel() {
    game.removeTickEvent('Segunda Generacion')
    game.removeTickEvent('VerificoSiHayEnemigo')
    game.clear()
    jugador.reiniciarVida()
    jugador.obtenerNivel(self)
    creadorHordas.reiniciarLista()
    listaBalas.reiniciarLista()
  }

  method iniciar() {
    self.reiniciarNivel()
    cancionNivel3.play()
    cancionNivel3.volume(0.45)
    nivel.cancionNivel(cancionNivel3)
    game.addVisual(fondo3)
    jugador.cambiarPosicion(2,2)
    barraVida.actualizarVida(jugador.mostrarVida())
    game.addVisual(jugador)
    controles.teclas(jugador)

    game.schedule(500, {
      game.addVisual(imagenNivel3)
      game.schedule(4000, {
        game.removeVisual(imagenNivel3)
        creadorHordas.generarHordaAleatoria(1, 2, 2) //Genera las hordas
        game.onTick(3000, 'VerificoSiHayEnemigo', {
          if(creadorHordas.verificarSiHayEnemigo()) {
            game.removeTickEvent('VerificoSiHayEnemigo')
            nivel.nivelSuperado()
          }
        })
      })
    })
  }

  method nivelCancion() = cancionNivel3
}

const cancionNivel3 = game.sound('nivelTresSong(1).mp3')