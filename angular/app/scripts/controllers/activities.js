'use strict';

angular.module('coolCultureApp')
  .controller('ActivitiesCtrl', function ($scope, Activities) {
    $scope.date = new Date();
    $scope.format = 'dd-MMMM-yyyy';
    $scope.dateOptions = {
      formatYear: 'yyyy',
      startingDay: 1
    };

    $scope.formatActivityTime = function (activity) {
      if (activity.date == null)
        return null;
      var date = new Date(activity.date);
      var str = date.getUTCMonth()+1 + '/' + date.getUTCDate() + '/' + date.getUTCFullYear();
      if (activity.startTime) {
        str += ", " + activity.startTime;
        if (activity.endTime) {
          str += " - " + activity.endTime;
        }
      }
      return str;
    };

    $scope.open = function($event) {
      $event.preventDefault();
      $event.stopPropagation();

      $scope.opened = true;
    };

    $scope.$watch('date', function(newValue, oldValue) {
      $scope.activities = Activities.upcoming(newValue);
    });

 });
