module.exports = (gulp, gutil, config) ->
  # put plugin scripts in bin folder
  gulp.task "bin", (cb) ->
    rename 			= require "gulp-rename"
    changed     = require "gulp-changed"
    plumber     = require "gulp-plumber"
    uglify			= require "gulp-uglify"
    gulpwebpack 	= require "gulp-webpack"
    webpack       = require "webpack"
    bundleLogger 	= require "#{global.__gulp}/util/bundleLogger"
    handleErrors 	= require "#{global.__gulp}/util/handleErrors"

    paths				= config.get 'paths'
    js_config			= config.get 'js'

    src = "#{paths.dist.js}/bumpin.js"
    dest = "#{paths.bin}"

    gulp.src src
    .pipe changed(dest)
    .pipe plumber()
    .pipe rename('bumpin.js')
    .pipe gulp.dest(dest)
    .pipe uglify()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(dest)
    .on 'error', handleErrors
