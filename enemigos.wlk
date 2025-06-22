class Enemigos {
  const nombre
  override method toString() = nombre
  var vida
  const daño
  const yAleatoria = new Range(start=0,end=3).anyOne()
  var property position = game.at(30,yAleatoria)
  
  method enemigoID() = 'enemigo_' + nombre

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
}

class AlienRaptor inherits Enemigos{

  override method movimiento(){
    const tiempo = new Range(start = 750, end = 2000).anyOne() //una velocidad minima de 500 maxima 2500
    game.onTick(tiempo, self.enemigoID(), {self.avanzar()})
    // Añadir eliminacion de enemigos si pasan del escenario
  }

  method image() = 'alienRaptorArma.png'
  
}

class Crawler inherits Enemigos {

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
        return new AlienRaptor(nombre='alien'+id.toString(), vida=20, daño=5)
      } else (nombreEnemigo == "crawler") return new Crawler(nombre='crawler'+id.toString(), vida=30, daño=10)
    }

    method generarAlienRaptor(id){
      return new AlienRaptor(nombre='alien'+id.toString(), vida=20, daño=5)
    }

    method generarCrawler(id){
      return new Crawler(nombre='crawler'+id.toString(), vida=30, daño=10)
    }

}