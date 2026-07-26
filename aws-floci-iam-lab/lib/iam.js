function values(value) {
  return Array.isArray(value) ? value : [value]
}

function wildcard(pattern, candidate) {
  const escaped = pattern.replace(/[.+?^${}()|[\]\\]/g, "\\$&").replaceAll("*", ".*")
  return new RegExp(`^${escaped}$`, "i").test(candidate)
}

function statementMatches(statement, action, resource) {
  const actionMatch = statement.Action
    ? values(statement.Action).some(pattern => wildcard(pattern, action))
    : !values(statement.NotAction).some(pattern => wildcard(pattern, action))
  const resourceMatch = statement.Resource
    ? values(statement.Resource).some(pattern => wildcard(pattern, resource))
    : !values(statement.NotResource).some(pattern => wildcard(pattern, resource))
  return actionMatch && resourceMatch
}

export function validatePolicy(policy) {
  const issues = []
  if (!policy || typeof policy !== "object" || Array.isArray(policy)) issues.push("Policy must be a JSON object")
  if (policy?.Version !== "2012-10-17") issues.push("Version must be 2012-10-17")
  if (!policy?.Statement) issues.push("Statement is required")
  const statements = policy?.Statement ? values(policy.Statement) : []
  statements.forEach((statement, index) => {
    if (!["Allow", "Deny"].includes(statement.Effect)) issues.push(`Statement ${index + 1} needs Effect Allow or Deny`)
    if (!statement.Action && !statement.NotAction) issues.push(`Statement ${index + 1} needs Action or NotAction`)
    if (!statement.Resource && !statement.NotResource) issues.push(`Statement ${index + 1} needs Resource or NotResource`)
    if (statement.Condition) issues.push(`Statement ${index + 1} uses Condition, which this focused evaluator does not cover`)
    if (statement.Principal) issues.push(`Statement ${index + 1} uses Principal, which belongs in a resource policy`)
  })
  return issues
}

export function evaluate(policy, action, resource) {
  const matching = values(policy.Statement).filter(statement => statementMatches(statement, action, resource))
  if (matching.some(statement => statement.Effect === "Deny")) return "explicitDeny"
  if (matching.some(statement => statement.Effect === "Allow")) return "allowed"
  return "implicitDeny"
}

export function policySummary(policy) {
  const statements = values(policy.Statement)
  const allows = statements.filter(statement => statement.Effect === "Allow").length
  const denies = statements.filter(statement => statement.Effect === "Deny").length
  const actions = new Set(statements.flatMap(statement => values(statement.Action || statement.NotAction || [])))
  const resources = new Set(statements.flatMap(statement => values(statement.Resource || statement.NotResource || [])))
  return { statements: statements.length, allows, denies, actions: actions.size, resources: resources.size }
}
