/* Deck runtime: keyboard navigation, fragments, build-in animation, print mode,
   notes overlay, and the "draw another card" demo. No dependencies. */
(function () {
  'use strict';
  var slides = Array.prototype.slice.call(document.querySelectorAll('section.slide'));
  var stage = document.getElementById('stage');
  var counter = document.getElementById('counter');
  var notesBox = document.getElementById('notes');
  var navLabel = document.getElementById('nav-label');
  var mainCount = slides.filter(function (s) { return !/^Appendix/.test(s.dataset.slide || ''); }).length;
  var current = 0;
  var printMode = false;

  function fragmentsOf(slide) {
    return Array.prototype.slice.call(slide.querySelectorAll('.fragment'));
  }

  function fit() {
    if (printMode) { stage.style.transform = ''; return; }
    var s = Math.min(window.innerWidth / 1920, window.innerHeight / 1080);
    stage.style.transform = 'translate(-50%,-50%) scale(' + s + ')';
  }

  function show(i, revealAll) {
    i = Math.max(0, Math.min(slides.length - 1, i));
    slides.forEach(function (s, k) {
      var on = k === i;
      s.classList.toggle('active', on);
      if (!on) { s.classList.remove('in'); }
    });
    var slide = slides[i];
    fragmentsOf(slide).forEach(function (f) { f.classList.toggle('visible', !!revealAll); });
    current = i;
    // build-in animation: add .in on the next frame so transitions run
    requestAnimationFrame(function () { requestAnimationFrame(function () { slide.classList.add('in'); }); });
    counter.textContent = slide.dataset.label || ((i + 1) + ' / ' + slides.length);
    if (navLabel) {
      var lab = slide.dataset.slide || ((i + 1) + ' / ' + mainCount);
      var m = lab.match(/^(\d+)\s*\/\s*(\d+)$/);
      navLabel.innerHTML = m ? m[1] + '<span>/</span>' + m[2] : lab;
    }
    if (history.replaceState) history.replaceState(null, '', '#' + (i + 1));
    renderNotes();
  }

  function next() {
    var pending = fragmentsOf(slides[current]).filter(function (f) { return !f.classList.contains('visible'); });
    if (pending.length) { pending[0].classList.add('visible'); return; }
    if (current < slides.length - 1) show(current + 1, false);
  }
  function prev() {
    var shown = fragmentsOf(slides[current]).filter(function (f) { return f.classList.contains('visible'); });
    if (shown.length) { shown[shown.length - 1].classList.remove('visible'); return; }
    if (current > 0) show(current - 1, true);
  }

  function renderNotes() {
    if (!notesBox) return;
    var n = slides[current].querySelector('aside.notes');
    notesBox.innerHTML = n ? n.innerHTML : '<p>No notes for this slide.</p>';
  }

  function setPrint(on) {
    printMode = on;
    document.body.classList.toggle('print-mode', on);
    slides.forEach(function (s) {
      if (on) { s.classList.add('active'); s.classList.add('in'); fragmentsOf(s).forEach(function (f) { f.classList.add('visible'); }); }
    });
    if (!on) show(current, true);
    fit();
  }

  document.addEventListener('keydown', function (e) {
    if (e.metaKey || e.ctrlKey || e.altKey) return;
    switch (e.key) {
      case 'ArrowRight': case 'ArrowDown': case ' ': case 'PageDown': case 'Enter': e.preventDefault(); next(); break;
      case 'ArrowLeft': case 'ArrowUp': case 'PageUp': case 'Backspace': e.preventDefault(); prev(); break;
      case 'Home': show(0, false); break;
      case 'End': show(slides.length - 1, true); break;
      case 'f': case 'F':
        if (document.fullscreenElement) document.exitFullscreen(); else document.documentElement.requestFullscreen(); break;
      case 'n': case 'N': document.body.classList.toggle('show-notes'); break;
      case 'p': case 'P': setPrint(!printMode); break;
      case 'b': case 'B': document.body.classList.toggle('blackout'); break;
      case 'r': case 'R': show(0, false); break;
      default:
        if (/^[1-9]$/.test(e.key)) { show(parseInt(e.key, 10) - 1, false); }
    }
  });

  // click on the right/left 20% of the screen to move (for clickers that emulate mouse)
  document.addEventListener('click', function (e) {
    if (printMode) return;
    if (e.target.closest('button, a, input, select')) return;
    var x = e.clientX / window.innerWidth;
    if (x > 0.8) next(); else if (x < 0.2) prev();
  });

  window.addEventListener('resize', fit);
  window.addEventListener('hashchange', function () {
    var n = parseInt((location.hash || '#1').slice(1), 10);
    if (!isNaN(n) && n - 1 !== current) show(n - 1, false);
  });

  /* "Draw another card": re-randomise the US policy card on the design slide. */
  var CARD = {
    policy: {
      skilled: {
        expand: 'The government announced it will <b>increase the number of skilled worker visas issued each year</b> to address labor shortages.',
        restrict: 'The government announced it will <b>reduce the number of skilled worker visas issued each year</b> to prioritize domestic workers.'
      },
      asylum: {
        expand: 'The government announced it will <b>accept more asylum seekers</b> by expanding processing capacity.',
        restrict: 'The government announced it will <b>accept fewer asylum seekers</b> by raising eligibility standards and strengthening screening.'
      },
      family: {
        expand: 'The government announced it will <b>increase the number of family reunification visas issued each year</b> by raising per-country caps and streamlining petitioning processes.',
        restrict: 'The government announced it will <b>reduce the number of family reunification visas issued each year</b> by lowering per-country caps and tightening petitioning requirements.'
      }
    },
    groups: [
      ['Eastern European', 'Ukraine, Poland, and Romania'],
      ['Central American', 'Honduras, Guatemala, and El Salvador'],
      ['South Asian', 'India, Pakistan, and Bangladesh'],
      ['Sub-Saharan African', 'Nigeria, Ghana, and Kenya'],
      ['East/Southeast Asian', 'Hong Kong, Singapore, and Malaysia']
    ],
    process: [
      ['Lawful baseline', 'The decision was made after <b>congressional debate and public consultation</b>, through the normal legislative process with judicial review.'],
      ['Executive overreach', 'The decision was made by the President through <b>an executive order, bypassing congressional approval</b> and judicial review. The White House argued swift action was needed.'],
      ['External imposition', 'The decision was made <b>following recommendations from the World Economic Forum</b>. Officials said meeting international obligations was necessary to maintain the country’s standing.'],
      ['Procedural neglect', 'The decision was made <b>by skipping the standard review and approval steps</b>, without the normal legislative scrutiny. Officials argued quick action was needed.']
    ],
    application: [
      ['Even-handed', 'Administration officials said the policy would be applied <b>evenly, treating comparable applicants the same</b> under published criteria.'],
      ['Discretionary', 'Administration officials said the policy would be applied <b>case by case at officials’ discretion</b>, not by fixed published criteria.'],
      ['Unequal application', 'Administration officials signaled the policy would be applied <b>unevenly</b>, with some applicants exempted and others in comparable situations strictly enforced, with no stated basis.']
    ],
    imposition: { skilled: 'the World Economic Forum', asylum: 'the UN refugee agency (UNHCR)', family: 'the International Organization for Migration (IOM)' }
  };
  function pick(a) { return a[Math.floor(Math.random() * a.length)]; }
  function drawCard() {
    var area = pick(['skilled', 'asylum', 'family']);
    var dir = pick(['expand', 'restrict']);
    var g = pick(CARD.groups);
    var p = pick(CARD.process);
    var a = pick(CARD.application);
    var pText = p[1];
    if (p[0] === 'External imposition') {
      pText = 'The decision was made <b>following recommendations from ' + CARD.imposition[area] + '</b>. Officials said meeting international obligations was necessary to maintain the country’s standing.';
    }
    var set = function (id, html) { var el = document.getElementById(id); if (el) el.innerHTML = html; };
    set('card-policy', CARD.policy[area][dir]);
    set('card-groups', 'This policy <b>would primarily affect</b> immigrants from <b>' + g[1] + '</b>.');
    set('card-process', pText);
    set('card-application', a[1]);
    set('tag-policy', ({skilled: 'Skilled labor', asylum: 'Asylum', family: 'Family reunification'})[area] + ' · ' + (dir === 'expand' ? 'Expand' : 'Restrict'));
    set('tag-groups', g[0]);
    set('tag-process', p[0]);
    set('tag-application', a[0]);
    var card = document.getElementById('policy-card');
    if (card) { card.classList.remove('flash'); void card.offsetWidth; card.classList.add('flash'); }
  }
  /* navigation pill */
  var on = function (id, fn) { var el = document.getElementById(id); if (el) el.addEventListener('click', function (e) { e.stopPropagation(); fn(); }); };
  on('nav-prev', prev); on('nav-next', next); on('nav-reset', function () { show(0, false); });
  var navTimer;
  function navShow() { document.body.classList.add('nav-visible'); clearTimeout(navTimer); navTimer = setTimeout(function () { document.body.classList.remove('nav-visible'); }, 2200); }
  window.addEventListener('mousemove', navShow, { passive: true });
  var navEl = document.getElementById('nav');
  if (navEl) { navEl.addEventListener('mouseenter', function () { clearTimeout(navTimer); }); navEl.addEventListener('mouseleave', navShow); }

  var btn = document.getElementById('draw-card');
  if (btn) btn.addEventListener('click', function (e) { e.stopPropagation(); drawCard(); });

  // start
  var start = parseInt((location.hash || '#1').slice(1), 10);
  if (isNaN(start)) start = 1;
  fit();
  if (/[?&]print/.test(location.search) || window.matchMedia('print').matches) setPrint(true);
  else {
    var shot = /[?&]shot/.test(location.search);  // ?shot = stills: all fragments visible, no transitions
    if (shot) document.body.classList.add('no-anim');
    show(start - 1, shot);
  }
  window.addEventListener('beforeprint', function () { setPrint(true); });
})();
