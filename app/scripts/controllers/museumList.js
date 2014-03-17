'use strict';

angular.module('coolCultureApp')
  .controller('MuseumListCtrl', function($scope, MuseumService) {
    $scope.museums = MuseumService.requestAllMuseums();
    $scope.museumFilters = {
    	category: "",
    	borough: "",
    	subwayLine: ""
    }
  });
