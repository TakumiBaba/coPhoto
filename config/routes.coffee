module.exports = (app, io) ->
  ### Controller ###
  controllers   = app.settings.controllers
  # Controllers are function, pass `app` at first argument.
  ViewController = controllers.ViewController app
  DataController = controllers.DataController app

  ### Routing ###
  app.get '/tag/:tag'             , ViewController.index
  app.get "/get_title/:tag", DataController.get_tag_to_title
  app.get "/get_tag/:title", DataController.get_title_to_tag
  app.get "/title/:name/tag/:tag", DataController.set_tag_to_title
  # For backbone.
  app.put /^\/(.*)\.json$/, DataController.index
  app.get '/image/reset', DataController.image_reset
  app.post '/upload/:tag', DataController.image_upload

  ### webscoket ###
  io.sockets.on 'connection', DataController.websocket

  ### Fallback ###
  # Should handle the fallback(404) with front server.
  app.all /.*/, (req, res, next) ->
    console.log "Fallback."
    res.writeHead 404, 'Content-Type': 'text/html'
    res.end (require 'fs').readFileSync "#{__dirname}/../public/404.html"
