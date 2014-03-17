'use strict';

angular.module('coolCultureApp')
  .service('MuseumService', function MuseumService() {
    var museums = [ {id: '1',
                      name: 'Museum of Modern Art',
                      address: '400 Fake Street',
                      phoneNumber: '555-555-5555',
                      hours: '9-5 M-F, 9-9 Sat and Sun',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Brooklyn',
                      subwayLine: 'M',
                      category: 'Science'},
                      {id: '2',
                      name: 'Museum of Old Art',
                      address: '20 Fake Street',
                      phoneNumber: '115-523-5555',
                      hours: '9-5 M-F, 9-8 Sat and Sun',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Manhattan',
                      subwayLine: 'Q',
                      category: 'Art'},
                      {id: '3',
                      name: 'Museum of Science',
                      address: '1 New Street',
                      phoneNumber: '555-244-5535',
                      hours: '9-5 M-T, 9-1 Sat and Sun',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Queens',
                      subwayLine: 'P',
                      category: 'History'},
                      {id: '4',
                      name: 'Museum of Science',
                      address: '1 New Street',
                      phoneNumber: '555-244-5535',
                      hours: '9-5 M-T, 9-1 Sat and Sun',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Brooklyn',
                      subwayLine: 'P',
                      category: 'Science'},
                      {id: '5',
                      name: 'Museum of Science',
                      address: '1 New Street',
                      phoneNumber: '555-244-5535',
                      hours: '9-5 M-T, 9-1 Sat and Sun',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Manhattan',
                      subwayLine: 'N',
                      category: 'Art'},
                      {id: '6',
                      name: 'Museum of Science',
                      address: '1 New Street',
                      phoneNumber: '555-244-5535',
                      hours: '9-5 M-T, 9-1 Sat and Sun',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Brooklyn',
                      subwayLine: 'M',
                      category: 'Science'}
                      ];
    return  {
      requestAllMuseums : function() {
            return museums;
          },
      requestMuseum : function(id) {
            var requestedMuseum = {};
            museums.forEach(function(museum) {
                if(museum.id == id) {
                  requestedMuseum = museum;
                }
              });
            return requestedMuseum;
          }
    };
  });
