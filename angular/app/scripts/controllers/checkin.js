'use strict';

angular.module('coolCultureApp')
  .controller('CheckinCtrl', function ($scope, $rootScope, $routeParams, $window, Checkins) {
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
