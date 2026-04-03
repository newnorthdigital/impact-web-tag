___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.

___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Impact",
  "categories": ["AFFILIATE_MARKETING", "CONVERSIONS"],
  "brand": {
    "id": "brand_dummy",
    "displayName": "New North Digital",
    "thumbnail": ""
  },
  "description": "Impact.com partnership tracking. Universal Tracking Tag, visitor identification, and conversion tracking.",
  "containerContexts": ["WEB"]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "actionType",
    "displayName": "Action type",
    "macrosInSelect": false,
    "selectItems": [
      {"value": "utt", "displayValue": "Universal Tracking Tag (all pages)"},
      {"value": "identify", "displayValue": "Identify visitor"},
      {"value": "conversion", "displayValue": "Track conversion"}
    ],
    "simpleValueType": true,
    "help": "UTT loads the tracking script on all pages. Identify passes visitor data for cross-device attribution. Track conversion fires on the order confirmation page."
  },
  {
    "type": "TEXT",
    "name": "accountUuid",
    "displayName": "Account UUID",
    "simpleValueType": true,
    "help": "Your Impact.com account UUID (found in Settings \u003e Tracking). Format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "alwaysInSummary": true,
    "valueValidators": [{"type": "NON_EMPTY"}],
    "enablingConditions": [{"paramName": "actionType", "paramValue": "utt", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "customerId",
    "displayName": "Customer ID (optional)",
    "simpleValueType": true,
    "help": "Your platform customer account ID.",
    "enablingConditions": [
      {"paramName": "actionType", "paramValue": "identify", "type": "EQUALS"},
      {"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}
    ]
  },
  {
    "type": "TEXT",
    "name": "customerEmail",
    "displayName": "Customer Email (optional)",
    "simpleValueType": true,
    "help": "Customer email (preferably SHA1 hashed) for attribution.",
    "enablingConditions": [
      {"paramName": "actionType", "paramValue": "identify", "type": "EQUALS"},
      {"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}
    ]
  },
  {
    "type": "TEXT",
    "name": "customProfileId",
    "displayName": "Custom Profile ID (optional)",
    "simpleValueType": true,
    "help": "A non-PII visitor identifier (UUID or first-party cookie value) for cross-device attribution.",
    "enablingConditions": [
      {"paramName": "actionType", "paramValue": "identify", "type": "EQUALS"},
      {"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}
    ]
  },
  {
    "type": "TEXT",
    "name": "actionTrackerId",
    "displayName": "Action Tracker ID",
    "simpleValueType": true,
    "help": "The numeric Event Type ID from Impact.com (Settings \u003e Tracking \u003e Event Types).",
    "valueValidators": [{"type": "NON_EMPTY"}],
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "orderId",
    "displayName": "Order ID",
    "simpleValueType": true,
    "help": "Unique order/transaction ID.",
    "valueValidators": [{"type": "NON_EMPTY"}],
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "currencyCode",
    "displayName": "Currency",
    "simpleValueType": true,
    "defaultValue": "EUR",
    "help": "ISO 4217 currency code (EUR, USD, GBP, etc.).",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "SELECT",
    "name": "customerStatus",
    "displayName": "Customer Status",
    "macrosInSelect": true,
    "selectItems": [
      {"value": "", "displayValue": "Not set"},
      {"value": "New", "displayValue": "New"},
      {"value": "Returning", "displayValue": "Returning"}
    ],
    "simpleValueType": true,
    "defaultValue": "",
    "help": "Whether this is a new or returning customer.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "orderPromoCode",
    "displayName": "Promo Code (optional)",
    "simpleValueType": true,
    "help": "Coupon or promo code used in the order.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "orderDiscount",
    "displayName": "Order Discount (optional)",
    "simpleValueType": true,
    "help": "Discount amount subtracted from the order subtotal.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "items",
    "displayName": "Items",
    "simpleValueType": true,
    "help": "A GTM variable returning an array of item objects. Each object needs: subTotal, category, sku, quantity. Optional: name.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "GROUP",
    "name": "debugging",
    "displayName": "Debugging",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {"type": "CHECKBOX", "name": "debug", "checkboxText": "Log debug messages to console", "simpleValueType": true}
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var log = require('logToConsole');
var injectScript = require('injectScript');
var createArgumentsQueue = require('createArgumentsQueue');
var callInWindow = require('callInWindow');
var copyFromWindow = require('copyFromWindow');
var makeString = require('makeString');
var makeNumber = require('makeNumber');
var makeInteger = require('makeInteger');
var getType = require('getType');

var enableDebug = data.debug;
var debugLog = function(msg) {
  if (enableDebug) log('Impact GTM - ' + msg);
};

var actionType = data.actionType;

if (actionType === 'utt') {
  var accountUuid = makeString(data.accountUuid);
  var scriptUrl = 'https://utt.impactcdn.com/' + accountUuid + '.js';

  // Create the ire command queue
  var ire = createArgumentsQueue('ire', 'ire.a');

  debugLog('Loading UTT for account: ' + accountUuid);

  injectScript(scriptUrl, function() {
    debugLog('UTT script loaded');
    data.gtmOnSuccess();
  }, function() {
    debugLog('UTT script failed to load');
    data.gtmOnFailure();
  }, 'impact-utt');

} else if (actionType === 'identify') {
  var identifyData = {};
  if (data.customerId) identifyData.customerId = makeString(data.customerId);
  if (data.customerEmail) identifyData.customerEmail = makeString(data.customerEmail);
  if (data.customProfileId) identifyData.customProfileId = makeString(data.customProfileId);

  debugLog('Identifying visitor');

  // Call ire identify - UTT must already be loaded
  var ire = copyFromWindow('ire');
  if (ire) {
    callInWindow('ire', 'identify', identifyData);
    debugLog('Identify call sent');
  } else {
    debugLog('Warning: ire function not found - ensure UTT tag fires first');
  }

  data.gtmOnSuccess();

} else if (actionType === 'conversion') {
  var actionTrackerId = makeInteger(data.actionTrackerId);

  var conversionData = {
    orderId: makeString(data.orderId),
    currencyCode: makeString(data.currencyCode || 'EUR')
  };

  if (data.customerId) conversionData.customerId = makeString(data.customerId);
  if (data.customerEmail) conversionData.customerEmail = makeString(data.customerEmail);
  if (data.customProfileId) conversionData.customProfileId = makeString(data.customProfileId);
  if (data.customerStatus) conversionData.customerStatus = makeString(data.customerStatus);
  if (data.orderPromoCode) conversionData.orderPromoCode = makeString(data.orderPromoCode);
  if (data.orderDiscount) conversionData.orderDiscount = makeNumber(data.orderDiscount);

  if (data.items && getType(data.items) === 'array') {
    conversionData.items = data.items;
  }

  debugLog('Tracking conversion: ' + conversionData.orderId);

  var ire = copyFromWindow('ire');
  if (ire) {
    callInWindow('ire', 'trackConversion', actionTrackerId, conversionData, {verifySiteDefinitionMatch: true});
    debugLog('Conversion tracked');
  } else {
    debugLog('Warning: ire function not found - ensure UTT tag fires first');
  }

  data.gtmOnSuccess();

} else {
  debugLog('Unknown action type');
  data.gtmOnFailure();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "vpiVersion": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://utt.impactcdn.com/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "vpiVersion": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ire"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ire.a"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ire_o"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "vpiVersion": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: "UTT script loads successfully"
  code: |-
    var mockData = {
      actionType: 'utt',
      accountUuid: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
      debug: false
    };

    mock('injectScript', function(url, success, failure, token) {
      success();
    });

    mock('createArgumentsQueue', function(fnName, arrayPath) {
      return function() {};
    });

    runCode(mockData);
    assertApi('gtmOnSuccess').wasCalled();
- name: "Identify sends visitor data"
  code: |-
    var mockData = {
      actionType: 'identify',
      customerId: 'CUST-1',
      customerEmail: 'hashed@email',
      customProfileId: 'profile-uuid',
      debug: false
    };

    mock('copyFromWindow', function(key) {
      return function() {};
    });

    mock('callInWindow', function() {});

    runCode(mockData);
    assertApi('gtmOnSuccess').wasCalled();
- name: "Conversion tracking with order data"
  code: |-
    var mockData = {
      actionType: 'conversion',
      actionTrackerId: '12345',
      orderId: 'ORDER-123',
      currencyCode: 'EUR',
      customerId: 'CUST-1',
      customerEmail: 'sha1hash',
      customerStatus: 'New',
      orderPromoCode: 'PROMO10',
      orderDiscount: '15.00',
      debug: false
    };

    mock('copyFromWindow', function(key) {
      return function() {};
    });

    mock('callInWindow', function() {});

    runCode(mockData);
    assertApi('gtmOnSuccess').wasCalled();
- name: "Conversion with items array"
  code: |-
    var mockData = {
      actionType: 'conversion',
      actionTrackerId: '12345',
      orderId: 'ORDER-456',
      currencyCode: 'USD',
      items: [
        {subTotal: 28.00, category: 'Shoes', sku: 'SKU-1', quantity: 2, name: 'Running Shoe'}
      ],
      debug: true
    };

    mock('copyFromWindow', function(key) {
      return function() {};
    });

    mock('callInWindow', function() {});

    runCode(mockData);
    assertApi('gtmOnSuccess').wasCalled();
- name: "UTT script failure calls gtmOnFailure"
  code: |-
    var mockData = {
      actionType: 'utt',
      accountUuid: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
      debug: false
    };

    mock('injectScript', function(url, success, failure, token) {
      failure();
    });

    mock('createArgumentsQueue', function(fnName, arrayPath) {
      return function() {};
    });

    runCode(mockData);
    assertApi('gtmOnFailure').wasCalled();


___NOTES___

Created on 4/1/2026, by New North Digital.
