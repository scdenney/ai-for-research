// Render scenes.html to PNG frames with the locally installed Google Chrome.
//
//   node render.mjs                         all scenes, durations from durations.json
//   node render.mjs --scenes 4,6            only these scenes
//   node render.mjs --jobs 6                parallel browser pages (default 4)
//   node render.mjs --still 6:24.5:out.png  one frame (scene:time:file; several, comma-separated) and exit
//
// durations.json is an array of seconds per scene (build.sh writes it).
// Frames go to frames/sceneNN/00001.png ... at 30 fps, 1920x1080.

import { chromium } from 'playwright-core';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const FPS = 30;
const CHROME = process.env.CHROME_PATH || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const TARGETS = [12, 30, 15, 30, 25, 40, 15, 8];

const argv = process.argv.slice(2);
const opt = (name, dflt) => {
  const i = argv.indexOf('--' + name);
  return i >= 0 ? argv[i + 1] : dflt;
};

const durFile = path.join(here, opt('durations', 'durations.json'));
const durations = fs.existsSync(durFile) ? JSON.parse(fs.readFileSync(durFile, 'utf8')) : TARGETS;
const jobs = Math.max(1, parseInt(opt('jobs', '4'), 10));
const only = opt('scenes', '')
  .split(',').filter(Boolean).map(Number);
const sceneList = only.length ? only : durations.map((_, i) => i + 1);

const url = pathToFileURL(path.join(here, 'scenes.html')).href +
  '?durations=' + encodeURIComponent(JSON.stringify(durations));

if (!fs.existsSync(CHROME)) {
  console.error('Google Chrome not found at ' + CHROME + ' (set CHROME_PATH).');
  process.exit(1);
}

const browser = await chromium.launch({
  executablePath: CHROME,
  headless: true,
  args: ['--force-color-profile=srgb', '--hide-scrollbars', '--disable-lcd-text'],
});
const context = await browser.newContext({ viewport: { width: 1920, height: 1080 }, deviceScaleFactor: 1 });

async function openPage() {
  const page = await context.newPage();
  await page.goto(url);
  await page.evaluate(() => document.fonts.ready);
  // make sure both families are really loaded before the first frame
  await page.evaluate(() => Promise.all([
    document.fonts.load('44px "EB Garamond"'),
    document.fonts.load('italic 44px "EB Garamond"'),
    document.fonts.load('40px "Noto Sans Mono"'),
  ]));
  return page;
}

async function shoot(page, n, t, file) {
  await page.evaluate(([n, t, d]) => window.setScene(n, t, d), [n, t, durations[n - 1]]);
  await page.screenshot({ path: file, type: 'png' });
}

const still = opt('still', '');
if (still) {
  // several stills may be given, separated by commas
  const page = await openPage();
  for (const spec of still.split(',')) {
    const [n, t, file] = spec.split(':');
    await shoot(page, +n, +t, path.resolve(file));
    console.log('wrote ' + file);
  }
  await browser.close();
  process.exit(0);
}

// build the task list: every frame of every requested scene
const tasks = [];
for (const n of sceneList) {
  const dir = path.join(here, 'frames', 'scene' + String(n).padStart(2, '0'));
  fs.rmSync(dir, { recursive: true, force: true });
  fs.mkdirSync(dir, { recursive: true });
  const count = Math.round(durations[n - 1] * FPS);
  for (let i = 0; i < count; i++) {
    tasks.push({ n, t: i / FPS, file: path.join(dir, String(i + 1).padStart(5, '0') + '.png') });
  }
}

const t0 = Date.now();
let next = 0, done = 0;
async function worker() {
  const page = await openPage();
  while (next < tasks.length) {
    const task = tasks[next++];
    await shoot(page, task.n, task.t, task.file);
    done++;
    if (done % 300 === 0) process.stdout.write(`  ${done}/${tasks.length} frames\n`);
  }
  await page.close();
}
await Promise.all(Array.from({ length: jobs }, worker));
await browser.close();
console.log(`rendered ${tasks.length} frames for scene(s) ${sceneList.join(',')} in ${((Date.now() - t0) / 1000).toFixed(1)} s`);
