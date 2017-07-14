// Defining requirements
var gulp = require('gulp');
var sass = require('gulp-sass');
var watch = require('gulp-watch');

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
    .pipe(gulp.dest('assets'))
    .pipe(browserSync.stream());
});

gulp.task('scripts', function() {
  gulp.src(jsFiles)
    .pipe(concat('all.js'))
    .pipe(gulp.dest('assets'))
    .pipe(browserSync.stream());
});

gulp.task('default', ['css', 'scripts']);
