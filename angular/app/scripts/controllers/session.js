'use strict';

angular.module('coolCultureApp').
  config(function(AuthProvider) {
    AuthProvider.ignoreAuth(true);
    AuthProvider.loginPath('/api/users/sign_in.json');
    AuthProvider.logoutPath('/api/users/sign_out.json');
  }).
  controller('SessionCtrl', function ($scope, $location, Auth, UserFactory, FamilyCards) {
    $scope.sessionData = {
      email: '',
      password: '',
      remember_me: true
    };

    $scope.passwordResetData = {
      showIt: false,
      email: ''
    };

    Auth.currentUser().then(function(user){
      $location.path('/profile');
    });

    $scope.login = function() {
      $scope.errors = ''
      
      Auth.login($scope.sessionData).then(function(user) {

        FamilyCards.get( {id: user.user_id}, function(data){
          if(data.family_card) { $scope.lastName = data.family_card.last_name; }
        });
        $location.path('/profile');
      }, function(error) {
        $scope.errors = "Something went wrong. Please try logging in again."
      });
    };

    $scope.resetPassword = function() {
      var email = $scope.passwordResetData.email;
      UserFactory.sendResetPassword(email);
      $scope.passwordResetData.email = '';
      $scope.passwordResetData.showIt = false;
      $scope.errors = '';
      $scope.passwordResetData.message = 'An email was sent to ' + email + '. Please check your inbox.';
    }
  });