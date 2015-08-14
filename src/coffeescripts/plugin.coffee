$ = require 'jquery'
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
    @addKick settings

    # setup controls
    @setupControls settings

    # load in audio
    @loadAudio settings.audio_src, settings.codecs

    # return this
    return @

  update: ->
    current_time = @d.getTime()
    if @time is current_time and @time != 0
      if @loop
        @pause()
        @play()
    @time = current_time

  # control methods
  play: -> @d.play()
  pause: -> @d.pause()
  setVolume: (val) -> @d.setVolume val
  getVolume: -> @d.getVolume()
  volumeUp:   -> @setVolume( if @getVolume() + .2 < 3 then @getVolume() + .2 else 2 )
  volumeDown: -> @setVolume( if @getVolume() - .2 > 0 then @getVolume() - .2 else 0 )

  # destroy: (dont_stop_the_music) ->
  #   @d.pause() unless dont_stop_the_music
  #   window.bumpin_instance = undefined

  isPlaying: -> @d.isPlaying()
  isLoaded: -> @d.isLoaded()
  getTime: -> @d.getTime()

  loadAudio: (audio_src, codecs) ->
    if codecs
      @d.load { src: audio_src, codecs: codecs }
    else if typeof audio_src is 'object'
      @d.load audio_src
    else
      a = new Audio()
      a.crossOrigin = 'Anonymous'
      a.src = audio_src
      @d.load a


  addKick: (settings) ->
    animation_data =
      selector: settings.selector
      speed: settings.speed
      scale: settings.scale
      freq: settings.freq
      ampl: settings.ampl
      threshold: settings.ampl
      is_animating: false
      id: Object.keys(@kicks).length
      onKick: settings.onKick

    kick = @d.createKick
      frequency: animation_data.freq
      threshold: animation_data.threshold
      decay: animation_data.decay
      onKick: @onKick animation_data
      offKick: @offKick animation_data

    kick.id = Object.keys(@kicks).length
    kick.animation_data = animation_data
    @kicks["#{kick.id}"] = kick
    kick.on()

  onKick: (a) ->
    selector = a.selector
    freq = a.freq
    return =>
      # get the kick
      kick = @kicks["#{a.id}"]
      # select and animate
      $elm = $ kick.animation_data.selector

      # calculate amplitude of current frequency
      current_freq = undefined
      if typeof freq is 'number'
        current_freq = @d.getFrequency freq
      else
        current_freq = @d.getFrequency freq...

      # animate element
      if kick and !kick.is_animating

        # animation opts
        anim = {}
        anim_data = kick.animation_data
        scale = undefined
        if typeof anim_data.scale is 'number'
          scale = anim_data.scale
        else
          range = anim_data.scale[1] - anim_data.scale[0]
          scale = anim_data.scale[0] + (current_freq / freq * range)
        anim.scaleX = scale
        anim.scaleY = scale

        # other opts and callbacks
        other_opts =
          begin: () => @kicks["#{a.id}"].is_animating = true
          duration: scale / a.speed / 2

        # animate
        $elm.velocity anim, other_opts

        # reverse animation
        setTimeout () =>
          reverse_anim = {}
          reverse_anim.scaleX = 1
          reverse_anim.scaleY = 1
          reverse_other_opts =
            complete: => @kicks["#{a.id}"].is_animating = false
            duration: scale / a.speed / 2
          $elm.velocity reverse_anim, reverse_other_opts
        , other_opts.duration

        # callback
        kick.animation_data.onKick kick


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


$.fn.bumpin = (opts) ->
  # define current instance
  bumpin = if window.bumpin_instance then window.bumpin_instance else undefined

  # specify default options
  settings = $.extend {
    # play options
    autoplay: false
    loop: false

    # animation options
    selector: @selector
    speed: 200 # ms
    scale: [1, 1.5] # range or single value
    freq: [.2, 1] # min - max kHz
    ampl: 0.3
    decay: 0.02
    onKick: ->

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
  bumpin.addKick settings if @selector and bumpin

  # create first instance if bumpin does not exist
  unless bumpin
    window.bumpin_instance = bumpin = new Bumpin settings

  # update the instance on window
  window.bumpin_instance = bumpin

  # make the plugin chainable
  return @
