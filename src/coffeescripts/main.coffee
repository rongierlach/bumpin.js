require('./bumpin')()

#ready
$(document).ready ->

	opts =
		# audio src
		audio_src: "http://youfoundron.com/cdn/audio/bumpin.mp3"

		# play options
		autoplay: false
		loop: false

		# animation options
		direction: 'down' # takes [ u, d, l, r, up, down, left, right, ^, v, <, > ]
		speed: 200 # ms
		easing: 20 # ms

		# 'kick' actuation point options (usually best between 20 to 100 hz)
		freq: [20, 100] # min - max hz
		ampl: [0, 666] # min - max db

		# href attr's for control buttons on the page
		play_btn: '#play'
		pause_btn: '#pause'
		stop_butn: '#stop'

		# control keys
		play_key: 'P'
		pause_key: 'P'
		stop_key: 'S'

	$('.bump-me').bumpin opts
