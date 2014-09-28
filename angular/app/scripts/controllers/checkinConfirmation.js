'use strict';

angular.module('coolCultureApp')
  .controller('CheckinConfirmationCtrl', function ($scope, $routeParams, CheckinService) {
    $scope.checkinTicket = {};

    CheckinService.getCheckin($routeParams.id).success(function(data) {
      $scope.checkinTicket.lastName = data.last_name;
      $scope.checkinTicket.familyCardId = data.family_card_id;
      $scope.checkinTicket.groupNumber = data.number_of_adults + data.number_of_children;
      var date = new Date(data.date);
      $scope.checkinTicket.date = date.toDateString()
    });


  });
