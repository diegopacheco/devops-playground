import { createBucket, iam, putObject, xmlTag } from "./aws.js"
import { evaluate, policySummary, validatePolicy } from "./iam.js"

const labs = {
  archive: {
    title: "Read-only archive",
    policy: bucket => ({
      Version: "2012-10-17",
      Statement: [
        {
          Sid: "ListArchive",
          Effect: "Allow",
          Action: "s3:ListBucket",
          Resource: `arn:aws:s3:::${bucket}`
        },
        {
          Sid: "ReadArchive",
          Effect: "Allow",
          Action: "s3:GetObject",
          Resource: `arn:aws:s3:::${bucket}/*`
        }
      ]
    }),
    probes: bucket => [
      { action: "s3:GetObject", resource: `arn:aws:s3:::${bucket}/welcome.txt`, expected: "allowed" },
      { action: "s3:PutObject", resource: `arn:aws:s3:::${bucket}/new.txt`, expected: "implicitDeny" }
    ]
  },
  guardrail: {
    title: "Explicit deny guardrail",
    policy: bucket => ({
      Version: "2012-10-17",
      Statement: [
        {
          Sid: "WorkInBucket",
          Effect: "Allow",
          Action: "s3:*",
          Resource: [`arn:aws:s3:::${bucket}`, `arn:aws:s3:::${bucket}/*`]
        },
        {
          Sid: "ProtectObjects",
          Effect: "Deny",
          Action: "s3:DeleteObject",
          Resource: `arn:aws:s3:::${bucket}/*`
        }
      ]
    }),
    probes: bucket => [
      { action: "s3:GetObject", resource: `arn:aws:s3:::${bucket}/welcome.txt`, expected: "allowed" },
      { action: "s3:DeleteObject", resource: `arn:aws:s3:::${bucket}/welcome.txt`, expected: "explicitDeny" }
    ]
  },
  upload: {
    title: "Scoped upload lane",
    policy: bucket => ({
      Version: "2012-10-17",
      Statement: [
        {
          Sid: "UploadOnly",
          Effect: "Allow",
          Action: "s3:PutObject",
          Resource: `arn:aws:s3:::${bucket}/incoming/*`
        }
      ]
    }),
    probes: bucket => [
      { action: "s3:PutObject", resource: `arn:aws:s3:::${bucket}/incoming/report.txt`, expected: "allowed" },
      { action: "s3:PutObject", resource: `arn:aws:s3:::${bucket}/private/report.txt`, expected: "implicitDeny" }
    ]
  }
}

function safeName(value, fallback) {
  const normalized = String(value || "").toLowerCase().replace(/[^a-z0-9-]/g, "-").replace(/-+/g, "-").replace(/^-|-$/g, "")
  return (normalized || fallback).slice(0, 48)
}

async function provision({ bucket, user, policy, policyName }) {
  const steps = []
  await createBucket(bucket)
  steps.push({ label: "S3 bucket created", detail: bucket })
  await putObject(bucket, "welcome.txt", "IAM Forge runs on Floci.")
  steps.push({ label: "Seed object written", detail: `s3://${bucket}/welcome.txt` })
  const created = await iam("CreateUser", { UserName: user }, ["EntityAlreadyExists"])
  const userArn = xmlTag(created.body, "Arn") || `arn:aws:iam::000000000000:user/${user}`
  steps.push({ label: "IAM identity ready", detail: userArn })
  await iam("PutUserPolicy", {
    UserName: user,
    PolicyName: policyName,
    PolicyDocument: JSON.stringify(policy)
  })
  const stored = await iam("GetUserPolicy", { UserName: user, PolicyName: policyName })
  if (!xmlTag(stored.body, "PolicyDocument")) throw new Error("Floci did not return the stored policy")
  steps.push({ label: "Inline policy verified", detail: policyName })
  return { steps, userArn }
}

export async function runLab(id) {
  const lab = labs[id]
  if (!lab) throw new Error("Unknown field drill")
  const suffix = Date.now().toString(36)
  const bucket = `iam-forge-${id}-${suffix}`
  const user = `iam-forge-${id}-${suffix}`
  const policy = lab.policy(bucket)
  const infra = await provision({ bucket, user, policy, policyName: `${id}-policy` })
  const probes = lab.probes(bucket).map(probe => {
    const decision = evaluate(policy, probe.action, probe.resource)
    return { ...probe, decision, pass: decision === probe.expected }
  })
  return {
    title: lab.title,
    bucket,
    user,
    policy,
    summary: policySummary(policy),
    probes,
    steps: infra.steps,
    boundary: "Floci stores the IAM and S3 resources. IAM decisions are calculated by the focused local evaluator because Floci S3 accepts local credentials independently of identity policies."
  }
}

export async function applyPolicy(input) {
  let policy
  try {
    policy = JSON.parse(input.policy)
  } catch {
    const error = new Error("Policy JSON is not valid")
    error.status = 400
    throw error
  }
  const issues = validatePolicy(policy)
  if (issues.length) {
    const error = new Error(issues.join(". "))
    error.status = 400
    throw error
  }
  const suffix = Date.now().toString(36)
  const bucket = safeName(input.bucket, `iam-forge-editor-${suffix}`)
  const user = safeName(input.user, `policy-author-${suffix}`)
  const policyName = `editor-policy-${suffix}`
  const infra = await provision({ bucket, user, policy, policyName })
  const requestedActions = Array.isArray(input.actions) && input.actions.length
    ? input.actions.slice(0, 12)
    : ["s3:ListBucket", "s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
  const probes = requestedActions.map(action => {
    const bucketAction = action === "s3:ListBucket"
    const resource = bucketAction ? `arn:aws:s3:::${bucket}` : `arn:aws:s3:::${bucket}/welcome.txt`
    return { action, resource, decision: evaluate(policy, action, resource) }
  })
  return {
    bucket,
    user,
    userArn: infra.userArn,
    policyName,
    summary: policySummary(policy),
    probes,
    steps: infra.steps,
    boundary: "Infrastructure is live in Floci. The decision matrix uses the local evaluator for Action and Resource matching, including explicit deny precedence."
  }
}
