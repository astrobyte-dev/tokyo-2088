# Payment decision — not activated

Official sources checked 11 September 2026. **Recommend Garmin-native monetization** for the first release if the owner accepts the annual fee: it keeps purchase/restore in Garmin's account flow and avoids adding a payment library, unlock screen or service to this face. Australia is explicitly eligible for merchant onboarding; that does not establish this owner's approval. At low sales volume, the annual fee can outweigh its lower transaction percentage.

## Verified terms and limits

| Topic | Garmin native | KiezelPay alternative |
| --- | --- | --- |
| Australian seller | Australia explicitly listed; individual/sole proprietor and organization onboarding supported. Identity, address, tax and entity checks apply. [Merchant onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/) | **Not verified.** Public FAQ does not establish Australian seller eligibility. Obtain provider confirmation and applicable merchant terms; buyer access or an Australian PayPal account is insufficient proof. |
| Up-front / annual | Non-refundable **US$100 annually**; merchant approval required. [Onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/) | No startup charge stated. [FAQ](https://api.kiezelpay.com/faq/) |
| Transaction | **15% of tax-exclusive price**, card processing included; applicable digital-service taxes and currency conversion may reduce proceeds. [App sales](https://developer.garmin.com/connect-iq/monetization/app-sales/) | **27%, minimum US$0.27**; card payments add US$0.30, charged to buyer or absorbed by seller. [FAQ](https://api.kiezelpay.com/faq/) |
| Payout | Monthly on the 1st, US$10 threshold, separate Garmin entities by market; last-five-days sales roll forward. Banking setup is documented; exact Australian bank rail, settlement currency and bank/FX costs remain account-specific/unverified. [Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/), [account management](https://developer.garmin.com/connect-iq/monetization/account-management/) | Verified PayPal account only; last Thursday monthly. Australian settlement/FX/tax details require confirmation. [FAQ](https://api.kiezelpay.com/faq/) |
| Buyers / devices | Australia is listed independently as a buyer country. Requires a supported device and current phone apps/checkout. The primary fenix 8 Solar 51mm and proposed follow-up devices are on the paid-app list; this is separate from rendering tests. [Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/) | PayPal/cards; a Garmin library is offered. Exact supported device/API, buyer-country and currency constraints require library/onboarding review before promising availability. [FAQ](https://api.kiezelpay.com/faq/) |
| Purchase / restore | Garmin checkout then sync; a purchase can be downloaded to compatible devices on the same Garmin account. [Garmin purchase help](https://support.garmin.com/fr-FR/?faq=tAsPhqUXOo2L3guHjLpJa7) | On-watch code entered on payment site; restore with a new code and original purchase email. Reinstallation may require unlocking again. No integration exists here. [FAQ](https://api.kiezelpay.com/faq/) |
| Published refund process | Request through Connect IQ purchase history within **48 hours**. [Garmin purchase help](https://support.garmin.com/fr-FR/?faq=tAsPhqUXOo2L3guHjLpJa7) | Provider helpdesk handles refunds within **30 days**; developers cannot refund directly. [FAQ](https://api.kiezelpay.com/faq/) |

Those published refund windows describe platform processes; final consumer terms must also account for applicable statutory rights. No legal or merchant agreement has been accepted in this work.

## Price proposal

Garmin's **US$2.50 base tier maps to A$3.99** in the published local-price table. The Australian displayed amount includes local taxes; do not estimate proceeds by simply taking 85% of A$3.99. Confirm the live merchant price selector before activation. [Official price points](https://developer.garmin.com/connect-iq/monetization/price-points/)

For scale only, at a US$2.50 tax-exclusive transaction the percentage-fee difference is US$0.30 (US$2.125 versus US$1.825 before other adjustments). Roughly 334 such sales offset a US$100 annual fee. This is an illustration, not a forecast: tax, currency, card surcharge, refunds, thresholds and support costs change the comparison.

## Privacy and implementation consequences

The current code has no payment integration or outbound network service. Native paid distribution can keep checkout/account payment data within Garmin's flow; this face does not need to receive card details. The owner must review Garmin's merchant obligations and configure accurate listing/support/privacy information. [Developer agreement](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)

KiezelPay would introduce a third-party licensing/purchase flow and require a separately reviewed library integration. Its published policy permits collection of personal/contact details and device/usage information, including location-related information, for several service, fraud-prevention and other purposes. That broad policy does **not** establish the precise payload of its Garmin library. Confirm the library's permissions, transmissions, retention, processors and deletion process before revising this project's privacy statement. [Provider privacy policy](https://s3.amazonaws.com/kiezelpay/agreements/Privacy-Policy.pdf)

## Owner/account gates

- Choose the route and final one-time price. All palettes/customization remain in one product.
- For Garmin: authorize annual fees separately, complete private identity/tax/banking checks, review current agreements and confirm approval, settlement details and live pricing.
- For KiezelPay: first confirm Australian seller eligibility, merchant terms and library/device behavior; then separately authorize integration and payment activation.
- Confirm buyer purchase, restore and refund instructions on an authorized test/release path before publication. No buyer checkout, account creation, payment, enrollment or activation was attempted.

Public Garmin article content was read from its official pages and public article HTML where client rendering obscured the body. Authenticated merchant screens and the upload form were not accessible for verification; account-specific details remain explicitly pending.
