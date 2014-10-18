angular.module('coolCultureApp').
  factory('UserFactory', function ($http) {
    var service = { currentUser: {}, messages: {} };
    
    service.setUser = function(user) {
      service.currentUser = { loggedIn: true, user_id: user._id.$oid, admin: false };
    }

    service.removeCurrentUser = function() {
      service.currentUser = { loggedIn: false }
    }

    service.sendResetPassword = function(email) {
      $http.post('/api/users/password', { user: { email: email } });
    }

    service.resetPassword = function(token, password, password_confirmation) {
      $http.put('/api/users/password', { user: { reset_password_token: token, 
                                                 password: password, 
                                                 password_confirmation: password_confirmation }});
    }

    return service;
  });