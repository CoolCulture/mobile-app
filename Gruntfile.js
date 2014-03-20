module.exports = function(grunt) {
  'use strict';

  grunt.loadNpmTasks('grunt-hub');

  grunt.initConfig({
    hub: {
      all: {
        src: ['angular/Gruntfile.js'],
        tasks: ['heroku'],
      },
    },
  });

  grunt.registerTask('heroku', ['hub']);
};
