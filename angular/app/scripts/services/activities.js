'use strict';

angular.module('coolCultureApp')
  .service('Activities', function Activities($resource) {
    var activities = $resource('/api/activities.json', {}, 
                      {upcoming: {method: 'GET', isArray: true, url: '/api/activities/upcoming.json'},
                       featured: {method: 'GET', url: '/api/activities/featured.json'}});
    
    function dateToParam(date) {
     return date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
    };

    function upcoming(start, end) {
      return activities.upcoming({start_date: dateToParam(start), end_date: end ? dateToParam(end) : null});
    };

    function featured() {
      return activities.featured();
    };

    return {upcoming: upcoming, featured: featured};
  });
