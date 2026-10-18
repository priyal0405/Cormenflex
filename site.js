// Mobile menu
(function () {
  var toggle = document.querySelector('.menu-toggle');
  var nav = document.querySelector('.main-nav');
  if (!toggle || !nav) return;
  toggle.addEventListener('click', function () { nav.classList.toggle('open'); });
  nav.querySelectorAll('a').forEach(function (a) {
    a.addEventListener('click', function () { nav.classList.remove('open'); });
  });
})();

// Hero carousel: auto-advance every 6 s, arrows and dots to navigate
(function () {
  var root = document.querySelector('.carousel');
  if (!root) return;
  var slides = root.querySelectorAll('.slide');
  var dots = root.querySelectorAll('.car-dots button');
  var current = 0, timer;
  function show(i) {
    slides[current].classList.remove('active'); dots[current].classList.remove('active');
    current = (i + slides.length) % slides.length;
    slides[current].classList.add('active'); dots[current].classList.add('active');
  }
  function restart() { clearInterval(timer); timer = setInterval(function () { show(current + 1); }, 6000); }
  root.querySelector('.car-prev').addEventListener('click', function () { show(current - 1); restart(); });
  root.querySelector('.car-next').addEventListener('click', function () { show(current + 1); restart(); });
  dots.forEach(function (d, i) { d.addEventListener('click', function () { show(i); restart(); }); });
  restart();
})();
