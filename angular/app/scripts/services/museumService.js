'use strict';

angular.module('coolCultureApp')
  .service('MuseumService', function MuseumService($http, $angularCacheFactory) {
    var museumCache = $angularCacheFactory('museumCache', {
      maxAge: 900000,
        cacheFlushInterval: 6000000,
        deleteOnExpire: 'aggressive'
    });

    return  {
      requestAllMuseums : function() {
          var request = $http.get('/api/museums.json', { cache: museumCache }).success(function(response) {
              return response.data;
            });
          return request;
          },
      requestMuseum : function(id) {
            var request = $http.get('/api/museums/'+ id+ '.json', { cache: museumCache }).success(function(response) {
              return response.data;
            });
          return request;
          }
    };
  });
