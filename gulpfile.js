// Defining requirements
const gulp = require('gulp');
const sass = require('gulp-sass');
const watch = require('gulp-watch');
const run = require('gulp-run');
const concat = require('gulp-concat');
const ngrok = require('ngrok');

const cssFiles = [
  'assets/_sass/**/*.?(s)css', 
  'assets/_sass/**/*.?(s)css'
];

const jsFiles = [
  'assets/js/main.js',
  './node_modules/\@gateway-interactive/tailor-accordion/index.js',
  './node_modules/\@gateway-interactive/tailor-tabs/index.js',
  './node_modules/jquery-modal/jquery.modal.js'
];

gulp.task('css', () => {
  gulp.src(cssFiles)
    .pipe(sass())
    .pipe(concat('main.css'))
    .pipe(gulp.dest('assets'));
});

gulp.task('scripts', function() {
  gulp.src(jsFiles)
    .pipe(concat('all.js'))
    .pipe(gulp.dest('assets'));
});

gulp.task('rackup', function() {
  return run('rackup').exec();
});

gulp.task('ngrok', function() {
  ngrok.connect({
    proto: 'http',
    addr: 9292,
  }, function (err, url) {});
});

gulp.task('default', ['css', 'scripts', 'rackup', 'ngrok']);
