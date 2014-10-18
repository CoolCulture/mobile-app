'use strict';

angular.module('coolCultureApp')
  .controller('CheckinCtrl', function ($scope, $rootScope, $routeParams, $window, Checkins, FamilyCards, UserFactory, Auth) {
    $scope.options = [1, 2, 3, 4, 5]
    $scope.checkinData = {
      museumId: $routeParams.id,
      familyCardId: '',
      lastName: '',
      checkin: {
        numberOfChildren: 0,
        numberOfAdults: 0
      }
    }

    Auth.currentUser().then(function(user){
      UserFactory.setUser(user);
      
      $scope.user = UserFactory.currentUser;

      FamilyCards.get( {id: $scope.user.user_id}, function(data){
        if(data.family_card) {
          $scope.checkinData.lastName = data.family_card.last_name;
          $scope.checkinData.familyCardId = data.family_card.pass_id
        }
      });
    }, function(error) {
      // if there's no user on the page when you arrive, that's cool.
    });

    $scope.enableCheckin = function() {
      return $scope.checkinData.checkin.numberOfAdults < 1 || $scope.checkinData.checkin.numberOfChildren < 1
    }

    $scope.checkin = function() {
      $scope.errors = "";
      Checkins.save($scope.checkinData, function(checkin) {
        var path = 'museums/checkinConfirmation/' + checkin.slug;
        $rootScope.go(path);
        
      }, function(response) {
        if (response.data.limit) {
          $scope.errors = response.data.limit[0];
        } else {
          $scope.errors = "Verify your Family Card Id and Last Name are correct.";
        };
      });
    }

    $window.scrollTo(0,0);
  });
