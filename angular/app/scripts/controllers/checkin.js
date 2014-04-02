'use strict';

angular.module('coolCultureApp')
  .controller('CheckinCtrl', function ($scope, $routeParams, CheckinService) {
    $scope.checkinData = {}

    // var checkin = function() {
    //   MuseumService.requestMuseum($routeParams.id).success(function(data){
    //     $scope.museum = data;
    //   });
    // }

  });
