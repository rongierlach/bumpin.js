require('./bumpin')()

#ready
$(document).ready ->

	opts =
		# audio src
		audio_src: "./audio/bumpin.mp3"

		# play options
		autoplay: true
		loop: true

		# href attr's for control buttons on the page
		play_btn: '#play'
		pause_btn: '#pause'
		volume_up: '#volume_up'
		volume_down: '#volume_down'

		# animation options
		direction: 'down' # takes [ u, d, l, r, up, down, left, right, ^, v, <, > ]
		speed: 200 # ms
		easing: 20 # ms
		distance: [0, 60] # range or single value (pixels)
		hover_stop: false # stop animating on hover event
		freq: 2 # int or range [min, max] - 'kick' actuation point options (usually best between 20 to 100 hz)
		ampl: 0.1 # minimum amplitude of the frequency range in order for a kick to occur. Default: 0.03
		decay: 0.02 # the rate that the previously registered kick's amplitude is reduced by on every frame. Default: 0.02

	moar_opts =
		direction: 'up'
		speed: 500
		easing: 40
		distance: [2, 100]
		hover_stop: true
		freq: [0, 10]
		ampl: 0.1
		decay: 0.02

	$('.bump-me').bumpin opts

	# setTimeout // fade in the "me too!" div
	# $('.me-too').bumpin moar_opts

	# $().bumpin('play')
