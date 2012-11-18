module.exports = (app, io) ->
  ### Controller ###
  controllers   = app.settings.controllers
  # Controllers are function, pass `app` at first argument.
  ViewController = controllers.ViewController app
  DataController = controllers.DataController app

  ### Routing ###
  app.get '/tag/:tag'             , ViewController.index
  # For backbone.
  app.put /^\/(.*)\.json$/, DataController.index
  app.get '/image/reset', DataController.image_reset
  app.post '/upload', DataController.image_upload

  ### webscoket ###
  io.sockets.on 'connection', (socket)->
    socket.on 'tagid', (data)=>DataController.websocket.initialize(data, socket)

  ### Fallback ###
  # Should handle the fallback(404) with front server.
  app.all /.*/, (req, res, next) ->
    console.log "Fallback."
    res.writeHead 404, 'Content-Type': 'text/html'
    res.end (require 'fs').readFileSync "#{__dirname}/../public/404.html"
