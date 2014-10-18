'use strict';

angular.module('coolCultureApp')
  .controller('MuseumDetailCtrl', function ($scope, $rootScope, $routeParams, $window, Museums) {
    $rootScope.loading = true;

    $scope.formatActivityTime = function (activity) {
      if (activity.date == null)
        return null;
      var date = new Date(activity.date);
      var str = date.getUTCMonth()+1 + '/' + date.getUTCDate() + '/' + date.getUTCFullYear();
      if (activity.startTime) {
        str += ", " + activity.startTime;
        if (activity.endTime) {
          str += " - " + activity.endTime;
        }
      }
      return str;
    };

    $scope.museum = Museums.get({id: $routeParams.id}, function(museum){
      $rootScope.loading = false;

      (function () {
      var articleId = fyre.conv.load.makeArticleId($scope.museum.name);
      fyre.conv.load({}, [{
          el: 'livefyre-comments',
          network: "livefyre.com",
          siteId: "357315",
          articleId: articleId,
          signed: false,
          collectionMeta: {
              articleId: articleId,
              url: fyre.conv.load.makeCollectionUrl(),
          }
        }], function() {});
      }());

    });

    $window.scrollTo(0,0);

  });
