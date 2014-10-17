'use strict';

angular.module('coolCultureApp')
  .controller('ProfileCtrl', function ($scope, $rootScope, $window, Auth, FamilyCards, UserFactory) {
    Auth.currentUser().then(function(user) {
      UserFactory.setUser(user);
      $scope.user = UserFactory.currentUser;

      FamilyCards.withCheckins({id: $scope.user.user_id}, function(data){
        if(data.family_card && data.checkins) {
          $scope.familyCard = data.family_card;
          $scope.checkins = data.checkins;
        }
      });
    }, function(error) {
      $rootScope.go('/login');
    });

    $scope.logout = function() {
      Auth.logout().then(function(oldUser) {
        UserFactory.removeCurrentUser();
        $scope.user = UserFactory.currentUser;
      });
    };

    $scope.$on('devise:logout', function(event, oldCurrentUser) {
      $rootScope.go('/login');
    });

    $window.scrollTo(0,0);
  });
