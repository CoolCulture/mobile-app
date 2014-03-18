'use strict';

angular.module('coolCultureApp')
  .controller('MuseumDetailCtrl', function ($scope, $routeParams, MuseumService) {
    MuseumService.requestMuseum($routeParams.id).then(function(data){
      $scope.museum = data;
    });
  });
