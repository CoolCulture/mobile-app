'use strict';

angular.module('coolCultureApp')
  .controller('CheckinConfirmationCtrl', function ($scope, $routeParams, CheckinService) {
    $scope.checkin = {
      museum_name_id: $routeParams.id,
      family_card_id: $routeParams.family_card_id
    }

    $scope.checkinTicket = {
      museumId: $routeParams.id,
      familyCardId: $routeParams.family_card_id,
      lastName: '',
      date: '',
      groupNumber: 0
    }

    CheckinService.getCheckin($scope.checkin).success(function(data) {
      $scope.checkinTicket.lastName = data.last_name;
      $scope.checkinTicket.groupNumber = data.number_of_adults + data.number_of_children;
      var date = new Date(data.date);
      $scope.checkinTicket.date = date.toDateString()
    });


  });
