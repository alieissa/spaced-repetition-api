package io.ohaj.spacedrepetition

import io.getquill.{PostgresJdbcContext, SnakeCase}

object Database {
  lazy val ctx = new PostgresJdbcContext(SnakeCase, "jdbc")
}
