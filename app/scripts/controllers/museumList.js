'use strict';

angular.module('mobileAppApp')
  .controller('MuseumListCtrl', function($scope, MuseumService) {
    $scope.museums = MuseumService.requestAllMuseums();
  });
