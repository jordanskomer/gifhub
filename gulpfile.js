// Defining requirements
const gulp = require('gulp');
const sass = require('gulp-sass');
const watch = require('gulp-watch');
const run = require('gulp-run');
const concat = require('gulp-concat');
const ngrok = require('ngrok');
const browserSync = require('browser-sync').create();

const cssFiles = [
  'app/assets/stylesheets/**/*.?(s)css'
];

const jsFiles = [
  'app/assets/js/main.js',
];

gulp.task('css', () => {
  gulp.src(cssFiles)
    .pipe(sass())
    .pipe(concat('main.css'))
    .pipe(gulp.dest('public/css'))
    .pipe(browserSync.stream());
});

gulp.task('scripts', function() {
  gulp.src(jsFiles)
    .pipe(concat('all.js'))
    .pipe(gulp.dest('public/js'))
    .pipe(browserSync.stream());
});

gulp.task('rackup', function() {
  return run('rackup').exec();
});

gulp.task('ngrok', function() {
  ngrok.connect({
    proto: 'http',
    addr: 9292,
  }, function (err, url) {
    console.log('-------------------------------------');
    console.log('NGROK URL: '+ url);
    console.log('-------------------------------------');

    gulp.start('bsync');
  });
});

gulp.task('bsync', function() {
  browserSync.init({
    files: ['app/assets/stylesheets/**/*.?(s)css', "*.rb"],
    proxy: "localhost:9292"
  });
});

gulp.task('serve', function() {
  gulp.start('rackup');
  gulp.start('ngrok');
  gulp.watch(cssFiles, ['css']);
  gulp.watch(jsFiles, ['scripts']);
});

gulp.task('default', ['css', 'scripts', 'serve']);
