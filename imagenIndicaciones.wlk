class Indicaciones {
  const nombre
  const imagen
  const duracion
  var property position

  override method toString() = nombre

  method visualizar() {
    game.addVisual(self)
  }
  
  method remover() {
    game.removeVisual(self)
    game.removeTickEvent(self)
  }
  method nombreGetter() = nombre

  method image() = imagen

  method duracionImagen() = duracion
}

// Fondos de niveles

class FondosNivel {
  const imagen
  var property position = game.at(0,0)
  method image() = imagen
   method esBala() = true
   method esEnemigo() = true
}

const fondo1 = new FondosNivel(imagen="FondoJuego(3).png")
const fondo2 = new FondosNivel(imagen="FondoJuegoPrueba(2).png")
const fondo3 = new FondosNivel(imagen='FondoJuegoPrueba(4).png')

// Imagenes Utilizadas en el juego

const imagen341 = new Indicaciones(nombre='hasGanado', imagen='Has-Ganado(2).png', duracion=1, position=game.at(0,0))
const imagen342 = new Indicaciones(nombre='hasPerdido', imagen='Has-Muerto(1).png', duracion=1,position=game.at(0,0))
const imagen343 = new Indicaciones(nombre='reiniciar', imagen='reiniciar(3).png', duracion=1, position=game.at(11,5))
const imagenNivel1 = new Indicaciones(nombre='imagenNivel1', imagen='Nivel-1-ten-cuidado-con.png', duracion=7, position=game.at(8,14))
const imagenNivel2 = new Indicaciones(nombre='imagenNivel2', imagen='Nivel-2-Crawlers.png', duracion=7, position=game.at(9,14))
