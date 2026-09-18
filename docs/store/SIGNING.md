# Release signing decision

The owner now authorizes **one unpaid, owner-only developer beta upload**, conditional on verifying the live account and beta-only access. The **existing temporary Windows development key** is explicitly approved for this private beta. Public upload and permanent public-release key adoption remain unapproved.

Beta identity is stable: `ca80e764ffae413996a66e11abd76ed9`, name **TOKYO 2088 BETA**, in `manifest-beta.xml`. Production `manifest.xml` and UUID remain unchanged. Retain this same beta UUID and key for later beta updates; no second upload/update is performed under the initial one-upload authorization. Beta outputs stay under `build/windows/beta/`.

## Preserved hardware build

- Source: `d8a86d2332805272b6cf4f2d8fa11fb6436e4b37`.
- File: `build/windows/candidate/TOKYO2088-fenix8solar51mm-release.prg`.
- Size: **24,172 bytes**.
- SHA-256: `7e3c596c7f85eabd7fe535a3025d431e0d4e298726099b279a93363833dbd038`.
- Provenance: temporary Windows development RSA-4096 key, retained privately outside the repository and cloud-synced project. Exact local key and hardware archive paths are in private local records, not this public document.
- Controlled transfer and independent readback were recorded before positive initial owner feedback. There is **no verified original Linux-binary rollback backup** on this PC; the owner accepted the built-in-face fallback. Existing private settings/log backups and the tested release archive are retained.

The Store-prep package has different customer defaults and a different binary. It has not been installed on the physical watch. The production UUID remains `d8c8adfe21c74bdd97fa2088ac010001`; the beta has a separate identity as described above. The retained signing key was not replaced.

## Decision before the first public-release upload

| Option | Implication |
| --- | --- |
| Explicitly adopt the existing Windows development key | Technically usable if the owner deliberately approves permanent custody and recoverable private backups. Its temporary label alone does not weaken its cryptography. No such approval is inferred. |
| Generate a dedicated Store-release key after approval | Clear release custody from the first Store submission. Produces a newly signed package; existing unpublished sideload replacement/settings behavior must not be assumed. No key generated now. |
| Privately recover the old Linux key | Optional continuity with the first unpublished sideload. Its availability is unconfirmed and it is not required merely because it signed that sideload. Never request its contents in chat. |

Garmin requires RSA-4096 signing and the **same developer key for updates to an existing Store app**; uploads signed with a different key are rejected. Losing the established Store key prevents updates. This makes deliberate selection and backup a first-submission gate. [Garmin security/key documentation](https://developer.garmin.com/connect-iq/core-topics/security/)

Before public upload, record the owner-approved permanent key identity/provenance privately, verify a recoverable backup in a separately protected location, then export and record the exact source/package hashes. The private beta uses the already-approved retained development key. Keep both existing keys if available. Do not upload private keys, publish them in logs, copy them into this public repository, or silently promote the temporary key. Public keys included by Garmin in an IQ package are not private-key backups.

The export script requires an explicit provenance label and an existing external key path, and refuses to overwrite the hardware candidate. Its `OwnerApprovedPermanent` label records an already-made owner decision; selecting that label does not grant approval.
