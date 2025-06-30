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
    game.addVisual(fondo2)
    jugador.cambiarPosicion(2,2)
    barraVida.actualizarVida(jugador.mostrarVida())
    game.addVisual(jugador)
    controles.teclas(jugador)

    const tuto0 = new Indicaciones(nombre='tuto0', imagen='Nivel-1-ten-cuidado-con.png', duracion=7, position=game.at(8,14))
    const tutos = [tuto0]

    game.onTick(500, 'espera',{
    if (puedeMostrar && id < tutos.size()) {
      puedeMostrar = false
      game.sound("level-up-enhancement-8-bit-retro-sound-effect-153002.mp3").play()
      tutos.get(id).visualizar()
      game.onTick(tutos.get(id).duracionImagen()*1000, 'duracionImagen',{
        tutos.get(id).remover()    
        puedeMostrar = true
        game.removeTickEvent('duracionImagen')
        id += 1    
      })
      
    } else if (puedeMostrar && id == tutos.size()) {
      game.removeTickEvent('espera')
      creadorHordas.generarHordaAleatoria(15, 2, 2)
    } 
    })
  }
}

const cancionNivel1 = game.sound('nivelUnoSong(1).mp3')