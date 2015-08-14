(function() {
  var Bumpin;

  Bumpin = (function() {
    function Bumpin(settings) {
      this.autoplay = settings.autoplay;
      this.loop = settings.loop;
      this.time = 0;
      this.d = new Dancer();
      this.d.bind('update', (function(_this) {
        return function() {
          return _this.update();
        };
      })(this));
      this.d.bind('loaded', (function(_this) {
        return function() {
          if (_this.autoplay) {
            return _this.play();
          }
        };
      })(this));
      this.kicks = [];
      this.addKick(settings);
      this.setupControls(settings);
      this.loadAudio(settings.audio_src, settings.codecs);
      return this;
    }

    Bumpin.prototype.update = function() {
      var current_time;
      current_time = this.d.getTime();
      if (this.time === current_time && this.time !== 0) {
        if (this.loop) {
          this.pause();
          this.play();
        }
      }
      return this.time = current_time;
    };

    Bumpin.prototype.play = function() {
      return this.d.play();
    };

    Bumpin.prototype.pause = function() {
      return this.d.pause();
    };

    Bumpin.prototype.setVolume = function(val) {
      return this.d.setVolume(val);
    };

    Bumpin.prototype.getVolume = function() {
      return this.d.getVolume();
    };

    Bumpin.prototype.volumeUp = function() {
      return this.setVolume(this.getVolume() + .2 < 3 ? this.getVolume() + .2 : 2);
    };

    Bumpin.prototype.volumeDown = function() {
      return this.setVolume(this.getVolume() - .2 > 0 ? this.getVolume() - .2 : 0);
    };

    Bumpin.prototype.isPlaying = function() {
      return this.d.isPlaying();
    };

    Bumpin.prototype.isLoaded = function() {
      return this.d.isLoaded();
    };

    Bumpin.prototype.getTime = function() {
      return this.d.getTime();
    };

    Bumpin.prototype.loadAudio = function(audio_src, codecs) {
      var a;
      if (codecs) {
        return this.d.load({
          src: audio_src,
          codecs: codecs
        });
      } else if (typeof audio_src === 'object') {
        return this.d.load(audio_src);
      } else {
        a = new Audio();
        a.crossOrigin = 'Anonymous';
        a.src = audio_src;
        return this.d.load(a);
      }
    };

    Bumpin.prototype.addKick = function(settings) {
      var animation_data, kick;
      animation_data = {
        selector: settings.selector,
        speed: settings.speed,
        scale: settings.scale,
        freq: settings.freq,
        ampl: settings.ampl,
        threshold: settings.ampl,
        is_animating: false,
        id: Object.keys(this.kicks).length,
        onKick: settings.onKick
      };
      kick = this.d.createKick({
        frequency: animation_data.freq,
        threshold: animation_data.threshold,
        decay: animation_data.decay,
        onKick: this.onKick(animation_data),
        offKick: this.offKick(animation_data)
      });
      kick.id = Object.keys(this.kicks).length;
      kick.animation_data = animation_data;
      this.kicks["" + kick.id] = kick;
      return kick.on();
    };

    Bumpin.prototype.onKick = function(a) {
      var freq, selector;
      selector = a.selector;
      freq = a.freq;
      return (function(_this) {
        return function() {
          var $elm, anim, anim_data, current_freq, kick, other_opts, range, ref, scale;
          kick = _this.kicks["" + a.id];
          $elm = $(kick.animation_data.selector);
          current_freq = void 0;
          if (typeof freq === 'number') {
            current_freq = _this.d.getFrequency(freq);
          } else {
            current_freq = (ref = _this.d).getFrequency.apply(ref, freq);
          }
          if (kick && !kick.is_animating) {
            anim = {};
            anim_data = kick.animation_data;
            scale = void 0;
            if (typeof anim_data.scale === 'number') {
              scale = anim_data.scale;
            } else {
              range = anim_data.scale[1] - anim_data.scale[0];
              scale = anim_data.scale[0] + (current_freq / freq * range);
            }
            anim.scaleX = scale;
            anim.scaleY = scale;
            other_opts = {
              begin: function() {
                return _this.kicks["" + a.id].is_animating = true;
              },
              duration: scale / a.speed / 2
            };
            $elm.velocity(anim, other_opts);
            setTimeout(function() {
              var reverse_anim, reverse_other_opts;
              reverse_anim = {};
              reverse_anim.scaleX = 1;
              reverse_anim.scaleY = 1;
              reverse_other_opts = {
                complete: function() {
                  return _this.kicks["" + a.id].is_animating = false;
                },
                duration: scale / a.speed / 2
              };
              return $elm.velocity(reverse_anim, reverse_other_opts);
            }, other_opts.duration);
            return kick.animation_data.onKick(kick);
          }
        };
      })(this);
    };

    Bumpin.prototype.offKick = function(a) {
      var freq, selector;
      selector = a.selector;
      freq = a.freq;
      return (function(_this) {
        return function() {
          var current_freq, ref;
          current_freq = void 0;
          if (typeof freq === 'number') {
            return current_freq = _this.d.getFrequency(freq);
          } else {
            return current_freq = (ref = _this.d).getFrequency.apply(ref, freq);
          }
        };
      })(this);
    };

    Bumpin.prototype.setupControls = function(controls) {
      if (controls.play_btn === controls.pause_btn) {
        $("a[href='" + controls.play_btn + "']").click((function(_this) {
          return function(e) {
            e.preventDefault();
            if (_this.isPlaying()) {
              return _this.pause();
            } else {
              return _this.play();
            }
          };
        })(this));
      } else {
        $("a[href='" + controls.play_btn + "']").click((function(_this) {
          return function(e) {
            e.preventDefault();
            return _this.play();
          };
        })(this));
        $("a[href='" + controls.pause_btn + "']").click((function(_this) {
          return function(e) {
            e.preventDefault();
            return _this.pause();
          };
        })(this));
      }
      $("a[href='" + controls.volume_up + "']").click((function(_this) {
        return function(e) {
          e.preventDefault();
          return _this.volumeUp();
        };
      })(this));
      return $("a[href='" + controls.volume_down + "']").click((function(_this) {
        return function(e) {
          e.preventDefault();
          return _this.volumeDown();
        };
      })(this));
    };

    return Bumpin;

  })();

  $.fn.bumpin = function(opts) {
    var bumpin, func, settings;
    bumpin = window.bumpin_instance ? window.bumpin_instance : void 0;
    settings = $.extend({
      autoplay: false,
      loop: false,
      selector: this.selector,
      speed: 200,
      scale: [1, 1.5],
      freq: [.2, 1],
      ampl: 0.3,
      decay: 0.02,
      onKick: function() {},
      play_btn: '#play',
      pause_btn: '#pause',
      volume_up: '#volume_up',
      volume_down: '#volume_down'
    }, opts);
    func = void 0;
    if (typeof opts === 'string') {
      func = opts;
    }
    if (func && bumpin) {
      bumpin[func]();
    }
    if (this.selector && bumpin) {
      bumpin.addKick(settings);
    }
    if (!bumpin) {
      window.bumpin_instance = bumpin = new Bumpin(settings);
    }
    window.bumpin_instance = bumpin;
    return this;
  };

}).call(this);
