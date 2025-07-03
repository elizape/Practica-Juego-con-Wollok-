import personajes.*
import enemigos.*
import armas.*
import imagenIndicaciones.*
import nivel0.*
import nivel2.*
object nivel1 {

  var id = 0
  var puedeMostrar = true

  method nivelSiguiente() = nivel2

  method reiniciarNivel() {
    id = 0
    puedeMostrar = true
    game.clear()
    creadorHordas.reiniciarLista()
    listaBalas.reiniciarLista()
    jugador.reiniciarVida()
    jugador.obtenerNivel(self)
    cancionNivel1.play()
  }

  method iniciar() {
    self.reiniciarNivel()
    cancionNivel1.volume(0.45)
    nivel.cancionNivel(cancionNivel1)
    game.addVisual(fondo1)
    jugador.cambiarPosicion(2,2)
    barraVida.actualizarVida(jugador.mostrarVida())
    game.addVisual(jugador)
    controles.teclas(jugador)

    game.schedule(500, {
      game.addVisual(imagenNivel1)
      game.schedule(3000, {
        game.removeVisual(imagenNivel1)
        creadorHordas.generarHordaAlien(3, 4, 4) 
        game.onTick(3000, 'Segunda Generacion', {
          if (creadorHordas.obtenerPuedeGenerar()){
            creadorHordas.generarHordaAlien(7, 4, 4)
            game.onTick(3000, 'VerificoSiHayEnemigo', {
              if(creadorHordas.verificarSiHayEnemigo()) {
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

  method nivelCancion() = cancionNivel1
}

const cancionNivel1 = game.sound('nivelUnoSong(1).mp3')