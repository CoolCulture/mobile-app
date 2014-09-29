'use strict';

angular.module('coolCultureApp')
  .controller('MuseumDetailCtrl', function ($scope, $rootScope, $routeParams, $window, Museums) {
    $rootScope.loading = true;

    Museums.get({id: $routeParams.id}, function(museum){
      $scope.museum = museum;

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
