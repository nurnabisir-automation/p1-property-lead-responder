# P1 test runner: sends the 30 test leads to the live webhook and compares Claude's answers with the expected ones.
$dir    = '.	est-data'
$url    = 'https://YOUR-N8N-INSTANCE.app.n8n.cloud/webhook/p1-lead-intake-test'
$secret = $env:P1_WEBHOOK_SECRET  # set this in your session; never commit the value
$leads  = Get-Content "$dir\leads.json" -Raw -Encoding UTF8 | ConvertFrom-Json

$results = foreach ($t in $leads) {
    $body = @{
        'Full name'   = [string]$t.input.name
        'Email'       = [string]$t.input.email
        'Phone'       = [string]$t.input.phone
        'Buy or rent' = ''
        'Message'     = [string]$t.input.message
    } | ConvertTo-Json
    $err = ''
    try {
        $r = Invoke-RestMethod -Method Post -Uri $url -Headers @{ 'X-Lead-Secret' = $secret } -ContentType 'application/json; charset=utf-8' -Body ([Text.Encoding]::UTF8.GetBytes($body))
    } catch { $r = $null; $err = $_.Exception.Message }

    $e     = $t.expected
    # Spam replies have is_valid = true but no score, so accept either
    $valid = ($r -ne $null) -and (("$($r.is_valid)".ToLower() -eq 'true') -or ($r.PSObject.Properties.Name -contains 'score'))
    $spam  = $valid -and ("$($r.is_spam)".ToLower() -eq 'true')
    if (-not $e.is_valid) { $intentOk = -not $valid }
    elseif ($e.is_spam)   { $intentOk = $spam }
    else                  { $intentOk = $valid -and ("$($r.buy_or_rent)".ToLower() -eq $e.buy_or_rent) }

    $scoreOk = ''
    if ($valid) {
        $lo, $hi = $e.score -split '-'
        $scoreOk = ([int]$r.score -ge [int]$lo) -and ([int]$r.score -le [int]$hi)
    }

    [pscustomobject]@{
        id = $t.id; name = $t.input.name
        expected_valid = $e.is_valid;       actual_valid = $valid
        expected_intent = $e.buy_or_rent;   actual_intent = $r.buy_or_rent
        expected_spam = $e.is_spam;         actual_spam = $spam
        expected_language = $e.language;    actual_language = $r.language
        expected_score = $e.score;          actual_score = $r.score
        intent_ok = $intentOk; score_ok = $scoreOk
        language_ok = (-not $valid) -or $e.is_spam -or ($r.language -eq $e.language)
        error = $err
    }
    Write-Host ("{0}  intent {1}" -f $t.id, $(if ($intentOk) { 'PASS' } else { 'FAIL' }))
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmm'
$out   = "$dir\results-$stamp.csv"
$results | Export-Csv $out -NoTypeInformation -Encoding UTF8
"Intent correct: $(@($results | Where-Object intent_ok).Count) / $($results.Count)  (target 27)"
"Score in range: $(@($results | Where-Object { $_.score_ok -eq $true }).Count)"
"Language correct: $(@($results | Where-Object language_ok).Count) / $($results.Count)"
"Saved: $out"