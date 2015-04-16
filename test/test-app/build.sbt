import NativePackagerKeys._

name := """test-app"""

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.1"

libraryDependencies ++= Seq(
  jdbc,
  anorm,
  cache,
  ws
)

maintainer in Docker := "John Smith <john.smith@example.com>"

dockerExposedPorts in Docker := Seq(9000)