'use strict';

angular.module('coolCultureApp')
  .service('Museums', function Museums($resource) {
    return $resource('/api/museums/:id', {},
      {get: { method: "GET", cache: true},
       list: { method: "GET", cache: true, isArray: true}});
  });
