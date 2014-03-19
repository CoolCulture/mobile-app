'use strict';

angular.module('coolCultureApp')
  .service('MuseumService', function MuseumService($http) {
    return  {
      requestAllMuseums : function() {
          var request = $http.get('museums.json').then(function(response) {
              return response.data;
            });
          return request;
          },
      requestMuseum : function(id) {
            var request = $http.get('museums.json').then(function(response) {
              return response.data[id - 1];
            });
          return request;
          }
    };
  });