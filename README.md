\# P1 Property Lead Responder



P1 Property Lead Responder: replies to property enquiries within minutes, qualifies leads, follows up and alerts the agent.







\## Problem

Property agents often reply to enquiries hours after they arrive. Late replies lose leads to competitors, and staff spend time sorting spam, repeat enquiries and incomplete forms by hand.





\## Diagram

Website form or webhook

&#x20;       |

&#x20;       v

Normalise the data (name, email, phone, message)

&#x20;       |

&#x20;       v

Valid lead?

&#x20; - No  --> Result Invalid (logged in the API response, no reply)

&#x20; - Yes --> Claude Qualify (language, buy or rent, area, budget, timeline, urgency, spam check)

&#x20;               |

&#x20;               v

&#x20;           Is spam?

&#x20;             - Yes --> Log to the Log sheet --> Result Spam (no reply)

&#x20;             - No  --> Look up the email in the Leads sheet

&#x20;                           |

&#x20;                           v

&#x20;                       Merge with existing lead (keep the new details, keep old values if new ones are empty)

&#x20;                           |

&#x20;                           +--> Save to CRM (Leads sheet: add or update)

&#x20;                           +--> Log the enquiry (Log sheet)

&#x20;                           |

&#x20;                           v

&#x20;                       Claude Write Reply (plain text: SUBJECT and BODY)

&#x20;                           |

&#x20;                           v

&#x20;                       Split Reply (subject and body)

&#x20;                           |

&#x20;                           v

&#x20;                       Email Settings

&#x20;                           |

&#x20;                           v

&#x20;                       Is new lead?

&#x20;                         - Yes --> Send Reply (email to the lead)

&#x20;                         - No  --> no reply (repeat enquiry)





\## Setup steps

1\. Import the n8n workflow from the project folder, using the exported JSON file.

2\. Connect the credentials: Anthropic API key, Google Sheets, Gmail, and the webhook header secret named P1 Webhook Secret.

3\. Point the Google Sheets nodes at the CRM sheet with Leads and Log tabs, and test on a copy before the live sheet.





\## Cost per month

Example volume: 100 enquiries per month.

Model: Claude Haiku 5.5 at $0.10 per million input tokens and $0.50 per million output tokens (prompts up to 100K tokens).

Per lead: about 1,700 input and 900 output tokens for the reply, plus about 1,200 input and 150 output tokens for qualification (estimates from test runs).

Cost per lead: about $0.0008.

Cost per month at 100 leads: about $0.08. At 1,000 leads: about $0.80.





\## How it handles failure

Invalid leads (missing name, message or a valid email) get a result with is\_valid false and no reply. Spam is logged to the Log sheet and gets no reply. Repeat enquiries update the existing lead and get no second reply. If a reply step fails, the webhook returns an error and the run shows red in n8n Executions.





\## Known limitations

Client country is not captured yet. Reply quality depends on the model, so each reply should be checked during the first weeks. Duplicate replies were tested with 30 sample leads only.





