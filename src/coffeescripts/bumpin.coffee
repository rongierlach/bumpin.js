require 'velocity/velocity.js'
require 'dancer/dancer.js' # https://www.npmjs.com/package/dancer

# bumpin class
class Bumpin
  constructor: (settings) ->
    # config vars
    @auto_play = settings.auto_play
    @loop = settings.loop
    @playing = undefined

    # initialize animations array and add first animation
    @animations = []
    @addAnimation settings

    # setup controls
    @setupControls settings

    # dancer config
    @d = new Dancer()
    @d.bind 'update', => @update
    @d.bind 'loaded', => @play if @auto_play

    @loadAudio settings.audio_src

  update: ->
    # run the animations n shit

  play: -> @d.play()

  pause: -> @d.pause()

  isPlaying: -> @d.isPlaying()

  loadAudio: (audio_src) ->
    a = new Audio()
    a.src = audio_src
    @d.load a

  addAnimation: (settings) ->
    animation =
      selector: settings.selector
      direction: settings.direction
      speed: settings.speed
      easing: settings.easing
      distance: settings.distance
      hover_stop: settings.hover_stop
      freq: settings.freq
      ampl: settings.ampl
      is_animating: false
    @animations.push animation

  setupControls: (controls) ->
    # toggling play / pause
    if controls.play_btn is controls.pause_btn
      $("a[href='#{controls.play_btn}']").click (e) =>
        e.preventDefault()
        if @isPlaying() then @play else @pause
    else
      # play button
      $("a[href='#{controls.play_btn}']").click (e) =>
        e.preventDefault()
        @play()
      # pause button
      $("a[href='#{controls.pause_btn}']").click (e) =>
        e.preventDefault()
        @pause()


module.exports = ->
  $.fn.bumpin = (opts) ->
    # define current instance
    bumpin = if window.bumpin_instance then window.bumpin_instance else undefined

    # specify default options
    settings = $.extend {
      # play options
      autoplay: true
      loop: false

      # animation options
      selector: @selector
      direction: 'down' # takes [up, down, left, right, u, d, l, r, ^, v, <, >], eventually implement degree system...
      speed: 200 # ms
      easing: 20 # ms
      distance: [0, 60] # range or single value (pixels)
      hover_stop: false # stop animating on hover event
      # 'kick' actuation point options frequency (usually best between 20 to 100 hz) and amplitude
      freq: [20, 100] # min - max hz
      ampl: [0, 666] # min - max db

      # href attrs for control buttons on the page
      play_btn: '#play'
      pause_btn: '#pause'
      # stop_btn: '#stop'

    }, opts

    # check if function was passed instead
    func = undefined
    func = opts if typeof opts is 'string'

    # log settings
    # console.log settings, func

    # call function
    bumpin[func]() if func and bumpin

    # add animation if selector is given and a bumpin instance exists
    bumpin.loadAnimation settings if @selector and bumpin

    # create first instance if bumpin does not exist
    unless bumpin
      window.bumpin_instance = bumpin = new Bumpin settings

    # update the instance on window
    window.bumpin_instance = bumpin

    # make the plugin chainable
    return @
