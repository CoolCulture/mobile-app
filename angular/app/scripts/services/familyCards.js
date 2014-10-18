'use strict';

angular.module('coolCultureApp')
  .service('FamilyCards', function FamilyCards($resource) {
    return $resource('/api/family_cards/:id', {},
      { get: { method: "GET", cache: true },
        withCheckins: { method: "GET", params: { checkins: true }, cache: true }});
  });