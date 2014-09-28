'use strict';

angular.module('coolCultureApp')
  .service('CheckinService', function CheckinService($http) {
    return  {
      checkin : function(data) {
          var request = $http.post('/api/checkins', data).success(function(response) {
            return response.data;
          });
          return request;
          },
      getCheckin : function(slug) {
        var request = $http.get('/api/checkins/' + slug).success(function(response){
          return response.data;
        });
          return request;
      }
    };
  });
