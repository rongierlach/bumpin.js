require('./bumpin')()

#ready
$(document).ready ->

	opts =
		# audio src
		audio_src: "./audio/bumpin.mp3"

		# play options
		autoplay: false
		loop: false

		# href attr's for control buttons on the page
		play_btn: '#play'
		pause_btn: '#pause'
		# stop_btn: '#stop'

		# animation options
		direction: 'down' # takes [ u, d, l, r, up, down, left, right, ^, v, <, > ]
		speed: 200 # ms
		easing: 20 # ms
		distance: [0, 60] # range or single value (pixels)
		hover_stop: false # stop animating on hover event
		freq: [20, 100] # min - max hz - 'kick' actuation point options (usually best between 20 to 100 hz)
		ampl: [0, 666] # min - max db

	moar_opts =
		direction: 'up'
		speed: 500
		easing: 40
		distance: [2, 100]
		hover_stop: true
		freq: [500, 700]
		ampl: [0, 666]

	$('.bump-me').bumpin opts

	# setTimeout // fade in the "me too!" div
	# $('.me-too').bumpin moar_opts

	# $().bumpin('play')
