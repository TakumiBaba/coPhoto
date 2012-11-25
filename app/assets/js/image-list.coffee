$ ->
	api = 'http://133.27.147.134:1217/'
	ws_api = "http://133.27.147.134:1218/"
	tag = $(location.href.split("/")).last()[0].replace "#", ""
	console.log tag
	$.ajax
		url:api+"get_title/"+tag
		type:"GET"
		success:(data)->
			console.log data
			$('h1.title').html(data.name)
	upload = (files)->
		#api = 'http://ascension.chi.mag.keio.ac.jp/upload'
		#ws_api = "http://olive.chi.mag.keio.ac.jp/upload"
		console.log tag
		fd = new FormData()
		for file in files
			fd.append 'image', file
		$.ajax
			url: api+"upload/"+tag
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
	removeFlag = false
	$("#add_button").click ()->
		$('#file').click()
	$("#remove_button").click (e)->
		if removeFlag
			removeFlag = false
			$(e.currentTarget).html("-")
		else
			removeFlag = true
			$(e.currentTarget).html("end")
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
		ele_base.css height:$('.content').height()*0.4
		ele_img  = $('<img>')
		ele_img.attr 'src', src

		ele_base.append ele_img

		$('.content').prepend ele_base
	#	ele_base.show(500)
		ele_base.isOpen = false
		ele_base.bind 'click touchend touchstart', scaleImage

	appendImage = (src)->

		ele_base = $('<div>')
		ele_base.addClass 'img-element'
		ele_base.css height:$('.content').height()*0.4
		ele_img  = $('<img>')
		ele_img.attr 'src', src
		#ele_base.hide()
		ele_base.append ele_img
		$('.content').append ele_base
		#ele_base.show(500)
		ele_base.isOpen = false
		ele_base.bind 'click touchend touchstart', scaleImage

	touchPoint = {}

	scaleImage = (e)->
		if e.type is 'touchstart'
			touchPoint.x = e.changeTouches[0].pageX
			touchPoint.y = e.changeTouches[0].pageY
		if e.type is 'touchend'
			if touchPoint.x is e.changeTouches[0].pageX &&
				 touchPoint.y is e.changeTouches[0].pageY
				if this.isOpen
					#$(e.currentTarget).height($('body').width()*0.8)
					$(e.currentTarget).height($('.content').height()*0.4)
					this.isOpen = false
				else
					$(e.currentTarget).height($(e.target).height())
					this.isOpen = true
				if removeFlag
					$(e.currentTarget).hide()
		if e.type is 'click'
			if this.isOpen
				#$(e.currentTarget).height($('body').width()*0.48)
				console.log
				$(e.currentTarget).height($('.content').height()*0.4)
				this.isOpen = false
			else
				$(e.currentTarget).height($(e.target).height())

				this.isOpen = true
			if removeFlag
				$(e.currentTarget).hide()

	image_url_list = []
	image_url_list_num = 0

	isTitleClick = false
	$('h1.title').click ()->
		if isTitleClick is true
			return false
		isTitleClick = true
		title = $("<input type='text''>")
		title.attr 'placeholder', $('h1.title').html()
		$('h1.title').html("")
		title.css
			width: '50%'
		$(this).append title
		title.focus()
		title.bind 'keydown', (e)=>
			if e.keyCode is 13
				$('h1.title').html(e.target.value)
				#$('h1.title').remove title
				$.ajax
					url: api+"title/"+e.target.value+"/tag/"+tag

	socket = io.connect ws_api
	socket.emit 'tagid', {tagid: tag}
	socket.on 'initialize', (data)->
		if data.length == 0
			return false
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