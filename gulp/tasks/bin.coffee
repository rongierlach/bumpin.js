module.exports = (gulp, gutil, config) ->
  # put plugin scripts in bin folder
  gulp.task "bin", (cb) ->
    rename 			= require "gulp-rename"
    coffee      = require "gulp-coffee"
    uglify			= require "gulp-uglify"
    # gulpwebpack 	= require "gulp-webpack"
    # webpack       = require "webpack"
    bundleLogger 	= require "#{global.__gulp}/util/bundleLogger"
    handleErrors 	= require "#{global.__gulp}/util/handleErrors"

    paths				= config.get 'paths'
    js_config			= config.get 'js'

    src = "#{paths.src.coffee}/plugin.coffee"
    dest = "#{paths.bin}"

    gulp.src src
    .pipe coffee()
    .pipe rename("bumpin.js")
    .pipe gulp.dest(dest)
    .pipe rename({suffix: ".min"})
    .pipe gulp.dest(dest)
    .on 'error', handleErrors
