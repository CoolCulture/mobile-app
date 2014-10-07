angular.module('coolCultureApp').
  factory('UserFactory', function () {
    var service = { currentUser: {} };
    
    service.setUser = function(user) {
      service.currentUser = { loggedIn: true, user_id: user._id.$oid, admin: false };
    }

    service.removeCurrentUser = function() {
      service.currentUser = { loggedIn: false }
    }

    return service;
  });