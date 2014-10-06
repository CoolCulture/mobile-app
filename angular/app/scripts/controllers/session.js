'use strict';

angular.module('coolCultureApp').
  config(function(AuthProvider) {
    AuthProvider.loginPath('/api/users/sign_in.json');
    AuthProvider.logoutPath('/api/users/sign_out.json');
  }).
  controller('SessionCtrl', function ($scope, $rootScope, Auth, FamilyCardService) {
    $scope.returnFamilyCard = function () { 
      $scope.loggedIn = false;
      Auth.currentUser().then(function(user) {
        $scope.loggedIn = true;
        FamilyCardService.requestFamilyCard(user._id.$oid).success(function(data){
          var family_card = data.family_card;
          if(family_card) {
            $scope.lastName = family_card.last_name;
          }
        });
      });
    }

    $scope.returnFamilyCard();

    $scope.sessionData = {
      email: '',
      password: '',
      remember_me: true
    };

    $scope.login = function() {
      Auth.login($scope.sessionData).then(function(user) {
        $scope.returnFamilyCard();
      });
      if(!$scope.loggedIn) { $scope.errors = "Something went wrong. Please try logging in again." }
    };
    
    $scope.$on('devise:login', function(event, currentUser) {
      // nothing for now
    });

    $scope.$on('devise:new-session', function(event, currentUser) {
      // nothing for now
    });
  });