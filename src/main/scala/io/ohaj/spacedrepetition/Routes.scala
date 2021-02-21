package io.ohaj.spacedrepetition

import akka.actor.ActorSystem
import akka.http.scaladsl.server.Directives._
import akka.stream.Materializer
import com.typesafe.config.Config

import scala.concurrent.ExecutionContext

object Routes {

  def apply(implicit ec: ExecutionContext, config: Config, system: ActorSystem, materializer: Materializer) =
    pathPrefix("api") {
      (path("decks") & pathEndOrSingleSlash & get) {
        parameters("offset".as[Int].withDefault(0), "limit".as[Int].withDefault(100)) {
          (offset, limit) =>
            complete(
              Decks.getAll(offset, limit)
            )

        }
      }
    }
}
