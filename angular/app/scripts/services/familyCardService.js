'use strict';

angular.module('coolCultureApp')
  .service('FamilyCardService', function FamilyCardService($resource) {
    return $resource('/api/family_cards/:id', {},
      { get: { method: "GET", cache: true },
        withCheckins: { method: "GET", params: { checkins: true }, cache: true }});
  });