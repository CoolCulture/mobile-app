'use strict';

angular.module('coolCultureApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ngAnimate'
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
