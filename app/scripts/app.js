'use strict';

angular.module('mobileAppApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MuseumCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
