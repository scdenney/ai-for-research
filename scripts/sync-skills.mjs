#!/usr/bin/env node
// Detects drift between the open-science-skills repo's own skill catalog
// (README.md's "## Skills" section) and docs/skills/index.html, and appends
// clearly-flagged draft entries / removal notices. Never rewrites or deletes
// existing hand-authored prose — a human always reviews the resulting PR.

import { readFileSync, writeFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const [, , ossPath] = process.argv;
if (!ossPath) {
  console.error("Usage: node sync-skills.mjs <path-to-open-science-skills-checkout>");
  process.exit(1);
}

const PAGE_PATH = join(import.meta.dirname, "..", "docs", "skills", "index.html");

// Category name (as it appears in the OSS README's ### headings) -> the
// two-letter code and roman numeral already used on the skills page.
const CATEGORY_MAP = {
  "Project Setup": { code: "ps", roman: "I" },
  "Workflow & Orchestration": { code: "wo", roman: "II" },
  "Ideation": { code: "id", roman: "III" },
  "Research Design": { code: "rd", roman: "IV" },
  "Analysis": { code: "an", roman: "V" },
  "Corpus Processing": { code: "cp", roman: "VI" },
  "Writing & Reporting": { code: "wr", roman: "VII" },
  "Figures & Tables": { code: "ft", roman: "VIII" },
  "Manuscript QA": { code: "mq", roman: "IX" },
  "Review & Submission": { code: "rs", roman: "X" },
};

function stripHtml(html) {
  return html
    .replace(/<a\b[^>]*>(.*?)<\/a>/gis, "$1")
    .replace(/\[([^\]]*)\]\([^)]*\)/g, "$1") // markdown links -> text
    .replace(/<\/?strong>/gi, "")
    .replace(/<code>/gi, "`")
    .replace(/<\/code>/gi, "`")
    .replace(/<[^>]+>/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

function parseReadmeCatalog(readme) {
  const skillsSection = readme.split(/\n## Skills\n/)[1]?.split(/\n## /)[0];
  if (!skillsSection) throw new Error("Could not find '## Skills' section in README.md");

  const categories = [];
  const catBlocks = skillsSection.split(/\n### /).slice(1);
  for (const block of catBlocks) {
    const name = block.split("\n")[0].trim();
    const skills = [];
    // The README catalog switched from HTML tables to Markdown tables on
    // 2026-07-11: one row per skill, shaped
    //   | [slug](plugin/skills/slug/SKILL.md) | Platform | `command` | Description |
    // Only plugin/skills rows are parsed; Codex-only rows (which link into
    // codex/) are curated on the page by hand, and the removal check below
    // already unions the codex/ directory so they are never flagged.
    const rowRe = /^\|\s*\[([a-z0-9-]+)\]\(plugin\/skills\/[a-z0-9-]+\/SKILL\.md\)\s*\|[^|]*\|[^|]*\|\s*(.+?)\s*\|\s*$/gm;
    let m;
    while ((m = rowRe.exec(block))) {
      skills.push({ slug: m[1], description: stripHtml(m[2]) });
    }
    categories.push({ name, skills });
  }
  return categories;
}

function parsePageEntries(pageHtml) {
  const entries = new Map(); // slug -> { cat, block }
  const liRe = /<li class="entry"[^>]*id="([a-z0-9-]+)"[^>]*data-cat="([a-z]+)"[\s\S]*?<\/li>/g;
  let m;
  while ((m = liRe.exec(pageHtml))) {
    entries.set(m[1], { cat: m[2] });
  }
  return entries;
}

function buildEntryHtml(slug, code, description, codexSlugs) {
  const both = codexSlugs.has(slug); // a plugin skill also present in the codex catalog
  const plat = both ? "both" : "claude";
  const badge = both
    ? '<span class="tag-plat plat-both">both</span>'
    : '<span class="tag-plat plat-claude">Claude&nbsp;only</span>';
  const cmds = both
    ? `<code class="cmd">/oss:${slug}</code> <span class="cmd-sep">·</span> <code class="cmd">$${slug}</code>`
    : `<code class="cmd">/oss:${slug}</code>`;
  const searchExtra = both ? `$${slug} codex claude both` : "claude only";
  const search = `${slug} needs review ${description} /oss:${slug} ${searchExtra}`.toLowerCase().replace(/[`"]/g, "");
  // Markup matches the 2026-07-11 page design: descriptions are always
  // visible (no hidden attribute, no row-toggle button, no aria wiring).
  return `    <li class="entry" id="${slug}" data-cat="${code}" data-plat="${plat}" data-search="${search}">
      <div class="row">
        <div class="row-head">
          <span class="tag-cat">${code.toUpperCase()}</span><span class="name">${slug}</span><span class="leader" aria-hidden="true"></span>${badge}
        </div>
        <a class="ext-link" href="https://github.com/scdenney/open-science-skills/blob/main/plugin/skills/${slug}/SKILL.md" aria-label="Open ${slug} on GitHub">↗</a>
      </div>
      <div class="cmds">${cmds}</div>
      <p class="desc" id="desc-${slug}"><em>[needs review — paraphrase in plain language, source repo says:]</em> ${description}</p>
    </li>`;
}

const readme = readFileSync(join(ossPath, "README.md"), "utf8");
const catalog = parseReadmeCatalog(readme);
let page = readFileSync(PAGE_PATH, "utf8");
const pageEntries = parsePageEntries(page);

// Authoritative "does this skill still exist": a skill lives if it is a plugin
// skill (Claude Code) OR a codex-catalog skill (e.g. the Codex-only
// 46-orchestrate). Union so codex-only entries are not flagged as removed.
const pluginSlugs = new Set(
  readdirSync(join(ossPath, "plugin", "skills"), { withFileTypes: true })
    .filter((d) => d.isDirectory())
    .map((d) => d.name)
);
let codexSlugs = new Set();
try {
  codexSlugs = new Set(
    readdirSync(join(ossPath, "codex"), { withFileTypes: true })
      .filter((d) => d.isDirectory())
      .map((d) => d.name)
  );
} catch {
  // no codex catalog present
}
const currentSlugs = new Set([...pluginSlugs, ...codexSlugs]);

const summary = { newSkills: [], removedSkills: [], newCategories: [] };

for (const cat of catalog) {
  const known = CATEGORY_MAP[cat.name];
  if (!known) {
    summary.newCategories.push({ name: cat.name, skills: cat.skills.map((s) => s.slug) });
    continue;
  }
  for (const skill of cat.skills) {
    if (!pageEntries.has(skill.slug)) {
      summary.newSkills.push({ ...skill, category: cat.name, code: known.code });
      const entryHtml = buildEntryHtml(skill.slug, known.code, skill.description, codexSlugs);
      // Append to the end of that category's <ul class="entries"> block.
      const chapterRe = new RegExp(
        `(<div class="chapter" data-cat="${known.code}"[^>]*>[\\s\\S]*?<\\/div>\\s*<ul class="entries"[^>]*>)([\\s\\S]*?)(<\\/ul>)`
      );
      const chapMatch = page.match(chapterRe);
      if (chapMatch) {
        page = page.replace(chapterRe, `$1$2${entryHtml}\n  $3`);
      }
    }
  }
}

for (const [slug, { cat }] of pageEntries) {
  if (!currentSlugs.has(slug) && !slug.startsWith("removed-")) {
    summary.removedSkills.push(slug);
    const liRe = new RegExp(`(<li class="entry"[^>]*id="${slug}"[\\s\\S]*?<\\/li>)`);
    if (!page.includes(`REMOVED UPSTREAM: ${slug}`)) {
      page = page.replace(liRe, `<!-- REMOVED UPSTREAM: ${slug} is no longer in plugin/skills/ as of today. Review and remove if confirmed. -->\n    $1`);
    }
  }
}

// Opportunistically keep the colophon's version number current.
try {
  const pluginJson = JSON.parse(readFileSync(join(ossPath, "plugin", ".claude-plugin", "plugin.json"), "utf8"));
  if (pluginJson.version) {
    page = page.replace(/v\d+\.\d+\.\d+(?=\)\.)/, `v${pluginJson.version}`);
  }
} catch {
  // no plugin.json — leave the colophon version untouched
}

const changed = summary.newSkills.length > 0 || summary.removedSkills.length > 0 || summary.newCategories.length > 0;

if (changed) {
  writeFileSync(PAGE_PATH, page);
}

let body = "";
if (summary.newSkills.length) {
  body += `### New skills detected (${summary.newSkills.length})\n\n`;
  body += summary.newSkills.map((s) => `- **${s.slug}** (${s.category}) — draft entry appended, needs a plain-language rewrite and a final look at placement.`).join("\n");
  body += "\n\n";
}
if (summary.removedSkills.length) {
  body += `### Skills no longer in the source repo (${summary.removedSkills.length})\n\n`;
  body += summary.removedSkills.map((s) => `- **${s}** — flagged with an HTML comment in place, not deleted. Confirm and remove.`).join("\n");
  body += "\n\n";
}
if (summary.newCategories.length) {
  body += `### New categories in the source repo, not yet on the page (${summary.newCategories.length})\n\n`;
  body += summary.newCategories.map((c) => `- **${c.name}**: ${c.skills.join(", ")} — this needs a new chapter, chip, and roman numeral added by hand, not auto-draftable.`).join("\n");
  body += "\n\n";
}
if (!changed) {
  body = "No drift detected between open-science-skills and docs/skills/index.html.";
}

const githubOutput = process.env.GITHUB_OUTPUT;
if (githubOutput) {
  const delim = "SYNC_EOF";
  writeFileSync(githubOutput, `changed=${changed}\nsummary<<${delim}\n${body}\n${delim}\n`, { flag: "a" });
} else {
  console.log(`changed=${changed}`);
  console.log(body);
}
