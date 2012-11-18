$ ->
	upload = (files)->
		api = 'http://localhost:3000/upload'
		fd = new FormData()
		for file in files
			fd.append 'image', file
		$.ajax
			url: api
			type: 'POST'
			data: fd
			processData: false
			contentType: false
			success: (d)->
				console.log 'success!'
				console.log d
			error: (e)->
				console.log 'error!'
				console.log e


	$("#add-button").click ()->
		w = $(window)
		base = $("<div>")
		base.attr "draggable", 'true'
		base.css
			height: w.height()
			width:  w.width()/2
			position: 'absolute'
			left:	w.width()/4
			top: -w.height()
			'z-index': 100
			'background-color': 'gray'
		$('body').append base
		base.animate {
			top: 0
		},1000

		base.bind 'drop', (e)->
			e.preventDefault()
			files = e.originalEvent.dataTransfer.files
			upload files
		base.bind 'dragenter dragover', ()->
			return false

	socket = io.connect 'http://192.168.111.7:3001'
	socket.emit 'tagid', {tagid: 'hoge'}
	socket.on 'initialize', (data)->
		for d in data
			ele_base = $('<div>')
			ele_base.addClass 'img-element'
			ele_base.css
				height: $(window).width()*0.4
			ele_img  = $('<img>')
			ele_img.attr 'src', d.url
			ele_base.hide()
			ele_base.append ele_img
			$(".content").append ele_base
			ele_base.show(1000)