'use strict';

angular.module('mobileAppApp')
  .controller('MuseumCtrl', function($scope, Museumservice) {
    $scope.museums = Museumservice.requestMuseums();
  });
