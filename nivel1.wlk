import personajes.*
import enemigos.*
import armas.*
import imagenIndicaciones.*
object nivel1 {
    method iniciar() {
      
      game.boardGround("FondoJuego(2).png")
      game.addVisual(jugador)
      game.sound("Mick Gordon - 11. BFG Division [QHRuTYtSbJQ].mp3").play()
      controles.teclas(jugador)

      const tuto0 = new Indicaciones(nombre='tuto0', imagen='Nivel-1-ten-cuidado-con.png', duracion=7, position=game.at(8,14))
      const tutos = [tuto0]
      var id = 0
      var puedeMostrar = true

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
        creadorHordas.generarHordaAlien(2, 1)
      } 
      })
      
/*
      game.onTick(1000, 'horda_1', {
        creadorHordas.generarHordaAleatoria(15, 3)
        game.removeTickEvent('horda_1')
      }) */
  }
}