'use strict';

angular.module('coolCultureApp', [
  'ngAnimate',
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ui.bootstrap',
  'ngTouch',
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
      .when('/password_reset', {
        templateUrl: 'views/password_reset.html',
        controller: 'PasswordResetCtrl'
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
      .when('/activities', {
        templateUrl: 'views/activities.html',
        controller: 'ActivitiesCtrl'
      })
      .otherwise({
        redirectTo: '/museums'
      });
  })
    .run(function(){
      FastClick.attach(document.body);
    });
