package io.ohaj.spacedrepetition

import scala.concurrent.{ExecutionContext => EC}

case class Deck()

object Decks {

  import Database.ctx
  import ctx._

  lazy val query = quote[Deck]

  def getAll(offset: Int, limit: Int)(implicit ec: EC) = ???
}
