# P1 test data

- `leads.json` holds 30 fake property enquiries across 12 countries; all names, `example.com` emails and phone numbers are invented.
- Phone rule: official fictional ranges where they exist (US/Canada 555-0100 to 0199, UK 07700 900000 to 900999, Australia 0491 570 006 to 159); other countries use their country code plus an obviously fake pattern (`000 0000` or `555 0000`).
- Each lead has `input` (what arrives: source, name, email, phone, message) and `expected` (what P1 should produce).
- 27 messages are in English and 3 are in German, Dutch and Arabic, to check that P1 replies in the lead's own language.
- It includes 3 duplicates (same email as an earlier lead), 2 spam messages and 2 leads with a missing email (`is_valid: false`).
- `budget` is the number the lead stated, per the period they used (month, week or year); `score` is an accepted range, not one exact value.
