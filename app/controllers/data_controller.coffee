
exports.DataController = (app) ->

  # object substitution.
  {Data} = app.settings.models
  {Image} = app.settings.models
 	io = app.settings.socketio
  fs = require 'fs'


  return {
    index: (req, res, next) ->
      console.log "DataController.index"
      # Data.find~
      res.json 200, test: 'Hello City.'

    image_reset: (req, res, next)->
    	Image.remove {}, (err)->
    		if err
    			throw err
    		console.log 'reset'
    		res.send 'reset'

	  image_upload: (req, res, next)->
      path = "./public/img/test_id/"
      console.log req.files.image.length
      iLength = req.files.image.length - 1
      for i in [0..iLength]
        img = req.files.image[i]
        console.log req.files.image[i]
        readFile = fs.readFileSync img.path
        isWritten = fs.writeFileSync path+img.name, readFile
        image = new Image()
        image.name  = img.name
        image.date  = img.lastModifiedDate
        image.url   = "http://localhost:3000/img/test_id/"+img.name
        image.tagid = "hoge"
        image.save (err)->
        	if err
            console.log err
          console.log 'save!'
          return res.send 'ok'

    websocket:
    	initialize: (data, socket)->
    		Image.find {tagid: data.tagid}, (err, docs)->
    			console.log docs
    			socket.emit 'initialize', docs
  }