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
    game.removeTickEvent(nombre)
  }
  method nombreGetter() = nombre

  method image() = imagen

  method duracionImagen() = duracion
}