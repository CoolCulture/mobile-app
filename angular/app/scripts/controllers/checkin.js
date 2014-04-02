'use strict';

angular.module('coolCultureApp')
  .controller('CheckinCtrl', function ($scope, $rootScope, $routeParams, CheckinService) {
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

    $scope.checkin = function() {
      $scope.errors = "";
      CheckinService.checkin($scope.checkinData).success(function(data) {
        // $rootScope.go('museums/checkinConfirmation');
      }).error(function() {
        $scope.errors = "Verify your Family Card Id and Last Name are correct.";
      });
    }

  });
