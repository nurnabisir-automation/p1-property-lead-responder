# Property Enquiry Lead Responder (n8n + Claude)

## The problem
Property agencies often take hours to reply to enquiries from web forms. Slow replies lose leads, and staff spend time sorting spam and repeat messages.

## What I built
An n8n workflow receives each enquiry from a web form or webhook. It checks that the lead is valid, filters out spam, and checks the Google Sheet for a repeat enquiry. Claude writes a short reply with a subject and a body, in the lead's language. The lead is saved to a Google Sheet log, and Gmail sends the reply.

## How I tested it
I sent 30 sample enquiries through a PowerShell test script. The script compared each result with the expected answer: valid or not, spam or not, buy or rent, language, and score range.

## Results
- Intent classified correctly: 30 of 30
- Reply in the right language: 30 of 30
- Repeat enquiries: 23 emails for 23 unique people, with no duplicate replies
- Cost: about $0.0008 per lead, or about $0.08 per month at 100 leads

## What I learned
A plain-text reply with SUBJECT and BODY labels, parsed by a code node, worked more reliably than a structured output parser. Repeat leads need a check against the sheet, not a new reply each time.

## Limitations
The workflow has been tested with sample data only. It has not yet handled a live enquiry from a real agency, and the reply tone should be reviewed with a real client.
