import armas.*
class Jugador {
  var vida
  var arma
  var idBala = 0
  var puedeDisparar =  true
  var property position = game.at(2,2)
  
  method puedeDisparar() = puedeDisparar

  method posicionActual() = position
  
  method cambiarArma(nuevaArma) {
    arma = nuevaArma
  }
  method dañoArma() = arma.mostrarDaño()

  method disparar() {
    if (self.puedeDisparar()) {
        var posX = self.posicionActual().x() + 1
        var posY = self.posicionActual().y() + 0
        var bala = new Bala(position = game.at(posX, posY), id = idBala)
        game.addVisual(bala)
        bala.desplazamientoBala()
        idBala += 1

        // Activar cooldown
        puedeDisparar = false
        game.onTick(arma.cadenciaDisparo()*1000, 'cooldownDisparo', {
        puedeDisparar = true
        game.removeTickEvent('cooldownDisparo')
        })}
  }
  
  method recibirDaño(dañoRecibido) {
    vida = vida - dañoRecibido
  } 
  method mostrarVida() = vida

  method image() = "jugador.png"

  // Metodos para controlar el jugador

  method subir() {
    if (self.posicionActual().y() < 3) {position = position.up(1)}
  }

  method atras() {
    if (self.posicionActual().x() > 0)position = position.left(1)
  }

  method abajo() {
    if (self.posicionActual().y() > 0)position = position.down(1)
  }

  method adelante() {
    if (self.posicionActual().x() < 30)position = position.right(1)
  }
}

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
    const tiempo = new Range(start = 750, end = 2500).anyOne() //una velocidad minima de 500 maxima 2500
    game.onTick(tiempo, self.enemigoID(), {self.avanzar()})
    // Añadir eliminacion de enemigos si pasan del escenario
  }

  method image() = 'alienRaptorArma.png'
  
}

class Crawler inherits Enemigos {

  override method movimiento(){
    const tiempo = new Range(start = 500, end = 1000).anyOne() //una velocidad minima de 500 maxima 1000
    game.onTick(tiempo, self.enemigoID(), {self.avanzar()})
  }

  method image() = 'crawler(2).png'
}

class FinalBoss inherits Enemigos{
  method image() = ''
}

object creadorHordas {
  var tiposDeEnemigos = [
    new AlienRaptor(nombre='alienRápido', vida=15, daño=3),
    new Crawler(nombre='crawler', vida=30, daño=2)
  ]
  const tipoDeEnemigo = ['alien','crawler']
  var listaEnemigos = []
  
  method generarHordaAlien(cantidad, tiempoMinimoSpawn){
      var id = 0
      game.onTick(self.tiempoAparicion(tiempoMinimoSpawn)*1000, 'horda Enemigos',{
        if (id < cantidad) {
          const enemigo = self.generarAlienRaptor(id)
          listaEnemigos.add(enemigo)
          game.addVisual(enemigo)
          enemigo.movimiento()
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

class Indicaciones {
  var nombre
  var imagen
  var duracion
  var property position

  override method toString() = nombre

  method visualizar() {
    game.addVisual(self)
    game.onTick(duracion*1000, nombre, {
      game.removeVisual(self)
      game.removeTickEvent(nombre)
    })
  }

  method nombreGetter() = nombre

  method image() = imagen
}

object controles {
  method teclas(jugador) {
    keyboard.w().onPressDo {jugador.subir()}
    keyboard.a().onPressDo {jugador.atras()}
    keyboard.s().onPressDo {jugador.abajo()}
    keyboard.d().onPressDo {jugador.adelante()}
    keyboard.p().onPressDo {jugador.disparar()}
  }
}

object nivel1 {
    method iniciar() {
      const jugador = new Jugador(vida = 100, arma = rifle)
      game.addVisualCharacter(jugador)
      
      game.sound("Mick Gordon - 11. BFG Division [QHRuTYtSbJQ].mp3").play()
      controles.teclas(jugador)
      //
      creadorHordas.generarHordaAleatoria(15, 5)
      /*
      const tuto1 = new Indicaciones(nombre='tuto1', imagen='Muevete-con-WASD.png', duracion=7, position=game.at(10,14))
      const tuto2 = new Indicaciones(nombre='tuto2',imagen='disparecon.png',duracion=7,position=game.at(10,14))
      const tuto3 = new Indicaciones(nombre='tuto3', imagen='Cuidado-con-las-hordas.png', duracion=7, position=game.at(10,14))3
      
      var listaTutorial = []

      listaTutorial.add(tuto1)
      listaTutorial.add(tuto2)
      listaTutorial.add(tuto3)

      var id = 0

      game.onTick(, 'ejemplo',{
        if (id < 3) {
          listaTutorial.get(id).visualizar()
          id += 1
          game.onTick(7000, 'espera', {game.removeTickEvent('espera')})
          
        }
      })

      game.onTick(1000, 'horda_1', {
        creadorHordas.generarHordaAleatoria(15, 3)
        game.removeTickEvent('horda_1')
      })
      */
  }
}