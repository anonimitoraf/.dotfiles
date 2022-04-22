#!/usr/bin/env bash

function setup_blog_processes () {
  cd "${HOME}/Dropbox/blog" && hugo -D server & # hot reload
  cd "${HOME}/Dropbox/blog" && hugo --watch  & # auto-build
}

function setup_ngrok_ssh () {
  ngrok tcp --region=au --remote-addr=1.tcp.au.ngrok.io:25234 22
}
