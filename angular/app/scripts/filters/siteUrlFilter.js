'use strict';

angular.module('coolCultureApp')
  .filter('siteUrlFilter', function () {
    return function (input) {
      if (input.indexOf('http://') == -1) {
        return 'http://'.concat(input);
      } else {
        return input;
      }
    };
  });
