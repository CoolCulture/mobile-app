'use strict';

angular.module('coolCultureApp').
  config(function(AuthProvider) {
    AuthProvider.loginPath('/api/users/sign_in.json');
    AuthProvider.logoutPath('/api/users/sign_out.json');
  }).
  controller('SessionCtrl', function ($scope, $rootScope, Auth) {
    $scope.sessionData = {
      email: '',
      password: '',
      remember_me: true
    };

    $scope.login = function() {
      Auth.login($scope.sessionData).then(function(user) { console.log(user._id.$oid); });
    };
    
    $scope.$on('devise:login', function(event, currentUser) {
      // nothing for right now
    });

    $scope.$on('devise:new-session', function(event, currentUser) {
      $rootScope.go('/museums');
    });

    $scope.logout = function() {
      Auth.logout().then(function(oldUser) { console.log(oldUser); });
    };

    $scope.$on('devise:logout', function(event, oldCurrentUser) {
      $rootScope.go('/museums');
    });
  });