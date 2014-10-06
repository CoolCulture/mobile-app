'use strict';

angular.module('coolCultureApp')
  .controller('ProfileCtrl', function ($scope, $rootScope, $window, Auth, FamilyCardService) {
    Auth.currentUser().then(function(user) {
      $scope.loggedIn = true;
      FamilyCardService.requestFamilyCard(user._id.$oid).success(function(data){
        if(data.family_card) {
          $scope.familyCard = data.family_card;
        }
      });

      FamilyCardService.requestCheckins(user._id.$oid).success(function(data){
        console.log(data.checkins);
        $scope.checkins = data.checkins;
      });
    });


    $scope.logout = function() {
      Auth.logout().then(function(oldUser) { console.log('logged out'); });
    };

    $scope.$on('devise:logout', function(event, oldCurrentUser) {
      $rootScope.go('/museums');
    });

    $window.scrollTo(0,0);
  });
