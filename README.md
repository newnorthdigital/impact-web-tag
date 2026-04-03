# Impact.com Partnership Tracking - GTM Web Tag Template

Google Tag Manager web tag template for [Impact.com](https://impact.com) partnership tracking. Supports the Universal Tracking Tag (UTT), visitor identification, and conversion tracking.

## Features

- **Universal Tracking Tag** - Loads the Impact.com tracking script on all pages
- **Identify visitor** - Passes customer data for cross-device attribution
- **Track conversion** - Records order data on the confirmation page with line-item detail
- Debug logging toggle for troubleshooting

## Installation

### From the Community Template Gallery

1. In your GTM container, go to **Templates** > **Search Gallery**
2. Search for **Impact**
3. Click **Add to workspace**

### Manual import

1. Download `template.tpl` from this repository
2. In GTM, go to **Templates** > **New**
3. Click the three-dot menu > **Import**
4. Select the downloaded file

## Setup Guide

You need **three tags** for a complete Impact.com integration:

### Tag 1: Universal Tracking Tag (all pages)

| Setting | Value |
|---------|-------|
| Action type | Universal Tracking Tag (all pages) |
| Account UUID | Your Impact.com UUID from Settings > Tracking |
| Trigger | All Pages |

### Tag 2: Identify visitor (all pages, after UTT)

| Setting | Value |
|---------|-------|
| Action type | Identify visitor |
| Customer ID | `{{Customer ID}}` variable (optional) |
| Customer Email | `{{Customer Email SHA1}}` variable (optional) |
| Custom Profile ID | `{{Custom Profile ID}}` variable (optional) |
| Trigger | All Pages (with tag sequencing: fire after UTT tag) |

### Tag 3: Track conversion (order confirmation)

| Setting | Value |
|---------|-------|
| Action type | Track conversion |
| Action Tracker ID | Your numeric Event Type ID from Impact.com |
| Order ID | `{{Order ID}}` variable |
| Currency | EUR (or your store currency) |
| Customer Status | New / Returning |
| Items | `{{Impact Items}}` variable returning an array |
| Trigger | Order Confirmation page trigger |

Use **tag sequencing** on both the Identify and Conversion tags to ensure the UTT tag fires first.

## Items Array Format

The Items field expects a GTM variable that returns an array of objects:

```javascript
[
  {
    subTotal: 28.00,
    category: "Shoes",
    sku: "SKU-001",
    quantity: 2,
    name: "Running Shoe"
  },
  {
    subTotal: 45.00,
    category: "Apparel",
    sku: "SKU-002",
    quantity: 1,
    name: "Jacket"
  }
]
```

## Field Reference

| Field | Action Types | Required | Description |
|-------|-------------|----------|-------------|
| Action type | All | Yes | UTT, Identify, or Conversion |
| Account UUID | UTT | Yes | Impact.com account UUID |
| Customer ID | Identify, Conversion | No | Platform customer ID |
| Customer Email | Identify, Conversion | No | Email (preferably SHA1 hashed) |
| Custom Profile ID | Identify, Conversion | No | Non-PII visitor identifier |
| Action Tracker ID | Conversion | Yes | Numeric Event Type ID |
| Order ID | Conversion | Yes | Unique transaction ID |
| Currency | Conversion | No | ISO 4217 code (default: EUR) |
| Customer Status | Conversion | No | New or Returning |
| Promo Code | Conversion | No | Coupon code used |
| Order Discount | Conversion | No | Discount amount |
| Items | Conversion | No | Array of line-item objects |
| Debug | All | No | Log messages to browser console |

## Permissions

This template requests the following permissions:

- **Inject Script** - Loads `https://utt.impactcdn.com/*`
- **Access Globals** - Reads/writes/executes the `ire` function and related globals (`ire.a`, `ire_o`)
- **Logging** - Console logging in debug mode

## Resources

- [Impact.com JavaScript UTT Tracking Integration](https://integrations.impact.com/impact-brand/docs/javascript-utt-tracking-integration)
- [Impact.com Help Center](https://help.impact.com)

## Author

Built by [New North Digital](https://newnorth.digital?utm_source=github&utm_medium=gtm-template&utm_campaign=impact-web-tag).

## License

Apache 2.0 - see [LICENSE](LICENSE).
