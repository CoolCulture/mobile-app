'use strict';

angular.module('coolCultureApp').
  config(function(AuthProvider) {
    AuthProvider.ignoreAuth(true);
    AuthProvider.loginPath('/api/users/sign_in.json');
    AuthProvider.logoutPath('/api/users/sign_out.json');
  }).
  controller('SessionCtrl', function ($scope, $rootScope, Auth, UserFactory, FamilyCards) {    
    $rootScope.loading = true;

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
      UserFactory.setUser(user);
      
      $scope.user = UserFactory.currentUser;

      FamilyCards.get( {id: $scope.user.user_id}, function(data){
        if(data.family_card) { $scope.lastName = data.family_card.last_name; }
      });
    }, function(error) {
      // if there's no user on the page when you arrive, that's cool.
    });

    $rootScope.loading = false;

    $scope.login = function() {
      $scope.errors = ''
      
      Auth.login($scope.sessionData).then(function(user) {
        UserFactory.setUser(user);
        $scope.user = UserFactory.currentUser;

        FamilyCards.get( {id: UserFactory.currentUser.user_id}, function(data){
          if(data.family_card) { $scope.lastName = data.family_card.last_name; }
        });
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