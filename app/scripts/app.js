'use strict';

angular.module('coolCultureApp', [
  'ui.bootstrap',
  'ngAnimate',
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/museums', {
        templateUrl: 'views/museumList.html',
        controller: 'MuseumListCtrl'
      })
      .when('/museums/:id', {
        templateUrl: 'views/museumDetail.html',
        controller: 'MuseumDetailCtrl'
      })
      .otherwise({
        redirectTo: '/museums'
      });
  });
