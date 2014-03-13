'use strict';

angular.module('mobileAppApp')
  .controller('MuseumDetailCtrl', function ($scope, $routeParams, MuseumService) {
    $scope.museum = MuseumService.requestMuseum($routeParams.id);
  });
