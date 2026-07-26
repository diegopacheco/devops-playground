const $ = selector => document.querySelector(selector);
const editor = $("#sqlEditor");
const highlight = $("#highlightLayer");
const lineNumbers = $("#lineNumbers");
const autocomplete = $("#autocomplete");
const resultState = $("#resultState");
const resultSummary = $("#resultSummary");
const resultsTable = $("#resultsTable");
const tableScroll = $("#tableScroll");
const emptyState = $("#emptyState");
const pagination = $("#pagination");
const providerSelect = $("#providerSelect");
const keywords = [
  "SELECT", "FROM", "WHERE", "GROUP BY", "ORDER BY", "HAVING", "LIMIT", "OFFSET",
  "JOIN", "LEFT JOIN", "RIGHT JOIN", "INNER JOIN", "FULL JOIN", "ON", "AS", "WITH",
  "DISTINCT", "UNION ALL", "UNION", "CASE", "WHEN", "THEN", "ELSE", "END", "AND",
  "OR", "NOT", "IN", "IS NULL", "IS NOT NULL", "BETWEEN", "LIKE", "ASC", "DESC",
  "EXPLAIN", "SHOW", "DESCRIBE", "CAST", "OVER", "PARTITION BY"
];
const functions = [
  "COUNT", "SUM", "AVG", "MIN", "MAX", "ROUND", "COALESCE", "DATE_TRUNC",
  "ROW_NUMBER", "RANK", "DENSE_RANK", "LOWER", "UPPER", "SUBSTRING", "CONCAT"
];
let catalog = [];
let completions = [];
let completionIndex = 0;
let queryId = "";
let nextToken = null;
let pages = [];
let pageNumber = 1;
let currentRows = [];
let currentColumns = [];
let suggestedQuery = "";

const escapeHtml = value => value
  .replaceAll("&", "&amp;")
  .replaceAll("<", "&lt;")
  .replaceAll(">", "&gt;");

const highlightSql = sql => {
  const tokens = [];
  const protectedSql = escapeHtml(sql).replace(/('(?:''|[^'])*'|--[^\n]*|\/\*[\s\S]*?\*\/)/g, value => {
    const type = value.startsWith("'") ? "string" : "comment";
    tokens.push(`<span class="sql-${type}">${value}</span>`);
    return `\u0000${tokens.length - 1}\u0000`;
  });
  const tables = catalog.flatMap(database => database.tables.map(table => table.name));
  let output = protectedSql
    .replace(/(&lt;=|&gt;=|&lt;&gt;|!=|=|\+|-|\*|\/)/g, '<span class="sql-operator">$1</span>')
    .replace(/\b(\d+(?:\.\d+)?)\b/g, '<span class="sql-number">$1</span>');
  for (const value of [...keywords].sort((a, b) => b.length - a.length)) {
    output = output.replace(new RegExp(`\\b${value.replace(" ", "\\s+")}\\b`, "gi"), match => `<span class="sql-keyword">${match}</span>`);
  }
  for (const value of functions) {
    output = output.replace(new RegExp(`\\b${value}\\b(?=\\s*\\()`, "gi"), match => `<span class="sql-function">${match}</span>`);
  }
  for (const value of tables) {
    output = output.replace(new RegExp(`\\b${value}\\b`, "gi"), match => `<span class="sql-table">${match}</span>`);
  }
  return output.replace(/\u0000(\d+)\u0000/g, (_, index) => tokens[Number(index)]) + (sql.endsWith("\n") ? " " : "");
};

const syncEditor = () => {
  highlight.innerHTML = highlightSql(editor.value);
  const count = editor.value.split("\n").length;
  lineNumbers.textContent = Array.from({ length: count }, (_, index) => index + 1).join("\n");
  highlight.scrollTop = editor.scrollTop;
  highlight.scrollLeft = editor.scrollLeft;
  lineNumbers.scrollTop = editor.scrollTop;
  const before = editor.value.slice(0, editor.selectionStart);
  const lines = before.split("\n");
  $("#editorPosition").textContent = `Ln ${lines.length}, Col ${lines.at(-1).length + 1}`;
};

const toast = (message, type = "") => {
  const item = document.createElement("div");
  item.className = `toast ${type}`;
  item.textContent = message;
  $("#toastStack").append(item);
  setTimeout(() => item.remove(), 4500);
};

const api = async (path, options = {}) => {
  const response = await fetch(path, {
    ...options,
    headers: options.body ? { "Content-Type": "application/json", ...(options.headers || {}) } : options.headers
  });
  const body = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error(body.error || `Request failed with ${response.status}`);
  return body;
};

const renderCatalog = () => {
  const tree = $("#catalogTree");
  tree.innerHTML = catalog.map(database => `
    <div class="tree-database">
      <div class="tree-row database-name">
        <svg viewBox="0 0 18 18"><ellipse cx="9" cy="4" rx="6" ry="2.5"/><path d="M3 4v5c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5V4M3 9v5c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5V9"/></svg>
        ${escapeHtml(database.name)}
      </div>
      ${database.tables.map(table => `
        <button class="tree-row table-name" data-table="${escapeHtml(table.name)}">
          <svg viewBox="0 0 18 18"><path d="M3 4h12v10H3ZM3 8h12M7 4v10"/></svg>
          ${escapeHtml(table.name)}
        </button>
        <div class="tree-columns">
          ${table.columns.map(column => `<div class="tree-column"><span>${escapeHtml(column.name)}</span><span>${escapeHtml(column.type)}</span></div>`).join("")}
        </div>
      `).join("")}
    </div>
  `).join("");
  tree.querySelectorAll("[data-table]").forEach(button => button.addEventListener("dblclick", () => {
    editor.value = `SELECT *\nFROM ${button.dataset.table}\nLIMIT 50;`;
    syncEditor();
    editor.focus();
  }));
};

const loadCatalog = async () => {
  try {
    const response = await api("/api/schema");
    catalog = response.databases;
    renderCatalog();
    syncEditor();
  } catch (error) {
    $("#catalogTree").innerHTML = `<div class="tree-row">${escapeHtml(error.message)}</div>`;
    toast(error.message, "error");
  }
};

const loadStatus = async () => {
  const connection = $("#connection");
  try {
    const status = await api("/api/status");
    connection.className = "connection online";
    $("#connectionText").textContent = "Floci connected";
    $("#latency").textContent = `${status.latency}ms`;
    $("#catalogRegion").textContent = status.region;
    $("#bucketName").textContent = `s3://${status.bucket}`;
  } catch (error) {
    connection.className = "connection offline";
    $("#connectionText").textContent = "Floci unavailable";
    toast(error.message, "error");
  }
};

const setResultState = (state, text) => {
  resultState.className = `result-state ${state}`;
  resultState.innerHTML = `<span></span>${escapeHtml(text)}`;
};

const renderResults = data => {
  currentColumns = data.columns;
  currentRows = data.rows;
  const head = resultsTable.querySelector("thead");
  const body = resultsTable.querySelector("tbody");
  head.innerHTML = `<tr>${data.columns.map(column => `<th>${escapeHtml(column.name)}<span>${escapeHtml(column.type)}</span></th>`).join("")}</tr>`;
  body.innerHTML = data.rows.map(row => `<tr>${row.map(value =>
    value === null
      ? '<td class="null-value">null</td>'
      : `<td title="${escapeHtml(String(value))}">${escapeHtml(String(value))}</td>`
  ).join("")}</tr>`).join("");
  emptyState.hidden = true;
  tableScroll.hidden = false;
  pagination.hidden = false;
  $("#downloadCsv").disabled = data.rows.length === 0;
  $("#pageLabel").textContent = `Page ${pageNumber} · ${data.rows.length} row${data.rows.length === 1 ? "" : "s"}`;
  $("#previousPage").disabled = pageNumber === 1;
  $("#nextPage").disabled = !data.nextToken;
  nextToken = data.nextToken;
};

const runQuery = async () => {
  const button = $("#runQuery");
  button.disabled = true;
  button.querySelector("span").textContent = "Running";
  setResultState("running", "Running");
  resultSummary.textContent = "DuckDB is reading Glue-backed data from Floci S3";
  autocomplete.classList.remove("visible");
  try {
    const started = performance.now();
    const data = await api("/api/query", {
      method: "POST",
      body: JSON.stringify({ sql: editor.value })
    });
    queryId = data.queryId;
    pageNumber = 1;
    pages = [];
    renderResults(data);
    const elapsed = Math.max(data.elapsed || 0, Math.round(performance.now() - started));
    setResultState("success", "Succeeded");
    resultSummary.textContent = `${data.rows.length}${data.nextToken ? "+" : ""} rows · ${elapsed} ms · ${queryId.slice(0, 12)}`;
    saveQueryHistory(editor.value);
  } catch (error) {
    setResultState("error", "Failed");
    resultSummary.textContent = error.message;
    toast(error.message, "error");
  } finally {
    button.disabled = false;
    button.querySelector("span").textContent = "Run query";
  }
};

const fetchPage = async token => {
  const data = await api("/api/results", {
    method: "POST",
    body: JSON.stringify({ queryId, nextToken: token })
  });
  renderResults(data);
};

const formatSql = sql => {
  let output = sql.trim().replace(/\s+/g, " ");
  for (const keyword of ["SELECT", "FROM", "WHERE", "GROUP BY", "HAVING", "ORDER BY", "LIMIT", "UNION ALL", "UNION"]) {
    output = output.replace(new RegExp(`\\s*\\b${keyword.replace(" ", "\\s+")}\\b\\s*`, "gi"), `\n${keyword} `);
  }
  output = output.trim().replace(/\s*,\s*/g, ",\n  ");
  const lines = output.split("\n");
  output = lines.map((line, index) => {
    if (index === 0 || /^(FROM|WHERE|GROUP|HAVING|ORDER|LIMIT|UNION)/.test(line)) return line;
    return `  ${line}`;
  }).join("\n");
  return output.replace(/\s*;\s*$/, "") + ";";
};

const completionSource = () => {
  const tableItems = catalog.flatMap(database => database.tables.map(table => ({
    label: table.name,
    kind: "table",
    detail: database.name
  })));
  const columnItems = catalog.flatMap(database => database.tables.flatMap(table => table.columns.map(column => ({
    label: column.name,
    kind: "column",
    detail: column.type
  }))));
  return [
    ...keywords.map(label => ({ label, kind: "keyword", detail: "SQL" })),
    ...functions.map(label => ({ label, kind: "function", detail: "function" })),
    ...tableItems,
    ...columnItems
  ];
};

const currentWord = () => {
  const before = editor.value.slice(0, editor.selectionStart);
  return before.match(/[A-Za-z_][A-Za-z0-9_]*$/)?.[0] || "";
};

const showCompletions = force => {
  const word = currentWord();
  if (!force && word.length < 2) {
    autocomplete.classList.remove("visible");
    return;
  }
  const source = completionSource();
  const seen = new Set();
  completions = source.filter(item => {
    const match = !word || item.label.toLowerCase().startsWith(word.toLowerCase());
    const key = item.label.toLowerCase();
    if (!match || seen.has(key)) return false;
    seen.add(key);
    return true;
  }).slice(0, 12);
  completionIndex = 0;
  if (!completions.length) {
    autocomplete.classList.remove("visible");
    return;
  }
  renderCompletions();
  const lines = editor.value.slice(0, editor.selectionStart).split("\n");
  const line = lines.length - 1;
  const column = lines.at(-1).length;
  const top = Math.min(18 + (line + 1) * 23 - editor.scrollTop, editor.clientHeight - 220);
  const left = Math.min(66 + column * 7.8 - editor.scrollLeft, editor.clientWidth - 270);
  autocomplete.style.top = `${Math.max(44, top)}px`;
  autocomplete.style.left = `${Math.max(56, left)}px`;
  autocomplete.classList.add("visible");
};

const renderCompletions = () => {
  autocomplete.innerHTML = completions.map((item, index) => `
    <button class="completion-item ${index === completionIndex ? "selected" : ""}" data-index="${index}" role="option">
      <span class="completion-icon">${item.kind === "keyword" ? "K" : item.kind === "function" ? "ƒ" : item.kind === "table" ? "T" : "C"}</span>
      <strong>${escapeHtml(item.label)}</strong>
      <small>${escapeHtml(item.detail)}</small>
    </button>
  `).join("");
  autocomplete.querySelectorAll(".completion-item").forEach(button =>
    button.addEventListener("mousedown", event => {
      event.preventDefault();
      applyCompletion(Number(button.dataset.index));
    })
  );
};

const applyCompletion = index => {
  const item = completions[index];
  if (!item) return;
  const word = currentWord();
  const start = editor.selectionStart - word.length;
  const suffix = item.kind === "function" ? "()" : "";
  editor.setRangeText(item.label + suffix, start, editor.selectionStart, "end");
  if (suffix) editor.selectionStart = editor.selectionEnd = editor.selectionStart - 1;
  autocomplete.classList.remove("visible");
  syncEditor();
};

const saveQueryHistory = sql => {
  const history = JSON.parse(localStorage.getItem("flocus-query-history") || "[]");
  const next = [sql, ...history.filter(item => item !== sql)].slice(0, 10);
  localStorage.setItem("flocus-query-history", JSON.stringify(next));
};

const askAssistant = async () => {
  const prompt = $("#assistantPrompt").value.trim();
  if (!prompt) {
    toast("Tell the assistant what you want to query", "error");
    return;
  }
  const button = $("#askAssistant");
  button.disabled = true;
  button.querySelector("span").textContent = `Asking ${providerSelect.value}`;
  try {
    const response = await api("/api/ai", {
      method: "POST",
      body: JSON.stringify({
        provider: providerSelect.value,
        sql: editor.value,
        request: prompt
      })
    });
    suggestedQuery = response.query;
    $("#suggestedSql").textContent = suggestedQuery;
    $("#assistantResponse").hidden = false;
  } catch (error) {
    toast(error.message, "error");
  } finally {
    button.disabled = false;
    button.querySelector("span").textContent = "Generate SQL";
  }
};

const downloadCsv = () => {
  const quote = value => value === null ? "" : `"${String(value).replaceAll('"', '""')}"`;
  const csv = [currentColumns.map(column => quote(column.name)), ...currentRows.map(row => row.map(quote))]
    .map(row => row.join(","))
    .join("\n");
  const link = document.createElement("a");
  link.href = URL.createObjectURL(new Blob([csv], { type: "text/csv" }));
  link.download = `athena-results-page-${pageNumber}.csv`;
  link.click();
  URL.revokeObjectURL(link.href);
};

editor.addEventListener("input", () => {
  syncEditor();
  showCompletions(false);
});
editor.addEventListener("scroll", syncEditor);
editor.addEventListener("click", syncEditor);
editor.addEventListener("keyup", syncEditor);
editor.addEventListener("keydown", event => {
  if ((event.metaKey || event.ctrlKey) && event.key === "Enter") {
    event.preventDefault();
    runQuery();
    return;
  }
  if (event.ctrlKey && event.code === "Space") {
    event.preventDefault();
    showCompletions(true);
    return;
  }
  if (autocomplete.classList.contains("visible")) {
    if (event.key === "ArrowDown" || event.key === "ArrowUp") {
      event.preventDefault();
      completionIndex = (completionIndex + (event.key === "ArrowDown" ? 1 : -1) + completions.length) % completions.length;
      renderCompletions();
    }
    if (event.key === "Tab" || event.key === "Enter") {
      event.preventDefault();
      applyCompletion(completionIndex);
    }
    if (event.key === "Escape") autocomplete.classList.remove("visible");
  }
  if (event.key === "Tab" && !autocomplete.classList.contains("visible")) {
    event.preventDefault();
    editor.setRangeText("  ", editor.selectionStart, editor.selectionEnd, "end");
    syncEditor();
  }
});

$("#runQuery").addEventListener("click", runQuery);
$("#formatQuery").addEventListener("click", () => {
  editor.value = formatSql(editor.value);
  syncEditor();
});
$("#refreshSchema").addEventListener("click", loadCatalog);
$("#zebraToggle").addEventListener("change", event => resultsTable.classList.toggle("zebra", event.target.checked));
$("#downloadCsv").addEventListener("click", downloadCsv);
$("#nextPage").addEventListener("click", async () => {
  if (!nextToken) return;
  pages.push(nextToken);
  pageNumber += 1;
  try {
    await fetchPage(nextToken);
  } catch (error) {
    pages.pop();
    pageNumber -= 1;
    toast(error.message, "error");
  }
});
$("#previousPage").addEventListener("click", async () => {
  if (pageNumber === 1) return;
  pages.pop();
  pageNumber -= 1;
  try {
    await fetchPage(pageNumber === 1 ? null : pages.at(-1));
  } catch (error) {
    toast(error.message, "error");
  }
});
providerSelect.value = localStorage.getItem("flocus-ai-provider") || "codex";
providerSelect.addEventListener("change", () => localStorage.setItem("flocus-ai-provider", providerSelect.value));
$(".suggestion-list").addEventListener("click", event => {
  const button = event.target.closest("[data-prompt]");
  if (!button) return;
  $("#assistantPrompt").value = button.dataset.prompt;
  $("#assistantPrompt").focus();
});
$("#askAssistant").addEventListener("click", askAssistant);
$("#assistantPrompt").addEventListener("keydown", event => {
  if ((event.metaKey || event.ctrlKey) && event.key === "Enter") askAssistant();
});
$("#dismissSuggestion").addEventListener("click", () => {
  $("#assistantResponse").hidden = true;
});
$("#useSuggestion").addEventListener("click", () => {
  editor.value = suggestedQuery;
  syncEditor();
  $("#assistantResponse").hidden = true;
  editor.focus();
  toast("AI query placed in the editor");
});
document.addEventListener("click", event => {
  if (event.target !== editor && !autocomplete.contains(event.target)) autocomplete.classList.remove("visible");
});

resultsTable.classList.add("zebra");
syncEditor();
await Promise.all([loadStatus(), loadCatalog()]);
