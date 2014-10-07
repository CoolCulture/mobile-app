'use strict';

angular.module('coolCultureApp')
  .controller('CheckinConfirmationCtrl', function ($scope, $routeParams, Checkins) {
    $scope.checkinTicket = Checkins.get({id: $routeParams.id});
  });
