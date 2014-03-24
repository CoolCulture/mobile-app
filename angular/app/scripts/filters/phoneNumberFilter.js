'use strict';

angular.module('coolCultureApp')
  .filter('phoneNumberFilter', function () {
    return function (input) {
      return input.split('-').join('').split('(').join('').split(')').join('');
    };
  });
