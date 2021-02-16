#!/usr/bin/env bb

(ns headset-battery
  (:require [clojure.string :refer [split includes?]]
            [clojure.java.shell :refer [sh]]))

(let [{:keys [out]} (sh "headsetcontrol" "-b")]
  (->> (split out #"\n")
       (filter #(seq %))
       (filter #(includes? % "Battery"))
       (map    #(re-find #"Battery: (\d+%)" %))
       (map    #(nth % 1))
       (first)))
