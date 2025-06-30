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

const imagen342 = new Indicaciones(nombre='hasPerdido', imagen='Has-Muerto(1).png', duracion=1,position=game.at(0,0))
const imagen343 = new Indicaciones(nombre='reiniciar', imagen='reiniciar(3).png', duracion=1, position=game.at(11,5))
