'use strict';

angular.module('coolCultureApp')
  .controller('CheckinConfirmationCtrl', function ($scope, $routeParams) {
    $scope.museum_id = $routeParams.id;
    $scope.groupNumber = $routeParams.number;
  });
