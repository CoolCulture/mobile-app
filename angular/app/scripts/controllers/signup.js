'use strict';

angular.module('coolCultureApp').
  controller('SignupCtrl', function ($scope, Auth, $location) {
    $scope.signup = {}

    Auth.currentUser().then(function(user){
      $location.path('/profile');
    });

    $scope.signup = function() {
    
    };

  });