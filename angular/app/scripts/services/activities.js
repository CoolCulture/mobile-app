'use strict';

angular.module('coolCultureApp')
  .service('Activities', function Activities($resource) {
    var activities = $resource('/api/activities.json', {}, {upcoming: {method: 'GET', isArray: true, url: '/api/activities/upcoming.json'}});
    
    function dateToParam(date) {
     return date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
    };

    function upcoming(date) {
      return activities.upcoming({date: dateToParam(date)});
    }

    return {upcoming: upcoming};
  });
