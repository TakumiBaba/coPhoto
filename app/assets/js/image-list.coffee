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
	loadingFlag = false

	$("#add_button").click ()->
		$('#file').click()
	$("#file").change (e)->
		files = document.getElementById('file').files
		upload files
	$('.content').scroll (e)->
		if (e.target.scrollHeight - e.target.scrollTop) < $(window).height() + 100 && loadingFlag is false
			start = image_url_list_num
			end = image_url_list_num+9
			loadingFlag = true
			for i in [start...end]
				appendImage image_url_list[i].url
				image_url_list_num += 1
			setTimeout ()=>
				loadingFlag = false
			, 10000


	prependImage = (src)->
		ele_base = $('<div>')
		ele_base.addClass 'img-element'
		#ele_base.css height:$('body').height()*0.4
		ele_img  = $('<img>')
		ele_img.attr 'src', src
		#
		ele_base.append ele_img
		$(".content").prepend ele_base
	#	ele_base.show(500)
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

	appendImage = (src)->

		ele_base = $('<div>')
		ele_base.addClass 'img-element'
		#ele_base.css height:$('body').height()*0.4
		ele_img  = $('<img>')
		ele_img.attr 'src', src
		#ele_base.hide()
		ele_base.append ele_img
		$(".content").append ele_base
		#ele_base.show(500)
		ele_base.isOpen = false
		ele_base.bind 'click touchend touchstart', (e)->
			if e.type is 'touchstart'
				touchPoint.x = e.changeTouches[0].pageX
				touchPoint.y = e.changeTouches[0].pageY
			if e.type is 'touchend'
				if touchPoint.x is e.changeTouches[0].pageX &&
					 touchPoint.y is e.changeTouches[0].pageY
					if this.isOpen
						#$(e.currentTarget).height($('body').width()*0.8)
						$(e.currentTarget).width($('body').width()*0.8)
						this.isOpen = false
					else
						$(e.currentTarget).height($(e.target).height())
						this.isOpen = true
			if e.type is 'click'
				if this.isOpen
					#$(e.currentTarget).height($('body').width()*0.48)
					$(e.currentTarget).width($('body').width()*0.48)
					this.isOpen = false
				else
					$(e.currentTarget).height($(e.target).height())
					this.isOpen = true

	touchPoint = {}


	image_url_list = []
	image_url_list_num = 0

	socket = io.connect 'http://olive.chi.mag.keio.ac.jp'
	socket.emit 'tagid', {tagid: 'hoge'}
	socket.on 'initialize', (data)->
		image_url_list = data
		start = image_url_list_num
		end = image_url_list_num + 9
		for i in [image_url_list_num..image_url_list_num+9]
			appendImage image_url_list[i].url
			image_url_list_num += 1
	socket.on 'add',(data)->
		console.log data
		prependImage data.url
###