import personajes.*
import enemigos.*
import armas.*
import imagenIndicaciones.*
import nivel0.*
object nivel1 {

  var id = 0
  var puedeMostrar = true

  method reiniciarNivel() {
    id = 0
    puedeMostrar = true
  }

  method iniciar() {
    game.clear()
    jugador.reiniciarVida()
    jugador.obtenerNivel(self)
    creadorHordas.reiniciarLista()
    listaBalas.reiniciarLista()
    cancionNivel1.play()
    cancionNivel1.volume(0.45)
    nivel.cancionNivel(cancionNivel1)
    game.addVisual(fondo3)
    jugador.cambiarPosicion(2,2)
    barraVida.actualizarVida(jugador.mostrarVida())
    game.addVisual(jugador)
    controles.teclas(jugador)

    game.schedule(500, {
      game.addVisual(imagenNivel1)
      game.schedule(4000, {
        game.removeVisual(imagenNivel1)
        creadorHordas.generarHordaAleatoria(10, 3, 3) //Genera las hordas
        game.schedule(10000, {creadorHordas.verificarSiHayEnemigo()}) // Verifica que no 
      })
    })
  }

  method nivelCancion() = cancionNivel1
}

const cancionNivel1 = game.sound('nivelUnoSong(1).mp3')