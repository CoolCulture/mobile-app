'use strict';

angular.module('coolCultureApp')
  .service('Activities', function Activities($resource) {
    var activities = $resource('/api/activities.json', {}, {upcoming: {method: 'GET', isArray: true, url: '/api/activities/upcoming.json'}});
    
    function dateToParam(date) {
     return date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
    };

    function upcoming(start, end) {
      return activities.upcoming({start_date: dateToParam(start), end_date: end ? dateToParam(end) : null});
    }

    return {upcoming: upcoming};
  });
