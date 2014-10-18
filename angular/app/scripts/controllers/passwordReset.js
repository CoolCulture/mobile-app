'use strict';

angular.module('coolCultureApp')
  .controller('PasswordResetCtrl', function ($scope, $rootScope, $routeParams, UserFactory) {
    $scope.passData = {
      passwordResetToken: $routeParams.reset_password_token,
      password: '',
      passwordConfirmation: '',
      errors: ''
    };

    $scope.resetPassword = function() {
      var passwordValidity = ($scope.passData.password === $scope.passData.passwordConfirmation) &&
                             ($scope.passData.password.length >= 8)
      
      if(passwordValidity) {
        // there could still be an error here in that a passwordResetToken could be wrong.
        UserFactory.resetPassword($scope.passData.passwordResetToken,
                                  $scope.passData.password, 
                                  $scope.passData.passwordConfirmation);
        $rootScope.go('/login');
      } else {
        $scope.passData.password = '';
        $scope.passData.passwordConfirmation = '';
        $scope.passData.errors = 'Your password needs to be longer than 8 characters and both fields must match.';
      }
    }
  });
