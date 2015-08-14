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

    src = ["#{paths.dist.js}/bumpin.js", "#{paths.dist.js}/bumpin.min.js"]
    dest = "#{paths.bin}"

    gulp.src src
    .pipe gulp.dest(dest)
    .on 'error', handleErrors
