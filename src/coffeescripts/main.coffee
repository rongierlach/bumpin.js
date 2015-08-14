require 'velocity/velocity.js'
require('./bumpin')()

#ready
$(document).ready ->

	getRandomColor = ->
		letters = '0123456789ABCDEF'.split('')
		color = '#'
		for i in [0..5]
			color += letters[Math.floor(Math.random() * 16)]
		return color

	init =
		# audio source
		# audio_src: "./audio/bumpin.mp3"
		# audio_src: "https://s3-us-west-2.amazonaws.com/s.cdpn.io/161040/bumpin.mp3"
		audio_src: 'http://youfoundron.com/cdn/audio/bumpin.mp3'

		# play options
		autoplay: false
		loop: true

		# href attr's for control buttons on the page
		play_btn: '#play'
		pause_btn: '#pause'
		volume_up: '#volume_up'
		volume_down: '#volume_down'

	# animation options
	opts =
		change_color: true
		speed: 80 # ms
		scale: [1, 1.5] # range or single value (pixels)
		freq: 2 # int or range [min, max] - 'kick' actuation point
		ampl: 0.09 # minimum amplitude of the frequency range in order for a kick to occur. Default: 0.03
		decay: 0.02 # the rate that the previously registered kick's amplitude is reduced by on every frame. Default: 0.02
		onKick: (kick) ->

	moar_opts = $.extend {}, opts
	# example use of onKick callback
	moar_opts.onKick = (kick) ->
		color = getRandomColor()
		$elm = $ kick.animation_data.selector
		$elm.css { color: color, 'border-color': color }


	$().bumpin init
	$('.bump-me').bumpin opts
	$('.me-too').bumpin moar_opts
	$('.title').bumpin opts
	$().bumpin 'play'
