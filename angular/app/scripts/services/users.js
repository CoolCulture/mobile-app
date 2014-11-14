'use strict';

angular.module('coolCultureApp')
  .service('Users', function Users($resource) {
    return $resource('/api/users.json');
  });
