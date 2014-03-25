'use strict';

angular.module('coolCultureApp')
  .controller('MuseumDetailCtrl', function ($scope, $routeParams, MuseumService) {
    MuseumService.requestMuseum($routeParams.id).success(function(data){
      $scope.museum = data;
    });
  });
