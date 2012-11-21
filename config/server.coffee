require 'coffee-script'
require 'colors'

process.env.NODE_ENV = process.env.NODE_ENV || 'development'

global._ = require 'underscore'
http     = require 'http'
express  = require 'express'
app      = express()
io       = require('socket.io').listen 1218
#io.set 'transports', ['xhr-polling']


(require './config') app, io
(require './routes') app, io

http.createServer(app).listen app.get('port'), ->
  console.info "HTTP server listening on port #{app.get 'port'}."
  console.info "Application is #{process.env.NODE_ENV} mode."