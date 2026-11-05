// n8n Code node: "Split Reply"
// Mode: Run Once for All Items
// Place it between "Claude Write Reply" and "Email Settings".
// Input: the model's text. Output: { subject, body }.

const raw = String($input.first().json.text ?? $input.first().json.output ?? '').trim();

// Remove code fences if the model adds them anyway
const cleaned = raw.replace(/^```[a-zA-Z]*\s*/, '').replace(/```\s*$/, '').trim();

const subjectMatch = cleaned.match(/^SUBJECT:\s*(.+)$/im);
const bodyMatch = cleaned.match(/^BODY:\s*([\s\S]*)$/im);

const subject = subjectMatch ? subjectMatch[1].trim() : '';
const body = bodyMatch ? bodyMatch[1].trim() : cleaned;

if (!body) {
  throw new Error('Reply model returned an empty body');
}

return [{ json: { subject, body } }];
