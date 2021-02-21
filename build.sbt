

ThisBuild / scalaVersion := "2.12.13"

ThisBuild / organization := "io.ohaj"

val AkkaVersion = "2.6.8"
val AkkaHttpVersion = "10.2.3"

libraryDependencies ++= Seq(
  "com.typesafe.akka" %% "akka-actor-typed" % AkkaVersion,
  "com.typesafe.akka" %% "akka-stream" % AkkaVersion,
  "com.typesafe.akka" %% "akka-http" % AkkaHttpVersion,
  "org.postgresql" % "postgresql" % "42.2.8",
  "io.getquill" %% "quill-jdbc" % "3.6.1",
  "com.typesafe" % "config" % "1.4.1"
)

version := "0.1"

enablePlugins(JavaAppPackaging)
maintainer in Docker := "ali eissa <aeissa.o@gmail.com>"
packageSummary in Docker := "Spaced repetition server API"
dockerExposedPorts in Docker := Seq(8080)
dockerBaseImage in Docker := "openjdk:11"
dockerUsername in Docker := Some("aeissa")
dockerUpdateLatest := true

