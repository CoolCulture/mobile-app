'use strict';

angular.module('coolCultureApp')
  .service('FamilyCardService', function FamilyCardService($http, $angularCacheFactory) {
    var familyCardCache = $angularCacheFactory('familyCardCache', {
      maxAge: 1,
        cacheFlushInterval: 1,
        deleteOnExpire: 'aggressive'
    });

    return  {
      requestFamilyCard : function(user_id) {
        var request = $http.get('/api/family_cards/'+user_id+'.json', { cache: familyCardCache }).success(function(response) {
            return response;
          });
        return request;
        },
      requestCheckins : function(user_id) {
        var request = $http.get('/api/family_cards/'+user_id+'.json?checkins=true', { cache: familyCardCache }).success(function(response) {
            return response;
          });
        return request;
        }
    };
  });
