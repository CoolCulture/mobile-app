'use strict';

angular.module('coolCultureApp', [
  'ngAnimate',
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ui.bootstrap',
  'ngTouch',
  'jmdobry.angular-cache',
  'Devise'
])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
          templateUrl: 'views/welcome.html'
      })
      .when('/login', {
        templateUrl: 'views/login.html',
        controller: 'SessionCtrl'
      })
      .when('/profile', {
        templateUrl: 'views/profile.html',
        controller: 'ProfileCtrl'
      })
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
      .when('/admin/checkins', {
        templateUrl: 'views/admin/checkins.html',
        controller: 'AdminCheckinsCtrl'
      })
      .otherwise({
        redirectTo: '/museums'
      });
  })
    .run(function(){
      FastClick.attach(document.body);
    });
