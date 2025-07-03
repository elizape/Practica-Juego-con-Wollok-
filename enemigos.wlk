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
  method esBala() = false
  method esEnemigo() = true
  
  method enemigoID() = 'enemigo_' + nombre

  method posicionActual() = position

  method avanzar() {
    position = position.left(1)
    if (self.posicionActual().x() < -3){
      game.removeTickEvent(self.enemigoID() + 'disparo enemigo')
      game.removeTickEvent(self.enemigoID())
      game.removeVisual(self)
      jugador.recibirDaño(15) //si el enemigo sale del mapa, le hace daño al jugador
    }
  }

  method pausar() {
    game.removeTickEvent(self.enemigoID())
    game.removeTickEvent(self.enemigoID() + 'disparo enemigo')
  }

  method despausar() {
    self.movimiento()
    self.atacar()
  }

  method movimiento()

  method mostrarArma()

  method atacar(objetivo) {
    objetivo.recibirDaño(daño)
  }
  method recibirDaño(dañoRecibido) {
    vida = vida - dañoRecibido
    if (vida <= 0){
      game.removeTickEvent(self.enemigoID() + 'disparo enemigo')
      game.removeTickEvent(self.enemigoID())
      game.removeVisual(self)
      creadorHordas.removerEnemigo(self)
    }
  }
  method mostrarVida() = vida

  method atacar()

  method disparar()

  method detectarEnemigo() {
    return jugador.posicionActual().y() == self.posicionActual().y() && jugador.posicionActual().x() < self.posicionActual().x()
  }
}

class AlienRaptor inherits Enemigos{

  var idBala = 0

  override method movimiento(){
    const tiempo = new Range(start = 750, end = 2000).anyOne() //una velocidad minima de 500 maxima 2500
    game.onTick(tiempo, self.enemigoID(), {self.avanzar()})
  }

  method image() = 'alienRaptorArma.png'

  override method mostrarArma() = rifle

  override method atacar() {
    game.onTick(self.mostrarArma().cadenciaDisparo()*1000, self.enemigoID() + 'disparo enemigo', {self.disparar()})
  }

  override method disparar() {
    if (self.detectarEnemigo()) {
      const posX = self.posicionActual().x() - 1
      const posY = self.posicionActual().y() + 0
      const balaEnemigo = new BalaRifleAlien(position = game.at(posX, posY), id = 'balaEnemigo' + nombre + idBala, arma=self.mostrarArma())
      listaBalas.añadirBala(balaEnemigo)
      game.addVisual(balaEnemigo)
      game.sound(self.mostrarArma().sonidoAleatorioArma()).play()
      balaEnemigo.desplazamientoBalaX()
      idBala += 1
    }
  }

}

class Crawler inherits Enemigos {

  var idBala = 0

  override method mostrarArma() = bolaFuego

  override method movimiento(){
    const tiempo = new Range(start = 500, end = 750).anyOne() //una velocidad minima de 500 maxima 1000
    game.onTick(tiempo, self.enemigoID(), {self.avanzar()})
  }

  method image() = 'crawler(2).png'

  override method atacar() {
    game.onTick(self.mostrarArma().cadenciaDisparo()*1000, self.enemigoID() + 'disparo enemigo', {self.disparar()})
  }

  override method disparar() {
    if (self.detectarEnemigo()) {
      const posX = self.posicionActual().x() - 1
      const posY = self.posicionActual().y() + 0
      const balaEnemigo = new BalaCrawler(position = game.at(posX, posY), id = 'balaEnemigo' + nombre + idBala, arma=self.mostrarArma())
      listaBalas.añadirBala(balaEnemigo)
      game.addVisual(balaEnemigo)
      game.sound(self.mostrarArma().sonidoAleatorioArma()).play()
      balaEnemigo.desplazamientoBalaX()
      idBala += 1
    } 
  }
}

class FinalBoss inherits Enemigos{
  method image() = ''
}

object creadorHordas {
  const tipoDeEnemigo = ['alien','crawler']
  const listaEnemigos = []
  var puedeGenerar = true

  method obtenerPuedeGenerar() = puedeGenerar

  method cambiarPuedeGenerar() {
    puedeGenerar = !puedeGenerar
  }

  method verListaEnemigos() = listaEnemigos

  method removerEnemigo(enemigo) {
    listaEnemigos.remove(enemigo)
  }

  method reiniciarLista() {
    listaEnemigos.clear()
  }
  
  method generarHordaAlien(cantidad, tiempoMinimoSpawn,tiempoMaximoSpawn){
      var id = 0
      self.cambiarPuedeGenerar()
      game.onTick(self.tiempoAparicion(tiempoMinimoSpawn,tiempoMaximoSpawn)*1000, 'horda Enemigos',{
        if (id < cantidad && nivel.estaPausado()) {
          const enemigo = self.generarAlienRaptor(id)
          game.addVisual(enemigo)
          enemigo.movimiento()
          listaEnemigos.add(enemigo)
          enemigo.atacar()
          id += 1
        } else if (nivel.estaPausado()) {
          self.cambiarPuedeGenerar()
          game.removeTickEvent('horda Enemigos')
        }
      })
  }

  method generarHordaCrawler(cantidad, tiempoMinimoSpawn,tiempoMaximoSpawn){
      var id = 0
      self.cambiarPuedeGenerar()
      game.onTick(self.tiempoAparicion(tiempoMinimoSpawn,tiempoMaximoSpawn)*1000, 'horda Enemigos',{
        if (id < cantidad && nivel.estaPausado()) {
          const enemigo = self.generarCrawler(id)
          listaEnemigos.add(enemigo)
          game.addVisual(enemigo)
          enemigo.movimiento()
          enemigo.atacar()
          id += 1
        } else if (nivel.estaPausado()) {
          self.cambiarPuedeGenerar()
          game.removeTickEvent('horda Enemigos')
        }
      })
  }
  
  method generarHordaAleatoria(cantidad, tiempoMinimoSpawn,tiempoMaximoSpawn){
      var id = 0
      self.cambiarPuedeGenerar()
      game.onTick(self.tiempoAparicion(tiempoMinimoSpawn,tiempoMaximoSpawn)*1000, 'horda Enemigos',{
        if (id < cantidad && nivel.estaPausado()) {
          const enemigo = self.generarEnemigoAleatorio(id)
          listaEnemigos.add(enemigo)
          game.addVisual(enemigo)
          enemigo.movimiento()
          enemigo.atacar()
          id += 1
        } else if (nivel.estaPausado()) {
          self.cambiarPuedeGenerar()
          game.removeTickEvent('horda Enemigos')
        }
      })
    }

  method tiempoAparicion(tiempoMinimo,tiempoMaximo) {
      return new Range(start = tiempoMinimo, end = tiempoMaximo).anyOne() //elige entre un tiempo minimo de (tiempoMinimo)segundos y un tiempo maximo de 7segundos
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

  method verificarSiHayEnemigo() {
      return (self.obtenerPuedeGenerar() && self.verListaEnemigos().isEmpty() && nivel.estaPausado())
  }

}