#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
node --test
health_json="$(mktemp)"
drill_json="$(mktemp)"
policy_json="$(mktemp)"
status_json="$(mktemp)"
trap 'rm -f "$health_json" "$drill_json" "$policy_json" "$status_json"' EXIT
curl -fsS http://127.0.0.1:8080/api/health > "$health_json"
node -e 'const v=JSON.parse(require("fs").readFileSync(process.argv[1]));if(v.app!=="ready"||v.floci.iam!=="running"||v.floci.s3!=="running")process.exit(1);console.log(`Floci ${v.floci.version}: IAM and S3 running`)' "$health_json"
curl -fsS -X POST http://127.0.0.1:8080/api/labs/archive > "$drill_json"
node -e 'const v=JSON.parse(require("fs").readFileSync(process.argv[1]));if(v.probes.length!==2||v.probes.some(p=>!p.pass))process.exit(1);console.log(`Field drill passed: ${v.bucket}`)' "$drill_json"
curl -fsS -X POST -H 'content-type: application/json' --data-binary '{"bucket":"iam-forge-test","user":"iam-forge-tester","policy":"{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::iam-forge-test/*\"}]}"}' http://127.0.0.1:8080/api/policies/apply > "$policy_json"
node -e 'const v=JSON.parse(require("fs").readFileSync(process.argv[1]));const read=v.probes.find(p=>p.action==="s3:GetObject");const write=v.probes.find(p=>p.action==="s3:PutObject");if(read.decision!=="allowed"||write.decision!=="implicitDeny")process.exit(1);console.log(`Policy applied: ${v.policyName}`)' "$policy_json"
curl -fsS http://127.0.0.1:8080/api/assistant/status > "$status_json"
node -e 'const v=JSON.parse(require("fs").readFileSync(process.argv[1]));if(!v.providers.codex||!v.providers.claude||!v.providers.agy)process.exit(1);console.log("AI bridge provider configuration passed")' "$status_json"
curl -fsS http://127.0.0.1:8080/ | node -e 'let v="";process.stdin.on("data",d=>v+=d);process.stdin.on("end",()=>{if(!v.includes("<title>IAM Forge")||!v.includes("policy-editor"))process.exit(1);console.log("Interface delivery passed")})'
echo "All checks passed"
