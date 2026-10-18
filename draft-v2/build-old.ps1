param([string]$Root, [string]$Src)
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Page($rel, $title, $desc, $body, $extraScript = '', $bodyClass = '') {
  $depth = ($rel.Split('/').Count - 1)
  $p = ('../' * $depth)
  $footer = @"
  <footer class="footer">
    <div class="footer-inner">
      <div class="about">
        <h4>Shree Anurag Enterprises</h4>
        <p>Importer &amp; distributor of premium cutting wheels, grinding wheels, abrasives and power-tools under the Marksman, Cormenflex &amp; Tailong brands.</p>
      </div>
      <ul>
        <li><a href="${p}index.html">Home</a></li>
        <li><a href="${p}products.html">Products</a></li>
        <li><a href="${p}about.html">About</a></li>
        <li><a href="${p}contact.html">Contact</a></li>
      </ul>
      <div class="contact">
        <p class="title">Get in touch</p>
        <a href="tel:+19843639653">United States: &#128222; +1 (984) 363-9653</a>
        <a href="tel:+919811654647">India: &#128222; +91 98116 54647</a>
        <a href="tel:+971552901681">Dubai: &#128222; +971 55 290 1681</a>
        <a href="mailto:info@cormenflex.com">&#9993;&#65039; shreeanurag@gmail.com</a>
        <p class="copy">&copy; <span class="year">2026</span> Shree Anurag Enterprises</p>
      </div>
    </div>
  </footer>
"@
  # Single-screen pages (the product lines page) have no footer so nothing sits below the fold
  if ($bodyClass) { $footer = ''; $bodyAttr = " class=`"$bodyClass`"" } else { $bodyAttr = '' }
  $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$title</title>
  <meta name="description" content="$desc">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${p}style.css">
</head>
<body$bodyAttr>
  <nav class="navbar">
    <div class="navbar-inner">
      <a class="brand" href="${p}landing.html">Shree Anurag Enterprises</a>
      <ul>
        <li><a href="${p}products.html">All Products</a></li>
        <li><a href="${p}contact.html">Contact</a></li>
      </ul>
    </div>
  </nav>

  <main>
$($body.Replace('{P}', $p))
  </main>

$footer$extraScript
</body>
</html>
"@
  $out = Join-Path $Root ($rel.Replace('/', '\'))
  New-Item -ItemType Directory -Force (Split-Path $out -Parent) | Out-Null
  [IO.File]::WriteAllText($out, $html, $utf8)
  "built $rel"
}

# ---------- Product catalogue ----------
$products = @(
  @{ slug='abrasives/cut12x2';           name='Marksman Cutting Wheel 12&quot; &times; 2 mm';        img='images/cutting/cut12x2.jpg';            grit='A46TBF'; fb='images/marksman-logo.png' },
  @{ slug='abrasives/cut14x2-5';         name='Marksman Cutting Wheel 14&quot; &times; 2.5 mm';      img='images/cutting/cut14x2-5.jpg';          grit='A46TBF'; fb='images/marksman-logo.png' },
  @{ slug='cormenflex/cut105x1-2';       name='Cormenflex Gold Cutting Wheel 105 mm &times; 1.2 mm'; img='images/cormenflex/cut105x1-2.jpg';      fb='images/cormenflex-logo.png' },
  @{ slug='cormenflex/cut350x2-5';       name='Cormenflex Gold Rail-Cutting Wheel 350 mm &times; 2.5 mm'; img='images/cormenflex/cut350x2-5.jpg'; fb='images/cormenflex-logo.png' },
  @{ slug='cormenflex/grind100x6';       name='Cormenflex DCD Grinding Wheel 100 &times; 6 mm';      img='images/cormenflex/grind100x6.jpg';      fb='images/cormenflex-logo.png' },
  @{ slug='tailong/black-dcd-wheel';     name='Tailong Black DCD Wheels';                           img='images/tailong/black-dcd-wheel.png';    fb='images/tailong-logo.png' },
  @{ slug='tailong/black-parting-wheel'; name='Tailong Black Reinforced Parting Wheels';            img='images/tailong/black-parting-wheel.png'; fb='images/tailong-logo.png' },
  @{ slug='tailong/black-thin-cut';      name='Tailong Black Thin-Cut Wheels';                      img='images/tailong/black-thin-cut.png';     fb='images/tailong-logo.png' },
  @{ slug='tailong/flexible-wheel';      name='Tailong Green Flexible Wheel 105 &times; 2.5 mm';     img='images/tailong/flexible-wheel.png';     fb='images/tailong-logo.png' },
  @{ slug='tailong/green-dcd-wheel';     name='Tailong Green DCD Wheels';                           img='images/tailong/green-dcd-wheel-family.png'; fb='images/tailong-logo.png' },
  @{ slug='tailong/thin-cut-double';     name='Tailong Green Thin-Cut Wheels &bull; Double-Net';    img='images/tailong/thin-cut-double-net.png'; fb='images/tailong-logo.png' },
  @{ slug='tailong/thin-cut-single';     name='Tailong Green Thin-Cut Wheels &bull; Single-Net';    img='images/tailong/thin-cut-single-net.png'; fb='images/tailong-logo.png' }
)

# Use the brand logo where the product photo is missing (also missing on the live site)
function ImgFor($pr) {
  if (Test-Path (Join-Path $Root $pr.img)) { return @($pr.img, '') }
  return @($pr.fb, ' class="fallback"')
}

function Card($pr) {
  $i = ImgFor $pr
  $grit = ''
  if ($pr.grit) { $grit = "`n          <p class=`"grit`">Grit $($pr.grit)</p>" }
  @"
      <a class="product-card" href="{P}products/$($pr.slug).html">
        <div class="thumb"><img src="{P}$($i[0])"$($i[1]) alt="$($pr.name)" loading="lazy"></div>
        <div class="info">
          <h3>$($pr.name)</h3>$grit
        </div>
      </a>
"@
}

function Grid($title, $list) {
  @"
    <section class="container">
      <h1 class="page-title">$title</h1>
      <div class="product-grid">
$(($list | ForEach-Object { Card $_ }) -join "`n")
      </div>
    </section>
"@
}

# ---------- Home ----------
$linesBlock = @'
      <header class="center-head">
        <h2>View our Product Lines</h2>
        <p>Premium abrasives and power-tool solutions for every workshop.</p>
      </header>

      <div class="brand-grid">
        <a class="brand-card cormenflex" href="{P}cormenflex.html">
          <div class="logo-box"><img src="{P}images/cormenflex-logo.png" alt="Cormenflex logo"></div>
          <div class="body"><h3>Cormenflex</h3><p>Click here to see Gold-standard industrial cutting wheels</p></div>
        </a>
        <a class="brand-card marksman" href="{P}marksman.html">
          <div class="logo-box"><img src="{P}images/marksman-logo.png" alt="Marksman logo"></div>
          <div class="body"><h3>Marksman</h3><p>Click here to see Power tools &amp; accessories</p></div>
        </a>
        <a class="brand-card tailong" href="{P}tailong.html">
          <div class="logo-box"><img src="{P}images/tailong-logo.png" alt="Tailong logo"></div>
          <div class="body"><h3>Tailong</h3><p>Click here to see Green-label abrasives &amp; cutting wheels</p></div>
        </a>
      </div>
'@

# Home (index.html): full scrolling page
$homeBody = @"
    <section class="container stack">
$linesBlock
"@ + @'

      <div class="two-col">
        <div>
          <h2 class="section-title">What We Offer</h2>
          <ul class="bullets">
            <li>Tailong Green &amp; Black Series thin-cut wheels</li>
            <li>Cormenflex Gold, Green &amp; Standard grinding wheels</li>
            <li>Vitrified straight, cup, centreless &amp; cylindrical wheels</li>
            <li>Flap discs, Velcro/DA sanding discs &amp; &ldquo;Magic Series&rdquo; abrasives</li>
            <li>Diamond/CBN blades, TCT saws &amp; turbo blades for concrete</li>
          </ul>
          <p class="note">Every batch is ISO-tested in-house and shipped with full after-sales technical support.</p>
        </div>
        <div>
          <h2 class="section-title">Why Choose Us</h2>
          <ul class="bullets">
            <li><strong>Reliability:</strong> Consistent wheel geometry, less vibration and longer spindle life.</li>
            <li><strong>Honest Pricing:</strong> Transparent GST invoices with no hidden freight mark-ups.</li>
            <li><strong>Service with a Human Touch:</strong> Same-day dispatch and technical guidance on call.</li>
            <li><strong>Nation-wide Reach:</strong> Dealer network across every major industrial cluster.</li>
          </ul>
        </div>
      </div>

      <div class="office-card">
        <h2 class="section-title">Visit Our Head Office</h2>
        <p>&ldquo;Paras Bhawan&rdquo;, 3944, Behind G.B. Road, Delhi 110006, India</p>
        <iframe title="Shree Anurag Enterprises on Google Maps" src="https://www.google.com/maps?q=Paras+Bhawan,+3944,+Behind+G.B.+Road,+Delhi+110006&output=embed" loading="lazy" allowfullscreen referrerpolicy="no-referrer-when-downgrade"></iframe>
        <a class="map-link" href="https://maps.app.goo.gl/eKe1omaQVU8JVJix5" target="_blank" rel="noopener noreferrer">Open larger map</a>
      </div>
    </section>
'@

# Product lines (product-lines.html): one screen, no scrolling
$linesBody = @"
    <section class="lines-only">
$linesBlock
    </section>
"@
$slideScript = @'
  <script>
    // Hero slideshow: auto-advance every 5 s, dots jump to a slide
    (function () {
      var slides = document.querySelectorAll('#hero img');
      var dots = document.querySelectorAll('#hero .hero-dots button');
      var current = 0, timer;
      function show(i) {
        slides[current].classList.remove('active'); dots[current].classList.remove('active');
        current = i;
        slides[current].classList.add('active'); dots[current].classList.add('active');
      }
      function start() { timer = setInterval(function () { show((current + 1) % slides.length); }, 5000); }
      dots.forEach(function (d, i) { d.addEventListener('click', function () { clearInterval(timer); show(i); start(); }); });
      start();
    })();
  </script>
'@
Page 'index.html' 'Shree Anurag Enterprises | Cutting Wheels &amp; Power Tools' 'Family-owned importer of Tailong, Cormenflex and Marksman industrial products since 1996.' $homeBody
Page 'product-lines.html' 'Product Lines | Shree Anurag Enterprises' 'Family-owned importer of Tailong, Cormenflex and Marksman industrial products since 1996.' $linesBody '' 'single-screen'

# ---------- Listing pages ----------
$desc = 'Family-owned importer of Tailong, Cormenflex and Marksman industrial products since 1996.'
Page 'products.html'   'All Products | Shree Anurag Enterprises'       $desc (Grid 'All Products' $products)
Page 'cormenflex.html' 'Cormenflex | Shree Anurag Enterprises'         $desc (Grid 'Cormenflex Catalogue' ($products | Where-Object { $_.slug -like 'cormenflex/*' }))
Page 'tailong.html'    'Tailong | Shree Anurag Enterprises'            $desc (Grid 'Tailong Catalogue' ($products | Where-Object { $_.slug -like 'tailong/*' }))
Page 'marksman.html'   'Marksman | Shree Anurag Enterprises'           $desc @'
    <div class="text-page">
      <h1>Marksman</h1>
      <p class="muted">Power tools &amp; accessories. (Product list coming soon.)</p>
    </div>
'@

# ---------- About / Contact ----------
Page 'about.html' 'About | Shree Anurag Enterprises' $desc @'
    <div class="text-page">
      <h1>About Us</h1>
      <p>Founded in 1996 by <strong>Anil Kumar Jain</strong>&mdash;and now run by his son <strong>Anurag Jain</strong>&mdash;Shree Anurag Enterprises has grown from a single-counter shop into one of India&rsquo;s most trusted suppliers of industrial abrasives and power-tool accessories.</p>
      <p>Three generations work together today, blending the personal touch of a neighbourhood business with the professionalism of a national distributor.</p>
      <p>We import and distribute premium cutting wheels, grinding wheels, abrasives and power-tools under the Marksman, Cormenflex &amp; Tailong brands. Every batch is ISO-tested in-house and shipped with full after-sales technical support.</p>
    </div>
'@
Page 'contact.html' 'Contact | Shree Anurag Enterprises' $desc @'
    <div class="text-page">
      <h1>Contact</h1>
      <p class="muted">Same-day dispatch and technical guidance on call.</p>
      <ul class="contact-list">
        <li>United States: <a href="tel:+19843639653">+1 (984) 363-9653</a></li>
        <li>India: <a href="tel:+919811654647">+91 98116 54647</a></li>
        <li>Dubai: <a href="tel:+971552901681">+971 55 290 1681</a></li>
        <li>Email: <a href="mailto:info@cormenflex.com">shreeanurag@gmail.com</a></li>
        <li>Head Office: &ldquo;Paras Bhawan&rdquo;, 3944, Behind G.B. Road, Delhi 110006, India</li>
      </ul>
    </div>
'@

# ---------- Product detail pages (content taken from the downloaded live pages) ----------
foreach ($pr in $products) {
  $file = Join-Path $Src ('p_' + $pr.slug.Replace('/', '_') + '.html')
  $raw = [IO.File]::ReadAllText($file, [Text.Encoding]::UTF8)
  $specs = [regex]::Match($raw, '<table class="text-sm mb-6">(.*?)</table>', 'Singleline').Groups[1].Value
  $specs = [regex]::Replace($specs, '<tr><td[^>]*>slug</td><td>.*?</td></tr>', '')       # internal field, not for customers
  $specs = $specs -replace ' class="[^"]*"', ''
  $prose = [regex]::Match($raw, '<div class="prose[^"]*">(.*?)</div></article>', 'Singleline').Groups[1].Value
  $i = ImgFor $pr
  $body = @"
    <article class="product-detail">
      <h1>$($pr.name)</h1>
      <img class="main-img" src="{P}$($i[0])" alt="$($pr.name)">
      <table class="specs">$specs</table>
      <div class="prose">
$prose
      </div>
    </article>
"@
  $plain = [regex]::Replace($pr.name, '&[a-z]+;', ' ')
  Page "products/$($pr.slug).html" "$($pr.name) | Shree Anurag Enterprises" "$plain - Shree Anurag Enterprises" $body
}
