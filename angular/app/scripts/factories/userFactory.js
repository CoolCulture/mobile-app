angular.module('coolCultureApp').
  factory('UserFactory', function ($http) {
    var service = { currentUser: {}, messages: {} };
    
    service.setUser = function(user) {
      service.currentUser = { loggedIn: true, user_id: user._id.$oid, admin: false };
    }

    service.removeCurrentUser = function() {
      service.currentUser = { loggedIn: false }
    }

    service.resetPassword = function(email) {
      $http.post('/api/users/password', { user: { email: email } });
    }

    return service;
  });