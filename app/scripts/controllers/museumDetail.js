'use strict';

angular.module('coolCultureApp')
  .controller('MuseumDetailCtrl', function ($scope, $routeParams, MuseumService) {
    $scope.museum = MuseumService.requestMuseum($routeParams.id);
  });
