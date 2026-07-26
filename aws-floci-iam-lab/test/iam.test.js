import assert from "node:assert/strict"
import test from "node:test"
import { evaluate, policySummary, validatePolicy } from "../lib/iam.js"

const bucket = "arn:aws:s3:::reports"

test("matching allow produces allowed", () => {
  const policy = {
    Version: "2012-10-17",
    Statement: [{
      Effect: "Allow",
      Action: "s3:GetObject",
      Resource: `${bucket}/*`
    }]
  }
  assert.equal(evaluate(policy, "s3:GetObject", `${bucket}/q1.pdf`), "allowed")
})

test("missing allow produces implicit deny", () => {
  const policy = {
    Version: "2012-10-17",
    Statement: [{
      Effect: "Allow",
      Action: "s3:GetObject",
      Resource: `${bucket}/*`
    }]
  }
  assert.equal(evaluate(policy, "s3:PutObject", `${bucket}/q1.pdf`), "implicitDeny")
})

test("matching deny overrides broad allow", () => {
  const policy = {
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: "s3:*",
        Resource: `${bucket}/*`
      },
      {
        Effect: "Deny",
        Action: "s3:DeleteObject",
        Resource: `${bucket}/*`
      }
    ]
  }
  assert.equal(evaluate(policy, "s3:DeleteObject", `${bucket}/q1.pdf`), "explicitDeny")
})

test("resource prefix narrows the decision", () => {
  const policy = {
    Version: "2012-10-17",
    Statement: [{
      Effect: "Allow",
      Action: "s3:PutObject",
      Resource: `${bucket}/incoming/*`
    }]
  }
  assert.equal(evaluate(policy, "s3:PutObject", `${bucket}/incoming/q1.pdf`), "allowed")
  assert.equal(evaluate(policy, "s3:PutObject", `${bucket}/private/q1.pdf`), "implicitDeny")
})

test("validation and summary describe a focused policy", () => {
  const policy = {
    Version: "2012-10-17",
    Statement: [{
      Effect: "Allow",
      Action: ["s3:GetObject", "s3:PutObject"],
      Resource: `${bucket}/*`
    }]
  }
  assert.deepEqual(validatePolicy(policy), [])
  assert.deepEqual(policySummary(policy), {
    statements: 1,
    allows: 1,
    denies: 0,
    actions: 2,
    resources: 1
  })
})
