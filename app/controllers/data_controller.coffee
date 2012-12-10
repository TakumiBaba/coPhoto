
exports.DataController = (app) ->

  # object substitution.
  {Data} = app.settings.models
  {Image} = app.settings.models
  {Title} = app.settings.models
 	Users = []
  fs = require 'fs'
  im = require 'imagemagick'
  API = "http://192.168.2.103:1217/img/"

  return {
    index: (req, res, next) ->
      console.log "DataController.index"
      # Data.find~
      res.json 200, test: 'Hello City.'
    get_title_to_tag: (req, res, next)->
      #URIエンコードでの比較
      Title.findOne {title: req.params.title}, (err, doc)->
        if doc isnt null
          res.send doc
        else
          res.send []
    get_tag_to_title: (req, res, next)->
      Title.findOne {tag: req.params.tag}, (err, doc)->
        if doc isnt null
          console.log doc
          res.send doc
        else
          res.send {name:'タイトルを決める'}
    set_tag_to_title: (req, res, next)->
      Title.findOne tag: req.params.tag, (err, doc)->
        if !doc
          title = new Title()
          title.tag = req.params.tag
          title.name = req.params.name
          title.save (err)->
            if err
              throw err
            console.log "title set"
            res.json this.emitted.complete
        else
          doc.name = req.params.name
          doc.save (err)->
            if err
              throw err
            console.log 'save'
            res.json this.emitted.complete


    image_reset: (req, res, next)->
    	Image.remove {}, (err)->
    		if err
    			throw err
    		console.log 'reset'
    		res.send 'reset'

	  image_upload: (req, res, next)->
      tag =  req.params.tag
      console.log "-----"
      console.log tag
      console.log "-----"
      path = "./public/img/"+tag+"/"
      console.log path
      isTagFolder = fs.existsSync path, (exists)=>
      if !isTagFolder
        fs.mkdirSync path
      iLength = req.files.image.length - 1
      if iLength > 10
        iLength = 0
      imageArray = []
      v = 0
      for i in [0..iLength]
        img = req.files.image[i]
        if iLength is 0
          img = req.files.image
        readFile = fs.readFileSync img.path
        fs.writeFileSync path+img.name, readFile
        f = path+img.name
        im.resize {srcPath: f, dstPath: f, width: 500}, (err, stdout, stderr)->
          if err
            throw err
          console.log this
        image = new Image()
        image.name  = img.name
        image.date  = (new Date(img.lastModifiedDate)).getTime()
        image.url   = API+tag+"/"+img.name
        image.tagid = tag
        imageArray[i] = image
      for img in imageArray
        img.save (err)->
          url = this.emitted.complete[0].url
          for u in Users
            u.emit 'add', {url: url}

    websocket: (socket)->
      socket.on 'tagid', (data)->
        socket.tagid = data.tagid
        Users.push socket
        Image.find {tagid: data.tagid}, (err, docs)->
          socket.emit 'initialize', docs
      socket.on 'add', (data)->

  }