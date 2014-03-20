'use strict';

angular.module('coolCultureApp')
  .directive('subwayLines', function () {
    return {
      template:  '<span ng-repeat="line in lines" class="badge badge-{{line}}">{{line}}</span>',
      restrict: 'E',
      scope: {
        lines: '=lines'
      }
    };
  });
