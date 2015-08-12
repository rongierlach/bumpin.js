require 'velocity/velocity.js'
require 'dancer/dancer.js' # https://www.npmjs.com/package/dancer

# bumpin class
class Bumpin
  constructor: (settings) ->
    # config vars
    @autoplay = settings.autoplay
    @loop = settings.loop
    @time = 0

    # dancer config
    @d = new Dancer()
    @d.bind 'update', => @update()
    @d.bind 'loaded', => @play() if @autoplay

    # initialize animations array and add first animation
    @kicks = []
    @direction_keys = { up: 'up', u: 'up', '^': 'up', down: 'down', d: 'down', 'v': 'down', left: 'left', l: 'left', '<': 'left', right: 'right', r: 'right', '>': 'right' }
    @addKick settings

    # setup controls
    @setupControls settings

    # load in audio
    @loadAudio settings.audio_src

    # return this
    return @

  update: ->
    current_time = @d.getTime()
    if @time is current_time
      @pause()
      @play() if @loop
    @time = current_time

  # control methods
  play: -> @d.play()
  pause: -> @d.pause()
  setVolume: (val) -> @d.setVolume val
  getVolume: -> @d.getVolume()
  volumeUp: -> @setVolume @getVolume() + 1
  volumeDown: -> @setVolume( if @getVolume() - 1 > 0 then @getVolume() - 1 else 0 )

  destroy: (stop_the_music)->
    @d.pause() if stop_the_music
    window.bumpin_instance = undefined

  isPlaying: -> @d.isPlaying()

  loadAudio: (audio_src) ->
    a = new Audio()
    a.src = audio_src
    @d.load a

  addKick: (settings) ->
    animation =
      selector: settings.selector
      direction: @direction_keys[settings.direction.toLowerCase()]
      speed: settings.speed
      easing: settings.easing
      distance: settings.distance
      hover_stop: settings.hover_stop
      freq: settings.freq
      ampl: settings.ampl
      threshold: settings.ampl
      is_animating: false

    kick = @d.createKick
      frequency: animation.freq
      threshold: animation.threshold
      decay: animation.decay
      onKick: @onKick animation
      offKick: @offKick animation

    kick.animation = animation
    @kicks.push kick
    kick.on()

  onKick: (a) ->
    selector = a.selector
    freq = a.freq
    return =>
      current_freq = undefined
      if typeof freq is 'number'
        current_freq = @d.getFrequency freq
      else
        current_freq = @d.getFrequency freq...

      # console.log "kick ON for selector #{selector}, at freq #{current_freq}"

  offKick: (a) ->
    selector = a.selector
    freq = a.freq
    return =>
      current_freq = undefined
      if typeof freq is 'number'
        current_freq = @d.getFrequency freq
      else
        current_freq = @d.getFrequency freq...

      # console.log "kick OFF for selector #{selector}, at freq #{current_freq}"

  setupControls: (controls) ->
    # toggling play / pause
    if controls.play_btn is controls.pause_btn
      $("a[href='#{controls.play_btn}']").click (e) =>
        e.preventDefault()
        if @isPlaying() then @pause() else @play()
    else
      # play button
      $("a[href='#{controls.play_btn}']").click (e) =>
        e.preventDefault()
        @play()
      # pause button
      $("a[href='#{controls.pause_btn}']").click (e) =>
        e.preventDefault()
        @pause()

    # volume controls
    $("a[href='#{controls.volume_up}']").click (e) =>
      e.preventDefault()
      @volumeUp()
    $("a[href='#{controls.volume_down}']").click (e) =>
      e.preventDefault()
      @volumeDown()


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
      # ampl: [0, 666] # min - max db
      ampl: 0.3
      decay: 0.02

      # href attrs for control buttons on the page
      play_btn: '#play'
      pause_btn: '#pause'
      volume_up: '#volume_up'
      volume_down: '#volume_down'


    }, opts

    # check if function was passed instead
    func = undefined
    func = opts if typeof opts is 'string'

    # call function if function is given and a bumpin instance exists
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
