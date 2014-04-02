'use strict';

angular.module('coolCultureApp')
  .controller('CheckinCtrl', function ($scope, $routeParams, CheckinService) {
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
      CheckinService.checkin($scope.checkinData);
    }

  });
