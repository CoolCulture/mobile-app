'use strict';

angular.module('coolCultureApp')
  .controller('MuseumListCtrl', function($scope, $modal, MuseumService) {
    $scope.museums = {};

    MuseumService.requestAllMuseums().then(function(data){
        $scope.museums = data;
    });

    $scope.museumFilters = {
    	category: '',
    	borough: ''
    };

    $scope.resetFilters = function() {
		$scope.museumFilters.category = '';
		$scope.museumFilters.borough = '';
    };

    $scope.openFilterModal = function() {
    	$modal.open({
    		templateUrl: 'filters.html',
	    	controller: ['$scope', '$modalInstance', 'museumFilters', function ($scope, $modalInstance, museumFilters) {
	    		$scope.museumFilters = museumFilters;
	    		$scope.ok = function () {
	    			$modalInstance.close();
	    		};
	    		$scope.cancel = function() {
	    			$scope.museumFilters.borough = '';
	    			$scope.museumFilters.category = '';
	    			$modalInstance.close();
	    		};
	    	}],
	    	resolve: {
	    		museumFilters: function () {
	    			return $scope.museumFilters;
	    		}
	    	}
    	});
    };

  });
