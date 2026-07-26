const tabs = [...document.querySelectorAll("[data-tab]")]
const panels = [...document.querySelectorAll("[data-panel]")]
const editor = document.querySelector("#policy-editor")
const highlightLayer = document.querySelector("#highlight-layer")
const lineNumbers = document.querySelector("#line-numbers")
const syntaxStatus = document.querySelector("#syntax-status")
const bucketInput = document.querySelector("#bucket-name")
const userInput = document.querySelector("#user-name")
const templateSelect = document.querySelector("#policy-template")
const providerRadios = [...document.querySelectorAll('input[name="provider"]')]
const assistantPrompt = document.querySelector("#assistant-prompt")
const assistantAnswer = document.querySelector("#assistant-answer")
const drawer = document.querySelector("#ai-drawer")
const drawerBackdrop = document.querySelector("#drawer-backdrop")
const drawerContext = document.querySelector("#drawer-context")
const drawerPrompt = document.querySelector("#drawer-prompt")
const drawerAnswer = document.querySelector("#drawer-answer")
const floatingAi = document.querySelector("#floating-ai")
let activeTab = "learn"
let availableProviders = {}

const templates = {
  read: bucket => ({
    Version: "2012-10-17",
    Statement: [
      {
        Sid: "ListBucket",
        Effect: "Allow",
        Action: "s3:ListBucket",
        Resource: `arn:aws:s3:::${bucket}`
      },
      {
        Sid: "ReadObjects",
        Effect: "Allow",
        Action: "s3:GetObject",
        Resource: `arn:aws:s3:::${bucket}/*`
      }
    ]
  }),
  upload: bucket => ({
    Version: "2012-10-17",
    Statement: [
      {
        Sid: "UploadLane",
        Effect: "Allow",
        Action: "s3:PutObject",
        Resource: `arn:aws:s3:::${bucket}/incoming/*`
      }
    ]
  }),
  guardrail: bucket => ({
    Version: "2012-10-17",
    Statement: [
      {
        Sid: "BucketWork",
        Effect: "Allow",
        Action: "s3:*",
        Resource: [
          `arn:aws:s3:::${bucket}`,
          `arn:aws:s3:::${bucket}/*`
        ]
      },
      {
        Sid: "NoObjectDeletion",
        Effect: "Deny",
        Action: "s3:DeleteObject",
        Resource: `arn:aws:s3:::${bucket}/*`
      }
    ]
  })
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll("\"", "&quot;")
    .replaceAll("'", "&#039;")
}

function highlightJson(value) {
  const tokenPattern = /"(?:\\u[a-fA-F0-9]{4}|\\[^u]|[^\\"])*"|-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?|\b(?:true|false|null)\b/g
  let output = ""
  let lastIndex = 0
  let match
  while ((match = tokenPattern.exec(value))) {
    output += escapeHtml(value.slice(lastIndex, match.index))
    const token = match[0]
    const remaining = value.slice(tokenPattern.lastIndex)
    const type = token.startsWith("\"")
      ? (/^\s*:/.test(remaining) ? "key" : "string")
      : (/^(true|false|null)$/.test(token) ? "literal" : "number")
    output += `<span class="token-${type}">${escapeHtml(token)}</span>`
    lastIndex = tokenPattern.lastIndex
  }
  return output + escapeHtml(value.slice(lastIndex)) + "\n"
}

function syncEditor() {
  highlightLayer.innerHTML = highlightJson(editor.value)
  const count = editor.value.split("\n").length
  lineNumbers.textContent = Array.from({ length: count }, (_, index) => index + 1).join("\n")
  try {
    JSON.parse(editor.value)
    syntaxStatus.classList.remove("is-invalid")
    syntaxStatus.innerHTML = "<i></i> Valid JSON"
  } catch {
    syntaxStatus.classList.add("is-invalid")
    syntaxStatus.innerHTML = "<i></i> Invalid JSON"
  }
}

function loadTemplate() {
  const bucket = bucketInput.value.trim() || "iam-forge-workbench"
  editor.value = JSON.stringify(templates[templateSelect.value](bucket), null, 2)
  syncEditor()
}

function selectTab(id, focus = false) {
  activeTab = id
  tabs.forEach(tab => {
    const selected = tab.dataset.tab === id
    tab.classList.toggle("is-active", selected)
    tab.setAttribute("aria-selected", String(selected))
    tab.tabIndex = selected ? 0 : -1
    if (selected && focus) tab.focus()
  })
  panels.forEach(panel => {
    const selected = panel.dataset.panel === id
    panel.hidden = !selected
    panel.classList.toggle("is-active", selected)
  })
  floatingAi.classList.toggle("is-hidden", id === "assistant")
  history.replaceState(null, "", `#${id}`)
  window.scrollTo({ top: 0, behavior: "smooth" })
}

function decisionLabel(decision) {
  return {
    allowed: "ALLOWED",
    implicitDeny: "IMPLICIT DENY",
    explicitDeny: "EXPLICIT DENY"
  }[decision] || decision
}

function renderDrill(result) {
  const probes = result.probes.map(probe => `
    <div class="probe">
      <strong>${escapeHtml(probe.action)}</strong>
      <span class="${escapeHtml(probe.decision)}">${escapeHtml(decisionLabel(probe.decision))}</span>
    </div>
  `).join("")
  return `
    <div class="result-resource"><span>FLOCI BUCKET</span><code>${escapeHtml(result.bucket)}</code></div>
    <div class="result-resource"><span>IAM USER</span><code>${escapeHtml(result.user)}</code></div>
    ${probes}
  `
}

function renderEvidence(result) {
  const trail = result.steps.map(step => `
    <div class="trail-item">
      <i>✓</i>
      <div><strong>${escapeHtml(step.label)}</strong><small>${escapeHtml(step.detail)}</small></div>
    </div>
  `).join("")
  const probes = result.probes.map(probe => `
    <div class="evidence-probe">
      <code>${escapeHtml(probe.action)}</code>
      <span class="decision-label ${escapeHtml(probe.decision)}">${escapeHtml(decisionLabel(probe.decision))}</span>
    </div>
  `).join("")
  return `
    <div class="evidence-live">
      <div class="evidence-section">
        <span>FLOCI RESOURCE TRAIL</span>
        ${trail}
      </div>
      <div class="evidence-section">
        <span>DECISION MATRIX</span>
        ${probes}
      </div>
      <div class="evidence-section">
        <span>POLICY SHAPE</span>
        <div class="trail-item"><i>↳</i><div><strong>${result.summary.statements} statements · ${result.summary.actions} actions</strong><small>${result.summary.allows} allow · ${result.summary.denies} deny</small></div></div>
      </div>
    </div>
  `
}

async function fetchJson(url, options) {
  const response = await fetch(url, options)
  const body = await response.json()
  if (!response.ok) throw new Error(body.error || `Request failed with ${response.status}`)
  return body
}

async function loadHealth() {
  const pill = document.querySelector("#runtime-pill")
  const label = document.querySelector("#runtime-text")
  try {
    const result = await fetchJson("/api/health")
    pill.classList.add("is-ready")
    label.textContent = `Floci ${result.floci.version} · IAM + S3 ready`
  } catch {
    pill.classList.add("is-error")
    label.textContent = "Floci unavailable"
  }
}

async function runDrill(button) {
  const id = button.dataset.lab
  const target = document.querySelector(`#result-${id}`)
  button.disabled = true
  target.innerHTML = '<div class="result-loading"><div class="spinner"></div></div>'
  try {
    const result = await fetchJson(`/api/labs/${id}`, { method: "POST" })
    target.innerHTML = renderDrill(result)
  } catch (error) {
    target.innerHTML = `<div class="result-error">${escapeHtml(error.message)}</div>`
  } finally {
    button.disabled = false
  }
}

async function applyPolicy() {
  const button = document.querySelector("#apply-policy")
  const state = document.querySelector("#evidence-state")
  const content = document.querySelector("#evidence-content")
  button.disabled = true
  state.textContent = "APPLYING"
  content.className = "evidence-empty"
  content.innerHTML = '<div class="spinner"></div><h2>Building local evidence</h2>'
  try {
    const result = await fetchJson("/api/policies/apply", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        bucket: bucketInput.value,
        user: userInput.value,
        policy: editor.value
      })
    })
    state.textContent = "VERIFIED"
    content.className = ""
    content.innerHTML = renderEvidence(result)
  } catch (error) {
    state.textContent = "FAILED"
    content.className = "evidence-empty"
    content.innerHTML = `<div class="evidence-glyph">×</div><h2>Policy not applied</h2><p>${escapeHtml(error.message)}</p>`
  } finally {
    button.disabled = false
  }
}

function selectedProvider() {
  return providerRadios.find(radio => radio.checked)?.value || "codex"
}

function setProvider(provider) {
  const choice = providerRadios.find(radio => radio.value === provider) || providerRadios[0]
  choice.checked = true
  localStorage.setItem("iamForge.provider", choice.value)
}

async function loadProviders() {
  try {
    const result = await fetchJson("/api/assistant/status")
    availableProviders = result.providers
    Object.entries(result.providers).forEach(([id, provider]) => {
      const indicator = document.querySelector(`[data-availability="${id}"]`)
      indicator.textContent = provider.available ? "READY ON HOST" : "NOT FOUND"
      indicator.classList.add(provider.available ? "is-ready" : "is-missing")
    })
    const ready = Object.values(result.providers).filter(provider => provider.available).length
    document.querySelector("#provider-status").textContent = `${ready} of 3 ready`
  } catch {
    document.querySelector("#provider-status").textContent = "AI bridge unavailable"
  }
}

async function askAi(prompt, context, target, button) {
  const provider = selectedProvider()
  if (availableProviders[provider] && !availableProviders[provider].available) {
    target.textContent = `${availableProviders[provider].label} is not available on this host.`
    return
  }
  button.disabled = true
  target.textContent = "Thinking through your IAM question…"
  try {
    const result = await fetchJson("/api/assistant", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ provider, prompt, context })
    })
    target.textContent = result.answer
  } catch (error) {
    target.textContent = error.message
  } finally {
    button.disabled = false
  }
}

function openDrawer(context) {
  let fullContext = context
  if (activeTab === "editor") fullContext += `\n\nCurrent policy:\n${editor.value}`
  drawerContext.textContent = context
  drawer.dataset.context = fullContext
  drawer.classList.add("is-open")
  drawer.setAttribute("aria-hidden", "false")
  drawerBackdrop.hidden = false
  drawerPrompt.focus()
}

function closeDrawer() {
  drawer.classList.remove("is-open")
  drawer.setAttribute("aria-hidden", "true")
  drawerBackdrop.hidden = true
}

tabs.forEach((tab, index) => {
  tab.addEventListener("click", () => selectTab(tab.dataset.tab))
  tab.addEventListener("keydown", event => {
    if (!["ArrowLeft", "ArrowRight"].includes(event.key)) return
    event.preventDefault()
    const direction = event.key === "ArrowRight" ? 1 : -1
    const next = tabs[(index + direction + tabs.length) % tabs.length]
    selectTab(next.dataset.tab, true)
  })
})

document.querySelectorAll("[data-go]").forEach(button => button.addEventListener("click", () => selectTab(button.dataset.go)))
document.querySelectorAll(".run-lab").forEach(button => button.addEventListener("click", () => runDrill(button)))
document.querySelector("#apply-policy").addEventListener("click", applyPolicy)
templateSelect.addEventListener("change", loadTemplate)
editor.addEventListener("input", syncEditor)
editor.addEventListener("scroll", () => {
  highlightLayer.scrollTop = editor.scrollTop
  highlightLayer.scrollLeft = editor.scrollLeft
  lineNumbers.scrollTop = editor.scrollTop
})
editor.addEventListener("keydown", event => {
  if (event.key !== "Tab") return
  event.preventDefault()
  const start = editor.selectionStart
  const end = editor.selectionEnd
  editor.value = `${editor.value.slice(0, start)}  ${editor.value.slice(end)}`
  editor.selectionStart = editor.selectionEnd = start + 2
  syncEditor()
})

providerRadios.forEach(radio => radio.addEventListener("change", () => setProvider(radio.value)))
assistantPrompt.addEventListener("input", () => {
  document.querySelector("#prompt-count").textContent = `${assistantPrompt.value.length} / 4000`
})
document.querySelector("#send-question").addEventListener("click", event => {
  if (!assistantPrompt.value.trim()) {
    assistantAnswer.textContent = "Write a question first."
    return
  }
  askAi(assistantPrompt.value, "IAM assistant tab", assistantAnswer, event.currentTarget)
})

document.querySelectorAll(".ask-context").forEach(button => button.addEventListener("click", () => openDrawer(button.dataset.context)))
document.querySelector("#close-drawer").addEventListener("click", closeDrawer)
drawerBackdrop.addEventListener("click", closeDrawer)
document.addEventListener("keydown", event => {
  if (event.key === "Escape" && drawer.classList.contains("is-open")) closeDrawer()
})
document.querySelector("#drawer-send").addEventListener("click", event => {
  if (!drawerPrompt.value.trim()) {
    drawerAnswer.textContent = "Write a question first."
    return
  }
  askAi(drawerPrompt.value, drawer.dataset.context, drawerAnswer, event.currentTarget)
})

const initialTab = location.hash.slice(1)
if (tabs.some(tab => tab.dataset.tab === initialTab)) selectTab(initialTab)
setProvider(localStorage.getItem("iamForge.provider") || "codex")
loadTemplate()
loadHealth()
loadProviders()
