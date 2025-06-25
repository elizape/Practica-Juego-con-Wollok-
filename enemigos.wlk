import armas.*
import personajes.*
import nivel0.*
import nivel1.*

class Enemigos {
  const nombre
  override method toString() = nombre
  var vida
  const daño
  const yAleatoria = new Range(start=0,end=3).anyOne()
  var property position = game.at(30,yAleatoria)
  
  method enemigoID() = 'enemigo_' + nombre

  method posicionActual() = position

  method avanzar() {
    position = position.left(1)
  }

  method movimiento()

  method atacar(objetivo) {
    objetivo.recibirDaño(daño)
  }
  method recibirDaño(dañoRecibido) {
    vida = vida - dañoRecibido
    if (vida <= 0){
      game.removeTickEvent(self.enemigoID())
      game.removeVisual(self)
    }
  }
  method mostrarVida() = vida

  method atacar()
}

class AlienRaptor inherits Enemigos{

  var idBala = 0

  override method movimiento(){
    const tiempo = new Range(start = 750, end = 2000).anyOne() //una velocidad minima de 500 maxima 2500
    game.onTick(tiempo, self.enemigoID(), {self.avanzar()})
  }

  method image() = 'alienRaptorArma.png'

  method mostrarArma() = pistolaPlasma

  override method atacar() {
    game.onTick(self.mostrarArma().cadenciaDisparo()*1000, self.enemigoID() + 'disparo enemigo', {self.disparar()})
  }

  method disparar() {
    if (self.detectarEnemigo()) {
      const posX = self.posicionActual().x() - 1
      const posY = self.posicionActual().y() + 0
      const balaEnemigo = new BalaRifle(position = game.at(posX, posY), id = 'balaEnemigo ' + idBala)
      game.addVisual(balaEnemigo)
      game.sound(self.mostrarArma().sonidoAleatorioArma()).play()
      balaEnemigo.desplazamientoBalaY(self.mostrarArma())
      idBala += 1
    }
  }

  method detectarEnemigo() {
    if (jugador.posicionActual().y() == self.posicionActual().y()) {
      return true
    } else (jugador.posicionActual().y() != self.posicionActual().y()) {
      return false
    }
  }
}

class Crawler inherits Enemigos {

  override method atacar() = null

  override method movimiento(){
    const tiempo = new Range(start = 500, end = 750).anyOne() //una velocidad minima de 500 maxima 1000
    game.onTick(tiempo, self.enemigoID(), {self.avanzar()})
  }

  method image() = 'crawler(2).png'
}

class FinalBoss inherits Enemigos{
  method image() = ''
}

object creadorHordas {
  const tipoDeEnemigo = ['alien','crawler']
  const listaEnemigos = []

  method verListaEnemigos() = listaEnemigos
  
  method generarHordaAlien(cantidad, tiempoMinimoSpawn){
      var id = 0
      game.onTick(self.tiempoAparicion(tiempoMinimoSpawn)*1000, 'horda Enemigos',{
        if (id < cantidad) {
          const enemigo = self.generarAlienRaptor(id)
          game.addVisual(enemigo)
          enemigo.movimiento()
          listaEnemigos.add(enemigo)
          enemigo.atacar()
          id += 1
        }
      })
  }

  method generarHordaCrawler(cantidad, tiempoMinimoSpawn){
      var id = 0
      game.onTick(self.tiempoAparicion(tiempoMinimoSpawn)*1000, 'horda Enemigos',{
        if (id < cantidad) {
          const enemigo = self.generarCrawler(id)
          listaEnemigos.add(enemigo)
          game.addVisual(enemigo)
          enemigo.movimiento()
          enemigo.atacar()
          id += 1
        }
      })
  }
  
  method generarHordaAleatoria(cantidad, tiempoMinimoSpawn){
      var id = 0
      game.onTick(self.tiempoAparicion(tiempoMinimoSpawn)*1000, 'horda Enemigos',{
        if (id < cantidad) {
          const enemigo = self.generarEnemigoAleatorio(id)
          listaEnemigos.add(enemigo)
          game.addVisual(enemigo)
          enemigo.movimiento()
          enemigo.atacar()
          id += 1
        }
      })
    }

  method tiempoAparicion(tiempoMinimo) {
      return new Range(start = tiempoMinimo, end = 7).anyOne() //elige entre un tiempo minimo de (tiempoMinimo)segundos y un tiempo maximo de 7segundos
    }

    method generarEnemigoAleatorio(id){
      var nombreEnemigo = tipoDeEnemigo.anyOne()
      if (nombreEnemigo == 'alien'){
        return self.generarAlienRaptor(id)
      } else (nombreEnemigo == "crawler") return self.generarCrawler(id)
    }

    method generarAlienRaptor(id){
      return new AlienRaptor(nombre='alien'+id.toString(), vida=20, daño=5)
    }

    method generarCrawler(id){
      return new Crawler(nombre='crawler'+id.toString(), vida=30, daño=10)
    }

}