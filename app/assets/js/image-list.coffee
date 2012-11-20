$ ->
	upload = (files)->
		api = 'http://ascension.chi.mag.keio.ac.jp/upload'
		ws_api = "http://olive.chi.mag.keio.ac.jp/upload"
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

	$("#add_button").click ()->
		$('#file').click()
	$("#file").change (e)->
		files = document.getElementById('file').files
		upload files
		for file in files
			if file
				blobURLref = window.webkitURL.createObjectURL file
				appendImage blobURLref
	$(window).scroll
	appendImage = (src)->

		ele_base = $('<div>')
		ele_base.addClass 'img-element'
		ele_base.css
			height:$(window).height()*0.2
		ele_img  = $('<img>')
		ele_img.attr 'src', src
		ele_base.hide()
		ele_base.append ele_img
		$(".content").append ele_base
		ele_base.show(500)
		ele_base.isOpen = false
		ele_base.bind 'click touchend touchstart', (e)->
			if e.type is 'touchstart'
				touchPoint.x = e.changeTouches[0].pageX
				touchPoint.y = e.changeTouches[0].pageY
			if e.type is 'touchend'
				if touchPoint.x is e.changeTouches[0].pageX &&
					 touchPoint.y is e.changeTouches[0].pageY
					if this.isOpen
						$(e.currentTarget).height($(window).height()*0.2)
						this.isOpen = false
					else
						$(e.currentTarget).height($(e.target).height())
						this.isOpen = true
			if e.type is 'click'
				if this.isOpen
					$(e.currentTarget).height($(window).height()*0.2)
					this.isOpen = false
				else
					$(e.currentTarget).height($(e.target).height())
					this.isOpen = true

	touchPoint = {}


	image_url_list = []

	socket = io.connect 'http://olive.chi.mag.keio.ac.jp'
	socket.emit 'tagid', {tagid: 'hoge'}
	socket.on 'initialize', (data)->
		image_url_list = data
		for i in [0..8]
			appendImage image_url_list[i].url
	socket.on 'add',(data)->
		console.log data
###