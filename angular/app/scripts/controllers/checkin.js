'use strict';

angular.module('coolCultureApp')
  .controller('CheckinCtrl', function ($scope, $rootScope, $routeParams, $window, CheckinService, FamilyCardService, Auth) {
    $scope.options = [1, 2, 3, 4, 5]
    $scope.checkinData = {
      museum_id: $routeParams.id,
      family_card_id: '',
      last_name: '',
      checkin: {
        number_of_children: 0,
        number_of_adults: 0
      }
    }

    Auth.currentUser().then(function(user) {
      FamilyCardService.requestFamilyCard(user._id.$oid).success(function(data){
        var family_card = data.family_card;
        if(family_card) {
          $scope.checkinData.family_card_id = family_card.pass_id;
          $scope.checkinData.last_name = family_card.last_name;
        }
      });
    }, function(error) {
        // unauthenticated error
    });

    $scope.enableCheckin = function() {
      return $scope.checkinData.checkin.number_of_adults < 1 || $scope.checkinData.checkin.number_of_children < 1
    }

    $scope.checkin = function() {
      $scope.errors = "";
      CheckinService.checkin($scope.checkinData).success(function(data) {
        var path = 'museums/checkinConfirmation/' + data.slug;
        $rootScope.go(path);

      }).error(function(data) {
        if (data.limit) {
          $scope.errors = data.limit[0];
        } else {
          $scope.errors = "Verify your Family Card Id and Last Name are correct.";
        };
      });
    }

    $window.scrollTo(0,0);
  });
