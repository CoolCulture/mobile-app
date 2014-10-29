angular.module('coolCultureApp').
  factory('UserFactory', function ($http) {
    var service = { };

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