'use strict';

angular.module('coolCultureApp')
  .controller('CheckinConfirmationCtrl', function ($scope, $routeParams, Checkins, Museums) {
    $scope.twitterUrl = function(museumTitle) {
      return "https://twitter.com/home?status=Visiting%20The%20" + museumTitle + "%20thanks%20to%20@coolculture!";
    }

    $scope.setSocial = function (museum) {
      var facebookBase = "https://www.facebook.com/sharer/sharer.php?u=https://www.facebook.com/";
      if(museum && museum.facebook) {
        $scope.facebookUrl = facebookBase + museum.facebook;
      } else {
        $scope.facebookUrl = facebookBase + "CoolCulture";
      }
      
      if(museum && museum.twitter) {
        $scope.twitterUrl = $scope.twitterUrl(museum.twitter);
      } else {
        var name = museum.name.split(" ").join("%20");
        $scope.twitterUrl = $scope.twitterUrl(name);
      }
    }

    var museumId = $routeParams.id.split("+")[1].split(" ").join("-").toLowerCase();
    Museums.get({ id: museumId }, function(museum) {
      $scope.museum = museum;
      
      $scope.setSocial(museum);
    });

    $scope.checkinTicket = Checkins.get({id: $routeParams.id});
  });
