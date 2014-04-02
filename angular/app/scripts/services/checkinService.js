'use strict';

angular.module('coolCultureApp')
  .service('CheckinService', function CheckinService($http) {
    return  {
      checkin : function(data) {
          var request = $http.post('/api/checkin', data).success(function(response) {
              return response.data;
            });
          return request;
          }
    };
  });
