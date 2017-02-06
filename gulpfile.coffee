gulp        = require('gulp')
coffee      = require('gulp-coffee')
replace     = require('gulp-replace')
fs          = require('fs')
analyticsJS = fs.readFileSync('./vendor/analytics.min.js').toString('UTF-8')

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  gulp.src('source/google-analytics-embedded.coffee')
    .pipe replace(/[ ]+\/\* analytics\.js \*\//m, analyticsJS)
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
