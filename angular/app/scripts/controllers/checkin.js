'use strict';

angular.module('coolCultureApp')
  .controller('CheckinCtrl', function ($scope, $rootScope, $routeParams, $window, CheckinService) {
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

    $scope.enableCheckin = function() {
      return $scope.checkinData.checkin.number_of_adults < 1 || $scope.checkinData.checkin.number_of_children < 1
    }

    $scope.checkin = function() {
      $scope.errors = "";
      CheckinService.checkin($scope.checkinData).success(function(data) {
        var path = 'museums/checkinConfirmation/' + $scope.checkinData.museum_id + '?family_card_id=' + $scope.checkinData.family_card_id;
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
