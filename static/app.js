const form = document.querySelector("#analyze-form");
const button = document.querySelector("#submit-button");
const status = document.querySelector("#status");
const result = document.querySelector("#result");
const copyButton = document.querySelector("#copy-button");
let currentAnswer = "";

form.addEventListener("submit", async (event) => {
  event.preventDefault();
  result.classList.add("hidden");
  status.textContent = "Analyzing with Gemini…";
  button.disabled = true;
  try {
    const response = await fetch("/api/analyze", { method: "POST", body: new FormData(form) });
    const data = await response.json();
    if (!response.ok) throw new Error(data.detail || "Something went wrong.");
    currentAnswer = data.answer || "";
    document.querySelector("#answer").textContent = currentAnswer;
    document.querySelector("#reason").textContent = data.reason || "";
    document.querySelector("#evidence").textContent = data.evidence || "";
    const badge = document.querySelector("#action-badge");
    badge.textContent = data.action === "draft" ? "Draft candidate" : "Human review";
    badge.className = `badge ${data.action === "draft" ? "draft" : "review"}`;
    copyButton.disabled = data.action !== "draft";
    result.classList.remove("hidden");
    status.textContent = "Analysis complete. Verify the answer against the syllabus before using it.";
  } catch (error) {
    status.textContent = error.message || "Request failed.";
  } finally { button.disabled = false; }
});

copyButton.addEventListener("click", async () => {
  if (!currentAnswer) return;
  try {
    await navigator.clipboard.writeText(currentAnswer);
    status.textContent = "Draft copied to clipboard.";
  } catch { status.textContent = "Copy failed. Select and copy the response manually."; }
});
