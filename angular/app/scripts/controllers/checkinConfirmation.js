'use strict';

angular.module('coolCultureApp')
  .controller('CheckinConfirmationCtrl', function ($scope, $routeParams, Checkins, Museums) {
    $scope.twitterUrl = function(museumTitle) {
      return "https://twitter.com/home?status=Visiting%20The%20" + museumTitle + "%20thanks%20to%20@coolculture!";
    }

    $scope.setTwitter = function (twitter, museumName) {      
      if(twitter && museumName) {
        return $scope.twitterUrl(encodeURIComponent(twitter));
      } else {
        return $scope.twitterUrl(encodeURIComponent(museumName));
      }
    }

    $scope.setFacebook = function (facebook) {
      var facebookBase = "https://www.facebook.com/sharer/sharer.php?u=https://www.facebook.com/";
      if(facebook) {
        return facebookBase + facebook;
      } else {
        return facebookBase + "CoolCulture";
      }
    }

    $scope.checkinTicket = Checkins.get({id: $routeParams.id}, function(checkinTicket) {
      $scope.twitterUrl = $scope.setTwitter(checkinTicket.museum.twitter, checkinTicket.museum.name);
      $scope.facebookUrl = $scope.setFacebook(checkinTicket.museum.facebook);
    });
  });
