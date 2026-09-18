# TOKYO 2088 privacy notice

Effective 12 September 2026. Publisher: Astrobyte. Support and privacy contact: thr3eoh@gmail.com.

## What the watch face uses

TOKYO 2088 reads your watch's local time/date, battery, steps, recent heart rate and Garmin-provided cached weather to draw its display. It reads custom identity text, a manually entered city label and display preferences through Garmin's application settings. Manual city entry does not request GPS or look up your location. Optional display readings are held in memory; this code does not write activity files or create a separate health/location history. Settings persist through Garmin's application-properties system until you change or remove them.

## Trial and purchase checks

This edition includes KiezelPay. Its watch-face library makes HTTPS requests to api.kiezelpay.com for trial status, purchase codes and licence checks. The reviewed request contains the product ID, a licensing token, Garmin platform and device part number, test/trial flags, a timestamp and a library-version identifier. The licensing token uses Garmin's available uniqueIdentifier value; the fallback is an existing legacy token or a locally generated random value. This is an identifier, not a claim of anonymity.

The reviewed request does not include your custom text, city label, steps, heart-rate reading or weather. Neither the Tokyo code nor this library request asks for GPS coordinates. KiezelPay also receives ordinary connection information associated with an internet request, such as the connecting IP address. This describes the app/library request fields, not all information processed by Garmin, checkout websites or payment providers.

KiezelPay configuration and licence state, including the token, trial/start and check times, purchase code and response status, are stored locally in the app's storage. They support activation and subsequent checks. Removing local app data is not a request to delete provider purchase records and may require purchase recovery. No automatic deletion period for provider records is established by the library.

## Checkout and support

Purchase takes place on KiezelPay's website and its payment services. Card/PayPal credentials are not entered into the watch face. KiezelPay uses the purchase email for its documented unlock/recovery process. Its [privacy policy](https://s3.amazonaws.com/kiezelpay/agreements/Privacy-Policy.pdf) and [support/FAQ](https://kiezelpay.com/faq/) describe its separate practices. That published policy does not specify a definite retention period or a complete deletion procedure; contact KiezelPay for requests about its records. Astrobyte cannot promise deletion of records controlled by another provider.

If you contact Astrobyte, your email address and message are handled through the support mailbox, including KiezelPay-forwarded messages. Messages remain in the mailbox unless removed; no automatic deletion schedule is represented here. Contact thr3eoh@gmail.com about access, correction or deletion of support information. Do not send payment credentials, personal watch text or raw health/location/device logs. Public GitHub issues are public.

Garmin operates the watch, settings sync and weather services under its own privacy practices. KiezelPay and its payment services operate checkout/licensing under theirs. These services are separate from the display-only readings described above. Avoid sensitive text in the visible identity plate; you can change it in settings.
