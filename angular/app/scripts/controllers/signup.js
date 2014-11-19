'use strict';

angular.module('coolCultureApp').
  controller('SignupCtrl', function ($scope, Auth, $location, Users) {
    $scope.signup = {};

    Auth.currentUser().then(function(user){
      $location.path('/profile');
    });

    $scope.doSignup = function() {
      console.log($scope.signup);
      Users.save({user: $scope.signup}, function () {
        Auth.currentUser().then(function(user){
             $location.path('/profile');
           });
      }, function (response) {
        $scope.errors = response.data;
      });
    };

  });