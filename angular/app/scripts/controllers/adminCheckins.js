'use strict';

angular.module('coolCultureApp')
  .controller('AdminCheckinsCtrl', function ($scope, Checkins) {
    $scope.checkins = Checkins.query();
 });
