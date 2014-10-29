'use strict';

angular.module('coolCultureApp')
  .controller('ProfileCtrl', function ($scope, $location, $window, Auth, FamilyCards) {
    Auth.currentUser().then(function(user) {
      $scope.user = user;

      FamilyCards.withCheckins({id: $scope.user.family_card_id}, function(data){
        if(data.family_card && data.checkins) {
          $scope.familyCard = data.family_card;
          $scope.checkins = data.checkins;
        }
      });
    }, function(error) {
      $location.path('/login');
    });

    $scope.logout = function() {
      Auth.logout().then(function(oldUser) {
        $location.path('/museums');
      });
    };
  });
