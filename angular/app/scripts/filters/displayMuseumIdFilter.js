'use strict';

angular.module('coolCultureApp')
  .filter('displayMuseumIdFilter', function () {
    return function (input) {
      if (input) {
        return input.split('-').join(' ').toUpperCase();
      }
    };
  });
