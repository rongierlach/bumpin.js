require 'velocity/velocity.js'
require('./bumpin')()

#ready
$(document).ready ->

	init =
		# audio src
		audio_src: "./audio/bumpin.mp3"

		# play options
		autoplay: false
		loop: false

		# href attr's for control buttons on the page
		play_btn: '#play'
		pause_btn: '#pause'
		volume_up: '#volume_up'
		volume_down: '#volume_down'

	opts =
		# animation options
		change_color: true
		speed: 80 # ms
		scale: [1, 1.5] # range or single value (pixels)
		freq: 2 # int or range [min, max] - 'kick' actuation point
		ampl: 0.09 # minimum amplitude of the frequency range in order for a kick to occur. Default: 0.03
		decay: 0.02 # the rate that the previously registered kick's amplitude is reduced by on every frame. Default: 0.02

	title_opts = $.extend {}, opts
	title_opts.change_color = false

	$().bumpin init
	$('.bump-me').bumpin opts
	$('.me-too').bumpin opts
	$('.title').bumpin title_opts
	$().bumpin 'play'
