package io.ohaj.spacedrepetition

import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.stream.Materializer
import com.typesafe.config.ConfigFactory

object SpacedRepetitionService extends App {

  implicit val system = ActorSystem("SpacedRepetition")
  implicit val materializer: Materializer = Materializer(system)
  implicit val executionContext = system.dispatcher
  implicit val config = ConfigFactory.load()

  Http().newServerAt(config.getString("http.interface"), config.getInt("http.port")).bind(Routes.apply)
}
