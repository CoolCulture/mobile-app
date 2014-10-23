'use strict';

angular.module('coolCultureApp')
  .service('Checkins', function Checkins($resource) {
    return $resource('/api/checkins/:id.json');
  });
