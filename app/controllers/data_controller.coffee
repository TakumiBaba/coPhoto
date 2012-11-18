
exports.DataController = (app) ->

  # object substitution.
  {Data} = app.settings.models
  {Image} = app.settings.models
 	Users = []
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
      imageArray = []
      v = 0
      for i in [0..iLength]
        img = req.files.image[i]
        console.log req.files.image[i]
        readFile = fs.readFileSync img.path
        isWritten = fs.writeFileSync path+img.name, readFile
        image = new Image()
        image.name  = img.name
        image.date  = img.lastModifiedDate
        image.url   = "http://ascension.chi.mag.keio.ac.jp/img/test_id/"+img.name
        image.tagid = "hoge"
        imageArray.push image
        image.save (err)=>
        	if err
            throw err
          console.log 'save!'
          for u in Users
            if u.tagid = image.tagid
              u.emit 'add', {url: imageArray[v].url}
              v += 1
      return res.send 'ok'

    websocket: (socket)->
      socket.on 'tagid', (data)->
        socket.tagid = data.tagid
        Users.push socket
        Image.find {tagid: data.tagid}, (err, docs)->
          socket.emit 'initialize', docs
      socket.on 'add', (data)->

  }