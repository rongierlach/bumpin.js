# https://www.npmjs.com/package/dancer
require 'dancer/dancer.js'

module.exports = ->
  $.fn.bumpin = (opts) ->
    # specify default options
    settings = $.extend {
      # play options
      autoplay: true
      loop: false

      # animation options
      direction: 'down' # takes [up, down, left, right, u, d, l, r, ^, v, <, >]
      speed: 200 # ms
      easing: 20 # ms
      distance: [0, 60] # range or single value (pixels)

      # 'kick' actuation point options frequency (usually best between 20 to 100 hz) and amplitude
      freq: [20, 100] # min - max hz
      ampl: [0, 666] # min - max db

      # TODO: add DOM controls
      # href attrs for control buttons on the page
      play_btn: '#play'
      pause_btn: '#pause'
      stop_butn: '#stop'

      # TODO: add key controls
      # control keys
      play_key: 'P'
      pause_key: 'P'
      stop_key: 'S'
    }, opts

    # log settings
    console.log settings
    dancer = new Dancer()


    # make the plugin chainable
    return @
