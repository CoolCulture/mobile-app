'use strict';

angular.module('coolCultureApp', [
  'ngAnimate',
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ui.bootstrap',
  'ngTouch'
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
      .when('/museums/checkin/:id', {
        templateUrl: 'views/checkin.html',
        controller: 'CheckinCtrl'
      })
      .when('/museums/checkinConfirmation/:id', {
        templateUrl: 'views/checkinConfirmation.html',
        controller: 'CheckinConfirmationCtrl'
      })
      .otherwise({
        redirectTo: '/museums'
      });
  });
