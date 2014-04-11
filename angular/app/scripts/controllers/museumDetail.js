'use strict';

angular.module('coolCultureApp')
  .controller('MuseumDetailCtrl', function ($scope, $routeParams, $window, MuseumService) {
    MuseumService.requestMuseum($routeParams.id).success(function(data){
      $scope.museum = data;
    });

    $window.scrollTo(0,0);
  });
