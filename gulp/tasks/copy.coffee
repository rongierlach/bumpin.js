module.exports = (gulp, gutil, config) ->
  changed     = require "gulp-changed"
  handleErrors   = require "#{global.__gulp}/util/handleErrors"

  paths      = config.get 'paths'

  #copy fonts to dist
  gulp.task 'copy-fonts', ->
    src = "#{paths.src.fonts}/**/*"
    dest = paths.dist.fonts

    gulp.src src, {base: paths.src.fonts}
    .pipe changed(dest)
    .pipe gulp.dest(dest)

  #copy audio to dist
  gulp.task 'copy-audio', ->
    src = "#{paths.src.audio}/**/*"
    dest = paths.dist.audio
    
    gulp.src src, {base: paths.src.audio}
    .pipe changed(dest)
    .pipe gulp.dest(dest)

  # gulp.task 'copy-video'

  # copy all assets in copy task
  gulp.task 'copy', [ 'copy-fonts', 'copy-audio' ]
