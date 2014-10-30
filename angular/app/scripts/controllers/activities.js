'use strict';

angular.module('coolCultureApp')
  .controller('ActivitiesCtrl', function ($scope, $filter, Activities) {
    $scope.date = $filter('date')(new Date(), 'dd-MMMM-yyyy');

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

    function daysAfter(date, days) {
      var newDate = new Date(date);
      newDate.setDate(date.getDate()+days)
      return newDate;
    }

    $scope.$watch('date', function(newValue, oldValue) {
      $scope.activitiesByDay = Activities.upcoming(new Date(newValue));
    });

 });
