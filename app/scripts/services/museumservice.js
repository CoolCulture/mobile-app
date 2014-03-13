'use strict';

angular.module('mobileAppApp')
  .service('Museumservice', function Museumservice() {
    var museum = [ {name: 'Museum of Modern Art',
                            address: '400 Fake Street',
                            phoneNumber: '555-555-5555',
                            hours: '9-5 M-F, 9-9 Sat and Sun',
                            imageUrl: '/images/sample_museum.jpg'},
                            {name: 'Museum of Old Art',
                            address: '20 Fake Street',
                            phoneNumber: '115-523-5555',
                            hours: '9-5 M-F, 9-8 Sat and Sun',
                            imageUrl: '/images/sample_museum.jpg'},
                            {name: 'Museum of Science',
                            address: '1 New Street',
                            phoneNumber: '555-244-5535',
                            hours: '9-5 M-T, 9-1 Sat and Sun',
                            imageUrl: '/images/sample_museum.jpg'}
                            ];
    return  {
      requestMuseums : function() {
            return museum;
          }
    };
  });
